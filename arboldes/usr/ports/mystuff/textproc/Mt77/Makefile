# $adJ$

# Porte de dominio público

COMMENT=	"Search engine, fast and precise"

VERSION=1.0a6
REVISION= 
DISTNAME=v${VERSION}
CATEGORIES=     textproc
PKGNAME=Mt77-${VERSION}
GH_TAGNAME=v${VERSION}
GH_PROJECT=Mt77

HOMEPAGE=https://www.pasosdejesus.org/Mt77/
PKGSPEC = Mt77->=1.0,<1.1
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

SITES=https://gitlab.com/pasosdeJesus/Mt77/-/archive/
#EXTRACT_SUFX=.tar.gz
#DCOMP ?=${DISTNAME}
#WRKSRC = ${PKGNAME}
TEST_TARGET = regr
#Public domain
PERMIT_PACKAGE=   	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh

prueba:
	echo ${WRKCONF}
do-regress:
	echo "Intentando en ${WRKSRC}";
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS} regr

pre-patch:
	pwd
	echo "WRKDIR=${WRKDIR}"
	mv -f ${WRKDIR}/Mt77-v1.0a6* ${WRKDIR}/Mt77-1.0a6/

do-install:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} DESTDIR=${DESTDIR} ${MAKE_PROGRAM} ${MAKE_FLAGS} instala 


.include <bsd.port.mk>
