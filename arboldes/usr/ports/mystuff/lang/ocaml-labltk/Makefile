# $adJ$

# Port in the public domain.
# Ideas from https://www.freshports.org/x11-toolkits/ocaml-labltk/

COMMENT=	"Interface to the Tcl/Tk GUI framework"
VERSION=	8.06.2
REVISION=	1

PKGNAME=	ocaml-labltk-${VERSION}
DISTNAME=	labltk-${VERSION}
CATEGORIES=	lang

MASTER_SITES=	http://forge.ocamlcore.org/frs/download.php/1455/
EXTRACT_SUFX=	.tar.gz

HOMEPAGE=	https://forge.ocamlcore.org/projects/labltk/
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

MODULES=	lang/ocaml

PERMIT_PACKAGE_CDROM=   Yes

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
