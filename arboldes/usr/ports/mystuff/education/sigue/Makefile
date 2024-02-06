# $OpenBSD$
# This port is released to the public domain.
#
COMMENT=	"to track progress of students and generate reports"

V=		1.2
DISTNAME=	sigue-${V}
CATEGORIES=    	education
REVISION=	5
PKGNAME=	${DISTNAME}


HOMEPAGE=	http://structio.sourceforge.net/sigue
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

SITES=	${SITE_SOURCEFORGE:=structio/}
SITES.a=	${HOMEPAGE}/
DISTFILES=	${DISTNAME}.tar.gz

#Public domain
PERMIT_PACKAGE=	Yes

CONFIGURE_STYLE=	simple 
CONFIGURE_SCRIPT=	conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=	lang/ocaml textproc/markup education/repasa print/texlive/base lang/ocaml-camlp4 devel/ocaml-ocamlbuild
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
