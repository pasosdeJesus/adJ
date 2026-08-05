COMMENT =	Motor para crear y gestionar proyectos al estilo Pasos de Jesus

V =		0.14.1
DISTNAME =	m-${V}-full
PKGNAME =	m-${V}
CATEGORIES =	devel

HOMEPAGE =	https://gitlab.com/pasosdeJesus/m
MAINTAINER =	vtamara@pasosdeJesus.org

# ISC
PERMIT_PACKAGE =	Yes

# Uses node to execute; bundled distfiles already compiled (JS)
MODULES =	lang/node

NO_BUILD =	Yes
NO_TEST =	Yes

EXTRACT_SUFX =	.tar.gz

INSTDIR =		${PREFIX}/lib/node_modules/@pasosdejesus/m

PLIST =			${WRKDIR}/plist

do-install:
	# Install m to global node_modules
	mkdir -p ${INSTDIR}
	cp -R ${WRKSRC}/* ${INSTDIR}/
	chmod 755 ${INSTDIR}/dist/m.js
	# Symlink m binary
	ln -sf ../lib/node_modules/@pasosdejesus/m/dist/m.js ${PREFIX}/bin/m
	# Generate PLIST
	cd ${PREFIX} && find lib/node_modules/@pasosdejesus/m -type f | sort > ${PLIST}
	echo bin/m >> ${PLIST}

.include <bsd.port.mk>
