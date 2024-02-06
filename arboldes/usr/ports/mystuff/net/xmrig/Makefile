# $adJ$

# Port in the public domain.
COMMENT=	"Monero (XMR) CPU miner"

PKGNAME=	xmrig-${VERSION}
CATEGORIES=    	net
VERSION=	6.8.1
REVISION=
DISTNAME=v${VERSION}


MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE=	Yes

DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

GH_TAGNAME=${VERSION}
GH_PROJECT=xmrig
HOMEPAGE=https://github.com/xmrig/xmrig

SITES=https://github.com/xmrig/xmrig/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=v${VERSION}${EXTRACT_SUFX}

BUILD_DEPENDS += devel/cmake www/libmicrohttpd devel/libuv

MODULES += devel/cmake

CONFIGURE_ARGS += -DWITH_ASM=OFF

do-install:
	echo "WRKCONF=${WRKCONF}"
	echo "WRKDIR=${WRKDIR}"
	echo "DESTDIR=${DESTDIR}"
	echo "PREFIX=${PREFIX}"
	echo "BUILDDIR=${BUILDDIR}"
	cp ${WRKCONF}/xmrig ${PREFIX}/bin/
	${INSTALL_PROGRAM} ${WRKCONF}/xmrig ${PREFIX}/bin/xmrig

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/xmrig
	${INSTALL_PROGRAM} ${WRKDIR}/xmrig-2.14.4/src/config.json ${PREFIX}/share/examples/xmrig/config.json

.include <bsd.port.mk>
