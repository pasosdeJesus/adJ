#!/bin/sh
# Crea imagen img para memorias USB (o discos duros)
# Dominio público. vtamara@pasosdeJesus.org 2017

. ./ver.sh

if (test ! -d $V$VESP-$ARQ) then {
  echo "No existe el directorio $V$VESP-$ARQ";
  exit 1;
} fi;
im=/usr/src/distrib/amd64/iso/obj/install${VP}.img
if (test ! -f $im ) then {
  echo "Intentando crear $im"
  doas rm -rf /home/rel-amd64 /home/relx-amd64
  doas mkdir -p /home/rel-amd64 /home/relx-amd64
  cmd="doas cp $V$VESP-$ARQ/{INSTALL.amd64,SHA256,base$VP.tgz,bsd,bsd.mp,bsd.rd,cdboot,cdbr,comp$VP.tgz,game$VP.tgz,man$VP.tgz} /home/rel-amd64/"
  echo "$cmd"
  eval "$cmd"
  cmd="doas cp $V$VESP-$ARQ/{xbase$VP.tgz,xfont$VP.tgz,xshare$VP.tgz,xserv$VP.tgz} /home/relx-amd64/"
  echo "$cmd"
  eval "$cmd"
  touch /home/relx-amd64/SHA256 /home/rel-amd64/BUILDINFO
  (cd /usr/src/distrib/amd64/iso; FSSIZE=940000 make)
  if (test ! -f $im ) then {
    echo "No pudo crearse $im";
    exit 1;
  } fi;
} fi;

function ej {
  cmd="$1"
  echo "Por ejecutar: $cmd"
  echo "[ENTER] para continuar";
  read
  eval $cmd
  vr="$?"
  echo "Valor retornado: $vr"
  return $vr
}

if (test ! -f AprendiendoDeJesus-${V}${VESP}-${ARQ}.img) then {
  if (test ! -f blanco) then {
    ej "dd of=blanco bs=1M seek=5000 count=0"
  } else {
  echo 'Archivo blanco existente, saltando creacion'
} fi;
ej "cat $im blanco > AprendiendoDeJesus-${V}${VESP}-${ARQ}.img"
} else {
echo "Archivo AprendiendoDeJesus-${V}${VESP}-${ARQ}.img existente, saltando creacion"
} fi;
ej "doas vnconfig -l | grep 'vnd0: not in use' > /dev/null 2>&1"
if (test "$?" != "0") then {
  echo "vnd0 ocupado, no se puede continuar";
  exit 1;
} fi;
ej "doas vnconfig vnd0 AprendiendoDeJesus-${V}${VESP}-${ARQ}.img"
ej "doas fdisk -i -b 10000 -y /dev/rvnd0c"
# adJ64  fdisk: 1> p
#Disk: /dev/rvnd0c       geometry: 107734/1/100 [10773440 Sectors]
#Offset: 0       Signature: 0xAA55
#            Starting         Ending         LBA Info:
#: id      C   H   S -      C   H   S [       start:        size ]
#-------------------------------------------------------------------------------
# 0: EF      0   0  65 -     10   0  24 [          64:         960 ] EFI Sys     
# 1: 00      0   0   0 -      0   0   0 [           0:           0 ] unused      
# 2: 00      0   0   0 -      0   0   0 [           0:           0 ] unused      
#*3: A6     10   0  25 -   7372   0  80 [        1024:      736256 ] OpenBSD    
ej "rm -f tmp/etiqueta.txt"
ej "doas disklabel /dev/vnd0c  > /tmp/etiqueta.txt"
cat /tmp/etiqueta.txt
echo "[ENTER] por modificar esta etiqueta"
read
doas disklabel -E /dev/vnd0c <<EOF
a b

2400

a a



w
q
EOF
ej "doas disklabel /dev/vnd0c"
#                size           offset  fstype [fsize bsize   cpg]
#  a:         10945120            12512  4.2BSD   2048 16384     1 
#  b:             2400            10112    swap                    
#  c:         10957696                0  unused                    
#  i:            10000               64   MSDOS              

# /dev/rvnd0c> p
# OpenBSD area: 1024-737280; size: 736256; free: 0
# adJ64           size           offset  fstype [fsize bsize   cpg]
# a:           736256             1024  4.2BSD   2048 16384 16142 
# c:         10773440                0  unused                    
# i:              960               64   MSDOS        

ej "doas newfs /dev/rvnd0a"
ej "doas mount /dev/vnd0a /mnt/tmp"
ej "doas cp -rf $V$VESP-$ARQ/* /mnt/tmp/"

# Copia la necesario para installbot modo EFI que no está documentado en
# man installboot (tocó seguir paso a paso y analizar fuentes)
# Debe ejecutarse desde /dev o un directorio con los dispositivos
# Los dispositivos deben llamarse duid.p (bloque) y rduid.p (caracter) con
# los mismos mayor y menor del dispositivo.
# En el destino /mnt/tmp aqui debe existir /usr/mdec/BOOTIA32.EFI y
# /usr/mdec/BOOTX64.EFI


ej "doas mkdir -p /mnt/tmp/usr/mdec"
ej "doas cp -f /usr/mdec/biosboot /mnt/tmp/usr/mdec"
ej "doas cp -f /usr/mdec/boot /mnt/tmp/boot"
ej "doas cp -f $V$VESP-$ARQ/BOOTIA32.EFI /mnt/tmp/usr/mdec"
ej "doas cp -f $V$VESP-$ARQ/BOOTX64.EFI /mnt/tmp/usr/mdec"

# adJ 64
# $ find /mnt/tmp
# /mnt/tmp
# /mnt/tmp/efi
# /mnt/tmp/efi/boot
# /mnt/tmp/efi/boot/bootx64.efi
# /mnt/tmp/efi/boot/bootia32.efi

duid=`doas sysctl hw.disknames | sed -e "s/.*,vnd0:\([0-9a-f]*\).*/\1/g"`
echo "Duuid de vnd0 es $duid"
ej "doas mknod r$duid.i c 41 8" # Como /dev/rvnd0i
ej "doas mknod $duid.i b 14 8" # Como /dev/vnd0i

ej "doas installboot -v -r /mnt/tmp/ vnd0c /mnt/tmp/usr/mdec/biosboot /mnt/tmp/boot"

ej "doas umount -f /mnt/tmp"


