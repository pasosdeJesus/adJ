Con respecto a OpenBSD 5.9 las novedades son:

* Proceso de Instalación:
	* upgrade install install.sub 	En español
	* Organización del CD de instalación diferente

* Kernel
	* Palabra daemon renombrada por servicio ver 
	<http://aprendiendo.pasosdejesus.org/?id=Renombrando+Daemon+por+Service>
	* Nombre de compilación del kernel reportado por uname APRENDIENDODEJESUS

* Sistema Base
	* Binarios nuevos en /usr/bin/
		* colldef 	Para generar cotejación de locales
		* localedef 	Para generar archivos de locale
		* rsync-adJ 	Para descargar versiones nuevas
	* Archivos de órdenes nuevos en /usr/sbin/
		* adicuenta 	Agrega cuenta de correo 
		* auditabitacoras Audita bitacoras de /var/log
		* elimcuenta 	Elimina cuenta de correo
		* monitorea 	Revisa conexión a otro servidor
		* prepopensmtpd 	Prepara servidor de correo
	* Binarios modificados en /usr/bin
		* perl 		con soporte para locale monetario y numérico
		* Muchos otros cambiando daemon por servicio
	* Binarios modificados en /usr/sbin
		* sysmerge	Usa llaves de adJ
		* Muchos otros cambiando daemon por servicio
	* Archivos de órdenes nuevos en /usr/local/adJ/
		* amplia-vnd.sh 	Amplia tamaño de imagen cifrada para vnd
		* cuentaips.sh 	Cuenta frecuencia de IPs en bitácora
		* inst-adJ.sh	Instala adJ
		* inst-sivel.sh	Instala SIVeL
		* inst.sh		Inicia inst-adJ
		* reflejazona.sh 	Genera zona reflejada para DNS
		* repadicuenta.sh Ejecuta adicuenta para todo usuario
		* revisaapachelog.pl Revisa bitácora de Apache
		* revisaauthlog.pl Revisa bitácora authlog
		* rutinas.sh	Diversas rutinas para archivos de ord.
		* servicio-etc.sh	Cambia daemon por servicio en /etc
		* vuelcamysql.sh Vuelca base de datos MySQL
	* Páginas del manual nuevas en /usr/shar/man/man3
		* ctype_l digittoint_l duplocale freelocale isalnum_l,
		isalpha_l isascii_l isblank_l iscntrl_l isdigit_l
		isgraph_l ishexnumber_l isideogram_l islower_l isnumber_l
		isphonogram_l isprint_l ispunct_l isrune_l isspace_l
		isspecial_l isupper_l iswalnum_l iswalpha_l iswblank_l
		iswcntrl_l iswctype_l iswdigit_l iswgraph_l iswideogram_l
		iswlower_l iswnumber_l iswphonogram_l iswprint_l 
		iswpunct_l iswrune_l iswspace_l iswspecial_l iswupper_l
		iswxdigit_l isxdigit_l mblen_l mbrtowc_l mbsinit_l
		mbsnrtowcs_l mbsrtowcs_l mbstowcs_l mbtowc_l newlocale
		nextwctype nextwctype_l querylocale servicio strcasecmp_l
		strcasestr_l strcoll_l strfmon_l strncasecmp_l strxfrm_l
		tolower_l toupper_l towctrans_l towlower_l towupper_l
		uselocale wcscoll wcsnrtombs_l wcsrtombs_l wcstombs_l
		wcsxfrm wctob_l wctomb_l wctype_l xlocale
	* Encabezados de gcc modificados para definir símbolo \_\_adJ\_\_ que 
	  identifica compilaciones en el sistema operativo. Facilita uso de 
	  xlocale y características únicas de adJ respecto a OpenBSD en 
	  algunos portes --como libunistring.
	* Locales nuevos en /usr/share/locale/
		* Entre otros de todos los paises de latinoamérica
	* Zonas horarias nuevas en /usr/share/zoneinfo:
		* Asia/Khandyga Asia/Ust-Nera Europe/Busingen 
		posix/Asia/Khandyga posix/Asia/Ust-Nera posix/Europe/Busingen
		right/Asia/Khandyga right/Asia/Ust-Nera right/Europe/Busingen
	* Encabezados nuevos en /usr/include/
		* monetary.h 	Soporte a componente monetario del locale
		* xlocale.h  	Soporte para xlocale
	* Nuevo /usr/libdata/perl5/site_perl/amd64-openbsd/xlocale.ph
	* Librerías modificadas
		* libc 		Con soporte para localizaciones y xlocale
	* Archivos de configuración en /etc
		* X11/xdm/pixmas/adJ_*.xpm	Logo
		* signify/adJ-*.pub	Llaves criptográficas
		* En la mayoría de casos daemon remplazado por servicio
	* Archivos de configuración de ejemplo en /usr/local/shar/examples/adJ
		* varcorreo.sh	Usado por adicuenta	
		* varmonitorea.sh	Usar por monitorea

* Paquetes
	* Retroportados para cerrar fallas o actualizar
		* postgresql-server postgresql-client postgresql-contrib 
			postgresql-docs ruby ruby23-ri_docs
	* Recompilados de portes estables para cerrar fallas
		*  bzip2, curl, gd, git", imlib2, ImageMagick
		   libksba, libtalloc, mariadb-client mariadb-server, 
		   mplayer, nginx, node, openldap-client, 
		   p5-Mail-SpamAssassin, p7zip p7zip-rar, libpurple pidgin
		   ldb, samba, tevent, tdb, tiff, webkit, webkitgtk4
	* Nueva revisión para operar con librerías retroportadas o actualizadas
		* gdal, inkscape, libreoffice, postgis, py-psycopg2, qgis
	* Recompilado con llave de adJ
		* chromium 
	* Modificados para usar xlocale
		* libunistring, vlc
	* Recompilados de portes estables para usar xlocale y cerrar fallas
		* boost, djvulibre, gettext-tools, ggrep, gdk-pixbuf
			glib2, gtar, libidn, libxslt, llvm, scribus
			wget, wxWidgets-gtk2
	* Adaptados de portes estables pero mejorados para adJ:
		* colorls	Ordena alfabeticamente de acuerdo a locale
		* hexedit 	Soporta tamaños de archivos más grandes
		* xfe		Soporta paquetes tgz
	* Actualizados, pues están desactualizado en OpenBSD estable y current
		* php php-bz2 php-curl php-fpm php-gd php-intl php-ldap 
		php-mcrypt php-mysqli- php-pdo_pgsql php-pgsql php-zip
		pear-Auth pear-DB_DataObject
	* Unicos en adJ 
		* emulators/realboy lang/ocaml-labltk sysutils/ganglia 
		sysutils/htop textproc/biblesync
		textproc/sword textproc/xiphos www/pear-HTML-Common
		www/pear-HTML-Common2 www/pear-HTML-CSS 
		www/pear-HTML-Javascript
		www/pear-HTML-Menu www/pear-HTML-QuickForm www/pear-HTML-Table
		www/pear-DB-DataObject-FormBuilder 
		www/pear-HTML-QuickForm-Controller x11/fbdesk

	* Unicos en adJ liderados por Pasos de Jesús
		* evangelios_dp	Traducción en progreso de dominio público
		* basico_adJ	Documentación de uso remoto y básico
		* usuario_adJ	Docuemntación como sistema de escritorio
		* servidor_adJ	Documentación como servidor y cortafuegos
		* AnimalesI	Ejercicios lectoescritura
		* AprestamientoI	Ejercicios lectoescritura
		* PlantasCursiva	Ejercicios lectoescritura
		* NombresCursiva	Ejercicios lectoescritura
		* TiposLectoEscritura Tipografía
		* asigna		Asigna horario
		* markup		Librería para xml
		* repasa		Para repasar contenidos
		* sigue		Manejar calificaciones
		* Mt77		Buscador
		* sivel 1.2	Sistema de Información de violencia política
		* sivel 2.0	Versión en desarrollo

