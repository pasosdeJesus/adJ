#!/usr/bin/env ksh

# Script genérico para preparar herramientas de DocBook y configurar.
# Esta fuente se cede al dominio público 2003. No se ofrecen garantías.
# Puede enviar reportes de fallas a structio-info@lists.sourceforge.net

# Créditos
# Manejo de variables de configuración: Miembros de Structio.  
#	http://structio.sourceforge.net/
# Línea de comandos: WWWeb Tide Team 
#	http://www.ebbtide.com/Util/ksh_parse.html 
# que también es de dominio público de acuerdo a http://www.ebbtide.com/Util/
# "The following utilities have been written by the members of WWWeb Tide 
# Team. We considered them to be infinitely useful in every day systems and 
# web site administration. So much so, in fact, we have decided to put the 
# sources in the public domain." 


# Leyendo variables de configuración
if (test ! -f confv.sh) then {
        cp confv.empty confv.sh
} fi;

. ./confv.sh


# Leyendo funciones para ayudar en configuración
. herram/confaux.sh
. herram/misc.sh

# Reconociendo línea de comandos

BASENAME=$(basename $0)
USAGE="$BASENAME [-v] [-h] [-M] [-p prefijo]"
# Remember: if you add a switch above, don't forget to add it to: 
#	1) "Parse command line options" section 
#	2) "MANPAGE_HEREDOC" section
#	3) "check for help" section
ARG_COUNT=0 	# This nubmer must reflect true argument count
OPT_FLAG=0 	# Command line mistake flag
OPT_COUNT=0	# Number of options on the command line
MAN_FLAG=0 	# Default: no man pages requited
HELP_FLAG=0	# Default: no help required
VERBOSE_FLAG=0 	# Default: no verbose
WARNING=0 	# General purpose no fail warning flag

# initialize local variables
vbs=""
prefix="/usr/local"

# Parse command line options
while getopts :p:Mhv arguments 
do
   # remember treat r: switches with: R_VALE = $OPTARG ;;
   case $arguments in
      p)    prefix=$OPTARG;;
      M)    MAN_FLAG=1 ;;		# Display man page
      v)    # increment the verboseness count and...
	    VERBOSE_FLAG=$(($VERBOSE_FLAG+1))
	    # gather up all "-v" switches
	    vbs="$vbs -v"
	    ;;
      h)    HELP_FLAG=1;;		# display on-line help
      \?)   echo "Opción no reconocida: $OPTARG" >&2	# flag illegal switch 
	    OPT_FLAG=1;;
   esac
done
OPT_COUNT=$(($OPTIND-1))
shift $OPT_COUNT

options_help="
   -p prefijo	Prefijo de la ruta de instalación (por defecto /usr/local)
   -h           Presenta ayuda corta
   -M           Presenta ayuda más completa
   -v           Presenta información de depuración durante ejecución"
 
# check for man page request
if (test "$MAN_FLAG" = "1" ) then {
	if (test "$PAGER" = "" ) then {
		if ( test "$VERBOSE_FLAG" -gt "0" ) then {
			echo "$BASENAME: Resetting PAGER variable to more" >&2

	       	} fi;
	       	export PAGER=more;
	} fi;
	$PAGER << MANPAGE_HEREDOC

NOMBRE

	$BASENAME - Configura fuentes de $PROYECTO

	$USAGE


DESCRIPCIÓN

	Establece el valor de las variables de configuración y genera
	archivos en diversos formatos empleados por las fuentes DocBook
	con ayudas de 'repasa' del proyecto $PROYECTO:
	* $PRY_DESC
	* $URLSITE

	Las variables de configuración y sus valores por defecto están
	en confv.empty (debajo de cada variable hay un comentario con la 
	descripción).
	Este script modifica el archivo confv.sh (o de no existir lo crea
        a partir de confv.empty) y genera los archivos Make.inc y confv.ent 
	con las variables de configuración instanciadas.  
	Para la instanciación este tiene en cuenta:
	* Detecta procesadores para hojas de estilo  DocBook, hojas de estilo 
	  y de requerirse verifica sus versiones (Jade, OpenJade, xsltproc)
	* Adapta métodos de generación (por defecto prefiere emplear xsltproc
	  para generar HTML, OpenJade para generar PostScript y ps2pdf para
	  generar PDF).
	* Detecta herramientas auxiliares empleadas para la generación y
	  operación (e.g collateindex, dvips, convert, ps2pdf, awk, sed)
	* Detecta herraminetas opcionales que pueden servir para la
	  actualización del proyecto en Internet  (ncftpput o scp)
	* Actualiza fecha del proyecto de algún programa).
	
	Si este script no logra completar alguna detección, indicará el 
	problema, junto con la posible ayuda que se haya configurado en
	confv.empty y permitirá ingresar directamente la información o
	cancelar para reanudar posteriormente.

	De requerirlo sumerce puede cambiar directamente los valores detectados
	modificando el archivo confv.sh y ejecutando nuevamente ./conf.sh.

OPCIONES

$options_help


EJEMPLOS

	./conf.sh
	Configura fuentes y deja como prefijo para la ruta de instalación 
	"/usr/local"

	./conf.sh -p /usr/
	Configura fuentes y deja como prefijo para la ruta de instalación
	"/usr"


ESTÁNDARES
	Este script pretende ser portable. Debe cumplir POSIX.


FALLAS
	

VER TAMBIÉN
	Para mejorar este script o hacer uno similar ver fuentes de 
	herram/confaux.sh


CRÉDITOS Y DERECHOS DE REPRODUCCIÓN 

 	Script de dominio público.  Sin garantías.
	Fuentes disponibles en: http://structio.sourceforge.net/repasa
	Puede enviar reportes de problemas a 
		structio-info@lists.sourceforge.net

	Incluye porciones de código dominio público escritas por:
	  Miembros de Structio http://structio.sourceforge.net
	  WWWeb Tide Team http://www.ebbtide.com/Util/
	Puede ver más detalles sobre los derechos y créditos de este script en
	las fuentes.
MANPAGE_HEREDOC
   exit 0;
} fi;

# check for help
if (test "$HELP_FLAG" = "1" ) then {
   echo " Utilización: $USAGE"
   cat << HLP_OP
$options_help
HLP_OP
   exit 0
} fi;

# check for illegal switches
if (test "$OPT_FLAG" = "1") then {
   echo "$BASENAME: Se encontró alguna opción invalida" >&2
   echo "Utilización: $USAGE" >&2
   exit 1
}
elif (test "$#" != "$ARG_COUNT" ) then {
   echo "$BASENAME: se encontraron $# argumentos, pero se esperaban $ARG_COUNT." >&2
   echo "Utilización: $USAGE" >&2
   exit 1;
} fi;

echo "Configurando $PROYECTO $PRY_VERSION";

if (test "$prefix" != "") then {
        INSBIN="$prefix/bin";
        changeVar INSBIN 1;
        INSDOC="$prefix/share/doc/$PROYECTO";
        changeVar INSDOC 1;
	INSDATA="$prefix/share/$PROYECTO";
	changeVar INSDATA 1;
} fi;


if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Chequeando y detectando valor de variables de configuración";
} fi;
check "JADE" "" "test -x \$JADE" `which jade 2> /dev/null` `which openjade 2> /dev/null`
check "JADETEX" "" "test -x \$JADETEX" `which jadetex 2> /dev/null`
check "PDFJADETEX" "" "test -x \$PDFJADETEX" `which pdfjadetex 2> /dev/null`
check "XMLLINT" "" "test -x \$XMLLINT" `which xmllint`
check "XSLTPROC" "optional" "test -x \$XSLTPROC" `which xsltproc`
if (test -x $XSLTPROC) then {
	verxsltproc=`xsltproc -V | head -n 1 | sed -e "s/.*libxslt \([0-9]*\) .*/\1/g"`
	if (test "$verxsltproc" -lt "10019") then {
		echo "Se requiere xsltproc 1.0.19 o superior (versiones anteriores presentan errores con imagenes de DocBook XML 4.1.2)";
		echo "Empleando jade como segunda opción";
		HTML_PROC=dbrep_html_jade;
        	changeVar HTML_PROC 1;
	} fi;
} elif (test "$HTML_PROC" = "dbrep_html_xsltproc") then {
	HTML_PROC=dbrep_html_jade;
	changeVar HTML_PROC 1;
} fi;
check "DVIPS" "" "test -x \$DVIPS" `which dvips 2> /dev/null`
check "PS2PDF" "" "test -x \$PS2PDF" `which ps2pdf 2> /dev/null`

check "DOCBOOK_XML_DIR" "" "test -f \$DOCBOOK_XML_DIR/docbookx.dtd" "/usr/local/share/xml/docbook/4.2" "/usr/local/share/xml/docbook/4.1.2" "/usr/share/sgml/docbook/dtd/xml/4.1.2" "/usr/share/sgml/docbook/dtd/4.2/"
check "DOCBOOK_DSSSL" "optional" "test -f \$DOCBOOK_DSSSL/html/docbook.dsl" "/usr/local/share/sgml/docbook/dsssl/modular/" "/usr/share/sgml/docbook/stylesheet/dsssl/modular/"
check "CATALOG_DSSSL" "" "test -f \$CATALOG_DSSSL" "/usr/local/share/sgml/catalog" "/etc/sgml/catalog"
check "SGML_XML" "" "test -f \$SGML_XML" "$DOCBOOK_DSSSL/dtds/decls/xml.dcl" "/usr/share/sgml/declaration/xml.dcl"
check "DOCBOOK_XSL" "optional" "test -f \$DOCBOOK_XSL/html/docbook.xsl" "/usr/local/share/xml/docbook-xsl" "/usr/share/sgml/docbook/stylesheet/xsl/nwalsh" "/usr/local/share/xsl/docbook/"
if (test "$HTML_PROC" = "dbrep_html_jade" -o "$HTML_PROC" = "dbrep_html_jade_single") then {
	echo "jade"
}
elif (test -f $DOCBOOK_XSL/html/docbook.xsl) then {
        isfm=`grep "<fm:project>" $DOCBOOK_XSL/VERSION`;
        if (test "$isfm" != "") then {
                v=`grep "fm:Version>" $DOCBOOK_XSL/VERSION | sed -e "s|.*fm:Version>\([.0-9]*\)</fm:Version.*|\1|g"`;
        } else {
                v=`grep -i "VERSION\"" $DOCBOOK_XSL/VERSION | tr [a-z] [A-Z] | sed -e "s/^.*VERSION[^>]*>\([0-9]*[.][0-9]*\)[.].*$/\1/g"`;
        } fi;
	if (test "$v" = "") then {
		echo "** Falta archivo VERSION en directorio $DOCBOOK_XSL";
		exit 1;
	} 
	elif (test ! -f $DOCBOOK_XSL/manpages/docbook.xsl) then {
		echo "** La distribución de las hojas de estilo para DocBook que está empleando no incluye soporte para generar páginas man. Instale una versión reciente (http://docbook.sourceforge.net) y configure la ruta en la variable DOCBOOK_XSL del archivo confv.sh";
		exit 1;
	} 
	elif (ltf "$v" "1.56" -a "$HTML_PROC" = "dbrep_html_xsltproc") then {
		echo "Se requieren hojas de estilo XSL versión 1.56 o posterior";
		echo "Empleando jade como segunda opción"
		HTML_PROC=dbrep_html_jade;
		changeVar HTML_PROC 1;
	} fi;
} 
elif (test "$HTML_PROC" = "dbrep_html_xsltproc") then {
	echo "No se encontraron hojas XSL de DocBook, empleando jade como segunda opción"
	HTML_PROC=dbrep_html_jade;
	changeVar HTML_PROC 1;
} fi;

check "REPASA_DOCBOOK_XSL_HTML" "" "test -f \$REPASA_DOCBOOK_XSL_HTML" 'docbookrep_html.xsl'
check "PAPEL" "" "test x\$PAPEL != x" 'letter' 'legal' 'a4'
check "PS_PROC" "" "test x\$PS_PROC != x" 'dbrep_ps_jade'
check "PDF_PROC" "" "test x\$PDF_PROC != x" 'dbrep_pdf_ps'

check "COLLATEINDEX" "optional" "test -f \$COLLATEINDEX" "/usr/local/share/sgml/docbook/dsssl/modular/bin/collateindex.pl" "/usr/share/sgml/docbook/dsssl/nwalsh-modular/bin/collateindex.pl" "/usr/bin/collateindex.pl" `which collateindex.pl`

if (test "$ACT_PROC" = "act-ncftpput") then {
	check "NCFTPPUT" "optional" "test -x \$NCFTPPUT" `which ncftpput 2> /dev/null`
} 
elif (test "$ACT_PROC" = "act-scp") then { 
	check "SCP" "optional" "test -x \$SCP" `which scp 2> /dev/null`
} fi;


check "CONVERT" "" "test -x \$CONVERT" `which convert 2> /dev/null`
check "DOT" "optional" "test -x \$DOT" `which dot 2> /dev/null`
check "FIG2DEV" "optional" "test -x \$FIG2DEV" `which fig2dev 2> /dev/null`

check "AWK" "" "test -x \$AWK" `which awk 2> /dev/null`
check "CP" "" "test -x \$CP" `which cp 2> /dev/null`
check "CVS" "optional" "test -x \$CVS" `which cvs 2> /dev/null`
check "DOT" "optional" "test -x \$DOT" `which dot 2> /dev/null`
check "ED" "" "test -x \$ED" `which ed 2> /dev/null`
check "FIG2DEV" "optional" "test -x \$FIG2DEV" `which fig2dev 2> /dev/null`
check "FIND" "" "test -x \$FIND" `which find 2> /dev/null`
check "GZIP" "" "test -x \$GZIP" `which gzip 2> /dev/null`
check "ISPELL" "optional" "test -x \$ISPELL" `which ispell 2> /dev/null`
check "MAKE" "" "test -x \$MAKE" `which make 2> /dev/null`
check "MV" "" "test -x \$MV" `which mv 2> /dev/null`
check "MKDIR" "" "test -x \$MKDIR" `which mkdir 2> /dev/null`
check "PERL" "optional" "test -x \$PERL" `which perl 2> /dev/null`
check "RM" "" "test -x \$RM" `which rm 2> /dev/null`
check "SED" "" "test -x \$SED" `which sed 2> /dev/null`
check "TAR" "" "test -x \$TAR" `which tar 2> /dev/null`
check "TIDY" "optional" "test -x \$TIDY" `which tidy 2> /dev/null`
check "TOUCH" "" "test -x \$TOUCH" `which touch 2> /dev/null`

# Corrección ortografica
check "W3M" "optional" "test -x \$W3M" `which w3m 2> /dev/null` `which lynx 2> /dev/null`
l=`echo $W3M | sed -e "s|.*lynx.*|si|g"`
W3M_OPT=""; 
if (test "$l" = "si") then {
	W3M_OPT="-nolist";
} fi;
changeVar W3M_OPT 1;

check "ZIP" "optional" "test -x \$ZIP" `which zip 2> /dev/null`

check "PAPEL" "" "test x\$PAPEL != x" 'letter' 'a4' 'legal'
check "REPASA_DOCBOOK_XSL_HTML" "" "test x\$REPASA_DOCBOOK_XSL_HTML != x" 'docbookrep_html.xsl'
check "PS_PROC" "" "test x\$PS_PROC != x" 'dbrep_ps_jade' 
check "PDF_PROC" "" "test x\$PDF_PROC != x" 'dbrep_pdf_ps'



FECHA_ACT=`date "+%d/%m/%Y"`;
changeVar FECHA_ACT 1;
m=`date "+%m" | sed -e "s/01/Enero/;s/02/Febrero/;s/03/Marzo/;s/04/Abril/;s/05/Mayo/;s/06/Junio/;s/07/Julio/;s/08/Agosto/;s/09/Septiembre/;s/10/Octubre/;s/11/Noviembre/;s/12/Diciembre/"`
a=`date "+%Y"`
MES_ACT="$m de $a";
changeVar MES_ACT 1;

s=`echo $HTML_PROC | sed -e "s/.*single.*/1/g"`;
if (test "$s" = "1") then {
	db_html="docbook.xsl";	
}
else {
	db_html="chunk.xsl";
} fi;

if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Guardando variables de configuración";
} fi;
changeConfv;

if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Generando Make.inc";
} fi;

echo "# Algunas variables para el Makefile" > Make.inc;
echo "# Este archivo es generado automáticamente por conf.sh. No editar" >> Make.inc;
echo "" >> Make.inc

# Adding configuration variables to Make.inc
addMakeConfv Make.inc;
echo "PREFIX=$prefix" >> Make.inc

if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Generando confv.ent"
} fi;
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > confv.ent
echo "<!-- Variables de configuración  -->" >> confv.ent
echo "<!-- Este archivo es generado automáticamente por conf.sh. No editar -->" >> confv.ent
echo "<!ENTITY DOCBOOK-XSL-HTML \"$db_html\">" >> confv.ent

addXMLConfv confv.ent;

if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Creando directorios auxiliares"
} fi;
mkdir -p html
mkdir -p imp

if (test "$VERBOSE_FLAG" -gt "0") then {
	echo "Cambiando ruta de awk en script"
} fi;
echo ",s|/usr/bin/awk|$AWK|g
w
q
" | ed herram/db2rep 2> /dev/null

if (test ! -f personaliza.ent -a -f personaliza.ent.plantilla) then {
	cp personaliza.ent.plantilla personaliza.ent
} fi;

echo "Configuración completada";

