# $OpenBSD$
# This port is released to the public domain.
#

include Make.inc

REVISION=	
DISTNAME=	${PNAME}-${V}
PKGNAME=   	${DISTNAME}
CATEGORIES=    	books

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

HOMEPAGE=	http://traduccion.pasosdeJesus.org
SITES=	https://gitlab.com/pasosdeJesus/biblia_dp/-/archive/v$V/
DISTFILES=	v${V}.zip
SITES.a=	https://gitlab.com/pasosdeJesus/herram_confsh/-/archive/${VHERRAMCORTA}/
DISTFILES.a=	herram_confsh-${VHERRAMCORTA}-${VHERRAM}.tar.gz

WRKDIST=        ${WRKDIR}/biblia_dp-v${V}-${DIRCOM}

pre-patch:
	mv -f ${WRKDIR}/herram_confsh-${VHERRAMCORTA}-${VHERRAM}/* ${WRKDIST}/herram_confsh/

#Public domain
PERMIT_PACKAGE=	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=  textproc/docbook-xsl textproc/docbook-dsssl textproc/docbook textproc/openjade print/texlive/base print/texlive/texmf


INSTALL_TARGET = instala
ALL_TARGET = multi

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/evangelios_dp
	${INSTALL_DATA} ${WRKBUILD}/html/* ${PREFIX}/share/doc/evangelios_dp

post-install:

.include <bsd.port.mk>
