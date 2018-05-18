# $OpenBSD$
# This port is released to the public domain. 2004.
#
COMMENT=	"creation and study of contents for schools"

V=		1.4
DISTNAME=	repasa-${V}
REVISION=	7
CATEGORIES=    	education

HOMEPAGE=	http://structio.sourceforge.net/repasa
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdejesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/}
MASTER_SITES0=	${HOMEPAGE}/
DISTFILES=	${DISTNAME}.tar.gz

#Public domain
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE=	simple 
CONFIGURE_SCRIPT=	conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=	lang/ocaml lang/ocaml-labltk x11/tk/8.5 textproc/markup print/texlive/base lang/ocaml-camlp4 devel/ocaml-ocamlbuild
RUN_DEPENDS=	textproc/markup x11/tk/8.5

FAKE_TARGET=	instala-sin-catalogo-opt
FAKE_FLAGS=	PREFIX=${WRKINST}${PREFIX}

ALL_TARGET=	opt usrdoc
REGRESS_TARGET=	regr

WANTLIB=	X11 c m tk85 tcl85

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/repasa
	${INSTALL_DATA} ${WRKBUILD}/doc/usuario/html/* ${PREFIX}/share/doc/repasa

do-regress:
	cd ${WRKSRC}/regr && ./test.sh -opt

.include <bsd.port.mk>
