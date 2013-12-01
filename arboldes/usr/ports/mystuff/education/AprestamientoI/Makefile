# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"worksheets for learning to read and write"

V=		1.0
DISTNAME=	AprestamientoI-${V}
CATEGORIES=    	education

HOMEPAGE=	http://structio.sourceforge.net/escritura
MAINTAINER=	Vladimir Támara <vtamara@pasosdeJesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/}
DISTFILES=	${DISTNAME}.tar.gz



#Public domain
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=    Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=  Yes

do-build:

do-install:
	${INSTALL_DATA_DIR} $(PREFIX)/share/structio/AprestamientoI
	cd ${WRKDIR} && ${INSTALL_DATA} *pdf *png *svg *html $(PREFIX)/share/structio/AprestamientoI

.include <bsd.port.mk>
