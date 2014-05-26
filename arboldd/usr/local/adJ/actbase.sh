#!/bin/sh
# Actualiza sistema base a partir de instalador de adJ
# Basada en instrucciones del FAQ de OpenBSD
# Dominio público de acuerdo a legislación colombiana. http://www.pasosdejesus.org/dominio_publico_colombia.html. 
# 2011. vtamara@pasosdeJesus.org

if (test "$USER" != "root") then {
	echo "Ejecutar como usuario root"
	exit 1;
} fi;

if (test -f "ver.sh") then {
	. ./ver.sh
} else {
	V=$1
	if (test "$V" = "") then {
		echo "Primer parámetro debería ser versión, e.g"
		echo "actbase.sh 5.6"
		exit 1;
	} fi;
	VP=`echo $V | sed -e "s/[.]//g"`
} fi;

if (test "$V" = "5.1") then {
	echo "Eliminando /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl";
	rm -rf /usr/X11R6/share/X11/xkb/symbols/srvr_ctrl;
} fi;

mp=`uname -a | sed -e "s/.*\.MP.*/.mp/g"`
if (test "$mp" != ".mp") then {
	mp="";
} fi;
ARQ=amd64
rutak=$V$VESP-$ARQ
if (test ! -f $rutak/bsd -o ! -f $rutak/base$VP.tgz) then {
	echo "No se encontró kernel e instaladores en $rutak";
	exit 1;
} fi;
if (test "$RUTAKERNELREESPECIAL" != "") then {
        rutak="$RUTAKERNELREESPECIAL";
        echo "Usando kernel re-especial";
} fi;

nk=${rutak}/bsd${mp}
echo "Antes de continuar, recomendamos que ejecute util/preact-adJ.sh"
echo "Presione [ENTER] para instalar kernel $nk"
read
rm /obsd ; ln /bsd /obsd 
cp $nk /nbsd 
mv /nbsd /bsd
cp $rutak/bsd /bsd.sp
cp $rutak/bsd.rd $rutak/bsd.mp /

echo -n "[ENTER] para continuar con juegos de instalacion: "
read
sudo cp /sbin/reboot /sbin/oreboot
for i in xserv xfont xshare xbase game comp man site base; do
	echo $i;
	sudo tar -C / -xzphf $V$VESP-$ARQ/$i$VP.tgz
done
echo "Tras el reinicio recuerde ejecutar:"
echo "  cd /dev && ./MAKEDEV all"
echo "[ENTER] para ejecutar /sbin/oreboot"
read
/sbin/oreboot
