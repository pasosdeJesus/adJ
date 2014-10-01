#!/bin/sh
# Prepara para aplicar parches y probar

. ./ver.sh
cd /usr
cmd="sudo rsync --delete -ravz src${VP}-orig/ src/"
echo $cmd
eval $cmd
cmd="(cd /usr/src; sudo make obj)"
echo $cmd
eval $cmd
