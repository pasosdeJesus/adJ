# $adJ$
# This port is released to the public domain. 2016

COMMENT=	"Biblesync protocol"

V=		1.1.2
DISTNAME=	biblesync-${V}
CATEGORIES=	textproc misc
REVISION=	1
PKGNAME=	${DISTNAME}
HOMEPAGE=	https://github.com/karlkleinpaste/biblesync
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdejesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=gnomesword/BibleSync/${V}/}
	
DISTFILES=	${DISTNAME}.tar.gz

#Public Domain
PERMIT_PACKAGE_CDROM=	Yes

SHARED_LIBS +=  biblesync                 1.1

WANTLIB=	c m stdc++ 

BUILD_DEPENDS = sysutils/e2fsprogs

do-configure:
	cd ${WRKSRC} && \
	mkdir -p build/adJ && cd build/adJ && \
	cmake -DBUILD_SHARED_LIBS=TRUE -DCMAKE_INSTALL_PREFIX=/usr/local -DLIBDIR=/usr/local/lib/ ../..

do-build:
	cd ${WRKSRC}/build/adJ && make

do-install:
	cd ${WRKSRC}/build/adJ && make install


.include <bsd.port.mk>
