#!/bin/sh
# Prepara para aplicar parches y probar

. ./ver.sh
cd /usr
cmd="sudo rsync --delete -ravz xenocara${VP}-orig/ xenocara/"
echo $cmd
eval $cmd
cmd="(cd /usr/xenocara; sudo make obj)"
echo $cmd
eval $cmd
