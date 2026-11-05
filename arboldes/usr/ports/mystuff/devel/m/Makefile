COMMENT =	Rails-style CLI for Web 2.5 apps (Next.js + PostgreSQL)

V =		0.37.12
MPDJ_V =	0.3.3
DISTNAME =	m-${V}
PKGNAME =	m-${V}
CATEGORIES =	devel

HOMEPAGE =	https://gitlab.com/pasosdeJesus/m
MAINTAINER =	vtamara@pasosdeJesus.org

# ISC
PERMIT_PACKAGE =	Yes

# The published npm tarballs are the source; m's optional dependencies
# (contract-test, edr) and their transitive dependencies are resolved by
# pnpm against the pinned pnpm-lock.yaml in files/, so the port no longer
# depends on a pre-assembled "-full" blob.  pnpm is used because m is a pnpm
# project (packageManager pnpm@11.28.6); --node-linker=hoisted keeps the
# node_modules flat and self-contained (the default symlinked layout breaks
# when packaged).
SITES =		https://registry.npmjs.org/@pasosdejesus/m/-/
DISTFILES =	${DISTNAME}.tgz
SITES.mpdj =	https://registry.npmjs.org/@pasosdejesus/mpdj/-/
DISTFILES.mpdj =	mpdj-${MPDJ_V}.tgz

EXTRACT_SUFX =	.tgz
WRKDIST =	${WRKDIR}/package

# npm packs both tarballs into a top-level "package/" directory, so only the
# m tarball is extracted automatically and mpdj is unpacked by hand into a
# sibling directory in do-build.
EXTRACT_ONLY =	${DISTNAME}.tgz

BUILD_DEPENDS =	lang/node
RUN_DEPENDS =	lang/node

INSTDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/m
MPDJDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/mpdj

NO_TEST =	Yes

do-build:
	# Unpack the mpdj plugin next to m.
	mkdir -p ${WRKDIR}/package-mpdj
	tar -xzf ${FULLDISTDIR}/mpdj-${MPDJ_V}.tgz -C ${WRKDIR}/package-mpdj
	# m ships devDependencies that neither npm nor pnpm can resolve
	# (msip is private, @remix-project/* use the unsupported "link:" protocol);
	# drop them and the non-standard optionalPeerDependencies/peerDependencies,
	# and pin the package manager so corepack uses pnpm 11 (not 12, which has
	# no OpenBSD binary).
	cd ${WRKSRC} && node -e 'const f=require("fs");const p=JSON.parse(f.readFileSync("package.json"));delete p.devDependencies;delete p.optionalPeerDependencies;delete p.peerDependencies;p.packageManager="pnpm@11.28.6";f.writeFileSync("package.json",JSON.stringify(p,null,2)+"\n")'
	# Reproducible install from the pinned lockfile, keeping optional deps
	# (contract-test, edr) which pull solc 0.8.26.
	cp ${FILESDIR}/pnpm-lock.yaml ${WRKSRC}/pnpm-lock.yaml
	cd ${WRKSRC} && pnpm install --frozen-lockfile --prod --ignore-scripts \
		--node-linker=hoisted

do-install:
	${INSTALL_DATA_DIR} ${INSTDIR}
	cp -Rp ${WRKSRC}/{package.json,pnpm-lock.yaml,README.md,dist,node_modules,src} \
		${INSTDIR}/
	chmod 755 ${INSTDIR}/dist/m.js
	ln -sf ${TRUEPREFIX}/lib/node_modules/@pasosdejesus/m/dist/m.js \
		${PREFIX}/bin/m
	${INSTALL_MAN} ${WRKSRC}/man/man1/m.1 ${PREFIX}/man/man1/m.1
	${INSTALL_DATA_DIR} ${MPDJDIR}
	cp -Rp ${WRKDIR}/package-mpdj/package/{package.json,LICENSE.md,SKILL.md,dist,ia} \
		${MPDJDIR}/

.include <bsd.port.mk>
