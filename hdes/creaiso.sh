#!/bin/sh
# Crea imagen ISO
# Dominio público. vtamara@pasosdeJesus.org 2008
# http://bsd.b3ta.org/2007/11/06/custom-openbsd-42-bootable-cd/

. ./ver.sh

if (test ! -d $V$VESP-$ARQ) then {
	echo "No existe el directorio $V$VESP-$ARQ";
	exit 1;
} fi;
if (test -f $V$VESP-$ARQ/cdemu$VP.iso) then {
	# crear cdrom42.fs 
	cmd="./hdes/geteltorito.pl $V$VESP-$ARQ/cdemu$VP.iso  > $V$VESP-$ARQ/cdrom$VP.fs"
	echo "$cmd"
	eval "$cmd"
	im=cdrom$VP.fs;
}
else {
	im=floppy$VP.fs
} fi;

im=cdbr

cd $V$VESP-$ARQ
cmd="mkhybrid -r -e eficdboot -b $im -c boot.catalog -copyright Derechos.txt   -v -l -f -T -J -o ../AprendiendoDeJesus-$V$VESP-$ARQ.iso  ."
echo "$cmd";
eval "$cmd";



