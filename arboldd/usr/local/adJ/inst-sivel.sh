#!/bin/sh
# Instala/Actualiza un Aprendiendo de Jesús con SIVeL
# Dominio público. 2010. vtamara@pasosdeJesus.org

VER=4.9
VESP=
ACVER=`uname -r`

export PATH=$PATH:/usr/local/bin

if (test "$USER" != "root") then {
	echo "Este script debe ser ejecutado por root";
	exit 1;
} fi;

# Cantidad de paquetes instalados al comenzar
npaqantes=`ls -l /var/db/pkg | wc -l `;
 
if (test "$TAM" = "") then {
	TAM=670000;
# Cabe en CD
} fi;
if (test "$RUTAIMG" = "") then {
	RUTAIMG=/var/
} fi;

echo "-+-+-+-+-+-+" >> /var/tmp/inst-sivel.log
echo "Bitácora de instalación " >> /var/tmp/inst-sivel.log
date >> /var/tmp/inst-sivel.log
echo "VER=$VER ARCVER=$ARCVER TAM=$TAM RUTAIMG=$RUTAIMG ARCH=$ARCH ARCHSIVEL=$ARCHSIVEL " >> /var/tmp/inst-sivel.log

# Creates a string by concatenating $1, $2 times to $3 prints the result.
# From configuration tool of http://structio.sf.net/sigue
function mkstr {
	if (test "$2" -lt "0") then {
		echo "Bug.  Times cannot be negative" | tee -a /var/tmp/inst-sivel.log;
		exit 1;
	}
	elif (test "$2" == "0") then {
		echo $3;
	}
	else {
		mkstr "$1" $(($2 -1)) "$3$1"
	} fi;
}


# Decides if the  number $1 (float or integer in base 10) is less than  
# $2 (also float or integer in base 10).
# Returns 0 if it is  or 1 otherwise.
# From configuration tool of http://structio.sf.net/sigue
function ltf {
	local n1=$1;
	local n2=$2;

# Add .0 to integers
	t=`echo $n1 | grep "[.]"`;
	if (test "$t" == "") then {
		n1="${n1}.0"
	} fi;
	t=`echo $n2 | grep "[.]"`;
	if (test "$t" == "") then {
		n2="${n2}.0"
	} fi;
		
# Multiply each number with an appropiate power of tenth to 
# eliminate decimal part
	d1=`echo $n1 | sed -e "s/[0-9]*[.]\([0-9]*\)/\1/g"`;
	d2=`echo $n2 | sed -e "s/[0-9]*[.]\([0-9]*\)/\1/g"`

	nn1=`echo $n1 | sed -e "s/\([0-9]*\)[.]\([0-9]*\)/\1\2/g"`
	nn2=`echo $n2 | sed -e "s/\([0-9]*\)[.]\([0-9]*\)/\1\2/g"`
	
	t=`echo $((${#d1} < ${#d2}))`
	if (test "$t" == "1") then { 
		# n1 has less decimal digits
		nn1=`mkstr "0" $((${#d2}-${#d1})) $nn1`
	} 
	else { 
		# n2 has less or the same amount of decimal digits than n1
		nn2=`mkstr "0" $((${#d1}-${#d2})) $nn2`;
	}  fi;

	t=`echo $((${nn1} < ${nn2}))`;
	if (test "$t" == "1") then {
		return 0;
	}
	else {
		return 1;
	} fi;
}

if (test "$ARCH" = "") then {
	echo "Suponiendo que se instala de CD-ROM"| tee -a /var/tmp/inst-sivel.log;
	echo "Podría específicar otra ruta ejecutando";
	echo "	export ARCH=/miruta/";
	echo "antes de ejecutar este script";
	export ARCH=/mnt/cdrom;

	echo "Montar CDROM"| tee -a /var/tmp/inst-sivel.log;
	echo "[ENTER] para continuar";
	read
	mount | grep "cdrom" > /dev/null
	if (test "$?" != "0") then {
		mount /mnt/cdrom
	} else {
		echo "   Saltando..."| tee -a /var/tmp/inst-sivel.log;
	} fi;
} fi;

if (test ! -d "$ARCH/sivel/" -o ! -d "$ARCH/paquetes") then {
	echo "En la ruta $ARCH no está Aprendiendo de Jesús" | tee -a /var/tmp/inst-sivel.log;
	exit 1;
} fi;

if (test "$ARCHSIVEL" = "") then {
	ARCHSIVEL="$ARCH/sivel";
	echo "Usando como ruta de SIVeL $ARCHSIVEL" | tee -a /var/tmp/inst-sivel.log;
	echo "Puede cambiarla con la variable ARCHSIVEL";
} fi;

export PKG_PATH=$ARCH/paquetes/


a=`ls $PKG_PATH/sivel-* 2> /dev/null`;
o=`echo $a | sed -e "s/.*\sivel-\(.*\).tgz/\1/g"`;
echo "Actualizando/Instalando SIVeL $o" | tee -a /var/tmp/inst-sivel.log;
echo ""

usivel="";
psivel="";
if (test -f /var/www/htdocs/sivel/conf.sh) then {
	psivel=`stat -f "%Su" /var/www/htdocs/sivel/conf.sh 2> /dev/null`
} elif (test -f /var/www/users/sivel/conf.sh) then {
	psivel=`stat -f "%Su" /var/www/users/sivel/conf.sh 2> /dev/null`
} elif (test -f /var/www/users/sivel/confv.php) then {
	psivel=`stat -f "%Su" /var/www/users/sivel/confv.php 2> /dev/null`
} fi;
while (test "$usivel" = "") ; do
	echo "Nombre de cuenta que administrará y operará SIVeL [$psivel]? ";
	read usivel;
	if (test "$usivel" = "") then {
		usivel="$psivel";
	} fi;
	userinfo $usivel >/dev/null
	if (test "$?" != "0") then {
		echo "Debe ser una cuenta ya existente"| tee -a /var/tmp/inst-sivel.log;
		usivel="";
	} fi;
	if (test ! -f /home/$usivel/.fluxbox/menu) then {
		echo "La cuenta de usuario existe pero no tiene Fluxbox"
		usivel="";
	} fi;
done;


if (test ! -f /$RUTAIMG/post.img ) then {
	echo "Debería existir imagen encriptada (post.img) para PostgreSQL en ruta $RUTAIMG (o especifique otra en variable RUTAIMG)."| tee -a /var/tmp/inst-sivel.log;
	exit 1;
} fi;

if (test ! -f /$RUTAIMG/resbase.img) then {
} fi;

mount | grep "postgresql" > /dev/null
if (test "$?" != "0" ) then {
	echo "No está montada imagen encriptada para PostgreSQL" | tee -a /var/tmp/inst-sivel.log;
	echo ' Intente ejecutando "sudo /usr/local/sbin/monta.sh"';
	exit 1;
} fi;

mount | grep "resbase" > /dev/null
if (test "$?" != "0") then {
	echo "No está montada imagen encriptada para Archivo Digital" | tee -a /var/tmp/inst-sivel.log;
	echo ' Intente ejecutando "sudo /usr/local/sbin/monta.sh"';
	exit 1;
} fi;

uspos='postgres';
acuspos="-U$uspos";

pgrep post > /dev/null 2>&1
if (test "$?" != "0") then {
	sh /etc/rc.local
} fi;

pgrep post > /dev/null 2>&1
if (test "$?" != "0") then {
	echo "PostgreSQL no funciona, favor iniciarlo.";
       	exit 1;
} fi;

dext=`date +%Y%m%d`;
echo "* De requerirlo sacar respaldo de datos y fuentes de SIVeL" | tee -a /var/tmp/inst-sivel.log
if (test -d "/var/www/htdocs/sivel" -a ! -f /var/www/resbase/up$o.sql) then {
	cd /tmp
	pgrep post > /dev/null
	if (test "$?" = "0") then {
		echo -n "psql -h /var/www/tmp $acuspos -c \"select usename from pg_user where usename='postgres';\"" > /tmp/cu.sh
        	su - _postgresql /tmp/cu.sh
		if (test "$?" != "0") then {
			us='_postgresql';
			acus="-U$uspos";
		} fi;
	} fi;
	echo "Sacando copia de respaldo de base SIVeL por defecto" | tee -a /var/tmp/inst-sivel.log;
	echo -n "pg_dump  -h /var/www/tmp --inserts --clean --no-owner --column-inserts $acuspos sivel > /var/www/resbase/up$o.sql" >> /tmp/cu.sh
	touch /var/www/resbase/up$o.sql
	chown _postgresql:_postgresql /var/www/resbase/up$o.sql
        chmod a+x /tmp/cu.sh
	cat /tmp/cu.sh >> /var/tmp/inst-sivel.log
        su - _postgresql /tmp/cu.sh
} else {
	echo "   Saltando..." | tee -a /var/tmp/inst-sivel.log;
} fi;

chown -R $usivel:$usivel /var/www/resbase
if (test ! -d /var/www/resbase/AD) then {
	echo "* Creando Archivo Digital" | tee -a /var/tmp/inst-sivel.log;
	mkdir -p /var/www/resbase/AD
	ln -s /var/www/resbase/AD /home/$usivel/
	anio=`date +%Y`
	mkdir -p /var/www/resbase/AD/$anio
	for i in Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic ; do
		mkdir -p /var/www/resbase/AD/$anio/$i
		for j in 01 02 03 04 05	06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 ; do
			mkdir -p /var/www/resbase/AD/$anio/$i/$j
		done;
	done;
} fi;

if (test ! -d /var/www/resbase/anexos) then {
	echo "* Creando directorio para anexos" | tee -a /var/tmp/inst-sivel.log;
	mkdir -p /var/www/resbase/anexos/
} fi;
chown -R $usivel:www /var/www/resbase/anexos/
chmod -R g+wr /var/www/resbase/anexos
#chmod g-x /var/www/resbase/anexos/

if (test -d /var/www/sincodh-publico/relatos) then {
	chgrp -R www /var/www/sincodh-publico/relatos
	chmod -R g+w /var/www/sincodh-publico/relatos
} fi;

echo "* Verificando usuario postgres" | tee -a /var/tmp/inst-sivel.log
echo "psql -h /var/www/tmp/ -Upostgres template1 -c \"select * from pg_user where usename='postgres';\" | grep postgres > /tmp/sivel" > /tmp/cu.sh
chmod +x /tmp/cu.sh
cat /tmp/cu.sh >> /var/tmp/inst-sivel.log
su - _postgresql /tmp/cu.sh | tee -a /var/tmp/inst-sivel.log
if (test "`cat /tmp/sivel`" = "") then {
	echo "No puede revisarse usuario, por favor verifique clave del usuario postgres en   .pgpass o vuelva a instalar PostgreSQL" | tee -a /var/tmp/inst-sivel.log
	exit 1;
} fi;

CLSIVELPG="";
if (test -f /var/www/htdocs/sivel/aut/conf.php) then {
	CLSIVELPG=`grep "dbclave *=" /var/www/htdocs/sivel/aut/conf.php | sed -e 's/.*=.*"\([^"]*\)".*$/\1/g' 2> /dev/null`
} elif (test -f /var/www/users/sivel/aut/conf.php) then {
	CLSIVELPG=`grep "dbclave *=" /var/www/users/sivel/aut/conf.php | sed -e 's/.*=.*"\([^"]*\)".*$/\1/g' 2> /dev/null`
} elif (test -f /var/www/htdocs/sivel/sitios/sivel/conf.php) then {
	CLSIVELPG=`grep "dbclave *=" /var/www/htdocs/sivel/sitios/sivel/conf.php | sed -e 's/.*=.*"\([^"]*\)".*$/\1/g' 2> /dev/null`
} elif (test -f /home/$usivel/.pgpass) then {
	CLSIVELPG=`grep ":sivel:" /home/$usivel/.pgpass | sed -e 's/.*:sivel://g' 2> /dev/null`
} fi;
if (test "$CLSIVELPG" = "") then {
	CLSIVELPG=`apg | head -n 1`
} fi;


echo "* Crear usuario sivel para PostgreSQL" | tee -a /var/tmp/inst-sivel.log
echo "/usr/local/bin/psql -h /var/www/tmp -U$uspos template1 -c \"select * from pg_catalog.pg_user where usename='sivel';\" | grep \"sivel\" > /tmp/sivel" > /tmp/cu.sh
chmod +x /tmp/cu.sh
cat /tmp/cu.sh >> /var/tmp/inst-sivel.log
su - _postgresql /tmp/cu.sh | tee -a /var/tmp/inst-sivel.log
if (test "`cat /tmp/sivel`" = "") then {
	echo /usr/local/bin/createuser -U $uspos -h /var/www/tmp/ -s sivel > /tmp/cu.sh
	chmod +x /tmp/cu.sh
cat /tmp/cu.sh >> /var/tmp/inst-sivel.log
	su - _postgresql /tmp/cu.sh | tee -a /var/tmp/inst-sivel.log
} else {
	echo "Saltando ..." | tee -a /var/tmp/inst-sivel.log;
} fi;
#alter ROLE sivel superuser

echo "* Clave para usuario sivel de PostgreSQL ($CLSIVELPG)" | tee -a /var/tmp/inst-sivel.log;
echo "psql -h /var/www/tmp -U $uspos template1 -c \"ALTER USER sivel WITH PASSWORD '${CLSIVELPG}'\"" > /tmp/cu.sh
chmod +x /tmp/cu.sh
cat /tmp/cu.sh >> /var/tmp/inst-sivel.log
su - _postgresql /tmp/cu.sh | tee -a /var/tmp/inst-sivel.log
echo "*:*:*:sivel:$CLSIVELPG" > /home/$usivel/.pgpass;
chmod 0600 /home/$usivel/.pgpass;
chown $usivel:$usivel /home/$usivel/.pgpass

echo "* Poniendo /var/www/htdocs/sivel como raíz de documentos de Apache" | tee -a /var/tmp/inst-sivel.log;
grep "DocumentRoot.*\"/var/www/htdocs/sivel\"" /var/www/conf/httpd.conf > /dev/null
if (test "$?" != "0") then {
	chmod +w /var/www/conf/httpd.conf
	cp /var/www/conf/httpd.conf /tmp/httpd.conf
	awk '
/DocumentRoot .*/ {
	if (paso==1) {
		$0="DocumentRoot \"/var/www/htdocs/sivel\"";
	}
}

/^ServerName .*/ {
	if (paso==1) {
		print "    <Directory />";
		print "        AllowOverride Options";
		print "    </Directory>";
		print "    <Files ~ \"pruebas.bitacora|vardb.sh|vardb-copia.sh|Entries|Entries.Log|Repository|Root\">";
		print "        Order allow,deny";
		print "        Deny from all";
		print "    </Files>";
		$0="ServerName servidor";
	}
}

/^ServerAdmin .*/ {
	if (paso==1) {
		$0="ServerAdmin info@pasosdeJesus.org";
	}
}

/<VirtualHost _default_:443>/ {
	paso=1;
}

/.*/ {
	print $0;
}

BEGIN {
	paso=0;
}' /tmp/httpd.conf > /var/www/conf/httpd.conf
	chmod -w /var/www/conf/httpd.conf
}
else {
		echo "   Saltando..."| tee -a /var/tmp/inst-sivel.log;
} fi;

echo "* Mejorando permisos en configuración de Apache" | tee -a /var/tmp/inst-sivel.log;
grep "Files.*Entries" /var/www/conf/httpd.conf > /dev/null
if (test "$?" != "0") then {
	chmod +w /var/www/conf/httpd.conf
	cp /var/www/conf/httpd.conf /tmp/httpd.conf
	awk '
/^ServerName .*/ {
	if (paso==1) {
		print "<Directory />";
		print "    AllowOverride Options";
		print "</Directory>";
		print "<Files ~ \"Entries|Entries.Log|Repository|Root\">";
		print "    Order allow,deny";
		print "    Deny from all";
		print "</Files>";
		paso = 0;
	}
}

/DocumentRoot .*var.www.htdocs.sivel/ {
	paso=1;
}

/.*/ {
	print $0;
}

BEGIN {
	paso=0;
}' /tmp/httpd.conf > /var/www/conf/httpd.conf
	chmod -w /var/www/conf/httpd.conf
}
else {
		echo "   Saltando..."| tee -a /var/tmp/inst-sivel.log;
} fi;

echo "* Enlaces y directorios para Apache y SIVeL" | tee -a /var/tmp/inst-sivel.log;
if (test ! -d /var/www/htdocs/sivel -o ! -d /home/$usivel/public_html/sivel -o ! -d /home/$usivel/sivel) then {
	mkdir -p /var/www/htdocs/sivel/
	mkdir -p /home/$usivel/public_html/
	chown $usivel:$usivel /var/www/htdocs/sivel
	ln -s /var/www/htdocs/sivel /home/$usivel/public_html/
	ln -s /home/$usivel/public_html/sivel /home/$usivel/sivel
}
else {
		echo "   Saltando..."| tee -a /var/tmp/inst-sivel.log;
} fi;

apachectl stop
. /etc/rc.conf
httpd $httpd_flags | tee -a /var/tmp/inst-sivel.log
if (test "$?" != "0") then {
	echo "Falló httpd, revisar, asegurar que funciona y regresar con 'exit'" | tee -a /var/tmp/inst-sivel.log;
	sh
} fi;
cat /var/www/conf/httpd.conf >> /var/tmp/inst-sivel.log 

if (test -f "/var/www/htdocs/sivel/confv.php") then {
	vsant=`grep "PRY_VERSION" /var/www/htdocs/sivel/confv.php | sed -e "s/.*PRY_VERSION *= *\"\(...\).*/\1/g"`;
	if (test "$vsant" = "1.0") then {
		dpl=`stat -f "%Su" /var/www/htdocs/sivel/confv.php`

		echo "SIVeL 1.0 encontrado en ruta por defecto, RETORNO para moverla a /var/www/htdocs/sivel10 y base de sivel a sivel10 y despues eliminar"
		read
		
		su $dpl -c "cd /var/www/htdocs/sivel; bin/mueve.sh"
	} fi;
} fi;

if (test -f "/var/www/htdocs/sivel/aut/conf.php.plantilla" -o -f /var/www/htdocs/sivel/sitios/pordefecto/conf.php.plantilla) then {
	echo -n "¿Desinstalar versión anterior de SIVeL (s/n)? "
	read sn;
	if (test "$sn" = "s") then {
		d=`date "+%Y%m%d"`
		tar cvfz /var/www/resbase/sivelant-$d.tar.gz /var/www/htdocs/sivel
		f=`ls /var/db/pkg/sivel-* 2> /dev/null > /dev/null`;
		if (test "$?" = "0") then {
			sudo pkg_delete sivel
		} else {
			rm -rf /var/www/htdocs/sivel
			tar xvfz -C / /var/www/resbase/sivelant-$d.tar.gz /var/www/htdocs/sivel/{aut/conf.php,vardb.sh}
			tar xvfz -C / /var/www/resbase/sivelant-$d.tar.gz /var/www/htdocs/sivel/{sitios/sivel/conf.php,sitios/sivel/vardb.sh}
		} fi;
	} fi;
} fi;

echo "* Instalar SIVeL"
f=`ls /var/db/pkg/sivel-* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	sudo pkg_add $ARCHSIVEL/sivel-*.tgz 2>&1 | tee -a /var/tmp/inst-sivel.log
	if (test "$?" != "0") then {
		echo "No pudo instalar $ARCHSIVEL/sivel-*.tgz" | tee -a /var/tmp/inst-sivel.log
		exit 1;
	} fi;
} fi;
echo "* Estableciendo permisos"
cd /var/www/htdocs/sivel
chown -R $usivel:$usivel .
chmod -R a+r .
chmod -R go-rx bin
if (test ! -d /var/www/htdocs/sivel/sitios/sivel) then {
	cd sitios/
	# ahora nuevo.sh saca clave de .pgpass
	pwd
	SIN_CREAR=1 ./nuevo.sh sivel
	sudo chown www:www sivel/ultimoenvio.txt
	ln -s sivel 127.0.0.1
	cd ..
} fi;
f=`ls /var/www/usr/local/bin/ispell 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	echo -n "¿Desinstalar ispell y openssl de entorno chroot para instalarlos de nuevo? "
	read sn;
	if (test "$sn" = "s") then {
		sudo rm /var/www/usr/local/bin/ispell /var/www/usr/sbin/openssl
	} fi;
} fi;

echo "* Entorno chroot"
f=`ls /var/www/usr/local/bin/ispell 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	cd /var/www/htdocs/sivel
	bin/prep-chroot.sh /var/www | tee -a /var/tmp/inst-sivel.log
} else {
        echo "   Saltando..." | tee -a /var/tmp/inst-sivel.log;
} fi;


echo "* Configuración"
if (test -f /var/www/htdocs/sivel/sitios/sivel/vardb.sh) then {
	echo "vardb.sh anterior:" >> /var/tmp/inst-sivel.log
	cat /var/www/htdocs/sivel/sitios/sivel/vardb.sh >> /var/tmp/inst-sivel.log
	cp /var/www/htdocs/sivel/sitios/sivel/vardb.sh /var/www/htdocs/sivel/sitios/sivel/vardb-copia.sh
} fi;
rm -f /var/www/htdocs/sivel/{confv.sh,confaux.tmp}	
cd /var/www/htdocs/sivel
sudo touch /var/www/pear/lib/.lock

echo "* Información para Relatos" | tee -a /var/tmp/inst-sivel.log;
echo "Organización:"
read nomorg
echo "Sigla o abreviatura de organización:"
read aborg
echo "Derechos de reproduccion para relatos producidos [Dominio Público]:"
read derechos

if (test "$derechos" = "") then {
	derechos="Dominio Público";
} fi;

su $usivel ./conf.sh -i | tee -a /var/tmp/inst-sivel.log
echo "* Estableciendo clave" | tee -a /var/tmp/inst-sivel.log;

if (test ! -f "/var/www/htdocs/sivel/sitios/sivel/conf-copia$VER.php") then {
	cp /var/www/htdocs/sivel/sitios/sivel/conf.php /var/www/htdocs/sivel/sitios/sivel/conf-copia$VER.php
} fi;
sed -e "s/\$dbclave *=.*/\$dbclave = \"$CLSIVELPG\";/g" /var/www/htdocs/sivel/sitios/sivel/conf-copia$VER.php \
| sed -e "s/\$GLOBALS\['organizacion_responsable'\] *=.*/\$GLOBALS['organizacion_responsable'] = \"$nomorg\";/g" \
| sed -e "s/\$GLOBALS\['derechos'\] *=.*/\$GLOBALS['derechos'] = \"$derechos\";/g" \
| sed -e "s/\$GLOBALS\['PREF_RELATOS'\] *=.*/\$GLOBALS['PREF_RELATOS'] = '$aborg';/g" \
> /var/www/htdocs/sivel/sitios/sivel/conf.php
sudo chmod a-wrx /var/www/htdocs/sivel/sitios/sivel/conf-copia$VER.php
cd /var/www/htdocs/sivel/sitios/sivel
sudo chown $usivel:www conf*.php
chmod o-rwx conf*.php
chmod g=r conf*.php
../../bin/creaesquema.sh

cd /

echo "* Instalar datos y usuarios" | tee -a /var/tmp/inst-sivel.log;
cd /var/www/htdocs/sivel/sitios/sivel
echo "psql -h /var/www/tmp -U sivel sivel -c \"SELECT COUNT(*) FROM departamento;\"" > /tmp/cu.sh
echo "exit \$?" >> /tmp/cu.sh;
chmod +x /tmp/cu.sh
cat /tmp/cu.sh
# El siguiente sin tee porque retornaría 0
su - $usivel /tmp/cu.sh 
if (test "$?" != "0") then {
	su $usivel ../../bin/creapg.sh | tee -a /var/tmp/inst-sivel.log
	echo "Creación de primer usuario para SIVeL." | tee -a /var/tmp/inst-sivel.log;
       #	A password responda con clave de usuario sivel de PostgreSQL"
	su $usivel ../../bin/agus.sh | tee -a /var/tmp/inst-sivel.log
} else {
	echo "   Saltando..." | tee -a /var/tmp/inst-sivel.log;
} fi;
	


echo "* Configurar respaldos" | tee -a /var/tmp/inst-sivel.log;
su - $usivel -c "crontab -l 2>/dev/null" > /tmp/crontab.sivel
grep "sivel.*respaldo.sh" /tmp/crontab.sivel 2> /dev/null
if (test "$?" != "0") then {
	echo "* Programando cron para sacar copia de respaldo diaria al mediodia" | tee -a /var/tmp/inst-sivel.log;
	echo "0 12 * * * cd /var/www/htdocs/sivel/; sudo rm /tmp/respaldo-*; bin/resptodositio.sh > /tmp/respaldo-stdout 2> /tmp/respaldo-stderr" >> /tmp/crontab.sivel
	su - $usivel -c "crontab /tmp/crontab.sivel 2> /dev/null" | tee -a /var/tmp/inst-sivel.log;
} fi;
cat /tmp/crontab.sivel >> /var/tmp/inst-sivel.log;


echo "* Personalizando menú de fluxbox" | tee -a /var/tmp/inst-sivel.log;
grep "SIVeL" /home/$usivel/.fluxbox/menu > /dev/null 2> /dev/null
if (test "$?" != "0") then {
	echo -n "¿Nombre de usuario para conectarse a www.nocheyniebla.org? ";
	read usnyn
	ed /home/$usivel/.fluxbox/menu <<EOF
/(Dispositivos)
i
[submenu] (SIVeL)
	[exec] (SIVeL) {/usr/local/bin/firefox -UILocale es-AR https://127.0.0.1}
	[exec] (Editar sitios/sivel/conf.php) {LANG=es xfw /var/www/htdocs/sivel/sitios/sivel/conf.php}
        [exec] (Sacar copia de base en /var/www/resbase) {cd /var/www/htdocs/sivel/ && bin/pgdump.sh}
	[exec] (Quemar /var/resbase.img en CD-R) {xterm -e "cd /var/www/htdocs/sivel && bin/copiacd.sh"}
	[exec] (Conectar a ${usnyn}www.nocheyniebla.org) {xterm -e "ssh -p10022 -R 1234:localhost:22 ${usnyn}@www.nocheyniebla.org"}
	[exec] (Enviar volcado de la base a ${usnyn}@www.nocheyniebla.org) {cd /var/www/htdocs/sivel/sitios/sivel && ../../bin/pgdump.sh && dm=`date "+%d"` scp -P10022 /var/www/resbase/sivel-dump-$dm.sql.gz ${usnyn}@www.nocheyniebla.org:"}
[end]
.
w
q
EOF
} 
else {
	echo "   Saltando..." | tee -a /var/tmp/inst-sivel.log;
} fi;

echo "FELICITACIONES!  La instalación/actualización de SIVeL se completó satisfactoriamente";
echo "";
echo "Ahora puede actualizar SIVeL abriendo con un navegador https://127.0.0.1/actualiza.php y autenticandose.";
