#!/bin/sh
# Renombra daemon por service en diversos servicios de un directorio etc en adJ
# Dominio público de acuerdo a legislación colombiana. 2012. vtamara@pasosdeJesus.org



echo "Renombra bitacoras, suponemos que sistema base fue compilado con facilidad service"  >> /var/tmp/inst-adJ.bitacora
# syslog
grep ".var.log.daemon" /etc/syslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando por service en /etc/syslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/syslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/daemon
s/daemon.info\([^;].*\)\/var/daemon.info;service.info \1\/var/g
s/\/var\/log\/daemon/\/var\/log\/service/g
w
q
EOF
} fi;

grep ".var.log.daemon" /etc/newsyslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando por service en /etc/newsyslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/newsyslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/daemon
s/var\/log\/daemon/var\/log\/service/g
w
q
EOF
} fi;

echo "Archivos de etc en general exceptuando casos especiales de compatibilidad"  >> /var/tmp/inst-adJ.bitacora
l1=`find . -exec grep -l "daemon" {} ';' | grep -v "login.conf" | grep -v "group" | grep -v "passwd" | grep -v "pwd.db" | grep -v "syslog.conf" | grep -v "rc.subr" | grep -v "mail/aliases" | grep -v "mail/.*cf" | grep -v "Xsetup_0" | grep -v "dbus-1/system.conf" | grep -v "rc.conf.local" | grep -v "rc.local" | grep -v "rc.d/courier_authdaemond"`
l2=`grep -l "daemon" rc.d/* | grep -v "rc.subr"`
l="$l1 $l2"
echo "l=$l" >> /var/tmp/inst-adJ.bitacora 
for i in $l; do 
	echo $i  >> /var/tmp/inst-adJ.bitacora
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon/service/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Service/g
w
q
EOF

done;

echo "Particularidades de rc.subr"  >> /var/tmp/inst-adJ.bitacora
if (test -f "rc.d/rc.subr") then {
	grep "daemon_user.*service_user" rc.d/rc.subr > /dev/null 2>&1
	if (test "$?" = "1") then {
		ed rc.d/rc.subr >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon/service/g
w
q
EOF
		ed rc.d/rc.subr >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Service/g
w
q
EOF
		ed rc.d/rc.subr  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/service is not set
i
# Compatibilidad con formato anterior 
[ ! -z "\${daemon}"  ] && service=\${daemon}
[ ! -z "\${daemon_user}"  ] && service_user=\${daemon_user}
[ ! -z "\${daemon_flags}"  ] && service_flags=\${daemon_flags}
[ ! -z "\${daemon_class}"  ] && service_class=\${daemon_class}

.
w
q
EOF
	} fi;
} fi;

echo "Particularidades de login.conf"  >> /var/tmp/inst-adJ.bitacora
for i in login.conf login.conf.in; do
	echo $i >> /var/tmp/inst-adJ.bitacora
	grep "^service:" $i > /dev/null 2>&1
	if (test -f $i -a "$?" != "0") then {
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^daemon:
-
.,+8t.
/^daemon:
s/daemon/service/g
i

.
w
q
EOF
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon\([^:]\)/service\1/g
w
q
EOF
	} fi;
done;

echo "Particularidades de usuario y grupo"  >> /var/tmp/inst-adJ.bitacora
for i in group master.passwd mail/aliases; do
	grep "^service:" $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		echo $i  >> /var/tmp/inst-adJ.bitacora
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^daemon:
.t.
-
.s/daemon/service/g
w
q
EOF
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/devil/service/g
w
q
EOF
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/:daemon/:service/g
w
q
EOF
		ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Service/g
w
q
EOF
	} fi;
done;
pwd_mkdb -p /etc/master.passwd

echo "Manual"  >> /var/tmp/inst-adJ.bitacora
if (test -f "../share/man/man8/rc.d.8") then {
	dm="../share/man/man8/";
} else {
	dm="../usr/share/man/man8";
} fi;

for i in rc.d.8 rc.8 rc.conf.8 rc.conf.local.8 rc.local.8 rc.subr.8 rc.shutdown.8; do
	grep -i "daemon" $dm/$i > /dev/null 2>&1
	if (test "$?" = "0") then {
		echo $i  >> /var/tmp/inst-adJ.bitacora
		ed $dm/$i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon/service/g
,s/Daemon/Service/g
w
q
EOF
	} fi;
done;


