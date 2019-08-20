V=		6.5

DISTNAME=	${PNAME}-${V}
CATEGORIES=	books
MAINTAINER=     Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

VHERRAM=	b53a8513d69b4c3d5a1059262a382b41a467cf10
VHERRAMCORTA=	b53a8513

HOMEPAGE=       http://pasosdeJesus.github.io/${PNAME}/
MASTER_SITES=	https://github.com/pasosdeJesus/${PNAME}/archive/
MASTER_SITES1=	https://gitlab.com/pasosdeJesus/herram_confsh/-/archive/${VHERRAMCORTA}/
EXTRACT_SUFX=.tar.gz
DISTFILES=	${PNAME}-${V}${EXTRACT_SUFX}
DISTFILES+=	herram_confsh-${VHERRAMCORTA}-${VHERRAM}${EXTRACT_SUFX}:1
DCOMP=${PNAME}-${V}

#Public domain
PERMIT_PACKAGE_CDROM=	Yes

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
