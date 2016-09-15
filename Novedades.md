#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

###Versión: 5.9
Fecha de publicación: 9/Sep/2016

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Novedades_OpenBSD.md>

##NOVEDADES RESPECTO A adJ 5.8p1

###KERNEL Y SISTEMA BASE

* Parches al sistema base hasta el 22.Ago.2016, que cierran las 9 fallas de 
  seguridad y las 16 de robustez resueltas para fuentes de OpenBSD 5.9 
  descritas en <http://www.openbsd.org/errata59.html>
  Los binarios distribuidos de OpenBSD 5.9 no resuelven estas fallas. 
  3 fallas de robustez también afectan los binarios que saldrán de
  OpenBSD 6.0.
* Retroportados, recompilados o mejorados más de 50 paquetes de OpenBSD para 
  cerrar fallas de seguridad o emplear xlocale.  Incluidos más de 30
  paquetes que no son portes de OpenBSD. Ver detalles en sección 
  PAQUETES EXCLUSIVOS DE ADJ.
* Nueva utilidad /usr/local

Entre las novedades reportadas en las `Notas de publicación de OpenBSD 5.9' 
destacamos las siguientes relacionadas con amd64:

* Controladores ampliados o mejorados para amd64
	* Red: 
		* Ethernet: Controlador ```em``` ampliado para soportar
		  Intel 100 Series PCH Ethernet MAC con i219 PHY.
		  Controlador ```re``` ampliado con soporte para 
		  RTL8168H/RTL8111H. Controlador ```cnmac``` usado en algunas
		  enrutadores D-Link, Portwell y Ubiquiti mejorado.
		* Inalámbrico:  iwm e iwn ahora soportan IEEE802.11n que da
		  velocidad de hasta 65MBit/s
	* Interfaces con usuario: Teclados, mouse y touchpads sobre i2c con 
	  ```ikbd```, ```ims```, ```imt```.  ```pms``` ampliado para soportar 
	  touchpadas en modo W y mejorado su soporte para touchpads ALPS
	* Video: inteldrm actualizado para soportar Bay Trail y Broadwell
	* Temperatura, sensores y otros: Nuevo ```pchtemp``` para sensores
	  térmicos en Intel X99, C610, 9 y 100 PCH. Nuevo ```uonerng``` que
	  soporta generador de números aleatorios Moonbase Otago OneRNG.  
	  Ampliado controlador ```sdmmc``` 
	* Virtualización: ```xen```, ```xspd```, ```xnf``` permiten que sea 
          cliente sobre Xen (e.g en AWS).  Iniciados controladores
	  ```viocon```  y ```virtio``` que podrán a futuro ser usada por 
	  KVM, QEMU y otros.
	* Pede arrancar en modos EFI de 32 y 64 bits

* Mejoras a herramientas de Red
	* Varias herramientas de red mejoradas para operar en paralelo con
	  el kernel cuando hay más de un procesador. 
	* Nuevos dispositivos etherip para hacer tuneles de Ethernet sobre IP,
	  pair para crear interfaces virtuales por pares, tap separado de
	  tun.  
	* Mejorado pflow para incluir tráfico IPv6
	* Mejorados dhcp y dhclient
	* Nuevo servicio eigrpd para el protocolo de compuerta de
	  enrutamiento  interior ampliada (Enhanced Interior Gateway 
	  Routing Protocol)
	* Mejorado iked e IPSec para interoperar con MacOS X.

* Seguridad
	* pledge.  Permite a un programa comprometerse a hacer sólo ciertos
	  tipos de llamadas al sistema.  Se produce un fallo si el programa
	  no cumple su promesa.  Así se obliga la separación de privilegios.
	  Ver http://www.openbsd.org/papers/dot2016.pdf
	  La mayoría de binarios del sistema base se modificaron para
	  utilizar pledge.
	* OpenSSH 7.2 incluido que cierra vulnerabilidades y fallas.
	* LibreSSL 2.3.2 cierra vulnerabilidades CVE y otras, soporta 
	  características recientes de TLS y es más estricto para iniciar 
	  conexioens.  nc modificado para remplazar openssl s_client y
	  openssl s_server

* Otros
	* OpenBSD a partir de 5.9 sólo soporta el locale C y locales con 
	  codificación UTF-8. Retiró soporte NLS de libc.
	* El instalador puede instalar en particiones GPT y deja el sistema
	  EFI configurado. También fdisk soporta GPT 
	* Soporte UTF-8 para calendar, colrm, cut, fmt, ls, ps, rs, ul, uniq
	  y wc.

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.20.2, 
  ```OpenSMTP``` 5.9.1, ```nsd``` 4.1.7


### PROCESO DE INSTALACIÓN

Es en español, consta de: (a) preparación, (b) instalación/actualización 
del sistema base y (c) instalación de aplicaciones y entorno.  Por favor vea 
más detalles en 
[Actualiza.md](https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Actualiza.md)


### PAQUETES EXCLUSIVOS DE ADJ

Puede ver el listado de paquetes incluidos en 
[Contenido.txt](https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Contenido.txt)
a continuación se describen sólo novedades respecto a la versión anterior de 
adJ y OpenBSD 5.9:


* ```SIVeL 1.2.2```  Ver 
  <http://sivel.sourceforge.net/1.2/actualizacion-sivel.html#actualizaciondeunounoaunodos>
* ```SIVeL 2.0b1``` Versión beta 1 de SIVeL 2. Escrita sobre Ruby on Rails.
* Nuevo porte y paquete ```htop```
* Porte ```colorls``` mejorado para soportar locale en ordenamiento alfábetico,
  funciona bien en español.
* PostgreSQL 9.5.4 retroportado y recompilado para cerrar fallas, pero 
  además con soporte UTF-8 y ordenamientos alfabéticos en español.  Desde adJ 
  5.8 socket reubicado por omisión de ```/var/www/tmp``` a 
  ```/var/www/var/run/postgresql```.
  En adJ la información queda cifrada cuando así se elije al instalar o 
  actualizar adJ.  Ver detalles de como usar cotejación en 
  <http://aprendiendo.pasosdeJesus.org/?id=i18n>.  Se recompilaro otros 
  paquetes que dependen de este: ```libreoffice```, 
	```gdal```, ```postgis```, ```py-psycopg2```
* ```Ruby 2.3.1``` retroportado de OpenBSD-current y probado con aplicaciones 
  Rails 5.   Puede ver más sobre Ruby on Rails sobre adJ en 
  <http://dhobsd.pasosdeJesus.org/Ruby_on_Rails_en_OpenBSD.html>
* ```node 4.2.1``` probado con aplicaciones 
  como FreeCodeCamp --requiere y por eso se incluyen gcc-4.9.3 y g++-4.9.3 -- 
  ver <http://dhobsd.pasosdejesus.org/freecodecamp.html>
* ```PHP-5.6.25```, se recomienda activar opcache que hace más veloz la 
  operación con  
  ```doas ln -sf /etc/php-5.6.sample/opcache.ini /etc/php-5.6/```
  y reiniciar el servicio ```php56_fpm```
* Para activar soporte de xlocale se han recompilado los siguientes paquetes 
  que están en portes de OpenBSD 5.9: ```boost```, ```djvulibre```, 
  ```gettext-tools```, ```ggrep```, ```gdk-pixbuf```, ```glib2```, 
  ```gtar```, ```libidn```, ```libunistring```, ```libxslt```, ```llvm```, 
  ```scribus```, ```vlc```, ```wget```, ```wxWidgets-gtk2```
* Para cerrar fallas o porque dependen de librerías actualizadas se han 
  recompilado los siguientes paquetes a partir de portes actualizados de 
  OpenBSD 5.9:
  ```bzip2```, ```curl```, ```gd```, ```gimp```, ```git```, ```imlib2```, 
  ```ImageMagick```, ```libksba```, ```libspectre```, ```libtalloc```, 
  ```mariadb-client ```,
  ```mplayer```, ```nginx```, ```node```, ```openldap-client ```,
  ```p5-Mail-SpamAssassin```, ```p7zip```, ```pidgin```, ```samba```,
  ```tdb```, ```tiff```, ```webkit```, ```webkitgtk4```.
* Los paquetes exclusivos los encuentra en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.9-amd64/paquetes> y 
  otras extensiones de PostgreSQL y PHP que no hacen parte de la 
  distribución en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.9-amd64-paquetes-extra>

### PAQUETES DE OPENBSD

Los paquetes para OpenBSD 5.9 también funcionan sin cambios. Resaltamos:
* chromium 48.0.2564.116 recompilado con llaves de API de adJ 
* nginx 1.9.10 <http://pasosdeJesus.github.io/servidor_adJ/sevidorweb.html#openbsd-httpd>
* LibreOffice actualizado a 5.0.4.2, gimp a 2.8.16p1
* LLVM/Clang a 3.5.201402288 asi como los demás lenguajes de programación
* No hay paquete para mysql, ha sido remplazado por mariadb, ver 
  <http://pasosdeJesus.github.io/servidor_adJ/mariadb.html>
* Se incluyen en total 621 paquetes, en los repositorios de paquetes para 
  OpenBSD 5.9 hay 9295 disponibles para amd64


### ESCRITORIO

```ksh``` con ```xterm``` no soportan del todo UTF-8, por ejemplo al borrar 
una vocal con tilde o ñ debe presionarse 2 veces espacio atrás.  Si requiere 
una terminal con codificación ASCII ejecute:
<pre>
    xterm -en ascii
</pre>
y ponga la variable LANG en otro valor por ejemplo:
<pre>
    export LANG=C
</pre>

## DOCUMENTACIÓN

* http://pasosdejesus.github.io/basico_adJ/
* http://pasosdejesus.github.io/usuario_adJ/
* http://pasosdejesus.github.io/servidor_adJ/
* Se ha documentado como hacer conexiones remotas de PostgreSQL con 
  certificados SSL en <http://dhobsd.pasosdejesus.org/postgresql-remoto.html>
* Se está documentnado como correr aplicaciones Ruby on Rails en una jaula
  chroot en <http://dhobsd.pasosdejesus.org/aplicacion-rails-en-chroot.html>

## DESCARGAS

Puede descargar imagenes ISO para amd64:

* Protocolo HTTP: <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus>
* Protocolo RSYNC: ```rsync rsync://rsync.pasosdeJesus.org/AprendiendoDeJesus```

Si prefiere asumir gastos de manufactura, envío y eventualmente una donación 
con gusto le enviamos un DVD 
([correo de contacto](mailto:info@pasosdeJesus.org)).

Las claves públicas empleadas para firmar digitalmente el DVD de instalación 
y los paquetes se ubican en ```/etc/signify``` y deben coincidir con estas:
* adJ-59-base.pub: RWT/X+D55OaOpJ7ZqIgpJh4soQqAu6ocXqvqlQE4uk7TM8cUkPa3LaGx
* adJ-59-pkg.pub: RWQ6Y5bhgkHMqz1bsOhEfs4yojbGD6kv9vHGnCoadGGMcU1oF/+LH1G

## ACTUALIZACIÓN E INSTALACIÓN

Si planea actualizar de una versión anterior de adJ a adJ 5.9
hay un procedimiento mas rápido con rsync (ver
https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Actualiza.md ).

Allí mismo se documentan algunos problemas comunes al actualizar y su solución.


Si no tiene experiencia con esta distribución de OpenBSD para servidores
y cortafuegos, que es segura, usable en español y amigable para cristian@s,
puede aprender a instalar o actualizar con:
1 El curso/⁠reto que da una medalla a quienes completen:
  <https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/>
2 La guía de instalación:
  <http://pasosdeJesus.github.io/guias/usuario_adJ/sobre-la-instalacion.html>


## SOPORTE

Emplee el canal de gitter: <https://gitter.im/pasosdeJesus/adJ>

Eventualmente podrá contar con ayuda voluntaria para utilizar los programas 
disponibles en este DVD en la lista pública ```openbsd-colombia``` a la cual 
puede suscribirse enviando un correo a 
openbsd-colombia-subscribe@googlegroups.com (Agradecemos amabilidad del 
moderador Fernando Quintero).

Si su organización necesita un soporte retribuido lo invitamos a escribirnos 
al [correo de contacto](mailto:info@pasosdeJesus.org)


## DESARROLLO

Lo invitamos a consultar <https://github.com/pasosdeJesus/adJ> y a enviar sus 
mejoras.


## FE DE ERRATAS

Tanto en OpenBSD como en adJ cuando se usa locale (por ejemplo con 
codificación de caracteres UTF-8) ```abiword``` presenta problemas para 
arrancar, inicielo así:
<pre>
LC_MESSAGES=C abiword
</pre>


## DONACIONES 

Para mejorar el financiamiento de OpenBSD, donamos y aportamos trabajo 
voluntario a ese proyecto.  Por lo mismo publicamos adJ varios meses después 
de la respectiva versión de OpenBSD.

Favor ver más novedades de adJ 5.9 en 
<https://github.com/pasosdeJesus/adJ/blob/v5.9/Novedades.md>



