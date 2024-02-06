# $adJ$

# Port in the public domain.

VERSION=1.2.8
DISTNAME=v${VERSION}
PKGNAME=sivel-v${VERSION}
#REVISION=1

HOMEPAGE=http://pasosdeJesus.github.io/SIVeL/
PKGSPEC = sivel->=1.2,<1.3

SITES=https://github.com/pasosdeJesus/SIVeL/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=xv${VERSION}${EXTRACT_SUFX}
DCOMP=SIVeL-${VERSION}
SIVEL_RAIZ ?= htdocs/sivel

RUN_DEPENDS+= lang/php/5.6 \
	www/pear \
	security/pear-Auth \
	databases/pear-DB \
	devel/pear-Date \
	www/pear-HTML-QuickForm \
	net/pear-Net-Socket \
	net/pear-Net-SMTP \
	mail/pear-Mail  \
	mail/pear-Mail-Mime  \
	www/pear-HTML-Common  \
	www/pear-HTML-Menu \
	www/pear-HTML-QuickForm-Controller \
	www/pear-HTML-Javascript \
	www/pear-HTML-CSS \
	databases/pear-DB_DataObject \
	www/pear-DB-DataObject-FormBuilder \
	devel/pear-Validate 

pre-patch:
	ln -s ${WRKDIR}/SIVeL-${VERSION} ${WRKDIR}/v${VERSION}

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/.* ${PREFIX}/${SIVEL_RAIZ} 
	@cp -rf ${PREFIX}/../../../${DCOMP}/bin/.* ${PREFIX}/${SIVEL_RAIZ}/bin/
	@cp -rf ${PREFIX}/../../../${DCOMP}/herram/.* ${PREFIX}/${SIVEL_RAIZ}/herram/
	@cp -rf ${PREFIX}/../../../${DCOMP}/sitios/pruebas/.* ${PREFIX}/${SIVEL_RAIZ}/sitios/pruebas/
	@cp -rf ${PREFIX}/../../../${DCOMP}/valida/.* ${PREFIX}/${SIVEL_RAIZ}/valida/
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
