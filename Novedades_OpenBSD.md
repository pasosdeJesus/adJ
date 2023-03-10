Con respecto a OpenBSD 7.3 las novedades son:

* Proceso de Instalación:
	* En español (upgrade install install.sub)
	* Organización del CD de instalación diferente

* Kernel
	* Palabra daemon renombrada por servicio ver 
	<http://aprendiendo.pasosdejesus.org/?id=Renombrando+Daemon+por+Service>
	* Nombre de compilación del kernel reportado por uname 
	  APRENDIENDODEJESUS

* Herramientas de compilación fundamentales
  * Encabezados de gcc y clang modificados para definir 
    símbolo \_\_adJ\_\_ que identifica compilaciones en el sistema 
    operativo. Facilita uso de xlocale y características únicas de 
    adJ respecto a OpenBSD en algunos portes --como libunistring.

* Modificaciones a librería fundamental `libc`:
  * OpenBSD soporta unicamente codificaciones ASCII y UTF-8,
    adJ soporta más codificaciones, aunque la única que se
    ha probado extensivamente (además de ASCII y UTF-8) es ISO8859-1.
	* adJ tiene soporte completo para localizaciones (fecha y hora, cantidades,
	  cantidades monetarias, cotejación y ordenamiento) y xlocale.
    Así mismo cuenta con páginas del manual completas para las diversas
    funciones de xlocale.
  * C++ moderno depende de xlocale, por lo que diversos programas
    recientes en C++ podrán compilarse con más facilidad en adJ.
  * Aumentados descriptores de archivos de 2^15 a 2^63
    (La limitacíon de 32767 descriptores de archivos está en
     OpenBSD y en FreeBSD). Este cambio implica que no hay
     garantía en compatibilidad de binarios entre OpenBSD y adJ.
     En genereal la habrá, excepto en programas que usen macros
     que referencien estructura de FILE como `__sfileno`.
     Detalles en <https://github.com/pasosdeJesus/adJ/issues/8>


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
		* pkg_*		Permiten caracteres en español en descripciones
		* Muchos otros cambiando daemon por servicio
	* Archivos de órdenes nuevos en /usr/local/adJ/
		* resto-altroot.sh     para copiar resto de particiones altroot
		  ver <http://dhobsd.pasosdejesus.org/Respaldo_altroot.html>
		* amplia-vnd.sh 	Amplia tamaño de imagen cifrada para 
		  vnd
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
	* Páginas del manual nuevas:
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
	* Archivos de configuración en /etc
		* X11/xenodm/pixmas/adJ_*.xpm	Logo
		* signify/adJ-*.pub	Llaves criptográficas
		* En la mayoría de casos daemon remplazado por servicio
	* Archivos de configuración de ejemplo en /usr/local/shar/examples/adJ
		* varcorreo.sh	Usado por adicuenta	
		* varmonitorea.sh	Usar por monitorea

* Paquetes
	* Retroportados para cerrar fallas y/o actualizar y/o usar xlocale:
    ruby-3.2
    postgresql-server-14.4, postgresql-client, postgresql-contrib, 
    postgresql-docs, postgresql-previous, postgis-3.1.4
	* Se recompilaron de portes estables recientes para cerrar 
	  fallas o usar xlocale: 
    chromium, curl, dovecot, dtc, firefox-esr, flac, gnutls, libssh, 
    libxml, libxslt, lz4, mariadb-client, mariadb-server, mutt, node-12.22.9p0,
    python 2.7.18p3 y 3.8.12, php 8.0.16, rsync, samba, webkitgtk4, zsh
	* Recompilados todos los paquetes de perl
	* Modificados o recompilados para usar xlocale
		* glib2, libunistring, vlc
	* Adaptados de portes estables pero mejorados para adJ:
		* colorls	Ordena alfabeticamente de acuerdo a locale
		* hexedit 	Soporta tamaños de archivos más grandes
		* xfe		Soporta paquetes tgz
    * ocaml 4.12, ocamlbuild, findlib, dune, hevea
	* Unicos en adJ 
		* emulators/realboy , textproc/biblesync
		textproc/sword textproc/bibletime 
		x11/fbdesk textproc/po4a textproc/p5-SGMLNpm
	* Únicos en adJ liderados por Pasos de Jesús
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
		* Mt77		Buscador
		* sivel 2.0	Sistema de Información de violencia política

