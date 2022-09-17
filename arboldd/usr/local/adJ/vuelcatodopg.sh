#!/bin/sh
# Saca copia de todas las bases PostgreSQL
# Dominio público. vtamara@pasosdeJesus.org. 2016

if (test "$SOCKPSQL" = "") then {
	sockpsql="/var/www/var/run/postgresql"
} else {
	sockpsql="$SOCKPSQL"
} fi;
if (test "$ACUSPOS" = "") then {
	acuspos="-Upostgres"
} else {
	acuspos="$ACUSPOS"
} fi;
if (test "$USPOS" = "") then {
	uspos="postgres"
} else {
	uspos="$USPOS"
} fi;
if (test "$RES" = "") then {
	dm=`date "+%d"` # Dia del mes
	res="/var/www/resbase/pg/pg-$dm.sql"
} else {
	res="$RES"
} fi;

mkdir -p `dirname $res`
touch $res
chown _postgresql:_postgresql $res
touch $res-t
chmod +x `dirname $res`
chown _postgresql:_postgresql $res-t
rm -f /tmp/penc.txt
echo "psql -h$sockpsql $acuspos -c 'SHOW SERVER_ENCODING' > /tmp/penc.txt" > /tmp/cu.sh
chmod +x /tmp/cu.sh
su - _postgresql /tmp/cu.sh 
if (test -f /tmp/penc.txt -a ! -z /tmp/penc.txt) then {
	dbenc=`grep -v "(1 row)" /tmp/penc.txt | grep -v "server_encoding" | grep -v "[-]-----" | grep -v "^ *$" | sed -e "s/  *//g"`
} fi;
echo "pg_dumpall $acuspos --inserts --column-inserts --host=$sockpsql > $res-t" > /tmp/cu.sh
echo "pg_dumpall $acuspos --host=$sockpsql > $res-rapida-t" >> /tmp/cu.sh

echo "if (test \"\$?\" != \"0\") then {" >> /tmp/cu.sh 
echo "  echo \"No pudo completarse la copia\";" >> /tmp/cu.sh 
echo "  exit 1;" >> /tmp/cu.sh 
echo "} fi;" >> /tmp/cu.sh 
chmod +x /tmp/cu.sh
cat /tmp/cu.sh 
su - _postgresql /tmp/cu.sh 
if (test "$?" != "0" -a -f $res-t) then {
	echo "* Copia incompleta dejada en $res-par"
	mv $res-t $res-par
} else {
	grep "CREATE DATABASE" $res-t | grep -v "ENCODING" > /tmp/cb.sed
	sed -e "s/\(.*\);$/s\/\1;\/\1 ENCODING='$dbenc';\/g/g" /tmp/cb.sed  > /tmp/cb2.sed
	grep -v "ALTER ROLE $uspos" $res-t | sed -f /tmp/cb2.sed > $res
	rm $res-t
	grep "CREATE DATABASE" $res-rapida-t | grep -v "ENCODING" > /tmp/cc.sed
	sed -e "s/\(.*\);$/s\/\1;\/\1 ENCODING='$dbenc';\/g/g" /tmp/cc.sed  > /tmp/cc2.sed
	grep -v "ALTER ROLE $uspos" $res-rapida-t | sed -f /tmp/cc2.sed > $res-rapida
	rm $res-rapida-t

} fi;

