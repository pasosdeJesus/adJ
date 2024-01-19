# $OpenBSD: Makefile,v 1.1.1.1 2011/07/19 09:16:06 jasper Exp $

COMMENT=	Tipos de letra para aprender a leer y escribir

V=1.1
PKGNAME=	TiposLectoEscritura-$V
DISTNAME=	TiposLectoescritura-$V
REVISION=	2
CATEGORIES=	fonts

HOMEPAGE=	http://structio.sourceforge.net/
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE=	Yes
NO_BUILD=	Yes
NO_TEST=	Yes

WRKDIST=	${WRKDIR}
DIRTIPOS=	${PREFIX}/share/fonts/structio


SITES=	${SITE_SOURCEFORGE:=structio/TiposLectoescritura/}
EXTRACT_SUFX=	.tar.gz
DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

do-install:
	${INSTALL_DATA_DIR} ${DIRTIPOS}
	${INSTALL_DATA} ${WRKDIST}/*.{ttf,sfd} ${DIRTIPOS} 

.include <bsd.port.mk>
