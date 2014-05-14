# $OpenBSD$

COMMENT=	"Bible study platform with KJV module"

V=              1.7.2
DISTNAME=	sword-${V}
PKGNAME=        ${DISTNAME}
#REVISION=	1
CATEGORIES=    	textproc books
SHARED_LIBS=	sword 0.0 \
		sword-1.7.2 0.0 

HOMEPAGE=	http://crosswire.org/sword/software/swordapi.jsp
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# sword: GPL  kjv: free for any purpose
PERMIT_PACKAGE_CDROM=	Yes

BUILD_DEPENDS= archivers/unzip 
LIB_DEPENDS= net/curl

MASTER_SITES=	http://crosswire.org/ftpmirror/pub/sword/source/v1.7/
MASTER_SITES0=	http://crosswire.org/ftpmirror/pub/sword/packages/rawzip/
DISTFILES=	${DISTNAME}${EXTRACT_SUFX} 
DISTFILES+=	KJV.zip:0
CONFIGURE_STYLE=gnu
USE_GMAKE=yes

SHARE_DIR=       ${PREFIX}/share/sword

post-install:
	${INSTALL_DATA_DIR} ${SHARE_DIR}/mods.d/
	${INSTALL_DATA_DIR} ${SHARE_DIR}/modules/texts/ztext/kjv/
	${INSTALL_DATA} ${WRKDIR}/mods.d/* ${SHARE_DIR}/mods.d
	${INSTALL_DATA} ${WRKDIR}/modules/texts/ztext/kjv/* ${SHARE_DIR}/modules/texts/ztext/kjv/
	mv ${WRKINST}/etc/sword.conf ${SHARE_DIR}/

REGRESS_TARGET=check

.include <bsd.port.mk>
