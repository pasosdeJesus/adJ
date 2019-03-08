#!/bin/sh
# Crea imagen fs para memorias USB (o discos duros)
# Dominio público. vtamara@pasosdeJesus.org 2017

. ./ver.sh

if (test ! -d $V$VESP-$ARQ) then {
	echo "No existe el directorio $V$VESP-$ARQ";
	exit 1;
} fi;
im=/usr/src/distrib/amd64/iso/install${VP}.fs
if (test ! -f $im ) then {
	echo "No existe la imagen $im";
	exit 1;
} fi;

function ej {
	cmd="$1"
	echo "Por ejecutar: $cmd"
	echo "[ENTER] para continuar";
	read
	eval $cmd
	vr="$?"
	echo "Valor retornado: $vr"
	return $vr
}

if (test ! -f adJ${VP}${VESP}.fs) then {
	if (test ! -f blanco) then {
		ej "dd of=blanco bs=1M seek=4900 count=0"
	} else {
		echo 'Archivo blanco existente, saltando creacion'
	} fi;
	ej "cat $im blanco > adJ${VP}${VESP}.fs"
} else {
	echo "Archivo adJ${VP}${VESP}.fs existente, saltando creacion"
} fi;
ej "doas vnconfig -l | grep 'vnd0: not in use' > /dev/null 2>&1"
if (test "$?" != "0") then {
	echo "vnd0 ocupado, no se puede continuar";
	exit 1;
} fi;
ej "doas vnconfig vnd0 adJ${VP}${VESP}.fs"
ej "fdisk"
# 671/255/63

# 944/255/63

ej "rm -f tmp/etiqueta.txt"
ej "doas disklabel /dev/vnd0c  | sed -e '' > tmp/etiqueta.txt"
#  a:         10769856             3520  4.2BSD   2048 16384     1             
#  b:             2400             1099    swap                                
#  c:         10773440                0  unused                                
#  i:              960               64   MSDOS             

ej "newfs /dev/rvnd0a"
ej "mount /dev/vnd0a /mnt/tmp"
ej "cp -rf 6.4b1-amd64/* /mnt/tmp/"
ej "umount /mnt/tmp"

cd $V$VESP-$ARQ
cmd="mkisofs -r -no-emul-boot -b $im -c boot.catalog -copyright Derechos.txt   -v -l -posix-L -T -J -o ../AprendiendoDeJesus-$V$VESP-$ARQ.iso  ."
echo "$cmd";
eval "$cmd";



