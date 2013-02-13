#!/bin/sh
# Cuenta IPs en una bitacora
# Dominio publico de acuerdo a legislacion colombiana.
# vtamara@pasosdeJesus.org. 2013

a="$1";
if (test "$a" = "") then {
	echo "Falta bitácora como primer parametro";
	exit 1;
} fi;

sed -e "s/\([0-9][0-9]*\.[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\).*/\1/g" $a > /tmp/ips
sort -u /tmp/ips > /tmp/ipsord
for i in `cat /tmp/ipsord`; do 
	echo -n "$i : ";
	grep "$i" $a | wc -l
done;
