# adJ. Dominio Público. vtamara@pasosdeJesus.org. 2013

COMMENT=	 Interactive text-mode process viewer for Unix systems

VERSION=	2.0.1
DISTNAME=	htop-${VERSION}
#REVISION=	1

CATEGORIES=	sysutils
HOMEPAGE=	https://hisham.hm/htop

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# BSD
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=		https://hisham.hm/htop/releases/${VERSION}/

#BUILD_DEPENDS= 	devel/apr devel/libconfuse net/rrdtool
#RUN_DEPENDS=	net/rrdtool
WANTLIB =       c z #expat pthread

#SHARED_LIBS +=  ganglia-3.6.0             0.0 # 0.0
#SHARED_LIBS +=  ganglia                   0.0 # 0.0

CONFIGURE_STYLE=	gnu
CONFIGURE_ENV =         CFLAGS="-I${LOCALBASE}/include" \
                        LDFLAGS="-L${LOCALBASE}/lib"
#CONFIGURE_ARGS = --with-libconfuse=/usr/local  --with-gmetad

#post-install:
#	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/ganglia/
#	mv ${PREFIX}/../../etc/gmetad.conf ${PREFIX}/share/examples/ganglia/
#	mv ${PREFIX}/../../etc/conf.d ${PREFIX}/share/examples/ganglia/

.include <bsd.port.mk>
