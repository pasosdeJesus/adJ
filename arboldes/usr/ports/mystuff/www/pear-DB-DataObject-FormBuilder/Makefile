# $OpenBSD: Makefile,v 1.3 2007/03/22 22:48:04 robert Exp $

COMMENT=	"build HTML_QuickForm objects from a DB_DataObject derived"

DISTNAME=	DB_DataObject_FormBuilder-1.0.2
PKGNAME=	pear-${DISTNAME:S/_/-/g}
CATEGORIES=	www devel pear database

MASTER_SITES=	http://pear.php.net/get/
EXTRACT_SUFX=	.tgz

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>
MODULES=	www/pear
RUN_DEPENDS-main=       database/pear,-DB-DataObject


# PHP License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

.include <bsd.port.mk>
