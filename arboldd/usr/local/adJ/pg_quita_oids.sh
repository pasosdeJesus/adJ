#!/bin/sh
# Quita OIDs de todas las tablas de una base que recibe como argumento
# vtamara@pasosdeJesus.org 2020 Dominio Público

u=`whoami`
if (test "$u" != "_postgresql") then {
	echo "Debe ser ejecutado por _postgreql"
	exit 1;
} fi;

if (test "$1" = "") then {
	echo "Primer parámetro debe ser nombre de la base de datos"
	exit 1;
} fi;

echo "* Quitando oids de base de datos $1"
psql -h /var/www/var/run/postgresql -U postgres $1 << EOF
SELECT format( 'ALTER TABLE %I.%I.%I SET WITHOUT OIDS;', table_catalog, table_schema, table_name) 
   FROM information_schema.tables
   WHERE table_schema = 'public' and table_type='BASE TABLE';
\gexec
EOF

