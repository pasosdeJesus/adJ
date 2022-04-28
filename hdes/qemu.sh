#!/bin/sh
# Inicia maquina virtual para probar imagen ISO

. ./ver.sh

if (test "$ARQ" = "i386") then {
	cmd="qemu"
} else {
	cmd="qemu-system-x86_64"
} fi;
opq="-m 512M -no-fd-bootchk -boot $qemuboot -cdrom AprendiendoDeJesus-$V$VESP-$ARQ.iso -drive file=virtual.raw,format=raw"
if (test "$TEXTO" = "1") then {
	opq="$opq -nographic -display curses -s"
	cmd="$cmd $opq"
} else {
	opq="$opq -s -serial file:/tmp/q -monitor stdio"
	cmd="/usr/X11R6/bin/xterm -e \"$cmd $opq\""
} fi;
if (test ! -f virtual.raw) then {
	qemu-img create -f raw virtual.raw 15G
} fi;

echo $cmd;
eval $cmd;
