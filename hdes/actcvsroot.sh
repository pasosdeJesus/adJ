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

for i in `find $d -name CVS `; do 
	echo ${CVSROOT}  > $i/Root; 
done 
