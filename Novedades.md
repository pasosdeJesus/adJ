#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

###Versión: 5.9b1
Fecha de publicación: 15/Ago/2016

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Novedades_OpenBSD.md>

##NOVEDADES RESPECTO A adJ 5.8p1

###KERNEL Y SISTEMA BASE

-- sys/net/netisr.{c,h} cambiados libssl
* Parches al sistema base hasta el 20.Jun.2016, que cierran las x fallas de 
  seguridad y las y de robustez resueltas para fuentes de OpenBSD descritas 
  en <http://www.openbsd.org/errata59.html>. 
  Los binarios distribuidos de OpenBSD 5.9 no resuelven estas fallas. 
  .. también afectan OpenBSD 6.0, los binarios de esa distribución no los 
  resuelven.
* Retroportados, recompilados o mejorados más de xx paquetes de OpenBSD para 
  cerrar fallas de seguridad o emplear xlocale,  ver detalles en sección 
  PAQUETES EXCLUSIVOS DE ADJ.

Entre las novedades reportadas en las `Notas de publicación de OpenBSD 5.9' 
destacamos las siguientes relacionadas con amd64:

* Controladores ampliados o mejorados para amd64
	* Red: 
		* Ethernet:  Nuevo ..; mejorado ```zz``` para ...
		* Inalámbrico:  
	* Temperatura, sensores y otros: Nuevo ```pchtemp``` para sensores
	  térmicos el Intel X99, C610, 9 y 100 PCH. Nuevo ```uonerng``` que
	  soporta generador de números aleatorios Moonbase Otago OneRNG.

* Mejoras a herramientas de Red
	* Nuevo
	* OpenBSD httpd:
	* OpenBSD SMTPD:

* Seguridad
	* pledge.  Permite a un programa comprometerse a hacer sólo ciertos
	  tipos de llamadas al sistema.  Se produce un fallo si el programa
	  no cumple su promesa.  Así se obliga la separación de privilegios.
	  Ver http://www.openbsd.org/papers/dot2016.pdf
	* 
	* 

* Otros
	* OpenBSD a partir de 5.9 sólo soporta el locale C y locales con codificación UTF-8

* El sistema base incluye mejoras a componentes auditados y mejorados 
como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.20.2, 
```OpenSMTP``` 5.4.4, ```nsd``` 4.0.3


### PROCESO DE INSTALACIÓN

En adJ es en español, consta de: (a) preparación, (b) instalación/actualización 
del sistema base y (c) instalación de aplicaciones y entorno.  Por favor vea 
más detalles en 
[Actualiza.md](https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Actualiza.md)


### PAQUETES EXCLUSIVOS DE ADJ

Puede ver el listado completo en [Contenido.txt](https://github.com/pasosdeJesus/adJ/blob/ADJ_5_9/Contenido.txt)
a continuación se describen sólo novedades respecto a la versión anterior de 
adJ y OpenBSD 5.9:


* ```SIVeL 1.2.2```  Ver 
  <http://sivel.sourceforge.net/1.2/actualizacion-sivel.html#actualizaciondeunounoaunodos>
* ```SIVeL 2.0a9``` Versión alfa de SIVeL 2. Escrita sobre Ruby on Rails.
* ```PostgreSQL 9.5.3``` retroportado y recompilado para cerrar fallas, pero 
  además con soporte UTF-8 y ordenamientos alfabéticos en español.  Desde adJ 
  5.8 socket reubicado de ```/var/www/tmp``` a ```/var/www/var/run/postgresql```.
  En adJ la información queda cifrada cuando así se elije al instalar o 
  actualizar adJ.  Ver detalles de como usar cotejación en 
  <http://aprendiendo.pasosdeJesus.org/?id=i18n>
* ```Ruby 2.3.1``` retroportado de OpenBSD-current y probado con aplicaciones 
  Rails 5.   Puede ver más sobre Ruby on Rails sobre adJ en 
  <http://dhobsd.pasosdeJesus.org/Ruby_on_Rails_en_OpenBSD.html>
* ```node 4.2.1``` probado con aplicaciones 
  como FreeCodeCamp --requiere y por eso se incluyen gcc-4.9.3 y g++-4.9.3 -- 
  ver <http://dhobsd.pasosdejesus.org/freecodecamp.html>
* ```PHP-.5.6.23```.  
* Para activar soporte de xlocale se han recompilado los siguientes paquetes 
  que están en portes de OpenBSD 5.9: ```boost```, ```djvulibre```, 
  ```ggrep```, ```glib2```, ```gtar```, ```libidn```, ```libxslt```, 
  ```llvm```, ```scribus```, ```vlc```, ```wget```, ```wxWidgets-gtk2```
* Para cerrar fallas se han recompilado los siguientes paquetes a partir de 
  portes actualizados de OpenBSD 5.9 (pero no incluidos en binarios de ese 
  sistema):  ```...```.
* chromium 48.0.2564.116 recompilado con llaves de API de adJ
  (más estable). Chromium 48.0.2564.116 liberado el 18.Feb.2016 viene en
  OpenBSD 5.9 y no hay actualización para OpenBSD 5.9 (ver 
http://googlechromereleases.blogspot.com.co/2016/02/stable-channel-update_18.html ), terminó serie 48.  La serie 49 tuvo 5 publicaciones de versión estable 
  la última es de 7.Abr.2016 49.0.2623.112 . La serie 50 usa atomic de C++11
  no soportado en OpenBSD por libstdc++ (y dado que no hay libc++) como 
  se explica en https://bugzilla.mozilla.org/show_bug.cgi?id=876156

* Fuentes de la documentación basico_adJ convertida a Markdown, ver 
  <http://pasosdeJesus.github.io/basico_adJ/> y sobre la herramienta pandoc en
  <http://dhobsd.pasosdejesus.org/pandoc.html>
* Los paquetes exclusivos los encuentra en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.9-amd64/paquetes> y 
  otras extensiones de PostgreSQL y PHP que no hacen parte de la distribución en 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.9-amd64-paquetes-extra>

### PAQUETES DE OPENBSD

Los paquetes para OpenBSD 5.9 también funcionan sin cambios. Resaltamos:
* ruby 2.3.1 retroportado, opera bien con Rails 5
* PostgreSQL 9.5.3 retroportado y se recompilaron otros paquetes que 
  dependen de este (libreoffice, gdal, postgis, py-psycopg2)

* nginx 1.9.10 que puede ser util mientras migra a OpenBSD httpd, 
  ver <http://pasosdeJesus.github.io/servidor_adJ/sevidorweb.html#openbsd-httpd>
* LibreOffice actualizado a 5.0.4.2, gimp a 2.8.16
* LLVM/Clang a 3.5.201402288 asi como los demás lenguajes de programación
* No hay paquete para mysql, ha sido remplazado por mariadb, ver 
  <http://pasosdeJesus.github.io/servidor_adJ/mariadb.html>
* Se incluyen en total 568 paquetes, en los repositorios de paquetes para 
  OpenBSD 5.9 hay 8866 disponibles para amd64


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

* Se han hecho diversas pruebas del uso de adJ sobre IPv6. Se ha comprobado que 
  la pila de red de OpenBSD puede conectarse tanto con túneles como directamente 
  a conexiones IPv6 solas y doble pila. Respecto a servicios se ha comprobado 
  que operan bien al menos Xorg, cupsd, nginx, smtpd, sshd, named, ftpd, rsync, 
  dovecot.  También se ha comprobado la operación correcta sobre IPv6 de la 
  pila Ruby on Rails incluida en adJ. Para facilitar la adopción de IPv6 
  --extremadamente retrasada en Colombia-- hemos iniciado ejercicios y enlaces 
  a material público de un curso de IPv6 de LACNIC en: 
	<http://dhobsd.pasosdejesus.org/ipv6-basico-lacnic-2015.html>
* Se han hecho pruebas del uso de adJ sobre conexiones ethernet 10G con 
  cableado categoria 6A, con tarjetas de red de 10G y switches de 10G. 
  También se han hecho pruebas exitosas de cortafuegos redundantes para brindar 
  alta disponibilidad con costos moderados. Estaremos documentando.

## DESCARGAS

Puede descargar imagenes ISO para amd64:

* Protocolo HTTP: <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus>
* Protocolo RSYNC: ```rsync rsync://rsync.pasosdeJesus.org/AprendiendoDeJesus```

Si prefiere asumir gastos de manufactura, envío y eventualmente una donación con gusto le enviamos un DVD ([correo de contacto](mailto:info@pasosdeJesus.org)).

Las claves públicas empleadas para firmar digitalmente el CD de instalación y los paquetes se ubican en /etc/signify y deben coincidir con estas:
* adJ-58-base.pub: RWSHIU7tODYAqTiwkmrJclJb1WZXWrP7GcAmxueSChfaZ35o18ckZzUO
* adJ-58-pkg.pub: RWRJU9sVRyykCZtxkoXZfKfFYxboSbotEpLjGErsJ7XikPM+Qm+k6zcC

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



