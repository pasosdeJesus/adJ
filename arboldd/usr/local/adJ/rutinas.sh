#!/bin/sh
# Rutinas utiles en OpenBSD adJ
# Dominio público. vtamara@pasosdeJesus.org. 2012

# Agrega un servicio de /etc/rc.d en /etc/rc.conf.local
function activarcs {
	ns=$1;
	if (test "$ns" = "") then {
		echo "Falta nombre de servicio como primer parametro en activarcs";
		exit 1;
	} fi;
	if (test ! -f "/etc/rc.d/$ns") then {
		echo "En /etc/rc.d falta servicio de nombre $ns" 
		exit 1;
	} fi;
	echo "activando $ns" >> /var/tmp/inst-adJ.bitacora 2>&1 
	grep "^ *pkg_scripts.*[^a-zA-Z0-9_]$ns[^a-zA-Z0-9_]" /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 
	if (test "$?" != "0") then {
		echo "No  hay pkg_scripts con $ns"  >> /var/tmp/inst-adJ.bitacora 2>&1 
		grep "^ *pkg_script" /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 
		if (test "$?" != "0") then {
			echo "No hay pkg_script" >> /var/tmp/inst-adJ.bitacora 2>&1 
			ed /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
$
a
pkg_scripts="$ns"
.
w
q
EOF
		} else {
			cs=`grep "^ *pkg_scripts *=" /etc/rc.conf.local | sed -e "s/pkg_scripts *= *\"\([^\"]*\)\".*/\1/g"`
			if (test "$cs" != "") then {
				cs="$cs $ns";
			} else {
				cs=$ns;
			} fi;
			echo "cs=$cs" >> /var/tmp/inst-adJ.bitacora 2>&1 
			ed /etc/rc.conf.local >> /var/tmp/inst-adJ.bitacora 2>&1 <<EOF
/^ *pkg_scripts *=
.c
pkg_scripts="$cs"
.
w
q
EOF
		} fi;
	} else  {
		echo "Activo" >> /var/tmp/inst-adJ.bitacora 2>&1 
	} fi;
} 


# Presenta un mensaje y termina
function die {
	echo $1;
	exit 1;
}


# Instala un paquete y opcionalmente otro 
function insacp {
n=$1;
popc=$2;
pre=$3;
if (test "$n" = "") then {
	echo "insacp: Falta nombre de paquete";
	exit 1;
} fi;
echo "* Instalar $n"  >> /var/tmp/inst-adJ.bitacora;
opbor="";
f=`ls /var/db/pkg/$n-* 2> /dev/null > /dev/null`;
if (test "$?" = "0") then {
	echo "$n instalado. Intentando remplazar " >> /var/tmp/inst-adJ.bitacora
	opbor="-r -D update -D updatedepends"
} fi;

pkg_add $opbor $PKG_PATH/$n-[0-9]*.tgz >> /var/tmp/inst-adJ.bitacora 2>&1
if (test "$popc" != "") then {
	pkg_add $opbor $PKG_PATH/${popc}*.tgz >> /var/tmp/inst-adJ.bitacora 2>&1
} fi;
}

