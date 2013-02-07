#!/bin/sh
# Crea imagen ISO
# Dominio público. vtamara@pasosdeJesus.org 2008
# http://bsd.b3ta.org/2007/11/06/custom-openbsd-42-bootable-cd/

. ./ver.sh

echo $V$VESP-$ARQ/cdemu$VP.iso
if (test -f $V$VESP-$ARQ/cdemu$VP.iso) then {
	# crear cdrom42.fs 
	./hdes/geteltorito.pl $V$VESP-$ARQ/cdemu$VP.iso  > $V$VESP-$ARQ/cdrom$VP.fs
	im=cdrom$VP.fs;
}
else {
	im=floppy$VP.fs
} fi;

im=cdbr

cd $V$VESP-$ARQ
cmd="mkisofs -r -no-emul-boot -b $im -c boot.catalog -copyright Derechos.txt   -v -l -posix-L -T -J -o ../AprendiendoDeJesus-$V$VESP-$ARQ.iso  ."
echo "$cmd";
eval "$cmd";



