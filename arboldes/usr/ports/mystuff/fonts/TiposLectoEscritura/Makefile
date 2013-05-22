# $OpenBSD: Makefile,v 1.1.1.1 2011/07/19 09:16:06 jasper Exp $

COMMENT=	Tipos de letra para aprender a leer y escribir

V=1.1
PKGNAME=	TiposLectoEscritura-$V
DISTNAME=	TiposLectoescritura-$V
REVISION=	
CATEGORIES=	fonts

HOMEPAGE=	http://structio.sourceforge.net/
MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

NO_BUILD=	Yes
NO_REGRESS=	Yes

WRKDIST=	${WRKDIR}
DIRTIPOS=	${PREFIX}/lib/X11/fonts/structio


MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=structio/TiposLectoescritura/}
EXTRACT_SUFX=	.tar.gz
DISTFILES=      ${DISTNAME}${EXTRACT_SUFX} 

do-install:
	${INSTALL_DATA_DIR} ${DIRTIPOS}
	${INSTALL_DATA} ${WRKDIST}/*.{ttf,sfd} ${DIRTIPOS} 

doinstall-otro:
	echo @mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	@mkdir -p ${PREFIX}/${SIVEL_RAIZ}
	echo @cp ${PREFIX}/../../../${DISTNAME}/conf.sh ${PREFIX}/${SIVEL_RAIZ}
	@cp -rf ${PREFIX}/../../../${DISTNAME}/* ${PREFIX}/${SIVEL_RAIZ}
	@find ${PREFIX}/../../../${DISTNAME}/ -name ".*" -exec cp -rf {} ${PREFIX}/${SIVEL_RAIZ} ';'
	@find ${PREFIX}/${SIVEL_RAIZ} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
