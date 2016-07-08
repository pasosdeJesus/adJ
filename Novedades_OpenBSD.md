Con respecto a OpenBSD 5.8 las novedades son:

* Proceso de Instalación:
	* upgrade install install.sub 	En español
	* Organización del CD de instalacińo diferente

* Kernel
	* Palabra daemon renombrada por service ver 
	<http://aprendiendo.pasosdejesus.org/?id=Renombrando+Daemon+por+Service>
	* Nombre de compilación del kernel reportado por uname APRENDIENDODEJESUS

* Sistema Base
	* Binarios nuevos en /usr/bin/
		* colldef 	Para generar cotejación de locales
		* localedef 	Para generar archivos de locale
		* rsync-adJ 	Para descargar versiones nuevas
	* Archivos de órdenes nuevos en /usr/sbin/
		* adicuenta 	Agrega cuenta de correo 
		* auditabitaco
		* ras Audita bitacoras de /var/log
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
		* reflejazona.sh 	A partir de una zona dns maestra genera reflejo
		* repadicuenta.sh Ejecuta adicuenta para todo usuario
		* revisaapachelog.pl Revisa bitácora de Apache
		* revisaauthlog.pl Revisa bitácora authlog
		* rutinas.sh	Diversas rutinas para archivos de ord.
		* servicio-etc.sh	Cambia daemon por servicio en /etc
	* Páginas del manual nuevas en /usr/shar/man/man3
		* gctype_l gdigittoint_l gduplocale gfreelocale gisalnum_l,
		gisalpha_l gisascii_l gisblank_l giscntrl_l gisdigit_l
		gisgraph_l gishexnumber_l gisideogram_l gislower_l gisnumber_l
		gisphonogram_l gisprint_l gispunct_l gisrune_l gisspace_l
		gisspecial_l gisupper_l giswalnum_l giswalpha_l giswblank_l
		giswcntrl_l giswctype_l giswdigit_l giswgraph_l giswideogram_l
		giswlower_l giswnumber_l giswphonogram_l giswprint_l 
		giswpunct_l giswrune_l giswspace_l giswspecial_l giswupper_l
		giswxdigit_l gisxdigit_l gmblen_l gmbrtowc_l gmbsinit_l
		gmbsnrtowcs_l gmbsrtowcs_l gmbstowcs_l gmbtowc_l gnewlocale
		gnextwctype gnextwctype_l gquerylocale gservicio gstrcasecmp_l
		gstrcasestr_l gstrcoll_l gstrfmon_l gstrncasecmp_l gstrxfrm_l
		gtolower_l gtoupper_l gtowctrans_l gtowlower_l gtowupper_l
		guselocale gwcscoll gwcsnrtombs_l gwcsrtombs_l gwcstombs_l
		gwcsxfrm gwctob_l gwctomb_l gwctype_l gxlocale
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
	* Recompilados de portes estables para cerrar fallas
		* a2ps cups-filters freetds gnutls jasper libxml
		mariadb-client mariadb-server net-snmp owncloud 
		p5-Mail-SpamAssassin png postgis qemu
	
	* Recompilados de portes estables para usar xlocale y cerrar fallas
		* postgresql-client postgresql-server postgresql-contrib 
		postgresql-docs boost djvulibre gettext-tools ggrep
		gdk-pixbuf glib2 gtar libidn libunistring libxslt 
		llvm scribus vlc wget wxWidgets-gtk2

	* Adaptados de portes estables pero mejorados para adJ:
		* xfe		Soporta paquetes tgz
		* hexedit 	Soporta tamaños de archivos más grandes

	* Retroportados de versión posterior cerrar fallas o actualizar (aunque existen en actual)
		* chromium node openldap-client py-openssl py-zopeinterface ruby 

	* Retroportados de versión posterior que no existen en actual
		* security/letsencrypt devel/py-configargparse devel/py-parsedatetime 
		devel/py-python2-pythondialog devel/py-zopecomponent devel/py-zopeevent
		sysutils/py-psutil textproc/py-pyRFC3339/ www/py-ndg-httpsclient

        * Actualizados, pues están desactualizado en OpenBSD estable y current
		* php php-bz2 php-curl php-fpm php-gd php-intl php-ldap 
		php-mcrypt php-mysqli- php-pdo_pgsql php-pgsql php-zip
		pear-Auth pear-DB_DataObject
       		
	* Unicos en adJ 
		* emulators/realboy lang/ocaml-labltk sysutils/ganglia 
		textproc/sword textproc/xiphos www/pear-HTML-Common
		www/pear-HTML-Common2 www/pear-HTML-CSS www/pear-HTML-Javascript
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

