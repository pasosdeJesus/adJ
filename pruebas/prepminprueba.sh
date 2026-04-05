#!/bin/sh
# Copia lo minimo necesario para aplicar los parches y recompilar libc
# Dominio público. 2026. vtamara@pasosdeJesus.org

. ./ver.sh

# 1. Limpieza de archivos de parches en la raíz para que aplicahasta opere de cero
doas rm -f /usr/src/*.patch

# 2. Restauración completa de directorios base modificados
# Sincronizamos todo regress/lib/libc como sugeriste para evitar parches "reversos"
for d in regress/lib/libc lib/libc share/locale gnu/llvm/clang gnu/llvm/libcxx gnu/lib/libcxx gnu/usr.bin/perl ; do
	if [ -d /usr/src$VP-orig/$d ]; then
		doas rsync -ravz --delete /usr/src$VP-orig/$d/ /usr/src/$d/
	fi
done

# 3. Restauración de archivos específicos fuera de los directorios anteriores
for i in sys/sys/localedef.h include/Makefile include/ctype.h include/langinfo.h include/locale.h include/monetary.h include/stdio.h include/string.h include/strings.h include/time.h include/wchar.h include/wctype.h include/xlocale.h share/locale/cldr/Makefile usr.sbin/pkg_add/OpenBSD/BaseState.pm usr.sbin/pkg_add/OpenBSD/PackingElement.pm gnu/gcc/gcc/config/openbsd.h etc/Makefile etc/etc.amd64/Makefile.inc usr.bin/Makefile ; do
	if [ -e /usr/src$VP-orig/$i ]; then 
		doas cp /usr/src$VP-orig/$i /usr/src/$i
	else 
		doas rm -f /usr/src/$i
	fi
done

# 4. Eliminar directorios que adJ crea y que no existen en OpenBSD
doas rm -rf /usr/src/usr.bin/localedef /usr/src/usr.bin/colldef
