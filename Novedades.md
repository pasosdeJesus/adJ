#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

###Versión: 6.0b1
Fecha de publicación: 28/Dic/2016 

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_0/Novedades_OpenBSD.md>

##NOVEDADES RESPECTO A adJ 5.9

###KERNEL Y SISTEMA BASE

* Parches al sistema base hasta el 26.Dic.2016, que cierran 2 fallas de 
  seguridad y 13 de robustez resueltas para fuentes de OpenBSD 6.0 
  descritas en <http://www.openbsd.org/errata60.html>
  Los binarios distribuidos de OpenBSD 6.0 no resuelven estas fallas. 
* Retroportados, recompilados o mejorados más de 25 paquetes de OpenBSD para 
  cerrar fallas de seguridad o emplear xlocale.  Incluidos más de 10
  paquetes que no son portes de OpenBSD. Ver detalles en sección 
  PAQUETES EXCLUSIVOS DE ADJ.

Entre las novedades reportadas en las __Notas de publicación de OpenBSD 6.0__
destacamos las siguientes relacionadas con amd64:

* Controladores ampliados o mejorados para amd64
	* Red: 
		* Ethernet: Nevo controlador ure que soporta dispositivos USB Ethernet RealTek RTL8152 10/100. Mejoras a axen que soporta USB Ethernet AX88179 10/100/Gigabit. Mejoras a dc que soporta DEC/Intel 21140/21142/21143/21145
		* Inalámbrico: iwm ahora soporta dispositivos con chip Intel Wireless 3165 y 8260. Mejoras a ral que soporta Ralink Technology/MediaTek
		* Otros: umb que es interfaz usb a redes celulares, opera por ejemplo con Ericsson H5321gw y N5321gw, Medion Mobile S4222 (MediaTek OEM), Sierra Wireless EM7455, Sierra Wireless EM8805, Sierra Wireless MC8305. Mejoras a controladores de memorias SD.
	* Interfaces con usuario: utvfu controla dispositivos para capturar audio y video USBTV007. Interfaz multi-touch para controlador wsmouse
	* Virtualización: Soporta MSI-X en dispositivo virtio. El controlador xen ahora soporta configuración domU bajo el sistema operativo Qubes.
	* Temperatura, sensores y otros: ACPI de más SoCs:chvgipio, bytgpio. Reloj: maxrtc, pcfrtc. 

* Mejoras a herramientas de Red
	* Mejorada pila inalámbrica

* Seguridad
	* Se ha ampliado la protección W^X a programas y sistemas de archivo, si un sistema de archivo debe permitir escritura y ejecución (por ejemplo /usr/local o la subpartición que lo contenga) debe marcarse en /etc/fstab con la opción wxallowed.  Se recomienda dejar /usr/local como subpartición separada.
	* Protecciones y medidas para evitar ataques de inundación SYN 
	* OpenSSH 7.3: no acepta claves de más de 1024 caracteres para evitar uso excesivo de la CPU. 
	* LibreSSL 2.4.2 que soporta cifrado ChaCha20-Poly1305. Resuelve CVE-2016-2105 a CVE-2016-2109

* Otros
	* Nueva herramienta proot en árbol de portes para construir paquetes en una jaula chroot

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.20.3, 
  ```nsd``` 4.1.10


### PROCESO DE INSTALACIÓN

Es en español, consta de: (a) preparación, (b) instalación/actualización 
del sistema base y (c) instalación de aplicaciones y entorno.  Por favor vea 
más detalles en 
[Actualiza.md](https://github.com/pasosdeJesus/adJ/blob/ADJ_6_0/Actualiza.md)


### PAQUETES EXCLUSIVOS DE ADJ

Puede ver el listado de paquetes incluidos en 
[Contenido.txt](https://github.com/pasosdeJesus/adJ/blob/ADJ_6_0/Contenido.txt)
a continuación se describen sólo novedades respecto a la versión anterior de 
adJ y OpenBSD 6.0:


* ```SIVeL 1.2.3```  Ver 
  <http://sivel.sourceforge.net/1.2/actualizacion-sivel.html#actualizaciondeunounoaunodos>
* ```SIVeL 2.0b1p1``` Versión beta 1 de SIVeL 2. Escrita sobre Ruby on Rails
  puede correr en jaula chroot /var/www como usuario www:www
* PostgreSQL 9.6.1 retroportado con soporte UTF-8 y ordenamientos 
  alfabéticos en español.  Desde adJ 5.8 socket reubicado por omisión 
  de ```/var/www/tmp``` a ```/var/www/var/run/postgresql```.
  En adJ las base de datos quedan cifrada cuando así se elije al instalar o 
  actualizar adJ.  Ver detalles de como usar cotejación en 
  <http://aprendiendo.pasosdeJesus.org/?id=i18n>.  
* ```Ruby 2.4.0``` retroportado y probado con aplicaciones Rails 5.   
  Puede ver más sobre Ruby on Rails sobre adJ en 
  <http://dhobsd.pasosdeJesus.org/Ruby_on_Rails_en_OpenBSD.html>
* ```node 4.4.7``` retroportado, ver 
  <http://dhobsd.pasosdejesus.org/freecodecamp.html>
* ```php-5.6.29``` se recomienda activar opcache que hace más veloz 
  la operación con  
  ```doas ln -sf /etc/php-5.6.sample/opcache.ini /etc/php-5.6/```
  y reiniciar el servicio ```php56_fpm```
* Para activar soporte de xlocale se han recompilado los siguientes 
  paquetes que están en portes de OpenBSD 6.0: ```djvulibre```, 
  ```gettext-tools```, ```ggrep```, ```gdk-pixbuf```, ```glib2```, 
  ```gtar```, ```libidn```, ```libunistring```, ```libxslt```, 
  ```llvm```, ```scribus```, ```vlc```, ```wget```, 
  ```wxWidgets-gtk2```
* chromium 51.0.2704.106p0 recompilado con llaves de API de adJ 
* Para cerrar fallas o porque dependen de librerías actualizadas se 
  han recompilado los siguientes paquetes a partir de portes 
  actualizados de OpenBSD 6.0: ```curl```, ```flac```, 
  ```gstreamer```, ```libarchive```, ```mpg123```, 
  ```mariadb```, ```p5-DBD-mysql```, ```p7zip```, 
  ```samba```, ```tiff```, ```vim```, ```xz```, 
  ```zip```, 
* Los paquetes exclusivos los encuentra en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.0-amd64/paquetes> y 
  otras extensiones de PostgreSQL y PHP que no hacen parte de la 
  distribución en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.0-amd64-paquetes-extra>

### PAQUETES DE OPENBSD

Los paquetes para OpenBSD 6.0 también funcionan sin cambios. Resaltamos:
* nginx 1.10.1 <http://pasosdeJesus.github.io/servidor_adJ/sevidorweb.html#openbsd-httpd>
* LibreOffice actualizado a 5.1.4.2, gimp a 2.8.16
* LLVM/Clang a 3.8.0p2 asi como los demás lenguajes de programación
* No hay paquete para mysql, ha sido remplazado por mariadb, ver 
  <http://pasosdeJesus.github.io/servidor_adJ/mariadb.html>
* Añadimos paquete jailkit que facilita operaciones en jaula chroot
* Se incluyen en total 622 paquetes, en los repositorios de paquetes para 
  OpenBSD 6.0 hay 9433 disponibles para amd64


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
* adJ-60-base.pub: RWSQF5Uc51eIduRCwKzW5j7uJyq0dW2n4BY5zTBref0nRXWJJWp0iiRs
* adJ-60-pkg.pub: RWSFwGBTbCIfrjNou4Jo5cvmZPHnqnCH4BfXBeJD9i7Fq8wQzpKHE0Wa

## ACTUALIZACIÓN E INSTALACIÓN

Si planea actualizar de una versión anterior de adJ a adJ 6.0
hay un procedimiento mas rápido con rsync (ver
https://github.com/pasosdeJesus/adJ/blob/ADJ_6_0/Actualiza.md ).

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

Favor ver novedades de adJ 6.0 respecto a OpenBSD en 
<https://github.com/pasosdeJesus/adJ/blob/v6.0/Novedades_OpenBSD.md>



