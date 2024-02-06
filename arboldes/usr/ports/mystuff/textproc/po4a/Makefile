# $adJ$

# Porte de dominio público

COMMENT= "Translation of documentation. PO for anything"

VERSION=         0.63
REVISION=        1
DISTNAME=        v${VERSION}
CATEGORIES=      textproc
PKGNAME=         po4a-${VERSION}
GH_TAGNAME=      v${VERSION}
GH_PROJECT=      po4a

HOMEPAGE=        https://po4a.org/
PKGSPEC =        Mt77->=1.0,<1.1
MAINTAINER=      Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

SITES=    https://github.com/mquinson/po4a/archive/

PERMIT_PACKAGE=  Yes

BUILD_DEPENDS=   ${RUN_DEPENDS} 
RUN_DEPENDS=     devel/p5-Locale-gettext \
                 textproc/p5-Pod-Parser \
                 textproc/p5-SGMLSpm \
                 converters/p5-Unicode-LineBreak \
                 textproc/openjade \
                 textproc/libxslt \
                 textproc/docbook-xsl \
                 devel/gettext,-tools

CONFIGURE_STYLE= modbuild

.include <bsd.port.mk>
