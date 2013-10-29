# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"worksheets for learning to write with cursive font"

V=		1.0
DISTNAME=	NombresCursiva-${V}
CATEGORIES=    	education

HOMEPAGE=	http://structio.sourceforge.net/escritura
MAINTAINER=	Vladimir Támara <vtamara@pasosdeJesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/}
DISTFILES=	nombres_cursiva-${V}.tar.gz



#Public domain
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_FTP=	Yes

do-build:

do-install:
	mkdir -p $(PREFIX)/share/structio/nombrescursiva
	cd ${WRKDIR} && cp *pdf *png *svg *html $(PREFIX)/share/structio/nombrescursiva

.include <bsd.port.mk>
