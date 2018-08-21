# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.3
Fecha de publicación: 21/Ago/2018

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_3/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.2 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Aplicados parches de seguridad previos al 8.Ago.2018 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidad en CPU.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Mejoras a `iwm` y `iwn` en redes roam y con 
		  SSID escondido.
		* Ethernet: Añadido a `em` soporte para Intel Ice Lake y 
		  Cannon Lake.
	* Interfaces con usuario:
	* Virtualización: Soporta ISOs CD-ROM/DVD en `vmd` y `vioscsi`. `vmd`
	  ahora recibe información de switch (rdomain, etc) de la interfaz
	  de switch que subyace en conjunto con configuraciòn de
	  `vm.conf`, ahora soporta hasta 4 interfaces de red por máquina 
	  virtual.  Se añadió migraciones y snapshots para anfitriones 
	  AMD SVM/RVI.
	* Seguridad: Nuevo `bcmrng`` que soporta generador de números 
	  aleatorios Broadcom BCM2835/CM2836/BCM2837.  Nuevo contolador `efi` 
	  para servicios en tiempo de ejecución EFI. El microcódigo de las
	  CPUs Intel amd64 se carga durante el arranque y se instala con
	  fw_update.
	* Sensores y otros: Nuevo `bcmtemp` que controla monitor de
	  temperatura Broadcom BCM2835/CM2836/BCM2837. Nuevo `bwg`
	  que controla sensor de movimiento Bosch.  Nuevo `rkpcie`
	  que controla puente máquina/PCIe Rockchip RK3399. Se añadió
	  soporte para MegaRAID SAS3.5 a `mfii`. Se añadió soporte para
	  hibernaciòn a los medios de almacenamiento SD/MMC pegados
 	  a controladores `sdhc`
	
* Mejoras a herramientas de Red
	* Soporta GRE sobre IPv6
	* mejoras a dhclient
* Seguridad
	* Mas uso de .rodata para constantes en fuentes en ensamblador
	* Nuevo `execpromises` en pldege
	* Porción del kernel KARL en el piscina de entropia de generador
	  de números aleatorios al arranque
	* Pequeño hueco aleatrio al comienzo de las pilas de hilos, para
	  obligar a un atacante a hacer más trabajo.
	* Mitiga vulnerabilidad Meltdown
	* Incluye OpenSSH 7.7 que soporta criterio rdomain para permitir
	  configuracion condicionale dependiente de ruta del dominio
	* ssh/scp/sftp soportan URIs de las formas ssh://usuario@maquina o
	  sftp://user@maquina/ruta. Arregladas diversas fallas.
	* LibreSSL 2.7.2 con soporte para APIs 1.0.2 y 1.1 y manteniendo el
	  de 1.0.1

* Otros
	* Redireccionador cdn.openbsd.org y soporte para el mismo en 
	  diversos programas como pkg_add
	* Muchas otros arreglos e innovaciones en kernel, utilidades, librería 
	  de C y páginas del manual

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 5.0.1,  ```Xenocara``` (```Xorg```) 7.7, ```perl``` 5.24.3, 
* El repositorio de paquetes de OpenBSD cuenta con 9918 para amd64


# Novedades respecto a paquetes 

* Se retiraron paquetes poco usados de la distribución: ldapvi, g++, 
  gnome-doc-utils, gnome-vfs2, gperf, jack, jailkit, libbonobo, libcanberra, 
  libcaudio, libconfuse, libdca, libf2c, libguess, liblrdf, libmagic,
  libshout, libusb-compat, musepack, netpbm, net-snmp, opencore-amr, openjpeg,
  p5-Geography-Countries, p5-LWP-Protocolo-https, p5-Tk, p5-XML-Parser,
  py-python2-pythondialog, py-psutil, samba-docs, spandsp
* Retroportados y adaptados de current: ruby 2.5.1, postgresql 10.5, 
	chromium 66.0.3359 (con llaves para compilación de adJ).
* Se han actualizado más los binarios de los siguientes paquetes para
  actualizar o cerrar fallas de seguridad (a partir de portes más recientes 
  para OpenBSD 6.3): polkit, py-cryptography, curl
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, djvulibre, gettext-tools, gdk-pixbuf, glib2, gtar, libidn, 
  libspectre, libxslt, scribus, wget, wxWidgets-gtk2


## NOVEDADES RESPECTO A ADJ 6.2 PROVENIENTES DE PASOS DE JESÚS

* El instalador/actualizador inst-adJ.sh ahora actualiza ambiente
  de desarrollo de Ruby de acuerdo a 
  http://pasosdejesus.github.io//usuario_adJ/conf-programas.html#ruby
* Paquetes actualizados:
	- php-5.6.37 --no es posible actualizar a php-7 porque pear no opera y
		sivel 1.2 depende de pear.  Además de la extensión mysqli
	        (util para GLPI por ejemplo) se incluye la extensión mysql
		(requerida por ejemplo por Wordpress).  Otras extensioens
		no incluidas como de costumbre se dejan en el sitio de 
		distribución en el directorio extra-6.3
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

* Se recompilaron todos los paquetes de perl (sin cambiar de versión) con
  el perl de adJ que soporta LC_NUMERIC.  

* Documentación actualizada: basico_adJ, usuario_adJ y servidor_adJ

* Se parchan y compilan portes más recientes de:
	- biblesync, sword y xiphos
	- markup, repasa y sigue con Ocaml 4.0.5

* Se incluye beta 7 de sivel2 cuyas novedades son:
  * Se implementó autoclompetación de víctimas colectivas en formulario 
    de caso.
  * Se rediseño autocompletación de víctimas individuales en formulario 
    de caso.
  * Se resolvieron fallas: cuenta de casos en listado, al elegir departamento 
    en ubicaciones, no permitía eliminar algunos casos (por ejemplo con 
    frontera).

* Se incluye sivel-1.2.6 cuyas novedades son:
  * Al validar desde Otros->Validar, todas las validaciones ahora incluyen 
    analista.
  * Resuelto problema al editar casos con ubicaciones con departamento y sin 
    municipio (agradecemos reporte a Carlos Garaviz).
  * Conteo por víctimas individuales ahora incluye casos sin ubicación o 
    sin municipio (presenta en blanco estos datos cuando no hay información).
  * Resuelto problema de cambio de fecha de caso al intentar añadir un anexo 
    con nombre inválido (agradecemos reporte de Alejandro Burgos).


## FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en drive.google.com
  por esto sigue incluyendose firefox que en casos como ese puede operar.

