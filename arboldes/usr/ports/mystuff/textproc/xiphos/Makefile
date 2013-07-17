# $OpenBSD$
# This port is released to the public domain. 2010
#
COMMENT=	"Bible study tool with modules from Sword project"

V=		3.1.5
DISTNAME=	xiphos-${V}
CATEGORIES=	textproc misc
PKGNAME=	${DISTNAME}
HOMEPAGE=	http://xiphos.org
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdejesus.org>

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=gnomesword/Xiphos/${V}/}
	
DISTFILES=	${DISTNAME}.tar.gz


#GPL
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

MODULES =       devel/waf  

CONFIGURE_ARGS += --enable-gtkhtml

CFLAGS += 

CONFIGURE_ENV+= CPPFLAGS="-I${LOCALBASE}/include" 
MAKE_ENV += LD_PRELOAD=/usr/local/lib/python2.7/site-packages/libxml2mod.so

BUILD_DEPENDS=	textproc/intltool converters/libiconv textproc/sword www/gtkhtml3 textproc/clucene devel/libglade2 x11/gnome/doc-utils textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn

RUN_DEPENDS+= 	converters/libiconv textproc/sword www/gtkhtml3 textproc/clucene devel/libglade2 x11/gnome/doc-utils textproc/libxml devel/glib2 x11/gtk+2  x11/dbus-glib devel/libgsf devel/pango devel/atk graphics/cairo  graphics/png textproc/enchant devel/gconf2 devel/ORBit2 devel/pcre archivers/bzip2 net/curl devel/libidn

WANTLIB=	X11 c m stdc++ ssl

.include <bsd.port.mk>
