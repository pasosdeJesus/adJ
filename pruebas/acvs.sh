#! /bin/sh
# Agrega repositorio CVS de fuentes


nd="$1"
if (test "$nd" = "" -o ! -d "$nd/CVS") then {
	echo "Primer parámetro es directorio de fuentes de OpenBSD al cual agregarle Root en directorios CVS"
	exit 1;
} fi;

if (test ! -f "./ver.sh") then {
	echo "Ejecutar desde directorio con fuentes de adJ";
	exit 1;
} fi;

. ./ver.sh

for i in `find $nd -name "CVS" `; do 
	echo "$USUARIOCVS@$MAQCVS:$DIRCVS" > $i/Root; 
done
