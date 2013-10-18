#!/bin/sh
# Replaces daemon with service in base system of distribution adJ of OpenBSD.  Respects christians and non-christians, more neutral.
# Run from /usr/src/
# Public domain. vtamara@pasosdeJesus.org
# Tested with 5.2

# Remplaza ocurrencias de daemon por service 
function remplazad {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro";
		exit 1;
	} fi;
	rem=1;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/daemon/service/g
w
q
EOF
		ed $i <<EOF
,s/Daemon/Service/g
w
q
EOF
		ed $i <<EOF
,s/DAEMON/SERVICE/g
w
q
EOF
	} fi;
}
# Remplaza ocurrencias de /var/log/daemon por /var/log/service 
function remplazavarlog {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro";
		exit 1;
	} fi;
	rem=1;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/\/var\/log\/daemon/\/var\/log\/service/g
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

	grep service $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		ed $i <<EOF
/daemon
.t-1
.s/daemon/service/g
w
/DAEMON
.t-1
.s/DAEMON/SERVICE/g
w
q
EOF
	} fi;

}

echo "Buscando daemon en documentación";
find . -name "*.[1-9]" -exec grep -i -l -I "daemon" {} ';' > /tmp/tc 2> /dev/null
echo "Remplazando por service en documentación";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplazad $i;
	} fi;
done;

echo "Libreria libc";
cp lib/libc/gen/daemon.3 lib/libc/gen/service.3
if (test -f lib/libc/gen/daemon.c) then {
	mv lib/libc/gen/daemon.c lib/libc/gen/service.c
} fi;
grep service lib/libc/gen/service.c > /dev/null 2>&1
if (test "$?" != "0") then {
	ed lib/libc/gen/service.c <<EOF
,s/daemon/service/g
w
q
EOF
	ed lib/libc/gen/service.c <<EOF
\$a

/* Implementada por compatibilidad pero no recomendada --emplear service */
int 
daemon(int nochdir, int noclose) 
{ 
	return service(nochdir, noclose); 
}
.
w
q
EOF
} fi;

# Arreglando los que definian service
for i in `find kerberosV -name "*[h]" -exec grep -l "const char \*service" {} ';'; find kerberosV -name "*[c]" -exec grep -l "const char \*service" {} ';'`; do 
	echo "$i - kservice";
	ed $i << EOF
,s/service/kservice/g
,s/kservice_/service_/g
w
q
EOF
done

find /usr/include -name stdlib.h -exec grep -l daemon {} ';' > /tmp/tc
find . -name stdlib.h -exec grep -l daemon {} ';' >> /tmp/tc
for i in `cat /tmp/tc`; do
	echo $i
	replicaremplazauno $i
done

grep service lib/libc/gen/Makefile.inc > /dev/null 2>&1
if (test "$?" != "0") then {
	ed lib/libc/gen/Makefile.inc <<EOF
,s/daemon.c/service.c/g
w
,s/daemon.3/daemon.3 service.3/g
w
q
EOF
} fi;

echo "Buscando daemon en otras librerías";
find lib/ -exec grep -i -l -I "daemon" {} ';' | grep -v bn_exp.c | grep -v "gen.Makefile.inc" | grep -v "service.c" | grep -v "tcpd.h" | grep -v "CVS" > /tmp/tc 2> /dev/null
echo "Remplazando por service en otras librerías";
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
	grep "eval_service" $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		ed $i <<EOF
,s/daemon\[/service[/g
w
1
,s/via eval_daemon/via eva_service/g
w
1
/daemon
.t-1
.s/daemon/service/g
w
1
/DAEMON
.t-1
.s/DAEMON/SERVICE/g
w
,s/(r)->daemon/(r)->service/g
w
,s/daemon process/service process/g
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

echo "Renombrando uso de service en faithd"
i=usr.sbin/faithd/faithd.c
grep "nservice;" $i > /dev/null 2>&1
if (test "$?" != "0") then {
	ed $i <<EOF
,s/\([^n]\)service =/\1nservice =/g
w
1
,s/, service/, nservice/g
w
1
q
EOF
	ed $i <<EOF
,s/\([^n]\)service;/\1nservice;/g
w
q
EOF
} fi;


echo "Remplazando por service en varios directorios excepto sbin y usr.sbin";
find bin usr.sbin/cron usr.bin games gnu kerberosIV regress share -exec grep -i -l -I "daemon" {} ';' | grep -v "CVS" | grep -v "web2" | grep -v "perl" | grep -v "sendmail" > /tmp/tc 2> /dev/null
for i in `cat /tmp/tc`; do 
	echo $i;
	remplazad $i;
done;

echo "Buscando /var/log/daemon";
find . -exec grep -i -l -I "/var/log/daemon" {} ';' > /tmp/tc 2> /dev/null
echo "Remplazando por /var/log/service";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplazavarlog $i;
	} fi;
done;
