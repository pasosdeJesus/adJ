# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos el regreso del señor Jesucristo.

### Versión: 6.2
Fecha de publicación: 26/Feb/2018

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_2/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A ADJ 6.1 PROVENIENTES DE OPENBSD

# Kernel y Sistema Base

* Parches al sistema basta hasta el 20.Feb.2017 que cierran 3 fallas
  de seguridad y 5 de robustez.
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
	* Nuevo servicio `slaacd` que maneja autoconfiguración de direcciones 
          IPv6 sin estado (RFC 4862)
	* Reorganización a fuentes de `dhclient`
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
	* La edición con codificación UTF-8 ha mejorado en ksh.
	* Hibernación y suspención automática cuando la bateria es baja
	* Herramientas para mejorar depuración ctfdump y ctfconv, nueva
 	  sección `.SUNW_ctf` en kernel genérico con datos CTF y uso
	  de información CTF por parte de ddb
	* Mejoras a syslogd y newsyslog
	* Mejor implementación de Thread Control Block y funciones pasadas
	  de libpthread a libc: mutex, variable-condición, datos específicos
	  de thread, pthread_once, pthread_exit
	* Fallas resueltas en OpenSMTP 6.0
	* Incluye OpenSMTP 6.0 (con solución a fallas), OpenSSH 7.6 (que 
	  entre otras añade funcionalidad de reenviador dinámico inverso,
	  LibreSSL 2.6.3 y  mandoc 1.14.3 

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.24.1, 
  ```nsd``` 4.1.15
* El repositorio de paquetes de OpenBSD cuenta con 9728 para amd64


# Novedades respecto a paquetes 

* Nuevo paquete: xmr-stak-cpu para minar criptomoneda monero
* Retroportados de current: ruby 2.5, postgresql 10.1
* Se han actualizado más los binarios de los siguientes paquetes para
  actualizar o cerrar fallas de seguridad (a partir de portes más recientes 
  para OpenBSD 6.2):  chromium, curl, hevea, libtorrent, mariadb,
  ocamlbuild, p5-*, png, rsync,  
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, postgresql-client, postgresql-server, djvulibre, gettext-tools, 
  gdk-pixbuf, glib2, gtar, libidn, libspectre, libxslt, llvm, scribus,
  wget, wxWidgets-gtk2


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

* Se incluye beta 3 de sivel2 cuyas novedades son:
	- Conteos reorganizados para diferenciar filtro de criterios 
	  de desagregación
	- En formulario de caso, en pestaña presuntos responsables, 
	  en cada presunto responsable permite especificar otras 
	  agresiones que no son contra individuos, ni contra 
	  colectividades.
	- Siguiendo marco conceptual del Banco de Datos del CINEP/PPP
	  cambiadas a singular categorías individuales 716 y 717. 
	  Creadas categorias análogas para víctimas colectivas 916 y 
	  917.
* Se incluye sivel-1.2.4 cuyas novedades son:
	- Nombre de categorías individuales 716 y 717 ahora en 
	  singular y agregadas categorías análogas para víctimas 
	  colectivas 916 y 917.
	- En reporte de actos ahora se incluye código de víctima 
	  para facilitar hacer conteos por víctima, así como 
	  organización, filiación, vínculo con el estado y etnia.
	- Corrección: Consulta web presentada como tabla, vuelve a 
	  presentar todas las víctimas colectivas.
	- Corrección: Consulta detallada en reporte de actos ya no 
	  duplica actos cuando se especifica rango de la fecha de 
	  ingreso.
	- Documentación: Configuración para usar base remota

