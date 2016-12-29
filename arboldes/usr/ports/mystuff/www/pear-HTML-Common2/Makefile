# $adJ$

COMMENT=	base package for HTML handling in PHP5

DISTNAME=	HTML_Common2-2.1.1
REVISION=	
CATEGORIES=	www devel

MODULES=	www/pear

# PHP License
PERMIT_PACKAGE_CDROM=	Yes

TEST_DEPENDS=        devel/pear-PHPUnit2

do-test: fake
	@cd ${WRKSRC} && ${PEAR_PHPBIN} \
	    -d include_path="${WRKINST}${PEAR_LIBDIR}:${PEAR_LIBDIR}" \
	    tests/HTML_Common2_Test.php

.include <bsd.port.mk>
