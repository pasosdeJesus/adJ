# $adJ$

# Port in the public domain.

VERSION=2.0
REVISION=1
#v${VERSION}
PKGNAME=sivel-v${VERSION}

#GH_MAIN=sivel2.0
GH_ACCOUNT=pasosdeJesus
GH_PROJECT=sivel2
GH_COMMIT=0d6e569f5371e6bdf9b5e266fb2da1f02477e5aa

# Comenzado adJ 7.2 para logar que bundler corriera en
# /usr/ports/pobj/sivel-2.0/fake-amd64/var/www/htdocs/sivel2
# Tuvo que descargarse fuentes de libxml-ruby crear la gema
# con 
# 	gem build libxml-ruby.gemspec
# e instalarla manualmente con
# 	doas gem install --install-dir /usr/ports/pobj/sivel-2.0/fake-amd64/var/www/htdocs/sivel2/bundler/ruby/3.1 ./libxml-ruby-3.2.3.gem
# Esto debido a incompatibilidad de la gema publicada y libxml reciente
# de OpenBSD, como requiere compilación de extensiones y cambio de permisos
# no bastaba poner repositorio de github en el Gemfile.

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
	DISABLE_SSL=1 bundle install )
#	CFLAGS=-fdeclspec LDFLAGS=-fdeclspec CC=clang CXX=clang++ gem install --install-dir ./bundler/ruby/3.0 nokogiri -- --use-system-libraries; \
	

.include <bsd.port.mk>
