#!/bin/sh
# Compila libcxx
# Dominio Público. 2024. vtamara@pasosdeJesus.org

SRC=/usr/src/gnu/lib/libcxx

cd $SRC
#make clean
make includes
if (test "$?" != "0") then {
	exit 1;
} fi;
make depend
if (test "$?" != "0") then {
	exit 1;
} fi;
make
if (test "$?" != "0") then {
	exit 1;
} fi;
make install
