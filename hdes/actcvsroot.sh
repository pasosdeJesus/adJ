#!/bin/sh

. ./ver.sh

d=$1
if (test ! -d "$d") then {
	echo "Primer parametro debe ser directorio donde se actualizar CVSRoot"
	exit 1;
} fi;
if (test "$CVSROOT" = "") then {
	CVSROOT=${USUARIOCVS}@${MAQCVS}:${DIRCVS}
} fi;

echo "CVSROOT=${CVSROOT}" > /tmp/actcvsroot_tmp.sh
find $d -name CVS | sed -e "s/^/echo \${CVSROOT}  > \"/g;s/$/\/Root\"/g" >> /tmp/actcvsroot_tmp.sh
chmod +x /tmp/actcvsroot_tmp.sh
/tmp/actcvsroot_tmp.sh
#for i in `find $d -name CVS `; do 
#	echo ${CVSROOT}  > $i/Root; 
#done 
