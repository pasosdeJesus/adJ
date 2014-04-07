#!/bin/sh
# Aplica parches hasta el dado en línea de comandos

SRC=/usr/src
p=$1;
if (test ! -f "$p") then {
	echo "Falta parche como primer parámetro";
	exit 1;
} fi;

aplica=1;
e=`basename $p`;
d=`dirname $p`;
lista=`ls $d/*patch`
for i in $lista; do 
	if (test "$aplica" = "1") then {
		echo $i;
		pruebas/aplica.sh $i
		if (test "$?" != "0") then {
			exit 1;
		} fi;
	} fi;
	ae=`basename $i`;
	if (test "$ae" = "$e") then {
		aplica=0;
	} fi;
done


