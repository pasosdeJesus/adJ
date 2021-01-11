# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.8b1
Fecha de publicación: 10/Ene/2020

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.8b1-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.8b1-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync y actualizar un adJ ya instalado (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.8-extra/> es 
  directorio con versiones recientes de paquetes no incluidos en distribución 
  oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarollo/AprendiendoDeJesus-6.8b1-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-6.8b1-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 
      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.8b1-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.7 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

* Aplicados parches de seguridad hasta el 16.Mar.2020 provenientes de 
  OpenBSD que incluyen solución a fallas de OpenSMTPD y sysctl
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Soporte para TP-Link TL-WN822N-EU v5 (y v4) en `urtwn`.
    Soporte para AP6359SA y otras variantes de BCM4359 SDIO en `bwfm`.

		* Ethernet: Soporte para BCM5719A1 en `bge`. Habilitadas
    varias colas tx/rx con condensado RSS Teplitz en 
    `vmx`, `ix` and `ixl`.  Soporte para RK3308 en `dwe`. 
    Soporte para RTL8125B en `rge`. Soporte para ConnectX-6 Dx y para VLANs y
    otras mejoras a `mcx`
		* USB y modems: 
	* Vídeo: 
	* Sonido: 
	* Almacenamiento: 
	* Criptografía: 
	* Sensores y otros: Soporte para sensores de temperauta RK3308 en `rktemp`.
  Soporte para touchpad Elantech v1 en `pms`. Mejorado soporte para
  touchpad de varios portatiles Dell Latitude en `imt`.

	
* Mejoras a herramientas de Red
	* Mejoras a 
	* Soporte para 
	* Nuevo 
	* Diversas mejoras a
	* Mejoras a
	* Varias mejoras

* Seguridad
	* Función
	* Se añade soporte para 
	* Incluye OpenSSH x8.1
	* Incluye LibreSSL x3.0.2
* Otros
	* Diversas mejoras a

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm` x8.0.1,  `Xenocara` (basado en `Xorg` x7.7),
  `perl` x5.30.2
* El repositorio de paquetes de OpenBSD cuenta con x11268 para amd64


### 2.2 Paquetes 

* Recompilados portes estables más recientes para evitar fallas de seguridad de : 
* Ruby 3.0.0 retroportado de current
* Algunos paquetes típicos y su versión: dovecot x2.3.10, chromium 85.0.4183.121
  firefox x76.0 , libreoffice x6.4.3.2, nginx x1.16.1p1, mariadb x10.4.12v1,
  node x12.16.1, postgresql x12.3, python x3.7.9, ruby x2.7.1p0, vim x8.2.534,
  neovim x0.4.3, zsh x5.8


## 3. NOVEDADES RESPECTO A ADJ 6.7 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación
* ...
* Documentación actualizada: 
	* `basico_adJ`: Nueva sección 
	* `usuario_adJ`: Nueva sección 
	* `servidor_adJ`: Nueva sección sobre 

### 3.2 Paquetes

* Ahora se incluyen paquetes
  ... <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/arboldd/usr/local/share/adJ/archconf/README.md>
* Nueva versión 1.0a5 del motor de búsqueda Mt77
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Retroportados y adaptados de OpenBSD-current 
  * `chromium` x85.0.4183.121 con llave para API de Google de Pasos de Jesús 
     en lugar de OpenBSD
* Se incluye la versión beta 14 de `sivel2` cuyas novedades con respecto al 
  beta 12 includo en adJ 6.7 se describen a continuación. Agradecimiento por
  varias de  las novedades a Luis Alejandro Cruz:
    - OJO...


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

## 5. SI QUIERE AYUDARNOS

* Agradecemos sus oraciones.
* Si tiene una cuenta en github por favor pongale una estrella al
  repositorio <https://github.com/pasosdeJesus/adJ/>
* Le invitamos a patronicar nuestro trabajo empleando el botón
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

