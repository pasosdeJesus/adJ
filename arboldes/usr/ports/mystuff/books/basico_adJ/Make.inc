V=		7.5

DISTNAME=	${PNAME}-${V}
CATEGORIES=	books
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

VHERRAM=	c4e48748db6e642f4d026cb3fe5542cd80b514bf
VHERRAMCORTA=	c4e48748d

HOMEPAGE=       http://pasosdeJesus.org/doc/${PNAME}/
SITES=	https://gitlab.com/pasosdeJesus/${PNAME}/-/archive/
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
	mv `dirname ${WRKBUILD}`/${PNAME}-${PNAME}-${V}* ${WRKBUILD}

.include <bsd.port.mk>
