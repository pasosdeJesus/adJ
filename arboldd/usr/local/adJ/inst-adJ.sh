#!/bin/sh
# Instala/Actualiza un Aprendiendo de Jesús 
# Dominio público de acuerdo a legislación colombiana. http://www.pasosdejesus.org/dominio_publico_colombia.html. 
# 2015. vtamara@pasosdeJesus.org

VER=7.0
REV=0
VESP="b1"
VERP=70

# Falta /standard/root.hint

ACVER=`uname -r`
ARQ=`uname -m`

export PATH=$PATH:/usr/local/bin

w=`whoami`
if (test "$w" != "root") then {
	echo "Este script debe ser ejecutado por root o con doas";
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

mkdir -p /var/www/tmp/
echo "-+-+-+-+-+-+" >> /var/www/tmp/inst-adJ.bitacora
echo "Bitácora de instalación " >> /var/www/tmp/inst-adJ.bitacora
date >> /var/www/tmp/inst-adJ.bitacora
echo "VER=$VER ARCVER=$ARCVER TAM=$TAM RUTAIMG=$RUTAIMG ARCH=$ARCH ARCHSIVEL=$ARCHSIVEL ARCHSIVELPEAR=$ARCHSIVELPEAR" >> /var/www/tmp/inst-adJ.bitacora

# Creates a string by concatenating $1, $2 times to $3 prints the result.
# From configuration tool of http://structio.sf.net/sigue
function mkstr {
	if (test "$2" -lt "0") then {
		echo "Bug.  Times cannot be negative" >> /var/www/tmp/inst-adJ.bitacora;
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

function activarcs {
	ns=$1;
	rcctl enable $ns
} 

function creamontador {
ar=$1;
if (test "$ar" = "") then {
	echo "Falta archivo por crear como primer parametro";
	exit 1;
} fi;
rut=$2;
if (test "$rut" = "") then {
	echo "Falta ruta donde montar como segundo parametro";
	exit 1;
} fi;
dv=$3;
if (test "$dv" = "") then {
	echo "Falta numero de dipositivo vnd por usar como tercer parámetro";
	exit 1;
} fi;
us=$4;
if (test "$us" = "") then {
	echo "Falta usuario dueño de directorio como cuarto parámetro";
	exit 1;
} fi;
gr=$5;
if (test "$gr" = "") then {
	echo "Falta grupo dueño de directorio como quinto parámetro";
	exit 1;
} fi;
im=$6;
if (test "$im" = "") then {
	echo "Falta imagen como sexto parámetro";
	exit 1;
} fi;
cat > $ar << EOF
#!/bin/sh

servicio="/sbin/mount"

. /etc/rc.d/rc.subr

rc_check() {
/sbin/mount | grep "$rut" > /dev/null 
}

rc_stop() {
umount $rut
vnconfig -u vnd${dv}c
}

rc_start() {
if (test -f $im) then {
	/sbin/umount /dev/vnd${dv}c 2> /dev/null
	/sbin/umount /dev/vnd${dv}a 2> /dev/null
	/sbin/vnconfig -u vnd${dv}c 2> /dev/null
	if (test ! -d $rut) then {
		mkdir $rut
		chown $us:$gr $rut
		chmod o-w $rut
	} fi;
	echo " " > /dev/tty
	/sbin/vnconfig -ckv vnd${dv} $im
	partres=vnd${dv}c
	disklabel vnd${dv}c | grep "  a: " > /dev/null 2>&1
	if (test "\$?" = "0") then {
		partres=vnd${dv}a
	} fi;
	/sbin/fsck_ffs -y /dev/\$partres
	/sbin/mount /dev/\$partres $rut
} fi;
}

rc_cmd \$1
EOF
chmod +x $ar
}


echo "Script de instalación de adJ $VER" >> /var/www/tmp/inst-adJ.bitacora
echo "---------------------------- " >> /var/www/tmp/inst-adJ.bitacora
echo "Se recomienda ejecutarlo desde una terminal en X-Window" >> /var/www/tmp/inst-adJ.bitacora

if (test ! -f /etc/signify/adJ-$VERP-pkg.pub) then {
	echo 'No se encuentra /etc/signify/adJ-$VERP-pkg.pub'
	exit 1;
} fi;

if (test ! -f /etc/signify/adJ-$VERP-base.pub) then {
	echo 'No se encuentra /etc/signify/adJ-$VERP-base.pub'
	exit 1;
} fi;

mount > /dev/null 2> /dev/null
if (test "$?" != "0") then {
	echo 'No puede ejecutarse mount vuelva a ejecutar este script así:
	su -
	export PATH="$PATH:/bin/:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"
	/inst-adJ.sh'
	exit 1;
} fi;

umount /mnt/cdrom 2> /dev/null > /dev/null
mount | grep "/mnt/cdrom" > /dev/null 2> /dev/null
if (test "$?" = "0") then {
	echo "No puede desmontarse el CDROM" | tee -a /var/www/tmp/inst-adJ.bitacora;
	echo "Se recomienda detener (Ctrl-C) desmontar y volver a ejecutar este archivo de comandos" | tee -a /var/www/tmp/inst-adJ.bitacora;
	read;
} fi;

padJ=`stat -f "%Su" /mnt/cdrom 2> /dev/null`
if (test "$padJ" = "") then {
	if (test "$ADMADJ" = "") then {
		padJ=$USER;
	} else {
		padJ=$ADMADJ;
	} fi;
} fi;
uadJ="";
while (test "$uadJ" = "") ; do
	clear;
	echo "Cuenta (prefiera un nombre corto en minusculas y sin espacio) [$padJ]: ";
	read uadJ;
	uadJ=`echo $uadJ | sed -e "s/ //g"`
	if (test "$uadJ" = "") then {
		uadJ=$padJ;
	} fi;
done;
ADMADJ=$uadJ;

echo "* Creando cuenta inicial"  >> /var/www/tmp/inst-adJ.bitacora
groupinfo $uadJ > /dev/null 2>&1
if (test "$?" != "0") then {
groupadd $uadJ
} fi;
userinfo $uadJ >/dev/null 2>&1
if (test "$?" != "0") then {
adduser -v -batch $uadJ $uadJ,wheel $uadJ
passwd $uadJ
} else {
echo "   Saltando..."  >> /var/www/tmp/inst-adJ.bitacora;
} fi;
user mod -g $uadJ $uadJ
user mod -G users $uadJ
user mod -G staff $uadJ
user mod -G operator $uadJ

# Preparando en casos de actualización grande

chown $uadJ:$uadJ /home/$uadJ/.Xauthority > /dev/null 2>&1
rm -rf /home/$uadJ/.font*

usermod -G operator $uadJ

echo "* Permisos de /mnt" >> /var/www/tmp/inst-adJ.bitacora;
ls -l /mnt/ | grep "root  wheel" > /dev/null 2> /dev/null
if (test "$?" = "0") then {
	chown $uadJ:$uadJ /mnt/*	2> /dev/null > /dev/null
} fi;



echo "Sistemas de archivos de CDROM en /etc/fstab" >> /var/www/tmp/inst-adJ.bitacora
grep "/mnt/cdrom" /etc/fstab > /dev/null
if (test "$?" != "0") then {
	echo "/dev/cd0a /mnt/cdrom cd9660 noauto,ro 0 0" >> /etc/fstab
} else {
	echo "   Saltando cd0a..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;
mkdir -p /mnt/cdrom
chown $uadJ:$uadJ /mnt/cdrom

chmod g+rw /dev/sd?i /dev/sd?c /dev/cd?c /dev/cd?a

mkdir -p /var/www/tmp
chmod a+rxw /var/www/tmp > /dev/null 2>&1
chmod +t /var/www/tmp
chmod a+rxw /var/www/tmp > /dev/null 2>&1

# Puede faltar en algunos sitios
# cd /dev
# MAKEDEV sd5

if (test "$ARCH" = "") then {
echo "Suponiendo que se instala de CD-ROM." >> /var/www/tmp/inst-adJ.bitacora;
clear;
echo "Instalando desde CD-ROM";
echo ""
echo '\nPonga el CD de adJ en la unidad de CD-ROM. \n\nSi prefiere especificar un directorio como fuente de instalación, detenga este  archivo de comandos (con Control-C) y antes de volver a iniciarlo ejecute\n\n     export ARCH=/miruta/\n\n\nPresione [ENTER] para continuar' 
read
clear;

export ARCH=/mnt/cdrom;
mount | grep "cdrom" > /dev/null 2>&1
if (test "$?" != "0") then {
	mount /mnt/cdrom
} else {
	echo "   Saltando..."| tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
} else {
p=`echo $ARCH | sed -e "s/^\(.\).*/\1/g"`;
if (test "$p" != "/") then {
	echo "ARCH deberia ser una ruta absoluta (comenzando con /)";
	exit 1;
} fi;
} fi;

if (test ! -f "$ARCH/Novedades.md" -o ! -d "$ARCH/paquetes") then {
echo "En la ruta $ARCH no está el CD Aprendiendo de Jesús" | tee -a /var/www/tmp/inst-adJ.bitacora;
exit 1;
} fi;

export PKG_PATH=$ARCH/paquetes/

# Instala un paquete y opcionalmente otro 
function insacp {
	n=$1;
	popc=$2;
	pre=$3;
	if (test "$n" = "") then {
		echo "insacp: Falta nombre de paquete";
		exit 1;
	} fi;
	echo "* Instalar $n"  >> /var/www/tmp/inst-adJ.bitacora;
	opbor="-I";
	f=`ls /var/db/pkg/$n-* 2> /dev/null > /dev/null`;
	if (test "$?" = "0") then {
		echo "$n instalado. Intentando remplazar " >> /var/www/tmp/inst-adJ.bitacora
		opbor="-I -r -D repair -D update -D updatedepends"
	} fi;

	pe=`ls $PKG_PATH/$n-*.tgz 2> /dev/null`;
	if (test "$pe" = "") then {
		echo "No se encuentra paquete $n. Presione ENTER para continuar o Control-C para cancelar"
		read
	} fi;
	pkg_add $opbor $PKG_PATH/$n-*.tgz >> /var/www/tmp/inst-adJ.bitacora 2>&1
	if (test "$popc" != "") then {
		pkg_add $opbor $PKG_PATH/${popc}*.tgz >> /var/www/tmp/inst-adJ.bitacora 2>&1
	} fi;
}


insacp gettext
insacp libiconv
insacp dialog
l=`ls /var/db/pkg/ | grep "^dialog-"`
if (test "$l" = "") then {
echo "El paquete dialog es indispensable";
exit 1;
} fi;

echo "Sistemas de archivos para USB en /etc/fstab" >> /var/www/tmp/inst-adJ.bitacora
grep "/mnt/usb" /etc/fstab > /dev/null
if (test "$?" != "0") then {
	echo "Detectando dispositivo que corresponde a memoria USB" >> /var/www/tmp/inst-adJ.bitacora;
	ayuda="2";
	while (test "$ayuda" = "2"); do
		dialog --title 'Configurando USB (1)' --help-button --msgbox '\nDesmonte y retire toda memoria USB que pueda haber\n' 15 60
		ayuda="$?"
		if (test "$ayuda" = "2") then {
			dialog --title 'Ayuda configuración USB' --msgbox '\nLa prueba de insertar y retirar memoria USB se hace para diferenciar discos duros de memorias USB y configurar el dispositivo que típicamente usan las memorias USB, de forma que puedan montarse facilmente en /mnt/usb.\n' 15 60 
		} fi;
	done;
	dmesg > /tmp/dmesg1
	dialog --title 'Configurando USB (2)' --msgbox '\nPonga una memoria USB.  No se escribirá en ella.\n' 15 60
	dmesg > /tmp/dmesg2
	diff /tmp/dmesg1 /tmp/dmesg2 > /tmp/dmesgdiff
	nusb=0;
	grep "[>] sd" /tmp/dmesgdiff > /dev/null 2>&1
	if (test "$?" = "0") then {
		nusb=`grep "[>] sd" /tmp/dmesgdiff | head -n 1 | sed -e  "s/.* sd\([0-9]\).*/\1/g"` 
	} fi;
	echo "    Configurando dispositivo /dev/sd${nusb}c" >> /var/www/tmp/inst-adJ.bitacora;
	dialog --title 'Configurando USB (3)' --msgbox '\nRetire la memoria USB\n' 15 60
	echo "/dev/sd${nusb}i /mnt/usb msdos noauto,rw 0 0" >> /etc/fstab
	mkdir -p /mnt/usb
	echo "/dev/sd${nusb}c /mnt/usbc msdos noauto,rw 0 0" >> /etc/fstab
	mkdir -p /mnt/usbc
} else {
	echo "   Saltando USB..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;
chown $uadJ:$uadJ /mnt/usb 
chown $uadJ:$uadJ /mnt/usbc

echo "/var sin nodev en /etc/fstab (para tener /var/www/dev/random)" >> /var/www/tmp/inst-adJ.bitacora
grep " /var.*nodev," /etc/fstab > /dev/null
if (test "$?" = "0") then {
	echo "Por quitar opcion nodev en /var en fstab" >> /var/www/tmp/inst-adJ.bitacora;
	ed /etc/fstab <<EOF
/ \/var.*nodev,/
s/nodev,//g
w
q
EOF
} else {
	echo "   Saltando quitar nodev..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

echo "Creando /var/www/dev/random" >> /var/www/tmp/inst-adJ.bitacora
if (test ! -c "/var/www/dev/random") then {
	mkdir -p /var/www/dev/
	rm -f /var/www/dev/random
	mknod -m 644 /var/www/dev/random c 45 0 2>> /var/www/tmp/inst-adJ.bitacora
} else {
	echo "   Saltando /var/www/dev/random..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

userinfo _hostapd >/dev/null
if (test "$?" != "0") then {
	echo "Aplicando actualizaciones de 3.7 a 3.8"  >> /var/www/tmp/inst-adJ.bitacora;
	
	useradd -u86 -g=uid -c"HostAP Service" -d/var/empty -s/sbin/nologin _hostapd
} fi;

#grep "nat-anchor" /etc/pf.conf > /dev/null
#if (test "$?" != "0") then {
#	echo "Aplicando actualizaciones de 3.8 a 3.9"  >> /var/www/tmp/inst-adJ.bitacora;
#	# In the NAT section you need:
#	ed /etc/pf.conf <<EOF
#/nat on
#+
#i
#nat-anchor "ftp-proxy/*"
#rdr-anchor "ftp-proxy/*"
#.
#/rdr pass
#i
## In the rules section, this is needed:
#anchor "ftp-proxy/*"
#.
#w
#q
#EOF
#rm -f /usr/lib/libresolv*
#} fi;

vac="";
mac="";
userinfo _dvmrpd >/dev/null
if (test "$?" != "0") then {
	vac="$vac 3.9 a 4.0";	
	mac="$mac Hay cambios manuales por hacer si usa PPPOE del PPP del kernel\n";
	echo "Aplicando actualizaciones de 3.9 a 4.0"  >> /var/www/tmp/inst-adJ.bitacora;
	useradd -u87 -g=uid -c"DVMRP Service" -d/var/empty -s/sbin/nologin _dvmrpd

	#Previously, the /etc/hostname.pppoe0 file looked like this:

#	pppoedev ne0
#	!/sbin/ifconfig ne0 up
#	!/usr/sbin/spppcontrol \$if myauthproto=pap myauthname=testcaller \
#	        myauthkey=donttell
#		!/sbin/ifconfig \$if inet 0.0.0.0 0.0.0.1 netmask 0xffffffff
#		!/sbin/route add default 0.0.0.1
#		up
#		This should be updated according to the following example:
#		inet 0.0.0.0 255.255.255.255 0.0.0.1 pppoedev ne0 \
#		        authproto pap authname testcaller authkey donttell up
#			!/sbin/route add default 0.0.0.1
#			And the physical interface must be marked UP:
# echo "up" > /etc/hostname.ne0

#Colisiones al actualizar de 3.9 a 4.0
	mv -f /usr/local/share/locale/bg/LC_MESSAGES/gnumeric.mo  /usr/local/share/locale/bg/LC_MESSAGES/gnumeric.mo.evita-colision 2> /dev/null
	mv -f /usr/local/libexec/cups/filter/foomatic-rip /usr/local/libexec/cups/filter/foomatic-rip.evita-colision 2> /dev/null
	mv -f /var/www/pear/doc/DB/  /var/www/pear/doc/DB.evita-colision/  2> /dev/null
	mv -f /var/www/pear/lib/DB.php  /var/www/pear/doc/DB.php.evita-colision/ 2> /dev/null
	mv -f /var/www/pear/lib/DB/  /var/www/pear/doc/DB.evita-colision/ 2> /dev/null
	mv -f /var/www/pear/tests/DB/ /var/www/pear/tests/DB.evita-colision/ 2> /dev/null

} fi;


userinfo _ripd >/dev/null
if (test "$?" != "0") then {
	vac="$vac 4.0 a 4.1";	
	echo "Aplicando actualizaciones de 4.0 a 4.1" >> /var/www/tmp/inst-adJ.bitacora;

	useradd -u88 -g=uid -c"RIP Service" -d/var/empty -s/sbin/nologin _ripd >> /var/www/tmp/inst-adJ.bitacora
	useradd -u89 -g=uid -c"Relay Service" -d/var/empty -s/sbin/nologin _relayd >> /var/www/tmp/inst-adJ.bitacora
} fi;

userinfo _ospf6d >/dev/null
if (test "$?" != "0") then {
	# Los que se cambien aqui borrarlos de /tmp/etc para que no
	# sean actualizados por mergemaster

	vac="$vac 4.2 a 4.3";	
	echo "Aplicando actualizaciones de 4.2 a 4.3" >> /var/www/tmp/inst-adJ.bitacora;
	useradd -u90 -g=uid -c"OSPF6 Service" -d/var/empty -s/sbin/nologin _ospf6d
	useradd -u91 -g=uid -c"SNMP Service" -d/var/empty -s/sbin/nologin _snmpd

	grep "_hoststated" /etc/group  > /dev/null
	if (test "$?" = "0") then {
		userdel _hoststated
		groupdel _hoststated
		useradd -u89 -g=uid -c"Relay Service" -d/var/empty -s/sbin/nologin _relayd
		rm -f /etc/hoststated.conf /var/named/standard/root.hint
		chown root:operator /etc/chio.conf
		chmod 644 /etc/chio.conf
		ed /var/www/conf/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
/LoadModule php5_module .*
d
i

#Include extra module configuration files
Include /var/www/conf/modules/*.conf
.
w
q
EOF
	} fi;
} fi;

userinfo _ypldap >/dev/null
if (test "$?" != "0") then {
	vac="$vac 4.3 a 4.4";	
	echo "Aplicando actualizaciones de 4.3 a 4.4" >> /var/www/tmp/inst-adJ.bitacora;
	#useradd -u92 -g=uid -c"IPv6 Router Advertisement Service" -d/var/empty -s/sbin/nologin _rtadvd 
	useradd -u93 -g=uid -c"YP to LDAP Service" -d/var/empty -s/sbin/nologin _ypldap
	rm -f /etc/dhcpd.interfaces

# Posiblemente en httpd.conf
# :%s/\(VirtualHost.* \)\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)>/\1\2:80>/g
#  :%s/\(VirtualHost.* \)\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\) /\1\2:80 /g
} fi;

a=`ls /var/db/pkg/p5-Archive-Tar 2> /dev/null`
if (test "$a" != "") then {
# http://www.openbsd.org/faq/upgrade45.html
	vac="$vac 4.4 a 4.5";	
	echo "Aplicando actualizaciones de 4.4 a 4.5" >> /var/www/tmp/inst-adJ.bitacora;
	#useradd -u94 -g=uid -c"Servicio Bluetooth" -d/var/empty -s/sbin/nologin _btd Retirado en 5.5
	for i in p5-Archive-Tar p5-Compress-Raw-Zlib p5-Compress-Zlib \
p5-IO-Compress-Base p5-IO-Compress-Zlib p5-IO-Zlib p5-Module-Build \
p5-Module-CoreList p5-Module-Load p5-version p5-Digest-SHA \
p5-Locale-Maketext-Simple p5-Pod-Escapes p5-Pod-Simple \
p5-ExtUtils-ParseXS p5-ExtUtils-CBuilder p5-Module-Pluggable \
p5-Time-Piece p5-Module-Loaded xcompmgr; do
		pkg_delete -I -D dependencies $i 2>> /var/www/tmp/inst-adJ.bitacora 2>&1
	done;
	ed /etc/mixerctl.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/headphones/hp/g
w
q
EOF
	ed /etc/mixerctl.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/speaker/spkr/g
w
q
EOF
	ed /etc/X11/xorg.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/i810/intel/g
w
q
EOF
	ed /etc/X11/xorg.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/.*RgbPath .*//g
w
q
EOF

	find /usr/X11R6/lib/modules ! -newer libscanpci.la | xargs rm -f >> /var/www/tmp/inst-adJ.bitacora 2>&1

} fi;

	
userinfo _nsd >/dev/null 2>&1
if (test "$?" != "0") then {
# http://www.openbsd.org/faq/upgrade47.html
	vac="$vac 4.6 a 4.7";	
	mac="$mac Copia de respaldo de /etc/pf.conf inicial dejada en /etc/pf46.conf. Es importante verificar /etc/pf.conf manualmente\n"
	echo "Aplicando actualizaciones de 4.6 a 4.7" >> /var/www/tmp/inst-adJ.bitacora;
	useradd -u 97 -g =uid -c "NSD Service" -d /var/empty -s /sbin/nologin _nsd
	useradd -u 98 -g =uid -c "LDP Service" -d /var/empty -s /sbin/nologin _ldpd

	cp /etc/pf.conf /etc/pf46.conf
	cat > /tmp/z.sed << EOF
s/^ *nat  *on  *\(.*\) *->  *\(.*\)/match out on \1 nat-to \2/g
/^ *rdr  *pass  *on  *.* *->  *.*/ {
	G;
	s/^ *rdr  *pass  *on  *\(.*\) *->  *\(.*\n\)/match in on \1 rdr-to \2pass in on \1/g;
}
s/^ *rdr  *pass  *on  *\(.*\) *->  *\(.*\)/pass in on \1\nmatch in on \1 rdr-to \2/g
s/^ *rdr *\(.*\) on  *\(.*\) *->  *\(.*\)/match in on \1 rdr-to \2/g
s/^ *binat  *on  *\(.*\) *->  *\(.*\)/match on \1 binat-to \2/g
s/^ *nat-anchor .*/#&/g
s/^ *rdr-anchor .*/#&/g
s/^ *pass  *in  *on  *\(.*\)  *route-to  *\(.*\)  *from  *\(.*\)/pass in on \1 from \3 route-to \2/g
s/^ *pass  *in  *on  *\(.*\)  *reply-to  *\(.*\)  *to *\(.*\)/pass in on \1 to \3 reply-to \2/g
EOF
	sed -f /tmp/z.sed /etc/pf46.conf > /etc/pf.conf

} fi;



userinfo _sndio >/dev/null 2>&1
if (test "$?" != "0") then {
# http://www.openbsd.org/faq/upgrade48.html
	vac="$vac 4.7 a 4.8";	
	echo "Aplicando actualizaciones de 4.7 a 4.8" >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/include/evdns.h
	rm -f /usr/libdata/perl5/site_perl/*-openbsd/evdns.ph


	# Actulizaciones a X.Org
	cd /usr/X11R6/include/X11
	rm -f Xaw/Print.h Xaw/PrintSP.h
	rm -rf XprintAppUtil XprintUtil
	cd extensions
	rm -f Print.h Printstr.h XEVIstr.h Xagstr.h Xcupstr.h Xdbeproto.h Xevie.h \
	Xeviestr.h dpmsstr.h lbxdeltastr.h lbxopts.h lbxstr.h lbxzlib.h \
	mitmiscstr.h multibufst.h securstr.h shapestr.h shmstr.h syncstr.h \
	xteststr.h xtrapbits.h xtrapddmi.h xtrapdi.h xtrapemacros.h \
	xtraplib.h xtraplibp.h xtrapproto.h
	cd /usr/X11R6/lib/pkgconfig
	rm -f evieproto.pc lbxutil.pc printproto.pc trapproto.pc xaw8.pc \
	xevie.pc xp.pc xprintapputil.pc xprintutil.pc xtrap.pc
	rm -f /usr/X11R6/share/aclocal/xaw.m4

	# fortran77 en ports
	rm -f /usr/bin/f77 /usr/bin/g77 /usr/include/f2c.h /usr/include/g2c.h \
	/usr/lib/gcc-lib/*-unknown-openbsd*/3.3.5/f771 /usr/lib/libfrtbegin.a \
	/usr/lib/libfrtbegin_p.a /usr/lib/libfrtbegin_pic.a /usr/lib/libg2c.a \
	/usr/lib/libg2c_p.a /usr/lib/libg2c_pic.a /usr/share/info/g77.info \
	/usr/share/man/cat1/f77.0 /usr/share/man/cat1/g77.0

	useradd -u 99 -g =uid -c "sndio privsep" -d /var/empty -s /sbin/nologin _sndio
	useradd -u 100 -g =uid -c "LDAP Service" -d /var/empty -s /sbin/nologin _ldapd
	useradd -u 101 -g =uid -c "IKEv2 Service" -d /var/empty -s /sbin/nologin _iked

} fi;

if (test -f /usr/bin/addftinfo) then {
	vac="$vac 4.8 a 4.9";	
	echo "Aplicando actualizaciones de 4.8 a 4.9" >> /var/www/tmp/inst-adJ.bitacora;
	(cd /usr/bin; rm -f addftinfo afmtodit eqn grodvi groff grog grohtml grolj4 grops grotty \
   hpftodit indxbib lkbib lookbib neqn nroff pfbtops pic psbb refer sectok soelim \
   tbl tfmtodit troff)
	(cd /usr/share; rm -rf dict/eign groff_font tmac doc/psd doc/smm doc/usd groff)
	(cd /usr/share/man/cat1; rm -f addftinfo.0 afmtodit.0 eqn.0 grodvi.0 groff.0 grog.0 grohtml.0 grolj4.0 \
   grops.0 grotty.0 hpftodit.0 indxbib.0 lkbib.0 lookbib.0 neqn.0 nroff.0 \
   pfbtops.0 pic.0 psbb.0 refer.0 sectok.0 soelim.0 tbl.0 tfmtodit.0 troff.0)
	(cd /usr/share/man/cat3; rm -f sectok.0 sectok_apdu.0 sectok_cardpresent.0 sectok_close.0 \
   sectok_dump_reply.0 sectok_fdump_reply.0 sectok_fmt_fid.0 \
   sectok_friendly_open.0 sectok_get_input.0 sectok_get_ins.0 \
   sectok_get_sw.0 sectok_open.0 sectok_parse_atr.0 \
   sectok_parse_fname.0 sectok_parse_input.0 sectok_print_sw.0 \
   sectok_reset.0 sectok_selectfile.0 sectok_swOK.0 sectok_xopen.0)
	(cd /usr/share/man/cat5; rm -f groff_font.0 groff_out.0)
	(cd /usr/share/man/cat7; rm -f groff_char.0 groff_me.0 groff_mm.0 groff_mmse.0 groff_ms.0 groff_msafer.0 \
   me.0 mm.0 ms.0)

	rm -f /usr/bin/vgrind /usr/share/man/cat1/vgrind.0 /usr/share/man/cat5/vgrindefs.0 /usr/share/misc/vgrindefs /usr/share/misc/vgrindefs.db

	rm -f /usr/bin/colcrt /usr/share/man/cat1/colcrt.0
	rm -f /usr/bin/checknr /usr/share/man/cat1/checknr.0

	rm -f /sbin/wpa-psk

	rm -f /usr/X11R6/bin/xft-config  /usr/X11R6/man/man1/xft-config.1 \
   /usr/X11R6/include/X11/extensions/lbxbuf.h \
   /usr/X11R6/include/X11/extensions/lbxbufstr.h \
   /usr/X11R6/include/X11/extensions/lbximage.h

	echo "Verificando sintaxis para redes inalambricas WPA" >> /var/www/tmp/inst-adJ.bitacora; 
	for i in /etc/hostname.*; do
		grep wpapsk $i
		if (test "$?" == "0" -a ! -f $i.copia49) then {
			echo "Remplazando en $i"
			cp $i $i.copia49
			sed -e "s/nwid  *\([^ ]*\)  *wpapsk  *`wpa-psk  *[^ ]*  *\([^ ]\)`/nwid \1 wpakey \2" $i copia49 > $i
		} fi;
	done;
} fi;

if (test -f /etc/security) then {
	vac="$vac 4.9 a 5.0";	
	echo "Aplicando actualizaciones de 4.9 a 5.0" >> /var/www/tmp/inst-adJ.bitacora;
	mv /etc/security /etc/security49.anterior
	rm -rf /etc/X11/xkb /usr/lib/gcc-lib/$(arch -s)-unknown-openbsd4.? /usr/bin/perl5.10.1 /usr/libdata/perl5/$(arch -s)-openbsd/5.10.1 
	cp /etc/pf.conf /etc/pf49.conf
	cat > /tmp/z.sed << EOF
s/pass  *in  *quick  *proto  *tcp  *to  *port  *ftp  *rdr-to  *127.0.0.1  *port  *8021/pass in quick inet proto tcp to port ftp divert-to 127.0.0.1 port 8021/g
s/pass  *in  *quick  *on  *internal  *proto  *udp  *to  *port  *tftp  *rdr-to  *127.0.0.1  *port  *6969/pass in quick on internal inet proto udp to port tftp divert-to 127.0.0.1 port 6969/g
EOF
	sed -f /tmp/z.sed /etc/pf49.conf > /etc/pf.conf
} fi;

if (test ! -f /var/named/standard/root.hint) then {
	cp /var/named/etc/root.hint /var/named/standard/ > /dev/null 2>&1
} fi;
	

if (test ! -f /var/named/standard/root.hint) then {
	cp /var/named/etc/root.hint /var/named/standard/ > /dev/null 2>&1
} fi;
if (test -d /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl) then {
	vac="$vac 5.0 a 5.1";	
	echo "Aplicando actualizaciones de 5.0 a 5.1" >> /var/www/tmp/inst-adJ.bitacora;
	rm -rf /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl
	rm -f /etc/rc.d/aucat
	rm -f /etc/ccd.conf /sbin/ccdconfig /usr/share/man/man8/ccdconfig.8
	rm -f /usr/sbin/pkg_merge
	rm -f /usr/libexec/getNAME /usr/share/man/man8/getNAME.8
	rm -rf /usr/lib/gcc-lib/amd64-unknown-openbsd5.0
	rm -f /usr/bin/midicat /usr/share/man/man1/midicat.1
	rm -f /usr/bin/makewhatis /usr/bin/mandocdb /usr/share/man/man8/mandocdb.8
} fi;
if (test -f /usr/bin/lint) then {
	vac="$vac 5.1 a 5.2";	
	echo "Aplicando actualizaciones de 5.1 a 5.2 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -rf /usr/bin/lint /usr/libexec/lint[12] /usr/share/man/man1/lint.1 \
	       	/etc/rc.d/btd /usr/sbin/pkg /sbin/raidctl \
	       	/usr/share/man/man4/raid.4 /usr/share/man/man8/raidctl.8
	rm -rf /usr/libdata/lint /usr/libexec/tftpd
	rm -rf /usr/lib/gcc-lib/*-unknown-openbsd5.1
	pkg_delete -I -D dependencies sqlite3 > /dev/null 2>&1
} fi;
if (test -f /usr/bin/pmdb) then {
	vac="$vac 5.2 a 5.3";	
	echo "Aplicando actualizaciones de 5.2 a 5.3 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/bin/pmdb /usr/share/man/man1/pmdb.1
	rm -rf /usr/X11R6/lib/X11/config
	rm -f /usr/X11R6/bin/{ccmakedep,cleanlinks,imake,makeg,mergelib,mkdirhier,mkhtmlindex,revpath,xmkmf}
	rm -f /usr/X11R6/man/man1/{ccmakedep,cleanlinks,imake,makeg,mergelib,mkdirhier,mkhtmlindex,revpath,xmkmf}.1
	rm -r /usr/lib/gcc-lib/*-unknown-openbsd5.2
} fi;

if (test -d /usr/share/locale/de_AT -o -f /usr/include/pcap-int.h) then {
	vac="$vac 5.3 a 5.4";	
	echo "Aplicando actualizaciones de 5.3 a 5.4 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -rf /usr/share/locale/*_*.* /usr/share/locale/de_AT
	rm -rf /usr/include/pcap-int.h
	rm -rf /usr/libdata/perl5/site_perl/*/pcap-int.ph

	rm -f /usr/X11R6/include/xorg/{mibstore.h,synaptics.h,xaa.h,xaalocal.h}
	rm -f /usr/X11R6/lib/modules/extensions/lib{dbe,dri,dri2,extmod,record}.{la,so}
	rm -f /usr/X11R6/lib/modules/extensions/lib/libxaa.{la,so}
	rm -f /usr/share/man/man{9/{re,}lookup.9,/_Exit.3}
	rm -f /usr/include/spinlock.h
	rm -f /usr/libdata/perl5/site_perl/*/spinlock.ph
	rm -f /etc/kerberosV/README
	rm -f /usr/bin/{afslog,hxtool,kauth,kadmin,ksu,pagsh,kswitch}
	rm -f /usr/lib/lib{heimntlm.*,heimntlm_p.*,hx509.*,hx509_p.*}
	rm -f /usr/libdata/perl5/site_perl/*-openbsd/com_err.ph
	rm -f /usr/libdata/perl5/site_perl/*-openbsd/kerberosV/{crmf_asn1,heimntlm-protos,heimntlm,hx509-private,hdb-private}.ph
	rm -f /usr/libdata/perl5/site_perl/*-openbsd/kerberosV/{hx509-protos,hx509,hx509_err,kx509_asn1,ntlm_err,ocsp_asn1,pkcs10_asn1}.ph
	rm -f /usr/libdata/perl5/site_perl/*-openbsd/kerberosV/{pkcs12_asn1,pkcs8_asn1,pkcs9_asn1,pkinit_asn1,gssapi/gssapi_spnego,spnego_asn1}.ph
	rm -f /usr/libexec/{digest-service,kimpersonate,kdigest,kcm}
	rm -f /usr/include/com_err.h
	rm -f /usr/include/kerberosV/{crmf_asn1,hdb-private,heimntlm-protos,heimntlm,hx509-private}.h
	rm -f /usr/include/kerberosV/{hx509-protos,hx509,hx509_err,kx509_asn1,ntlm_err,ocsp_asn1,pkcs10_asn1,pkcs12_asn1}.h
	rm -f /usr/include/kerberosV/{pkcs8_asn1,pkcs9_asn1,pkinit_asn1,spnego_asn1,gssapi/gssapi_spnego}.h
	rm -f /usr/sbin/kdigest
	if (test -f "/var/heimdal") then {
		echo "Kerberos requiere actualización especial";
		echo "/etc/rc.d/kadmind stop; /etc/rc.d/kpasswdd stop; /etc/rc.d/kdc stop; cp -Rp /var/heimdal /var/kerberosV"
		echo "Actualizar y después: rm -rf /var/heimdal";
		echo "Regrese a este script con 'exit'";
		sh
	} fi;
} fi;

if (test -f /usr/libexec/identd) then {
	vac="$vac 5.4 a 5.5";	
	echo "Aplicando actualizaciones de 5.4 a 5.5 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/libexec/identd
	rm -f /usr/lib/libcompat.a /usr/lib/libcompat_p.a
	rm -f /usr/include/{re_comp,regexp,sgtty,sys/timeb}.h
	rm -f /usr/share/man/man3/{re_comp,re_exec,rexec,regexp}.3
	rm -f /usr/share/man/man3/{cuserid,ftime,gtty,setrgid,setruid,stty}.3
	rm -f /etc/rc.d/popa3d
	rm -f /usr/bin/{crunchgen,nawk}
	rm -f /usr/sbin/{iopctl,popa3d}
	rm -f /usr/share/man/man8/{iopctl,popa3d}.8
	rm -rf /usr/X11R6/include/freetype2/freetype
	rm -f /usr/X11R6/include/ft2build.h
	rm -f /usr/mdec/installboot
	rm -f /usr/share/man/man8/{amd64,i386}/installboot.8
	rm -f /var/account/acct
	rm -f /var/games/tetris.scores

	mv /etc/nsd.conf /var/nsd/etc/nsd.conf
	cd /usr/sbin && rm nsd-notify nsd-patch nsd-xfer nsd-zonec nsdc
	cd /usr/share/man/man8 && rm nsd-notify.8 nsd-patch.8 nsd-xfer.8 \
		nsd-zonec.8 nsdc.8
	chown _nsd /var/nsd/db/nsd.db
	printf '\nremote-control:\n\tcontrol-enable: yes\n' >> /var/nsd/etc/nsd.conf
} fi;

if (test -f /usr/sbin/spray) then {
	vac="$vac 5.5 a 5.6";	
	echo "Aplicando actualizaciones de 5.5 a 5.6 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/sbin/spray
	rm -f /usr/libexec/rpc.sprayd
	rm -f /usr/share/man/man8/{,rpc.}spray{,d}.8
	rm -rf /usr/lib/apache
	rm -rf /usr/share/doc/html/httpd
	rm -f /usr/bin/{dbmmanage,htdigest}
	rm -f /usr/sbin/{apachectl,apxs,logresolve,rotatelogs,suexec}
	rm -f /usr/share/man/man1/{dbmmanage.1,htdigest.1}
	rm -f /usr/share/man/man8/{apachectl.8,apxs.8,logresolve.8}
	rm -f /usr/share/man/man8/{rotatelogs.8,suexec.8}
	rm -f /usr/include/sys/agpio.h
	rm -f /etc/ppp/ppp.{conf,linkdown,linkup,secret}.sample
	rm -f /usr/sbin/ppp /usr/share/man/man8/ppp.8
	rm -f /usr/sbin/pppctl /usr/share/man/man8/pppctl.8
	rm -f /usr/sbin/pppoe /usr/share/man/man8/pppoe.8
	
	rm -f /bin/rcp /usr/share/man/man1/rcp.1
	rm -f /usr/lib/librt{,_p}.a
	rm -f /usr/include/bm.h
	rm -f /usr/include/md4.h
	rm -f /usr/lib/libwrap{,_p}.*
	rm -f /usr/libexec/tcpd
	rm -f /usr/include/tcpd.h
	rm -f /usr/sbin/tcpd{chk,match}
	rm -f /usr/share/man/man3/hosts_access.3
	rm -f /usr/share/man/man5/hosts.{allow,deny}.5
	rm -f /usr/share/man/man5/hosts_{access,options}.5
	rm -f /usr/share/man/man8/tcpd{,chk,match}.8
	rm -f /etc/hosts.{allow,deny}
	rm -f /bin/rmail
	rm -f /usr/share/man/man8/rmail.8
	
	rm -f /usr/libexec/uucpd
	rm -f /usr/share/man/man8/uucpd.8
	rm -rf /usr/include/altq
	rm -rf /etc/kerberosV/
	rm -f /etc/rc.d/{kadmind,kdc,kpasswdd,ipropd_master,ipropd_slave}
	rm -f /usr/bin/asn1_compile
	rm -f /usr/bin/compile_et
	rm -f /usr/bin/kcc
	rm -f /usr/bin/kdestroy
	rm -f /usr/bin/kf
	rm -f /usr/bin/kgetcred
	rm -f /usr/bin/kinit
	rm -f /usr/bin/klist
	rm -f /usr/bin/krb5-config
	rm -f /usr/bin/slc
	
	rm -f /usr/bin/string2key
	rm -f /usr/bin/verify_krb5_conf
	rm -rf /usr/include/kerberosV/
	rm -f /usr/lib/libasn1{,_p}.*
	rm -f /usr/lib/libcom_err{,_p}.*
	rm -f /usr/lib/libgssapi{,_p}.*
	rm -f /usr/lib/libhdb{,_p}.*
	rm -f /usr/lib/libheimbase{,_p}.*
	rm -f /usr/lib/libkadm5clnt{,_p}.*
	rm -f /usr/lib/libkadm5srv{,_p}.*
	rm -f /usr/lib/libkafs{,_p}.*
	rm -f /usr/lib/libkdc{,_p}.*
	rm -f /usr/lib/libkrb5{,_p}.*
	rm -f /usr/lib/libroken{,_p}.*
	rm -f /usr/lib/libwind{,_p}.*
	
	rm -rf /usr/libdata/perl5/site_perl/*-openbsd/kerberosV/
	rm -f /usr/libexec/auth/login_krb5{,-or-pwd}
	rm -f /usr/libexec/hprop{,d}
	rm -f /usr/libexec/ipropd-{master,slave}
	rm -f /usr/libexec/kadmind
	rm -f /usr/libexec/kdc
	rm -f /usr/libexec/kfd
	rm -f /usr/libexec/kpasswdd
	rm -f /usr/sbin/iprop-log
	rm -f /usr/sbin/kadmin
	rm -f /usr/sbin/kimpersonate
	rm -f /usr/sbin/kstash
	rm -f /usr/sbin/ktutil
	rm -f /usr/share/info/heimdal.info
	rm -f /usr/share/man/man1/kdestroy.1
	
	rm -f /usr/share/man/man1/kf.1
	rm -f /usr/share/man/man1/kgetcred.1
	rm -f /usr/share/man/man1/kinit.1
	rm -f /usr/share/man/man1/klist.1
	rm -f /usr/share/man/man1/krb5-config.1
	rm -f /usr/share/man/man1/kswitch.1
	rm -f /usr/share/man/man3/ecalloc.3
	rm -f /usr/share/man/man3/getarg.3
	rm -f /usr/share/man/man3/{gss,krb5,krb}_*.3
	rm -f /usr/share/man/man3/gssapi.3
	rm -f /usr/share/man/man3/gsskrb5_extract_authz_data_from_sec_context.3
	rm -f /usr/share/man/man3/gsskrb5_register_acceptor_identity.3
	rm -f /usr/share/man/man3/k_afs_cell_of_file.3
	rm -f /usr/share/man/man3/k_hasafs.3
	rm -f /usr/share/man/man3/k_hasafs_recheck.3
	
	rm -f /usr/share/man/man3/k_pioctl.3
	rm -f /usr/share/man/man3/k_setpag.3
	rm -f /usr/share/man/man3/k_unlog.3
	rm -f /usr/share/man/man3/kadm5_pwcheck.3
	rm -f /usr/share/man/man3/kafs*.3
	rm -f /usr/share/man/man3/krb524_*.3
	rm -f /usr/share/man/man3/parse_time.3
	rm -f /usr/share/man/man3/rtbl.3
	rm -f /usr/share/man/man5/krb5.conf.5
	rm -f /usr/share/man/man5/mech.5
	rm -f /usr/share/man/man8/hprop{,d}.8
	rm -f /usr/share/man/man8/iprop{,-log}.8
	rm -f /usr/share/man/man8/ipropd-{master,slave}.8
	rm -f /usr/share/man/man8/kadmin{,d}.8
	rm -f /usr/share/man/man8/kdc.8
	
	rm -f /usr/share/man/man8/kerberos.8
	rm -f /usr/share/man/man8/kfd.8
	rm -f /usr/share/man/man8/kimpersonate.8
	rm -f /usr/share/man/man8/kpasswdd.8
	rm -f /usr/share/man/man8/kstash.8
	rm -f /usr/share/man/man8/ktutil.8
	rm -f /usr/share/man/man8/login_krb5{,-or-pwd}.8
	rm -f /usr/share/man/man8/string2key.8
	rm -f /usr/share/man/man8/verify_krb5_conf.8
	rm -f /usr/bin/lynx
	rm -f /usr/share/man/man1/lynx.1
	rm -rf /usr/share/doc/html/lynx_help
	rm -f /etc/lynx.cfg
	
	rm -f /usr/bin/{rsh,ruptime,rwho}
	rm -f /usr/sbin/rwhod
	rm -f /etc/rc.d/rwhod
	rm -f /usr/libexec/rshd
	rm -f /usr/share/man/man1/{rwho,ruptime,rsh}.1
	rm -f /usr/share/man/man8/{rwhod,rshd}.8
	rm -rf /var/rwho
	
	chown -R _smtpq /var/spool/smtpd/{corrupt,incoming,purge,queue,temporary}
	useradd -u103 -g=uid -c"Servicio SMTP" -d/var/empty -s/sbin/nologin _smtpq

	# apache httpd eliminado
	rm -rf /usr/lib/apache /usr/share/doc/html/httpd /usr/bin{dbmmanage,htdigest} 
	rm -rf /usr/sbin/{apacehctl,apxs,httpd,logresolve,rotatelogs,suexec}
	rm -rf /usr/share/man/man1/{dbmmanage.1,htdigest.1}
	rm -rf /usr/share/man/man8/{apacehctl.8,apxs.8,httpd.8,logresolve.8}
	rm -rf /usr/share/man/man8/{rotatelogs.8,suexec.8}
	rm -rf /etc/rc.d/httpd

	useradd -u53 -g=uid -c"Servicio Unbound" -d/var/unbound -s/sbin/nologin _unbound
	

	# No consigandos en upgrade FAQ pero sin en changelog web
	rm -f /usr/bin/asa
	rm -f /usr/bin/bdes

} fi;

	
if (test -f /usr/include/ressl.h) then {
	vac="$vac 5.6 a 5.7";	
	echo "Aplicando actualizaciones de 5.6 a 5.7 " >> /var/www/tmp/inst-adJ.bitacora;


	(cd /etc/X11/app-defaults; \
	rm -f Beforelight Bitmap Bitmap-color Bitmap-nocase Chooser Clock-color ; \
	rm -f Editres Editres-color KOI8RXTerm SshAskpass UXTerm Viewres; \
	rm -f Viewres-color XCalc XCalc-color XClipboard XClock; \
	rm -f XClock-color XConsole XFontSel XLoad XLock XLogo; \
	rm -f XLogo-color XMore XSm XTerm XTerm-color Xedit; \
	rm -f Xedit-color Xfd Xgc Xgc-color Xmag Xman Xmessage; \
	rm -f Xmessage-color Xsystrace Xvidtune; \
	)

	rm -f /etc/rc.d/named
	rm -f /usr/sbin/dnssec-keygen
	rm -f /usr/sbin/dnssec-signzone
	rm -f /usr/sbin/named
	rm -f /usr/sbin/named-checkconf
	rm -f /usr/sbin/named-checkzone
	rm -f /usr/sbin/nsupdate
	rm -f /usr/sbin/rndc
	rm -f /usr/sbin/rndc-confgen
	rm -f /usr/share/man/man5/named.conf.5
	rm -f /usr/share/man/man5/rndc.conf.5
	rm -f /usr/share/man/man8/dnssec-keygen.8
	rm -f /usr/share/man/man8/dnssec-signzone.8
	rm -f /usr/share/man/man8/named.8
	rm -f /usr/share/man/man8/named-checkconf.8
	rm -f /usr/share/man/man8/named-checkzone.8
	rm -f /usr/share/man/man8/nsupdate.8
	rm -f /usr/share/man/man8/rndc-confgen.8
	rm -f /usr/share/man/man8/rndc.8

	rm -f /usr/sbin/openssl
	rm -f /etc/rc.d/nginx
	rm -f /usr/sbin/nginx
	rm -f /usr/share/man/man8/nginx.8
	rm -f /usr/share/man/man5/nginx.conf.5
	rm -f /sbin/mount_procfs
	rm -f /usr/share/man/man8/mount_procfs.8
	rm -rf /usr/include/libmilter
	rm -rf /usr/libdata/perl5/site_perl/`uname -p`-openbsd/libmilter
	rm -rf /usr/libexec/sendmail
	rm -rf /usr/share/sendmail  # preserve mc files first if needed

	rm -f /etc/rc.d/sendmail
	rm -f /usr/lib/{libmilter.a,libmilter.so.3.0,libmilter_p.a}
	rm -f /usr/libexec/smrsh
	rm -f /usr/sbin/{editmap,mailstats,praliases}
	rm -f /usr/share/man/man1/{hoststat.1,praliases.1,purgestat.1}
	rm -f /usr/share/man/man8/{editmap.8,mailq.8,mailstats.8,smrsh.8}
	rm -f /var/log/sendmail.st
	rmdir /usr/libexec/sm.bin
	rm -rf /usr/lkm /usr/share/lkm /dev/lkm
	rm -f /usr/bin/modstat
	rm -f /sbin/mod{,un}load
	rm -f /usr/share/man/man8/mod{stat,load,unload}.8
	rm -f /usr/share/man/man4/lkm.4
	rm -f /usr/share/mk/bsd.lkm.mk /usr/include/sys/lkm.h

	rm -f /usr/include/ressl.h
	rm -f /usr/lib/libressl.* /usr/lib/libressl_*
	rm -f /usr/share/man/man3/ressl_*
	rm -f /usr/mdec/installboot /usr/share/man/man8/sparc64/installboot.8
	rm -f /etc/rc.d/rtsold /sbin/rtsol /usr/sbin/rtsold
	rm -f /usr/share/man/man8/rtsol.8 /usr/share/man/man8/rtsold.8
	rm -f /usr/X11R6/include/GL/glcorearb.h
	rm -f /usr/X11R6/include/EGL/eglextchromium.h

	rm -r /var/tmp
	ln -s /tmp /var/tmp

	groupdel _lkm > /dev/null 2>&1
	userdel smmsp > /dev/null 2>&1
	groupdel smmsp > /dev/null 2>&1

	pkg_delete basico_OpenBSD
	pkg_delete usuario_OpenBSD
	pkg_delete servidor_OpenBSD
	
	# No consigandos en upgrade FAQ pero sin en changelog web
	rm -f /usr/bin/gzsig
} fi;

echo "* Configurar doas" >> /var/www/tmp/inst-adJ.bitacora;
grep "^permit *nopass.*:wheel" /etc/doas.conf > /dev/null 2>&1
if (test "$?" != "0") then {
	touch /etc/doas.conf
	chmod +w /etc/doas.conf
	echo "permit nopass keepenv :wheel" >> /etc/doas.conf
	chmod -w /etc/doas.conf
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;


if (test -f /usr/bin/sudo) then {
	vac="$vac 5.7 a 5.8";	
	echo "Aplicando actualizaciones de 5.7 a 5.8 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/bin/sudo /usr/bin/sudoedit /usr/sbin/visudo
	rm -f /usr/share/man/man8/sudo.8 /usr/share/man/man8/sudoedit.8
	rm -f /usr/share/man/man8/visudo.8 /usr/share/man/man5/sudoers.5
	rm -f /usr/libexec/sudo_noexec.so
	# No consigandos en upgrade FAQ pero sin en changelog web
	rm -f /sbin/lmccontrol
	rm -f /sbin/slattach
	rm -f /usr/bin/tcopy
	rm -f /usr/bin/tip
} fi;

if (test -f /usr/share/misc/termcap.db) then {
	vac="$vac 5.8 a 5.9";	
	echo "Aplicando actualizaciones de 5.8 a 5.9 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/libexec/smtpd/makemap

	# opensmtpd-extras incluye los siguientes
	rm -f /usr/libexec/smtpd/table-ldap
	rm -f /usr/libexec/smtpd/table-passwd
	rm -f /usr/libexec/smtpd/table-sqlite
	rm -f /usr/share/man/man5/table_passwd.5

	rm -f /usr/share/misc/termcap.db /usr/share/misc/terminfo.db

	rm -f /usr/X11R6/include/intel_*.h
	rm -f /usr/X11R6/include/r600_pci_ids.h
	rm -f /usr/X11R6/include/radeon_*.h

	rm -f /usr/include/malloc.h

	rm -f /usr/libexec/auth/login_tis
	rm -f /etc/rc.d/yppasswdd /usr/sbin/rpc.yppasswdd

	cd /usr/X11R6/include/freetype2
	rm -rf config
	rm -f freetype.h ftadvanc.h ftbbox.h ftbdf.h ftbitmap.h ftbzip2.h \
          ftcache.h ftcffdrv.h ftchapters.h ftcid.h fterrdef.h \
          fterrors.h ftfntfmt.h ftgasp.h ftglyph.h ftgxval.h ftgzip.h \
          ftimage.h ftincrem.h ftlcdfil.h ftlist.h ftlzw.h ftmac.h \
          ftmm.h ftmodapi.h ftmoderr.h ftotval.h ftoutln.h ftpfr.h \
          ftrender.h ftsizes.h ftsnames.h ftstroke.h ftsynth.h \
          ftsystem.h fttrigon.h fttypes.h ftwinfnt.h t1tables.h \
          ttnameid.h tttables.h tttags.h ttunpat.h

	# No consigandos en upgrade FAQ pero sin en changelog web
	rm -f /usr/sbin/lptest
} fi;
	
if (test -f /usr/bin/sqlite3) then {
	vac="$vac 6.0 a 6.1";	
	echo "Aplicando actualizaciones de 6.0 a 6.1 " >> /var/www/tmp/inst-adJ.bitacora;
	rm -rf /usr/share/man
	makewhatis
	rm /usr/bin/sqlite3
	rm /usr/include/sqlite3*.h
	rm /usr/lib/pkgconfig/sqlite3.pc
	rm /usr/libdata/perl5/site_perl/*-openbsd/sqlite3*.ph
	rm /usr/lib/libsqlite3*
	userdel uucp
	groupdel news
	rm -rf /var/spool/uucp*
	cd /usr/X11R6
	rm bin/koi8rxterm bin/uxterm
	rm share/X11/app-defaults/KOI8RXTerm share/X11/app-defaults/UXTerm
	rm man/man1/koi8rxterm.1 man/man1/uxterm.1
	grep "xdm_flags *= *$" /etc/rc.conf.local > /dev/null 2>&1
	if (test "$?" = "0") then {
		rcctl disable xdm
		rcctl enable xenodm
	} fi;
	rm -rf /etc/X11/xdm
	rm /usr/X11R6/bin/xdm /usr/X11R6/man/man1/xdm.1 /etc/rc.d/xdm

	rm /etc{,/examples}/pkg.conf

	rm -rf /usr/libdata/perl5/site_perl \
		/usr/bin/perl5* \
		/usr/lib/libperl.so.17.* \
		/usr/libdata/perl5/*-openbsd/5.*/ \
		/usr/bin/a2p \
		/usr/bin/config_data \
		/usr/bin/find2perl \
		/usr/bin/psed \
		/usr/bin/s2p \
		/usr/libdata/perl5/CGI* \
		/usr/libdata/perl5/Locale/Codes/Constants.pod \
		/usr/libdata/perl5/Module/Build* \
		/usr/libdata/perl5/Package \
		/usr/libdata/perl5/inc \
		/usr/libdata/perl5/pod/a2p.pod \
		/usr/libdata/perl5/unicore/lib/Gc/Lt.pl \
		/usr/libdata/perl5/unicore/lib/Hyphen/Y.pl \
		/usr/libdata/perl5/unicore/lib/LOE \
		/usr/libdata/perl5/unicore/lib/NChar \
		/usr/libdata/perl5/unicore/lib/PatWS \
		/usr/libdata/perl5/unicore/lib/Perl/_XExtend.pl \
		/usr/libdata/perl5/unicore/lib/Perl/_XRegula.pl \
		/usr/libdata/perl5/unicore/lib/Perl/_XSpecia.pl \
		/usr/libdata/perl5/unicore/lib/Space \
		/usr/libdata/perl5/version/vpp.pm

	rm -f /dev/sound*

} fi;

if (test -d /var/db/pkg/ispell-spanish-*) then {
	vac="$vac 6.1 a 6.2";	
	echo "Aplicando actualizaciones de 6.1 a 6.2 " >> /var/www/tmp/inst-adJ.bitacora;
        pkg_delete -D dependencies ispell
} fi;

if (test -f /etc/rc.d/rtadvd) then {
	vac="$vac 6.3 a 6.4";	
	echo "Aplicando actualizaciones de 6.3 a 6.4" >> /var/www/tmp/inst-adJ.bitacora;

	rm /dev/audio /dev/audioctl
	rm /etc/rc.d/rtadvd /usr/sbin/rtadvd /usr/share/man/man5/rtadvd.conf.5 /usr/share/man/man8/rtadvd.8
	userdel _rtadvd
	groupdel _rtadvd
	rm /usr/X11R6/lib/libxcb-xevie.*
	rm /usr/X11R6/lib/libxcb-xprint.*
	rm /usr/X11R6/lib/pkgconfig/xcb-xevie.pc
	rm /usr/X11R6/lib/pkgconfig/xcb-xprint.pc
} fi;

if (test -f /usr/include/openssl/asn1_mac.h) then {
	vac="$vac 6.4 a 6.5";
	echo "Aplicando actualizaciones de 6.4 a 6.5" >> /var/www/tmp/inst-adJ.bitacora;

	rm /usr/include/openssl/asn1_mac.h
        rm /usr/bin/c2ph \
          /usr/bin/pstruct \
          /usr/libdata/perl5/Locale/Codes/API.pod \
          /usr/libdata/perl5/Module/CoreList/TieHashDelta.pm \
          /usr/libdata/perl5/Unicode/Collate/Locale/bg.pl \
          /usr/libdata/perl5/Unicode/Collate/Locale/fr.pl \
          /usr/libdata/perl5/Unicode/Collate/Locale/ru.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Cham.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Ethi.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Hebr.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Hmng.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Khar.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Khmr.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Lana.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Lao.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Talu.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Tibt.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Xsux.pl \
          /usr/libdata/perl5/unicore/lib/Sc/Zzzz.pl \
          /usr/share/man/man1/c2ph.1 \
          /usr/share/man/man1/pstruct.1 \
          /usr/share/man/man3p/Locale::Codes::API.3p
} fi;

if (test -f /usr/sbin/snmpctl) then {
	vac="$vac 6.5 a 6.6";
	echo "Aplicando actualizaciones de 6.5 a 6.6" >> /var/www/tmp/inst-adJ.bitacora;
	rm -f /usr/share/man/man3p/carp.3p \
		/usr/share/man/man3p/Tie::ExtraHash.3p \
		/usr/share/man/man3p/Tie::StdHash.3p \
		/usr/share/man/man3p/Tie::StdScalar.3p \
		/usr/share/man/man3p/basename.3p \
		/usr/share/man/man3p/cluck.3p \
		/usr/share/man/man3p/confess.3p \
		/usr/share/man/man3p/croak.3p \
		/usr/share/man/man3p/dirname.3p \
		/usr/share/man/man3p/fileparse.3p \
		/usr/share/man/man3p/getopt.3p \
		/usr/share/man/man3p/getopts.3p \
		/usr/share/man/man3p/inet_aton.3p \
		/usr/share/man/man3p/inet_ntoa.3p \
		/usr/share/man/man3p/longmess.3p \
		/usr/share/man/man3p/look.3p \
		/usr/share/man/man3p/open2.3p \
		/usr/share/man/man3p/open3.3p \
		/usr/share/man/man3p/pod2usage.3p \
		/usr/share/man/man3p/podchecker.3p \
		/usr/share/man/man3p/podselect.3p \
		/usr/share/man/man3p/shortmess.3p \
		/usr/share/man/man3p/sockaddr_in.3p \
		/usr/share/man/man3p/sockaddr_un.3p \
		/usr/share/man/man3p/writemain.3p

	rm -f /usr/sbin/snmpctl \
		/usr/share/man/man8/snmpctl.8

  	rm -f /usr/X11R6/lib/pkgconfig/libfs.pc \
		/usr/X11R6/include/X11/fonts/FSlib.h
	rm -rf  /usr/X11R6/share/doc/libFS

  	rm -f /usr/X11R6/bin/xman \
        	/usr/X11R6/lib/X11/xman.help \
        	/usr/X11R6/man/man1/xman.1 \
        	/usr/X11R6/share/X11/app-defaults/Xman

  	rm -f /usr/X11R6/lib/pkgconfig/libfs.pc \
        	/usr/X11R6/lib/modules/v10002d.uc \
		/usr/X11R6/lib/modules/v20002d.uc \
		/usr/X11R6/lib/modules/drivers/ark_drv.la \
		/usr/X11R6/lib/modules/drivers/ark_drv.so \
		/usr/X11R6/lib/modules/drivers/chips_drv.la \
		/usr/X11R6/lib/modules/drivers/chips_drv.so \
		/usr/X11R6/lib/modules/drivers/glint_drv.la \
		/usr/X11R6/lib/modules/drivers/glint_drv.so \
		/usr/X11R6/lib/modules/drivers/i128_drv.la \
		/usr/X11R6/lib/modules/drivers/i128_drv.so \
		/usr/X11R6/lib/modules/drivers/neomagic_drv.la \
		/usr/X11R6/lib/modules/drivers/neomagic_drv.so \
		/usr/X11R6/lib/modules/drivers/rendition_drv.la \
		/usr/X11R6/lib/modules/drivers/rendition_drv.so \
		/usr/X11R6/lib/modules/drivers/s3_drv.la \
		/usr/X11R6/lib/modules/drivers/s3_drv.so \
		/usr/X11R6/lib/modules/drivers/s3virge_drv.la \
		/usr/X11R6/lib/modules/drivers/s3virge_drv.so \
		/usr/X11R6/lib/modules/drivers/sis_drv.la \
		/usr/X11R6/lib/modules/drivers/sis_drv.so \
		/usr/X11R6/lib/modules/drivers/tdfx_drv.la \
		/usr/X11R6/lib/modules/drivers/tdfx_drv.so \
		/usr/X11R6/lib/modules/drivers/trident_drv.la \
		/usr/X11R6/lib/modules/drivers/trident_drv.so \
		/usr/X11R6/lib/modules/drivers/tseng_drv.la \
		/usr/X11R6/lib/modules/drivers/tseng_drv.so \
		/usr/X11R6/man/man4/chips.4 \
		/usr/X11R6/man/man4/glint.4 \
		/usr/X11R6/man/man4/i128.4 \
		/usr/X11R6/man/man4/neomagic.4 \
		/usr/X11R6/man/man4/rendition.4 \
		/usr/X11R6/man/man4/s3.4 \
		/usr/X11R6/man/man4/s3virge.4 \
		/usr/X11R6/man/man4/sis.4 \
		/usr/X11R6/man/man4/tdfx.4 \
		/usr/X11R6/man/man4/trident.4 \
		/usr/X11R6/man/man4/tseng.4 \
		/usr/X11R6/man/man3/XkbAllocGeomOverlayKey.3

  	rm -f /usr/X11R6/include/X11/fonts/FSlib.h \
        	/usr/include/dev/ic/dwc_gmac_reg.h \
		/usr/include/dev/ic/dwc_gmac_var.h \
		/usr/include/llvm/Analysis/IndirectCallSiteVisitor.h \
		/usr/include/llvm/CodeGen/GCs.h \
		/usr/include/llvm/DebugInfo/PDB/Native/NativeBuiltinSymbol.h \
		/usr/include/llvm/DebugInfo/PDB/Native/NativeEnumSymbol.h \
		/usr/include/llvm/IR/TypeBuilder.h \
		/usr/include/llvm/Transforms/Utils/OrderedInstructions.h

  	rm -f /usr/share/man/man1/clang++.1 \
		/usr/share/man/man1/clang-cpp.1 \
		/usr/share/man/man1/diagnostics.1 \
		/usr/share/man/man3/SipHash24.3 \
		/usr/share/man/man3/bitstring.3 \
		/usr/share/man/man3/byteorder.3 \
		/usr/share/man/man3/directory.3 \
		/usr/share/man/man3/ethers.3 \
		/usr/share/man/man3/exec.3 \
		/usr/share/man/man3/fts.3 \
		/usr/share/man/man3/getcap.3 \
		/usr/share/man/man3/inet_net.3 \
		/usr/share/man/man3/md5.3 \
		/usr/share/man/man3/pcap-filter.3 \
		/usr/share/man/man3/pcap.3 \
		/usr/share/man/man3/pwcache.3 \
		/usr/share/man/man3/resolver.3 \
		/usr/share/man/man3/rmd160.3 \
		/usr/share/man/man3/sha1.3 \
		/usr/share/man/man3/sha2.3 \
		/usr/share/man/man3/stdarg.3 \
		/usr/share/man/man3/uucplock.3 \
		/usr/share/man/man3/uuid.3 \
		/usr/share/man/man3/ypclnt.3 \
		/usr/share/man/man4/i386/vmm.4 \
		/usr/share/man/man4/macppc/openprom.4 \
		/usr/share/man/man4/sparc64/openprom.4


} fi;

if (test -f /usr/libdata/perl5/Math/BigInt/CalcEmu.pm) then {
	vac="$vac 6.6 a 6.7";
	echo "Aplicando actualizaciones de 6.6 a 6.7" >> /var/www/tmp/inst-adJ.bitacora;

	rm -rf /usr/libdata/perl5/*/Storable \
		/usr/libdata/perl5/*/arybase.pm \
		/usr/libdata/perl5/*/auto/arybase \
		/usr/libdata/perl5/B/Debug.pm \
		/usr/libdata/perl5/Locale/{Codes,Country,Currency,Language,Script}* \
		/usr/libdata/perl5/Math/BigInt/CalcEmu.pm \
		/usr/libdata/perl5/unicore/To/_PerlWB.pl \
		/usr/libdata/perl5/unicore/lib/GCB/EB.pl \
		/usr/libdata/perl5/unicore/lib/GCB/GAZ.pl \
		/usr/share/man/man3p/B::Debug.3p \
		/usr/share/man/man3p/Locale::{Codes*,Country,Currency,Language,Script}.3p \
		/usr/share/man/man3p/Math::BigInt::CalcEmu.3p \
		/usr/share/man/man3p/arybase.3p


	rm -f /usr/sbin/{dig,host,nslookup}

	rm -f /dev/mixer*
  id named > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel named
    groupdel named
  } fi;
  rm -rf /var/named

  id _btd > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel _btd
  } fi;

} fi;

if (test -f /usr/lib/libperl.a) then {
  vac="$vac 6.7 a 6.8";
  echo "Aplicando actualizaciones de 6.7 a 6.8" >> /var/www/tmp/inst-adJ.bitacora;
  chmod 600 /etc/npppd/npppd.conf
  rm -f /usr/lib/libperl.a
  rm /usr/X11R6/lib/libxkbui.* \
    /usr/X11R6/lib/pkgconfig/xkbui.pc \
    /usr/X11R6/include/X11/extensions/XKBui.h
  id named > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel named
    groupdel named
  } fi;
  rm -rf /var/named

  id _btd > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel _btd
  } fi;

} fi;

if (test -f /usr/bin/podselect) then {
  vac="$vac 6.8 a 6.9";
  echo "Aplicando actualizaciones de 6.8 a 6.9" >> /var/www/tmp/inst-adJ.bitacora;
  rm -rf /usr/bin/podselect \
    /usr/lib/libperl.so.20.0 \
    /usr/libdata/perl5/*/CORE/dquote_inline.h \
    /usr/libdata/perl5/*/Tie \
    /usr/libdata/perl5/*/auto/Tie \
    /usr/libdata/perl5/Pod/Find.pm \
    /usr/libdata/perl5/Pod/InputObjects.pm \
    /usr/libdata/perl5/Pod/ParseUtils.pm \
    /usr/libdata/perl5/Pod/Parser.pm \
    /usr/libdata/perl5/Pod/PlainText.pm \
    /usr/libdata/perl5/Pod/Select.pm \
    /usr/libdata/perl5/pod/perlce.pod \
    /usr/libdata/perl5/unicore/Heavy.pl \
    /usr/libdata/perl5/unicore/lib/Lb/EB.pl \
    /usr/libdata/perl5/unicore/lib/Perl/_PerlNon.pl \
    /usr/libdata/perl5/unicore/lib/Sc/Armn.pl \
    /usr/libdata/perl5/utf8_heavy.pl \
    /usr/share/man/man1/podselect.1 \
    /usr/share/man/man3p/Pod::Find.3p \
    /usr/share/man/man3p/Pod::InputObjects.3p \
    /usr/share/man/man3p/Pod::ParseUtils.3p \
    /usr/share/man/man3p/Pod::Parser.3p \
    /usr/share/man/man3p/Pod::PlainText.3p \
    /usr/share/man/man3p/Pod::Select.3p

  id named > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel named
    groupdel named
  } fi;
  rm -rf /var/named

  id _btd > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel _btd
  } fi;

} fi;

  
if (test -f /usr/X11R6/include/X11/extensions/dmxext.h) then {
  vac="$vac 6.9 a 7.0";
  echo "Aplicando actualizaciones de 6.9 a 7.0" >> /var/www/tmp/inst-adJ.bitacora;
  rm -f /usr/X11R6/lib/libdmx.*
  rm -f /usr/X11R6/include/X11/extensions/dmxext.h
  rm -f /usr/X11R6/lib/pkgconfig/dmx.pc
  rm -f /usr/X11R6/man/man3/DMX*.3

  id named > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel named
    groupdel named
  } fi;
  rm -rf /var/named

  id _btd > /dev/null 2>&1
  if (test "$?" != "0") then {
    userdel _btd
  } fi;
} fi;


if  (test "$vac" != "") then {
	dialog --title 'Actualizaciones aplicadas' --msgbox "\\nSe aplicaron actualizaciones: $vac\\n\\n$mac\\n" 15 60
} fi;

cd /etc && /usr/local/adJ/servicio-etc.sh >> /var/www/tmp/inst-adJ.bitacora 2>&1
cap_mkdb /etc/login.conf
cap_mkdb /etc/master.passwd

if (test ! -f /var/log/servicio) then {
	if (test -f /var/log/daemon) then {
		mv /var/log/daemon /var/log/servicio
	} fi;
	if (test -f /var/log/service) then {
		mv /var/log/service /var/log/servicio
	} fi;
	touch /var/log/servicio
} fi;

touch /etc/rc.local
echo "* Preparar /etc/rc.local para que reinicie servicios faltantes" >> /var/www/tmp/inst-adJ.bitacora;
echo "* Nueva forma de /etc/rc.local" >> /var/www/tmp/inst-adJ.bitacora;
grep "for _r in \${pkg_scripts}" /etc/rc.local > /dev/null 2>&1
if (test "$?" != "0") then {
	echo "Activando" >> /var/www/tmp/inst-adJ.bitacora;
	ed /etc/rc.local >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
/securel
a

# Este script podría ser ejecutado desde una tarea cron para reparar
# servicios que pudieran haberse caido.  Verifica que cada servicio 
# está efectivamente abajo antes de iniciarlo.

if (test " \$TERM" != "") then {
	pkg_scripts=\`rcctl order\`
	for _r in \${pkg_scripts}; do
		echo -n " \${_r} ";
		if (test -x /etc/rc.d/\${_r}) then {
			/etc/rc.d/\${_r} check
			if (test "\$?" != "0") then {
				echo -n "Iniciando "
				/etc/rc.d/\${_r} start
			} fi;
		} fi;
	done
} fi;
.
w
q
EOF
	if (test ! -f /etc/rc.local -o ! -s /etc/rc.local) then {
		echo "Creando" >> /var/www/tmp/inst-adJ.bitacora;
		cat > /etc/rc.local <<EOF
# Este script podría ser ejecutado desde una tarea cron para reparar
# servicios que pudieran haberse caido.  Verifica que cada servicio 
# está efectivamente abajo antes de iniciarlo.

if (test " \$TERM" != "") then {
	pkg_scripts=\`rcctl order\`
	for _r in \${pkg_scripts}; do
		echo -n " \${_r} ";
		if (test -x /etc/rc.d/\${_r}) then {
			/etc/rc.d/\${_r} check
			if (test "\$?" != "0") then {
				echo -n "Iniciando "
				/etc/rc.d/\${_r} start
			} fi;
		} fi;
	done
} fi;
EOF
	} fi;
	chmod +x /etc/rc.local
} else {
	grep "rcctl order" /etc/rc.local > /dev/null 2> /dev/null
	if (test "$?" != "0") then {
		ed /etc/rc.local >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
/for _r in
i
	pkg_scripts=\`rcctl order\`
.
w
q
EOF
	} fi;
} fi;


if (test -f /etc/rc.d/cron) then {
	activarcs cron
} fi;

echo "* Configurando escritorio de cuenta de administrador(a)" | tee -a /var/www/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/fluxbox* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	pkg_delete -I -D dependencies fluxbox >> /var/www/tmp/inst-adJ.bitacora 2>&1
	pkg_delete -I -D dependencies partial-fluxbox >> /var/www/tmp/inst-adJ.bitacora 2>&1
} fi;

chown -R $uadJ:$uadJ /mnt/ 2> /dev/null

f=`ls /var/db/pkg/fluxbox* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	echo "* Instalando escritorio fluxbox" >> /var/www/tmp/inst-adJ.bitacora;
	p=`ls $PKG_PATH/tiff-* 2> /dev/null`
	if (test "$p" = "") then {
		echo 'No se encuentra paquete tiff'
		exit 1;
	} fi;
        pkg_add -I -D repair -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	insacp fribidi
	p=`ls $PKG_PATH/jpeg-* $PKG_PATH/libid3tag-* $PKG_PATH/png-* $PKG_PATH/bzip2-* $PKG_PATH/libungif-* $PKG_PATH/imlib2-* $PKG_PATH/libltdl-* $PKG_PATH/fluxbox-* $PKG_PATH/fluxter-* $PKG_PATH/fbdesk-* 2>/dev/null`
        pkg_add -I -D repair -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	if (test ! -f /home/$uadJ/.xsession) then {
		cat > /home/$uadJ/.xsession <<EOF
		/usr/local/bin/startfluxbox
EOF
		chown $uadJ:$uadJ /home/$uadJ/.xsession > /dev/null 2>&1
	} fi;
} fi;

if (test -f /home/$uadJ/.fluxbox/menu) then {
	rm -f /home/$uadJ/.fluxbox/menu
	rm -f /home/$uadJ/.fluxbox/startup
	rm -f /home/$uadJ/.fluxbox/init
} fi;

# Por cambiar mas en paquetes
ln -sf /usr/local/bin/gnome-keyring-daemon /usr/local/bin/gnome-keyring-servicio

if (test ! -f /home/$uadJ/.fluxbox/menu) then {
	mkdir -p /home/$uadJ/.fluxbox
	cat > /home/$uadJ/.fluxbox/menu <<EOF

[begin] (Fluxbox)
	[exec] (xfe - Archivos) {PATH=\$PATH:/usr/sbin:/usr/local/sbin:/sbin /usr/local/bin/xfe}
	[exec] (xterm+tmux) { xterm -geometry 160x48 -en utf8 -e "TERM=xterm-color /usr/bin/tmux -2 -l" }
	[exec] (xterm) { xterm -geometry 160x48 -en utf8 -ls }
	[exec] (chromium) {/usr/local/bin/chrome --disable-gpu --allow-file-access-from-files}
	[exec] (firefox-esr) {/usr/local/bin/firefox-esr}
[submenu] (Espiritualidad)
	[exec] (bibletime) {/usr/local/bin/bibletime}
	[exec] (Evangelios de dominio publico) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/evangelios_dp/}
[end]
[submenu] (Dispositivos)
	[exec] (Apagar) {doas /sbin/halt -p}
	[exec] (Iniciar servicios faltantes) {xterm -en utf8 -e "/usr/bin/doas /bin/sh /etc/rc.local espera"}
	[exec] (Montar CD) {doas /sbin/mount /mnt/cdrom ; doas xfe /mnt/cdrom/ }
	[exec] (Desmontar CD) {doas /sbin/umount -f /mnt/cdrom}
	[exec] (Montar USB) {doas /sbin/mount /mnt/usb ; doas xfe /mnt/usb/}
	[exec] (Desmontar USB) {doas /sbin/umount -f /mnt/usb}
	[exec] (Montar USBC) {doas /sbin/mount /mnt/usbc ; doas xfe /mnt/usbc/}
	[exec] (Desmontar USBC) {doas /sbin/umount -f /mnt/usbc}
	[exec] (Montar Floppy) {doas /sbin/mount /mnt/floppy ; doas xfe /mnt/floppy}
	[exec] (Desmontar Floppy) {doas /sbin/umount -f /mnt/floppy}
	[exec] (Configurar Impresora con CUPS) {echo y | doas cups-enable; doas chmod a+rw /dev/ulpt* /dev/lpt*; /usr/local/bin/chrome --disable-gpu http://127.0.0.1:631}
	[submenu] (Red)
                [exec] (Examinar red) {xterm -en utf8 -e '/sbin/ifconfig; echo -n "\n[RETORNO] para examinar enrutamiento (podrá salir con q)"; read; /sbin/route -n show | less'}
                [exec] (Examinar configuracion cortafuegos) {xterm  -en utf8 -e 'doas  /sbin/pfctl -s all | less '}
                [exec] (Configurar interfaces de red) {xterm -en utf8 -e 'li=\`/sbin/ifconfig | grep "^[a-z]*[0-9]:" | sed -e "s/:.*//g" | grep -v "lo0" | grep -v "enc0" | grep -v "pflog0" | grep -v "tun[0-9]"\`;  echo "Por configurar \$li"; for i in \$li; do echo "Configurando \$i"; /sbin/ifconfig \$i; echo -n "\n[RETORNO] para editar /etc/hostname.\$i"; read;  doas touch /etc/hostname.\$i; doas xfw /etc/hostname.\$i; done'}
                [exec] (Configurar puerta de enlace) {doas touch /etc/mygate; doas xfw /etc/mygate}
                [exec] (Configurar cortafuegos) {doas xfw /etc/pf.conf}
                [exec] (Reiniciar red) {xterm -en utf8 -e 'PATH=/sbin:/usr/sbin:/bin:/usr/bin/ /usr/bin/doas /bin/sh /etc/netstart && /usr/bin/doas /sbin/pfctl -f /etc/pf.conf; echo "[RETORNO] para continuar"; read'}
                [exec] (ping a Internet) {xterm -en utf8 -e '/sbin/ping 157.253.1.13'}
        [end]
[end]
[submenu] (Oficina)
	[exec] (evince) {evince}
	[exec] (dia) {/usr/local/bin/dia}
	[exec] (gnumeric) {LC_CTYPE=C /usr/local/bin/gnumeric}
	[exec] (gv) {gv}
	[exec] (gimp) {LC_CTYPE=C /usr/local/bin/gimp}
	[exec] (inkscape) {inkscape}
	[exec] (LibreOffice) {/usr/local/bin/soffice}
	[exec] (scribus) {scribus}
[end]
[submenu] (Multimedia)
	[exec] (audacios) {audacious}
	[exec] (audacity) {audacity}
	[exec] (cdio cdplay) {xterm -en utf8 -e "cdio cdplay"}
	[exec] (musescore) {musescore}
	[exec] (xcdplayer) {xcdplayer}
	[exec] (xsane) {xsane}
	[exec] (vlc) {vlc}
[end]
[submenu] (Internet)
	[exec] (FileZilla) {filezilla}
	[exec] (Pidgin) {pidgin}
[end]
[submenu] (Documentos)
	[exec] (adJ basico) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/basico_adJ/index.html}
	[exec] (adJ usuario) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/usuario_adJ/index.html}
	[exec] (adJ servidor) {/usr/local/bin/chrome --disable-gpu /usr/local/share/doc/servidor_adJ/index.html}
[end]
[submenu] (Otros)
[exec] (gvim) {gvim}
[exec] (qemu) {qemu-system-x86_64}
[exec] (qgis) {qgis}
[exec] (xarchiver) {xarchiver}
[exec] (xfw) {xfw}
[end]
[submenu] (Menu de fluxbox)
[config] (Configurar)
[submenu] (Estilos del sistema) {Elija un estilo ...}
[stylesdir] (/usr/local/share/fluxbox/styles)
[end]
[submenu] (Estilos de usuario) {Elija un estilo...}
[stylesdir] (~/.fluxbox/styles)
[end]
[workspaces] (Lista de espacios de trabajo)
[submenu] (Herramientas)
[exec] (Nombre de ventana) {xprop WM_CLASS|cut -d " -f 2|xmessage -file - -center}
[exec] (Foto de la pantalla - JPG) {import screenshot.jpg && display -resize 50% screenshot.jpg}
[exec] (Foto de la pantalla - PNG) {import screenshot.png && display -resize 50% screenshot.png}
[end]
[submenu] (Administrador de Ventanas)
[restart] (cwm) {cwm}
[restart] (fvwm) {fvwm}
[restart] (twm) {twm}
[restart] (mwm) {mwm}
[end]
[exec] (Bloquear pantalla) {xlock}
[commanddialog] (Comando de Fluxbox)
[reconfig] (Cargar nuevamente la configuracion)
[restart] (Volver a iniciar)
[exec] (Acerca de) {(fluxbox -v; fluxbox -info | sed 1d) 2> /dev/null | xmessage -file - -center}
[separator]
[exit] (Exit)
[end]
[exec] (Reiniciar) {doas /sbin/reboot}
[exec] (Apagar) {doas /sbin/halt -p}
[end]
EOF
} fi;

if (test ! -d /home/$uadJ/Documentos) then {
	mkdir -p /home/$uadJ/Documentos
	chown $uadJ:$uadJ /home/$uadJ/Documentos 
} fi;

if (test ! -f /home/$uadJ/.fluxbox/startup) then {
	mkdir -p /home/$uadJ/.fluxbox/backgrounds/
	imfondo=`ls -lat $ARCH/medios/*.jpg | head -n 1 | sed -e "s/.*medios\///g"`
	echo "Imagen de fondo: $imfondo" >> /var/www/tmp/inst-adJ.bitacora
	cp $ARCH/medios/*.jpg /home/$uadJ/.fluxbox/backgrounds/
	cp $ARCH/medios/$imfondo /home/$uadJ/.fluxbox/backgrounds/fondo.jpg
	cat > /home/$uadJ/.fluxbox/startup <<EOF
#fbsetroot -to blue -solid lightblue
export LANG=es_CO.UTF-8
if (test -x /usr/local/bin/fluxter) then {
	/usr/local/bin/fluxter &
} fi;
im=fondo.jpg
if (test -x /usr/local/bin/fbsetbg -a -x /usr/local/bin/display -a -f /home/$uadJ/.fluxbox/backgrounds/\$im) then {
	display -backdrop -window root /home/$uadJ/.fluxbox/backgrounds/\$im
} fi;
if (test -x /usr/local/bin/fbdesk) then {
	/usr/local/bin/fbdesk &
} fi;
if (test -x /usr/local/bin/pidgin) then {
	LANG=es_CO.UTF-8 /usr/local/bin/pidgin &
} fi;
xterm -geometry 160x48 -en utf8 -e /usr/bin/tmux -l &
# /usr/local/bin/bsetroot -solid black
# fbsetbg -C /usr/local/share/fluxbox/splash.jpg
# xset -b
# xset r rate 195 35
# xset +fp /home/$uadJ/.font
# xsetroot -cursor_name right_ptr
# xmodmap ~/.Xmodmap
# unclutter -idle 2 &
# wmnd &
# wmsmixer -w &
# idesk &
if (test -x /usr/X11R6/bin/xcompmgr) then {
#        /usr/X11R6/bin/xcompmgr -CcfF -I-.015 -O-.03 -D2 -t-1 -l-3 -r4.2 -o.5 &
} fi;

exec /usr/local/bin/fluxbox -log ~/.fluxbox/log
EOF
grep -v "display -backdrop -window .*\$im"  /home/$uadJ/.fluxbox/apps > /tmp/a 2>/dev/null
cat /tmp/a - > /home/$uadJ/.fluxbox/apps <<EOF
	[startup] {display -backdrop -window root /home/$uadJ/.fluxbox/backgrounds/fondo.jpg}
EOF
} fi;

if (test ! -f /home/$uadJ/.fluxbox/fbdesk) then {
	mkdir -p /home/$uadJ/.fluxbox/
	cat > /home/$uadJ/.fluxbox/fbdesk <<EOF
session.styleFile:      /usr/local/share/fluxbox/styles/Operation
fbdesk.snapY:   5
fbdesk.lockPositions:   false
fbdesk.textPlacement:   Bottom
fbdesk.snapX:   5
fbdesk.textColor:       black
fbdesk.doubleClickInterval:     200
fbdesk.iconFile:        ~/.fluxbox/fbdesk.icons
fbdesk.textBackground:  white
fbdesk.textAlpha:       0
fbdesk.font:    fixed
fbdesk.iconAlpha:       255
EOF
	cat > /home/$uadJ/.fluxbox/fbdesk.icons <<EOF
[Desktop Entry]
Name=xterm
Exec=xterm -en utf8 -e /bin/ksh -l
Icon=/usr/local/share/icons/hicolor/48x48/apps/applications-other.png
Pos= 23 5
[end]

[Desktop Entry]
Name=chromium
Exec=chrome --disable-gpu
Icon=/usr/local/share/icons/hicolor/48x48/apps/applications-internet.png
Pos= 27 86
[end]
EOF

} fi;

if (test ! -f /home/$uadJ/.fluxbox/init) then {
	mkdir -p /home/$uadJ/.fluxbox/
	cat > /home/$uadJ/.fluxbox/init <<EOF
session.screen0.overlay.lineWidth:	1
session.screen0.overlay.lineStyle:	LineSolid
session.screen0.overlay.joinStyle:	JoinMiter
session.screen0.overlay.capStyle:	CapNotLast
session.screen0.tab.alignment:	Left
session.screen0.tab.width:	64
session.screen0.tab.rotatevertical:	True
session.screen0.tab.height:	16
session.screen0.tab.placement:	Top
session.screen0.titlebar.left:	Stick 
session.screen0.titlebar.right:	Minimize Maximize Close 
session.screen0.toolbar.layer:	Desktop
session.screen0.toolbar.widthPercent:	66
session.screen0.toolbar.onhead:	0
session.screen0.toolbar.height:	0
session.screen0.toolbar.alpha:	250
session.screen0.toolbar.onTop:	False
session.screen0.toolbar.autoHide:	false
session.screen0.toolbar.tools:	workspacename, prevworkspace, nextworkspace, iconbar, systemtray, prevwindow, nextwindow, clock
session.screen0.toolbar.visible:	true
session.screen0.toolbar.maxOver:	false
session.screen0.toolbar.placement:	BottomCenter
session.screen0.menu.alpha:	255
session.screen0.iconbar.mode:	Workspace
session.screen0.iconbar.alignment:	Relative
session.screen0.iconbar.deiconifyMode:	Follow
session.screen0.iconbar.usePixmap:	true
session.screen0.iconbar.wheelMode:	Screen
session.screen0.iconbar.iconTextPadding:	10l
session.screen0.iconbar.iconWidth:	70
session.screen0.slit.onTop:	False
session.screen0.slit.onhead:	0
session.screen0.slit.autoHide:	false
session.screen0.slit.layer:	Dock
session.screen0.slit.maxOver:	false
session.screen0.slit.direction:	Vertical
session.screen0.slit.alpha:	255
session.screen0.slit.placement:	BottomRight
session.screen0.window.focus.alpha:	255
session.screen0.window.unfocus.alpha:	128
session.screen0.fullMaximization:	false
session.screen0.edgeSnapThreshold:	0
session.screen0.windowScrollReverse:	false
session.screen0.showwindowposition:	true
session.screen0.resizeMode:	Bottom
session.screen0.antialias:	false
session.screen0.desktopwheeling:	true
session.screen0.followModel:	Ignore
session.screen0.menuDelay:	0
session.screen0.workspaceNames:	one,two,three,four,
session.screen0.menuMode:	Delay
session.screen0.focusLastWindow:	true
session.screen0.windowPlacement:	RowSmartPlacement
session.screen0.windowMenu:	
session.screen0.strftimeFormat:	%k:%M
session.screen0.workspacewarping:	true
session.screen0.workspaces:	4
session.screen0.menuDelayClose:	0
session.screen0.tabFocusModel:	ClickToTabFocus
session.screen0.rowPlacementDirection:	LeftToRight
session.screen0.autoRaise:	false
session.screen0.sloppywindowgrouping:	true
session.screen0.decorateTransient:	false
session.screen0.opaqueMove:	false
session.screen0.focusModel:	ClickFocus
session.screen0.rootCommand:	
session.screen0.windowScrollAction:	
session.screen0.focusNewWindows:	true
session.screen0.imageDither:	true
session.screen0.clickRaises:	true
session.screen0.colPlacementDirection:	TopToBottom
session.slitlistFile:	~/.fluxbox/slitlist
session.cacheMax:	200l
session.cacheLife:	5l
session.forcePseudoTransparency:	false
session.keyFile:	~/.fluxbox/keys
session.tabs:	true
session.focusTabMinWidth:	0
session.doubleClickInterval:	250
session.groupFile:	~/.fluxbox/groups
session.autoRaiseDelay:	250
session.styleFile:	/usr/local/share/fluxbox/styles/BlueNight
session.tabPadding:	0
session.styleOverlay:	~/.fluxbox/overlay
session.useMod1:	true
session.opaqueMove:	False
session.ignoreBorder:	false
session.colorsPerChannel:	4
session.numLayers:	13
session.tabsAttachArea:	Window
session.appsFile:	~/.fluxbox/apps
session.imageDither:	True
session.menuFile:	~/.fluxbox/menu
EOF

} fi;


chown -R $uadJ:$uadJ /home/$uadJ/.fluxbox/

if (test ! -f /home/$uadJ/.Xdefaults) then {
		cat > /home/$uadJ/.Xdefaults <<EOF
// Con base en http://dentarg.starkast.net/files/configs/dot.zshrc

XTerm*color0:                   #000000
XTerm*color1:                   #bf7276
XTerm*color2:                   #86af80
XTerm*color3:                   #968a38
XTerm*color4:                   #3673b5
XTerm*color5:                   #9a70b2
XTerm*color6:                   #7abecc
XTerm*color7:                   #dbdbdb
XTerm*color8:                   #6692af
XTerm*color9:                   #e5505f
XTerm*color10:                  #87bc87
XTerm*color11:                  #e0d95c
XTerm*color12:                  #1b85d6
XTerm*color13:                  #ad73ba
XTerm*color14:                  #338eaa
XTerm*color15:                  #f4f4f4
XTerm*colorBD:                  #ffffff
XTerm*foreground:               #000000
XTerm*background:               #ffffff
XTerm*font:                     shine2.se
XTerm*boldMode:                 false
XTerm*scrollBar:                false
XTerm*colorMode:                on
XTerm*dynamicColors:            on
XTerm*highlightSelection:       true
XTerm*eightBitInput:            false
XTerm*metaSendsEscape:          false
XTerm*oldXtermFKeys:            true
EOF
		chown -R $uadJ:$uadJ /home/$uadJ/.Xdefaults
} fi;


actualiza=0
nv="$VERP$REV"
if (test "$vac" != "") then {
	actualiza=1;
} else {
	if (test -f /var/adJ/verinstadJ.txt) then {
		ov=`cat /var/adJ/verinstadJ.txt`;
		if (test "$nv" -gt "$ov") then {
			actualiza=1;
		} fi;
	} fi;
} fi;

if (test "$actualiza" = "1") then {
	dialog --title 'Actualización de /etc con sysmerge' --msgbox '\nDurante la ejecución de sysmerge, mezcle archivos de los servicios que tenga instalados e instale nuevas versiones de los que no use' 15 60 

	if (test "$EDITOR" = "" -a "$VISUAL" = "") then {
		cmd="EDITOR=mg ";
	} fi;
	if (test ! -f /etc/sysmerge.ignore) then {
		cat > /etc/sysmerge.ignore <<EOF
EOF
	} fi;
	clear
	cmd="$cmd sysmerge"
	echo $cmd;
	eval $cmd;
} fi;
echo $nv > /var/adJ/verinstadJ.txt
sh /etc/rc.local >> /var/www/tmp/inst-adJ.bitacora 2>&1

echo "* Configurar script de inicio de root (root/.profile)" >> /var/www/tmp/inst-adJ.bitacora;
grep "PKG_PATH" /root/.profile > /dev/null 2>&1
if (test "$?" != "0") then {
	cat >> /root/.profile <<EOF
export PKG_PATH=ftp://carroll.cac.psu.edu/pub/OpenBSD/$VER/packages/$ARQ/
export PKG_PATH=http://adJ.pasosdeJesus.org/pub/OpenBSD/$VER/packages/$ARQ/
if (test "\$TERM" = "xterm" -o "\$TERM" = "xterm-color") then {
	        export TERM=xterm-color
} elif (test "\$TERM" != "screen" -a "\$TERM" != "screen-256color") then {
	        export TERM=wsvt25
} fi;
which colorls > /dev/null 2>&1
if (test "\$?" == "0") then {
	        export CLICOLOR=1
		alias ls=colorls
} fi;
export PS1="\h# "
export HISTFILE=/root/.pdksh_history
export HISTSIZE=2048
export LANG=es_CO.UTF-8
EOF
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar LANG en script de inicio de root (root/.profile)" >> /var/www/tmp/inst-adJ.bitacora;
grep "es_CO.UTF8" /root/.profile > /dev/null 2>&1
if (test "$?" = "0") then {
	ed /root/.profile <<EOF
,s/es_CO.UTF8/es_CO.UTF-8/g
w
q
EOF
} fi;
grep "es_CO.UTF-8" /root/.profile > /dev/null 2>&1
if (test "$?" != "0") then {
	cat >> /root/.profile <<EOF
export LANG=es_CO.UTF-8
EOF
} fi;
	
echo "* Configurar X-Window" >> /var/www/tmp/inst-adJ.bitacora
pgrep xdm > /dev/null 2>&1
if (test "$?" != "0" -a ! -f /etc/X11/xorg.conf -a ! -f /etc/X11/xorg-automatico ) then {
	dialog --title 'Configuración de X-Window' --msgbox "\nSe ejecutará 'X -configure' Si se congela su sistema reinicie, si logra ingresar a modo gráfico vuelva a la consola presionando [Ctrl]+[Alt]+[Backspace]\n
Puede examinar errores, causas y soluciones al final de la bitacora:\n
        less /var/log/Xorg.0.log\n" 15 60
	cat > /root/xorg.conf.generico <<EOF
Section "ServerLayout"
	Identifier     "X.org Configured"
	Screen      0  "Screen0" 0 0
	InputDevice    "Mouse0" "CorePointer"
	InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Files"
	#	RgbPath      "/usr/X11R6/share/X11/rgb"
	#	ModulePath   "/usr/X11R6/lib/modules"
	FontPath     "/usr/X11R6/lib/X11/fonts/misc/"
	FontPath     "/usr/X11R6/lib/X11/fonts/TTF/"
	FontPath     "/usr/X11R6/lib/X11/fonts/Type1/"
	FontPath     "/usr/X11R6/lib/X11/fonts/CID/"
	FontPath     "/usr/X11R6/lib/X11/fonts/75dpi/"
	FontPath     "/usr/X11R6/lib/X11/fonts/100dpi/"
	FontPath     "/usr/local/lib/X11/fonts/local/"
	FontPath     "/usr/local/lib/X11/fonts/Speedo/"
	FontPath     "/usr/local/lib/X11/fonts/TrueType/"
	FontPath     "/usr/local/lib/X11/fonts/freefont/"
EndSection

Section "Module"
	Load  "dbe"
	Load  "freetype"
EndSection

Section "InputDevice"
	Identifier  "Keyboard0"
	Driver      "kbd"
	Option      "XkbLayout" "$nt"
	# Si el teclado fuera latinoamericano en vez de "es" usar "latam"
	Option      "XkbModel" "pc105"
EndSection

Section "InputDevice"
	Identifier  "Mouse0"
	Driver      "mouse"
	Option      "Protocol" "wsmouse"
	Option      "Device" "/dev/wsmouse"
	# Si es serial usar protocolo "Microsoft" y dispositivo "/dev/tty00" 
	Option      "ZAxisMapping" "4 5"
EndSection

Section "Monitor"
	#       HorizSync    30.0 - 70.0
	#       VertRefresh  50.0 - 90.0
	# Puede funcionar quitar el comentario en HorizSync (vea /var/log/Xorg.0.log)
	Identifier   "Monitor0"
	Option      "DPMS"
EndSection

Section "Device"
	Identifier  "Card0"
	Driver      "vesa
	#	BusID       "PCI:0:1:0"
EndSection

Section "Screen"     
	Identifier "Screen0"
	Device     "Card0"
	Monitor    "Monitor0"
	DefaultDepth     16
	SubSection "Display"
		Viewport   0 0
		Depth     1
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     4
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     8
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     15
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     16
		Modes    "1024x768"
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     24
	EndSubSection
EndSection
EOF
	Xorg -configure
	cat /var/log/Xorg.0.log >> /var/www/tmp/inst-adJ.bitacora
	if (test ! -f /root/xorg.conf.new) then {
		dialog --title 'Configuración de X-Window' --msgbox "\nNo pudo configurarse automaticamente, se empleara un archivo de configuracion genérico que puede requerir su edicion.\n
Vea la documentacion con man xorg.conf, editelo por ejemplo con mg /etc/X11/xorg.conf y pruebelo con Xorg.  \n" 15 60
		cp /root/xorg.conf.pordefecto /root/xorg.conf.new
	} fi;

	clear
	echo "Verifique si corre X-Window (modo gráfico) ejecutando"
	echo "     cd /root/"
	echo "     Xorg -config xorg.conf.new"
	echo "Puede salir de X-Window con [Ctrl]-[Alt]-[BackSpace]."
	echo "Si no opera examine errores, causas y soluciones al final de la bitacora:"
	echo "    less /var/log/Xorg.log.0"
	echo "De requerirlo ajuste la configuración con:"
	echo "     mg /root/xorg.conf.new"
	echo "Vea la documentacion con:"
	echo "     man xorg.conf"
	echo "Regrese a este script con 'exit'";
	/bin/sh
	dialog --title 'Configuración de X-Window' --yesno '\n¿Logró configurar X-Window?' 15 60 
	if (test "$?" = "0") then {
		echo "xenodm_flags=\"\"" >> /etc/rc.conf.local
	} fi;
} else {
	rm -f /etc/X11/xorg-automatico
	echo "   Saltando..."  >> /var/www/tmp/inst-adJ.bitacora;
} fi;
echo "/etc/X11/xorg.conf" >> /var/www/tmp/inst-adJ.bitacora
cat /etc/X11/xorg.conf >> /var/www/tmp/inst-adJ.bitacora 2> /dev/null


echo "* Configurar teclado latinoamericano en Xorg si es el caso y si hace falta"  >> /var/www/tmp/inst-adJ.bitacora;
kb=`cat /etc/kbdtype 2>/dev/null`
if (test "$kb" = "la") then {
	grep "setxkbmap latam" /etc/X11/xenodm/Xsetup_0 > /dev/null 2>&1
	if (test "$?" != "0") then {
		echo "setxkbmap latam" >> /etc/X11/xenodm/Xsetup_0
	} fi;
} fi;

echo "* Configurar scripts de cuenta inicial"  >> /var/www/tmp/inst-adJ.bitacora;
grep "PKG_PATH" /home/$uadJ/.profile > /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.profile <<EOF
export PATH=$PATH:.
export PKG_PATH=http://adJ.pasosdeJesus.org/pub/OpenBSD/$VER/packages/$ARQ/
if (test "\$TERM" = "xterm") then {
	        export TERM=xterm-color
}
else {
	        export TERM=wsvt25
} fi;
which colorls > /dev/null 2>&1
if (test "\$?" == "0") then {
	        export CLICOLOR=1
		alias ls=colorls
} fi;
export PS1="\h\$ "
#alias vi=vim
#export VISUAL=vi
export SWORD_PATH=/usr/local/share/sword
export HISTFILE=/home/$uadJ/.pdksh_history
export HISTSIZE=2048
export LANG=es_CO.UTF-8
if [ -z "\$SSH_AUTH_SOCK" -a "\$-" == "*i*" ] ; then
	eval \`ssh-agent -s\` 
	ssh-add 
fi
EOF
	cat >> /home/$uadJ/.inputrc <<EOF
set input-meta on
set output-meta on
set convert-meta off
#set editing-mode vi
TAB: complete
EOF
	chown $uadJ:$uadJ /home/$uadJ/.inputrc
} else {
	ed /home/$uadJ/.profile >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\(PKG_PATH=.*\)[0-9][.][0-9]/\1$ACVER/g
w
q
EOF
	echo "   Actualizando versión en PKG_PATH de /home/$uadJ/.profile" >> /var/www/tmp/inst-adJ.bitacora;
} fi;

grep "PKG_PATH" /home/$uadJ/.zshrc> /dev/null
if (test -f /home/$uadJ/.zshrc -a "$?" != "0") then {
} else {
	ed /home/$uadJ/.zshrc >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\(PKG_PATH=.*\)[0-9][.][0-9]/\1$ACVER/g
w
q
EOF
	echo "   Actualizando versión en PKG_PATH de /home/$uadJ/.zshrc" >> /var/www/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar LANG en script de inicio de cuenta $uadJ" >> /var/www/tmp/inst-adJ.bitacora;
grep "es_CO.UTF8" /home/$uadJ/.profile > /dev/null 2>&1
if (test "$?" = "0") then {
	ed /home/$uadJ/.profile <<EOF
,s/es_CO.UTF8/es_CO.UTF-8/g
w
q
EOF
} fi;

grep "es_CO.UTF-8" /home/$uadJ/.profile > /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.profile <<EOF
export LANG=es_CO.UTF-8
EOF
} fi;

grep "fortune" /home/$uadJ/.profile > /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.profile <<EOF
/usr/games/fortune /usr/local/share/adJ/fortune/versiculos
EOF
} fi;


echo "* Preparando espacio para respaldos de bases de datos" >> /var/www/tmp/inst-adJ.bitacora;
if (test ! -d /var/www/resbase) then {
	mkdir /var/www/resbase
	chown $uadJ:$uadJ /var/www/resbase
	chmod o-w /var/www/resbase
	chmod o+r /var/www/resbase
	chmod o+x /var/www/resbase
} fi;


# Cambiar otros posibles scripts de /usr/local/sbin

for i in /usr/local/sbin/*sh; do
	grep "dev/svnd" $i > /dev/null 2>&1
	if (test "$?" = "0") then {
		echo "* Cambiando svnd por vnd en $i (copia en $i-pre50)" >> /var/www/tmp/inst-adJ.bitacora;
		cp $i $i-pre50
		sed -e "s/svnd/vnd/g" $i-pre50 > $i;
	} fi;
done

clear;


sh /etc/rc.local >> /var/www/tmp/inst-adJ.bitacora 2>&1 # En caso de que falte montar bien

# Nuevo usuario PostgreSQL
if (ltf $ACVER "4.1") then {
	uspos='_postgresql';
}
else {
	uspos='postgres';
} fi;

acuspos="-U$uspos"

# Localizacion del socket hasta 5.7 era /var/www/tmp a partir de 5.8 /var/www/var/run/postgresql
if (test "$SOCKPSQL" != "") then {
  sockpsql="$SOCKPSQL";
} else {
  sockpsql="/var/www/var/run/postgresql"
} fi;
echo "* Detectando socket de PostgreSQL en $sockpsql" >> /var/www/tmp/inst-adJ.bitacora;
# Detectar socket de PostgreSQL
vpi=`ls /var/db/pkg/postgresql-server-*` 
if (test ! -S "$sockpsql/.s.PGSQL.5432" -a "$vpi" != "") then {
  echo "* No se encontró socket de PostgreSQL en $sockpsql";
  sockpsql="/var/www/tmp"
  echo "* Detectando socket de PostgreSQL en $sockpsql" >> /var/www/tmp/inst-adJ.bitacora;
  if (test ! -S "$sockpsql/.s.PGSQL.5432") then {
    echo "* Tampoco se encontró socket de PostgreSQL en $sockpsql";
    echo "* Se recomienda detener (Ctrl-C) y ejecutar nuevamente especificando la ruta del socket de PostgreSQL en variable SOCKPSQL";
    read;
  } fi;
} fi;

# Codificacion por defecto en versiones hasta 5.0
dbenc="LATIN1";

echo "* De requerirlo sacar respaldo de datos" >> /var/www/tmp/inst-adJ.bitacora
pgrep post > /dev/null 2>&1
if (test "$?" = "0") then {
	echo -n "psql -h $sockpsql $acuspos -c \"select usename from pg_user where usename='postgres';\"" > /tmp/cu.sh
       	su - _postgresql /tmp/cu.sh
	if (test "$?" != "0") then {
		us='_postgresql';
		acus="-U$uspos";
	} fi;

	nb=1;
	while (test -f /var/www/resbase/pga-$nb.sql -o -f /var/www/resbase/pga-$nb.sql.gz) do
		nb=`expr $nb + 1`;
	done;
	dialog --title 'Respaldo de datos de PostgreSQL' --yesno "\\n¿Intentar sacar copia de respaldo de todas las bases PostgreSQL en /var/www/resbase/pga-$nb.sql ?\n" 15 60
	if (test "$?" = "0") then {
		pgrep post > /dev/null 2>&1
		if (test "$?" = "0") then {
			mkdir -p /var/www/resbase
			touch /var/www/resbase/pga-$nb.sql
			chown _postgresql:_postgresql /var/www/resbase/pga-$nb.sql
			touch /var/www/resbase/pga-conc.sql
			chmod +x /var/www/resbase/
			chown _postgresql:_postgresql /var/www/resbase/pga-conc.sql
			rm -f /tmp/penc.txt
			echo "psql -h$sockpsql $acuspos -c 'SHOW SERVER_ENCODING' > /tmp/penc.txt" > /tmp/cu.sh
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora;
			if (test -f /tmp/penc.txt -a ! -z /tmp/penc.txt) then {
				dbenc=`grep -v "(1 row)" /tmp/penc.txt | grep -v "server_encoding" | grep -v "[-]-----" | grep -v "^ *$" | sed -e "s/  *//g"`
			} fi;
			echo "pg_dumpall $acuspos --inserts --column-inserts --host=$sockpsql > /var/www/resbase/pga-conc.sql" > /tmp/cu.sh
			echo "if (test \"\$?\" != \"0\") then {" >> /tmp/cu.sh 
			echo "  echo \"No pudo completarse la copia\";" >> /tmp/cu.sh 
			echo "  exit 1;" >> /tmp/cu.sh 
			echo "} fi;" >> /tmp/cu.sh 
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora;
			if (test "$?" != "0" -a -f /var/www/resbase/pga-conc.sql) then {
				echo "* Copia incompleta dejada en /var/www/resbase/pga-par.sql"
				mv /var/www/resbase/pga-conc.sql /var/www/resbase/pga-par.sql
			} else {
				grep "CREATE DATABASE" /var/www/resbase/pga-conc.sql | grep -v "ENCODING" > /tmp/cb.sed
				sed -e "s/\(.*\);$/s\/\1;\/\1 ENCODING='$dbenc';\/g/g" /tmp/cb.sed  > /tmp/cb2.sed
				cat /tmp/cb2.sed >> /var/www/tmp/inst-adJ.bitacora
				grep -v "ALTER ROLE $uspos" /var/www/resbase/pga-conc.sql | sed -f /tmp/cb2.sed > /var/www/resbase/pga-$nb.sql
			} fi;
		} else {
			echo "PostgreSQL no está corriendo, no fue posible sacar copia" >> /var/www/tmp/inst-adJ.bitacora;
		} fi;
		if (test ! -s /var/www/resbase/pga-$nb.sql) then {
			echo "* No fue posible sacar copia, por favor saquela manualmente en un archivo de nombre /var/www/resbase/pga-$nb.sql o asegurarse de sacarlo con pg_dumpall o en último caso sacando una copia del directorio /var/postgresql/data" | tee -a /var/www/tmp/inst-adJ.bitacora;
			echo "* Vuelva a este script con 'exit'" 
			sh
		} fi;
	} fi;
} else {
	if (test -d "/var/postgresql") then {
		dialog --title 'PostgreSQL no opera' --yesno "\\nAunque PostgreSQL no esta operando en el disco parece haber datos para ese motor.  Puede detener este archivo de comandos para verificar.\\n   ¿Continuar?\\n" 15 60
		if (test "$?" != "0") then {
			echo "";
        		echo "Vuelva a ejecutar este script cuando termine de verificar" 
			exit 1;
		} fi;
	} fi;
} fi;

echo "* Deteniendo PostgreSQL" >> /var/www/tmp/inst-adJ.bitacora
pgrep post > /dev/null 2>&1
if (test "$?" = "0") then {
	su -l _postgresql -c "/usr/local/bin/pg_ctl stop -m fast -D /var/postgresql/data" >> /var/www/tmp/inst-adJ.bitacora
	rm -f /var/postgresql/data/postmaster.pid
} fi;

f=`ls /var/db/pkg/postgresql-server* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar PostgreSQL' --yesno "\\nDesea eliminar la actual versión de PostgreSQL y los datos asociados para actualizarla\\n" 15 60
	if (test "$?" = "0") then {
		echo "s" >> /var/www/tmp/inst-adJ.bitacora
		pkg_delete -I -D dependencies GeoIP >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies postgresql-contrib >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies postgresql-server >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies postgresql-client >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies postgresql-docs >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs-postgresql-client >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs1-postgresql-client >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs-postgresql-server >> /var/www/tmp/inst-adJ.bitacora 2>&1
		d=`date +%Y%M%d`
		nd="data-$o-$d"
		while (test -f "${nd}.tar.gz" ) ; do
			nd="${nd}y";
		done;
		tar cvfz /var/postgresql/${nd}.tar.gz /var/postgresql/data >> /var/www/tmp/inst-adJ.bitacora 2>&1
		rm -rf /var/postgresql/data
	} fi;
} fi;

echo "* Desmontando particiones cifradas" >> /var/www/tmp/inst-adJ.bitacora;
umount -f /var/bakbase 2>/dev/null >> /var/www/tmp/inst-adJ.bitacora;
umount -f /var/www/bakbase 2>/dev/null >> /var/www/tmp/inst-adJ.bitacora;
umount -f /var/www/resbase 2>/dev/null >> /var/www/tmp/inst-adJ.bitacora;
umount -f /var/postgresql 2>/dev/null >> /var/www/tmp/inst-adJ.bitacora;

echo "* Renombrando de bakbase a resbase" >> /var/www/tmp/inst-adJ.bitacora;
if (test ! -f /var/resbase.img -a -f /var/bakbase.img) then {
	mv /var/bakbase.img /var/resbase.img;
}
else {
	echo "   Saltando" >> /var/www/tmp/inst-adJ.bitacora;
} fi;


echo "* Poniendo permisos de /var/www/resbase" >> /var/www/tmp/inst-adJ.bitacora;
chown $uadJ:$uadJ /var/www/resbase

insacp apg
insacp xz
insacp libxml
insacp libiconv

echo "* Instalar PostgreSQL y PostGIS"  >> /var/www/tmp/inst-adJ.bitacora
f=`ls /var/db/pkg/postgresql-server* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	p=`ls $PKG_PATH/libxml-* $PKG_PATH/libiconv-* $PKG_PATH/postgresql-client-* $PKG_PATH/postgresql-*-server* $PKG_PATH/postgresql-*-contrib* $PKG_PATH/postgresql-*-doc*`
	pkg_add -I -r -D repair -D update -D updatedepends $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	insacp postgresql-contrib
	insacp jpeg
	insacp tiff
	insacp nghttp2
	insacp curl
	insacp png
	insacp opus
	insacp x264
	insacp lcms2
	insacp openjp2
	insacp giflib
	insacp imlib2
	insacp geos
	insacp proj
	insacp sqlite3
	insacp libspatialite
	insacp libgeotiff
	insacp jasper
	insacp libidn
	insacp libffi
	insacp tcl
	insacp tk
	insacp python
	insacp pcre
	insacp json-c
	insacp bzip2
	insacp py-setuptools
	insacp gdal 
	insacp postgis
	grep "^postgresql:" /etc/login.conf > /dev/null 2>&1
	if (test "$?" = "1") then {
		cat >> /etc/login.conf << EOF
postgresql:\
	:setenv=LD_PRELOAD=libpthread.so:\
	:tc=servicio:
EOF
		cap_mkdb /etc/login.conf
	} fi;
	echo -n "La clave del administrador de 'postgres' quedará en /var/postresql/.pgpass " >> /var/www/tmp/inst-adJ.bitacora;
	clpg=`apg | head -n 1`
	mkdir -p /var/postgresql/data
	echo "*:*:*:$uspos:$clpg" > /var/postgresql/.pgpass;
	chown -R _postgresql:_postgresql /var/postgresql/
	chmod 0600 /var/postgresql/.pgpass;
	if (test ! -f /var/postgresql/data/postgresql.conf) then {
		echo "$clpg" > /tmp/clave.txt
		chown _postgresql:_postgresql /tmp/clave.txt
		echo ""
		echo "* Activando claves md5"  >> /var/www/tmp/inst-adJ.bitacora
		echo initdb --encoding=UTF8 -U $uspos --auth=md5 --pwfile=/tmp/clave.txt -D/var/postgresql/data > /tmp/cu.sh
#		echo initdb --auth=trust --pwfile=/tmp/clave.txt -D/var/postgresql/data > /tmp/cu.sh
		chmod +x /tmp/cu.sh
		cat /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora
		echo "Preparado PostgreSQL" >> /var/www/tmp/inst-adJ.bitacora
		rm -rf /var/postgresql/data
		su - _postgresql /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora;
		echo "---" >> /var/www/tmp/inst-adJ.bitacora;
	} fi;
	ed /var/postgresql/data/postgresql.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/#unix_socket_directory *=.*/unix_socket_directory = '\/var\/www\/var\/run\/postgresql'/g
w
q
EOF
	ed /var/postgresql/data/postgresql.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/#unix_socket_directories *=.*/unix_socket_directories = '\/var\/www\/var\/run\/postgresql'/g
w
q
EOF
	ed /var/postgresql/data/postgresql.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/#listen_addresses *=.*/listen_addresses = '127.0.0.1'/g
w
q
EOF
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

mkdir -p /var/www/var/run/postgresql
chown _postgresql:_postgresql /var/www/var/run/postgresql
chown -R _postgresql:_postgresql /var/postgresql/
chmod o-rxw /var/postgresql/

echo "* Configurando para que inicie PostgreSQL en cada arranque y cierre al apagar" >> /var/www/tmp/inst-adJ.bitacora;

activarcs postgresql

grep "kern.seminfo.semmns" /etc/sysctl.conf > /dev/null 2> /dev/null
if (test "$?" != "0") then {
	cat >> /etc/sysctl.conf <<EOF
kern.shminfo.shmmni=1024
kern.seminfo.semmns=2048
kern.shminfo.shmmax=50331648
kern.shminfo.shmall=51200
kern.maxfiles=20000
EOF
	sysctl -w kern.shminfo.shmmni=1024> /dev/null
	sysctl -w kern.seminfo.semmns=2048 >/dev/null
	sysctl -w kern.shminfo.shmmax=50331648 > /dev/null
	sysctl -w kern.shminfo.shmall=51200 > /dev/null
	sysctl -w kern.maxfiles=20000 > /dev/null
} fi;

#staff:\
#	:datasize-cur=1536M:\
#	:datasize-max=infinity:\
#	:maxproc-max=4096:\
#	:maxproc-cur=4096:\
#	:openfiles-max=8090:\
#	:openfiles-cur=8090:\
#	:ignorenologin:\
#	:requirehome@:\
#	:tc=default:

cat /etc/rc.local >> /var/www/tmp/inst-adJ.bitacora
cat /etc/rc.conf.local >> /var/www/tmp/inst-adJ.bitacora
cat /etc/sysctl.conf >> /var/www/tmp/inst-adJ.bitacora

echo "* Iniciando PostgreSQL"  | tee -a /var/www/tmp/inst-adJ.bitacora
/etc/rc.d/postgresql start >> /var/www/tmp/inst-adJ.bitacora
echo
sleep 1
/etc/rc.d/postgresql restart >> /var/www/tmp/inst-adJ.bitacora
echo
sleep 1
pgrep post > /dev/null 2>&1
if (test "$?" != "0") then {
	dialog --title 'Revisar PostgreSQL' --msgbox '\nComando falló, esperar un momento o revisar o asegurar que corre postgresql (con "pgrep post") y regresar con "exit"' 15 60
	sh
} fi;

if (test "$SOCKPSQL" != "") then {
  sockpsql="$SOCKPSQL";
} else {
  sockpsql="/var/www/var/run/postgresql"
} fi;
echo "* Nuevamente detectando socket de PostgreSQL en $sockpsql" >> /var/www/tmp/inst-adJ.bitacora;
# Detectar socket de PostgreSQL
if (test ! -S "$sockpsql/.s.PGSQL.5432") then {
  echo "* No se encontró socket de PostgreSQL en $sockpsql";
  sockpsql="/var/www/tmp"
  echo "* Detectando socket de PostgreSQL en $sockpsql" >> /var/www/tmp/inst-adJ.bitacora;
  if (test ! -S "$sockpsql/.s.PGSQL.5432") then {
    echo "* Tampoco se encontró socket de PostgreSQL en $sockpsql";
    echo "* Puede ejecutar especificando la ruta del socket de PostgreSQL en variable SOCKPSQL";
    exit 1;
  } fi;
} fi;


pb=`ls -t /var/www/resbase/pga*sql 2>/dev/null | head -n 1`;
echo "pb=$pb" >> /var/www/tmp/inst-adJ.bitacora;
if (test -f "$pb") then {
	echo -n " (s/n): " >> /var/www/tmp/inst-adJ.bitacora;
	dialog --title 'Restaurar' --yesno "\\nRestaurar la copia de respaldo $pb\\n" 15 60
	if (test "$?" = "0") then {
		echo "s" >> /var/www/tmp/inst-adJ.bitacora
        	echo "psql -U$uspos -h $sockpsql -f $pb template1" > /tmp/cu.sh
        	chmod +x /tmp/cu.sh
        	su - _postgresql /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora;
	} fi;
} fi;


echo "* Agregar cotejaciones en español y facilidades de busqueda para PostgreSQL"  >> /var/www/tmp/inst-adJ.bitacora
ES_COUNTRIES="AR BO CH CO CR CU DO EC ES GQ GT HN MX NI PA PE PR PY SV VE US UY"
echo "psql -h $sockpsql -U postgres -c \"SELECT COUNT(*) FROM pg_collation WHERE collname = 'es_co_utf_8';\"" > /tmp/cu.sh
echo "exit \$?" >> /tmp/cu.sh;
chmod +x /tmp/cu.sh | tee -a /var/www/tmp/inst-adJ.bitacora
cat /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora
su - _postgresql /tmp/cu.sh > /tmp/cu.out 2>> /var/www/tmp/inst-adJ.bitacora
echo "" > /tmp/cu.sh
t=`head -n 3 /tmp/cu.out | tail -n 1 | sed -e "s/ *//g" 2>/dev/null`
if (test "$t" != "1") then {
	for i in $ES_COUNTRIES; do
		echo "psql -h $sockpsql -U postgres -c \"CREATE COLLATION es_${i}_UTF_8 (LOCALE='es_${i}.UTF-8');\"" >> /tmp/cu.sh
	done;
} fi;
echo "psql -h $sockpsql -U postgres -c \"CREATE EXTENSION unaccent;\"" >> /tmp/cu.sh
echo "psql -h $sockpsql -U postgres -c \"ALTER TEXT SEARCH DICTIONARY unaccent (RULES='unaccent');\"" >> /tmp/cu.sh
echo "psql -h $sockpsql -U postgres -c \"ALTER FUNCTION unaccent(text) IMMUTABLE;\"" >> /tmp/cu.sh
echo "exit \$?" >> /tmp/cu.sh;
chmod +x /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora 2>&1
cat /tmp/cu.sh >> /var/www/tmp/inst-adJ.bitacora
su - _postgresql /tmp/cu.sh  >> /var/www/tmp/inst-adJ.bitacora 2>&1
				

insacp libidn
insacp curl 
insacp libidn

echo "* Instalando PHP" | tee -a /var/www/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "$p" != "") then {
	rm -f /var/www/conf/modules/php5.conf 
	rcctl stop php56_fpm
	rcctl disable php56_fpm
	for i in php php-2 php5-core partial-php5-core partial-php5-pear partial-php; do
		pkg_delete -I -D dependencies $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
	done;
} fi;


echo "* Configurar servidor web" >> /var/www/tmp/inst-adJ.bitacora ;
if (test ! -f /etc/ssl/server.crt) then {
	echo "* Configurando Certificado SSL" | tee -a /var/www/tmp/inst-adJ.bitacora;
	openssl genrsa -out /etc/ssl/private/server.key 2048
	openssl req -new -key /etc/ssl/private/server.key \
       		-out /etc/ssl/private/server.csr
	openssl x509 -req -days 3650 -in /etc/ssl/private/server.csr \
      		-signkey /etc/ssl/private/server.key -out /etc/ssl/server.crt
} fi;

# Ponemos OpenBSD httpd si es nueva instalacion
# Si ya había nginx o apache procuramos dejarlos.
sweb=""
grep "^ *pkg_scripts=.*[ \"]nginx[ \"]." /etc/rc.conf.local > /dev/null 2>/dev/null
if (test "$?" = "0") then {
	sweb="nginx"
} elif (test "$CONAPACHE" != "") then {
	sweb="apache"
} fi;
if (test "$sweb" != "nginx" -a "$sweb" != "apache") then {
	sweb="httpd"
} fi;

echo "* Por configurar $sweb" >> /var/www/tmp/inst-adJ.bitacora ;

if (test "$sweb" = "apache") then {
	echo "* Inicio de Apache" >> /var/www/tmp/inst-adJ.bitacora ;
	insacp apache-httpd-openbsd
	activarcs apache
	# El anterior puede quitar apache_flags las ponemos:
	grep "apache_flags" /etc/rc.conf.local > /dev/null 2>/dev/null
	if (test "$?" != "0") then {
		echo "apache_flags=\"-DSSL\"" >> /etc/rc.conf.local
	} fi;
} fi;

echo "* Paquete nginx" >> /var/www/tmp/inst-adJ.bitacora ;
if (test "$sweb" = "nginx") then {
	echo "* Inicio de nginx" >> /var/www/tmp/inst-adJ.bitacora ;
	insacp nginx
	activarcs nginx
	# El anterior puede quitar nginx_flags las ponemos:
	grep "nginx_flags" /etc/rc.conf.local > /dev/null 2>/dev/null
	if (test "$?" != "0") then {
		echo "nginx_flags=" >> /etc/rc.conf.local
	} fi;
	grep "^[^#]*listen.*443" /etc/nginx/nginx.conf > /dev/null 2>/dev/null
	if (test "$?" != "0") then {
		ed /etc/nginx/nginx.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
1
?}
i
    server {
        listen       443;
        server_name  127.0.0.1;
        root         /var/www/htdocs/;
        index		index.php index.html index.htm;

        ssl                  on;
        ssl_certificate      /etc/ssl/server.crt;
        ssl_certificate_key  /etc/ssl/private/server.key;
        ssl_session_timeout  5m;
        ssl_protocols  SSLv3 TLSv1;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers   on;

    }
.
w
q
EOF
	} fi;
} fi;

echo "* Nuevo httpd" >> /var/www/tmp/inst-adJ.bitacora ;
if (test "$sweb" = "httpd") then {
	echo "* Inicio de httpd" >> /var/www/tmp/inst-adJ.bitacora ;
	# No se requiere por ser servicio del sistema pero para que
	# arranque con rc.local se hace:
	activarcs httpd
	# El anterior puede quitar httpd_flags las ponemos:
	grep "httpd_flags" /etc/rc.conf.local > /dev/null 2>/dev/null
	if (test "$?" != "0") then {
		echo "httpd_flags=" >> /etc/rc.conf.local
	} fi;

	if (test ! -f /etc/httpd.conf) then {
		nomm=`cat /etc/myname`
		cat > /etc/httpd.conf << EOF
server "127.0.0.1" {
	listen on * tls port 443
	connection max request body 250000000
        directory {
		no auto index
		index "index.php"
	}

	location "/*.php" {
		fastcgi socket "/var/run/php-fpm.sock"
	}
	root "/htdocs/sivel/"
}
EOF
	} fi;
} fi;

echo "* Inicio de $sweb configurado" >> /var/www/tmp/inst-adJ.bitacora ;
grep "#ServerName" /var/www/conf/httpd.conf > /dev/null 2> /dev/null
if (test "$?" = "0") then  {
	echo "* Estableciendo nombre del servidor en configuración de Apache" >> /var/www/tmp/inst-adJ.bitacora;
	cp /var/www/conf/httpd.conf /var/www/conf/httpd.conf-sinServerName >> /var/www/tmp/inst-adJ.bitacora 2>&1
	sn=`hostname`;
	sed -e "s/#ServerName.*/ServerName \"$sn\"/g" /var/www/conf/httpd.conf-sinServerName > /var/www/conf/httpd.conf
} fi;



pgrep http > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "* Deteniendo httpd"  >> /var/www/tmp/inst-adJ.bitacora 2>&1
	/etc/rc.d/httpd stop >> /var/www/tmp/inst-adJ.bitacora 2>&1
} fi;

pgrep nginx > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "* Deteniendo nginx"  >> /var/www/tmp/inst-adJ.bitacora 2>&1
	/etc/rc.d/nginx stop >> /var/www/tmp/inst-adJ.bitacora 2>&1
	sweb=nginx
} fi;

echo "* Instalando PHP" >> /var/www/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "$p" = "") then {
	insacp libltdl
	insacp libgpg-error
	insacp libgcrypt
	insacp icu4c
	p=`ls $PKG_PATH/png*` 
	pkg_add -I -D repair -D libdepends -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	p=`ls $PKG_PATH/libxslt* $PKG_PATH/gettext* $PKG_PATH/libxml* $PKG_PATH/png* $PKG_PATH/jpeg* $PKG_PATH/t1lib* $PKG_PATH/libiconv* $PKG_PATH/php*` 
	echo $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	pkg_add -I -D repair -D libdepends -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	rm -f /var/www/conf/modules/php.conf /var/www/conf/php.ini /etc/php.ini
	mkdir -p /var/www/conf/modules/
	ln -sf /var/www/conf/modules.sample/php-5.6.conf \
		/var/www/conf/modules/php.conf
	for sp in gd intl ldap mcrypt mysql pod_mysql pdo_pgsql pgsql zip; do
		rm -f /etc/php-5.6/$sp
		if (test -f /etc/php-5.6.sample/$sp.ini) then {
			ln -fs /etc/php-5.6.sample/$sp.ini /etc/php-5.6/
		} fi;
		rm -f /etc/php-7.1/$sp
		if (test -f /etc/php-7.1.sample/$sp.ini) then {
			ln -fs /etc/php-7.1.sample/$sp.ini /etc/php-7.1/
		} fi;
	done;
	if (test "$sweb" = "apache") then {
		chmod +w /var/www/conf/httpd.conf
		ed /var/www/conf/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\#AddType application\/x-httpd-php .php/AddType application\/x-httpd-php .php/g
w
q
EOF
		ed /var/www/conf/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/DirectoryIndex index.html.*/DirectoryIndex index.html index.php/g
w
q
EOF
		ed /var/www/conf/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/UseCanonicalName *On/UseCanonicalName Off/g
w
q
EOF
	} else {
		ed /etc/php-fpm.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/; listen.owner = www/listen.owner = www/g
w
q
EOF
		ed /etc/php-fpm.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/; listen.group = www/listen.group = www/g
w
q
EOF
		ed /etc/php-fpm.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/; *listen *=.*/listen = \/var\/www\/var\/run\/php-fpm.sock/g
w
q
EOF
		ed /etc/php-fpm.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/^listen = .var.www.run.php-fpm.sock/listen = \/var\/www\/var\/run\/php-fpm.sock/g
w
q
EOF
		activarcs php56_fpm
		/etc/rc.d/php56_fpm -d start >> /var/www/tmp/inst-adJ.bitacora 2>&1
		grep "^ *location .*php" /etc/nginx/nginx.conf > /dev/null 2>&1
		if (test "$?" != "0") then {
			grep "^ *ssl_prefer_server_ciphers" /etc/nginx/nginx.conf > /dev/null 2>&1
			if (test "$?" = "0") then {
				ed /etc/nginx/nginx.conf >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
1
?ssl_prefer_server_ciphers
a

        location ~ \.php\$ {
            fastcgi_pass   unix:/var/run/php-fpm.sock;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
            include        fastcgi_params;
        }
.
w
q
EOF
			} fi;
		} fi;
	} fi;
# Antes ,s/session.auto_start = 0/session.auto_start = 1/g
# Pero no es indispensable y si entra en conflicto con horde 3.1.4
	for i in /etc/php-*.ini; do
		echo "Cambiando $i" >> /var/www/tmp/inst-adJ.bitacora 
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/max_execution_time = 30/max_execution_time = 900/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/max_input_time = 60/max_input_time = 900/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/allow_url_fopen = Off/allow_url_fopen = On/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/[;]*date.timezone =.*/date.timezone = America\/Bogota/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/memory_limit = 128M/memory_limit = 1024M/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/upload_max_filesize = 2M/upload_max_filesize = 32M/g
w
q
EOF
		ed $i >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/post_max_size = 8M/post_max_size = 128M/g
w
q
EOF
	done;

} else {
	echo "   Saltando..."  >> /var/www/tmp/inst-adJ.bitacora;
} fi;

if (test "$sweb" = "nginx") then {
	echo "* Corriendo nginx" >> /var/www/tmp/inst-adJ.bitacora
	/etc/rc.d/php56_fpm start >> /var/www/tmp/inst-adJ.bitacora 2>&1
	/etc/rc.d/nginx start >> /var/www/tmp/inst-adJ.bitacora 2>&1
} elif (test "$sweb" = "apache") then {
	echo "* Corriendo Apache" >> /var/www/tmp/inst-adJ.bitacora
	/etc/rc.d/apache start >> /var/www/tmp/inst-adJ.bitacora 2>&1
} else {
	echo "* Corriendo OpenBSD httpd" >> /var/www/tmp/inst-adJ.bitacora
	/etc/rc.d/httpd start >> /var/www/tmp/inst-adJ.bitacora 2>&1
} fi;
sleep 1

if (test "$sweb" = "nginx") then {
	pgrep nginx > /dev/null 2>&1
	rs=$?
} else {
	pgrep httpd > /dev/null 2>&1
	rs=$?
} fi;
if (test "$rs" != "0") then {
	dialog --title 'Fallo servidor web' --msgbox '\nFalló servidor web, revisar, asegurar que funciona y regresar con "exit"' 15 60
	sh
} fi;
if (test -f /var/www/conf/httpd.conf) then {
	cat /var/www/conf/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 
} fi;
if (test -f /etc/nginx/nginx.conf) then {
	cat /etc/nginx/nginx.conf >> /var/www/tmp/inst-adJ.bitacora 
} fi;
if (test -f /etc/httpd.conf) then {
	cat /etc/httpd.conf >> /var/www/tmp/inst-adJ.bitacora 
} fi;

if (test "$sweb" = "apache") then {
	docroot=`awk '
/DocumentRoot  */ {
	if (paso==3) {
		match($0, /DocumentRoot  */);
		sc=substr($0, RSTART+RLENGTH, length($0)-RSTART-RLENGTH+1);
		gsub(/"/, "", sc);
		paso=4;
	}
	if (paso==1) {
		match($0, /DocumentRoot  */);
		sc=substr($0, RSTART+RLENGTH, length($0)-RSTART-RLENGTH+1);
		gsub(/"/, "", sc);
		paso=2;
	}
}

/<VirtualHost .*_default_:443/ {
	if (paso==0) {
		paso=1;
	}
}

/<VirtualHost .*127.0.0.1:443/ {
	if (paso==2 || paso==0) {
		paso=3;
	} 
}

Primero default, pero si despues viene un 127.0.0.1 ese

/.*/ {
}

BEGIN {
	paso=0;
}

END {
	if (paso == 2 || paso == 4) {
		print sc;
	} else {
		print "/var/www/htdocs"
	}
}
' /var/www/conf/httpd.conf`
	chmod -w /var/www/conf/httpd.conf
} elif (test "$sweb" = "apache") then {
	docroot=`awk '
/^ *root  */ {
	if (paso==1) {
		match($0, /root  */);
		sc=substr($0, RSTART+RLENGTH, length($0)-RSTART-RLENGTH+1);
		gsub(/"/, "", sc);
		gsub(/; *$/, "", sc);
		paso=2;
	}
}

/^ *listen  *443 *;/ {
	if (paso==0) {
		paso=1;
	}
}

/.*/ {
}

BEGIN {
	paso=0;
}

END {
	if (paso == 2) {
		print sc;
	} else {
		print "/var/www/htdocs"
	}
}
' /etc/nginx/nginx.conf`

} fi;

cr=`echo "$docroot" | sed -e "s/^\/var\/www\/.*/SIPI/g"`
if (test "$cr" != "SIPI") then {
	docroot="/var/www/$docroot"
} fi;
echo "docroot=$docroot" >>  /var/www/tmp/inst-adJ.bitacora;

echo "* Probando PHP" >> /var/www/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "no" = "probar" -a "$p" != "") then {
	cat > $docroot/phpinfo-adJ.php <<EOF
<?php
	phpinfo();
?>
EOF
	curl -k "https://127.0.0.1/phpinfo-adJ.php" > /tmp/rescurl.html 2> /dev/null
	grep "PHP" /tmp/rescurl.html > /dev/null 2>&1
	if (test "$?" != "0") then {
		dialog --title 'Fallo PHP' --msgbox '\nPHP parece no estar corriendo. Favor revisar y volver a este script con "exit"' 15 60
		sh
	} fi;

rm -f $docroot/phpinfo-adJ.php
rm -f $docroot/phpinfo.php
} else {
	echo "* Saltando"; >> /var/www/tmp/inst-adJ.sh
} fi;

insacp ispell


for i in ruby19-railties-3.1.3 ruby19-actionmailer-3.1.3 \
    ruby19-actionpack-3.1.3 ruby19-erubis-2.7.0 ruby19-tzinfo-0.3.29 \
    ruby19-activeresource-3.1.3 ruby19-rack-ssl-1.3.2 \
    ruby19-activerecord-3.1.3 ruby19-activemodel-3.1.3 \
    ruby19-hike-1.2.1 ruby19-arel-2.2.1 ruby19-rack-mount-0.8.3 \
    ruby19-thor-0.14.6p1 ruby19-activesupport-3.1.3 \
    ruby19-actionmailer-3.1.3 ruby19-sprockets-2.0.3 ruby19-rack-cache-1.1 \
    ruby19-actionpack-3.1.3 ruby-2.3.1 ruby23-ri-docs; do
	pkg_delete -I -D dependencies $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
done

if (test ! -f /home/$uadJ/.irbrc) then {
	cat > /home/$uadJ/.irbrc << EOF
# Configuración de irb
# Basado en archivo de ordenes disponible en http://girliemangalo.wordpress.com/2009/02/20/using-irbrc-file-to-configure-your-irb/
require 'irb/completion'
require 'pp'
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

def clear
    system('clear')
end
EOF
	chown $uadJ:$uadJ /home/$uadJ/.irbrc
} fi;

VRUBY=3.0
VRUBYSP=`echo $VRUBY | sed -e "s/\.//g"`
echo "* Configurar ruby-$VRUBY" >> /var/www/tmp/inst-adJ.bitacora;
uruby=$uadJ
for vrelim in 2.3 2.4 2.5 2.6; do
	v=`(cd /var/db/pkg/; ls) | grep ruby-$vrelim`
	if (test -d /var/www/bundler/ruby/$vrelim/bundler/gems/ -o -d /usr/local/lib/ruby/$vrelim -o "$v" != "") then {
		if (test -d /var/www/bundler/ruby/$vrelim) then {
			uruby=`stat -f "%u" /var/www/bundler/ruby/$vrelim`
			echo "uruby=$uruby" >> /var/www/tmp/inst-adJ.bitacora;
		} fi;
		dialog --title "Eliminar ruby $vrelim y sus librerías" --yesno "\\nSe encontró algo de ruby $vrelim ¿Eliminar para evitar conflictos con la versión $VRUBY?" 15 60
		if (test "$v" != "") then {
			pkg_delete -I -D dependencies $v >> /var/www/tmp/inst-adJ.bitacora 2>&1
		} fi;
		echo "* Eliminando directorios de $vrelim" >> /var/www/tmp/inst-adJ.bitacora;
		rm -rf /var/www/bundler/ruby/$vrelim
		rm -rf /usr/local/lib/ruby/$vrelim
	} fi;
done
	
if (test ! -f "/usr/local/bin/ruby$VRUBYSP") then {
	insacp ruby
} fi

if (test -f "/usr/local/bin/ruby$VRUBYSP") then {
        echo "* Creando enlaces para ruby $VRUBY" >> /var/www/tmp/inst-adJ.bitacora;
	ln -sf /usr/local/bin/ruby$VRUBYSP /usr/local/bin/ruby
	ln -sf /usr/local/bin/erb$VRUBYSP /usr/local/bin/erb
	ln -sf /usr/local/bin/irb$VRUBYSP /usr/local/bin/irb
	ln -sf /usr/local/bin/rdoc$VRUBYSP /usr/local/bin/racc
	ln -sf /usr/local/bin/rdoc$VRUBYSP /usr/local/bin/rdoc
	ln -sf /usr/local/bin/rdoc$VRUBYSP /usr/local/bin/rbs
	ln -sf /usr/local/bin/ri$VRUBYSP /usr/local/bin/ri
	ln -sf /usr/local/bin/rake$VRUBYSP /usr/local/bin/rake
	ln -sf /usr/local/bin/gem$VRUBYSP /usr/local/bin/gem
	ln -sf /usr/local/bin/bundle$VRUBYSP /usr/local/bin/bundle
	ln -sf /usr/local/bin/bundler$VRUBYSP /usr/local/bin/bundler
	ln -sf /usr/local/bin/typeprof$VRUBYSP /usr/local/bin/typeprof
} fi;


echo "* Verificando limites sysctl buenos para ruby" >> /var/www/tmp/inst-adJ.bitacora;
if (test `sysctl -n kern.shminfo.shmmni` -lt "1024") then {
	echo "Aumentar valor de kern.shminfo.shmmni en /etc/sysctl.conf" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
if (test `sysctl -n kern.shminfo.shmmax` -lt "50331648") then {
	echo "Aumentar valor de kern.shminfo.shmmax en /etc/sysctl.conf" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
if (test `sysctl -n kern.seminfo.semmns` -lt "2048") then {
	echo "Aumentar valor de kern.seminfo.semmns /etc/sysctl.conf" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
if (test `sysctl -n kern.shminfo.shmall` -lt "51200") then {
	echo "Aumentar valor de kern.shminfo.shmmall en /etc/sysctl.conf" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
if (test `sysctl -n kern.maxfiles` -lt "20000") then {
	echo "Aumentar valor de kern.maxfiles en /etc/sysctl.conf" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;
if (test ! -d /var/www/bundler/ruby/$VRUBY) then {
  echo "Creando /var/www/bundler/$VRUBY" >> /var/www/tmp/inst-adJ.bitacora;
  doas mkdir -p /var/www/bundler/ruby/$VRUBY/
  doas chown -R $uruby:www /var/www/bundler/ruby/$VRUBY/
} fi;

echo "Eliminando gemas generales repetidas" >> /var/www/tmp/inst-adJ.bitacora;
for i in `gem list | grep "(.*," | sed -e "s/ *([^,]*,/,/g;s/, default: [^,]*//g;s/, /,/g;s/)$//g;s/  */ /g" `; do 
  echo $i; 
  n=`echo $i | sed "s/,.*//g"`
  v=`echo $i | sed "s/.*,//g"`
  cmd="doas gem uninstall --executables --ignore-dependencies $n -v $v"
  echo $cmd
  eval $cmd >> /var/www/tmp/inst-adJ.bitacora 2>&1
done

# Seria bueno eliminar gemas repetidas de /var/www/bundler/ruby/gems/$VRUBY
# gem uninstall no ha operado con --install-dir (aunque la documentacion dice que si).

echo "Actualizando gemas del sistema" >> /var/www/tmp/inst-adJ.bitacora;
gem update --system >> /var/www/tmp/inst-adJ.bitacora 2>&1

echo "Reinstalando gemas generales" >> /var/www/tmp/inst-adJ.bitacora;
QMAKE=qmake-qt5 make=gmake MAKE=gmake doas gem pristine --all >> /var/www/tmp/inst-adJ.bitacora 2>&1

echo "Reinstalando versiones mas actualizadas de gemas de /var/www/bundler/ruby/$VRUBY con extensiones cuando se cambia version menor" >> /var/www/tmp/inst-adJ.bitacora
rm -f /usr/local/bin/bundle
for i in `ls /var/www/bundler/ruby/$VRUBY/extensions/x86_64-openbsd/$VRUBY/ 2> /dev/null | sed -e "s/-[0-9.]*$//g" | sort -u`; do
  uj=""
  for j in /var/www/bundler/ruby/$VRUBY/gems/$i-*; do
    uj=$j
  done
  v=`echo $uj | sed -e 's/.*-\([0-9.]*\)/\1/g'` ; 
  n=`echo $uj | sed -e 's/.*\/\(.*\)-[0-9.]*/\1/g'` ; 
  cmd="doas gem install --install-dir /var/www/bundler/ruby/$VRUBY/ $n -v $v" 
  echo "$cmd"
  eval "$cmd" >> /var/www/tmp/inst-adJ.bitacora 2>&1
done

echo "Instalando gemas importantes " >> /var/www/tmp/inst-adJ.bitacora
gem install pkg-config >> /var/www/tmp/inst-adJ.bitacora 2>&1
gem install bundler >> /var/www/tmp/inst-adJ.bitacora 2>&1
if (test -x /usr/lcoal/bin/bundle$VRUBYSP) then { 
      ln -sf /usr/local/bin/bundle$VRUBYSP /usr/local/bin/bundle
} fi
if (test -x /usr/lcoal/bin/bundler$VRUBYSP) then { 
      ln -sf /usr/local/bin/bundler$VRUBYSP /usr/local/bin/bundler
} fi
bundle config path /var/www/bundler/ruby/$VRUBY

echo "* Configurar tmux" >> /var/www/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/tmux* 2> /dev/null`;
if (test "$f" != "") then {
	pkg_delete -I -D dependencies tmux >> /var/www/tmp/inst-adJ.bitacora 2>&1
} fi;

if (test ! -f /home/$uadJ/.tmux.conf) then {
	cat > /home/$uadJ/.tmux.conf << EOF
set-option -g history-limit 20000

EOF
	chown $uadJ:$uadJ /home/$uadJ/.tmux.conf
} fi;
grep "default-terminal" /home/$uadJ/.tmux.conf > /dev/null 2>&1
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.tmux.conf << EOF
set -g default-terminal "screen"
EOF
} fi;


echo "* Configurando sistema de impresión cups" | tee -a /var/www/tmp/inst-adJ.bitacora;
rm -f /etc/rc.d/dbus_daemon
insacp glib2
insacp dbus	
insacp libusb1
insacp lcms2
insacp cairo
insacp poppler
insacp cups
if (test -f /etc/rc.d/cupsd) then {
	activarcs cupsd
} else {
	echo "** No pudo instalarse cups" | tee -a /var/www/tmp/inst-adJ.bitacora;
} fi;


echo "* Instalando navegador chromium" | tee -a /var/www/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/*chromum* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar chromium' --yesno "\\nChrome instalado. ¿Eliminarlo para instalar uno más nuevo?" 15 60
	if (test "$?" = "0") then {
		pkg_delete -I -D dependencies chromium >> /var/www/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies chromium >> /var/www/tmp/inst-adJ.bitacora 2>&1
	} fi;
} fi;
f=`ls /var/db/pkg/chromium* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {

	insacp png
	insacp glib2
	insacp cairo
	insacp libffi
	insacp pcre
	insacp icu4c
	insacp harfbuzz
	insacp pango
	insacp gtk+2

	p=`ls $PKG_PATH/libxml-* $PKG_PATH/shared-mime-info-* $PKG_PATH/pcre-* $PKG_PATH/png-* $PKG_PATH/jpeg-* $PKG_PATH/glib2-* $PKG_PATH/tiff-* $PKG_PATH/libiconv-* $PKG_PATH/esound-* $PKG_PATH/atk-* $PKG_PATH/desktop-file-utils-* $PKG_PATH/gettext-* $PKG_PATH/libaudiofile-* $PKG_PATH/gtk+2-* $PKG_PATH/cairo-* $PKG_PATH/pango-* $PKG_PATH/nss-* $PKG_PATH/nspr-* $PKG_PATH/jasper-* $PKG_PATH/hicolor-icon-theme-* $PKG_PATH/chromium-*`
        pkg_add -I -D repair -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	#echo "Sugerencias: " >> /var/www/tmp/inst-adJ.bitacora;
	#echo "  * Configure localización en español desde about:config general.useragent.local es-AR"
	#echo "  * Como página de inicio use https://127.0.0.1/";
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

echo "* Permisos para aplicaciones" >> /var/www/tmp/inst-adJ.bitacora;

if (test -d /home/$uadJ/.config/chromium) then {
	chown -R $uadJ:$uadJ /home/$uadJ/.config/chromium
} fi;

if (test -d /home/$uadJ/.openoffice.org2) then {
	chown -R $uadJ:$uadJ /home/$uadJ/.openoffice.org2
} fi;

echo "* Agregar usuario a grupo wheel" >> /var/www/tmp/inst-adJ.bitacora;
grep wheel /etc/group | grep $uadJ > /dev/null
if (test "$?" != "0") then {
	usermod -G wheel $uadJ >> /var/www/tmp/inst-adJ.bitacora
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;


echo "* Instalando adminstrador de archivos xfe" | tee -a /var/www/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/xfe* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	pkg_delete -I -D dependencies xfe >> /var/www/tmp/inst-adJ.bitacora 2>&1
	rm /home/$uadJ/.config/xfe/xf*
} fi;
f=`ls /var/db/pkg/xfe* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	p=`ls $PKG_PATH/libiconv-* $PKG_PATH/fox-* $PKG_PATH/gettext-* $PKG_PATH/xfe-*`
        pkg_add -I -D repair -D update -D updatedepends -r $p >> /var/www/tmp/inst-adJ.bitacora 2>&1
	# Archivo de configuración se creará en primera ejecución de xfe
	mkdir -p /home/$uadJ/.config/xfe/
	chown -R $uadJ:$uadJ /home/$uadJ/.config
} else {
	echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar xfe" >> /var/www/tmp/inst-adJ.bitacora;
if (test ! -f "/home/$uadJ/.config/xfe/xferc") then {
	cat > /home/$uadJ/.config/xfe/xferc <<EOF
[OPTIONS]
uso_sudo=1
sudo_passwd=1
EOF
} else {
	for m in uso_sudo sudo_passwd; do
		grep "^ *$m" /home/$uadJ/.config/xfe/xferc > /dev/null 2>&1
		if (test "$?" = "0") then {
			ed /home/$uadJ/.config/xfe/xferc >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\($m\).*/\1=1/g
w
q
EOF
		} else {
			ed /home/$uadJ/.config/xfe/xferc >> /var/www/tmp/inst-adJ.bitacora 2>&1 <<EOF
/[OPTIONS]
a
$m=1
.
w
q
EOF
		} fi;
	done;
} fi;

chmod a+rxw /var/www/tmp > /dev/null 2>&1


dialog --title 'Componentes básicos instalados' --msgbox "\\nInstalación y configuración de los componentes básicos de adJ completada.\\n\\nPor instalar los demás paquetes de $ARCH/paquetes" 15 60
#, mientras tanto puede instalar SIVeL:"
#echo "1. Pase a la consola gráfica con [Ctrl]-[Alt]-[F5] o si no es gráfica iniciela desde la segunda consola [Ctrl]-[Alt]-[F2] con 'xdm'"
#echo "2. Abra chromium (o en modo texto elinks) y use la dirección 'https://127.0.0.1/actualiza.php'"
#echo "3. Debe poder ingresar con el usuario que creó"
#echo "4. Complete actualización de SIVeL siguiendo las instrucciones"
#echo ""
#echo "Si hay inconvenientes puede examinar log de Apache en /var/www/logs/error y ayudar en el desarrollo de SIVeL suscribiendose y enviando sus mejoras a adJ-soporte@lists.sourceforge.net";

clear
echo "Eliminando parciales" >> /var/www/tmp/inst-adJ.bitacora 
cd /var/db/pkg
for i in partial-*; do 
	echo $i >> /var/www/tmp/inst-adJ.bitacora ; 
	pkg_delete -I-D dependencies  $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
done

echo "Eliminando problemáticos" >> /var/www/tmp/inst-adJ.bitacora 
pkg_delete -I -D dependencies libstdc++ >> /var/www/tmp/inst-adJ.bitacora  2>&1
pkg_delete -I -D dependencies lua >> /var/www/tmp/inst-adJ.bitacora  2>&1
pkg_delete -I -D dependencies gtk+2 >> /var/www/tmp/inst-adJ.bitacora  2>&1

echo "Instalando algunos comunes" >> /var/www/tmp/inst-adJ.bitacora 
pkg_add -I -D repair -D updatedepends -D update -D libdepends -r $PKG_PATH/sdl*tgz $PKG_PATH/libxml*tgz $PKG_PATH/libgpg-error*tgz $PKG_PATH/libart-*.tgz  >> /var/www/tmp/inst-adJ.bitacora 2>&1
pkg_add -I -D repair -D updatedepends -D update -D libdepends -r $PKG_PATH/gtk+2*tgz >> /var/www/tmp/inst-adJ.bitacora 2>&1

echo "Instalando todos los disponibles en PKG_PATH" >> /var/www/tmp/inst-adJ.bitacora 
pkg_add -I -D repair -D update -u 
cd /var/db/pkg/
for i in $PKG_PATH/*tgz; do
	echo $i | tee -a /var/www/tmp/inst-adJ.bitacora
	pkg_add -I -D repair -D updatedepends -D update -D libdepends -r $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
done;

echo "Eliminando librerías innecesarias" >> /var/www/tmp/inst-adJ.bitacora 
cd /var/db/pkg
for i in .libs*; do 
	echo $i >> /var/www/tmp/inst-adJ.bitacora ; 
	pkg_delete -I $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
done
rm -rf *core

for i in $PKG_PATH/*tgz; do
	echo $i | tee -a /var/www/tmp/inst-adJ.bitacora
	pkg_add -I -D repair -D updatedepends -D update -D libdepends -r $i >> /var/www/tmp/inst-adJ.bitacora 2>&1
done;

pkg_add -I -D repair -D installed sword-* 2>&1 | tee -a /var/www/tmp/inst-adJ.bitacora 
pkg_add -I -D repair -D update -u 2>&1 | tee -a /var/www/tmp/inst-adJ.bitacora 

# Configuraciones típicas

echo "* Configurar vim con UTF-8" >> /var/www/tmp/inst-adJ.bitacora;
if (test ! -d /home/$uadJ/.vim) then {
	mkdir -p /home/$uadJ/.vim
	cp -rf /usr/local/share/vim/vim*/* /home/$uadJ/.vim/
	chown -R $uadJ:$uadJ /home/$uadJ/.vim
} fi;

if (test ! -f /home/$uadJ/.vimrc) then {
	cp -f /usr/local/share/vim/vim*/vimrc_example.vim /home/$uadJ/.vimrc
	chown $uadJ:$uadJ /home/$uadJ/.vimrc
} fi;

grep "set  *tenc" /home/$uadJ/.vimrc> /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.vimrc <<EOF
set encoding&       " terminal charset: follows current locale 
set fileencoding&   " auto-sensed charset of current buffer
EOF
} fi;
if (test ! -f "/home/$uadJ/.vim/after/ftplugin/ruby.vim") then {
	mkdir -p /home/$uadJ/.vim/after/ftplugin/
	cat > /home/$uadJ/.vim/after/ftplugin/ruby.vim <<EOF
set expandtab
setlocal shiftwidth=2
setlocal tabstop=2
EOF
} fi;

# Diccionario español de LibreOffice
# http://es.openoffice.org/programa/diccionario.html
if (test -f $ARCH/util/es_CO.oxt -a -f /usr/local/lib/libreoffice/program/unopkg) then {
	/usr/local/lib/libreoffice/program/unopkg add --shared $ARCH/util/es_CO.oxt
} fi;

echo "* Configurar pidgin con SILC y canales en www.nocheyniebla.org" >> /var/www/tmp/inst-adJ.bitacora;
if (test ! -f /home/$uadJ/.purple/blist.xml) then {

	cat	/home/$uadJ/.purple/blist.xml <<EOF
<?xml version='1.0' encoding='UTF-8' ?>

<purple version='1.0'>
	<blist>
		<group name='Chats'>
			<setting name='collapsed' type='bool'>0</setting>
			<chat proto='prpl-silc' account='$uadJ@www.nocheyniebla.org'>
				<component name='channel'>soporte-ubuntuCE</component>
				<setting name='gtk-persistent' type='bool'>1</setting>
				<setting name='gtk-autojoin' type='bool'>1</setting>
			</chat>
			<chat proto='prpl-silc' account='$uadJ@www.nocheyniebla.org'>
				<component name='channel'>soporte-adJ</component>
				<setting name='gtk-persistent' type='bool'>1</setting>
				<setting name='gtk-autojoin' type='bool'>1</setting>
			</chat>
			<chat proto='prpl-silc' account='$uadJ@www.nocheyniebla.org'>
				<component name='channel'>sincodh</component>
				<setting name='gtk-persistent' type='bool'>1</setting>
				<setting name='gtk-autojoin' type='bool'>1</setting>
			</chat>
			<chat proto='prpl-silc' account='$uadJ@www.nocheyniebla.org'>
				<component name='channel'>redbandatos</component>
				<setting name='gtk-persistent' type='bool'>1</setting>
				<setting name='gtk-mute-sound' type='bool'>0</setting>
				<setting name='gtk-autojoin' type='bool'>1</setting>
			</chat>
		</group>
	</blist>
	<privacy>
		<account proto='prpl-silc' name='$uadJ@www.nocheyniebla.org' mode='1'/>
	</privacy>
</purple>
EOF

} fi;

if (test -d /home/$uadJ/.libreoffice) then {
	chown -R $uadJ:$uadJ /home/$uadJ/.libreoffice
} fi;

if (test ! -h /usr/local/bin/python) then {
	ln -sf /usr/local/bin/python2.7 /usr/local/bin/python
	ln -sf /usr/local/bin/python2.7-2to3 /usr/local/bin/2to3
	ln -sf /usr/local/bin/python2.7-config /usr/local/bin/python-config
	ln -sf /usr/local/bin/pydoc2.7  /usr/local/bin/pydoc
} fi;

chmod a+xrw /var/www/tmp

echo "* Volviendo a cambiar en por servicio en etc" >> /var/www/tmp/inst-adJ.bitacora;
cd /etc && /usr/local/adJ/servicio-etc.sh >> /var/www/tmp/inst-adJ.bitacora 2>&1
dialog --title 'Componentes básicos instalados' --msgbox "\\nFELICITACIONES!  La instalación/actualización de la distribución Aprendiendo de Jesús $VER se completó satisfactoriamente\\n\\n Para instalar SIVeL ejecute \"doas /usr/local/adJ/inst-sivel.sh\"" 15 60

