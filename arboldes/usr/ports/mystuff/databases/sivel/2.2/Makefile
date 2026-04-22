# $adJ$

# Port in the public domain.

VERSION=2.2.1
REVISION=
PKGNAME=sivel-v${VERSION}

#GH_MAIN=sivel2.0
#GH_ACCOUNT=pasosdeJesus
#GH_PROJECT=sivel2
#GH_COMMIT=c9c57a13f0a7b7a9eca16dd9640f2ebb319ef7a9

SITES=https://gitlab.com/pasosdeJesus/sivel2/-/archive/v${VERSION}/sivel2-v${VERSION}$
EXTRACT_SUFX=.tar.gz
DISTFILES=»·sivel2-v${VERSION}${EXTRACT_SUFX}
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


HOMEPAGE=http://sivel.xyz
PKGSPEC = sivel->=2.2,<2.3

DISTFILES=xv${VERSION}${EXTRACT_SUFX}
DCOMP=sivel2-v${VERSION}
SIVEL_RAIZ ?= htdocs/sivel2

RUN_DEPENDS += lang/ruby/3.4
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
	mkdir -p ${PREFIX}/${SIVEL_RAIZ}/bundler/ruby/3.3/bundler/gems/sivel2_gen-2a321e3acf44/coverage
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
