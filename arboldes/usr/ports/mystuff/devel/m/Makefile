COMMENT =	Rails-style CLI for Web 2.5 apps (Next.js + PostgreSQL)

V =		0.37.8
DISTNAME =	m-${V}-full
PKGNAME =	m-${V}
CATEGORIES =	devel

HOMEPAGE =	https://gitlab.com/pasosdeJesus/m
MAINTAINER =	vtamara@pasosdeJesus.org

# ISC
PERMIT_PACKAGE =	Yes

EXTRACT_SUFX =	.tar.gz
WRKDIST =	${WRKDIR}/package

# The `-full` tarball is assembled by the project outside this repository, with
# `m`'s production dependencies already installed and the Pasos de Jesus
# extension (mpdj) vendored alongside, so this port does not download anything
# from npm:
#
#   npm pack @pasosdejesus/m@0.37.8        # -> package/
#   (cd package && npm install --omit=dev)
#   npm pack @pasosdejesus/mpdj@0.3.2      # -> package-mpdj/
#   tar czf m-0.37.8-full.tar.gz package package-mpdj
#
# With `package-mpdj` as a sibling of `package`, `m` loads it as a plugin
# (`ai:*`, `eng:credentials:*`) and finds `mpdj/ia` without configuration.

NO_BUILD =	Yes
NO_TEST =	Yes

RUN_DEPENDS =	lang/node

INSTDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/m
MPDJDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/mpdj

do-install:
	${INSTALL_DATA_DIR} ${INSTDIR}
	cp -Rp ${WRKSRC}/{package.json,package-lock.json,README.md,dist,node_modules,src} \
		${INSTDIR}/
	chmod 755 ${INSTDIR}/dist/m.js
	ln -sf ${TRUEPREFIX}/lib/node_modules/@pasosdejesus/m/dist/m.js \
		${PREFIX}/bin/m
	${INSTALL_MAN} ${WRKSRC}/man/man1/m.1 ${PREFIX}/man/man1/m.1
	${INSTALL_DATA_DIR} ${MPDJDIR}
	cp -Rp ${WRKDIR}/package-mpdj/{package.json,LICENSE.md,SKILL.md,dist,ia} \
		${MPDJDIR}/

.include <bsd.port.mk>
