#!/bin/sh

if (test "$CVSROOT" = "") then {
	CVSROOT=
}

for i in `find . -name CVS `; do 
	echo $i; 
done 
