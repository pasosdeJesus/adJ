# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.9
Fecha de publicación: 10/Jun/2021

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.9-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.9-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync y actualizar un adJ ya instalado (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.9-extra/> es 
  directorio con versiones recientes de paquetes no incluidos en distribución 
  oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarollo/AprendiendoDeJesus-6.9-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-6.9-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.9-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.9 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/68.html> y de 
<https://home.nuug.no/~peter/openbsd_and_you_68/#1>

* Aplicados parches de seguridad hasta el 2.Jun.2021 provenientes de 
  OpenBSD que incluyen solución a fallas de OpenSMTPD y sysctl
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: 
		* Ethernet:
	* Vídeo: 
	* Sonido:
	* Sensores y otros:

* Mejoras a herramientas de Red
  * 

* Seguridad
	* 
* Otros
  * 
* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm` x,  `Xenocara` (basado en `Xorg` x.x),
  `perl` x
* El repositorio de paquetes de OpenBSD cuenta con x para amd64


### 2.2 Paquetes 

* Ruby 3...
  * 
* Postgresql ... tomado de correos a ports-openbsd
* Veracrypt ...  tomado de correos a ports-openbsd
* Recompilados portes estables más recientes para evitar fallas de seguridad 
  de: x,y,z
* Algunos paquetes típicos y su versión: dovecot x
  chromium , firefox x , libreoffice x
  nginx x, mariadb x, node x, python x, neovim x,
  zsh x


## 3. NOVEDADES RESPECTO A ADJ 6.8 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada: 
	* `basico_adJ`: 
	* `usuario_adJ`: 
	* `servidor_adJ`:

### 3.2 Paquetes

* El paquete `evangelios_dp` ahora incluye ...
  evangelio de Juan.
* Compiladas versiones más recientes de ...
* Nuevo paquete ...
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Retroportados y adaptados de OpenBSD-current 
  * `chromium` x con llave para API de Google de Pasos de Jesús 
     en lugar de OpenBSD
* Se incluye la versión beta 16 de `sivel2` cuyas novedades con respecto al 
  beta 14 incluido en adJ 6.8 se describen a continuación. Agradecimiento por
  algunas de las novedades a Luis Alejandro Cruz:
  * Mejoras en consultas
    * 
  * Mejoras en sistematización y en importación 
    * 
  * Mejoras en reportes 
    * 
  * Control de acceso y bitácoras
    * 


### 3.3 Configuración
* Es sencillo emplear como interprete de ordenes zsh con tmux para
  tener varias terminales y neovim como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/arboldd/usr/local/share/adJ/archconf/README.md>

## 4. FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en ocasiones en 
  <http://drive.google.com>
  por esto sigue incluyendose firefox que en casos como ese puede operar.

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```
- ruby 

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
* Agradecemos su ayuda en el desarrollo que llevamos
  en <https://github.com/pasosdeJesus/adJ/>

