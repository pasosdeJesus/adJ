# Dominio Público. vtamara@pasosdeJesus.org. 2013

ONLY_FOR_ARCHS=	amd64

COMMENT=	Emulador de Game Boy Classic

PKGNAME=	realboy-0.9
DISTNAME=	realboy

CATEGORIES=	emulators games
HOMEPAGE=	http://realboyemulator.wordpress.com/

# BSD
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=realboy/}
DISTFILES=	${DISTNAME}.tar.gz

RUN_DEPENDS=	converters/libiconv devel/sdl 


do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/realboy ${PREFIX}/bin
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/pkg-readmes/
	${INSTALL_DATA} ${WRKSRC}/README ${PREFIX}/share/doc/pkg-readmes/${PKGNAME}


.include <bsd.port.mk>
