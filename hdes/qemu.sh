#!/bin/sh
# Inicia maquina virtual para probar imagen ISO

. ./ver.sh

que="$1"
if (test "$que" = "") then {
  que="iso"
} fi;
if (test "$que" != "img" -a "$que" != "iso") then {
  echo "Solo maneja img o iso"
  exit 1;
} fi;

cmd="qemu-system-x86_64"
opq="-m 512M -no-fd-bootchk"
if (test "$que" = "iso") then {
  opq="$opq -boot $qemuboot -cdrom AprendiendoDeJesus-$V$VESP-$ARQ.iso"
} else {
  echo "Como bootindex no opera con qemu 9.0.2 en adJ 7.6 usamos -boot=menu"
  echo "Para arrancar por la USB al inicio presione ESC y elija el segundo disposito que debe ser la USB"
  echo "[ENTER] para continuar"
  read
  opq="$opq -boot menu=on"
  opq="$opq -drive if=none,id=stick,format=raw,file=AprendiendoDeJesus-$V$VESP-$ARQ.img"
  opq="$opq -device nec-usb-xhci,id=xhci"
  opq="$opq -device usb-storage,bus=xhci.0,drive=stick"
} fi;
opq="$opq -drive file=virtual.raw,format=raw"
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

echo $cmd > /tmp/c
echo $cmd 
eval $cmd;
