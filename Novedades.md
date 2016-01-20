#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que esperamos será la elegida por Jesús durante el Milenio.

##Versión: 5.8a1%%%
Fecha de publicación: 25/Ene/2015

###NOVEDADES

Con respecto a OpenBSD 5.8 para amd64 y a la edición anterior de este DVD


###KERNEL Y SISTEMA BASE

* Símbolo __adJ__ predefinido en gcc.  Facilita uso de xlocale y características únicas de adJ respecto a OpenBSD en algunos portes --como libunistring.
* Utilidad ==localedef== especificada en el estándar POSIX para convertir formatos de fechas y horas en un formato estándar POSIX al formato de OpenBSD.  Configuraciones regionales de países tomadas del CLDR de Unicode.
* Soporte en la librería de C para presentar fechas, horas, cantidades monetarias, números y ordenamientos alfabéticos (cotejación) con las convenciones de cada país de latinoamérica (y de otros locales soportados por OpenBSD) de acuerdo al estándar POSIX. Opera bien en codificaciones de 8 bits o para español en codificación UTF-8. Buena parte de este soporte, así como el de xlocale se basaron en FreeBSD.  Estas mejoras fueron aportadas a OpenBSD (cotejación desde adJ 5.2, cantidades monetarias y números desde 5.4 y fechas y horas desde 5.5) y se anhela su integración en futuras versiones.    Así en adJ por ejemplo los ordenamientos alfabéticos en !LibreOffice y otros programas son correctos en español (que no ocurre en OpenBSD).
* Parches de seguridad del sistema base hasta 27.Oct.2015, que cierran las 10 fallas de seguridad y las 8 de robustez resueltas para fuentes de OpenBSD en http://www.openbsd.org/errata58.html. Los binarios distribuidos de OpenBSD 5.8 no resuelven estas fallas.
* Retroportados, recompilados o mejorados más de 25 paquetes de OpenBSD para cerrar fallas de seguridad o emplear xlocale,  ver detalles en sección PAQUETES EXCLUSIVOS DE ADJ.
* Hemos remplazando `daemon' por `servicio' en buena parte del sistema base (ver por ejemplo ==vmstat -s== o ==less /var/log/servicio== o ==man servicio==).  

Entre las novedades reportadas en las `Notas de publicación de OpenBSD 5.8' destacamos las siguientes relacionadas con amd64:

* Controladores ampliados o mejorados para amd64
** Vídeo: Mejorado ==radeondrm== en su soporte para Radeon RS* IGP
** Audio: Mejorado ==azalia== para soportar codecs Realtek ALC885  y dipositivos Bay Trail HD Audio.
** Red: Ethernet:  Nuevo ==nep== que soporta Sun Neptune 10GB, mejorado ==myx== que soporta yricom Myri-10G PCI Express, mejorado ==msk== para soporta Yukon Prime, Yukon Optima 2, Yukon 88E8079,  y varios EC U y chipsets Supreme; mejorado ==bge== para soportar frames jumbo; mejorado ==sk== que soporta XMAC II y Marvell Yukon 10/100G.  Inalámbrico:  Nuevo ==iwm== que soporta dispositivos Intel 7200 IEEE 802.11a/ac/b/g/n; mejorado ==athn== para soprotar Atheros UB94; mejorado ==win==. Modem USB: Mejorado ==umsm== para soportar MEDION S4222, mejorado ==umodem== para soportar dispositivos Arduino Leonardo.
** Discos: Mejorado ==ciss== para soportar Arreglos RAIS HP Gen9 Smart, mejorados ==mpi== y ==mfi==, ==mfii== que soportan arreglos RAID. Mejorado ==pciide== para soportar chipsets Intel C610.
** Temperatura, sensores y otros: USB 3.0 soportado en ==xhci==, varios adaptadores seriales a usb soportados con nuevos ==umcs== y ==uslhcom==; mejorado ==umass== para soportar ARchos 24y Vision. gpio: controlador ==skgpio== para Soekris net6501. Lectores de tarjetas: mejorado ==rtsx== para soportar RTS5227 y RTL8411B. Puentes y Buses PCI: mejorados ==ppb==, ==puc==. Memoria:mejorado ==sdmmc== para soportar memorias SD/MMC de mas de 2G y más tarjetas reconocidas por ==sdhc==. UPS: Mejorado ==upd== para soportar más UPS. Mejorado ==ums== para soportar tabletas emuladas por Qemu. Teclado: Mejorado ==ukbd== para soportar Apple "wellspring". touchpads: Mejorado ==pms== para soportar Elantech v4.

* Mejoras a herramientas de Red
** OpenBSD httpd: No soporta SSLv3, mejora soporte para virtualhosts, autenticación básica, redirección en URLs específicos, mejoras a FastCGI
** OpenSMTP 5.4.4:  No soporta SSLv3, mejoras a reconocedor de encabezados
** tcpdump presenta tráfico destinadoa a direcciones IPv6 de Enlace-local (FE80::/65)
** Las solicitudes de IPv6 ahora las hace el kernel ("inet6 autoconf") no se requieren rtsol y rtsold que se han eliminado.

* Seguridad
** Chequeo más estricto W^X en kernel
** /var/tmp es enlace a /tmp
** Las funciones rand, random, drand48, lrand48, mrand48, srand48 ahora son no-deterministicas.
** passwd ahora sólo soporta cifrado blowfish
** Mejoras LibreSSL que es una pila para TLS que remplaza OpenSSL con fuentes más legibles y auditadas.
** OpenSSH 6.8

* Otros
** mandoc ahora soporta UTF-8 especificado con -K y la salida por defecto ahora es -Tlocale en lugar -Tascii
** ==syslogd== puede enviar mensajes por TLS
** Nueva herramienta ==rcctl== para controlar servicios
** Diversos programas pasados de base a portes: Sendmail, nginx.  Estos están disponibles como paquetes.


* El sistema base incluye mejoras a componentes auditados y mejorados como ==Xenocara== (Xorg 7.7), ==gcc== 4.2.1, ==perl== 5.18.2, LibreSSL 2.0 con parches posteriores, OpenSMTP 5.4.4, nsd 4.0.3


!PROCESO DE INSTALACIÓN

En adJ es en español, consta de: (a) preparación, (b) instalación/actualización del sistema base y (c) instalación de aplicaciones y entorno.  Por favor vea más detalles en [ Actualiza.md | https://github.com/pasosdeJesus/adJ/blob/ADJ_5_8/Actualiza.md ]

Desde 5.7 el instalador no incluye etc ni xetc pues hacen parte de base y xbase
Desde 5.7 la bitácora de instalación ya no se ubica en /var/tmp sino en /var/www/tmp 


!PAQUETES EXCLUSIVOS DE ADJ

Puede ver el listado completo en https://github.com/pasosdeJesus/adJ/blob/master/Contenido.txt a continuación se describen sólo novedades respecto a la versión anterior de adJ y OpenBSD 5.8:
* SIVeL 1.2.  Si no lo hahecho se recomienda migrar a esta versión estable (también se incluye SIVeL 1.1.7 para facilitar el proceso a quienes usen SIVeL 1.1.x) ver http://sivel.sourceforge.net/1.2/actualizacion-sivel.html#actualizaciondeunounoaunodos
* SIVeL 2.0a7. Versión alfa de SIVeL 2. Escrita sobre Ruby on Rails.
* Mt77 1.0a1. Buscador rápido y preciso para español, versión alfa.
* PostgreSQL 9.4.5 retroportado y recompilado para cerrar fallas, pero además con soporte UTF-8 y ordenamientos alfabéticos en español. En adJ la información queda cifrada cuando así se elije al instalar o actualizar adJ.  Ver detalles de como usar cotejación en http://aprendiendo.pasosdeJesus.org/?id=i18n
* ruby 2.2.4 retroportado de OpenBSD-current y probado con aplicaciones Rails 4.2.4 Ver http://dhobsd.pasosdeJesus.org/Ruby_on_Rails_en_OpenBSD.html 
* Para activar soporte de xlocale se ha recompilado los siguientes paquetes que están en portes de OpenBSD 5.8: boost, djvulibre, ggrep, glib2, gtar, libidn, libxslt, llvm, scribus, vlc, wget, wxWidgets-gtk2
* Para cerrar fallas se han recompilado los siguientes paquetes a partir de portes actualizados de OpenBSD 5.8 (pero no incluidos en binarios de ese sistema):  cups, cups-libs, cups-filters, curl, gdk-pixbuf, ghostscript, gnutls, icu4c, libksba, libtasn1, libwmf, libxml, net-snmp, netpbm, p5-Mail-SpamAssassin, polkit, php-5.5.30, qemu, rrdtool
* Se han retroportado otros paquetes de OpenBSD-Current: chromium-43 (más estable)
* Se incluye el navegador modo texto w3m para remplazar a lynx que salió del sistema base. w3m soporta UTF-8, colores y descargas grandes (no operaba en 5.6).
* Nuevo porte ocaml-labltk
* Paquetes con documentación renombrados ahora son: basico_adJ, usuario_adJ y servidor_adJ que se instalan (con el nuevo nombre) en /usr/local/share/doc/.  Las fuentes se migraron a github y puede ubicarlas en https://github.io/pasosdeJesus y los HTML puede verlos en Internet en http://pasosdeJesus.github.io/basico_adJ/, http://pasosdeJesus.github.io/usuario_adJ/ y http://pasosdeJesus.github.io/servidor_adJ/ 
* Los paquetes exclusivos los encuentra en [http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.8-amd64/paquetes] y otras extensiones de PostgreSQL y PHP que no hacen parte de la distribución en [http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/5.8-amd64-paquetes-extra] 

!PAQUETES DE OPENBSD

Los paquetes para OpenBSD 5.8 también funcionan sin cambios, resaltamos:
* nginx 1.7.1 que puede ser util mientras migra a OpenBSD httpd, ver http://pasosdeJesus.github.io/servidor_adJ/sevidorweb.html#openbsd-httpd
* !LibreOffice actualizado a 4.1.6.2, gimp a 2.8.10
* LLVM/Clang a 3.5.2040228p8 asi como los demás lenguajes de programación
* No hay paquete para mysql, ha sido remplazado por mariadb, ver http://pasosdeJesus.github.io/servidor_adJ/mariadb.html
* Se incluyen en total 517 paquetes, en los repositorios de paquetes para OpenBSD 5.8 hay 8588 disponibles para amd64


!ESCRITORIO

==ksh== con ==xterm== no soportan del todo UTF-8, por ejemplo al borrar una vocal con tilde o ñ debe presionarse 2 veces espacio atrás.  Si requiere una terminal con codificación ASCII ejecute:
<pre>
    xterm -en ascii
</pre>
y ponga la variable LANG en otro valor por ejemplo:
<pre>
    export LANG=C
</pre>

!DOCUMENTACIÓN

* Se han hecho diversas pruebas del uso de adJ sobre IPv6. Se ha comprobado que la pila de red de OpenBSD puede conectarse tanto con túneles como directamente a conexiones IPv6 solas y doble pila. Respecto a servicios se ha comprobado que operan bien al menos Xorg, cupsd, nginx, smtpd, sshd, named, ftpd, rsync, dovecot.  También se ha comprobado la operación correcta sobre IPv6 de la pila Ruby on Rails incluida en adJ. Para facilitar la adopción de IPv6 --extremadamente retrasada en Colombia-- hemos iniciado ejercicios y enlaces a material público de un curso de IPv6 de LACNIC en: 
	http://dhobsd.pasosdejesus.org/ipv6-basico-lacnic-2015.html
* Se han hecho pruebas del uso de adJ sobre conexiones ethernet 10G con cableado categoria 6A, con tarjetas de red de 10G y switches de 10G. También se han hecho pruebas exitosas de cortafuegos redundantes para brindar alta disponibilidad con costos moderados. Estaremos documentando.

!!!DESCARGAS

Puede descargar imagenes ISO para amd64:

* Protocolo HTTP: http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus
* Protocolo RSYNC: ==rsync !rsync://rsync.pasosdeJesus.org/AprendiendoDeJesus==
* Ya no se soporta el protocolo FTP

Si prefiere asumir gastos de manufactura, envío y eventualmente una donación con gusto le enviamos un DVD ([correo de contacto|mailto:info@pasosdeJesus.org]).

Las claves públicas empleadas para firmar digitalmente el CD de instalación y los paquetes se ubican en /etc/signify y deben coincidir con estas:
* adJ-58-base.pub: ![RWSHIU7tODYAqTiwkmrJclJb1WZXWrP7GcAmxueSChfaZ35o18ckZzUO]
* adJ-58-pkg.pub: ![RWRJU9sVRyykCZtxkoXZfKfFYxboSbotEpLjGErsJ7XikPM+Qm+k6zcC]

!!!ACTUALIZACIÓN E INSTALACIÓN

Si planea actualizar de una versión anterior de adJ a adJ 5.8
hay un procedimiento mas rápido con rsync (ver
https://github.com/pasosdeJesus/adJ/blob/ADJ_5_8/Actualiza.md ).

Allí mismo se documentan algunos problemas comunes al actualizar y su solución.


Si no tiene experiencia con esta distribución de OpenBSD para servidores
y cortafuegos, que es segura, usable en español y amigable para cristian@s,
puede aprender a instalar o actualizar con:
# El curso/⁠reto que da una medalla a quienes completen:
  https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
# La guía de instalación:
  http://pasosdeJesus.github.io/guias/usuario_adJ/sobre-la-instalacion.html


!!! SOPORTE

Eventualmente podrá contar con ayuda voluntaria para utilizar los programas disponibles en este DVD en la lista pública ==openbsd-colombia== a la cual puede suscribirse enviando un correo a openbsd-colombia-subscribe@googlegroups.com (Agradecemos amabilidad del moderador Fernando Quintero).

Si su organización necesita un soporte retribuido lo invitamos a escribirnos al [correo de contacto|mailto:info@pasosdeJesus.org].


!!!DESARROLLO

Lo invitamos a consultar https://github.com/pasosdeJesus/adJ y a enviar sus mejoras.


!!! FE DE ERRATAS

Tanto en OpenBSD como en adJ cuando se usa locale (por ejemplo con 
codificación de caracteres UTF-8) ==abiword== presenta problemas para 
arrancar, inicielo así:
<pre>
LC_MESSAGES=C abiword
</pre>


!!! DONACIONES 

Para mejorar el financiamiento de OpenBSD, donamos y aportamos trabajo voluntario a ese proyecto.  Por lo mismo publicamos adJ varios meses después de la respectiva versión de OpenBSD.

'''Agradecemos sus oraciones y si le resulta posible sus [donaciones | Donaciones]'''.

