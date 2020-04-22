#!/bin/sh
# Saca copia  de una base de datos MySQL en SQL y XML
# Dominio publico. 2016. vtamara@pasosdeJesus.org

bd="$1"
usu="$2"
cla="$3"

if (test "$bd" = "") then {
	echo "Falta primer parametro con nombre de base mysql"
	exit 1;
} fi;
if (test "$usu" = "") then {
	echo "Falta segundo parametro con usuario mysql"
	exit 1;
} fi;
if (test "$cla" = "") then {
	echo "Falta tercer parametro con clave mysql"
	exit 1;
} fi;
dm=`date "+%d"` # Dia del mes
/usr/local/bin/mysqldump --socket=/var/www/var/run/mysql/mysql.sock --xml -c -u $usu --password=$cla $bd > /var/www/resbase/$bd-$dm.xml
/usr/local/bin/mysqldump --socket=/var/www/var/run/mysql/mysql.sock --compatible=postgresql -c -u $usu --password=$cla $bd > /var/www/resbase/$bd-$dm.sql
