
STRFILE= /usr/src/games/fortune/strfile/obj/strfile versiculos versiculos.dat

all: versiculos.dat

versiculos.dat: versiculos
	${STRFILE} -s ${.CURDIR}/${.TARGET:R} ${.TARGET}

