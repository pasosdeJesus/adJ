# $adJ$

# Port in the public domain.
COMMENT=	"Miner that uses CPU"

PKGNAME=	xmr-stak-cpu-${VERSION}
CATEGORIES=    	net
VERSION=1.5.1
REVISION=
DISTNAME=v${VERSION}


MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_FTP=	Yes

DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

GH_TAGNAME=v${VERSION}
GH_PROJECT=xmr-stak-cpu
HOMEPAGE=https://github.com/fireice-uk/xmr-stak-cpu
#PKGSPEC = xmr-stak-cpu->=2.0,<2.1

MASTER_SITES=https://github.com/vtamara/xmr-stak-cpu/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=v${VERSION}${EXTRACT_SUFX}

BUILD_DEPENDS += devel/cmake

MODULES += devel/cmake

CONFIGURE_ARGS += -DMICROHTTPD_ENABLE=OFF -DHWLOC_ENABLE=OFF

do-install:
	echo "WRKCONF=${WRKCONF}"
	echo "WRKDIR=${WRKDIR}"
	echo "DESTDIR=${DESTDIR}"
	echo "PREFIX=${PREFIX}"
	echo "BUILDDIR=${BUILDDIR}"
	cp ${WRKCONF}/bin/xmr-stak-cpu ${PREFIX}/bin/
	${INSTALL_PROGRAM} ${WRKCONF}/bin/xmr-stak-cpu ${PREFIX}/bin/xmr-stak-cpu

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/xmr-stak-cpu
	${INSTALL_DATA} ${.CURDIR}/files/xmr-stak-cpu.conf \
		${PREFIX}/share/examples/xmr-stak-cpu/xmr-stak-cpu.conf

.include <bsd.port.mk>
