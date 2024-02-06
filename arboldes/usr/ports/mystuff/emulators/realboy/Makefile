# Dominio Público. vtamara@pasosdeJesus.org. 2013

ONLY_FOR_ARCHS=	amd64

COMMENT=	Emulador de Game Boy Classic/Game Boy Color

VERSION=	0.2.2
DISTNAME=       realboy-${VERSION}
REVISION=	1
#PKGNAME=        ${DISTNAME:L}


CATEGORIES=	emulators games
HOMEPAGE=	http://realboyemulator.wordpress.com/


# GPL 2
PERMIT_PACKAGE=	Yes

SITES=	${SITE_SOURCEFORGE:=realboy/}
DISTFILES=	${DISTNAME}.tar.gz

BUILD_DEPENDS=	devel/sdl 

RUN_DEPENDS=	converters/libiconv devel/sdl 
WANTLIB =       SDL c m pthread sndio

LIB_DEPENDS =           devel/sdl

CONFIGURE_STYLE=	gnu
CONFIGURE_ENV =         CFLAGS="-g -fno-pie" \
			CPPFLAGS="-I${LOCALBASE}/include" \
                        LDFLAGS="-L${LOCALBASE}/lib -nopie"

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/src/realboy ${PREFIX}/bin
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/pkg-readmes/
	${INSTALL_DATA} ${WRKSRC}/README ${PREFIX}/share/doc/pkg-readmes/${PKGNAME}

.include <bsd.port.mk>
