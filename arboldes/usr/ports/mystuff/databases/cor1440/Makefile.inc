# $adJ$

# Port in the public domain.

COMMENT=	"Information system of political violence"

PKGNAME=	sivel-${VERSION}
CATEGORIES=    	databases www

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_FTP=	Yes

NO_BUILD=	Yes

PREFIX ?=       /var/www
SIVEL_RAIZ ?=	htdocs/sivel
INSTDIR ?=	${PREFIX}/${SIVEL_RAIZ}
SUBST_VARS=	INSTDIR SIVEL_RAIZ


RUN_DEPENDS= lang/php/5.5 \
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
	devel/pear-Validate \
	databases/postgresql 


DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 
DCOMP ?= ${DISTNAME}

