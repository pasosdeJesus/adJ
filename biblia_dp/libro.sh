#!/bin/sh
# Genera distribuci�n de fuentes de un libro o un grupo de libros
# Dominio p�blico. Sin garant�as. 2004. vtamara@infomatik.uni-kl.de

dir=$1;
pry=$2;
desc=$3;
fuentes=$4;
tipoestilo=$5;
gutnum=$6;
gutdate=$7;
imagenes=$8;

if (test "$dir" = "") then {
	echo "Falta directorio como primer par�metro";
	exit 1;
} fi;

if (test "$pry" = "") then {
	echo "Falta nombre corto del proyecto como segundo par�metro";
	exit 1;
} fi;

if (test "$desc" = "") then {
	echo "Falta descripci�n del libro como tercer par�metro";
	exit 1;
} fi;

if (test "$fuentes" = "") then {
	echo "Faltan fuentes como cuarto par�metro";
	exit 1;
} fi;

if (test "$tipoestilo" != "1ev" -a "$tipoestilo" != "4ev") then {
	echo "Quinto par�metro debe ser tipo de estilo (1ev o 4ev)";
	exit 1;
} fi;

if (test "$gutnum" = "") then {
	echo "Falta n�mero Gutenberg como sexto par�metro";
	exit 1;
} fi;

if (test "$gutdate" = "") then {
	echo "Falta fecha de publicaci�n en Gutenberg como septimo par�metro";
	exit 1;
} fi;

guturl=`echo $gutnum | sed -e "s|^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\).*|http://www.gutenberg.net/\1/\2/\3/\4/&|g"`;

version="";

extdbk=xdbk

function neln {
	pwd=`pwd`;
	if (test -d $2 -o ! -f $2) then {
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
		sed -e "s|biblia_dp|$pry|g;s|Biblia de dominio p�blico|$desc|g;s|PRY_DESC=\"[^\"]*\"|PRY_DESC=\"$desc\"|g;s|SOURCE_GBFXML=.*|SOURCE_GBFXML=$fuentes|g;s|IMAGES=.*|IMAGES=$imagenes|g;s|Traducci�n a espa�ol de la Biblia|Traducci�n a espa�ol|g;s|PRY_VERSION=\"[^\"]*\"|PRY_VERSION=\"$version\"|g;s|GUTNUM=.*|GUTNUM=\"$gutnum\"|g;s|GUTDATE=.*|GUTDATE=\"$gutdate\"|g;s|GUTURL=.*|GUTURL=\"$guturl\"|g" $1 > $2
	} fi
}

nd=$dir/$pry

mkdir -p $nd
mkdir -p $nd/img
mkdir -p $nd/gutenberg
mkdir -p $nd/ispell

for i in $fuentes ; do 
	v=`grep "<credits.*version" $i | sed -e "s/^.*version=\"\([^\"]*\)\".*$/\1/g"`;
	if (test "$version" = "" -a "$v" != "") then {
		version=$v;
	} fi;
	echo "$i ($v)";
	neln $i $nd;
done

for i in $imagenes ; do 
	echo $i;
	neln $i $nd;
done

neln conf.sh $nd/conf.sh
neln docbookrep_html.xsl $nd/docbookrep_html.xsl
neln docbookrep_tex.dsl $nd/docbookrep_tex.dsl
neln docbookrep_html.dsl $nd/docbookrep_html.dsl
nesed Leame.txt $nd/Leame.txt
nesed Instala.txt $nd/Instala.txt
nesed Creditos.txt $nd/Creditos.txt
nesed Novedades.txt $nd/Novedades.txt
nesed Desarrollo.txt $nd/Desarrollo.txt
nesed estilos/estilo-$tipoestilo.dsl $nd/estilo.dsl
nesed estilos/estilohtml-$tipoestilo.xsl $nd/estilohtml.xsl
nesed confv.empty $nd/confv.empty
nesed Makefile $nd/Makefile
nesed Derechos.txt $nd/Derechos.txt
neln derechos.gbfxml $nd
neln biblio.gbfxml $nd
neln biblia_dp.css $nd/$pry.css
neln gbfxml2db.xsl $nd
neln gbfxml2html.xsl $nd
neln gbfxml.dtd $nd
neln gutenberg/Readme.txt $nd/gutenberg
neln gutenberg/footer.inc $nd/gutenberg
neln ispell/$pry.ispell $nd/ispell
neln img/blank.png $nd/img/
neln img/caution.png $nd/img/
neln img/draft.png $nd/img/
neln img/home.png $nd/img/
neln img/important.png $nd/img/
neln img/next.png $nd/img/
neln img/note.png $nd/img/
neln img/prev.png $nd/img/
neln img/tip.png $nd/img/
neln img/toc-blank.png $nd/img/
neln img/toc-minus.png $nd/img/
neln img/toc-plus.png $nd/img/
neln img/up.png $nd/img/
neln img/warning.png $nd/img/

if (test ! -d $dir/herram) then {
	mkdir $nd/herram
	ln -s $pwd/herram/* $nd/herram
	rm -f $nd/herram/CVS
} fi;


# Generaci�n de libro
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

