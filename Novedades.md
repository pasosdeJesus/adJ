# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.3
Fecha de publicación: 20/May/2018

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_2/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.2 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

- Aplicados parches de seguridad posteriores al 10.May.2018 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidad Meltdown
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Mejoras a `iwm` y `iwn` en redes roam y con SSID 
	          escondido.
		* Ethernet: Añadido a `em` soporte para Intel Ice Lake y Cannon Lake.
	* Interfaces con usuario:
	* Virtualización: Soporta ISOs CD-ROM/DVD en `vmd` y `vioscsi`. `vmd`
	  ahora recibe información de switch (rdomain, etc) de la interfaz
	  de switch que subyace en conjunto con configuraciòn de
	  `vm.conf`, ahora soporta hasta 4 interfaces de red por máquina virtual.
	  Se añadió migraciones y snapshots para anfitriones AMD SVM/RVI.
	
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
	* Pequeño hueco aleaotrio al comienzo de las pilas de hilos, para
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
	* Muchas otros arreglos e innovaciones en kernel, utilidades, librería de C
	  y páginas del manual

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 5.0.1,  ```Xenocara``` (```Xorg```) 7.7, ```perl``` 5.24.3, 
* El repositorio de paquetes de OpenBSD cuenta con 9912 para amd64


# Novedades respecto a paquetes 

* Nuevo paquete: 
* Retroportados de current: ruby 2.5.1, postgresql 10.4, chromium 66.0.3359 
  (con llaves para compilación de adJ).
* Se han actualizado más los binarios de los siguientes paquetes para
  actualizar o cerrar fallas de seguridad (a partir de portes más recientes 
  para OpenBSD 6.3):  
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, postgresql-client, postgresql-server, djvulibre, gettext-tools, 
  gdk-pixbuf, glib2, gtar, libidn, libspectre, libxslt, scribus,
  wget, wxWidgets-gtk2


## NOVEDADES RESPECTO A ADJ 6.2 PROVENIENTES DE PASOS DE JESÚS

* Paquetes más actualizados que OpenBSD-Current 
	- php-5.6.36 --no es posible actualizar a 7 porque pear no opera y
		sivel 1.2 depende de pear.  Además de la extensión mysqli
	        (util para GLPI por ejemplo) se incluye la extensión mysql
		(requerida por ejemplo por Wordpress).  Otras extensioens
		no incluidas como de costumbre se dejan en el sitio de 
		distribución directorio extra-6.3
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

* Modificación al sistema de paquetes para permitir descripciones de 
  paquetes en UTF-8 con caracteres en español.
* Se recompilaron todos los paquetes de perl (sin cambiar de versión) con
  el perl de adJ que soporta LC_NUMERIC.  

* Documentación actualizada:
	- OJO basico_adJ, usuario_adJ y servidor_adJ

* Se parchan y compilan portes más recientes de:
	- OJO biblesync, sword y xiphos
	- OJO markup, repasa y sigue con Ocaml 4.0.5

* Se incluye beta 6 de sivel2 cuyas novedades son:
  *
* Se incluye sivel-1.2.x cuyas novedades son:
  *


## FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en drive.google.com
  sigue incluyendose firefox que lo opera bien.

