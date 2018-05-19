# $adJ$

# Port in the public domain.
COMMENT=	"Miner that uses CPU"

PKGNAME=	xmr-stak-${VERSION}
CATEGORIES=    	net
VERSION=	2.4.3
REVISION=
DISTNAME=v${VERSION}


MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_FTP=	Yes

DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

GH_TAGNAME=${VERSION}
GH_PROJECT=xmr-stak
HOMEPAGE=https://github.com/fireice-uk/xmr-stak
#PKGSPEC = xmr-stak->=2.0,<2.1

MASTER_SITES=https://github.com/fireice-uk/xmr-stak/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=${VERSION}${EXTRACT_SUFX}

BUILD_DEPENDS += devel/cmake

MODULES += devel/cmake

CONFIGURE_ARGS += -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DMICROHTTPD_ENABLE=OFF -DHWLOC_ENABLE=OFF

do-install:
	echo "WRKCONF=${WRKCONF}"
	echo "WRKDIR=${WRKDIR}"
	echo "DESTDIR=${DESTDIR}"
	echo "PREFIX=${PREFIX}"
	echo "BUILDDIR=${BUILDDIR}"
	cp ${WRKCONF}/bin/xmr-stak ${PREFIX}/bin/
	${INSTALL_PROGRAM} ${WRKCONF}/bin/xmr-stak ${PREFIX}/bin/xmr-stak

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/xmr-stak
	${INSTALL_DATA} ${.CURDIR}/files/xmr-stak.conf \
		${PREFIX}/share/examples/xmr-stak/xmr-stak.conf

.include <bsd.port.mk>
