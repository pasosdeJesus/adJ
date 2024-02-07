V=		7.3

DISTNAME=	${PNAME}-${V}
CATEGORIES=	books
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

VHERRAM=	40964c3d01fe7d1a070024b6bc74495c581de1b0
VHERRAMCORTA=	40964c3d

HOMEPAGE=       http://pasosdeJesus.github.io/${PNAME}/
SITES=	https://github.com/pasosdeJesus/${PNAME}/archive/
SITES.a=	https://gitlab.com/pasosdeJesus/herram_confsh/-/archive/${VHERRAMCORTA}/
EXTRACT_SUFX=.tar.gz
DISTFILES=	${PNAME}-${V}${EXTRACT_SUFX}
DISTFILES.a+=	herram_confsh-${VHERRAMCORTA}-${VHERRAM}${EXTRACT_SUFX}
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
