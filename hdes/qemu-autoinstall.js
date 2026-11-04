#!/usr/bin/env node
// Autoinstalación desatendida de adJ en QEMU + verificación post-instalación.
//
// Genera un ISO temporal con `set tty com0` en /etc/boot.conf (consola serial),
// crea un disco virtual, arranca QEMU (-machine q35), sirve el archivo de
// respuestas por HTTP, completa la instalación desatendida y, tras reiniciar,
// ejecuta las pruebas de verificación del lanzamiento.
//
// Por qué la consola serial: el instalador de adJ (bsd.rd) usa VGA (pc0) por
// defecto en QEMU; solo pasa a com0 si detecta el hipervisor VMM (vmd). Para
// probar sin pantalla se añade `set tty com0` al /etc/boot.conf del ISO
// temporal (se restaura al terminar). No se necesita QMP ni qemu-mcp.
//
// Uso (como root, porque QEMU necesita memoria y mkhybrid reescribe el
// catálogo de arranque):
//
//     doas node hdes/qemu-autoinstall.js [tamano_disco_en_G]
//
// Requisitos:
//     - Distribución ya construida (directorio 7.9-amd64/).
//     - qemu-system-x86_64, qemu-img y mkhybrid instalados.
//
// Referencia: https://gitlab.com/pasosdeJesus/adJ/-/work_items/21

'use strict';

const fs = require('fs');
const path = require('path');
const { spawn, execSync } = require('child_process');
const http = require('http');

const REPO = '/var/www/adJ-ia/adJ';
const PUERTO_HTTP = 8000;
const MEMORIA = '512M';
const DEADLINE_MS = 3600 * 1000;

const RESPUESTA = `Nombre de la maquina = adJ
Clave para root = adJtest
Llave ssh publica para la cuenta root = nada
Terminal = vt220
Iniciar sshd(8) por defecto = si
Usara X Window = no
Cambiar consola a com0 = si
Cual velocidad deberia com0 usar = 115200
Crear cuenta de usuario = no
Permitie ingreso de root por ssh = si
Zona horaria = America/Bogota
Cual es el disco raiz = sd0
Cifrar el disco raiz con una (p)alabra secreta o un (d)isco llave = no
Usar (T)odo el disco MBR, todo el disco (G)PT o (E)ditar = T
URL de la plantilla de autoparticionado para disklabel = nada
Usar distribucion (A)utolocalizada, (E)ditarla, o (C)rear una distribucion = a
Localizacion = cd0
Nombre(s) de componente(s) = listo
Continuar en todo caso = si
Continuar sin verificacion = si
`;

const VERIFICACION = `echo ===INICIO-VERIF===
uname -a
echo ===SEP===
vmstat -s | grep -i servicio
echo ===SEP===
ls -d /var/log/servicio 2>&1
echo ===SEP===
cat > /tmp/l.c <<'EOF'
#include "locale.h"
#include "stdio.h"
int main() {
  setlocale(LC_ALL, "es_CO.UTF-8");
  printf("%'f", 1000000.2);
  return 0;
}
EOF
cc -o /tmp/l /tmp/l.c && /tmp/l
echo
echo ===FIN-VERIF===
`;

function fail(msg) {
  console.error(`[FAIL] ${msg}`);
  process.exit(1);
}

function sh(cmd) {
  execSync(cmd, { stdio: 'inherit' });
}

function leerVersion() {
  const v = { V: '7.9', VESP: '', ARQ: 'amd64' };
  const contenido = fs.readFileSync(path.join(REPO, 'ver.sh'), 'utf8');
  for (const linea of contenido.split('\n')) {
    const m = linea.trim().match(/^(V|VESP|ARQ)="?([^"]*)"?$/);
    if (m && m[1] in v) v[m[1]] = m[2];
  }
  return [v.V, v.VESP, v.ARQ];
}

function construirIsoSerial(isoSalida, dirBuild) {
  const bootConf = path.join(dirBuild, 'etc', 'boot.conf');
  const respaldo = bootConf + '.orig-autoinstall';
  fs.copyFileSync(bootConf, respaldo);
  fs.writeFileSync(bootConf, 'set tty com0\necho adJ\nboot bsd.rd\n');
  try {
    sh(`cd ${dirBuild} && mkhybrid -r -e eficdboot -b cdbr ` +
       `-c boot.catalog -l -f -T -J -o ${isoSalida} .`);
  } finally {
    fs.copyFileSync(respaldo, bootConf);
    fs.unlinkSync(respaldo);
  }
  console.log(`[OK] ISO serial: ${isoSalida}`);
}

function main() {
  const tamano = process.argv[2] || '30';
  if (typeof process.getuid === 'function' && process.getuid() !== 0) {
    fail('Ejecutar como root: doas node hdes/qemu-autoinstall.js');
  }

  const [V, VESP, ARQ] = leerVersion();
  const dirBuild = path.join(REPO, `${V}${VESP}-${ARQ}`);
  const isoSerial = `/tmp/AprendiendoDeJesus-${V}${VESP}-${ARQ}-serial.iso`;
  const disco = path.join(REPO, 'virtual.raw');
  if (!fs.existsSync(dirBuild)) {
    fail(`No existe ${dirBuild}`);
  }

  construirIsoSerial(isoSerial, dirBuild);
  fs.writeFileSync('/tmp/install.conf', RESPUESTA);

  if (fs.existsSync(disco)) fs.unlinkSync(disco);
  sh(`qemu-img create -f raw ${disco} ${tamano}G`);
  console.log(`[OK] Disco ${disco} (${tamano}G)`);

  const httpd = http.createServer((req, res) => {
    const filePath = path.join('/tmp', path.basename(req.url || ''));
    fs.readFile(filePath, (err, data) => {
      if (err) { res.writeHead(404); res.end('Not found'); return; }
      res.writeHead(200, { 'Content-Type': 'application/octet-stream' });
      res.end(data);
    });
  });
  httpd.listen(PUERTO_HTTP);

  const args = ['-machine', 'q35', '-m', MEMORIA,
    '-boot', 'order=cd', '-cdrom', isoSerial,
    '-drive', `file=${disco},format=raw`,
    '-net', 'nic,model=e1000', '-net', 'user',
    '-nographic'];
  const qemu = spawn('qemu-system-x86_64', args,
    { stdio: ['pipe', 'pipe', 'pipe'] });

  let buf = '';
  let etapa = 0;
  let resultado = '';
  let terminado = false;

  const send = (s) => qemu.stdin.write(s);

  const temporizador = setTimeout(() => {
    if (!terminado) {
      console.error('\n[FAIL] Tiempo agotado (sin verificación).');
      qemu.kill();
    }
  }, DEADLINE_MS);

  qemu.stdout.on('data', (d) => {
    const texto = d.toString('latin1');
    process.stdout.write(texto);
    buf += texto;
    const low = buf.toLowerCase();
    if (etapa === 0 && (low.includes('utoinstall') || low.includes('utoinstal'))) {
      send('a\r'); etapa = 1; buf = '';
    } else if (etapa === 1 &&
               (low.includes('archivo de respuestas') || low.includes('response file'))) {
      send(`http://10.0.2.2:${PUERTO_HTTP}/install.conf\r`); etapa = 2; buf = '';
    } else if (etapa === 2 && low.includes('login:')) {
      send('root\r'); etapa = 3; buf = '';
    } else if (etapa === 3 && low.includes('password:')) {
      send('adJtest\r'); etapa = 4; buf = '';
    } else if (etapa === 4 && low.includes('#')) {
      send(VERIFICACION); etapa = 5; buf = '';
    } else if (etapa === 5 && low.includes('===FIN-VERIF===')) {
      resultado = buf;
      terminado = true;
      clearTimeout(temporizador);
      qemu.kill();
    }
  });

  qemu.stderr.on('data', (d) => {
    process.stderr.write(d.toString('latin1'));
  });

  qemu.on('exit', () => {
    httpd.close();
    if (!resultado) {
      fail('No se alcanzó la verificación (revisar salida).');
    }
    const t = resultado.split('===INICIO-VERIF===')[1] || '';
    const bloques = t.split('===FIN-VERIF===')[0].split('===SEP===');
    const uname = (bloques[0] || '').trim();
    const servicio = (bloques[1] || '').trim();
    const log = (bloques[2] || '').trim();
    const libc = (bloques[3] || '').trim();

    console.log('\n=== RESULTADO VERIFICACIÓN ===');
    console.log('uname:', uname);
    console.log('servicio:', servicio.slice(0, 120));
    console.log('/var/log/servicio:', log);
    console.log('libc:', libc);

    let ok = true;
    if (!uname.includes('APRENDIENDODEJESUS')) {
      console.log('[FAIL] uname no reporta APRENDIENDODEJESUS'); ok = false;
    }
    if (!servicio.toLowerCase().includes('servicio')) {
      console.log('[FAIL] vmstat no muestra "servicio"'); ok = false;
    }
    if (!log.includes('/var/log/servicio')) {
      console.log('[FAIL] No existe /var/log/servicio'); ok = false;
    }
    if (libc !== '1.000.000,200000') {
      console.log(`[WARN] libc locale: esperado "1.000.000,200000", salió "${libc}"`);
      ok = false;
    }

    console.log(ok ? '[OK] Verificación satisfactoria' : '[FAIL] Verificación falló');
    process.exit(ok ? 0 : 1);
  });
}

main();
