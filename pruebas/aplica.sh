#!/bin/sh
# Aplica un parche dado por línea de comandos

SRC=/usr/src
p=$1;
if (test ! -f "$p") then {
	echo "Falta parche como primer parámetro";
	exit 1;
} fi;

r=`find $SRC/ -name "*rej"`
if (test "$r" != "") then {
	echo "Sin procesar porque hay estos rechazados $r";
	exit 1;
} fi;
n=`basename $p`
cp $p $SRC/
cd $SRC
patch -p1 < $n
r=`find $SRC/ -name "*rej"`
if (test "$r" != "") then {
	echo "Rechazados: $r";
	exit 1;
} fi;

