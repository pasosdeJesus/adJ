# $adJ$

# Port in the public domain.

VERSION=2.0b14
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

RUN_DEPENDS += lang/ruby/3.0
#BUILD_DEPENDS += www/phantomjs


pre-patch:
	pwd
	ln -s `dirname ${WRKDIST}`/sivel2-${VERSION} ${WRKDIST}

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/.bundle
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/bundler
	echo '---' > ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_DEPLOYMENT: "true"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_PATH: "./bundler"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_BUILD_NOKOGIRI: "--use-system-libraries --with-xml2-include=/usr/local/include/libxml2"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_DISABLE_SHARED-GEMS: "true"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	( cd ${PREFIX}/${SIVEL_RAIZ}; \
	bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/local/include/libxml2/; \
	CC=clang CXX=clang++ bundle install )
	#gem install --install-dir ./bundler/ruby/3.0 nokogiri; \

.include <bsd.port.mk>
