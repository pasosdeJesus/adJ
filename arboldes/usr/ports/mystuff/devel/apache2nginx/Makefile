# $adJ$

COMMENT=	Ayuda a traducir configuración de Apache a nginx

DISTNAME=	apache2nginx-0.0.1

VERSION= 0.0.1

CATEGORIES=	devel

HOMEPAGE=	http://github.com/vtamara/apache2nginx
MASTER_SITES =	https://github.com/vtamara/apache2nginx/raw/master/pkg/


# MIT
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MODULES=	lang/ruby

BUILD_DEPENDS =		${RUN_DEPENDS}
RUN_DEPENDS =		devel/ruby-apacheconf_parser


CONFIGURE_STYLE=ruby gem 

.include <bsd.port.mk>
