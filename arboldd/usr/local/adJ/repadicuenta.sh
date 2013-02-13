#!/bin/sh
# Asegura ejecutar adicuenta para todos los usuarios del sistema
# Dominio público de acuerdo a legislación colombiana. 
# 2013. vtamara@pasosdeJesus.org

for i in /home/*; do
	n=`echo $i | sed -e "s/\/home\///g"`
	userinfo $n >/dev/null 2> /dev/null
	if (test "$?" = "0") then {
		echo "$i ";
		adicuenta $n
	} fi;
done;
