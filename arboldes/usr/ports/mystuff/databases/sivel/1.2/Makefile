# $adJ$

# Port in the public domain.

VERSION=1.2b1
DISTNAME=SIVeL-v${VERSION}

HOMEPAGE=http://pasosdeJesus.github.io/SIVeL/
PKGSPEC = sivel->=1.2,<1.3

MASTER_SITES=https://github.com/pasosdeJesus/SIVeL/archive/
EXTRACT_SUFX=.zip
DCOMP=SIVeL-SIVeL-v${VERSION}
SIVEL_RAIZ ?= htdocs/sivel12

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
