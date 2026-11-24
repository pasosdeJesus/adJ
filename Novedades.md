# AdJ - Aprendiendo de Jesus

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 8.0b1
Fecha de publicación: 10/Jun/2026

Puedes ver novedades respecto a OpenBSD en:
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_9/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puedes ver las diversas versiones publicadas en
<https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
encontrarás:

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-8.0b1-amd64.img>
  que es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez
  la descargues puedes escribirla en una USB ubicada en `/dev/sd2c`
  (verifica el dispositivo con `dmesg` y remplaza) con:

       doas dd if=AprendiendoDeJesus-8.0b1-amd64.img of=/dev/sd2c bs=1M

  Este proceso puede ser demorado, podrás ver el progreso con

      doas pkill -SIGINFO dd

  O si deseas probarla con `qemu` para instalar en un disco `virtual.raw`:

      qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-8.0b1-amd64.img -boot menu=on

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-8.0b1-amd64.iso>
  que es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/8.0b1-amd64/>
  que es directorio con el contenido del DVD instalador apropiado para
  descargar con `rsync` desde un adJ o un OpenBSD ya instalado para
  actualizarlo (ver
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_9/Actualiza.md> )

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/8.0b1-extra/>
  es directorio con versiones recientes de paquetes no incluidos en
  distribución oficial (pueden no estar firmados y requerir instalación con
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES PROVENIENTES DE OPENBSD 8.0

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/80.html>

* El sistema base incluye mejoras a componentes auditados y mejorados.
* Aplicados parches de seguridad de OpenBSD hasta el 20.Oct.2026 (fecha de
  la versión 8.0; las correcciones posteriores se acumulan en 8.0-stable).
* **`amd64`: espacio de direcciones virtuales del kernel ampliado de 4G a
  512G**; el mapa directo de `pmap(9)` se ubica en una dirección aleatoria y
  el cifrado de swap usa instrucciones AES de la CPU.
* `arm64`: soporte de hibernación, cifrado de swap con AES y bounce buffers.
* `riscv64`: detección de extensiones vía `AT_HWCAP`, soporte de la extensión
  vectorial «V» y de la arquitectura avanzada de interrupciones
  (`imsic(4)`, `aplic(4)`).
* `sparc64` pasa a la cadena de herramientas LLVM; se retira la arquitectura
  `loongson`.
* Controladores ampliados o mejorados
  * `drm(4)` actualizado a Linux 6.18.53; soporte de Intel Arc A-Series
    (DG2/Alchemist) en `inteldrm(4)`.
  * Red: Panther Lake y Wildcat Lake en `em(4)`, Intel E610 en `ix(4)`.
  * Inalámbricas `qwx(4)`/`qwz(4)`: 802.11n con canales de 40MHz, QoS,
    correcciones de firmware y de itinerancia.
  * `vmd(8)`/`vmm(4)`: hasta 64 VCPUs por VM, x2apic, virtio con MSI/MSI-X y
    descarga de checksum.
* Seguridad
  * `libressl` 4.4.0: X25519MLKEM768 como grupo preferido en TLS 1.3,
    correcciones en CMS, PKCS#7 y validación de cadenas X.509.
  * OpenSSH 10.6: se deshabilita el codificador LZ77 de `ssh(1)` y se
    refuerzan `sshd(8)`, `ssh-agent(1)` y `scp(1)`.
  * `expat` 2.8.4 (CVE-2026-66046, CVE-2026-76641, CVE-2026-76957) y
    correcciones en `perl(1)` (Storable y `pack`/`unpack`).
  * `httpd(8)` y `relayd(8)` usan el conjunto de cifrados `secure` y rechazan
    CL.TE y `obs-fold` (RFC 9112).
* Herramientas de paquetes
  * **`pkg_add(1)` ya no busca paquetes en el directorio actual**: toda ruta
    debe ser explícita o venir de `PKG_PATH`.
  * `fw_update(8)` valida la firma de `SHA256.sig` local y limita el tamaño de
    las descargas.
* Se actualizan `LLVM/Clang 22.1.6`, `Xenocara` (X.Org 7.7, xserver
  21.1.24), `GCC 16.1.0` y `perl 5.42.3`.
* El repositorio de paquetes de OpenBSD cuenta con 13060 paquetes para amd64.

## 3. NOVEDADES RESPECTO A ADJ 7.9 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Sistema Base

* Parches de locale y xlocale reapuntados a las fuentes de OpenBSD 8.0.
* 3 fallas en parches detectadas por modelo de IA, Gemini, corregidas:
  - Evita desbordamiento de buffer con locales alterados
  - Arreglada fuga de memoria en xlocale al cambiar locales
  - Arreglada fuga de memoria al cargar locales monetarios y numéricos
* Corregida condición de carrera en la prueba de regresión de xlocale
  (`uselocale`) que causaba un timeout al sincronizar hilos.

### 3.2 Instalador y documentación

* Documentación actualizada
  * `basico_adJ`
    <https://pasosdejesus.org/doc/basico_adJ/index.html>
  * `usuario_adJ`
    <https://pasosdejesus.org/doc/usuario_adJ/index.html> 
    (Vea la sección sobre Gestión de Energía que opera
     en OpenBSD/adJ 8.0).
  * `servidor_adJ`
    <https://pasosdejesus.org/doc/servidor_adJ/index.html>
* Documentado que los archivos `.xlsx` se abren con LibreOffice al
  descargarlos desde Chromium.
* Nuevos scripts para preparar máquinas virtuales de desarrollo con IA
  (vmd + NFS + crush), en `/usr/local/adJ/`:
  * `prep-vm-ia-anfitrion` — crea la VM en el anfitrión, exporta `/var/www`
    por NFS y opcionalmente autoinstala adJ desde la ISO.
  * `prep-vm-ia-invitado` — configura una VM adJ ya instalada (Go, Crush,
    montaje NFS, timecounter, ntpd).

### 3.3 Paquetes

* Incluye porte de ruby 4.0.7 con `doas gem update --system` habilitado
* Incluye evangelios-0.9.16 que agrega traducción de 1 Pedro y hace
  arreglos en varios libros tras retroalimentación de varios modelos de IA
  cuidadosamente analizada (DeepSeek y Gemini). El directorio
  `evangelios_dp` del CD contiene lo mismo que este paquete.
* Incluye porte de sivel-2.2.1
* Incluye porte de solidity (`solc`), el compilador de contratos
  Solidity para Ethereum/EVM, compilado de forma nativa en C++23 (sin Rust
  ni WASM). Facilita compilar contratos inteligentes en adJ/OpenBSD sin
  recurrir a binarios externos o hacks.
* Incluye porte de `m` (`@pasosdejesus/m`), el CLI para crear y
  gestionar proyectos Next.js y contratos Solidity (sin Hardhat), con la
  extensión `mpdj` (`ai:*`, `eng:credentials:*`) y las dependencias
  opcionales (`contract-test` y `edr`) empaquetadas. Se instala
  `/usr/local/bin/m`.
* Actualizados postgresql a 18.6 y php a 8.5.11 desde la rama estable de
  OpenBSD 8.0.
* Actualizados por fallas de seguridad críticas (22-23.Oct.2026):
  php-8.5.12 (CVE-2026-109618 y CVE-2026-109619), node-22.23.4,
  brotli-1.2.1 y py3-brotli-1.2.1 (CVE-2026-111497),
  python-3.13.17 (retira la CA comprometida eMudhra/emSign),
  firefox-esr-140.17.0, openssl-3.5.9, rsync-3.5.1,
  cups-2.4.19 y vim-9.2.1125.
* Incluye portes actualizados para cerrar fallas de curl 8.19,
  enchant2-2.8.16, ffmpeg-8.0.3v1, libexif-0.6.26, libffi-3.5.2p0,
  libunbound-1.26.0, mpg123-1.33.7, nghttp2-1.68.1, openldap-client-2.6.15,
  png-1.6.59, py3-asn1-0.6.3v0, redis 6.2.20, sqlite3-3.50.7p0


### 3.4 Novedades de adJ 7.9 y 7.9p1

* **Datos abiertos de Noche y Niebla al día.** El directorio
  `sivel/` del medio de instalación ahora incluye
  `nocheyniebla1999-2026-xrlt.tar.gz` con **48 187 relatos** del Banco de
  Datos de Derechos Humanos del CINEP, generados a partir de la base
  vigente en https://www.nocheyniebla.org/base
* **Nuevo porte de solidity 0.8.38** (`solc`), con C++23 y la suite de
  pruebas habilitada: ahora incluye pruebas unitarias, de sintaxis y del
  verificador SMT contra el `z3` empaquetado (`math/z3` 4.16.0). Cuatro
  pruebas cuyas expectativas se grabaron con z3 4.13.3 quedan omitidas en
  OpenBSD mediante `SMTIgnoreOS: openbsd`, y `z3` pasa a ser dependencia de
  ejecución y de pruebas (el verificador lo invoca como proceso externo,
  no enlaza `libz3`).
* **Porte de `m` actualizado a 0.37.20** (`@pasosdejesus/m`), reempaquetado
  como único tarball `-full` generado por `make publish` de `m`; el porte ya
  no necesita red durante la compilación.
* **Nuevas llaves `signify` para 8.0** (`adJ-80-base.pub` y
  `adJ-80-pkg.pub`), generadas y respaldadas por el operador.
* **Scripts convertidos de latin1 a UTF-8** (`creaimg.sh`, `creaiso.sh`,
  `servicio-kernel.sh`, `verificadep.sh`, `xenocaraadJ.sh`, `varcorreo.sh`,
  `tminiroot/install-en`) y corregidas seis referencias obsoletas en
  `inst-adJ.sh` (servicio PHP, listas de paquetes inexistentes, plantilla
  `xorg.conf.pordefecto` y bloque muerto de Pidgin).
* **`hdes/creaimg.sh` acepta el directorio de trabajo** como parámetro o en
  `DIRIMG` (por omisión `/var/www/adJ-ia/adJ`), para no llenar el disco local
  al crear la imagen USB.
* **Paquetes recompilados por fallas de seguridad de OpenBSD hasta
  el 20.Oct.2026.**

## 4. VERIFICACIÓN DE LA DESCARGA

Antes de usar cualquier imagen, verifique su integridad con `signify`:

```
doas signify -C -p /etc/signify/adJ-80-base.pub -x SHA256.sig
```

El comando debe reportar `Signature Verified` para cada archivo. Si falla,
no use la descarga: vuelva a descargarla.

## 5. FE DE ERRATAS

Sin erratas conocidas en 7.9p1.


- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```

## 6. SI QUIERES AYUDARNOS

* Agradecemos tus oraciones.
* Si prefieres ayudar de otra forma, también puedes: dar una estrella,
  patrocinar, comprar una USB, mejorar la documentación o traducir.
* Si tienes una cuenta en gitlab o en github por favor ponle una estrella al
  repositorio en [gitlab](https://gitlab.com/pasosdeJesus/adJ) o
  en [github](https://github.com/pasosdeJesus/adJ/)
* Te invitamos a patrocinar nuestro trabajo empleando el botón
  Patrocinar (__Sponsor__) de <https://github.com/pasosdeJesus/adJ/>
* También puedes comprar una USB de instalación con la versión más reciente de
  adJ o contratar alguno de los servicios de Pasos de Jesús
  desde <https://www.pasosdeJesus.org>
* Agradecemos tu ayuda mejorando este sitio, la documentación
  para usuario final y la documentación técnica.
* Agradecemos tu ayuda traduciendo a español páginas del
  manual desde: <https://hosted.weblate.org/projects/adj/>
* Agradecemos tu ayuda en el desarrollo de fuentes abiertas que llevamos
  en <https://gitlab.com/pasosdeJesus/adJ/>

