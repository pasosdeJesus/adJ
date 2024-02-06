# $adJ$

# Port in the public domain.

VERSION=2.0a9
DISTNAME=v${VERSION}
PKGNAME=sivel-v${VERSION}

HOMEPAGE=http://pasosdeJesus.github.io/sivel2
PKGSPEC = sivel->=2.0,<2.1

SITES=https://github.com/pasosdeJesus/sivel2/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=v${VERSION}${EXTRACT_SUFX}
DCOMP=sivel2-${VERSION}
SIVEL_RAIZ ?= htdocs/sivel2

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'
	( cd ${PREFIX}/${SIVEL_RAIZ}; \
	bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/local/include/libxml2/; \
	bundle install --deployment )

.include <bsd.port.mk>
