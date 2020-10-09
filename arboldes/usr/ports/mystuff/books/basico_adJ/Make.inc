V=		6.7

DISTNAME=	${PNAME}-${V}
CATEGORIES=	books
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

VHERRAM=	534f8a78d88776b08c241550a749e1b8d1b5c9fe
VHERRAMCORTA=	534f8a7

HOMEPAGE=       http://pasosdeJesus.github.io/${PNAME}/
MASTER_SITES=	https://github.com/pasosdeJesus/${PNAME}/archive/
MASTER_SITES1=	https://gitlab.com/pasosdeJesus/herram_confsh/-/archive/${VHERRAMCORTA}/
EXTRACT_SUFX=.tar.gz
DISTFILES=	${PNAME}-${V}${EXTRACT_SUFX}
DISTFILES+=	herram_confsh-${VHERRAMCORTA}-${VHERRAM}${EXTRACT_SUFX}:1
DCOMP=${PNAME}-${V}

#Public domain
PERMIT_PACKAGE=	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=  textproc/docbook-xsl textproc/docbook-dsssl textproc/docbook textproc/openjade print/texlive/base print/texlive/texmf

INSTALL_TARGET = instala

pre-patch:
	mv -f ${WRKDIR}/herram_confsh-${VHERRAMCORTA}-${VHERRAM}/* ${WRKDIST}/herram_confsh/

post-extract:
	mv `dirname ${WRKBUILD}`/${PNAME}-${PNAME}-${V} ${WRKBUILD}

.include <bsd.port.mk>
