#!/bin/sh
# Instala/Actualiza un Aprendiendo de Jesús 
# Dominio público. 2012. vtamara@pasosdeJesus.org

VER=5.2
VESP=""
VERP=52

# Falta /standard/root.hint

ACVER=`uname -r`
ARQ=`uname -m`

export PATH=$PATH:/usr/local/bin

if (test "$USER" != "root") then {
	echo "Este script debe ser ejecutado por root o con sudo";
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

mkdir -p /var/tmp
if (test "$?" != "0") then {
	echo "No pudo crearse directorio /var/tmp para la bitácora";
	exit 1;
} fi;

echo "-+-+-+-+-+-+" >> /var/tmp/inst-adJ.bitacora
echo "Bitácora de instalación " >> /var/tmp/inst-adJ.bitacora
date >> /var/tmp/inst-adJ.bitacora
echo "VER=$VER ARCVER=$ARCVER TAM=$TAM RUTAIMG=$RUTAIMG ARCH=$ARCH ARCHSIVEL=$ARCHSIVEL ARCHSIVELPEAR=$ARCHSIVELPEAR" >> /var/tmp/inst-adJ.bitacora

# Creates a string by concatenating $1, $2 times to $3 prints the result.
# From configuration tool of http://structio.sf.net/sigue
function mkstr {
	if (test "$2" -lt "0") then {
		echo "Bug.  Times cannot be negative" >> /var/tmp/inst-adJ.bitacora;
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
	if (test "$ns" = "") then {
		echo "Falta nombre de servicio como primer parametro en activarcs";
		exit 1;
	} fi;
	if (test ! -f "/etc/rc.d/$ns") then {
		echo "En /etc/rc.d falta servicio de nombre $ns" 
		exit 1;
	} fi;
	echo "activando $ns" >> /var/tmp/inst-adJ.bitacora 2>&1 
	grep "^ *pkg_scripts.*[^a-zA-Z0-9_]$ns[^a-zA-Z0-9_]" /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 
	if (test "$?" != "0") then {
		echo "No  hay pkg_scripts con $ns"  >> /var/tmp/inst-adJ.bitacora 2>&1 
		grep "^ *pkg_script" /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 
		if (test "$?" != "0") then {
			echo "No hay pkg_script" >> /var/tmp/inst-adJ.bitacora 2>&1 
			ed /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
$
a
pkg_scripts="$ns"
.
w
q
EOF
		} else {
			cs=`grep "^ *pkg_scripts *=" /etc/rc.conf.local | sed -e "s/pkg_scripts *= *\"\([^\"]*\)\".*/\1/g"`
			if (test "$cs" != "") then {
				cs="$cs $ns";
			} else {
				cs=$ns;
			} fi;
			echo "cs=$cs" >> /var/tmp/inst-adJ.bitacora 2>&1 
			ed /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^ *pkg_scripts *=
.c
pkg_scripts="$cs"
.
w
q
EOF
		} fi;
	} else  {
		echo "Activo" >> /var/tmp/inst-adJ.bitacora 2>&1 
	} fi;
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

service="/sbin/mount"

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


echo "Script de instalación de adJ $VER" >> /var/tmp/inst-adJ.bitacora
echo "---------------------------- " >> /var/tmp/inst-adJ.bitacora
echo "Se recomienda ejecutarlo desde una terminal en X-Window" >> /var/tmp/inst-adJ.bitacora

mount > /dev/null 2> /dev/null
if (test "$?" != "0") then {
echo 'No puede ejecutarse mount vuelva a ejecutar este script así:
export PATH="$PATH:/bin/:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"
sudo /inst-adJ.sh'
exit 1;
} fi;

umount /mnt/cdrom 2> /dev/null > /dev/null
mount | grep "/mnt/cdrom" > /dev/null 2> /dev/null
if (test "$?" = "0") then {
echo "No puede desmontarse el CDROM" >> /var/tmp/inst-adJ.bitacora ;
echo "Desmontelo y vuelva a ejecutar este archivo de comandos" | tee -a 
/var/tmp/inst-adJ.bitacora;
exit 1;
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
if (test "$uadJ" = "") then {
	uadJ=$padJ;
} fi;
done;
ADMADJ=$uadJ;

echo "* Creando cuenta inicial"  >> /var/tmp/inst-adJ.bitacora
groupinfo $uadJ > /dev/null
if (test "$?" != "0") then {
groupadd $uadJ
} fi;
userinfo $uadJ >/dev/null
if (test "$?" != "0") then {
adduser -v -batch $uadJ $uadJ,wheel $uadJ
passwd $uadJ
} else {
echo "   Saltando..."  >> /var/tmp/inst-adJ.bitacora;
} fi;
user mod -g $uadJ $uadJ
user mod -G users $uadJ
user mod -G staff $uadJ
user mod -G operator $uadJ

# Preparando en casos de actualización grande

sudo chown $uadJ:$uadJ /home/$uadJ/.Xauthority > /dev/null 2>&1
sudo rm -rf /home/$uadJ/.font*

usermod -G operator $uadJ
echo "* Dispositivos montables por usuarios" >> /var/tmp/inst-adJ.bitacora;
grep "^ *kern.usermount *= *1" /etc/sysctl.conf > /dev/null 2> /dev/null
if (test "$?" != "0") then {
cat >> /etc/sysctl.conf <<EOF
kern.usermount=1
EOF
sysctl -w kern.usermount=1 > /dev/null
} else {
echo "   Saltando..."  >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Permisos de /mnt" >> /var/tmp/inst-adJ.bitacora;
ls -l /mnt/ | grep "root  wheel" > /dev/null 2> /dev/null
if (test "$?" = "0") then {
sudo chown $uadJ:$uadJ /mnt/*	2> /dev/null > /dev/null
} fi;



echo "Sistemas de archivos de CDROM en /etc/fstab" >> /var/tmp/inst-adJ.bitacora
grep "/mnt/cdrom" /etc/fstab > /dev/null
if (test "$?" != "0") then {
echo "/dev/cd0a /mnt/cdrom cd9660 noauto,ro 0 0" >> /etc/fstab
mkdir -p /mnt/cdrom
} else {
echo "   Saltando cd0a..." >> /var/tmp/inst-adJ.bitacora;
} fi;
sudo chown $uadJ:$uadJ /mnt/cdrom

chmod g+rw /dev/sd?i /dev/sd?c /dev/cd?c /dev/cd?a

mkdir -p /var/www/tmp
chmod a+rxw /var/www/tmp > /dev/null 2>&1
chmod +t /var/www/tmp

# Puede faltar en algunos sitios
# cd /dev
# MAKEDEV sd5

if (test "$ARCH" = "") then {
echo "Suponiendo que se instala de CD-ROM." >> /var/tmp/inst-adJ.bitacora;
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
	echo "   Saltando..."| tee -a /var/tmp/inst-adJ.bitacora;
} fi;
} else {
p=`echo $ARCH | sed -e "s/^\(.\).*/\1/g"`;
if (test "$p" != "/") then {
	echo "ARCH deberia ser una ruta absoluta (comenzando con /)";
	exit 1;
} fi;
} fi;

if (test ! -f "$ARCH/Novedades.txt" -o ! -d "$ARCH/paquetes") then {
echo "En la ruta $ARCH no está el CD Aprendiendo de Jesús" >> /var/tmp/inst-adJ.bitacora;
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
echo "* Instalar $n"  >> /var/tmp/inst-adJ.bitacora;
opbor="";
f=`ls /var/db/pkg/$n-* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	echo "$n instalado. Intentando remplazar " >> /var/tmp/inst-adJ.bitacora
	opbor="-r -D update -D updatedepends"
} fi;

pkg_add $opbor $PKG_PATH/$n-[0-9]*.tgz >> /var/tmp/inst-adJ.bitacora 2>&1
if (test "$popc" != "") then {
	pkg_add $opbor $PKG_PATH/${popc}*.tgz >> /var/tmp/inst-adJ.bitacora 2>&1
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

echo "Sistemas de archivos para USB en /etc/fstab" >> /var/tmp/inst-adJ.bitacora
grep "/mnt/usb" /etc/fstab > /dev/null
if (test "$?" != "0") then {
	echo "Detectando dispositivo que corresponde a memoria USB" >> /var/tmp/inst-adJ.bitacora;
	dialog --title 'Configurando USB (1)' --msgbox '\nDesmonte y retire toda memoria USB que pueda haber\n' 15 60
	dmesg > /tmp/dmesg1
	dialog --title 'Configurando USB (2)' --msgbox '\nPonga una memoria USB\n' 15 60
	dmesg > /tmp/dmesg2
	diff /tmp/dmesg1 /tmp/dmesg2 > /tmp/dmesgdiff
	nusb=0;
	grep "[>] sd" /tmp/dmesgdiff > /dev/null 2>&1
	if (test "$?" = "0") then {
		nusb=`grep "[>] sd" /tmp/dmesgdiff | head -n 1 | sed -e  "s/.* sd\([0-9]\).*/\1/g"` 
	} fi;
	echo "    Configurando dispositivo /dev/sd${nusb}c" >> /var/tmp/inst-adJ.bitacora;
	dialog --title 'Configurando USB (3)' --msgbox '\nRetire la memoria USB\n' 15 60
	echo "/dev/sd${nusb}i /mnt/usb msdos noauto,rw 0 0" >> /etc/fstab
	mkdir -p /mnt/usb
	echo "/dev/sd${nusb}c /mnt/usbc msdos noauto,rw 0 0" >> /etc/fstab
	mkdir -p /mnt/usbc
} else {
	echo "   Saltando USB..." >> /var/tmp/inst-adJ.bitacora;
} fi;
sudo chown $uadJ:$uadJ /mnt/usb 
sudo chown $uadJ:$uadJ /mnt/usbc


userinfo _hostapd >/dev/null
if (test "$?" != "0") then {
	echo "Aplicando actualizaciones de 3.7 a 3.8"  >> /var/tmp/inst-adJ.bitacora;
	
	useradd -u86 -g=uid -c"HostAP Service" -d/var/empty -s/sbin/nologin _hostapd
} fi;

#grep "nat-anchor" /etc/pf.conf > /dev/null
#if (test "$?" != "0") then {
#	echo "Aplicando actualizaciones de 3.8 a 3.9"  >> /var/tmp/inst-adJ.bitacora;
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
	echo "Aplicando actualizaciones de 3.9 a 4.0"  >> /var/tmp/inst-adJ.bitacora;
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
	echo "Aplicando actualizaciones de 4.0 a 4.1" >> /var/tmp/inst-adJ.bitacora;

	useradd -u88 -g=uid -c"RIP Service" -d/var/empty -s/sbin/nologin _ripd >> /var/tmp/inst-adJ.bitacora
	useradd -u89 -g=uid -c"Relay Service" -d/var/empty -s/sbin/nologin _relayd >> /var/tmp/inst-adJ.bitacora
} fi;

userinfo _ospf6d >/dev/null
if (test "$?" != "0") then {
	# Los que se cambien aqui borrarlos de /tmp/etc para que no
	# sean actualizados por mergemaster

	vac="$vac 4.2 a 4.3";	
	echo "Aplicando actualizaciones de 4.2 a 4.3" >> /var/tmp/inst-adJ.bitacora;
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
		ed /var/www/conf/httpd.conf >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
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

userinfo _rtadvd >/dev/null
if (test "$?" != "0") then {
	vac="$vac 4.3 a 4.4";	
	echo "Aplicando actualizaciones de 4.3 a 4.4" >> /var/tmp/inst-adJ.bitacora;
	useradd -u92 -g=uid -c"IPv6 Router Advertisement Service" -d/var/empty -s/sbin/nologin _rtadvd
	useradd -u93 -g=uid -c"YP to LDAP Service" -d/var/empty -s/sbin/nologin _ypldap
	rm -f /etc/dhcpd.interfaces

# Posiblemente en httpd.conf
# :%s/\(VirtualHost.* \)\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\)>/\1\2:80>/g
#  :%s/\(VirtualHost.* \)\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\) /\1\2:80 /g
} fi;

userinfo _btd >/dev/null
if (test "$?" != "0") then {
# http://www.openbsd.org/faq/upgrade45.html
	vac="$vac 4.4 a 4.5";	
	echo "Aplicando actualizaciones de 4.4 a 4.5" >> /var/tmp/inst-adJ.bitacora;
	useradd -u94 -g=uid -c"Servicio Bluetooth" -d/var/empty -s/sbin/nologin _btd
	for i in p5-Archive-Tar p5-Compress-Raw-Zlib p5-Compress-Zlib \
p5-IO-Compress-Base p5-IO-Compress-Zlib p5-IO-Zlib p5-Module-Build \
p5-Module-CoreList p5-Module-Load p5-version p5-Digest-SHA \
p5-Locale-Maketext-Simple p5-Pod-Escapes p5-Pod-Simple \
p5-ExtUtils-ParseXS p5-ExtUtils-CBuilder p5-Module-Pluggable \
p5-Time-Piece p5-Module-Loaded xcompmgr; do
		pkg_delete -I -D dependencies $i 2>> /var/tmp/inst-adJ.bitacora 2>&1
	done;
	ed /etc/mixerctl.conf >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/headphones/hp/g
,s/speaker/spkr/g
w
q
EOF
	ed /etc/X11/xorg.conf >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/i810/intel/g
,s/.*RgbPath .*//g
w
q
EOF

	find /usr/X11R6/lib/modules ! -newer libscanpci.la | xargs sudo rm -f >> /var/tmp/inst-adJ.bitacora 2>&1

} fi;

	
userinfo _nsd >/dev/null 2>&1
if (test "$?" != "0") then {
# http://www.openbsd.org/faq/upgrade47.html
	vac="$vac 4.6 a 4.7";	
	mac="$mac Copia de respaldo de /etc/pf.conf inicial dejada en /etc/pf46.conf. Es importante verificar /etc/pf.conf manualmente\n"
	echo "Aplicando actualizaciones de 4.6 a 4.7" >> /var/tmp/inst-adJ.bitacora;
	useradd -u 97 -g =uid -c "NSD Service" -d /var/empty -s /sbin/nologin _nsd
	useradd -u 98 -g =uid -c "LDP Service" -d /var/empty -s /sbin/nologin _ldpd

	sudo cp /etc/pf.conf /etc/pf46.conf
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
	echo "Aplicando actualizaciones de 4.7 a 4.8" >> /var/tmp/inst-adJ.bitacora;
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
	echo "Aplicando actualizaciones de 4.8 a 4.9" >> /var/tmp/inst-adJ.bitacora;
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

	echo "Verificando sintaxis para redes inalambricas WPA" >> /var/tmp/inst-adJ.bitacora; 
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
	echo "Aplicando actualizaciones de 4.9 a 5.0" >> /var/tmp/inst-adJ.bitacora;
    sudo mv /etc/security /etc/security49.anterior
    sudo rm -rf /etc/X11/xkb /usr/lib/gcc-lib/$(arch -s)-unknown-openbsd4.? /usr/bin/perl5.10.1 /usr/libdata/perl5/$(arch -s)-openbsd/5.10.1 
    sudo cp /etc/pf.conf /etc/pf49.conf
	cat > /tmp/z.sed << EOF
s/pass  *in  *quick  *proto  *tcp  *to  *port  *ftp  *rdr-to  *127.0.0.1  *port  *8021/pass in quick inet proto tcp to port ftp divert-to 127.0.0.1 port 8021/g
s/pass  *in  *quick  *on  *internal  *proto  *udp  *to  *port  *tftp  *rdr-to  *127.0.0.1  *port  *6969/pass in quick on internal inet proto udp to port tftp divert-to 127.0.0.1 port 6969/g
EOF
	sed -f /tmp/z.sed /etc/pf49.conf > /etc/pf.conf
} fi;

if (test ! -f /var/named/standard/root.hint) then {
	cp /var/named/etc/root.hint /var/named/standard/
} fi;
	

if (test ! -f /var/named/standard/root.hint) then {
	cp /var/named/etc/root.hint /var/named/standard/
} fi;
if (test -d /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl) then {
	vac="$vac 5.0 a 5.1";	
	echo "Aplicando actualizaciones de 5.0 a 5.1" >> /var/tmp/inst-adJ.bitacora;
    sudo rm -rf /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl
    sudo rm -f /etc/rc.d/aucat
    sudo rm -f /etc/ccd.conf /sbin/ccdconfig /usr/share/man/man8/ccdconfig.8
    sudo rm -f /usr/sbin/pkg_merge
    sudo rm -f /usr/libexec/getNAME /usr/share/man/man8/getNAME.8
    sudo rm -rf /usr/lib/gcc-lib/amd64-unknown-openbsd5.0
    sudo rm -f /usr/bin/midicat /usr/share/man/man1/midicat.1
    sudo rm -f /usr/bin/makewhatis /usr/bin/mandocdb /usr/share/man/man8/mandocdb.8
} fi;

if  (test "$vac" != "") then {
	dialog --title 'Actualizaciones aplicadas' --msgbox "\\nSe aplicaron actualizaciones: $vac\\n\\n$mac\\n" 15 60
} fi;

cd /etc && /usr/local/adJ/service-etc.sh >> /var/tmp/inst-adJ.bitacora 2>&1

if (test ! -f /var/log/service) then {
	if (test -f /var/log/daemon) then {
		mv /var/log/daemon /var/log/service
	} fi;
	touch /var/log/service
} fi;

echo "* Preparar /etc/rc.local para que reinicie servicios faltantes" >> /var/tmp/inst-adJ.bitacora;
grep "\. /etc/rc.conf" /etc/rc.local > /dev/null 2> /dev/null
if (test "$?" != "0") then {
	ed /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/securel
a

# Este script podría ser ejecutado desde una tarea cron para reparar
# servicios que pudieran haberse caido.  Verifique que cada servicio 
# está efectivamente abajo antes de iniciarlo.
. /etc/rc.conf
.
w
q
EOF
} 
else {
	echo "   Saltando..." >>  /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Nueva forma de /etc/rc.local" >> /var/tmp/inst-adJ.bitacora;
grep "for _r in \${pkg_scripts}" /etc/rc.local> /dev/null 2>&1
if (test "$?" != "0") then {
	echo "Activando" >> /var/tmp/inst-adJ.bitacora;
	ed /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/. \/etc\/rc.conf
a

if (test " \$TERM" != "") then {
	for _r in \${pkg_scripts}; do
		echo -n " \${_r}";
		if (test -x /etc/rc.d/\${_r}) then {
			/etc/rc.d/\${_r} check
			if (test "\$?" != "0") then {
				/etc/rc.d/\${_r} start
			} fi;
		} fi;
	done
} fi;

.
w
q
EOF
} fi;

if (test -f /etc/rc.d/cron) then {
	activarcs cron
} fi;
if (test -f /etc/rc.d/httpd) then {
	activarcs httpd
} fi;

echo "* Crear scripts para montar imagenes encriptadas como servicios" >> /var/tmp/inst-adJ.bitacora;
nuevomonta=0;

creamontador /etc/rc.d/montaencres /var/www/resbase 2 $uadJ $uadJ /var/resbase.img
creamontador /etc/rc.d/montaencpos /var/postgresql 1 _postgresql _postgresql /var/post.img
rm -f /usr/local/sbin/monta.sh

grep "mount.*post" /etc/rc.local > /dev/null 2>&1
if (test "$?" = "0") then {
	ed /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/mount.*post
.,+4d
w
q
EOF
	activarcs montaencpos
} fi;
grep "mount.*resbase" /etc/rc.local > /dev/null 2>&1
if (test "$?" = "0") then {
	ed /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/mount.*resbase
.,+4d
w
q
EOF
	activarcs montaencres
} fi;


echo "¿Actualizar archivos de /etc? (requerido si actualizó sistema base) (s/n)" #>> /var/tmp/inst-adJ.bitacora;
dialog --title 'Archivos de configuración de /etc' --yesno '\nActualizar archivos del directorio /etc?\n\nRequerido si actualizó sistema base de una versión previa' 15 60 
if (test "$?" = "0") then {
	dialog --title 'sysmerge' --msgbox '\nDurante la ejecución de sysmerge, recomendamos que instale nuevas versiones de todos los archivos (con la opción i), excepto de los archivos:\n  /etc/group\n  /etc/master.passwd\n  /etc/sysctl.conf\n  /var/www/conf/httpd.conf\n  /var/named/etc/named.conf\n' 15 60 

	mkdir -p /var/tmp/temproot
	tar xzpf $ARCH/etc??.tgz -C /var/tmp/temproot
	tar xzpf $ARCH/xetc??.tgz -C /var/tmp/temproot
	if (test "$?" = "0") then {
		cmd="cd /var/tmp/temproot/etc;
		cp -f changelist chio.conf daily dvmrpd.conf ftpusers hostapd.conf lynx.cfg moduli monthly netstart ospf6d.conf pf.os rc rc.conf relayd.conf >> /
security sensorsd.conf services snmpd.conf syslog.conf weekly /etc;
                cp mail/README mail/submit.cf mail/helpfile mail/localhost.cf /etc/mail/;
		#cp ppp/ppp.conf.sample /etc/ppp/;
		#cp ssh/ssh_config ssh/sshd_config /etc/ssh/;
		cp ../var/named/etc/root.hint /var/named/etc/
		cp mtree/* /etc/mtree/;
		newaliases
		mtree -qdef /etc/mtree/4.4BSD.dist -p / -u"
		echo "Por ejecutar: $cmd" >>  /var/tmp/inst-adJ.bitacora
		eval $cmd;
		cd /var/tmp/temproot/etc
		cmd="";
		if (test "$EDITOR" = "" -a "$VISUAL" = "") then {
echo "EDITOR=$EDITOR"
echo "VISUAL=$VISUAL"
			cmd="EDITOR=mg ";
		} fi;
		if (test ! -f /etc/sysmerge.ignore) then {
			cat > /etc/sysmerge.ignore <<EOF
/etc/master.passwd
/etc/group
/etc/rc.local
EOF
		} fi;
		clear
		cmd="$cmd sysmerge -s $ARCH/etc$VERP.tgz -x $ARCH/xetc$VERP.tgz"
		echo $cmd;
		eval $cmd;
	} fi;
} fi;

sh /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1

echo "* Configurar script de inicio de root (root/.profile)" >> /var/tmp/inst-adJ.bitacora;
grep "PKG_PATH" /root/.profile > /dev/null 2>&1
if (test "$?" != "0") then {
	cat >> /root/.profile <<EOF
export PKG_PATH=ftp://carroll.cac.psu.edu/pub/OpenBSD/$VER/packages/$ARQ/
export PKG_PATH=ftp://ftp.pasosdeJesus.org/pub/OpenBSD/$VER/packages/$ARQ/
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
export PS1="\h# "
export HISTFILE=$HOME/.pdksh_history
export LANG=es_CO.UTF-8
EOF
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar LANG en script de inicio de root (root/.profile)" >> /var/tmp/inst-adJ.bitacora;
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
	
echo "* Configurar X-Window" >> /var/tmp/inst-adJ.bitacora
pgrep xdm > /dev/null 2>&1
if (test "$?" != "0" -a ! -f /etc/X11/xorg.conf) then {
	dialog --title 'Configuración de X-Window' --msgbox "\nPodría ocurrir que al ejecutar 'X -config' se congele su sistema, en ese caso reinicie y si el archivo /root/xorg.conf no es vacío ejecute \n
	cp /home/$uadJ/xorg.conf.new /etc/X11/xorg.conf\n
o cree un archivo de configuración con\n
	Xorg -configure\n
Puede examinar errores, causas y soluciones al final de la bitacora que puede examinar con:\n
        less /var/log/Xorg.log.0\n" 15 60
	X -configure
	cat /var/log/Xorg.0.log >> /var/tmp/inst-adJ.bitacora
	clear
	echo "Verifique si corre X-Window (modo gráfico) ejecutando"
	echo "     Xorg -config /home/$uadJ/xorg.conf.new"
	echo "Puede salir de X-Window con [Ctrl]-[Alt]-[BackSpace]."
	echo "De requerirlo ajuste la configuración con:"
	echo "     mg /home/$uadJ/xorg.conf.new"
	echo "Regrese a este script con 'exit'";
	sh
	dialog --title 'Configuración de X-Window' --yesno '\n¿Logró configurar X-Window?' 15 60 
	if (test "$?" = "0") then {
		cp /home/$uadJ/xorg.conf.new /etc/X11/xorg.conf
		nt=`cat /etc/kbdtype`;
		if (test "$nt" != "us") then {
			awk  "/.*/ { print \$0; } /\"kbd\"/ { print \"    Option \\\"XkbLayout\\\" \\\"$nt\\\"\"; }" /root/xorg.conf.new > /etc/X11/xorg.conf
		} fi;
		echo "xdm_flags=\"\"" >> /etc/rc.conf.local
	} fi;
} else {
	echo "   Saltando..."  >> /var/tmp/inst-adJ.bitacora;
} fi;
echo "/etc/X11/xorg.conf" >> /var/tmp/inst-adJ.bitacora
cat /etc/X11/xorg.conf >> /var/tmp/inst-adJ.bitacora 2> /dev/null


echo "* Configurar scripts de cuenta inicial"  >> /var/tmp/inst-adJ.bitacora;
grep "PKG_PATH" /home/$uadJ/.profile > /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.profile <<EOF
export PKG_PATH=ftp://ftp.pasosdeJesus.org/pub/OpenBSD/$VER/packages/$ARQ/
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
export HISTFILE=$HOME/.pdksh_history
export LANG=es_CO.UTF-8
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
	ed /home/$uadJ/.profile >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\(PKG_PATH=.*\)[0-9][.][0-9]/\1$ACVER/g
w
q
EOF
	echo "   Actualizando versión en PKG_PATH..." >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar LANG en script de inicio de cuenta $uadJ" >> /var/tmp/inst-adJ.bitacora;
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

if (test -f /$RUTAIMG/post.img) then {
	echo "Existe imagen para datos encriptados de PostgreSQL /$RUTAIMG/post.img. " >> /var/tmp/inst-adJ.bitacora
	echo "Suponiendo que la base PostgreSQL tendrá datos encriptados allí" >> /var/tmp/inst-adJ.bitacora
	postencripta="s";
}
else {
	postecnripta="n";
	dialog --title 'Cifrado de datos de PostgreSQL' --yesno '\n¿Preparar imagenes cifradas para los datos de PostgreSQL?' 15 60 
	if (test "$?" = "0") then {
		postencripta="s";
	} fi;
} fi;


if (test "$postencripta" = "s") then {
	echo "* Crear imagen encriptada para base de ${TAM}Kbytes (se espeicifica otra con var. TAM) en directorio $RUTAIMG (se especifica otra con var RUTAIMG)"  >> /var/tmp/inst-adJ.bitacora
	clear;
	if (test ! -f /$RUTAIMG/post.img ) then {
		dd of=/$RUTAIMG/post.img bs=1024 seek=$TAM count=0
		vnconfig -u vnd0
		vnconfig -ckv vnd0 /$RUTAIMG/post.img
		newfs /dev/rvnd0c
		vnconfig -u vnd0
	} else {
		echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
	} fi;

	echo "* Crear imagen encriptada para respaldo de ${TAM}Kbytes (se espeicifica otra con var. TAM) en directorio $RUTAIMG (se especifica otra con var RUTAIMG)"  >> /var/tmp/inst-adJ.bitacora
	if (test ! -f /$RUTAIMG/resbase.img -a ! -f /$RUTAIMG/bakbase.img) then {
		dd of=/$RUTAIMG/resbase.img bs=1024 seek=$TAM count=0
		vnconfig -u vnd0
		vnconfig -ckv vnd0 /$RUTAIMG/resbase.img
		newfs /dev/rvnd0c
		vnconfig -u vnd0
	} else {
		echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
	} fi;

} fi; #postencripta

echo "* Preparando espacio para respaldos de bases de datos" >> /var/tmp/inst-adJ.bitacora;
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
		echo "* Cambiando svnd por vnd en $i (copia en $i-pre50)" >> /var/tmp/inst-adJ.bitacora;
		cp $i $i-pre50
		sed -e "s/svnd/vnd/g" $i-pre50 > $i;
	} fi;
done

clear;


sh /etc/rc.local >> /var/tmp/inst-adJ.bitacora 2>&1; # En caso de que falte montar bien

if (test "$postencripta" = "s") then {
	echo "* Montar imagenes encriptadas durante arranque" >> /var/tmp/inst-adJ.bitacora;
	activarcs montaencres
	activarcs montaencpos

} fi; #postencripta

# Nuevo usuario PostgreSQL
if (ltf $ACVER "4.1") then {
	uspos='_postgresql';
}
else {
	uspos='postgres';
} fi;

acuspos="-U$uspos"

# Codificacion por defecto en versiones hasta 5.0
dbenc="LATIN1";

echo "* De requerirlo sacar respaldo de datos" >> /var/tmp/inst-adJ.bitacora
pgrep post > /dev/null 2>&1
if (test "$?" = "0") then {
	echo -n "psql -h /var/www/tmp $acuspos -c \"select usename from pg_user where usename='postgres';\"" > /tmp/cu.sh
       	su - _postgresql /tmp/cu.sh
	if (test "$?" != "0") then {
		us='_postgresql';
		acus="-U$uspos";
	} fi;

	nb=1;
	while (test -f /var/www/resbase/pga-$nb.sql) do
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
			echo "psql -h/var/www/tmp $acuspos -c 'SHOW SERVER_ENCODING' > /tmp/penc.txt" > /tmp/cu.sh
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora;
			if (test -f /tmp/penc.txt -a ! -z /tmp/penc.txt) then {
				dbenc=`grep -v "(1 row)" /tmp/penc.txt | grep -v "server_encoding" | grep -v "[-]-----" | grep -v "^ *$" | sed -e "s/  *//g"`
			} fi;
			echo -n "pg_dumpall $acuspos --inserts --column-inserts --host=/var/www/tmp > /var/www/resbase/pga-conc.sql" > /tmp/cu.sh
			chmod +x /tmp/cu.sh
			cat /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora
			su - _postgresql /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora;
			grep "CREATE DATABASE" /var/www/resbase/pga-conc.sql | grep -v "ENCODING" > /tmp/cb.sed
			sed -e "s/\(.*\);$/s\/\1;\/\1 ENCODING='$dbenc';\/g/g" /tmp/cb.sed  > /tmp/cb2.sed
			cat /tmp/cb2.sed >> /var/tmp/inst-adJ.bitacora
			grep -v "ALTER ROLE $uspos" /var/www/resbase/pga-conc.sql | sed -f /tmp/cb2.sed > /var/www/resbase/pga-$nb.sql
		} else {
			echo "PostgreSQL no está corriendo, no fue posible sacar copia" >> /var/tmp/inst-adJ.bitacora;
		} fi;
		if (test ! -s /var/www/resbase/pga-$nb.sql) then {
			echo "* No fue posible sacar copia, por favor saquela manualmente en un archivo de nombre /var/www/resbase/pga-$nb.sql o asegurarse de sacarlo con pg_dumpall o en último caso sacando una copia del directorio /var/postgresql/data" | tee -a /var/tmp/inst-adJ.bitacora;
			echo "* Vuelva a este script con 'exit'" 
			sh
		} fi;
	} fi;
} else {
	if (test -d "/var/postgresql") then {
		dialog --title 'PostgreSQL no opera' --yesno "\\nAunque PostgreSQL no esta operando en el disco parece haber datos para ese motor.  Puede detener este archivo de comandos para verificar.\\n   ¿Continuar?\\n" 15 60
		if (test "$?" != "0") then {
			clear;
        		echo "Vuelva a ejecutar este script cuando termine de verificar" 
			exit 1;
		} fi;
	} fi;
} fi;

echo "* Deteniendo PostgreSQL" >> /var/tmp/inst-adJ.bitacora;
pgrep post > /dev/null 2>&1
if (test "$?" = "0") then {
	su -l _postgresql -c "/usr/local/bin/pg_ctl stop -m fast -D /var/postgresql/data" >> /var/tmp/inst-adJ.bitacora
	rm -f /var/postgresql/data/postmaster.pid
} fi;

f=`ls /var/db/pkg/postgresql-server* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar PostgreSQL' --yesno "\\nDesea eliminar la actual versión de PostgreSQL y los datos asociados para actualizarla\\n" 15 60
	if (test "$?" = "0") then {
		echo "s" >> /var/tmp/inst-adJ.bitacora
		pkg_delete -I -D dependencies postgresql-server >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies postgresql-client >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs-postgresql-client >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs1-postgresql-client >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies .libs-postgresql-server >> /var/tmp/inst-adJ.bitacora 2>&1
		d=`date +%Y%M%d`
		nd="data-$o-$d"
		while (test -f "${nd}.tar.gz" ) ; do
			nd="${nd}y";
		done;
		tar cvfz /var/postgresql/${nd}.tar.gz /var/postgresql/data >> /var/tmp/inst-adJ.bitacora 2>&1
		rm -rf /var/postgresql/data
	} fi;
} fi;

echo "* Desmontando particiones encriptadas" >> /var/tmp/inst-adJ.bitacora;
umount -f /var/bakbase 2>/dev/null >> /var/tmp/inst-adJ.bitacora;
umount -f /var/www/bakbase 2>/dev/null >> /var/tmp/inst-adJ.bitacora;
umount -f /var/www/resbase 2>/dev/null >> /var/tmp/inst-adJ.bitacora;
umount -f /var/postgresql 2>/dev/null >> /var/tmp/inst-adJ.bitacora;

echo "* Renombrando de bakbase a resbase" >> /var/tmp/inst-adJ.bitacora;
if (test ! -f /var/resbase.img -a -f /var/bakbase.img) then {
	mv /var/bakbase.img /var/resbase.img;
}
else {
	echo "   Saltando" >> /var/tmp/inst-adJ.bitacora;
} fi;


if (test "$postencripta" = "s") then {
	echo "* Volviendo a montar imagenes encriptadas" >> /var/tmp/inst-adJ.bitacora;
	clear;
	/etc/rc.d/montaencres check
	if (test "$?" != "0") then {
		echo "No está montada imagen encriptada para respaldo" >> /var/tmp/inst-adJ.bitacora;
		/etc/rc.d/montaencres start
	} fi;
	/etc/rc.d/montaencpos check
	if (test "$?" != "0") then {
		echo "No está montada imagen encriptada para PostgreSQL" >> /var/tmp/inst-adJ.bitacora;
		/etc/rc.d/montaencpos start
	} fi;
} fi; 

echo "* Poniendo permisos de /var/www/resbase" >> /var/tmp/inst-adJ.bitacora;
chown $uadJ:$uadJ /var/www/resbase

insacp apg

echo "* Instalar PostgreSQL"  >> /var/tmp/inst-adJ.bitacora
f=`ls /var/db/pkg/postgresql-server* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	p=`ls $PKG_PATH/libxml-* $PKG_PATH/libiconv-* $PKG_PATH/postgresql-client-* $PKG_PATH/postgresql-server*`
	pkg_add -r -D update -D updatedepends $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	echo -n "La clave del administrador de 'postgres' quedará en /var/postresql/.pgpass " >> /var/tmp/inst-adJ.bitacora;
	clpg=`apg | head -n 1`
	mkdir -p /var/postgresql/data
	echo "*:*:*:$uspos:$clpg" > /var/postgresql/.pgpass;
	chown -R _postgresql:_postgresql /var/postgresql/
	chmod 0600 /var/postgresql/.pgpass;
	if (test ! -f /var/postgresql/data/postgresql.conf) then {
		echo "$clpg" > /tmp/clave.txt
		chown _postgresql:_postgresql /tmp/clave.txt
		echo ""
		echo "* Activando claves md5"  >> /var/tmp/inst-adJ.bitacora
		echo initdb --encoding=UTF8 -U $uspos --auth=md5 --pwfile=/tmp/clave.txt -D/var/postgresql/data > /tmp/cu.sh
#		echo initdb --auth=trust --pwfile=/tmp/clave.txt -D/var/postgresql/data > /tmp/cu.sh
		chmod +x /tmp/cu.sh
		cat /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora
		echo "Preparado PostgreSQL" >> /var/tmp/inst-adJ.bitacora
		su - _postgresql /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora;
		echo "---" >> /var/tmp/inst-adJ.bitacora;
	} fi;
	ed /var/postgresql/data/postgresql.conf >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/#unix_socket_directory = .*/unix_socket_directory = '\/var\/www\/tmp'/g
,s/#listen_addresses = .*/listen_addresses = '127.0.0.1'/g
w
q
EOF
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;


echo "* Configurando para que inicie PostgreSQL en cada arranque y cierre al apagar" >> /var/tmp/inst-adJ.bitacora;

activarcs postgresql

grep "kern.seminfo.semmni" /etc/sysctl.conf > /dev/null 2> /dev/null
if (test "$?" != "0") then {
	cat >> /etc/sysctl.conf <<EOF
kern.seminfo.semmni=256
kern.seminfo.semmns=2048
kern.shminfo.shmmax=50331648
EOF
	sysctl -w kern.seminfo.semmni=256 > /dev/null
	sysctl -w kern.seminfo.semmns=2048 >/dev/null
	sysctl -w kern.shminfo.shmmax=50331648 > /dev/null
} fi;

cat /etc/rc.local >> /var/tmp/inst-adJ.bitacora
cat /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora
cat /etc/sysctl.conf >> /var/tmp/inst-adJ.bitacora

echo "* Iniciar PostgreSQL"  >> /var/tmp/inst-adJ.bitacora
. /etc/rc.conf >> /var/tmp/inst-adJ.bitacora
. /etc/rc.local >> /var/tmp/inst-adJ.bitacora
echo
sleep 1
pgrep post > /dev/null 2>&1
if (test "$?" != "0") then {
	dialog --title 'Revisar PostgreSQL' --msgbox '\nComando falló, esperar un momento o revisar o asegurar que corre postgresql (con "pgrep post") y regresar con "exit"' 15 60
	sh
} fi;

pb=`ls -t /var/www/resbase/pga*sql 2>/dev/null | head -n 1`;
echo "pb=$pb" >> /var/tmp/inst-adJ.bitacora;
if (test -f "$pb") then {
	echo -n " (s/n): " >> /var/tmp/inst-adJ.bitacora;
	dialog --title 'Restaurar' --yesno "\\nRestaurar la copia de respaldo $pb\\n" 15 60
	if (test "$?" = "0") then {
		echo "s" >> /var/tmp/inst-adJ.bitacora
        	echo "psql -U$uspos -h /var/www/tmp -f $pb template1" > /tmp/cu.sh
        	chmod +x /tmp/cu.sh
        	su - _postgresql /tmp/cu.sh >> /var/tmp/inst-adJ.bitacora;
	} fi;
} fi;


insacp libidn
insacp curl 
insacp libidn

echo "* PHP" >> /var/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "$p" != "") then {
	dialog --title 'Eliminar PHP' --yesno "\\nPaquete PHP ya instalado. ¿Eliminar para instalar el de esta versión de adJ?" 15 60
	if (test "$?" = "0") then {
		rm -f /var/www/conf/modules/php5.conf 
		pkg_delete -I -D dependencies php >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies php-2. >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies php5-core >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies partial-php5-core >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies partial-php5-pear >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies partial-php >> /var/tmp/inst-adJ.bitacora 2>&1
	} fi;
} fi;

echo "* Configurar Apache" >> /var/tmp/inst-adJ.bitacora ;
if (test ! -f /etc/ssl/server.crt) then {
	echo "* Configurando SSL en Apache" >> /var/tmp/inst-adJ.bitacora;
	openssl genrsa -out /etc/ssl/private/server.key 1024
	openssl req -new -key /etc/ssl/private/server.key \
       		-out /etc/ssl/private/server.csr
	openssl x509 -req -days 3650 -in /etc/ssl/private/server.csr \
      		-signkey /etc/ssl/private/server.key -out /etc/ssl/server.crt
} fi;

grep "httpd_flags.*-DSSL" /etc/rc.conf.local > /dev/null 2>/dev/null
if (test "$?" != "0") then {
	echo "* Configurando opciones para Apache en archivo de arranque" >> /var/tmp/inst-adJ.bitacora;
	echo httpd_flags="-DSSL"  >> /etc/rc.conf.local
} fi;

grep "#ServerName" /var/www/conf/httpd.conf > /dev/null 2> /dev/null
if (test "$?" = "0") then  {
	echo "* Estableciendo nombre del servidor en configuración de Apache" >> /var/tmp/inst-adJ.bitacora;
	cp /var/www/conf/httpd.conf /var/www/conf/httpd.conf-sinServerName >> /var/tmp/inst-adJ.bitacora 2>&1;
	sn=`hostname`;
	sed -e "s/#ServerName.*/ServerName \"$sn\"/g" /var/www/conf/httpd.conf-sinServerName > /var/www/conf/httpd.conf
} fi;



pgrep httpd > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "* Deteniendo apache"  >> /var/tmp/inst-adJ.bitacora 2>&1
	/etc/rc.d/httpd stop >> /var/tmp/inst-adJ.bitacora 2>&1
} fi;

echo "* Instalar PHP" >> /var/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "$p" = "") then {
	insacp libltdl
	insacp libgcrypt
	p=`ls $PKG_PATH/png*` 
	pkg_add -D libdepends -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1
	p=`ls $PKG_PATH/libxslt* $PKG_PATH/gettext* $PKG_PATH/libxml* $PKG_PATH/png* $PKG_PATH/jpeg* $PKG_PATH/t1lib* $PKG_PATH/libiconv* $PKG_PATH/php*` 
	echo $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	pkg_add -D libdepends -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1
	rm -f /var/www/conf/modules/php.conf /var/www/conf/php.ini /etc/php.ini
	ln -s /var/www/conf/modules.sample/php-5.3.conf \
		/var/www/conf/modules/php.conf
	rm -f /etc/php-5.3/{gd.ini,mcrypt.ini,pgsql.ini,pdo_pgsql.ini,sqlite.ini}
	ln -fs /etc/php-5.3.sample/gd.ini \
        	/etc/php-5.3/gd.ini
	ln -fs /etc/php-5.3.sample/mcrypt.ini \
		/etc/php-5.3/mcrypt.ini
	ln -fs /etc/php-5.3.sample/pgsql.ini \
        	/etc/php-5.3/pgsql.ini
	ln -fs /etc/php-5.3.sample/pdo_pgsql.ini \
        	/etc/php-5.3/pdo_pgsql.ini
	ln -fs /etc/php-5.3.sample/sqlite.ini \
		/etc/php-5.3/sqlite.ini

	chmod +w /var/www/conf/httpd.conf
	ed /var/www/conf/httpd.conf >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\#AddType application\/x-httpd-php .php/AddType application\/x-httpd-php .php/g
,s/DirectoryIndex index.html.*/DirectoryIndex index.html index.php/g
,s/UseCanonicalName *On/UseCanonicalName Off/g
w
q
EOF
# Antes ,s/session.auto_start = 0/session.auto_start = 1/g
# Pero no es indispensable y si entra en conflicto con horde 3.1.4
	ed /etc/php-5.3.ini >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/max_execution_time = 30/max_execution_time = 900/g
w
,s/max_input_time = 60/max_input_time = 900/g
w
,s/allow_url_fopen = Off/allow_url_fopen = On/g
w
,s/;date.timezone =.*/date.timezone = America\/Bogota/g
w
,s/memory_limit = 128M/memory_limit = 256M/g
w
q
EOF
	chmod -w /var/www/conf/httpd.conf
	pkg_add -D update -D updatedepends -r $PKG_PATH/php5-pgsql*.tgz >> /var/tmp/inst-adJ.bitacora 2>&1

} else {
	echo "   Saltando..."  >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Corriendo Apache" >> /var/tmp/inst-adJ.bitacora
/etc/rc.d/httpd start >> /var/tmp/inst-adJ.bitacora 2>&1
sleep 1

pgrep httpd > /dev/null 2>&1
if (test "$?" != "0") then {
	dialog --title 'Fallo httpd' --msgbox '\nFalló httpd, revisar, asegurar que funciona y regresar con "exit"' 15 60
	sh
} fi;
cat /var/www/conf/httpd.conf >> /var/tmp/inst-adJ.bitacora 


apdocroot=`awk '
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

echo "apdocroot=$apdocroot" >>  /var/tmp/inst-adJ.bitacora;

echo "* Probando PHP" >> /var/tmp/inst-adJ.bitacora;
p=`ls /var/db/pkg | grep "^php"`
if (test "$p" != "") then {
	cat > $apdocroot/phpinfo-adJ.php <<EOF
<?php
	phpinfo();
?>
EOF
	sed -e "s/#FORCE_SSL_PROMPT.*/FORCE_SSL_PROMPT:yes/g" /etc/lynx.cfg > /tmp/lynx.cfg
	curl -k "https://127.0.0.1/phpinfo-adJ.php" > /tmp/rescurl.html 2> /dev/null
	grep "PHP" /tmp/rescurl.html > /dev/null 2>&1
	if (test "$?" != "0") then {
		dialog --title 'Fallo PHP' --msgbox '\nPHP parece no estar corriendo. Favor revisar y volver a este script con "exit"' 15 60
		sh
	} fi;

rm -f $apdocroot/phpinfo-adJ.php
rm -f $apdocroot/phpinfo.php
} else {
	echo "* Saltando"; >> /var/tmp/inst-adJ.sh
} fi;

inspear="s";
if (test -f "/var/www/pear/lib/DB/DataObject/FormBuilder.php") then {
	dialog --title 'Actualizar PEAR' --yesno "\\nLibrerías de pear ya instaladas. ¿Actualizarlas?" 15 60
	if (test "$?" != "0") then {
		inspear="n";
	} fi;
} fi;

function pearfun {
if (test "$inspear" = "s") then {
	echo "* Actualizando paquetes de pear"  >> /var/tmp/inst-adJ.bitacora;
	echo "* Eliminando paquetes y librerías" >> /var/tmp/inst-adJ.bitacora;
	p=`ls /var/db/pkg/ | grep "pear-"`;
	pkg_delete -I $p >> /var/tmp/inst-adJ.bitacora 2>&1
	p=`ls /var/db/pkg/ | grep "pear-"`;
	pkg_delete -I $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	rm -rf /var/www/pear
	echo "Antes de pkg_add" >> /var/tmp/inst-adJ.bitacora
	p=`ls $PKG_PATH/pear-*`;
	pkg_add -D update -D installed -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1
	echo "Antes de pkg_delete" >> /var/tmp/inst-adJ.bitacora
	ls -l /var/www/pear/lib/DB/ >> /var/tmp/inst-adJ.bitacora
	cd /var/db/pkg
	pkg_delete -I partial-pear-*  >> /var/tmp/inst-adJ.bitacora 2>&1;
} fi;

}

pearfun

insacp ispell ispell-sp
ispell-config 3 >> /var/tmp/inst-adJ.bitacora


echo "* Configurar sudo" >> /var/tmp/inst-adJ.bitacora;
grep "^%wheel.*ALL=(ALL).*NOPASSWD:.*ALL" /etc/sudoers > /dev/null
if (test "$?" != "0") then {
	chmod +w /etc/sudoers
	ed /etc/sudoers >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\# \%wheel.*ALL=(ALL).*NOPASSWD.*/%wheel  ALL=(ALL) NOPASSWD: SETENV: ALL/g
w
q
EOF
	chmod -w /etc/sudoers
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Configurar escritorio de cuenta inicial" >> /var/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/fluxbox* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar Fluxbox' --yesno "\\nfluxbox instalado. ¿Eliminarlo para instalar uno más nuevo?" 15 60
	if (test "$?" = "0") then {
		pkg_delete -I -D dependencies fluxbox >> /var/tmp/inst-adJ.bitacora 2>&1 
		pkg_delete -I -D dependencies partial-fluxbox >> /var/tmp/inst-adJ.bitacora 2>&1
	} fi;
} fi;

chown -R $uadJ:$uadJ /mnt/ 2> /dev/null

f=`ls /var/db/pkg/fluxbox* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	echo "* Instalando escritorio fluxbox" >> /var/tmp/inst-adJ.bitacora;
	p=`ls $PKG_PATH/tiff-*`
        pkg_add -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	p=`ls $PKG_PATH/jpeg-* $PKG_PATH/libid3tag-* $PKG_PATH/png-* $PKG_PATH/bzip2-* $PKG_PATH/libungif-* $PKG_PATH/imlib2-* $PKG_PATH/libltdl-* $PKG_PATH/fluxbox-* $PKG_PATH/fluxter-* $PKG_PATH/fbdesk-*`
        pkg_add -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1;
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

if (test ! -f /home/$uadJ/.fluxbox/menu) then {
	mkdir -p /home/$uadJ/.fluxbox
	cat > /home/$uadJ/.fluxbox/menu <<EOF

[begin] (Fluxbox)
	[exec] (xfe - Archivos) {PATH=\$PATH:/usr/sbin:/usr/local/sbin:/sbin LANG=es LC_ALL=es /usr/local/bin/xfe}
	[exec] (xterm) {xterm -en utf8 -e /bin/ksh -l}
	[exec] (mozilla-firefox) {ulimit -d 200000 && /usr/local/bin/firefox -UILocale es-AR}
	[exec] (midori) {LANG=es_CO.UTF-8 /usr/local/bin/midori}
	[exec] (chrome) {LANG=es_CO.UTF-8 /usr/local/bin/chrome}
[submenu] (Espiritualidad)
	[exec] (xiphos) {LANG=es_CO.UTF-8 /usr/local/bin/xiphos}
	[exec] (Evangelios de dominio publico) {/usr/local/bin/firefox /usr/local/share/doc/evangelios_dp/index.html}
[end]
[submenu] (Dispositivos)
	[exec] (Apagar) {sudo /sbin/halt -p}
	[exec] (Iniciar servicios faltantes) {xterm -en utf8 -e "/usr/bin/sudo /bin/sh /etc/rc.local espera"}
	[exec] (Montar CD) {/sbin/mount /mnt/cdrom ; LANG=es xfe /mnt/cdrom/ }
	[exec] (Desmontar CD) {/sbin/umount -f /mnt/cdrom}
	[exec] (Montar USB) {/sbin/mount /mnt/usb ; LANG=es xfe /mnt/usb/}
	[exec] (Desmontar USB) {/sbin/umount -f /mnt/usb}
	[exec] (Montar USBC) {/sbin/mount /mnt/usbc ; LANG=es xfe /mnt/usbc/}
	[exec] (Desmontar USBC) {/sbin/umount -f /mnt/usbc}
	[exec] (Montar Floppy) {/sbin/mount /mnt/floppy ; LANG=es xfe /mnt/floppy}
	[exec] (Desmontar Floppy) {/sbin/umount -f /mnt/floppy}
	[exec] (Configurar Impresora con CUPS) {echo y | sudo cups-enable; sudo chmod a+rw /dev/ulpt* /dev/lpt*; /usr/local/bin/firefox -UILocale es-AR http://127.0.0.1:631}
	[submenu] (Red)
                [exec] (Examinar red) {xterm -en utf8 -e '/sbin/ifconfig; echo -n "\n[RETORNO] para examinar enrutamiento (podrá salir con q)"; read; /sbin/route -n show | less'}
                [exec] (Examinar configuracion cortafuegos) {xterm  -en utf8 -e 'sudo /sbin/pfctl -s all | less '}
                [exec] (Configurar interfaces de red) {xterm -en utf8 -e 'li=\`/sbin/ifconfig | grep "^[a-z]*[0-9]:" | sed -e "s/:.*//g" | grep -v "lo0" | grep -v "enc0" | grep -v "pflog0" | grep -v "tun[0-9]"\`;  echo "Por configurar \$li"; for i in \$li; do echo "Configurando \$i"; /sbin/ifconfig \$i; echo -n "\n[RETORNO] para editar /etc/hostname.\$i"; read;  sudo touch /etc/hostname.\$i; sudo xfw /etc/hostname.\$i; done'}
                [exec] (Configurar puerta de enlace) {sudo touch /etc/mygate; sudo xfw /etc/mygate}
                [exec] (Configurar cortafuegos) {sudo xfw /etc/pf.conf}
                [exec] (Reiniciar red) {xterm -en utf8 -e '/usr/bin/sudo PATH=/sbin:/usr/sbin:/bin:/usr/bin/ /bin/sh /etc/netstart && sudo /sbin/pfctl -f /etc/pf.conf; echo "[RETORNO] para continuar"; read'}
                [exec] (ping a Internet) {xterm -en utf8 -e '/sbin/ping 157.253.1.13'}
        [end]
[end]
[submenu] (Oficina)
	[exec] (gnumeric) {LANG=es_CO.UTF-8 /usr/local/bin/gnumeric}
	[exec] (abiword) {LANG=es_CO.UTF-8 /usr/local/bin/abiword}
	[exec] (xpdf) {xpdf}
	[exec] (gv) {gv}
	[exec] (gimp) {LANG=es_CO.UTF-8 gimp}
	[exec] (LibreOffice) {/usr/local/bin/soffice}
[end]
[submenu] (Multimedia)
	[exec] (xcdplayer) {LANG=es_CO.UTF-8 xcdplayer}
	[exec] (xcdroast) {LANG=es_CO.UTF-8 sudo xcdroast}
	[exec] (xmix) {LANG=es_CO.UTF-8 xmix}
	[exec] (cdio cdplay) {xterm -en utf8 -e "cdio cdplay"}
[end]
[submenu] (Internet)
	[exec] (FileZilla) {LANG=es_CO.UTF-8 filezilla}
	[exec] (Pidgin) {LANG=es_CO.UTF-8 pidgin}
[end]
[submenu] (Documentos)
	[exec] (OpenBSD basico) {/usr/local/bin/firefox -UILocale es-AR /usr/local/share/doc/basico_OpenBSD/index.html}
	[exec] (OpenBSD usuario) {/usr/local/bin/firefox -UILocale es-AR /usr/local/share/doc/usuario_OpenBSD/index.html}
	[exec] (OpenBSD servidor) {/usr/local/bin/firefox -UILocale es-AR /usr/local/share/doc/servidor_OpenBSD/index.html}
[end]
[submenu] (Otros)
[exec] (vim) {LANG=es_CO.UTF-8 gvim}
[end]
[submenu] (Menú de fluxbox)
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
[exec] (Apagar) {sudo /sbin/halt -p}
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
	echo "Imagen de fondo: $imfondo" >> /var/tmp/inst-adJ.bitacora
	cp $ARCH/medios/*.jpg /home/$uadJ/.fluxbox/backgrounds/
	cp $ARCH/medios/$imfondo /home/$uadJ/.fluxbox/backgrounds/fondo.jpg
	cat > /home/$uadJ/.fluxbox/startup <<EOF
#fbsetroot -to blue -solid lightblue
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
	grep "display -backdrop"  /home/$uadJ/.fluxbox/apps > /dev/null 2>&1
	if (test "$?" != "0") then {
		cat >> /home/$uadJ/.fluxbox/apps <<EOF
	[startup] {display -backdrop -window root /home/$uadJ/.fluxbox/backgrounds/fondo.jpg}
EOF
	} fi;
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
Name=firefox
Exec=firefox
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
session.styleFile:	/usr/local/share/fluxbox/styles/MerleyKay
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

echo "* Configurar ruby-1.9" >> /var/tmp/inst-adJ.bitacora;
if (test ! -f "/usr/local/bin/ruby") then {
	insacp ruby
	ln -sf /usr/local/bin/ruby19 /usr/local/bin/ruby
	ln -sf /usr/local/bin/erb19 /usr/local/bin/erb
	ln -sf /usr/local/bin/irb19 /usr/local/bin/irb
	ln -sf /usr/local/bin/rdoc19 /usr/local/bin/rdoc
	ln -sf /usr/local/bin/ri19 /usr/local/bin/ri
	ln -sf /usr/local/bin/rake19 /usr/local/bin/rake
	ln -sf /usr/local/bin/gem19 /usr/local/bin/gem
	ln -sf /usr/local/bin/testrb19 /usr/local/bin/testrb
} fi;


echo "* Configurar tmux" >> /var/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/tmux* 2> /dev/null`;
if (test "$f" != "") then {
	pkg_delete -I tmux >> /var/tmp/inst-adJ.bitacora 2>&1
} fi;

if (test ! -f /home/$uadJ/.tmux.conf) then {
	cat > /home/$uadJ/.tmux.conf << EOF
set-option -g history-limit 20000
EOF
	chown $uadJ:$uadJ /home/$uadJ/.tmux.conf
} fi;

echo "* Configurar cups" >> /var/tmp/inst-adJ.bitacora;
insacp dbus	
insacp libusb1
insacp cups
activarcs cupsd


echo "* Instalar mozilla-firefox" >> /var/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/*firefox* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar Firefox' --yesno "\\nFirefox instalado. ¿Eliminarlo para instalar uno más nuevo?" 15 60
	if (test "$?" = "0") then {
		pkg_delete -I -D dependencies mozilla-firefox >> /var/tmp/inst-adJ.bitacora 2>&1
		pkg_delete -I -D dependencies firefox >> /var/tmp/inst-adJ.bitacora 2>&1
	} fi;
} fi;
f=`ls /var/db/pkg/firefox* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {

	insacp png
	insacp libelf
	insacp glib2
	insacp cairo
	insacp pango
	insacp gtk+2

	p=`ls $PKG_PATH/libxml-* $PKG_PATH/shared-mime-info-* $PKG_PATH/pcre-* $PKG_PATH/png-* $PKG_PATH/jpeg-* $PKG_PATH/glib2-* $PKG_PATH/tiff-* $PKG_PATH/libiconv-* $PKG_PATH/esound-* $PKG_PATH/atk-* $PKG_PATH/desktop-file-utils-* $PKG_PATH/gettext-* $PKG_PATH/libaudiofile-* $PKG_PATH/gtk+2-* $PKG_PATH/cairo-* $PKG_PATH/pango-* $PKG_PATH/nss-* $PKG_PATH/nspr-* $PKG_PATH/jasper-* $PKG_PATH/hicolor-icon-theme-* $PKG_PATH/firefox-* $PKG_PATH/firefox-i18n-es-AR*`
        pkg_add -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	grep "browser.startup.homepage.*https://localhost" /usr/local/mozilla-firefox/defaults/profile/prefs.js > /dev/null
	if (test "$?" != "0") then {
		echo 'user_pref("general.useragent.locale", "es-AR")' >> /usr/local/mozilla-firefox/defaults/profile/prefs.js;
		echo 'user_pref("browser.startup.homepage", "https://127.0.0.1/");' >> /usr/local/mozilla-firefox/defaults/profile/prefs.js;
	} fi;
	echo "Sugerencias: " >> /var/tmp/inst-adJ.bitacora;
	echo "  * Configure localización en español desde about:config general.useragent.local es-AR"
	echo "  * Como página de inicio use https://127.0.0.1/";
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;

echo "* Permisos para aplicaciones" >> /var/tmp/inst-adJ.bitacora;

if (test -d /home/$uadJ/.mozilla) then {
	sudo chown -R $uadJ:$uadJ /home/$uadJ/.mozilla
} fi;

if (test -d /home/$uadJ/.openoffice.org2) then {
	sudo chown -R $uadJ:$uadJ /home/$uadJ/.openoffice.org2
} fi;

echo "* Agregar usuario a grupo wheel" >> /var/tmp/inst-adJ.bitacora;
grep wheel /etc/group | grep $uadJ > /dev/null
if (test "$?" != "0") then {
	sudo usermod -G wheel $uadJ >> /var/tmp/inst-adJ.bitacora
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;


echo "* Instalar xfe" >> /var/tmp/inst-adJ.bitacora;
f=`ls /var/db/pkg/xfe* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	dialog --title 'Eliminar xfe' --yesno "\\nxfe instalado. ¿Eliminarlo para instalar uno más nuevo?" 15 60
	if (test "$?" = "0") then {
		pkg_delete -I -D dependencies xfe >> /var/tmp/inst-adJ.bitacora 2>&1
	} fi;
} fi;
f=`ls /var/db/pkg/xfe* 2> /dev/null > /dev/null`;
if (test "$?" != "0") then {
	p=`ls $PKG_PATH/libiconv-* $PKG_PATH/fox-* $PKG_PATH/gettext-* $PKG_PATH/xfe-*`
        pkg_add -D update -D updatedepends -r $p >> /var/tmp/inst-adJ.bitacora 2>&1;
	if (test ! -f "/home/$uadJ/.config/xfe/xferc") then {
		mkdir -p /home/$uadJ/.config/xfe/
		cat > /home/$uadJ/.config/xfe/xferc <<EOF
[OPTIONS]
panel_view=2
xpos=149
width=800
confirm_quit=1
tree_width=200
locationbar=1
auto_save_layout=1
ask_before_copy=1
status=1
height=600
tree_hidden_dir=0
confirm_delete=1
use_trash_bypass=0
toolbar=1
root_warn=0
paneltoolbar=1
single_click_fileopen=0
use_trash_can=1
ypos=99
confirm_overwrite=1
single_click_diropen=0

[FILETYPES]
kdelnk=xfw,xfv,xfw;KDE Link;config_32x32.png;config_16x16.png;;
au=play,,;Sound;sound_32x32.png;sound_16x16.png;;
py=xfw,xfv,xfw;Python Source;text_32x32.png;text_16x16.png;;
gz=xarchive, file-roller,gunzip -f,file-roller;Gziped File;gz_32x32.png;gz_16x16.png;application/x-gzip
mp3=mplayer,,;MPEG Audio;mp3_32x32.png;mp3_16x16.png;;
class=xfw,xfv,xfw;Java Binary;class_32x32.png;class_16x16.png;;
chm=xchm,xchm,xchm;Windows Help;chm_32x32.png;chm_16x16.png;;
rm=realplay,,;RealPlayer Video;video_32x32.png;video_16x16.png;;
xm=mplayer,,;Audio module;wave_32x32.png;wave_16x16.png;;
html=firefox,firefox,xfw;Hyper Text;html_32x32.png;html_16x16.png;;
smf=smath,oomath,oomath;StarMath 5.0 Document;sxm_32x32.png;sxm_16x16.png;;
tcl=xfw,xfv,xfw;Tcl Source;tcl_32x32.png;tcl_16x16.png;;
pl=xfw,xfv,xfw;Perl Source;text_32x32.png;text_16x16.png;;
pm=xfw,xfv,xfw;Perl Module;text_32x32.png;text_16x16.png;;
po=xfw,xfv,xfw;Locale File;text_32x32.png;text_16x16.png;;
mpeg=mplayer,plaympeg,;MPEG Video;video_32x32.png;video_16x16.png;;
mp4=mplayer,plaympeg,;MPEG Video;video_32x32.png;video_16x16.png;;
sh=xfw,xfv,xfw;Shell Script;shell_32x32.png;shell_16x16.png;;
exe=wine,,;Windows EXE;exe_32x32.png;exe_16x16.png;;
sdw=swriter,oowriter,oowriter;Starwriter 5.0 Document;sxw_32x32.png;sxw_16x16.png;;
ps=gv,evince,;PostScript Document;ps_32x32.png;ps_16x16.png;;
rpm=xfp,xfp,xfp;RPM Package;rpm_32x32.png;rpm_16x16.png;;
makefile.in=xfw,xfv,xfw;Configure Makefile;make_32x32.png;make_16x16.png;;
patch=xfw,xfv,xfw;Source Patch;text_32x32.png;text_16x16.png;;
news=xfw,xfv,xfw;News File;news_32x32.png;news_16x16.png;;
xfprc=xfw,xfv,xfw;Xfe Configuration;config_32x32.png;config_16x16.png;;
xfvrc=xfw,xfv,xfw;Xfe Configuration;config_32x32.png;config_16x16.png;;
xbm=xfi,display,gimp,;X Bitmap;xbm_32x32.png;xbm_16x16.png;;
jpeg=xfi,display,gimp;JPEG Image;jpeg_32x32.png;jpeg_16x16.png;;
o=,,;Object File;o_32x32.png;o_16x16.png;;
lzh=xarchive, file-roller,lha -xf,file-roller;LZH Archive;lzh_32x32.png;lzh_16x16.png;;
xcf=xfi,gimp,gimp;XCF Image;xcf_32x32.png;xcf_16x16.png;;
rar=xarchive, file-roller,rar x -o+,file-roller;RAR Archive;rar_32x32.png;rar_16x16.png;;
pas=xfw,xfv,xfw;Pascal Source;text_32x32.png;text_16x16.png;;
zip=xarchive, file-roller,unzip -o,file-roller;ZIP Archive;zip_32x32.png;zip_16x16.png;application/x-zip
makefile=xfw,xfv,xfw;Makefile;make_32x32.png;make_16x16.png;;
spec=xfw,xfv,xfw;RPM Spec;rpm_32x32.png;rpm_16x16.png;;
pyo=,,;Python Object;o_32x32.png;o_16x16.png;;
tar=xarchive, file-roller,tar -xvf,file-roller;Tar Archive;tar_32x32.png;tar_16x16.png;application/x-tar
bak=xfw,xfv,xfw;Backup File;bak_32x32.png;bak_16x16.png;;
dpatch=xfw,xfv,xfw;Debian Patch;text_32x32.png;text_16x16.png;;
dia=dia,dia,dia;Dia Drawing;dia_32x32.png;dia_16x16.png;;
djvu=djview,djview,;DJVU Document;djvu_32x32.png;djvu_16x16.png;;
a=,,;Static Library;a_32x32.png;shared_16x16.png;;
desktop=xfw,xfv,xfw;Gnome Desktop Entry;config_32x32.png;config_16x16.png;;
iso=xarchive, file-roller,file-roller,file-roller;ISO9660 Image;package_32x32.png;package_16x16.png;;
h=xfw,xfv,xfw;C Header;h_32x32.png;h_16x16.png;;
vlog=xfw,xfv,xfw;Verilog Source;vlog_32x32.png;vlog_16x16.png;;
readme=xfw,xfv,xfw;Readme File;help_32x32.png;help_16x16.png;;
tif=xfi,display,gimp;TIFF Image;tif_32x32.png;tif_16x16.png;;
ram=realplay,,;RealPlayer Video;video_32x32.png;video_16x16.png;;
ml=xfw,xfv,xfw;Caml Source;text_32x32.png;text_16x16.png;;
sxi=simpress,ooimpress,ooimpress;OpenOffice 1.0 Impress;sxi_32x32.png;sxi_16x16.png;;
cpp=xfw,xfv,xfw;C++ Source;cc_32x32.png;cc_16x16.png;;
copyright=xfw,xfv,xfw;Copyright File;info_32x32.png;info_16x16.png;;
xpm=xfi,gimp,gimp;X Pixmap;xpm_32x32.png;xpm_16x16.png;;
eps=gv,evince,;Encapsulated PostScript Document;ps_32x32.png;ps_16x16.png;;
php=firefox,firefox,xfw;PHP Source;html_32x32.png;html_16x16.png;;
m=xfw,xfv,xfw;Matlab Source;m_32x32.png;m_16x16.png;;
sxd=sdraw,oodraw,oodraw;OpenOffice 1.0 Draw;sxd_32x32.png;sxd_16x16.png;;
pps=simpress,ooimpress,ooimpress;PowerPoint Show;ppt_32x32.png;ppt_16x16.png;;
ppt=simpress,ooimpress,ooimpress;PowerPoint Presentation;ppt_32x32.png;ppt_16x16.png;;
mid=midiplay,,;MIDI File;midi_32x32.png;midi_16x16.png;;
sxm=smath,oomath,oomath;OpenOffice 1.0 Math;sxm_32x32.png;sxm_16x16.png;;
xfwrc=xfw,xfv,xfw;Xfe Configuration;config_32x32.png;config_16x16.png;;
txt=xfw,xfv,xfw;Plain Text;text_32x32.png;text_16x16.png;;
vhd=xfw,xfv,xfw;Vhdl Source;vhdl_32x32.png;vhdl_16x16.png;;
core=,,;Core Dump;core_32x32.png;core_16x16.png;;
sxw=swriter,oowriter,oowriter;OpenOffice 1.0 Text;sxw_32x32.png;sxw_16x16.png;;
jpg=xfi,display,gimp;JPEG Image;jpeg_32x32.png;jpeg_16x16.png;;
mpg=mplayer,xine,plaympeg;MPEG Video;video_32x32.png;video_16x16.png;;
wav=mplayer,,;Wave Audio;wave_32x32.png;wave_16x16.png;;
vsd=visio,visio,visio;Visio Drawing;vsd_32x32.png;vsd_16x16.png;;
log=xfw,xfv,xfw;Log File;info_32x32.png;info_16x16.png;;
doc=abiword,swriter,oowriter,oowriter;Word Document;doc_32x32.png;doc_16x16.png;;
gif=xfi,xfi,gimp;GIF Image;gif_32x32.png;gif_16x16.png;;
pot=simpress,ooimpress,ooimpress;PowerPoint Template;ppt_32x32.png;ppt_16x16.png;;
la=,,;Libtool library file;a_32x32.png;shared_16x16.png;;
vst=visio,visio,visio;Visio Template;vsd_32x32.png;vsd_16x16.png;;
mod=mplayer,,;Audio module;wave_32x32.png;wave_16x16.png;;
c=xfw,xfv,xfw;C Source;c_32x32.png;c_16x16.png;;
vss=visio,visio,visio;Visio Solution;vsd_32x32.png;vsd_16x16.png;;
svg=sodipodi,inkscape,inkscape;SVG Image;svg_32x32.png;svg_16x16.png;;
sxc=scalc,oocalc,oocalc;OpenOffice 1.0 Calc;sxc_32x32.png;sxc_16x16.png;;
java=xfw,xfv,xfw;Java Source;java_32x32.png;java_16x16.png;;
z=xarchive, file-roller,uncompress -f,file-roller;Compressed File;z_32x32.png;z_16x16.png;;
s3m=mplayer,,;Audio module;wave_32x32.png;wave_16x16.png;;
dot=swriter,oowriter,oowriter;Word Template;doc_32x32.png;doc_16x16.png;;
cc=xfw,xfv,xfw;C++ Source;cc_32x32.png;cc_16x16.png;;
install=xfw,xfv,xfw;Install File;info_32x32.png;info_16x16.png;;
bugs=xfw,xfv,xfw;Bugs File;bug_32x32.png;bug_16x16.png;;
odg=sdraw,oodraw,oodraw;OpenDocument Graphic;odg_32x32.png;odg_16x16.png;;
configure=xfw,xfv,xfw;Configure Script;make_32x32.png;make_16x16.png;;
img=,,;Image File;package_32x32.png;package_16x16.png;;
wri=swriter,oowriter,oowriter;Write Document;doc_32x32.png;doc_16x16.png;;
ini=xfw,xfv,xfw;Configuration file;config_32x32.png;config_16x16.png;;
tbz2=xarchive, file-roller,tar -jxvf,file-roller;Bziped Tar;tbz2_32x32.png;tbz2_16x16.png;application/x-tbz
configure.in=xfw,xfv,xfw;Configure Source;make_32x32.png;make_16x16.png;;
ogg=mplayer,ogg123,;Ogg Vorbis Audio;mp3_32x32.png;mp3_16x16.png;;
bz2=xarchive, file-roller,bunzip2 -f,file-roller;Bziped File;bz2_32x32.png;bz2_16x16.png;application/x-bz
png=xfi,display,gimp;PNG Image;png_32x32.png;png_16x16.png;;
dvi=xdvi,xdvi,;DVI Document;dvi_32x32.png;dvi_16x16.png;;
so=,,;Shared Library;so_32x32.png;shared_16x16.png;;
wbk=swriter,oowriter,oowriter;Word Backup Document;doc_32x32.png;doc_16x16.png;;
deb=xfp,xfp,xfp;DEB Package;deb_32x32.png;deb_16x16.png;;
makefile.am=xfw,xfv,xfw;Automake Makefile;make_32x32.png;make_16x16.png;;
tex=xfw,xfv,xfw;TeX Document;tex_32x32.png;tex_16x16.png;;
config=xfw,xfv,xfw;Configuration file;config_32x32.png;config_16x16.png;;
authors=xfw,xfv,xfw;Authors File;info_32x32.png;info_16x16.png;;
mpeg3=mplayer,,;MPEG Audio;mp3_32x32.png;mp3_16x16.png;;
diff=xfw,xfv,xfw;Diff File;text_32x32.png;text_16x16.png;;
htm=firefox,firefox,xfw;Hyper Text;html_32x32.png;html_16x16.png;;
tgz=xarchive, file-roller,tar -xzvf,file-roller;Gziped Tar;tgz_32x32.png;tgz_16x16.png;application/x-tgz
rb=xfw,xfv,xfw;Ruby Source;text_32x32.png;text_16x16.png;;
mov=mplayer,xine,plaympeg;MPEG Video;video_32x32.png;video_16x16.png;;
vhdl=xfw,xfv,xfw;Vhdl Source;vhdl_32x32.png;vhdl_16x16.png;;
csh=xfw,xfv,xfw;C-Shell Script;shell_32x32.png;shell_16x16.png;;
tiff=xfi,gimp,gimp;TIFF Image;tif_32x32.png;tif_16x16.png;;
bmp=xfi,gimp,gimp;BMP Image;bmp_32x32.png;bmp_16x16.png;;
rtf=abiword,swriter,oowriter,oowriter;RTF Document;doc_32x32.png;doc_16x16.png;;
avi=mplayer,xine,;Video;video_32x32.png;video_16x16.png;;
conf=xfw,xfv,xfw;Configuration file;config_32x32.png;config_16x16.png;;
xfirc=xfw,xfv,xfw;Xfe Configuration;config_32x32.png;config_16x16.png;;
xls=gnumeric,scalc,excel,excel;Excel Spreadsheet;xls_32x32.png;xls_16x16.png;;
gnumeric=gnumeric,scalc,excel,excel;Excel Spreadsheet;xls_32x32.png;xls_16x16.png;;
midi=midiplay,,;MIDI File;midi_32x32.png;midi_16x16.png;;
xferc=xfw,xfv,xfw;Xfe Configuration;config_32x32.png;config_16x16.png;;
copying=xfw,xfv,xfw;Copyright File;info_32x32.png;info_16x16.png;;
odf=smath,oomath,oomath;OpenDocument Formula;odf_32x32.png;odf_16x16.png;;
pls=xmms,,;XMMS Playlist;mp3_32x32.png;mp3_16x16.png;;
xlt=scalc,excel,excel;Excel Template;xls_32x32.png;xls_16x16.png;;
pdf=evince,xpdf,acroread,;PDF Document;pdf_32x32.png;pdf_16x16.png;;
changelog=xfw,xfv,xfw;Log File;info_32x32.png;info_16x16.png;;
sdc=scalc,oocalc,oocalc;StarCalc 5.0 Document;sxc_32x32.png;sxc_16x16.png;;
sda=sdraw,oodraw,oodraw;StarDraw 5.0 Document;sxd_32x32.png;sxd_16x16.png;;
ods=scalc,oocalc,oocalc;OpenDocument Spreadsheet;ods_32x32.png;ods_16x16.png;;
odp=simpress,ooimpress,ooimpress;OpenDocument Presentation;odp_32x32.png;odp_16x16.png;;
cxx=xfw,xfv,xfw;C++ Source;cc_32x32.png;cc_16x16.png;;
sdi=simpress,ooimpress,ooimpress;StarImpress 5.0 Document;sxi_32x32.png;sxi_16x16.png;;
odt=abiword,swriter,oowriter,oowriter;OpenDocument Text;odt_32x32.png;odt_16x16.png;;
abw=abiword,swriter,oowriter,oowriter;Abiword Text;odt_32x32.png;odt_16x16.png;;
zabw=abiword,swriter,oowriter,oowriter;Abiword Text;odt_32x32.png;odt_16x16.png;;

[LEFT PANEL]
type_size=100
hiddenfiles=0
liststyle=4194304
dirs_first=1
attr_size=100
user_size=50
ext_size=100
grou_size=50
modd_size=150
ignore_case=1
sort_func=ascendingCase
showthumbnails=0
name_size=200
size_size=60

[HISTORY]
open=simpress:soffice:
run=

[SETTINGS]
listforecolor=Black
forecolor=Black
iconpath=/usr/local/share/xfe/icons/xfce-theme
basecolor=#eeeeee
selbackcolor=#637792
highlightcolor=#eeeeee
wheellines=5
bordercolor=Black
listbackcolor=Gray100
backcolor=#eeeeee
tiptime=10000
selforecolor=Gray100
tippause=200

[RIGHT PANEL]
grou_size=50
type_size=100
hiddenfiles=0
dirs_first=1
attr_size=100
user_size=50
panel_width=200
ext_size=100
liststyle=4194304
panel_tree_width=200
modd_size=150
ignore_case=1
sort_func=ascendingCase
showthumbnails=0
name_size=200
size_size=60

EOF
		chown -R $uadJ:$uadJ /home/$uadJ/.config
	} fi;
} else {
	echo "   Saltando..." >> /var/tmp/inst-adJ.bitacora;
} fi;

chmod a+rxw /var/www/tmp > /dev/null 2>&1

dialog --title 'Componentes básicos instalados' --msgbox "\\nInstalación y configuración de los componentes básicos de adJ completada.\\n\\nPor instalar los demás paquetes de $ARCH/paquetes" 15 60
#, mientras tanto puede instalar SIVeL:"
#echo "1. Pase a la consola gráfica con [Ctrl]-[Alt]-[F5] o si no es gráfica iniciela desde la segunda consola [Ctrl]-[Alt]-[F2] con 'xdm'"
#echo "2. Abra mozilla-firefox (o en modo texto lynx) y use la dirección 'https://127.0.0.1/actualiza.php'"
#echo "3. Debe poder ingresar con el usuario que creó"
#echo "4. Complete actualización de SIVeL siguiendo las instrucciones"
#echo ""
#echo "Si hay inconvenientes puede examinar log de Apache en /var/www/logs/error y ayudar en el desarrollo de SIVeL suscribiendose y enviando sus mejoras a adJ-soporte@lists.sourceforge.net";

clear
echo "Eliminando parciales" >> /var/tmp/inst-adJ.bitacora 
cd /var/db/pkg
for i in partial-*; do 
	echo $i >> /var/tmp/inst-adJ.bitacora ; 
	sudo pkg_delete -I $i >> /var/tmp/inst-adJ.bitacora 2>&1 ; 
done

echo "Eliminando problemáticos" >> /var/tmp/inst-adJ.bitacora 
sudo pkg_delete -D dependencies libstdc++ >> /var/tmp/inst-adJ.bitacora  2>&1
sudo pkg_delete -D dependencies lua >> /var/tmp/inst-adJ.bitacora  2>&1

echo "Instalando algunos comunes" >> /var/tmp/inst-adJ.bitacora 
pkg_add -D updatedepends -D update -D libdepends -r $PKG_PATH/sdl*tgz $PKG_PATH/libxml*tgz $PKG_PATH/libgpg-error*tgz $PKG_PATH/libart-*.tgz  >> /var/tmp/inst-adJ.bitacora 2>&1;
pkg_add -D updatedepends -D update -D libdepends -r $PKG_PATH/gtk+2*tgz >> /var/tmp/inst-adJ.bitacora 2>&1;

echo "Instalando todos los disponibles en PKG_PATH" >> /var/tmp/inst-adJ.bitacora 
pkg_add -D update -u 
cd /var/db/pkg/
for i in $PKG_PATH/*tgz; do
	echo $i | tee -a /var/tmp/inst-adJ.bitacora
	pkg_add -D updatedepends -D update -D libdepends -r $i >> /var/tmp/inst-adJ.bitacora 2>&1;
done;

echo "Eliminando librerías innecesarias" >> /var/tmp/inst-adJ.bitacora 
cd /var/db/pkg
for i in .libs*; do 
	echo $i >> /var/tmp/inst-adJ.bitacora ; 
	sudo pkg_delete -I $i >> /var/tmp/inst-adJ.bitacora 2>&1 ; 
done

for i in $PKG_PATH/*tgz; do
	echo $i | tee -a /var/tmp/inst-adJ.bitacora
	pkg_add -D updatedepends -D update -D libdepends -r $i >> /var/tmp/inst-adJ.bitacora 2>&1
done;

pkg_add -D update -u

# Configuraciones típicas
if (test ! -f /home/$uadJ/.vimrc) then {
	cp -f /usr/local/share/vim/vim*/vimrc_example.vim ~/.vimrc
	chown $uadJ:$uadJ ~/.vimrc
} fi;

echo "* Configurar vim con UTF-8" >> /var/tmp/inst-adJ.bitacora;
grep "set  *tenc" /home/$uadJ/.vimrc> /dev/null
if (test "$?" != "0") then {
	cat >> /home/$uadJ/.vimrc <<EOF
set tenc=utf8
set enc=utf8
EOF
} fi;
	
# Diccionario español de LibreOffice
# http://es.openoffice.org/programa/diccionario.html
if (test -f $ARCH/util/es_CO.oxt -a -f /usr/local/lib/libreoffice/program/unopkg) then {
	sudo /usr/local/lib/libreoffice/program/unopkg add --shared $ARCH/util/es_CO.oxt
} fi;

echo "* Configurar pidgin con SILC y canales en www.nocheyniebla.org" >> /var/tmp/inst-adJ.bitacora;
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

echo "* Volviendo a cambiar en por service en etc" >> /var/tmp/inst-adJ.bitacora;
cd /etc && /usr/local/adJ/service-etc.sh >> /var/tmp/inst-adJ.bitacora 2>&1
dialog --title 'Componentes básicos instalados' --msgbox "\\nFELICITACIONES!  La instalación/actualización de la distribución Aprendiendo de Jesús $VER se completó satisfactoriamente\\n\\n Para instalar SIVeL ejecute sudo /usr/local/adJ/inst-sivel.sh" 15 60

