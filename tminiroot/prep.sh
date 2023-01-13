. ../ver.sh

VPM=`expr $VP - 1`
cp /usr/src/distrib/miniroot/install.sub install.sub
cp /usr/src/distrib/amd64/common/install.md install-amd64.md

git diff -u install.sub > /tmp/d
echo "Editar install-lang.sub para incluir cambios por mostrar";
echo "RETORNO para continuar";
ls -l /tmp/d
read
vim /tmp/d

git diff -u install-amd64.md  > /tmp/d
echo "Editar install-amd64-lang.md para incluir cambios por mostrar";
echo "RETORNO para continuar";
read
vim /tmp/d
