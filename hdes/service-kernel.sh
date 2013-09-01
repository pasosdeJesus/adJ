#!/bin/sh
# Dominio público de acurdo a legislación colombiana. vtamara@pasosdeJesus.org
# Replaces daemon with service in kernel of OpenBSD.  Respects christians and non-christians, more neutral.
# Run from /usr/src/sys
# Tested from 4.7 


# Remplaza ocurrencias de daemon por service con manejo especial de casos
# como el de syslog.h
function remplaza {
	i=$1;
	if (test ! -f "$i") then {
		echo "Falta archivo como primer parámetro";
		exit 1;
	} fi;
	rem=1;
	s=`echo $i | sed -e "s/.*syslog.h//g"`;
	if (test "$s" = "") then {
		grep 'daemon.*LOG_SERVICE' $i > /dev/null 2>&1
		if (test "$?" = "0") then {
			rem=0;
		} fi;
	} fi;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/daemon/service/g
w
q
EOF
	} fi;
	ed $i <<EOF
,s/Daemon/Service/g
w
q
EOF
	rem=1;
	s=`echo $i | sed -e "s/.*syslog.h//g"`;
	if (test "$s" = "") then {
		grep 'LOG_SERVICE' $i > /dev/null 2>&1
		if (test "$?" = "0") then {
			rem=0;
		} fi;
	} fi;
	if (test "$rem" = "1") then {
		ed $i <<EOF
,s/DAEMON/SERVICE/g
w
q
EOF
	} fi;
}

cd /usr/src/sys
# Renombra uvm/uvm_pdaemon.{c,h} por uvm/uvm_pservice.{c,h} --pageservice
a=`find . | grep -i daemon`;
for i in $a; do 
	ni=`echo $i | sed -e "s/daemon/service/g;s/Daemon/Service/g;s/DAEMON/SERVICE/g"`
	echo "$i -> $ni";
	mv $i $ni
done
#if (test -f uvm/uvm_pdaemon.c) then {
#	sudo mv uvm/uvm_pdaemon.c uvm/uvm_pservice.c
#} fi;
#if (test -f uvm/uvm_pdaemon.h) then {
#	sudo mv uvm/uvm_pdaemon.h uvm/uvm_pservice.h
#} fi;

# En las fuentes remplaza ocurrencias, manejando de forma especial casos
# excepcionales como el de syslog.h
echo "Buscando";
find . -exec grep -i -l -I "daemon" {} ';' > /tmp/tc
echo "Remplazando";
for i in `cat /tmp/tc`; do 
	echo $i;
	encvs=`echo $i | sed -e "s/.*\/CVS\/.*//g"`;
	if (test "$encvs" != "") then {
		remplaza $i;
	} fi;
done

# Adicion especial en syslog.h para no quebrar aplicaciones que
# esperan constante LOG_DAEMON y nombre de facilidad "daemon"
grep LOG_DAEMON "sys/syslog.h" > /dev/null 2>&1
if (test "$?" != "0") then {
	ed sys/syslog.h << EOF
/define.*LOG_SERVICE
.t.
.s/SERVICE/DAEMON/
/"service",.*LOG_SERVICE
.t.
.s/service/daemon/
w
q
EOF
} fi;

# Aplica otros cambios a resto de fuentes que OpenBSD que empleaban nombres
# antiguos
if (test -f "../usr.bin/vmstat/vmstat.c") then {
	ed ../usr.bin/vmstat/vmstat.c << EOF
,s/daemon/service/g
w
q
EOF
} fi;

# Copia cambios en encabezados a encabezados del sistema
cp -rf /usr/src/sys/sys/*h /usr/include/sys/
cp -rf /usr/src/sys/sys/syslog.h /usr/include/

