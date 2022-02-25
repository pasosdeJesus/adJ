#!/bin/sh
# Saca copia de todas las bases MySQL en SQL y XML
# Dominio público. vtamara@pasosdeJesus.org. 2016


usu="$1"
cla="$2"

if (test "$usu" = "") then {
	echo "Falta primer parametro con usuario root mysql"
	exit 1;
} fi;
if (test "$cla" = "") then {
	echo "Falta segundo parametro con clave mysql"
	exit 1;
} fi;
dm=`date "+%d"` # Dia del mes
/usr/local/bin/mysqldump --socket=/var/www/var/run/mysql/mysql.sock --force --xml -c -u $usu --password=$cla --all-databases > /var/www/resbase/mysql/mysql-$dm.xml
/usr/local/bin/gzip /var/www/resbase/mysql/mysql-$dm.xml
/usr/local/bin/mysqldump --socket=/var/www/var/run/mysql/mysql.sock --compatible=postgresql -c -u $usu --password=$cla --all-databases > /var/www/resbase/mysql/mysql-$dm.sql

