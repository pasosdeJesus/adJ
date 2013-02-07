#!/bin/sh

. ./ver.sh

cdir=`pwd`
if (test "$psivelInstSivel" = "s") then {
	echo "Preparando inst-adJ.sh e inst-sivel.sh";
	mkdir -p /tmp/i/usr/src/etc
	rm -rf /tmp/i/*
	cp inst-adJ$VP$VESP.sh /tmp/i/inst-adJ.sh
	cp inst-sivel$VP$VESP.sh /tmp/i/inst-sivel.sh
	mkdir -p /tmp/i/usr/src/etc/
	cp /usr/src/etc/Makefile  /tmp/i/usr/src/etc/
	d=`pwd`
	(cd /tmp/i ; tar cvfz $d/$V-$ARQ/site$VP.tgz .)
} fi;

