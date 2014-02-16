#!/bin/sh
# Renombra daemon por servicio en diversos servicios de un directorio etc en adJ
# Dominio público de acuerdo a legislación colombiana. 2012. vtamara@pasosdeJesus.org



echo "Renombra bitacoras, suponemos que sistema base fue compilado con facilidad servicio"  >> /var/tmp/inst-adJ.bitacora
# syslog
grep ".var.log.daemon" /etc/syslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando daemon por servicio en /etc/syslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/syslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/daemon
,s/daemon.info\([^;].*\)\/var/daemon.info;servicio.info\1\/var/g
,s/\/var\/log\/daemon/\/var\/log\/servicio/g
,s/\/var\/log\/service/\/var\/log\/servicio/g
w
q
EOF
} fi;
grep ".var.log.service" /etc/syslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando service por servicio en /etc/syslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/syslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
} fi;


grep ".var.log.daemon" /etc/newsyslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando por servicio en /etc/newsyslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/newsyslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/daemon
s/var\/log\/daemon/var\/log\/servicio/g
w
q
EOF
} fi;
grep ".var.log.service" /etc/newsyslog.conf > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Cambiando por servicio en /etc/newsyslog.conf"  >> /var/tmp/inst-adJ.bitacora
	ed /etc/newsyslog.conf  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/service
s/var\/log\/service/var\/log\/servicio/g
w
q
EOF
} fi;


echo "Archivos de etc en general exceptuando casos especiales de compatibilidad"  >> /var/tmp/inst-adJ.bitacora
l=`find . -exec grep -l "daemon" {} ';' | grep -v "login.conf" | grep -v "group" | grep -v "passwd" | grep -v "pwd.db" | grep -v "syslog.conf" | grep -v "rc.subr" | grep -v "mail/aliases" | grep -v "mail/.*cf" | grep -v "Xsetup_0" | grep -v "dbus-1/system.conf" | grep -v "rc.conf.local" | grep -v "rc.local" | grep -v "rc.d/" | grep -v "php-fpm.conf" | grep -v Makefile`
echo "l=$l" >> /var/tmp/inst-adJ.bitacora 
for i in $l; do 
	echo $i  >> /var/tmp/inst-adJ.bitacora
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon/servicio/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/etc\/servicios/etc\/services/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Servicio/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Service/Servicio/g
w
q
EOF
done;
echo "Archivos de etc con service en general exceptuando casos especiales de compatibilidad"  >> /var/tmp/inst-adJ.bitacora
l=`find . -exec grep -l "service" {} ';' | grep -v "changelist" | grep -v "esd.conf" | grep -v "inetd.conf" | grep -v "pwd.db" | grep -v "php-*.ini" | grep -v "rc.subr" | grep -v "rc.d/" | grep -v "services" | grep -v Makefile`
echo "l=$l" >> /var/tmp/inst-adJ.bitacora 
for i in $l; do 
	echo $i  >> /var/tmp/inst-adJ.bitacora
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/etc\/servicios/etc\/services/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Service/Servicio/g
w
q
EOF
	ed $i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/\/etc\/servicios/\/etc\/services/g
w
q
EOF
done;

echo "Archivos de etc/rc.d"  >> /var/tmp/inst-adJ.bitacora
# No cambiamos todos porque los instalados por paquetes tendran problemas cuando se quiera desinstalar el paquete por la suma cambiada.
l=`cd rc.d ; ls | grep -v daemon | grep -v rc.subr`
echo "l=$l" >> /var/tmp/inst-adJ.bitacora 
for i in $l; do 
	echo rc.d/$i  >> /var/tmp/inst-adJ.bitacora
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/^ *daemon *=/servicio=/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/^ *service *=/servicio=/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/^ *daemon_flags *=/servicio_flags=/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service_flags/servicio_flags/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/{daemon}/{servicio}/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/{service}/{servicio}/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/{daemon_flags}/{servicio_flags}/g
w
q
EOF
	ed rc.d/$i >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/{service_flags}/{servicio_flags}/g
w
q
EOF

done;

echo "Particularidades de rc.subr"  >> /var/tmp/inst-adJ.bitacora
if (test -f "rc.d/rc.subr") then {
	grep "daemon_user.*servicio_user" rc.d/rc.subr > /dev/null 2>&1
	if (test "$?" = "1") then {
		grep "daemon_user.*service_user" rc.d/rc.subr > /dev/null 2>&1
		if (test "$?" = "0") then {
			ed rc.d/rc.subr >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
			ed rc.d/rc.subr  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/daemon_class.*servicio_class
a

[ ! -z "\${service}"  ] && servicio=\${service}
[ ! -z "\${service_user}"  ] && servicio_user=\${service_user}
[ ! -z "\${service_flags}"  ] && servicio_flags=\${service_flags}
[ ! -z "\${service_class}"  ] && servicio_class=\${service_class}

.
w
q
EOF
		} else {
			ed rc.d/rc.subr >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon/servicio/g
w
q
EOF
			ed rc.d/rc.subr >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Servicio/g
w
q
EOF
			ed rc.d/rc.subr  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/servicio is not set
i
# Compatibilidad con formato anterior 
[ ! -z "\${daemon}"  ] && servicio=\${daemon}
[ ! -z "\${daemon_user}"  ] && servicio_user=\${daemon_user}
[ ! -z "\${daemon_flags}"  ] && servicio_flags=\${daemon_flags}
[ ! -z "\${daemon_class}"  ] && servicio_class=\${daemon_class}

.
w
q
EOF
		} fi;
	} fi;
} fi;


echo "Particularidades de login.conf"  >> /var/tmp/inst-adJ.bitacora
for i in login.conf login.conf.in; do
	echo $i >> /var/tmp/inst-adJ.bitacora
	grep "^servicio:" $i > /dev/null 2>&1
	if (test -f $i -a "$?" != "0") then {
		grep "^service:" $i /dev/null 2>&1
		if (test "$?" = "0") then {
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
		} else {
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^daemon:
-
.,+8t.
/^daemon:
s/daemon/servicio/g
i

.
w
q
EOF
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/daemon\([^:]\)/servicio\1/g
w
q
EOF
		} fi;
		cap_mkdb /etc/login.conf
	} fi;
done;

echo "Particularidades de usuario y grupo"  >> /var/tmp/inst-adJ.bitacora
for i in group master.passwd mail/aliases; do
	grep "^servicio:" $i > /dev/null 2>&1
	if (test "$?" != "0") then {
		echo $i  >> /var/tmp/inst-adJ.bitacora
		grep "^service:" $i /dev/null 2>&1
		if (test "$?" = "0") then {
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Service/Servicio/g
w
q
EOF
		}  else {
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^daemon:
.t.
-
.s/daemon/servicio/g
w
q
EOF
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/devil/servicio/g
w
q
EOF
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/:daemon/:servicio/g
w
q
EOF
			ed $i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Servicio/g
w
q
EOF
		} fi; 
	} fi; done;
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
,s/daemon/servicio/g
w
q
EOF
		ed $dm/$i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/service/servicio/g
w
q
EOF
		ed $dm/$i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Daemon/Servicio/g
w
q
EOF


		ed $dm/$i  >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
,s/Service/Servicio/g
w
q
EOF


	} fi;
done;


