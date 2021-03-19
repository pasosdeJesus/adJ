# $OpenBSD$
# This port is released to the public domain. 2014
#
COMMENT=	"Bible study tool with modules from Sword project"

GH_ACCOUNT = crosswire
GH_PROJECT = xiphos
GH_TAGNAME = 4.2.1
SUBST_VAR += GH_TAGNAME

#V=		4.0.5
#DISTNAME=	xiphos-${V}
CATEGORIES=	textproc misc
#PKGNAME=	${DISTNAME}
REVISION=	
HOMEPAGE=	http://xiphos.org
MAINTAINER=	Vladimir Tamara Patino <vtamara@pasosdejesus.org>

#MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=gnomesword/Xiphos/${V}/}
	
#DISTFILES=	${DISTNAME}-20170423.tar.gz

#GPL
PERMIT_PACKAGE=	Yes

#MODULES =       devel/waf  

#CONFIGURE_ARGS += --enable-gtkhtml

CFLAGS += -I/usr/local/include/ossp/ -I/usr/local/include/webkitgtk-4.0/
CPPFLAGS += -I/usr/local/include/ossp/ -I/usr/local/include/webkitgtk-4.0/
LDFLAGS += -I/usr/local/include/ossp/ -L/usr/local/lib -lbiblesync

CONFIGURE_ENV+= CPPFLAGS="-I${LOCALBASE}/include -I/usr/local/include/ossp/ -L/usr/local/lib" 
MAKE_ENV += LD_PRELOAD=/usr/local/lib/python2.7/site-packages/libxml2mod.so

BUILD_DEPENDS=	textproc/sword www/gtkhtml4 textproc/libxml devel/glib2 x11/gtk+3  www/webkitgtk4 textproc/biblesync textproc/itstool x11/gnome/yelp-tools
#BUILD_DEPENDS=	textproc/intltool converters/libiconv textproc/sword www/gtkhtml4 textproc/clucene devel/libglade2 textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn www/webkitgtk4 sysutils/e2fsprogs textproc/icu4c textproc/biblesync

RUN_DEPENDS+= 	converters/libiconv textproc/sword www/gtkhtml4 textproc/clucene devel/libglade2 textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn www/webkitgtk4 sysutils/e2fsprogs textproc/icu4c textproc/biblesync

WANTLIB=	X11 c m ssl

COMPILER = 	base-clang #ports-gcc
CXXFLAGS += 	-std=c++11
MODULES =	lang/clang

# compilacion con waf de py-cairo
do-configure:
	cd ${WRKSRC} && env PYTHON=${MODPY_BIN} \
		LDFLAGS="$$(python${MODPY_VERSION}-config --libs)" \
		CXX="${CXX}" CXXFLAGS="${CXXFLAGS}" ${MODPY_BIN} ./waf configure

do-build:
	cd ${WRKBUILD} && ${MODPY_BIN} ./waf build

do-install:
	cd ${WRKBUILD} && ${MODPY_BIN} ./waf install

.include <bsd.port.mk>
