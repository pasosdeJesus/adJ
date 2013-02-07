# $OpenBSD$
# This port is released to the public domain.
#


COMMENT=	"Documentación de adJ como Sistema de Escritorio"
PNAME=		usuario_OpenBSD

include ../basico_OpenBSD/Make.inc

DISTNAME=	${PNAME}-${V}
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

#post-build:
#	(cd ${WRKBUILD}; make imp/${PNAME}.pdf)

.include <bsd.port.mk>
