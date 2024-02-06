# $adJ$
# This port is released to the public domain. 2016

COMMENT=	"Biblesync protocol"

V=		2.0.1
#V=		1.2.0
DISTNAME=	biblesync-${V}
CATEGORIES=	textproc misc
REVISION=	1
PKGNAME=	${DISTNAME}
HOMEPAGE=	https://github.com/karlkleinpaste/biblesync
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdejesus.org>
GH_PROJECT=	biblesync
GH_ACCOUNT=	karlkleinpaste
GH_TAGNAME=	${V}
	
DISTFILES=	${DISTNAME}.tar.gz

#Public Domain
PERMIT_PACKAGE=	Yes

SHARED_LIBS +=  biblesync                 2.0

WANTLIB=	c m 

BUILD_DEPENDS = sysutils/e2fsprogs devel/cmake

COMPILER=base-clang
CXX=clang++

do-configure:
	cd ${WRKSRC} && \
	mkdir -p build/adJ && cd build/adJ && \
	CXX=${CXX} cmake -DBUILD_SHARED_LIBS=TRUE -DCMAKE_INSTALL_PREFIX=/usr/local -DLIBDIR=/usr/local/lib/ ../..

do-build:
	cd ${WRKSRC}/build/adJ && make

do-install:
	cd ${WRKSRC}/build/adJ && make install


.include <bsd.port.mk>
