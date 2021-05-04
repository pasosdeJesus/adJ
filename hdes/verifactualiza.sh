#!/bin/sh
# Verifica si los paquetes disponibles para distribucion
# están actualizados respecto a posibilidades de /usr/ports

. ./ver.sh

echo "V=$V$VESP";
for i in `cd $V$VESP-amd64/paquetes/; ls`; do 
	paq=`echo $i | sed -e "s/\(.*\)-\([0-9][0-9a-zA-Z_.]*\)\(.*\).tgz/\1/g"`
	ver=`echo $i | sed -e "s/\(.*\)-\([0-9][0-9a-zA-Z_.]*\)\(.*\).tgz/\2/g"`
	paqsesp=`echo $paq | sed -e "s/\+/./g"`
	verpor=`(cd /usr/ports; make search name="^$paqsesp-[0-9]" | grep Port | sed -e "s/.*-\([0-9][0-9a-zA-Z_.]*\).*/\1/g" | uniq | tr "\n" " ")` # | tr "\n" " ")`
	if (test "${verpor#*$ver}" = "$verpor") then {
		echo "Paquete: $paq ($paqsesp).   En directorio paquetes $ver.   En portes $verpor"
	} fi;
done
