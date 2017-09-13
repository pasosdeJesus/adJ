# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

### Versión: 6.2
Fecha de publicación: 12/Dic/2017

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_2/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.0 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Parches al sistema basta hasta el  que cierran 16 fallas 
  de seguridad y 11 de robustez.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Ethernet: 
		* Inalámbrica: 
		* Otros: 
	* Almacenamiento: 
	* Interfaces con usuario: 
	* Virtualización: 
	* Sensores y otros: 
* Mejoras a herramientas de Red
	* x
* Seguridad
	* y
* Otros

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.24.1, 
  ```nsd``` 4.1.15



# Novedades respecto a paquetes 

* retroportado de Current
* Se han actualizado más los binarios de los siguientes paquetes para
cerrar fallas de seguridad (a partir de portes más recientes para 
OpenBSD 6.2):

## NOVEDADES RESPECTO A ADJ 6.1 PROVENIENTES DE PASOS DE JESÚS

* Paquetes más actualizados: 
	- php-5.6.31 --no es posible actualizar a 7 porque pear no opera y
		sivel 1.2 depende de pear
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

* Se recompilaron todos los paquetes de perl (sin cambiar de versión) con
  el perl de adJ que soporta LC_NUMERIC.  Antes de actualizar a 6.2
  es recomendable desintalar p5-Term-ReadKey si lo tiene (esto lo 
  hace preact-adJ.sh de 6.2).


* Documentación actualizada:
	- basico_adJ, usuario_adJ y servidor_adJ

* Se parchan y compilan portes más recientes de:
	- biblesync, sword y xiphos
	- markup, repasa y sigue con Ocaml 4.0.5

* Se incluye beta 3 de sivel2 que tiene entres sus novedades:

* Se incluye sivel1.2.4 cuyas novedades son:

* Archivo de ordenes 


