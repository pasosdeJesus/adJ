# $adJ$

# Port in the public domain.

# Política: Sólo una versión estable de SIVeL (que por defecto queda en 
# /var/www/htdocs/sivel, sitio principal por defecto sitios/sivel en base sivel)
# Las versiones históricas quedan con copia en /var/www/htdocs/sivel11 base
# renombrada a sivel11 pero sin paquete
# Puede haber varias en desarrollo /var/www/htdocs/sivel20b7 
VERSION=1.1.7
REVISION=2

DISTNAME=sivel-${VERSION}
HOMEPAGE=	http://sivel.sourceforge.net/
PKGSPEC = sivel->=1.1,<1.2

SITES=	${SITE_SOURCEFORGE:=sivel/}
EXTRACT_SUFX=	.tar.gz
SIVEL_RAIZ ?= htdocs/sivel

RUN_DEPENDS+= lang/php/5.5 \
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

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DCOMP}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DCOMP}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DCOMP}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
