#!/bin/sh
# Copia inst-adJ actual en imagen de qemu ya instalada
# Dominio público. 2009 vtamara@pasosdeJesus.org

. ./ver.sh

sudo mkdir -p /mnt/tmp
sudo vnconfig -c vnd0 virtual.hd 
exit 1;
sudo fsck -y /dev/vnd0a 
sudo mount /dev/vnd0a /mnt/tmp
sudo cp /mnt/tmp/inst-adJ.sh inst-adJ-qemu.sh
sudo cp /mnt/tmp/inst-sivel.sh inst-sivel-qemu.sh
sudo cp inst-adJ$VP.sh /mnt/tmp/inst-adJ.sh
sudo cp inst-sivel$VP.sh /mnt/tmp/inst-sivel.sh
sudo umount /mnt/tmp
sudo vnconfig -u vnd0c
