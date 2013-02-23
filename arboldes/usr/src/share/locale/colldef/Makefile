
# pull LOCALEDIR and other declarations
.include <bsd.own.mk>

# The contents of this directory is based on FreeBSD

# http://en.wikipedia.org/wiki/List_of_countries_where_Spanish_is_an_official_language
ES_COUNTRIES= ES CO PE VE EC GT CU BO HN PY SV CR PA GQ MX AR CH DO NI UY PR
ENCODINGS= ISO8859-1 ISO8859-15 UTF-8
LOCALES=
.for c in ${ES_COUNTRIES}
.for e in ${ENCODINGS}
LOCALES+= es_${c}.${e}
.endfor
.endfor

all: ${LOCALES:S/$/.out/g}
realall: ${LOCALES:S/$/.out/g}

.SUFFIXES: .src .out

.src.out:
	colldef -I ${.CURDIR} -o ${.TARGET} ${.IMPSRC}

FILES=		${LOCALES:S/$/.out/}

NOMAN=	# defined

.for c in ${ES_COUNTRIES}
.for e in ${ENCODINGS}
es_${c}.${e}.out: es_ES.ISO8859-1.src
	colldef -I ${.CURDIR} -o es_$c.$e.out ${.CURDIR}/es_ES.ISO8859-1.src
.endfor
.endfor


CLEANFILES+=	${LOCALES:S/$/.out/g}


install:
.for locale in ${LOCALES}
	install -o ${LOCALEOWN} -g ${LOCALEGRP} -m ${DIRMODE} -d \
	    ${DESTDIR}${LOCALEDIR}/${locale}
	install -o ${LOCALEOWN} -g ${LOCALEGRP} -m ${LOCALEMODE} \
	    ${locale}.out ${DESTDIR}${LOCALEDIR}/${locale}/LC_COLLATE
.endfor


.include <bsd.prog.mk>
