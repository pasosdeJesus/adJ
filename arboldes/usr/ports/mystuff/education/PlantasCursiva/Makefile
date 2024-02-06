# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"worksheets for learning to write with cursive font"

V=		1.0
REVISION=	1
DISTNAME=	PlantasCursiva-${V}
CATEGORIES=    	education

HOMEPAGE=	http://structio.sourceforge.net/escritura
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

SITES=	${SITE_SOURCEFORGE:=structio/}
DISTFILES=	plantas_cursiva-${V}.tar.gz



#Public domain
PERMIT_PACKAGE=	Yes

do-build:

do-install:
	${INSTALL_DATA_DIR} $(PREFIX)/share/structio/PlantasCursiva
	cd ${WRKDIR} && ${INSTALL_DATA} *pdf *png *svg *html $(PREFIX)/share/structio/PlantasCursiva

.include <bsd.port.mk>
