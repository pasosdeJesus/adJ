# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.4b1
Fecha de publicación: 15/Feb/2019

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_4/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.3 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Aplicados parches de seguridad previos al 27.Dic.2018 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidad en CPU.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Nuevo ..., Mejorado `rtwn` para soportar 
	          RTL8188EE y RTL8723AE. Mejorado `ral` para soportar
		  RT3290. En toda la pila wireless nueva característica
		  'join' que permite al kernel manejar automáticamente cambio
		  entre diversas redes inalámbricas.
		* Ethernet: Nuevo controlador 'bnxt' para adaptaores PCI 
		  Express Broadcom NetXtreme-C/E basados en los chipsets 
		  Broadcom BCM573xx y BCM574xx.
		* USB y modems: Nuevo controlador `mue` para Gigabit sobre 			  USB 2.0 Microchip LAN7500/LAN7505/LAN7515/LAN7850 USB 2.0 y 
		  sobre USB 3.0 LAN7800/LAN7801. Controlador `umsm` ahora
	 	  soporta Huawei k3772. `com`  soporta mejor UARTs Synopsys 
		  Designware 
	* Interfaces con usuario:
		* Vídeo: Actualizado controlador *radeondrm* para agregar
 		  mejor soporte para APUs KAVERI/KABINI/MULLINS y GPUs 
		  OLAND/BONAIRE/HAINAN/HAWAII
		* Touchpad: Nuevo *umt* que soporta USB Windows Precision 
		  Touchpad. Controlador `pms` ahora soporta Elantech 
		  trackpoints
	* Virtualización: Soporta imágenes de disco qcow2 y snapshots.
	* Sensores y otros: Mejorado `acpithinkpad`. Controlador `nmea` ahora 
	  soporta redes GNSS fuera de GPS. Soporte para monitor de hardware con
	  chipset VIA VX900  en `viapm`. Nuevo controlador `islrtc` para 
	  reloj ISL1208
	* Almacenamiento: Controlador `mpii` soporta SAS 3.5 (SAS34xx and 
	  SAS35xx).  `mfii` soporta sensores y bio de disco y estado de bateria.
	
* Mejoras a herramientas de Red
	* ...
* Seguridad
	* ...
	* Incluye OpenSSH ... que
	* LibreSSL ...
	* Seguridad: Nueva llamada al sistema unveil para restringir acceso 
	  al sistema de archivos del proceso sólo a ciertos archivos 
	  y directorios. 
	* Más mitigaciones para SpectreRSB, L1 Terminal Fault, 
	  información colada del estado del FPU.  
	* Grabación de audio deshabilitado por omisión, se habilita con la 
	  variable sysctl kern.audio.record

* Otros
	* ...
	* ...

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 6.0.0,  ```Xenocara``` (```Xorg```) 7.7, ```perl``` 5.24.3, 
* El repositorio de paquetes de OpenBSD cuenta con 9918 para amd64


# Novedades respecto a paquetes 

* Se retiraron paquetes mozjs17, pecl-uploadprogress, phantomjs, php-mysql 
  (que ya no está en PHP 7), py-acme, py-ConfigArgParse, py-gdal, py-josepy, 
  py-mock, py-parsedatetime, py-psutil, py-psycopg2, py-qscintilla, 
  python-tkinter, tremor 
* Retroportados y adaptados de current: 
	* ruby 2.6.1: es más veloz en tareas que requieren CPU e incluye
		nuevo compilador JIT usable con opción --jit
	*  Se deja chromium 69 (con llaves para compilación de adJ) porque 
	   en pruebas con chromium 71 (retroportado) no permitia adjuntar 
	   archivos, ni ingresar a {drive,calendar}.google.com y 
 	   chromium 72 requiere bastante memoria para su ejecución
	   (y JDK para su compilación).
	* curl, djvulibre, libspatialite, py-requests, py3-requests,
	  qemu, tiff por versiones mas recientes
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, djvulibre, gettext-tools, gdk-pixbuf, glib2, gtar, libidn, 
  libspectre, libxslt, scribus, wget, wxWidgets-gtk2


## NOVEDADES RESPECTO A ADJ 6.3 PROVENIENTES DE PASOS DE JESÚS

* Instalador prepara características de seguridad KARL con kernel 
  APRENDIENDODEJESUS en lugar de GENERIC

* Paquetes actualizados:
	- php-5.6.40 y php-7.0.33
		Aunque según http://php.net/archive/2019.php#id2019-01-10-4
		php-5.6.40 será última versión de la serie 5.6,
		tuvo que inclurse porque buena parte e la librería pear 
		aún requiere php-5.6 (incluyendo partes requeridas por 
		SIVeL 1.2 como HTML_QuickForm) aunque al parecer otras 
		partes requieren php-7.
		Urge el transito en SIVeL 2 porque futuras fallas encontradas
		en PHP-5.6 no será resueltas.
		En esta versión inst-adJ configurará por omisión php-5.6.40 
		que es el requerido por Pear y SIVeL 1.2, usando
		el script php56_fpm, la configuración /etc/php-fpm.conf y
		el socket /var/www/var/run/php-fpm.sock.
		Si en un servidor necesita correr SIVeL con PHP 5 y otra
		aplicación con PHP 7, la sugerencia es modificar 
		/etc/rc.d/php70_fpm para que emplee un segundo
		archivo /etc/php70-fpm.conf que ubique el socket para
		php 7 por ejemplo 
		de configuración php-fpm
		Otras extensioens no incluidas como de costumbre se dejan 
		en el sitio de distribución en el directorio extra-6.4
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

* Se recompilaron todos los paquetes de perl (sin cambiar de versión) con
  el perl de adJ que soporta LC_NUMERIC.  

* Documentación actualizada: basico_adJ, usuario_adJ y servidor_adJ

* Se parchan y compilan portes más recientes de:
	- biblesync, sword y xiphos
	- markup, repasa y sigue con Ocaml 4.0.5

* Se incluye beta 8 de sivel2 cuyas novedades respecto al beta 7 son:
  * En tabla básica Rango de Edad se quita campo rango y su información se 
    deja en campo nombre
  * Reorganizado el formulario de caso para aprovechar espacio horizontal
  * Conteo por persona permite desagregar por año de nacimiento
  * Listado de víctimas y casos (en SIVeL 1.2 se llamaba reporte consolidado)
    configurable con la tabla básica "Rotulos para el listado de víctimas"
  * Posibilidad de exportar listado de víctimas a una plantilla
    de hoja de cálculo, con posibilidad de incluir más campos que antes (e.g
    datos biográficos de la víctima).
  * El listado de usuarios y los listados de las tablas básicas en lugar de 
    "Fecha de deshabilitación" ahora tienen un filtro "Habilitado" con 
    opciones Si, No y Todos.
  * Listados de departamento, municipio y centro poblado permiten filtar 
    por pais 

* Se incluye sivel-1.2.6 cuyas novedades son:
  * ...


## FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en www.davivienda.com
  por esto sigue incluyendose firefox que en casos como ese puede operar.

- xenodm no logra utilizar un teclado latinoamericano.  Para usarlo
  agregue en /etc/X11/xenodm/Xsetup_0:
  setxkbmap latam

