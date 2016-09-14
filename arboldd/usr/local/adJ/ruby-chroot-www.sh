#!/bin/sh
# Copia partes de ruby a chroot de Apache
# Dominio público. 2016. vtamara@pasosdeJesus.org
# Referencias:
# http://web.archive.org/web/20100110060204/http://bsd.phoenix.az.us/faq/openbsd/rails-chroot-fastcgi

dchroot=$1;
if (test "$dchroot" = "") then {
	echo "Primer parametro debe ser directorio chroot en el que corre Apache";
	exit 1;
} fi;


pkg_info -L ruby-2.3.1 | grep "^/" > /tmp/l
for i in `cat /var/db/pkg/ruby-2.3.1/+REQUIRING`; do
	pkg_info -L $i | grep "^/" >> /tmp/l
done
ldd /usr/local/bin/ruby23  | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l
ldd /usr/local/lib/ruby/2.3/x86_64-openbsd/zlib.so | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l
gem contents bundler >> /tmp/l
gem contents rubygems-update >> /tmp/l
pkg_info -L node | grep "^/" >> /tmp/l
ldd /usr/local/bin/node | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l
echo "/sbin/ldconfig" >> /tmp/l
echo "/etc/resolv.conf" >> /tmp/l

ldd `gem contents nokogiri | grep "\.so"` | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l

ldd `find /home/vtamara/.bundler/gems/ -name "*.so"` | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l


# Otros que pueden requerirse
echo /usr/local/bin/convert >> /tmp/l
ldd /usr/local/bin/convert | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l


sort -u /tmp/l > /tmp/lo
for i in `cat /tmp/lo` ; do
	cmd="mkdir -p /var/www/`dirname $i`"
	eval "$cmd"
	if (test "$?" != "0") then {
		echo "$cmd";
	} fi;
	cmd="cp $i /var/www/`dirname $i`"
	eval "$cmd"
	if (test "$?" != "0") then {
		echo "$cmd";
	} fi;
done;
chroot $dchroot /sbin/ldconfig /usr/local/lib /usr/X11R6/lib/
exit 1;
cp /usr/local/bin/ruby23 $dchroot/usr/local/bin/ruby23
cp /usr/lib/{libc.so.*,libtermcap.so.*,libssl.so.*,libcrypto.so.*} $dchroot/usr/lib/
cp /usr/libexec/ld.so $dchroot/usr/libexec/
cp /usr/bin/openssl $dchroot/usr/bin/
cp /bin/echo $dchroot/bin/

# Pruebas

cp /bin/ksh /bin/sh $dchroot/bin/


exit 0;
echo 'r=`echo "holax nación" | /usr/local/bin/ispell -d spanish -l -Tlatin1`' > $dchroot/usr/local/bin/test-ispell.sh
echo 'if (test "$r" != "holax") then { echo 'Problema con instalación de ispell'; exit 1; } fi;' >> $dchroot/usr/local/bin/test-ispell.sh
echo "echo \"ispell funciona en español en directorio chroot $dchroot/\"" >> $dchroot/usr/local/bin/test-ispell.sh
chmod +x $dchroot/usr/local/bin/test-ispell.sh
chroot -u www $dchroot/ /usr/local/bin/test-ispell.sh
