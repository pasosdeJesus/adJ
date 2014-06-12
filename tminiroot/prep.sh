. ../ver.sh

VPM=`expr $VP - 1`
cp /usr/src/distrib/miniroot/install.sh install.sh
cp /usr/src/distrib/miniroot/install.sub install.sub
cp /usr/src/distrib/miniroot/upgrade.sh upgrade.sh
cp /usr/src/distrib/amd64/common/install.md install-amd64.md

for a in install upgrade; do
	git diff -u $a.sh > /tmp/d
	echo "Editar $a-lang.sh para incluir cambios que se mostrarán";
	echo "RETORNO para continuar";
	read
	less /tmp/d
done

git diff -u install.sub > /tmp/d
echo "Editar install-lang.sub para incluir cambios por mostrar";
echo "RETORNO para continuar";
read
less /tmp/d

git diff -u install-amd64.md  > /tmp/d
echo "Editar install-amd64-lang.md para incluir cambios mostrados";
echo "RETORNO para continuar";
read
less /tmp/d
