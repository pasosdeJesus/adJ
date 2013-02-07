. ../ver.sh

VPM=`expr $VP - 1`
cp /usr/src/distrib/miniroot/install.sh install.sh
cp /usr/src/distrib/miniroot/install.sub install.sub
cp /usr/src/distrib/miniroot/upgrade.sh upgrade.sh
cp /usr/src/distrib/amd64/common/install.md install-amd64.md
cp /usr/src/distrib/i386/common/install.md install-i386.md

for a in install upgrade; do
	cvs diff -u $a.sh
	echo "Editar $a-lang.sh para incluir cambios mostrados";
	echo "RETORNO para continuar";
	read
done

if (test ! -f install-lang.sub) then {
	cvs diff -u install.sub
	echo "Editar install-lang.sub para incluir cambios mostrados";
	echo "RETORNO para continuar";
	read
} fi;
for a in install-amd64 install-i386; do
	cvs diff -u $a.md 
	echo "Editar $a-lang.md para incluir cambios mostrados";
	echo "RETORNO para continuar";
	read
done;
