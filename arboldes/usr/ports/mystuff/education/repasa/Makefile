# $OpenBSD$
# This port is released to the public domain. 2004.
#
COMMENT=	"creation and study of contents for schools"

V=		1.4
DISTNAME=	repasa-${V}
CATEGORIES=    	education
PKGNAME=    	${DISTNAME}p1

HOMEPAGE=	http://structio.sourceforge.net/repasa
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdejesus.org>

#Public domain
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE=	simple 
CONFIGURE_SCRIPT=	conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=	lang/ocaml textproc/markup
RUN_DEPENDS=	textproc/markup

FAKE_TARGET=	instala-sin-catalogo-opt
FAKE_FLAGS=	PREFIX=${WRKINST}${PREFIX}

ALL_TARGET=	opt usrdoc
REGRESS_TARGET=	regr

WANTLIB=	X11 c m 

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/repasa
	${INSTALL_DATA} ${WRKBUILD}/doc/usuario/html/* ${PREFIX}/share/doc/repasa

do-regress:
	cd ${WRKSRC}/regr && ./test.sh -opt

.include <bsd.port.mk>
