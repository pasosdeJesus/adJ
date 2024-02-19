#!/bin/sh
# Prepara motor con bases PostGIS para actualizar
# vtamara@pasosdeJesus.org.   Licencia ISC

function gen_para_base {
  base=$1;
  for tabla in `psql -U postgres -h /var/www/var/run/postgresql -c "SELECT distinct table_name FROM information_schema.columns WHERE table_schema='public' AND udt_name IN ('geometry', 'geography');" $base | grep "^ [^ ]" `; do 
    #echo "OJO tabla=$tabla";
    # No conocemos consulta para sacar tipo preciso nos toca con \d de psql
    m=`psql -U postgres -h /var/www/var/run/postgresql -c "\d $tabla" $base | grep -e geometry -e geography | sed -e "s/^ *\([^ ]*\) *| *\([^ ]*\).*/\1|\2/g"`
    #echo "OJO m=$m";
    for coltipo in $m; do
      #echo "OJO coltipo=$coltipo"
      col=`echo $coltipo | sed -e "s/|.*//g"`
      tipo=`echo $coltipo | sed -e "s/.*|//g"`
      tipobase=`echo $tipo | sed -e "s/(.*//g"`
      #echo "OJO tipobase=$tipobase"
      if (test "$tipobase" = "geometry") then {
        echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"ALTER TABLE $tabla ALTER COLUMN $col TYPE text USING ST_AsText($col);\"" >> /var/www/tmp/quita-postgis.sh
        echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"ALTER TABLE $tabla ALTER COLUMN $col TYPE $tipo USING ST_GeomFromText($col);\"" >> /var/www/tmp/agrega-postgis.sh
      } else {
        echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"ALTER TABLE $tabla ALTER COLUMN $col TYPE text USING ST_AsText($col);\"" >> /var/www/tmp/quita-postgis.sh
        echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"ALTER TABLE $tabla ALTER COLUMN $col TYPE $tipo USING ST_GeographyFromText($col);\"" >> /var/www/tmp/agrega-postgis.sh
      } fi;
    done;
  done
}

psql -U postgres -h /var/www/var/run/postgresql/ -c "select datname from pg_database;" |\
	sed -e "s/^ *datname//g;s/^---*//g;s/^(.*rows.*//g" > /var/www/tmp/rp-todas.txt

echo "#!/bin/sh" > /var/www/tmp/quita-postgis.sh
echo "#!/bin/sh" > /var/www/tmp/agrega-postgis.sh
for i in `cat /var/www/tmp/rp-todas.txt `; do
	if (test "$i" != "template0") then {
		echo -n "$i: ";
		psql -U postgres -h /var/www/var/run/postgresql/ $i \
			-c "SELECT extname FROM pg_extension WHERE extname='postgis';" | grep postgis
		if (test "$?" = "0") then {
      echo "Usa PostGIS"
			echo "echo $i;" >> /var/www/tmp/quita-postgis.sh;
			echo "echo $i;" >> /var/www/tmp/agrega-postgis.sh;
			echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"CREATE EXTENSION postgis;\"" >> /var/www/tmp/agrega-postgis.sh
      gen_para_base $i
			echo "psql -U postgres -h /var/www/var/run/postgresql/ $i -c \"DROP EXTENSION postgis;\"" >> /var/www/tmp/quita-postgis.sh
    } else {
      echo "No usa PostGIS"
		} fi;
	} fi;
done
chmod +x /var/www/tmp/quita-postgis.sh
echo "Creado script /var/www/tmp/quita-postgis.sh que debe correr antes de pg_upgrade"
chmod +x /var/www/tmp/agrega-postgis.sh
echo "Creado script /var/www/tmp/agrega-postgis.sh que debe correr después de pg_upgrade"

exit 0

psql -U postgres -h /var/www/var/run/postgresql -e "SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';"

