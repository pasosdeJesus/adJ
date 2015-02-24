# $adJ$

# Port in the public domain.

VERSION=1.1.6
REVISION=1
DISTNAME=sivel-${VERSION}
HOMEPAGE=	http://sivel.sourceforge.net/
PKGSPEC = sivel->=1.1,<1.2

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=sivel/}
EXTRACT_SUFX=	.tar.gz

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
