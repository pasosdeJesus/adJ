V=		5.8

DISTNAME=	${PNAME}-${V}
CATEGORIES=	books
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

HOMEPAGE=       http://pasosdeJesus.github.io/${PNAME}/
MASTER_SITES=https://github.com/pasosdeJesus/${PNAME}/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=${PNAME}-${V}${EXTRACT_SUFX}
DCOMP=${PNAME}-${V}

#Public domain
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=  textproc/docbook-xsl textproc/docbook-dsssl textproc/docbook textproc/openjade print/texlive/base print/texlive/texmf

INSTALL_TARGET = instala

post-extract:
	mv `dirname ${WRKBUILD}`/${PNAME}-${PNAME}-${V} ${WRKBUILD}

.include <bsd.port.mk>
