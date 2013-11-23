# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"to track progress of students and generate reports"

V=		1.2
DISTNAME=	sigue-${V}
CATEGORIES=    	education
PKGNAME=	${DISTNAME}p1


HOMEPAGE=	http://structio.sourceforge.net/sigue
MAINTAINER=	Vladimir Támara <vtamara@pasosdeJesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/}
MASTER_SITES0=	${HOMEPAGE}/
DISTFILES=	${DISTNAME}.tar.gz

#Public domain
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE=	simple 
CONFIGURE_SCRIPT=	conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=	lang/ocaml textproc/markup education/repasa
RUN_DEPENDS=	textproc/markup education/repasa

FAKE_TARGET=	instala-sin-catalogo-opt
FAKE_FLAGS=	PREFIX=${WRKINST}${PREFIX}

ALL_TARGET=	opt usrdoc

REGRESS_TARGET=regr

WANTLIB=	c m

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/sigue
	${INSTALL_DATA} ${WRKBUILD}/doc/usuario/html/* ${PREFIX}/share/doc/sigue

do-regress:
	cd ${WRKSRC}/regr && ./test.sh -opt

.include <bsd.port.mk>
