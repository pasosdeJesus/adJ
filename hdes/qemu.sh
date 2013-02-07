#!/bin/sh
# Inicia maquina virtual para probar imagen ISO

. ./ver.sh

opq="-boot $qemuboot -cdrom AprendiendoDeJesus-$V$VESP-$ARQ.iso virtual.vdi"
if (test "$TEXTO" = "1") then {
	opq="$opq -curses"
} else {

	opq="$opq -s -serial file:/tmp/q -monitor stdio"
} fi;
if (test ! -f virtual.vdi) then {
	qemu-img create -f raw virtual.vdi 13G
} fi;

if (test "$ARQ" = "i386") then {
	cmd="qemu"
} else {
	cmd="qemu-system-x86_64"
} fi;
cmd="sudo xterm -e \"$cmd $opq\""
echo $cmd;
eval $cmd;
