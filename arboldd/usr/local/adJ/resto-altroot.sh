#!/bin/sh
# Copia con rsync particiones montables en /altroot

pasoapaso=0

function ejord {
	echo "$ord"
	if (test "$pasoapaso" = "1") then {
		echo "ENTER para confirmar"
		read
	} fi;
	eval "$ord"
};

for i in `grep "altroot\/[^ \t]" /etc/fstab | sed -e "s/^\([^ ]*\) \([^ ]*\) .*/\1|\2/g"`; do
	echo $i;
	d=`echo $i | sed -e "s/|.*//g"`
	p=`echo $i | sed -e "s/.*|//g"`
	o=`echo $p | sed -e "s/^\/altroot//g"`
	echo "d=$d, p=$p, o=$o"
	ord="/sbin/umount \"$d\""
	ejord	
    	ord="/sbin/fsck -y \"$d\""
	ejord
    	ord="/sbin/mount $d $p"
	ejord
done

for i in `grep "altroot\/[^ \t]" /etc/fstab | sed -e "s/^\([^ ]*\) \([^ ]*\) .*/\1|\2/g"`; do
	ord="/usr/local/bin/rsync -ravzp $o/* /altroot$o/"
	ejord
done
