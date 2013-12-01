# $OpenBSD: Makefile,v 1.19 2013/03/11 11:23:57 espie Exp $

COMMENT =	format the display of a shell script

V =		1.2-20130928
DISTNAME = 	dialog-${V}
PKGNAME = 	dialog-${V:S/-/./}

EXTRACT_SUFX =	.tgz

CATEGORIES =	misc

MASTER_SITES =	ftp://invisible-island.net/dialog/
HOMEPAGE =	http://invisible-island.net/dialog/dialog.html

# LGPL
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP=     Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=   Yes

WANTLIB =	c m ncurses

MODULES=        devel/gettext

CONFIGURE_STYLE=gnu
MAKE_FILE =	makefile

CONFIGURE_ARGS= --enable-nls
CONFIGURE_ARGS+= --includedir="${LOCALBASE}/include"
CONFIGURE_ENV= LDFLAGS="-L${LOCALBASE}/lib -liconv"

NO_TEST =	Yes

post-build:
	cd ${WRKSRC}/po; ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} ${MAKE_FLAGS}

post-install:
	echo "PREFIX=$(PREFIX)"
	cd ${WRKSRC}/po; ${SETENV} ${MAKE_ENV} ${MAKE_PROGRAM} DESTDIR=${DESTDIR} ${MAKE_FLAGS} install

.include <bsd.port.mk>
