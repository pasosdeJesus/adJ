# Dominio Público. vtamara@pasosdeJesus.org. 2013

ONLY_FOR_ARCHS=	amd64

COMMENT=	Emulador de Game Boy Classic

PKGNAME=	realboy-0.9
REVISION=	1
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


pre-patch:
	echo 'unsigned char dmg_rom[] = {' > ${WRKSRC}/dmg_rom.c
	hexdump -v -e '8/1 "0x%02x, " "\n"' ${WRKSRC}/boot_roms/dmg_rom.bin >> ${WRKSRC}/dmg_rom.c
	echo '};' >> ${WRKSRC}/dmg_rom.c
	echo 'unsigned char gbc_bios[] = {' > ${WRKSRC}/gbc_bios.c
	hexdump -v -e '8/1 "0x%02x, " "\n"' ${WRKSRC}/boot_roms/gbc_bios.bin >> ${WRKSRC}/gbc_bios.c
	echo '};' >> ${WRKSRC}/gbc_bios.c

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/realboy ${PREFIX}/bin
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/pkg-readmes/
	${INSTALL_DATA} ${WRKSRC}/README ${PREFIX}/share/doc/pkg-readmes/${PKGNAME}


.include <bsd.port.mk>
