# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.2
Fecha de publicación: 17/Ene/2022

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_2/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
  encontrará:

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-7.2-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/7.2-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync desde un adJ o un OpenBSD ya instalado para actualizarlo (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_2/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.2-extra/> 
  es directorio con versiones recientes de paquetes no incluidos en 
  distribución oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.2-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-7.2-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.2-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 7.2 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/71.html> 

* Aplicados parches de seguridad hasta el 17.Ene.2023 provenientes de 
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: Mejorados `uaq` (USB-Ethernet), `reg`, `mvneta`, 
    `igc`, `bnxt` e `ix`.
  * Tarjetas inalámbricas: Mejorados `iwx`, `iwm`, `bwfm`, `urtwn`
* Mejoras a herramientas de Red
  * Mejorado openrsync, pf, bgpd, rpki-client, snmpd, ldapd, ospfd, tcpdump,
    dhclient, dig, resolvd, httpd, relayd y ftp.
* Seguridad
  * Separación de privilegios en más programas
  * Mejorada seguridad de ypldap, dhcpleased, mountd, nfsd, pflogd, 
    resolvd, nwind entre otros.
  * libressl actualizado a la versión 3.6.0 que incluye soporte
    experimental para BoringSSL QUIC API.
  * Incluye OpenSSH 9.1
* Otros
  * Mejoras a candados en diversas partes del sistema base.
  * Mejoas a tmux y mandoc

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm 13.0.0`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.32.1` 
* El repositorio de paquetes de OpenBSD cuenta con 11451 para amd64


### 2.2 Paquetes 

* Para cerrar fallas se usan las versiones más recientes preparadas
  por OpenBSD 7.2 de: `curl`, `firefox-esr`, `openssl`, `php`, `postgis`,
  `postgresql`, `samba`, `webkitgtk4`,
* Para aprovechar el xlocale extendido de adJ se han recompilado
  `vlc`, `glib2` y `libunistring`.
* Por el aumento en número de descriptores de archivos tuvimos que
  recompilar: `unzip`, `bison`, `m4`, `unzip`, `python`, `ruby`,
  `gettext-tools`,  `gmake`, `ImageMagick`, 
  `texlive_base` y `texlive_texmf-minimal`
* Algunos paquetes típicos y su versión: `dovecot 2.3.19.1p0v0`,
  `chromium 105.0.5195.125`, `firefox-esr-102.3.0`, 
  `libreoffice 7.4.1.2v0`,
  `nginx 1.22.0p0`, `mariadb 10.9.3v1`,
  `python 3.9.15p0`, `neovim 0.7.2`, `zsh 5.9`


## 3. NOVEDADES RESPECTO A ADJ 7.2 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada 
	* `basico_adJ`: 
    <http://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ` 
    <http://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`: 
    <http://pasosdejesus.github.io/servidor_adJ>

### 3.2 Paquetes

* Incluye evangelios_dp 0.9.7 con traducción y marcado Strong de
  1 Corintios.
* Como herramientas para el blockchain TON (The Open Network), además 
  del paquete `ton` ahora incluimos el paquete `ton-toncli`. El primero 
  consta de las herramientas estándar, el segundo se trata de las mismas 
  herramientas en rutas diferentes pues emplean una máquina virtual TON 
  ampliada para facilitar depuración y el desarrollo de contratos con 
  `toncli`. Estos paquetes incluyen parches que propusimos para mejorar
  portabilidad de TON a adJ y que fueron aceptados por los desarrolladores
  de TON. Puede ver la documentación actualizada en
  <http://pasosdejesus.github.io/usuario_adJ/conf-programas.html#ton>
* Hemos retroportado ruby de OpenBSD-current pues incluye Ruby 3.2 que
  trae un nuevo compilador JIT que podría aumentar la velocidad de
  aplicaciones rails, ver
  <https://www.ruby-lang.org/es/news/2022/12/25/ruby-3-2-0-released/>
* Hemos retroportado node 18.12.1 (publicado en Nov.2022) de OpenBSD-current 
  para tener el entorno de desarrollo estable de larga duración más 
  actualizado y sin fallas de seguridad conocidas hasta el momento. Ver
  <https://github.com/nodejs/release#release-schedule>
* Eliminamos python 2 y paquetes para este.
* Chromium recompilado con llave de Pasos de Jesús.  Ya permite autenticar
  y usar sitios como <https://drive.google.com>  --si tiene problemas para
  autenticarse intente desde un nuevo perfil (obligatorio por ejemplo si 
  cambia su clave en gmail).
* Además de chromium incluimos `firefox-esr` que también ha resultado
  bastante estable.
* Se han recompilado los siguientes para aprovechar `xlocale` (además de muchos
  para perl): `glib2`, `libunistring`, `vlc`
* Se han parchado minimamente los siguientes para usar `servicio` en lugar
  de `daemon`: `postgresql`, `git` y `smartmontools`

### 3.3 Configuración

* Es sencillo emplear como interprete de ordenes `zsh` con `tmux` para
  tener varias terminales y `neovim` como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_2/arboldd/usr/local/share/adJ/archconf/README.md>

## 4. FE DE ERRATAS

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```

## 5. SI QUIERE AYUDARNOS

* Agradecemos sus oraciones.
* Si tiene una cuenta en github por favor póngale una estrella al
  repositorio <https://github.com/pasosdeJesus/adJ/>
* Le invitamos a patrocinar nuestro trabajo empleando el botón
  Patrocinar (__Sponsor__) de <https://github.com/pasosdeJesus/adJ/>
* También puede donarnos para recibir una USB para instalar la
  versión más reciente de adJ o alguno de los servicios de Pasos
  de Jesús desde <https://www.pasosdeJesus.org>
* Agradecemos su ayuda mejorando este sitio, la documentación
  para usuario final y la documentación técnica.
* Agradecemos su ayuda traduciendo a español páginas del
  manual desde: <https://hosted.weblate.org/projects/adj/>
* Agradecemos su ayuda en el desarrollo de fuentes abiertas que llevamos
  en <https://github.com/pasosdeJesus/adJ/>

