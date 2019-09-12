# $adJ$

# Port in the public domain.

VERSION=2.0b9
#REVISION=1
DISTNAME=v${VERSION}
PKGNAME=sivel-v${VERSION}

HOMEPAGE=http://pasosdeJesus.github.io/sivel2
PKGSPEC = sivel->=2.0,<2.1

MASTER_SITES=https://github.com/pasosdeJesus/sivel2/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=v${VERSION}${EXTRACT_SUFX}
#DCOMP=sivel2-${VERSION}
SIVEL_RAIZ ?= htdocs/sivel2

RUN_DEPENDS += lang/ruby/2.6
#BUILD_DEPENDS += www/phantomjs


pre-patch:
	pwd
	ln -s `dirname ${WRKDIST}`/sivel2-${VERSION} ${WRKDIST}

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'
	( cd ${PREFIX}/${SIVEL_RAIZ}; \
	bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/local/include/libxml2/; \
	CC=clang CXX=clang++ bundle install --deployment )

.include <bsd.port.mk>
