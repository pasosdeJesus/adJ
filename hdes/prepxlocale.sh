#!/bin/sh
# Prepara parches de xlocale
# Dominio público de acuerdo a legislación colombiana. http://www.pasosdejesus.org/dominio_publico_colombia.html. 
# 2013. vtamara@pasosdeJesus.org

if (test ! -f ver.sh.plantilla) then {
	echo "Ejecutar desde directorio con fuentes de adJ";
	exit 1;
} fi;
cur=`pwd`;
cd /usr/src
sudo cvs diff -u include/Makefile > ${cur}/arboldes/usr/src/xlocale1.patch
echo "? include/_ctype.h" >> ${cur}/arboldes/usr/src/xlocale1.patch
echo "? include/runetype.h" >> ${cur}/arboldes/usr/src/xlocale1.patch
echo "? include/xlocale" >> ${cur}/arboldes/usr/src/xlocale1.patch
echo "? include/xlocale.h" >> ${cur}/arboldes/usr/src/xlocale1.patch
echo "? lib/libc/locale/collate.h" >> ${cur}/arboldes/usr/src/xlocale1.patch
echo "? lib/libc/locale/xlocale_private.h" >> ${cur}/arboldes/usr/src/xlocale1.patch
sudo cvs diff -u share/locale  >> ${cur}/arboldes/usr/src/xlocale1.patch
sudo cvs diff -u usr.bin/Makefile >> ${cur}/arboldes/usr/src/xlocale1.patch
sudo rm -rf usr.bin/colldef/obj
echo "? usr.bin/colldef" >> ${cur}/arboldes/usr/src/xlocale1.patch

sudo cvs diff -u include/{wctype.h,wchar.h,string.h,stdlib.h,locale.h,langinfo.h}  > ${cur}/arboldes/usr/src/xlocale2.patch
sudo cvs diff -u lib/libc/locale/ >> ${cur}/arboldes/usr/src/xlocale2.patch
sudo cvs diff -u lib/libc/string/ >> ${cur}/arboldes/usr/src/xlocale2.patch
sudo cvs diff -u lib/libc/gen/{isctype.c,tolower.3,tolower_.c,toupper.3,toupper_.c} >> ${cur}/arboldes/usr/src/xlocale2.patch
sudo rm -rf regress/lib/libc/locale/check_xlocale/obj
sudo cvs diff -u regress/lib/libc/locale/ >> ${cur}/arboldes/usr/src/xlocale2.patch
sudo cvs diff -u usr.bin/mklocale/ >> ${cur}/arboldes/usr/src/xlocale2.patch

# 3 include/{inttypes.h,langinfo.h,stdio.h,stdlib.h,time.h}
cd ${cur}
hdes/copiafaltantesdeparche.sh arboldes/usr/src/xlocale1.patch /usr/src arboldes/usr/src
hdes/copiafaltantesdeparche.sh arboldes/usr/src/xlocale2.patch /usr/src arboldes/usr/src

