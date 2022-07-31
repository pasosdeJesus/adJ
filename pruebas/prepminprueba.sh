#!/bin/sh
# Copia lo minimo necesario para aplicar los parches y recompilar libc

rsync -ravz --delete /usr/src71-orig/regress/ /usr/src/regress/
rsync -ravz --delete /usr/src71-orig/lib/libc/ /usr/src/lib/libc/
rsync -ravz --delete /usr/src71-orig/share/locale/ /usr/src/share/locale/
rsync -ravz --delete /usr/src71-orig/usr.bin/colldef /usr/src/usr.bin/colldef
rsync -ravz --delete /usr/src71-orig/usr.bin/localedef /usr/src/usr.bin/localedef
rsync -ravz --delete /usr/src71-orig/gnu/usr.bin/perl/hints/ /usr/src/gnu/usr.bin/perl/hints/
for i in /gnu/llvm/clang/lib/Basic/Targets/OSTargets.h /gnu/llvm/libcxx/include/__config /gnu/llvm/libcxx/include/__locale /gnu/llvm/libcxx/include/__support/openbsd/xlocale.h /gnu/usr.bin/perl/hints/openbsd.sh /include/Makefile /include/ctype.h /include/langinfo.h /include/locale.h /include/monetary.h /include/stdio.h /include/string.h /include/strings.h /include/time.h /include/wchar.h /include/wctype.h /include/xlocale.h /share/locale/cldr/Makefile /usr.sbin/pkg_add/OpenBSD/BaseState.pm /gnu/gcc/gcc/config/openbsd.h /etc/Makefile /etc/etc.amd64/Makefile.inc /include/Makefile /usr.bin/Makefile ; do
	rsync -ravz --delete /usr/src71-orig/$i /usr/src/$i
done

