#!/bin/sh
#Evaluación parcial de mensajes
#Dominio público. 2009. vtamara@pasosdeJesus.org

. ../ver.sh

DLENG=$1
if (test "X$DLENG" = "X") then {
	DLENG=en;
} fi;

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-lang.sh > /tmp/install-lang-inst.sh

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-amd64-lang.md > /tmp/install-amd64-lang-inst.sh

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-i386-lang.md > /tmp/install-i386-lang-inst.sh

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" install-lang.sub > /tmp/install-sub-inst.sh

sed -e "s/\\\\/\\\\\\\\/g;s/\\\\n/\\\\\\\\n/g;s/\(\$[^_]\)/\\\\\1/g;s/\(\$_[^s]\)/\\\\\1/g;s/\(\$_s[^l]\)/\\\\\1/g;s/\`/\\\\\`/g;s/\"/\\\\\"/g;s/\(.*\)/echo \"\1\"/g" upgrade-lang.sh > /tmp/upgrade-lang-inst.sh


. ./install-$DLENG

. /tmp/install-lang-inst.sh > install-$DLENG.sh
. /tmp/install-sub-inst.sh > install-$DLENG.sub
. /tmp/upgrade-lang-inst.sh > upgrade-$DLENG.sh
. /tmp/install-amd64-lang-inst.sh > install-amd64-$DLENG.md
. /tmp/install-i386-lang-inst.sh > install-i386-$DLENG.md

