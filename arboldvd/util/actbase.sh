#!/bin/sh
# Actualiza sistema base a partir de instalador de adJ
# Basada en instrucciones del FAQ de OpenBSD
# Dominio público de acuerdo a legislación colombiana. http://www.pasosdejesus.org/dominio_publico_colombia.html. 
# 2011. vtamara@pasosdeJesus.org

VCOR=`uname -r`
u=`whoami`
if (test "$u" != "root") then {
	echo "Ejecutar como usuario root"
	exit 1;
} fi;
VCORSP=`echo $VCOR | sed -e "s/\.//g"`
VSP=70

if (test -f "ver.sh") then {
	. ./ver.sh
} else {
	V=$1
	if (test "$V" = "") then {
		echo "Primer parámetro debería ser versión, e.g"
		echo "actbase.sh 7.1"
		exit 1;
	} fi;
	VP=`echo $V | sed -e "s/[.]//g"`
} fi;

if (test "$V" = "5.1") then {
	echo "Eliminando /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl";
	rm -rf /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl;
} fi;

ARQ=amd64
rutak=$V$VESP-$ARQ
if (test ! -f $rutak/bsd -o ! -f $rutak/base$VSP.tgz) then {
	echo "No se encontró kernel e instaladores en $rutak";
	exit 1;
} fi;
if (test "$RUTAKERNELREESPECIAL" != "") then {
        rutak="$RUTAKERNELREESPECIAL";
        echo "Usando kernel re-especial";
} fi;
mp=`uname -a | sed -e "s/.*\.MP\#.*/.mp/g"`
if (test "$mp" != ".mp") then {
	mp="";
} fi;

nk=${rutak}/bsd${mp}
echo "Antes de continuar, recomendamos que ejecute util/preact-adJ.sh"
echo "Presione [ENTER] para preparar primer arranque tras actualizacion"
read
pgrep xdm > /dev/null  2>&1
if (test "$?" = "0" -a ! -f /etc/X11/xorg.conf) then {
	touch /etc/X11/xorg-automatico
} fi;
echo "(cd /dev; ./MAKEDEV all)" >/etc/rc.firsttime
echo "fw_update" >> /etc/rc.firsttime
if (test "$VCORSP" -lt "55" ) then {
	eusr=`df -kP /usr | awk '{ print $2; }' | tail -n 1`
	if (test "$eusr" -lt "200000") then {
		echo "Debe haber al menos 200M disponibles en /usr";
		exit 1;
	} fi;
	if (test "${HOME}" != "/root") then {
		echo "Para actualizar desde 5.4 o anteriores debe ejecutar como root y no con sudo";
		exit 1;
	} fi;
	dd=`sysctl hw.disknames | sed -e "s/.*=sd0.*/sd0/g;s/.*wd0.*/wd0/g;s/.*sd0.*/sd0/g"`
	echo "Esta operacion para actualizar desde 5.4 o anteriores no es recomendable, pero si continua:"
	echo "1. Saque copias de respaldo en formato portable de bases de datos (bd, mysql, ldapd, OpenLDAP, rrdtool, etc)";
	echo "2. Elimine todos los paquetes y binarios que no son sistema base";
	echo "Si continua este script:"
	echo "1. Intentara detener todos los servicios"
	echo "2. Deshabilitar servicios de /etc/rc.conf.local --habilitelos tras la instalacion"
	echo "3. Se instalaran nuevos bloques de arranque en disco $dd"
	echo "[RETORNO] para continuar, [CTRL]+[C] para cancelar";
	read
	echo "/usr/sbin/pwd_mkdb -d /etc /etc/master.passwd" >>/etc/rc.firsttime
	echo "/usr/bin/cap_mkdb /etc/login.conf" >>/etc/rc.firsttime
	echo "cp /dev/null /var/log/lastlog" >>/etc/rc.firsttime
	echo "cp /dev/null /var/log/wtmp" >>/etc/rc.firsttime    
	echo "installboot -v sd0" >>/etc/rc.firsttime    
	echo "USER=$USER";
	. /etc/rc.conf.local
	for _r in ${pkg_scripts}; do
		echo -n " ${_r}";
		if (test -x /etc/rc.d/${_r}) then {
			/etc/rc.d/${_r} stop
		} fi;
	done
	ed /etc/rc.conf.local <<EOF
,s/^pkg_scripts/#pkg_scripts/g
w
q
EOF
	(cd /usr/mdec; cp boot /boot; ./installboot -v /boot ./biosboot $dd)
} fi;
ARCH=`pwd`
ARCH="$ARCH/$V$VESP-$ARQ/"
#echo "TERM=vt220 ARCH=$ARCH /inst-adJ.sh" >>/etc/rc.firsttime    
echo "Presione [ENTER] para instalar kernel $nk"
read
rm /obsd ; ln /bsd /obsd 
cp $nk /nbsd 
mv /nbsd /bsd
# Habilita KARL
sha256 -h /var/db/kernel.SHA256 /bsd
cp $rutak/bsd /bsd.sp
cp $rutak/bsd.rd $rutak/bsd.mp /

echo -n "[ENTER] para continuar con juegos de instalacion: "
read
cp /sbin/reboot /sbin/oreboot
for i in xserv xfont xshare xbase game comp man site base; do
	echo $i;
	tar -C / -xzphf $V$VESP-$ARQ/$i$VSP.tgz
done
echo "Tras el reinicio recuerde ejecutar:"
echo "  cd /dev && ./MAKEDEV all"
echo "[ENTER] para ejecutar /sbin/oreboot"
read
/sbin/oreboot
