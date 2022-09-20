# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.1p1
Fecha de publicación: 20/Sep/2022

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_1/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-7.1p1-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/7.1p1-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync desde un adJ o un OpenBSD ya instalado para actualizarlo (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_1/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.1-extra/> 
  es directorio con versiones recientes de paquetes no incluidos en 
  distribución oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.1p1-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-7.1p1-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.1p1-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 7.1p1 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/71.html> 

* Aplicados parches de seguridad hasta el 7.Sep.2022 provenientes de 
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: `igc` soporta Intel I225 1Gb/2.5Gb. Soporte para 
    interfaces USB-Ethernet RTL8156B en `ure`. Mejorados `ix` e  `ixl` para
    tarjetas Intel de 10GB y 40GB respectivamente.
  * Tarjetas inalámbricas: Nuevo controlador `mtw` soporta dispositivos
    Wifi MediaTek MT7601U USB. Soporte para BCM4387 añadido a `bwfm`.
    Soporte para 802.11n (40MHz y velocidades 72 a 600MBs) y 802.11ac (80MHz 
    y velocidades 433 a 6933MBs) a `iwm` y `iwx.`
* Mejoras a herramientas de Red
  * Mejorado DHCP, soporte IPSEC, httpd, smtpd, rpki-client, bgpd.
* Seguridad
  * ssh actualizado a la versión 9.0 que emplea protocolo SFTP con scp en lugar
    del protocolo scp/rcp (hay incompatibilidades en rutas con comodines)
  * libressl actualizado a la versión 3.5.2 que soporta RFC 3779
* Otros
  * Mejoras a tmux, mandoc.

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm 13.0.0`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.32.1` 
* El repositorio de paquetes de OpenBSD cuenta con 11301 para amd64


### 2.2 Paquetes 

* Para cerrar fallas se usan las versiones más recientes preparadas
  por OpenBSD de: `postgresql`, `mariadb`, `node`, `php`, `curl`, 
  `cups`, `dovecot`,  `gnutls`, `gnugp`, `libmad`, `libxml`, `mutt`, 
  `nspr`, `openssl`, `rsync`, `sqlite3`, `tiff`, `unrar`, `unzip`, 
  `wavpack`, `webkitgtk4`, `samba`
* Para aprovechar el xlocale extendido de adJ se han recompilado
  `vlc`, `glib2` y `libunistring`.

* Algunos paquetes típicos y su versión: `dovecot 2.3.16p1v0`,
  `chromium 100.0.4896.60, `firefox-esr 91.7.1`, `libreoffice 7.3.1.3v0`,
  `nginx 1.20.2p0`, `mariadb 10.6.7p0v1`, `node 16.14.2`, `python 3.9.10p0`,
  `neovim 0.6.1`, `zsh 5.8.1`


## 3. NOVEDADES RESPECTO A ADJ 7.1 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Kernel y sistema base

* Los descriptores de archivos pueden ser enteros (en OpenBSD y FreeBSD son 
  enteros cortos lo cual los limita a abri máximo 32.000 archivos 
  simultaneamente).  Con esta implementación en adJ hemos probado abrir 
  simultanemente más de 500.000 archivos:
  ![Pantallazo de programa de prueba con más de 500.000 descriptores de archivos](https://aprendiendo.pasosdejesus.org/assets/images/muchosdescriptores.png)

  Para usar más descriptores efectivamente (digamos 200.000):
  ```
  doas sysctl -w kern.maxfiles=200000
  ulimit -n 200000
  ```

### 3.1 Instalador y documentación

* Documentación actualizada 
	* `basico_adJ`: 
    <http://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ` 
    <http://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`: 
    <http://pasosdejesus.github.io/servidor_adJ>

### 3.2 Paquetes

* El nuevo paquete `ton` consta de las herramientas del Blockchain TON 
  (The Open Network).  Ver documentación de como probar un 
  contato inteligente sobre adJ en
  http://pasosdejesus.github.io/usuario_adJ/conf-programas.html#ton
* Incluimos más paquetes de OpenBSD en esta versión de adJ entre los que
  destacamos: `smartmontools` para monitorear discos duros que soportan SMART,
  `pandoc` para convertir entre diveros lenguajes de marcado (lo usamos 
  para generar esta documentación), `redis` que es una base de datos tipo 
  llave-valor usada por ActionCable en la infraestructura reciente de rails.
* El aumento en número de descriptores de archivos puede afectar algunos
  binarios por lo que tuvieron que recompilarse:
  `unzip`, `bison`, `m4`, `unzip`, `python`, `ruby`,
  `gettext-tools`,  `gmake`, `ImageMagick`, 
  `texlive_base` y `texlive_texmf-minimal`
* Chromium recompilado con llave de Pasos de Jesús.  Ya permite autenticar
  y usar sitios como https://drive.google.com  --si tiene problemas para
  autenticarse intente desde un nuevo perfil (obligatorio por ejemplo si cambia
  su clave en gmail).
* Además de chromium incluimos `firefox-esr` que también ha resultado
  bastante estable.
* Se han recompilado los siguientes para aprovechar `xlocale` (además de muchos
  para perl): `glib2`, `libunistring`, `vlc`
* Se han retroportado de OpenBSD-current los siguientes paquetes para cerrar 
  fallas: `jansson`, `postgresql-client`, `postgis`, `ruby`

### 3.3 Configuración

* Es sencillo emplear como interprete de ordenes `zsh` con `tmux` para
  tener varias terminales y `neovim` como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_1/arboldd/usr/local/share/adJ/archconf/README.md>

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

