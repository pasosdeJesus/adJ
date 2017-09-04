# $OpenBSD$
# This port is released to the public domain
# It is partially based on the port of security/cryptokit

COMMENT=	"library to read and validate XML files from Ocaml"

DISTNAME=	markup-0.2.12
PKGNAME=	${DISTNAME}
REVISION=	4
CATEGORIES=	textproc
HOMEPAGE=	http://ocaml-programming.de/markup/

MASTER_SITES=	http://ocaml-programming.de/markup/
DISTFILES=	${DISTNAME}.tar.gz

MAINTAINER=	Vladimir Támara <vtamara@pasosdeJesus.org>

MODULES	= lang/ocaml

#MIT Style license
PERMIT_PACKAGE_CDROM=	Yes


CONFIGURE_STYLE=	simple 
CONFIGURE_SCRIPT=	conf.sh
CONFIGURE_ARGS+=	-p ${PREFIX}

OCAML_LIBDIR=${PREFIX}/lib/ocaml
FAKE_FLAGS=	INSLIB2=${WRKINST}${OCAML_LIBDIR}

ALL_TARGET=     all ${MODOCAML_NATIVE:S,Yes,opt,:S,No,,}

REGRESS_TARGET=	test

pre-install:
	${INSTALL_DATA_DIR} ${OCAML_LIBDIR}

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/markup
	${INSTALL_DATA} ${WRKBUILD}/doc/manual/html/* ${PREFIX}/share/doc/markup

.include <bsd.port.mk>
