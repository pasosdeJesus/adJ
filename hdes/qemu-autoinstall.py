#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Autoinstalación desatendida de adJ en QEMU + verificación post-instalación.

Genera un ISO temporal con `set tty com0` en /etc/boot.conf (consola serial),
crea un disco virtual, arranca QEMU (-machine q35), sirve el archivo de
respuestas por HTTP, completa la instalación desatendida y, tras reiniciar,
ejecuta las pruebas de verificación del lanzamiento.

Por qué la consola serial: el instalador de adJ (bsd.rd) usa VGA (pc0) por
defecto en QEMU; solo pasa a com0 si detecta el hipervisor VMM (vmd). Para
probar sin pantalla se añade `set tty com0` al /etc/boot.conf del ISO
temporal (se restaura al terminar). No se necesita QMP ni qemu-mcp: la
consola serial basta desde que arranca el instalador.

Uso (como root, porque QEMU necesita memoria y mkhybrid reescribe el
catálogo de arranque):

    doas python3 hdes/qemu-autoinstall.py [tamano_disco_en_G]

Requisitos:
    - Distribución ya construida (directorio 7.9-amd64/).
    - qemu-system-x86_64, qemu-img y mkhybrid instalados.

Referencia: https://gitlab.com/pasosdeJesus/adJ/-/work_items/21
"""

import os
import re
import shutil
import socketserver
import subprocess
import sys
import threading
import time
import select
import http.server
import pty

REPO = '/var/www/adJ-ia/adJ'
PUERTO_HTTP = 8000
MEMORIA = '512M'


def leer_version():
    """Lee V, VESP y ARQ desde ver.sh."""
    v = {'V': '7.9', 'VESP': '', 'ARQ': 'amd64'}
    with open(os.path.join(REPO, 'ver.sh')) as f:
        for linea in f:
            m = re.match(r'^(V|VESP|ARQ)=("?)([^"]*)\2\s*$', linea.strip())
            if m and m.group(1) in v:
                v[m.group(1)] = m.group(3)
    return v['V'], v['VESP'], v['ARQ']


def sh(cmd):
    """Ejecuta una orden y aborta si falla."""
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0:
        sys.exit(f"[FAIL] {cmd}")


def construir_iso_serial(iso_salida, dir_build):
    """Respaldado de boot.conf, añade set tty com0 y regenera un ISO temporal."""
    boot_conf = os.path.join(dir_build, 'etc', 'boot.conf')
    respaldo = boot_conf + '.orig-autoinstall'
    shutil.copy2(boot_conf, respaldo)
    with open(boot_conf, 'w') as f:
        f.write('set tty com0\necho adJ\nboot bsd.rd\n')
    try:
        sh(f"cd {dir_build} && mkhybrid -r -e eficdboot -b cdbr "
           f"-c boot.catalog -l -f -T -J -o {iso_salida} .")
    finally:
        shutil.copy2(respaldo, boot_conf)
        os.remove(respaldo)
    print(f"[OK] ISO serial: {iso_salida}")


RESPUESTA = """Nombre de la maquina = adJ
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
"""

VERIFICACION = """echo ===INICIO-VERIF===
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
"""


class HTTP(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *a):
        pass


def main():
    tamano = sys.argv[1] if len(sys.argv) > 1 else '30'
    if os.geteuid() != 0:
        sys.exit("[FAIL] Ejecutar como root: doas python3 hdes/qemu-autoinstall.py")

    V, VESP, ARQ = leer_version()
    dir_build = os.path.join(REPO, f'{V}{VESP}-{ARQ}')
    iso_serial = f'/tmp/AprendiendoDeJesus-{V}{VESP}-{ARQ}-serial.iso'
    disco = os.path.join(REPO, 'virtual.raw')
    if not os.path.isdir(dir_build):
        sys.exit(f"[FAIL] No existe {dir_build}")

    construir_iso_serial(iso_serial, dir_build)

    with open('/tmp/install.conf', 'w') as f:
        f.write(RESPUESTA)

    if os.path.exists(disco):
        os.remove(disco)
    sh(f"qemu-img create -f raw {disco} {tamano}G")
    print(f"[OK] Disco {disco} ({tamano}G)")

    os.chdir('/tmp')
    httpd = socketserver.TCPServer(('', PUERTO_HTTP), HTTP)
    threading.Thread(target=httpd.serve_forever, daemon=True).start()

    master, slave = pty.openpty()
    cmd = ['qemu-system-x86_64', '-machine', 'q35', '-m', MEMORIA,
           '-boot', 'order=cd', '-cdrom', iso_serial,
           '-drive', f'file={disco},format=raw',
           '-net', 'nic,model=e1000', '-net', 'user',
           '-nographic']
    p = subprocess.Popen(cmd, stdin=slave, stdout=slave, stderr=slave,
                         close_fds=True)
    os.close(slave)

    def send(s):
        os.write(master, s.encode())

    buf = b''
    etapa = 0
    resultado = ''
    deadline = time.time() + 3600
    try:
        while time.time() < deadline:
            r, _, _ = select.select([master], [], [], 2)
            if not r:
                continue
            try:
                d = os.read(master, 65536)
            except OSError:
                break
            if not d:
                break
            sys.stdout.write(d.decode('latin-1', 'replace'))
            sys.stdout.flush()
            buf += d
            low = buf.lower()
            if etapa == 0 and (b'utoinstall' in low or b'utoinstal' in low):
                send('a\r'); etapa = 1; buf = b''
            elif etapa == 1 and (b'archivo de respuestas' in low or
                                 b'response file' in low):
                send(f'http://10.0.2.2:{PUERTO_HTTP}/install.conf\r')
                etapa = 2; buf = b''
            elif etapa == 2 and b'login:' in low:
                send('root\r'); etapa = 3; buf = b''
            elif etapa == 3 and b'password:' in low:
                send('adJtest\r'); etapa = 4; buf = b''
            elif etapa == 4 and b'#' in low:
                send(VERIFICACION)
                etapa = 5; buf = b''
            elif etapa == 5 and b'===FIN-VERIF===' in low:
                resultado = buf.decode('latin-1', 'replace')
                break
    finally:
        p.terminate()
        try:
            p.wait(timeout=5)
        except Exception:
            p.kill()
        httpd.shutdown()

    if not resultado:
        print('\n[FAIL] No se alcanzó la verificación (revisar salida).')
        sys.exit(1)

    txt = resultado.split('===INICIO-VERIF===')[-1].split('===FIN-VERIF===')[0]
    bloques = txt.split('===SEP===')
    uname = bloques[0].strip() if len(bloques) > 0 else ''
    servicio = bloques[1].strip() if len(bloques) > 1 else ''
    log = bloques[2].strip() if len(bloques) > 2 else ''
    libc = bloques[3].strip() if len(bloques) > 3 else ''

    print('\n=== RESULTADO VERIFICACIÓN ===')
    print('uname:', uname)
    print('servicio:', servicio[:120])
    print('/var/log/servicio:', log)
    print('libc:', libc)

    ok = True
    if 'APRENDIENDODEJESUS' not in uname:
        print('[FAIL] uname no reporta APRENDIENDODEJESUS'); ok = False
    if 'servicio' not in servicio.lower():
        print('[FAIL] vmstat no muestra "servicio"'); ok = False
    if '/var/log/servicio' not in log:
        print('[FAIL] No existe /var/log/servicio'); ok = False
    if libc != '1.000.000,200000':
        print(f'[WARN] libc locale: esperado "1.000.000,200000", salió {libc!r}'); ok = False

    print('[OK] Verificación satisfactoria' if ok else '[FAIL] Verificación falló')
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
