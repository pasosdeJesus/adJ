#!/bin/sh
# Prepara para aplicar parches y probar

. ./ver.sh
cd /usr
cmd="doas rsync --delete -ravz src${VP}-orig/ src/"
echo $cmd
eval $cmd
cmd="(cd /usr/src; doas make obj)"
echo $cmd
eval $cmd
cmd="sudo rsync --delete -ravz xenocara${VP}-orig/ xenocara/"
echo $cmd
eval $cmd
cmd="(cd /usr/xenocara; sudo make obj)"
echo $cmd

