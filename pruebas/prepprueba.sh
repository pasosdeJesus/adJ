#!/bin/sh
# Prepara para aplicar parches y probar

. ./ver.sh
cd /usr
cmd="rsync --delete -ravz src${VP}-orig/ src/"
echo $cmd
eval $cmd
cmd="(cd /usr/src/lib/libc; make clean)"
echo $cmd
eval $cmd
cmd="(cd /usr/src; make obj)"
echo $cmd
eval $cmd
cmd="rsync --delete -ravz xenocara${VP}-orig/ xenocara/"
echo $cmd
eval $cmd
cmd="(cd /usr/xenocara; make obj)"
echo $cmd

