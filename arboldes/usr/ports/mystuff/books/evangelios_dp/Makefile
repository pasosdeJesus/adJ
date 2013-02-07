# $OpenBSD$
# This port is released to the public domain.
#

include Make.inc

DISTNAME=	${PNAME}-${V}
PKGNAME=   	${DISTNAME}p1
CATEGORIES=    	books

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

MASTER_SITES=	${HOMEPAGE}
DISTFILES=	${DISTNAME}.tar.gz

#Public domain
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

CONFIGURE_STYLE=        simple
CONFIGURE_SCRIPT=       conf.sh
CONFIGURE_ARGS+=-p ${PREFIX}

BUILD_DEPENDS=  textproc/docbook-xsl textproc/docbook-dsssl textproc/docbook textproc/openjade print/texlive/base print/texlive/texmf


INSTALL_TARGET = instala
ALL_TARGET = all

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/evangelios_dp
	${INSTALL_DATA} ${WRKBUILD}/html/* ${PREFIX}/share/doc/evangelios_dp

.include <bsd.port.mk>
