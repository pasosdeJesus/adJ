# AdJ - Aprendiendo de Jesus

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.8
Fecha de publicación: 1/Abr/2026

Puedes ver novedades respecto a OpenBSD en:
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_8/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puedes ver las diversas versiones publicadas en
<https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
encontrarás:

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.8-amd64.img>
  que es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez
  la descargues puedes escribirla en una USB ubicada en `/dev/sd2c`
  (verifica el dispositivo con `dmesg` y remplaza) con:

       doas dd if=AprendiendoDeJesus-7.8-amd64.img of=/dev/sd2c bs=1M

  Este proceso puede ser demorado, podrás ver el progreso con

      doas pkill -SIGINFO dd

  O si deseas probarla con `qemu` para instalar en un disco `virtual.raw`:

      qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.8-amd64.img -boot menu=on

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.8-amd64.iso>
  que es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.8-amd64/>
  que es directorio con el contenido del DVD instalador apropiado para
  descargar con `rsync` desde un adJ o un OpenBSD ya instalado para
  actualizarlo (ver
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_8/Actualiza.md> )

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.8-extra/>
  es directorio con versiones recientes de paquetes no incluidos en
  distribución oficial (pueden no estar firmados y requerir instalación con
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES RESPECTO A ADJ 7.8 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/78.html>

* Aplicados parches de seguridad hasta el 31.Mar.2026 provenientes de
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: `rge` ahora soporta Realtek RTL8125D (de 2.5G)
     y RTL8127 (de 10G). 
  * USB Ethernet: `ure` ahora soporta RTL8157.
  * Inalámbricas: Mejoras a `qwx`,  `bfwm` y `iwx`
  * CPUs y GPUs: `drm` actualizado al de Linux 6.12.50
  * Otros:  Mejoras a suspender/hibernar. Ya opera orden `ZZZ`
* Mejoras a `vmm`: Puede iniciar máquinas virtuales confidenciales en
  procesadores AMD con SEV-ES.
* Seguridad
  * pledge en más programas
  * LLDP mejorado
  * `libressl` actualizado a 4.2.0
  * Incluye OpenSSH 10.2
* El sistema base incluye mejoras a componentes auditados y mejorados
  como, `llvm 19.1.7`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.40.1`
* El repositorio de paquetes de OpenBSD cuenta con 12651 para amd64


## 3. NOVEDADES RESPECTO A ADJ 7.6 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada
  * `basico_adJ`
    <https://pasosdejesus.org/doc/basico_adJ/index.html>
  * `usuario_adJ`
    <https://pasosdejesus.org/doc/usuario_adJ/index.html>
  * `servidor_adJ`
    <https://pasosdejesus.org/doc/servidor_adJ/index.html>

### 3.2 Paquetes

* Incluye retro-porte de llama-cpp-0.0.5372
* Incluye retro-porte de ruby 3.4.6
* Incluye retro-porte de node 22.20.0 junto con paquetes que requiere 
  libuv 1.51.0p0 y openssl 3.5.4v0
* Incluye portes actualizados para cerrar fallas de curl 8.13,
  geolite2-country-20191224p3, glib2-2.82.5p0,
  libarchive 3.8.1, libssh 0.11.3, libxml 2.13.9, libxslt, 1.1.43p1, 
  mutt 2.2.15v3, nginx 1.26.3, p5-Cpanel-JSON-XS 4.40, php-8.3.26,
  redis 6.2.20, tiff 4.7.1p0


## 4. FE DE ERRATAS

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```

## 5. SI QUIERES AYUDARNOS

* Agradecemos tus oraciones.
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

