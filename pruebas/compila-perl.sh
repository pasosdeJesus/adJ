#!/bin/sh
# Compila libcxx
# Dominio Público. 2024. vtamara@pasosdeJesus.org

SRC=/usr/src/gnu/usr.bin/perl

cd $SRC
LANG=C make -f Makefile.bsd-wrapper clean
if (test "$?" != "0") then {
	exit 1;
} fi;
LANG=C make -f Makefile.bsd-wrapper depend
if (test "$?" != "0") then {
	exit 1;
} fi;
LANG=C make -f Makefile.bsd-wrapper 
if (test "$?" != "0") then {
	exit 1;
} fi;
LANG=C make -f Makefile.bsd-wrapper install
if (test "$?" != "0") then {
	exit 1;
} fi;
