# Dominio Público. vtamara@pasosdeJesus.org. 2013

COMMENT=	Scalable distributed monitoring system

VERSION=3.6.0
DISTNAME=	ganglia-${VERSION}

CATEGORIES=	sysutils
HOMEPAGE=	http://ganglia.sourceforge.net/

# BSD
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=ganglia/}
DISTFILES=	${DISTNAME}.tar.gz

BUILD_DEPENDS= 	devel/apr devel/libconfuse
RUN_DEPENDS=	net/rrdtool
WANTLIB =       c kvm z expat pthread

SHARED_LIBS +=  ganglia-3.6.0             0.0 # 0.0
SHARED_LIBS +=  ganglia                   0.0 # 0.0

CONFIGURE_STYLE=	gnu
CONFIGURE_ENV =         CFLAGS="-I${LOCALBASE}/include" \
                        LDFLAGS="-L${LOCALBASE}/lib"
CONFIGURE_ARGS = --with-libconfuse=/usr/local  --with-gmetad

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/ganglia/
	mv ${PREFIX}/../../etc/gmetad.conf ${PREFIX}/share/examples/ganglia/
	mv ${PREFIX}/../../etc/conf.d ${PREFIX}/share/examples/ganglia/



.include <bsd.port.mk>
