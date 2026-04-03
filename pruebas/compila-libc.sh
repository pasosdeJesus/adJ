#!/bin/sh
# Compila libc
# Dominio Público. 2013. vtamara@pasosdeJesus.org

SRC=/usr/src

cd $SRC/include
make 
if (test "x$SALTAINC" != "x1") then {
  make includes

  if (test "$?" != "0") then {
    exit 1;
  } fi;
} fi;
make install
cd ../lib/libc
#make clean
make depend
make
if (test "$?" != "0") then {
	exit 1;
} fi;
NOMAN=1 make install
