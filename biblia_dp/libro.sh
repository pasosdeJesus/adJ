#!/bin/sh

dir=$1;
pry=$2;
desc=$3;
fuentes=$4;
gutnum=$5;
gutdate=$6;
imagenes=$7;

if (test "$dir" = "") then {
	echo "Falta directorio como primer parámetro";
	exit 1;
} fi;

if (test "$pry" = "") then {
	echo "Falta nombre corto del proyecto como segundo parámetro";
	exit 1;
} fi;

if (test "$desc" = "") then {
	echo "Falta descripción del libro como tercer parámetro";
	exit 1;
} fi;
if (test "$fuentes" = "") then {
	echo "Faltan fuentes como cuarto parámetro";
	exit 1;
} fi;

if (test "$gutnum" = "") then {
	echo "Falta número Gutenberg como quinto parámetro";
	exit 1;
} fi;

if (test "$gutdate" = "") then {
	echo "Falta fecha de publicación en Gutenberg como sexto parámetro";
	exit 1;
} fi;

guturl=`echo $gutnum | sed -e "s|^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\).*|http://www.gutenberg.net/\1/\2/\3/\4/&|g"`;

version="";

extdbk=xdbk

function neln {
	pwd=`pwd`;
	if (test ! -f $2) then {
		ln -s $pwd/$1 $2
	} fi
}

function necp {
	if (test ! -f $2) then {
		cp $1 $2
	} fi
}

function nesed {
	if (test ! -f $2) then {
		sed -e "s|biblia_dp|$pry|g;s|PRY_DESC=\"[^\"]*\"|PRY_DESC=\"$desc\"|g;s|SOURCE_GBFXML=.*|SOURCE_GBFXML=$fuentes|g;s|IMAGES=.*|IMAGES=$imagenes|g;s|Traducción a español de la Biblia|Traducción a español|g;s|PRY_VERSION=\"[^\"]*\"|PRY_VERSION=\"$version\"|g;s|GUTNUM=.*|GUTNUM=\"$gutnum\"|g;s|GUTDATE=.*|GUTDATE=\"$gutdate\"|g;s|GUTURL=.*|GUTURL=\"$guturl\"|g" $1 > $2
	} fi
}

nd=$dir/$pry

mkdir -p $nd
mkdir -p $nd/img
mkdir -p $nd/gutenberg
mkdir -p $nd/ispell

for i in $fuentes ; do 
	v=`grep "<credits.*version" $i | sed -e "s/^.*version=\"\([^\"]*\)\".*$/\1/g"`;
	if (test "$v" != "") then {
		version=$v;
	} fi;
	echo "$i ($version)";
	neln $i $nd;
done

for i in $imagenes ; do 
	echo $i;
	neln $i $nd;
done

neln conf.sh $nd/conf.sh
neln docbookrep_html.xsl $nd/docbookrep_html.xsl
neln docbookrep_tex.dsl $nd/docbookrep_tex.dsl
nesed Leame.txt $nd/Leame.txt
nesed Desarrollo.txt $nd/Desarrollo.txt
nesed estilo.dsl $nd/estilo.dsl
nesed estilohtml.xsl $nd/estilohtml.xsl
nesed confv.empty $nd/confv.empty
nesed Makefile $nd/Makefile
nesed Derechos.txt $nd/Derechos.txt
neln derechos.gbfxml $nd
neln biblio.gbfxml $nd
neln gbfxml2db.xsl $nd
neln gbfxml.dtd $nd
neln gutenberg/Readme.txt $nd/gutenberg
neln gutenberg/footer.inc $nd/gutenberg
neln ispell/$pry.ispell $nd/ispell
neln img/*.png $nd/img/

if (test ! -d $dir/herram) then {
	mkdir $nd/herram
	ln -s $pwd/herram/* $nd/herram
	rm -f $nd/herram/CVS
} fi;


# Generación de libro
echo '<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE gbfxml SYSTEM "gbfxml.dtd" [
<!ENTITY % confv SYSTEM "confv.ent">
%confv;
<!ENTITY derechos SYSTEM "derechos.gbfxml">' > $nd/$pry.gbfxml
for i in $fuentes ; do
	echo "<!ENTITY $i SYSTEM \"$i\">" >> $nd/$pry.gbfxml;
done
echo '<!ENTITY biblio SYSTEM "biblio.gbfxml">
]>

<gbfxml version="1.0" lang="es">
<tt>&PRY-DESC;</tt>
<stt>&PROYECTO;</stt>
&derechos;' >> $nd/$pry.gbfxml

for i in $fuentes ; do
	echo "&$i;" >> $nd/$pry.gbfxml;
done

echo '&biblio;
</gbfxml>' >> $nd/$pry.gbfxml

