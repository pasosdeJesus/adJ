COMMENT =	Motor para crear y gestionar proyectos estilo Pasos de Jesus

V =		0.37.4
DISTNAME =	m-${V}-full
PKGNAME =	m-${V}
CATEGORIES =	devel

HOMEPAGE =	https://gitlab.com/pasosdeJesus/m
MAINTAINER =	vtamara@pasosdeJesus.org

# ISC
PERMIT_PACKAGE =	Yes

EXTRACT_SUFX =	.tar.gz
WRKDIST =	${WRKDIR}/package

NO_BUILD =	Yes
NO_TEST =	Yes

RUN_DEPENDS =	lang/node

INSTDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/m

do-install:
	${INSTALL_DATA_DIR} ${INSTDIR}
	cp -Rp ${WRKSRC}/{package.json,package-lock.json,README.md,dist,node_modules,src} \
		${INSTDIR}/
	chmod 755 ${INSTDIR}/dist/m.js
	ln -sf ${TRUEPREFIX}/lib/node_modules/@pasosdejesus/m/dist/m.js \
		${PREFIX}/bin/m
	${INSTALL_MAN} ${WRKSRC}/man/man1/m.1 ${PREFIX}/man/man1/m.1

.include <bsd.port.mk>
