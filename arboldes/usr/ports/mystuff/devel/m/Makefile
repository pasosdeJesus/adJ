COMMENT =	Rails-style CLI for Web 2.5 apps (Next.js + PostgreSQL)

V =		0.37.13
DISTNAME =	m-${V}-full
PKGNAME =	m-${V}
CATEGORIES =	devel

HOMEPAGE =	https://gitlab.com/pasosdeJesus/m
MAINTAINER =	vtamara@pasosdeJesus.org

# ISC
PERMIT_PACKAGE =	Yes

# Tarball "-full" generado por la CI de m (scripts/build-full.sh): dist + man +
# node_modules de producción (contract-test, edr, solc 0.8.26, @ethereumjs/*),
# sin la extensión opt-in mpdj.  Se distribuye como artefacto del Generic
# Package Registry de GitLab, así el porte NO necesita red en la compilación.
SITES =		https://gitlab.com/api/v4/projects/76261690/packages/generic/m-full/${V}/
DISTFILES =	${DISTNAME}.tar.gz

EXTRACT_SUFX =	.tar.gz
WRKDIST =	${WRKDIR}/package

NO_BUILD =	Yes
NO_TEST =	Yes

RUN_DEPENDS =	lang/node

INSTDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/m

do-install:
	${INSTALL_DATA_DIR} ${INSTDIR}
	cp -Rp ${WRKSRC}/{package.json,pnpm-lock.yaml,README.md,dist,node_modules,src} \
		${INSTDIR}/
	chmod 755 ${INSTDIR}/dist/m.js
	ln -sf ${TRUEPREFIX}/lib/node_modules/@pasosdejesus/m/dist/m.js \
		${PREFIX}/bin/m
	${INSTALL_MAN} ${WRKSRC}/man/man1/m.1 ${PREFIX}/man/man1/m.1

.include <bsd.port.mk>
