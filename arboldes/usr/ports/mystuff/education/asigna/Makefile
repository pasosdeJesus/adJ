# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"timetabling for a school"

V=		1.1
DISTNAME=	asigna-${V}
CATEGORIES=    	education
PKGNAME= 	${DISTNAME}p0

HOMEPAGE=	http://structio.sourceforge.net/asigna
MAINTAINER=	Vladimir Támara <vtamara@pasosdeJesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/}
DISTFILES=	${DISTNAME}.tar.gz



#Public domain
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh

#PREFIX=/

do-regress:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS} check

do-install:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS} instala && ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS} instala-php

.include <bsd.port.mk>
