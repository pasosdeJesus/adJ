#!/bin/sh
# Prepara para aplicar parches y probar

. ./ver.sh
cd /usr
cmd="doas rsync --delete -ravz src${VP}-orig/ src/"
echo $cmd
eval $cmd
cmd="(cd /usr/src/lib/libc; doas make clean)"
echo $cmd
eval $cmd
cmd="(cd /usr/src; doas make obj)"
echo $cmd
eval $cmd
cmd="doas rsync --delete -ravz xenocara${VP}-orig/ xenocara/"
echo $cmd
eval $cmd
cmd="(cd /usr/xenocara; doas make obj)"
echo $cmd

