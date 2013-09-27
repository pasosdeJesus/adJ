#!/bin/sh
# Ayuda a mantener actualizado reflejo de una zona
# Dominio publico. 2013. vtamara@pasosdeJesus.org
# Agradecimientos a www.sofhouse.net

d=$1
if (test "$d" = "") then {
	echo "primer parametro deberia ser zona";
	exit 1;
} fi;	

ext_ip=`grep ext_ip /etc/pf.conf | sed -e "s/.*ext_ip *=[^0-9]*\([0-9]*.[0-9]*.[0-9]*.[0-9]*\).*/\1/g"`
if (test "$ext_ip" = "") then {
	echo "No hay variable ext_ip con IP externa en /etc/pf.conf";
	exit 1;
} fi;
echo "IP Externa: $ext_ip";
int_ip=`grep int_ip /etc/pf.conf | sed -e "s/.*int_ip *=[^0-9]*\([0-9]*.[0-9]*.[0-9]*.[0-9]*\).*/\1/g"`
if (test "$int_ip" = "") then {
	echo "No hay variable int_ip con IP interna en /etc/pf.conf";
	exit 1;
} fi;
echo "IP Interna: $int_ip";
ns=`mktemp`
nr=`mktemp`
echo "[ENTER] para continuar";
read

tr "\t" " " < $d | sed -e "s/   */ /g;s/$ext_ip/$int_ip/g" > $ns
if (test ! -f ../refleja/$d) then {
	cp $ns ../refleja/$d;
} fi;
tr "\t" " " < ../refleja/$d | sed -e "s/   */ /g" > $nr
nt=`mktemp`
grep -i " IN A " $ns | grep -v "\*" | grep -v "^ *;" | sed -e "s/ /|/g" > $nt
for i in `cat $nt`; do
	s=`echo $i | sed -e "s/\(^.*\)|IN|A.*/\1/g;s/|/ /g"`
	ptr=`echo $s | sed -e "s/^db\.[0-9].*/si/g"`
	ic=`echo $i | sed -e "s/|/ /g"`
	if (test "$ptr" != "si") then {
		grep "$s " $nr > /dev/null
		if (test "$?" != "0") then {
			echo "[ENTER] para agregar '$ic' a ../refleja/$d ($nr)";
			read
			echo "$ic" >> ../refleja/$d		
		} fi;
	} fi;
done
chmod a+r ../refleja/$d
