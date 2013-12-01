# adJ. Dominio Público de acuerdo a legislación colombiana. 2013. vtamara@pasosdeJesus.or

COMMENT=		fluxbox-util application that creates and manage icons

V=              1.4.1
DISTNAME=       fbdesk-${V}
PKGNAME=        ${DISTNAME}p2

CATEGORIES=		x11

MAINTAINER=		Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

HOMEPAGE=		http://fluxbox.sourceforge.net/fbdesk/

# 
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=		http://fluxbox.sourceforge.net/download/

WANTLIB=		Xpm Xft Xrender fontconfig expat png Imlib2 freetype z Xext Xdmcp Xau m ICE X11 c SM stdc++

RUN_DEPENDS=		x11/fluxbox

USE_X11=		Yes
USE_GMAKE=		Yes
CONFIGURE_STYLE=	gnu

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/fbdesk
	${INSTALL_DATA} ${WRKBUILD}/README ${PREFIX}/share/doc/fbdesk

.include <bsd.port.mk>
