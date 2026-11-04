# AdJ - Aprendiendo de Jesus

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.9
Fecha de publicación: 3/Nov/2026

Puedes ver novedades respecto a OpenBSD en:
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_9/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puedes ver las diversas versiones publicadas en
<https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
encontrarás:

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.9-amd64.img>
  que es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez
  la descargues puedes escribirla en una USB ubicada en `/dev/sd2c`
  (verifica el dispositivo con `dmesg` y remplaza) con:

       doas dd if=AprendiendoDeJesus-7.9-amd64.img of=/dev/sd2c bs=1M

  Este proceso puede ser demorado, podrás ver el progreso con

      doas pkill -SIGINFO dd

  O si deseas probarla con `qemu` para instalar en un disco `virtual.raw`:

      qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.9-amd64.img -boot menu=on

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.9-amd64.iso>
  que es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.9-amd64/>
  que es directorio con el contenido del DVD instalador apropiado para
  descargar con `rsync` desde un adJ o un OpenBSD ya instalado para
  actualizarlo (ver
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_9/Actualiza.md> )

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.9-extra/>
  es directorio con versiones recientes de paquetes no incluidos en
  distribución oficial (pueden no estar firmados y requerir instalación con
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES PROVENIENTES DE OPENBSD 7.9

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/79.html>


* El sistema base incluye mejoras a componentes auditados y mejorados
* Aplicados parches de seguridad de OpenBSD hasta el 23.Oct.2026.
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: `rge` ahora soporta Realtek RTL8126. `bnxt`
    ahora soporta dispositivos BCM575xx
  * Inalámbricas: Soporte básico de 802.11ax (WiFi 6). Mejoras a `iwx`
  * CPUs y GPUs: `drm` actualizado al de Linux 6.18.22. Diversas mejoras
    para amdgpu. MAXCPUS aumentado a 255 en amd64
  * Suspender/hibernar: hibernación diferida (`machdep.hibernatedelay`) para
    no agotar la batería, y gestión de CPUs híbridas (`hw.blockcpu`)
* Seguridad
  * pledge en más programas
  * `libressl` actualizado a 4.3.0 con intercambio de claves híbrido
    post-cuántico ML-KEM768 + X25519 (como recomienda D. J. Bernstein y el
    RFC 10024 -- TLS 1.3)
  * Incluye OpenSSH 10.3
  * Redes: IPv6 autoconf (SLAAC) habilitado por defecto
* Se actualizan `llvm 19.1.7`, `Xenocara` (basado en `Xorg` 7.7) y
  `perl 5.42.2`.
* El repositorio de paquetes de OpenBSD cuenta con 13044 paquetes para
  amd64.


## 3. NOVEDADES RESPECTO A ADJ 7.8 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Sistema Base

* Parches de locale y xlocale actualizados a fuentes de OpenBSD 7.9.
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
     en OpenBSD/adJ 7.9).
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
* Incluye porte de solidity-0.8.37 (`solc`), el compilador de contratos
  Solidity para Ethereum/EVM, compilado de forma nativa en C++20 (sin Rust
  ni WASM). Facilita compilar contratos inteligentes en adJ/OpenBSD sin
  recurrir a binarios externos o hacks.
* Incluye porte de `m` (`@pasosdejesus/m` 0.37.8), el CLI para crear y
  gestionar proyectos Next.js y contratos Solidity (sin Hardhat), con la
  extensión `mpdj` (`ai:*`, `eng:credentials:*`) y las dependencias
  opcionales (`contract-test` y `edr`) empaquetadas. Se instala
  `/usr/local/bin/m`.
* Actualizados postgresql a 18.6 y php a 8.5.12 desde la rama estable de 
  OpenBSD 7.9.
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


## 4. VERIFICACIÓN DE LA DESCARGA

Antes de usar cualquier imagen, verifique su integridad con `signify`:

```
doas signify -C -p /etc/signify/adJ-79-base.pub -x SHA256.sig
```

El comando debe reportar `Signature Verified` para cada archivo. Si falla,
no use la descarga: vuelva a descargarla.

## 5. FE DE ERRATAS

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

