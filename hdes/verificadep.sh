#!/bin/sh
# Verifica que todas las dependencias de los paquetes de un directorio
# estén resueltas en el mismo directorio.
# Dominio público. Sin garantías. 2005. vtamara@pasosdejesus.org

. ./ver.sh



echo "Verificando cantidad de copias por paquete";
pausa=0;
ls $V$VESP-$ARQ/paquetes/ > /tmp/1
for i in `cat /tmp/1`; do  n=`echo $i | sed -e "s/-[0-9].*//g"`; c=`grep "^$n-[0-9]" /tmp/1 | wc -l | sed -e "s/ *//g"`; if (test "$c" != 1) then { echo "Cantidad de $n errada: $c"; pausa=1; } fi; done

if (test "$pausa" != "0") then {
	echo "[ENTER] para continuar";
	read;
} fi;


echo "Verificando dependencias";
lp=`cd $V$VESP-$ARQ/paquetes/; ls *tgz`;
for j in $lp; do 
    echo $j;
    for i in `pkg_info -f $V$VESP-$ARQ/paquetes/$j | grep @depend | sed -e "s/.*:\([^:]*\)$/\1.tgz/g"`; do 
        echo "  $i";
    	if (test ! -f "$V$VESP-$ARQ/paquetes/$i") then { 
    		echo "**** Falta paquete $i" > /dev/stderr; 
		echo "[ENTER] para continuar revisando";
		read;
	} fi;
    done;
done;

