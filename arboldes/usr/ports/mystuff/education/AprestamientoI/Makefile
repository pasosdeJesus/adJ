# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"worksheets for learning to read and write"

V=		1.0
REVISION=	1
DISTNAME=	AprestamientoI-${V}
CATEGORIES=    	education

HOMEPAGE=	http://structio.sourceforge.net/escritura
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

SITES=	${SITE_SOURCEFORGE:=structio/}
DISTFILES=	${DISTNAME}.tar.gz



#Public domain
PERMIT_PACKAGE=	Yes

do-build:

do-install:
	${INSTALL_DATA_DIR} $(PREFIX)/share/structio/AprestamientoI
	cd ${WRKDIR} && ${INSTALL_DATA} *pdf *png *svg *html $(PREFIX)/share/structio/AprestamientoI

.include <bsd.port.mk>
