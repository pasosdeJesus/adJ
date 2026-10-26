# $OpenBSD$
# This port is released to the public domain. 2020

COMMENT=	"Open source Bible study tool"

GH_ACCOUNT =	bibletime
GH_PROJECT =	bibletime
GH_TAGNAME =	v3.0.3

CATEGORIES=	textproc misc
HOMEPAGE=	https://bibletime.info/
MAINTAINER=	Vladimir Tamara Patino <vtamara@pasosdejesus.org>

# GPLv2
PERMIT_PACKAGE=	Yes

MODULES +=	devel/cmake \
		x11/qt5

BUILD_DEPENDS += textproc/sword \
		 textproc/clucene

RUN_DEPENDS =	textproc/sword

LIB_DEPENDS +=	x11/qt5/qtdeclarative \
		x11/qt5/qtsvg \
		textproc/clucene

WANTLIB +=	clucene-core Qt5Core Qt5Gui Qt5Widgets Qt5Xml Qt5Network \
		Qt5PrintSupport Qt5Qml Qt5Quick Qt5QuickWidgets Qt5Svg

CXXFLAGS +=	-std=c++11

CONFIGURE_ARGS +=	-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib/qt5/cmake/ \
			-DBUILD_HANDBOOK_HTML=OFF \
			-DBUILD_HANDBOOK_PDF=OFF \
			-DBUILD_HOWTO_HTML=OFF \
			-DBUILD_HOWTO_PDF=OFF

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/bibletime

.include <bsd.port.mk>
