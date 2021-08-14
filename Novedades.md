# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.9b1
Fecha de publicación: 10/Ago/2021

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.9b1-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.9b1-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync desde un adJ o un OpenBSD ya instalado para actualizarlo (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.9-extra/> 
  es directorio con versiones recientes de paquetes no incluidos en 
  distribución oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarollo/AprendiendoDeJesus-6.9b1-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-6.9b1-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.9b1-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.9 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/69.html> 

* Aplicados parches de seguridad hasta el 12.Ago.2021 provenientes de 
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Mejorados `athn`, `bwfm`, `ipw`, `iwi`, `iwm`, `iwx` 
      y `urtwn`,
		* Ethernet: Nuevo `mvsw`  para switches Marvel "SOHO". `mvpp` ahora soporta
    10G.  Mejorados `ix`, `mvneta`, `mvpp`,  `mvsw`,  `ogx`, `rge` 
    * SFP:  `ofw`
	* Vídeo: Soporte para 30-bits de color en `simplefb` y `wsfb`
	* Sensores y otros: Soporte para AMD Vi y VTD IOMMU que crean dominios
  separados para cada dispositivo PCI dando protección contra accesos 
  inválidos a memoria.  Mejorado soporte para ACPI con nuevos controladores
  `pcamux`, `acpige` para manejo de botón de apagado, `imxiic`.  Mejor
  soporte para touchpads `dwiic`, `ims`, `wsmouse`

* Mejoras a herramientas de Red
  * Nuevo controlador puente virtual Eternet `veb` 
  * Mejoras a bgpd, ospf, IPSEC, httpd, dig, dhclient, OpenSMTPD, 
  * Nuevos servicios `dhcpleased` y `resolvd` (por habiltiar con `rcctl`) que 
    junto con `slaacd` y  `unwind` proveen una configuación automática 
    de interfaces de red y resolución DNS.

* Seguridad
	* Nuevas versiones de LibreSSL y OpenSSH.
* Otros
  * Permite arranque desde GPT en discos formateados de más de 4TB
  * El instalador ahora incluye una versión comprimida con gzip de `bsd.rd`
  * Nueva disciplina para softraid RAID1C (raid1 cifrado)
  * Nuevo kern.video.record para sysctl que previene o posibilita grabar video,
    analogo a kern.audio.record.
  * Enlazador `ld` que genera ejecutables ELF remplazado por el del
    proyecto LLVM. Hasta OpenBSD 6.8 se usaba el del proyecto GNU.
    El nuevo `ld` reporta situaciones erroneas, que no eran detectadas o
    reportadas por el anterior.
* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm 10.0.1`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.32` 
* El repositorio de paquetes de OpenBSD cuenta con 11310 para amd64


### 2.2 Paquetes 

* Veracrypt 1.24u7p1  tomado de correos a `ports-openbsd`
* Recompilados portes estables más recientes para evitar fallas de seguridad 
  de: `curl`, `dovecot`,  `dtc`, `firefox-esr`,  `flac`, `gdal`,
  `gnutls`, `libxml`, `lz4`, `lua`, `mariadb`, `nginx`, `php 8.0`, 
  `python` 2.7 y 3.8, `rsync`, `samba`, `webkitgtk4`

* Algunos paquetes típicos y su versión: `dovecot 2.3.14`,
  `chromium 90.0.4430.72p1`, `firefox-esr 78.12`, `libreoffice 7.0.5.2v0`,
  `nginx 1.18.0p5`, `mariadb 10.5.10v1`, `node 12.16.1p1`, `python 3.9.6`,
  `neovim 0.4.4`, `zsh 5.8p0`


## 3. NOVEDADES RESPECTO A ADJ 6.8 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada: 
	* `basico_adJ`: 
	* `usuario_adJ`: 
	* `servidor_adJ`:

### 3.2 Paquetes

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
* Adaptados de portes de OpenBSD estable:
  * `postgresql 13.4`, `gdal`, `postgis`
* Retroportados y adaptados de OpenBSD-current 
  * `ruby-3.0.2`
  * `chromium 90` con llave para API de Google de Pasos de Jesús 
     en lugar de OpenBSD
* Portes más actualizados que los disponibles en OpenBSD
  * `ocaml 4.12`, `ocamlbuild`, `findlib`, `dune`, `hevea`
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`

### 3.3 Configuración
* Es sencillo emplear como interprete de ordenes `zsh` con `tmux` para
  tener varias terminales y `neovim` como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_9/arboldd/usr/local/share/adJ/archconf/README.md>

## 4. FE DE ERRATAS

- Ni `chromium` ni `firefox` permite ingreso a servicios de Google como
  <https://drive.google.com> por esto incluimos `firefox-esr` que en casos 
  como ese puede operar.

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

