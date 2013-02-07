# $OpenBSD$

# Port in the public domain.

COMMENT=	"Information system of political violence"

DISTNAME=	sivel-1.1.2
PKGNAME=	${DISTNAME}p0
CATEGORIES=    	databases www

HOMEPAGE=	http://sivel.sourceforge.net/
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

NO_BUILD=	Yes
NO_REGRESS=	Yes

PREFIX ?=       /var/www
SIVEL_RAIZ ?=	htdocs/sivel
INSTDIR ?=	${PREFIX}/${SIVEL_RAIZ}
SUBST_VARS=	INSTDIR SIVEL_RAIZ


RUN_DEPENDS= lang/php/5.2 \
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


MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=sivel/}
EXTRACT_SUFX=	.tar.gz
DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

do-install:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DISTNAME}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DISTNAME}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DISTNAME}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

d: @cd ${PREFIX} && tar zvxf ${FULLDISTDIR}/${DISTNAME}${EXTRACT_SUFX}
	@chown -R root:www ${PREFIX}/${DISTNAME}
	@mv ${PREFIX}/${DISTNAME}/* ${PREFIX}/${SIVEL_RAIZ}
	@mv ${PREFIX}/${DISTNAME}/.* ${PREFIX}/${SIVEL_RAIZ}
	@cp ${PREFIX}/../conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@rm -rf ${PREFIX}/${DISTNAME}


.include <bsd.port.mk>
