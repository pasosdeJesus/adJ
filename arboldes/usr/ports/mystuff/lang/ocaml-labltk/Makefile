# $adJ$

# Port in the public domain.
# Ideas from https://www.freshports.org/x11-toolkits/ocaml-labltk/

COMMENT=	"Interface to the Tcl/Tk GUI framework"
VERSION=	8.06.10
REVISION=	

PKGNAME=	ocaml-labltk-${VERSION}
DISTNAME=	labltk-${VERSION}
CATEGORIES=	lang


MASTER_SITES=	https://github.com/garrigue/labltk/archive/
DISTFILES=	${VERSION}${EXTRACT_SUFX}
EXTRACT_SUFX=	.tar.gz

HOMEPAGE=	https://garrigue.github.io/labltk/
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

MODULES=	lang/ocaml

PERMIT_PACKAGE=   Yes

CONFIGURE_STYLE=        simple dest  
CONFIGURE_ARGS+=-installdir ${DESTDIR}${TRUEPREFIX}/lib/ocaml/labltk
CONFIGURE_ARGS+=-installbindir ${DESTDIR}${TRUEPREFIX}/bin
CONFIGURE_ENV+=OPENBSD_LOCALBASE="${LOCALBASE}"

USE_GMAKE=	Yes

BUILD_DEPENDS +=        lang/ocaml
RUN_DEPENDS-graphics += lang/ocaml
LIB_DEPENDS-tk=		tk->=8.5:x11/tk/8.5
WANTLIB-main =          c tk85

ALL_TARGET=     all ${MODOCAML_NATIVE:S,Yes,opt,:S,No,,}

pre-patch:
	echo ${WRKDIST}
	ln -s `dirname ${WRKDIST}`/labltk-8.06.0 ${WRKDIST}
	#ln -s ${WKRDIST} 

.include <bsd.port.mk>
