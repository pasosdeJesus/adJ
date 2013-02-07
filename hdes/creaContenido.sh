#!/bin/sh
# Actualiza paquetes

. ./ver.sh


echo "s/\[V\]/$V/g"  > rempCont.sed
for i in `grep ".-\[v\]" Contenido$VP$VESP.txt | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[v]\1/g"`; do
	echo -n "$i ";
	n=`echo $i | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[0-9][0-9alphabetrc._]*\1.tgz/g"`
	d=`(cd $V$VESP-$ARQ/paquetes; ls $n; cd ../sivel; ls $n 2>/dev/null | tail -n 1)`
	e=`echo $d | sed -e 's/.tgz//g'`;
	echo $e;
	ic=`echo $i | sed -e 's/\[v\]/\\\\[v\\\\]/g'`;
	echo "s/$ic/$e/g" >> rempCont.sed
done;

sed -f rempCont.sed Contenido$VP$VESP.txt > $V$VESP-$ARQ/Contenido.txt

l=`(cd $V$VESP-$ARQ/paquetes; ls *tgz)`
for i in $l; do 
	n=`echo $i | sed -e "s/-[0-9].*//g"`; 
	grep $n Contenido$VP$VESP.txt > /dev/null ; 
	if (test "$?" != "0") then { 
		echo "En Contenido$VP$VESP.txt falta $n"; 
	} fi; 
done
