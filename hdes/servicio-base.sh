#!/bin/sh
# Replaces daemon with servicio in base system of distribution adJ of OpenBSD.  Respects christians and non-christians, more neutral.
# Run from /usr/src/
# Public domain. vtamara@pasosdeJesus.org
# Tested with 5.2

# Remplaza ocurrencias de daemon por servicio 
function remplazad {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro";
		exit 1;
	} fi;
	rem=1;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/daemon/servicio/g
w
q
EOF
		ed $i <<EOF
,s/Daemon/Servicio/g
w
q
EOF
		ed $i <<EOF
,s/DAEMON/SERVICIO/g
w
q
EOF
	} fi;
}
# Remplaza ocurrencias de /var/log/daemon por /var/log/servicio 
function remplazavarlog {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro";
		exit 1;
	} fi;
	rem=1;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/\/var\/log\/daemon/\/var\/log\/servicio/g
w
q
EOF
	} fi;
}

function replicaremplazauno {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro de replicaremplazauno";
		exit 1;
	} fi;

	grep servicio $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		ed $i <<EOF
/daemon
.t-1
.s/daemon/servicio/g
w
q
EOF
		ed $i <<EOF
/DAEMON
.t-1
.s/DAEMON/SERVICIO/g
w
q
EOF
	} fi;

}

echo "Buscando daemon en documentación";
find . -name "*.[1-9]" -exec grep -i -l -I "daemon" {} ';' > /tmp/tc 2> /dev/null
echo "Remplazando por servicio en documentación";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplazad $i;
	} fi;
done;

echo "Libreria libc";
cp lib/libc/gen/daemon.3 lib/libc/gen/servicio.3
if (test -f lib/libc/gen/daemon.c) then {
	mv lib/libc/gen/daemon.c lib/libc/gen/servicio.c
} fi;
grep servicio lib/libc/gen/servicio.c > /dev/null 2>&1
if (test "$?" != "0") then {
	ed lib/libc/gen/servicio.c <<EOF
,s/daemon/servicio/g
w
q
EOF
	ed lib/libc/gen/servicio.c <<EOF
\$a

/* Implementada por compatibilidad pero no recomendada --emplear servicio */
int 
daemon(int nochdir, int noclose) 
{ 
	return servicio(nochdir, noclose); 
}
.
w
q
EOF
} fi;

find /usr/include -name stdlib.h -exec grep -l daemon {} ';' > /tmp/tc
find /usr/src/include -name stdlib.h -exec grep -l daemon {} ';' >> /tmp/tc
for i in `cat /tmp/tc`; do
	echo $i
	replicaremplazauno $i
done

grep servicio lib/libc/gen/Makefile.inc > /dev/null 2>&1
if (test "$?" != "0") then {
	ed lib/libc/gen/Makefile.inc <<EOF
,s/daemon.c/servicio.c/g
w
q
EOF
	ed lib/libc/gen/Makefile.inc <<EOF
,s/daemon.3/daemon.3 servicio.3/g
w
q
EOF
} fi;

grep servicio lib/libc/Symbols.list > /dev/null 2>&1
if (test "$?" != "0") then {
	replicaremplazauno lib/libc/Symbols.list
} fi;

echo "Buscando daemon en otras librerías";
find lib/ -exec grep -i -l -I "daemon" {} ';' | grep -v bn_exp.c | grep -v "gen.Makefile.inc" | grep -v "servicio.c" | grep -v "tcpd.h" | grep -v "CVS" | grep -v "stdlib.h" | grep -v Symbols.list > /tmp/tc 2> /dev/null
echo "Remplazando por servicio en otras librerías";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplazad $i;
	} fi;
done;


find /usr/include -name tcpd.h -exec grep -li daemon {} ';' > /tmp/tc
find . -name tcpd.h -exec grep -li daemon {} ';' >> /tmp/tc
for i in `cat /tmp/tc`; do
	echo $i
	grep "eval_servicio" $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		ed $i <<EOF
,s/daemon\[/servicio[/g
w
1
,s/via eval_daemon/via eval_servicio/g
w
1
/daemon
.t-1
.s/daemon/servicio/g
w
1
/DAEMON
.t-1
.s/DAEMON/SERVICIO/g
w
,s/(r)->daemon/(r)->servicio/g
w
,s/daemon process/servicio process/g
q
EOF
	} fi;
done


echo "Remplazando en servicios y programas que deben mantener compatibilidad"
echo "cron"
find usr.sbin/cron -exec grep -i -l "daemon" {} ';' | grep -v "CVS" > /tmp/tc 2> /dev/null
for i in `cat /tmp/tc`; do 
	echo $i;
	remplazad $i;
done;

echo "Remplazando por servicio en varios directorios excepto sbin y usr.sbin";
find bin usr.sbin/cron usr.bin games gnu regress share libexec sbin/iked usr.sbin -exec grep -i -l -I "daemon" {} ';' | grep -v "CVS" | grep -v "web2" | grep -v "perl" | grep -v "sendmail" | grep -v "lpr.lp.*Makefile" | grep -v "usr.sbin.unbound" > /tmp/tc 2> /dev/null
for i in `cat /tmp/tc`; do 
	echo $i;
	remplazad $i;
done;

echo "fuse_servicioize"
mv lib/libfuse/fuse_daemonize.3 lib/libfuse/fuse_servicioize.3

echo "Buscando /var/log/daemon";
find . -exec grep -i -l -I "/var/log/daemon" {} ';' > /tmp/tc 2> /dev/null
echo "Remplazando por /var/log/servicio";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplazavarlog $i;
	} fi;
done;
