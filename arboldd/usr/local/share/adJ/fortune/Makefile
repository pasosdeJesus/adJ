
STRFILE= /usr/src/games/fortune/strfile/strfile versiculos versiculos.dat

all: versiculos.dat

versiculos.dat: versiculos
	${STRFILE} -s ${.CURDIR}/${.TARGET:R} ${.TARGET}

