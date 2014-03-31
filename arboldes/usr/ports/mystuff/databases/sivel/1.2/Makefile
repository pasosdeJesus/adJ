# $adJ$

# Port in the public domain.

VERSION=1.2b1
DISTNAME=v${VERSION}

HOMEPAGE=http://pasosdeJesus.github.io/SIVeL/
PKGSPEC = sivel->=1.2,<1.3

RUN_DEPENDS= lang/php/5.3 \
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
	databases/pear-DB-DataObject \
	www/pear-DB-DataObject-FormBuilder \
	devel/pear-Validate \
	databases/postgresql 


MASTER_SITES=https://github.com/pasosdeJesus/SIVeL/archive/
EXTRACT_SUFX=.zip
DCOMP=SIVeL-${VERSION}
SIVEL_RAIZ ?=	htdocs/sivel12

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
