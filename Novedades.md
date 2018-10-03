# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.4a1
Fecha de publicación: 3/Oct/2018

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_4/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.3 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Aplicados parches de seguridad previos al 20.Sep.2018 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidad en CPU.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Nuevo ..., Mejorado ...
		* Ethernet: ...
	* Interfaces con usuario:
	* Virtualización: ...
	* Seguridad: ...
	* Sensores y otros: Nuevo
	
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
* Retroportados y adaptados de current: ruby x, postgresql y,
	chromium z (con llaves para compilación de adJ).
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

* Se incluye beta 7 de sivel2 cuyas novedades son:
  * ...

* Se incluye sivel-1.2.6 cuyas novedades son:
  * ...


## FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en drive.google.com
  por esto sigue incluyendose firefox que en casos como ese puede operar.

