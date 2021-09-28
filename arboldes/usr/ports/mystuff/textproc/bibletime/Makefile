# $OpenBSD$
# This port is released to the public domain. 2020

# Reference: https://svnweb.freebsd.org/ports/head/misc/bibletime/Makefile?revision=507372&view=markup

COMMENT=	"Open source Bible study tool"

GH_ACCOUNT = bibletime
GH_PROJECT = bibletime
GH_TAGNAME = v2.11.2
#SUBST_VAR += GH_TAGNAME

#V=		4.0.5
#DISTNAME=	xiphos-${V}
CATEGORIES=	textproc misc
#PKGNAME=	${DISTNAME}
REVISION=	2
HOMEPAGE=	http://bibletime.info/
MAINTAINER=	Vladimir Tamara Patino <vtamara@pasosdejesus.org>

#MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=gnomesword/Xiphos/${V}/}
	
#DISTFILES=	${DISTNAME}-20170423.tar.gz

#GPL
PERMIT_PACKAGE=	Yes

MODULES += devel/cmake \
	   x11/qt5 \
	   lang/clang

COMPILER = 	base-clang #ports-gcc

BUILD_DEPENDS += devel/cmake \
		 textproc/sword \
		 textproc/clucene

RUN_DEPENDS = 	x11/qt5/qtwebkit \
		textproc/sword 

LIB_DEPENDS += 	x11/qt5/qtbase \
		textproc/clucene



#CONFIGURE_ARGS += --enable-gtkhtml

#CFLAGS += -I/usr/local/include/ossp/ -I/usr/local/include/webkitgtk-3.0/
#CPPFLAGS += -I/usr/local/include/ossp/ -I/usr/local/include/webkitgtk-3.0/
#LDFLAGS += -I/usr/local/include/ossp/ -L/usr/local/lib -lbiblesync

#CONFIGURE_ENV+= CPPFLAGS="-I${LOCALBASE}/include -I/usr/local/include/ossp/ -L/usr/local/lib" 
#MAKE_ENV += LD_PRELOAD=/usr/local/lib/python2.7/site-packages/libxml2mod.so

WANTLIB +=	clucene-core Qt5Core




#BUILD_DEPENDS=	textproc/intltool converters/libiconv textproc/sword www/gtkhtml4 textproc/clucene devel/libglade2 x11/gnome/doc-utils textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn www/webkit-gtk3 sysutils/e2fsprogs textproc/icu4c textproc/biblesync

#RUN_DEPENDS+= 	converters/libiconv textproc/sword www/gtkhtml4 textproc/clucene devel/libglade2 x11/gnome/doc-utils textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn www/webkit-gtk3 sysutils/e2fsprogs textproc/icu4c textproc/biblesync

WANTLIB +=	X11 c m ssl

CXXFLAGS += 	-std=c++11
CONFIGURE_ARGS +=	-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib/qt5/cmake/


# compilacion con waf de py-cairo
#do-configure:
#	cd ${WRKSRC} && env PYTHON=${MODPY_BIN} \
#		LDFLAGS="$$(python${MODPY_VERSION}-config --libs)" \
#		CXX="${CXX}" CXXFLAGS="${CXXFLAGS}" ${MODPY_BIN} ./waf configure

#do-build:
#	cd ${WRKBUILD} && ${MODPY_BIN} ./waf build

#do-install:
#	cd ${WRKBUILD} && ${MODPY_BIN} ./waf install

.include <bsd.port.mk>
