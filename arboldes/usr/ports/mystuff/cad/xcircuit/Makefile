COMMENT =	circuit drawing and schematic capture

BASEVER =	3.10.34
REVISION=0
DISTNAME =	xcircuit-${BASEVER}
CATEGORIES =	cad
HOMEPAGE =	http://opencircuitdesign.com/xcircuit/
MAINTAINER =	Stuart Cassoff <stwo@users.sourceforge.net>

# GPLv2
PERMIT_PACKAGE =	Yes

WANTLIB =	c m pthread z ICE Xt X11 SM Xpm ${MODTK_WANTLIB}

GH_MAIN=master
GH_ACCOUNT=RTimothyEdwards
GH_PROJECT=XCircuit
GH_COMMIT=0056213308c92bec909e8469a0fa1515b72fc3d2


#MASTER_SITES =	${HOMEPAGE:=archive/}
#EXTRACT_SUFX =	.tgz

MODULES =	x11/tk
MODTK_VERSION = 8.6
LIB_DEPENDS =	${MODTK_LIB_DEPENDS} 

USE_GMAKE =	Yes

CONFIGURE_STYLE =	autoconf no-autoheader
AUTOCONF_VERSION =	2.69
CONFIGURE_ARGS +=	--with-tcl=${MODTCL_LIBDIR} \
			--with-tk=${MODTK_LIBDIR}

NO_TEST =	Yes

SUBST_VARS =	BASEVER

CFLAGS   +=	-O0 -g -I/usr/local/include
LDFLAGS   += -lpthread

post-install:
	@cd ${WRKSRC} && ${MAKE} install-man
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/xcircuit
	${INSTALL_DATA} ${WRKSRC}/README* ${PREFIX}/share/doc/xcircuit
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/xcircuit
	${INSTALL_DATA} ${WRKSRC}/examples/*.* \
		${PREFIX}/share/examples/xcircuit
	${INSTALL_DATA} ${WRKSRC}/examples/.xcircuitrc \
		${PREFIX}/share/examples/xcircuit/dot.xcircuitrc

.include <bsd.port.mk>
