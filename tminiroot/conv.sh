#!/bin/sh
#Evaluación parcial de mensajes
#Dominio público. 2009. vtamara@pasosdeJesus.org

. ../ver.sh

DLENG=$1
if (test "X$DLENG" = "X") then {
	DLENG=en;
} fi;

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-amd64-lang.md > /tmp/install-amd64-lang-inst.sh

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-lang.sub > /tmp/install-sub-inst.sh

sed -e "s/á/a/g;s/é/e/g;s/í/i/g;s/ó/o/g;s/ú/u/g;s/Á/A/g;s/É/E/g;s/Í/I/g;s/Ó/O/g;s/Ú/U/g;s/ü/u/g;s/Ü/U/g;s/¿//g;s/¡//g" install-$DLENG > install-$DLENG-sinacentos
. ./install-$DLENG-sinacentos

echo "1";
. /tmp/install-sub-inst.sh > install-$DLENG.sub
echo "2";
. /tmp/install-amd64-lang-inst.sh > install-amd64-$DLENG.md

