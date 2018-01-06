# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.2b2
Fecha de publicación: 6/Ene/2018

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_2/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.1 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Parches al sistema basta hasta el 12.Dic.2017 que cierran 1 falla
  de seguridad y 2 de robustez.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: `iwm` ahora soporta Intel 8265 y 3168, 
		  `rtwn` ahora soporta RTL8192CE,  `ral` ahora soporta
		  RT5360, 
	* Interfaces con usuario: `inteldrm` actualizado.
	* Virtualización: Nuevo `hvs` para almacenamiento Hyper-V. Mejor
 	  soporte para Xen y en particular `xbf`. Muchas mejoras a 
	  `vmd` y `vmctl`.
	* Sensores y otros: Nuevo `urng` para dispositivos USB generadores de
	  números aleatorios. `rtsx` ahora soporta lectores de tarjetas 
	  RTS525A. El control de batería `acpibat`  ahora soporta algo de 
	  ACPI 4.0. Soporte de hibernación ACPI añadido a `nvme`. Mejorado 
	  desempeño de hibernación de `ahci`
* Mejoras a herramientas de Red
	* Mejorado pf para ser más eficiente en IPv6.
	* Desempeño y más consistencia entre IPv4 e IPv6
	* Nuevo servicio slaacd que maneja autoconfiguración de direcciones IPv6
	  sin estado (RFC 4862)
	* Reorganización a fuentes de dhclient
* Seguridad
	* Durante arranque se vuelven a enlazar kernel, libcrytpo y ld.so 
	  en orden aleatorio para producir cada vez un binario diferente 
	  y hacer más dificil explotarlos.  
	* Nueva función `freezero` para borrar y liberar memoria con datos 
	  sensibles.
	* pledge usado ahora en ifstated, snmpd, snmpctl y mejorado su uso
	  en at, nc.
	* Modelo fork+exec usado ahora por pflogd y  tcpdumpd.
* Otros
	* Ahora el sistema base utiliza clang como compilador base.
	* La edición de línea UTF-8 ha mejorado en ksh.
	* Hibernación y suspención automática cuando la bateria es baja
	* Herramientas para mejorar depuración ctfdump y ctfconv, nueva
 	  sección .SUNW_ctf en kernel genérico con datos CTF y uso
	  de información CTF por parte de ddb
	* Mejoras a syslogd y newsyslog
	* Mejor implementación de Thread Control Block y funciones pasadas
	  de libpthread a libc: mutex, variable-condición, datos específicos
	  de thread, pthread_once, pthread_exit
	* Fallas resueltas en OpenSMTP 6.0
	* Incluye OpenSMTP 6.0 (con solución a fallas), OpenSSH 7.6 (que 
	  entre otras añade funcionalidad de reenviador dinámico inverso,
	  LibreSSL 2.6.3 y  mandoc 1.14.3 
	* 

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.24.1, 
  ```nsd``` 4.1.15
* El repositorio de paquetes de OpenBSD cuenta con 9728 para amd64


# Novedades respecto a paquetes 

* Retroportados de Current: ruby 2.5
* Se han actualizado más los binarios de los siguientes paquetes para
cerrar fallas de seguridad (a partir de portes más recientes para 
OpenBSD 6.2):

## NOVEDADES RESPECTO A ADJ 6.1 PROVENIENTES DE PASOS DE JESÚS

* Aprovechando que OpenBSD 6.2 provee una implementación nula de xlocale
  se revisó la implementación completa de locale y xlocale en adJ 6.2,
  ver https://github.com/pasosdeJesus/adJ/blob/master/i18n.md
* En locale se quito soporte a codificaciones diferentes a UTF-8 y ASCII,
  que son las únicas soportadas por OpenBSD.

* Paquetes más actualizados: 
	- php-5.6.32 --no es posible actualizar a 7 porque pear no opera y
		sivel 1.2 depende de pear
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

* Se recompilaron todos los paquetes de perl (sin cambiar de versión) con
  el perl de adJ que soporta LC_NUMERIC.  

* Documentación actualizada:
	- basico_adJ, usuario_adJ y servidor_adJ

* Se parchan y compilan portes más recientes de:
	- biblesync, sword y xiphos
	- markup, repasa y sigue con Ocaml 4.0.5

* Se incluye beta 3 de sivel2 que tiene entres sus novedades:

* Se incluye sivel1.2.4 cuyas novedades son:

* Archivo de ordenes 


