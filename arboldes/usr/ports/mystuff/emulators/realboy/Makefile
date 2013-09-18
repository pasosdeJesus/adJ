# Dominio Público. vtamara@pasosdeJesus.org. 2013

ONLY_FOR_ARCHS=	amd64

COMMENT=	Emulador de Game Boy Classic/Game Boy Color

VERSION=0.1
PKGNAME=	realboy-${VERSION}
DISTNAME=	realboy-${VERSION}

CATEGORIES=	emulators games
HOMEPAGE=	http://realboyemulator.wordpress.com/


# GPL 2
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=realboy/}
DISTFILES=	${DISTNAME}.tar.gz

BUILD_DEPENDS=	devel/sdl 

RUN_DEPENDS=	converters/libiconv devel/sdl 
WANTLIB =       SDL c m pthread sndio

LIB_DEPENDS =           devel/sdl

CONFIGURE_STYLE=	gnu
CONFIGURE_ENV =         CPPFLAGS="-I${LOCALBASE}/include -g -O0" \
                        LDFLAGS="-L${LOCALBASE}/lib"

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/src/realboy ${PREFIX}/bin
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/pkg-readmes/
	${INSTALL_DATA} ${WRKSRC}/README ${PREFIX}/share/doc/pkg-readmes/${PKGNAME}

.include <bsd.port.mk>
