# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.4b1
Fecha de publicación: 15/Ene/2019

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
		  RT3290
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
	* Virtualización: ...
	* Seguridad: ...
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

* Otros
	* ...
	* ...

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 5.0.1,  ```Xenocara``` (```Xorg```) 7.7, ```perl``` 5.24.3, 
* El repositorio de paquetes de OpenBSD cuenta con 9918 para amd64


# Novedades respecto a paquetes 

* Se retiraron paquetes ...
* Retroportados y adaptados de current: 
	* ruby 2.6: es más veloz en tareas que requieren CPU e incluye
		nuevo compilador JIT usabel con opción --jit
	*  chromium (con llaves para compilación de adJ).   
* Se han actualizado más los binarios de los siguientes paquetes para
  actualizar o cerrar fallas de seguridad (a partir de portes más recientes 
  para OpenBSD 6.4): ...
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, djvulibre, gettext-tools, gdk-pixbuf, glib2, gtar, libidn, 
  libspectre, libxslt, scribus, wget, wxWidgets-gtk2


## NOVEDADES RESPECTO A ADJ 6.2 PROVENIENTES DE PASOS DE JESÚS

* ...
* Paquetes actualizados:
	- php-x ...
		Otras extensioens
		no incluidas como de costumbre se dejan en el sitio de 
		distribución en el directorio extra-6.4
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

