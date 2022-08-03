# $adJ$

# Port in the public domain.

VERSION=2.0
#REVISION=1
#v${VERSION}
PKGNAME=sivel-v${VERSION}

#GH_MAIN=sivel2.0
GH_ACCOUNT=pasosdeJesus
GH_PROJECT=sivel2
GH_COMMIT=c71dc561ed0fb44cfab43f8d1ee6365078b6330f

DISTNAME=${GH_COMMIT}

HOMEPAGE=http://pasosdeJesus.github.io/sivel2
PKGSPEC = sivel->=2.0,<2.1

#MASTER_SITES=https://github.com/pasosdeJesus/sivel2/archive/
#EXTRACT_SUFX=.tar.gz
DISTFILES=xv${VERSION}${EXTRACT_SUFX}
DCOMP=sivel2-${GH_COMMIT}
SIVEL_RAIZ ?= htdocs/sivel2

RUN_DEPENDS += lang/ruby/3.1
#BUILD_DEPENDS += www/phantomjs


#pre-patch:
#	pwd
#	ln -s `dirname ${WRKDIST}`/sivel2-${VERSION} ${WRKDIST}

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo rsync -ravzp ${PREFIX}/../../../${DCOMP}/ ${PREFIX}/${SIVEL_RAIZ}/
	rsync -ravzp ${PREFIX}/../../../${DCOMP}/ ${PREFIX}/${SIVEL_RAIZ}/
	echo @find
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/.bundle
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/bundler
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/public/packs
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/public/packs-test
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/bundler/ruby/3.1/bundler/gems/sivel2_gen-2a321e3acf44/coverage
	echo '___' > ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_DEPLOYMENT: "true"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_PATH: "./bundler"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_BUILD_NOKOGIRI: "--use-system-libraries --with-xml2-include=/usr/local/include/libxml2"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	echo 'BUNDLE_DISABLE_SHARED_GEMS: "true"' >> ${PREFIX}/${SIVEL_RAIZ}/.bundle/config
	( cd ${PREFIX}/${SIVEL_RAIZ}; \
	bundle config build.nokogiri --use-system-libraries --with-xml2-include=/usr/local/include/libxml2/; \
	bundle install )
#	CFLAGS=-fdeclspec LDFLAGS=-fdeclspec CC=clang CXX=clang++ gem install --install-dir ./bundler/ruby/3.0 nokogiri -- --use-system-libraries; \
	

.include <bsd.port.mk>
