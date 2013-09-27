#!/bin/sh
# Copia inst-adJ actual en imagen de qemu ya instalada
# Dominio público. 2009 vtamara@pasosdeJesus.org

. ./ver.sh

sudo mkdir -p /mnt/tmp
sudo vnconfig -c vnd0c virtual.vdi
sudo fsck -y /dev/vnd0a 
sudo mount /dev/vnd0a /mnt/tmp
sudo cp /mnt/tmp/usr/local/adJ/inst-adJ.sh tmp/inst-adJ-qemu.sh
sudo cp /mnt/tmp/usr/local/adJ/inst-sivel.sh tmp/inst-sivel-qemu.sh
sudo cp arboldd/usr/local/adJ/inst-adJ.sh /mnt/tmp/usr/local/adJ/
sudo cp arboldd/usr/local/adJ/inst-sivel.sh /mnt/tmp/usr/local/adJ/
sudo umount /mnt/tmp
sudo vnconfig -u vnd0c
