# $adJ$

# Port in the public domain.

ONLY_FOR_ARCHS= amd64

COMMENT=	An office suite that combines text, spreadsheet and presentation editors
VERSION=	4.2.1
REVISION=
DISTNAME=	onlyoffice-desktopeditors-${VERSION}
WRKDIST=	${WRKDIR}/DesktopEditors-ONLYOFFICE-DesktopEditors-${VERSION}
PKGNAME=	onlyoffice-desktopeditors-${VERSION}
CATEGORIES=	editors productivity

MAINTAINER=	Vladimir Tamara <vtamara@pasosdeJesus.org>

HOMEPAGE=	http://www.onlyoffice.org

SITES=	https://github.com/ONLYOFFICE/DesktopEditors/archive/
SITES.a=	https://github.com/ONLYOFFICE/core/archive/
SITES.b=	https://github.com/ONLYOFFICE/desktop-apps/archive/
SITES.c=	https://github.com/ONLYOFFICE/desktop-sdk/archive/
SITES.d=	https://github.com/ONLYOFFICE/dictionaries/archive/
SITES.e=	https://github.com/ONLYOFFICE/sdkjs/archive/
SITES.f=	https://github.com/ONLYOFFICE/web-apps/archive/
SITES.g=	https://github.com/v8/v8/archive/

EXTRACT_SUFX=	.tar.gz
DISTFILES=	ONLYOFFICE-DesktopEditors-${VERSION}${EXTRACT_SUFX}

DISTFILES.a+= 	13d57361e4db28309a28cceb05b3267b4014a222${EXTRACT_SUFX}
DISTFILES.b+=		942bdffe28c329c12f34f124b8359ebc37418235${EXTRACT_SUFX}
DISTFILES.c+=		1d5ea8684503e6536238b052afbc0b1eb2d2d5a2${EXTRACT_SUFX}
DISTFILES.d+=		474a6c687d3e909004514ce593058a47e667e764${EXTRACT_SUFX}
DISTFILES.e+=		e31de797da58533cd7eabea5d1dcb473554581c5${EXTRACT_SUFX}
DISTFILES.f+=		24ce4d9b3a134a513607c8f86520eb88abae398c${EXTRACT_SUFX}
DISTFILES.g+=		5.7.492.60${EXTRACT_SUFX}:

DIST_SUBDIR=	desktopeditors

# License: AGPL 3
PERMIT_PACKAGE_CDROM=	Yes

USE_GMAKE=	Yes
NO_TEST=	Yes

BUILD_DEPENDS+=	x11/qt5

MODULES+=	gcc4
MODGCC4_ARCHS=	*
MODGCC4_LANGS=	c++

LIB_DEPENDS=

WANTLIB=

RUN_DEPENDS=

MAKE_ENV+=	QMAKE=qmake-qt5 \
		QMAKE_CXX=eg++

pre-patch:
	mv -f ${WRKDIR}/core-13d57361e4db28309a28cceb05b3267b4014a222/* ${WRKDIST}/core/
	mv -f ${WRKDIR}/desktop-apps-942bdffe28c329c12f34f124b8359ebc37418235/* ${WRKDIST}/desktop-apps/
	mv -f ${WRKDIR}/desktop-sdk-1d5ea8684503e6536238b052afbc0b1eb2d2d5a2/* ${WRKDIST}/desktop-sdk/
	mv -f ${WRKDIR}/dictionaries-474a6c687d3e909004514ce593058a47e667e764/* ${WRKDIST}/dictionaries/
	mv -f ${WRKDIR}/sdkjs-e31de797da58533cd7eabea5d1dcb473554581c5/* ${WRKDIST}/sdkjs/
	mv -f ${WRKDIR}/web-apps-24ce4d9b3a134a513607c8f86520eb88abae398c/* ${WRKDIST}/web-apps/
	mv -f ${WRKDIR}/v8-5.7.492.60 ${WRKDIST}/core/Common/3dParty/v8/v8

.include <bsd.port.mk>
