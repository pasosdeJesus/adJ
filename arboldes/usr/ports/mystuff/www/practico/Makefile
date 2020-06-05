# $adJ$

# Port in the public domain.

COMMENT=	"Diseño automático de aplicaciones web y progresivas"

VERSION=19.8
DISTNAME=${VERSION}
#REVISION=1
PKGNAME=	practico-${VERSION}
CATEGORIES=    	www devel 

HOMEPAGE=https://www.practico.org/

MAINTAINER=	Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

# Public Domain  & BSD License
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_FTP=	Yes 
NO_BUILD=	Yes

PREFIX=       	${VARBASE}/www
RAIZ=		htdocs/practico
INSTDIR=	${PREFIX}/${RAIZ}
TINSTDIR=	${TRUEPREFIX}/${RAIZ}
SUBST_VARS=	INSTDIR RAIZ TINSTDIR MODPHP_BIN 
MODPHP_VERSION=	7.1

RUN_DEPENDS= databases/postgresql \
	     	lang/php/${MODPHP_VERSION}

MASTER_SITES=https://github.com/unix4you2/practico/archive/
EXTRACT_SUFX=.tar.gz
DISTFILES=${VERSION}${EXTRACT_SUFX}
DCOMP=practico-${VERSION}

RUN_DEPENDS+= lang/php/7.1 

pre-patch:
	ln -s ${WRKDIR}/practico-${VERSION} ${WRKDIR}/${VERSION}

do-install:
	echo @mkdir -p ${PREFIX}/${RAIZ}
	@mkdir -p ${PREFIX}/${RAIZ}
	echo @cp -Rp ${WRKSRC}/* ${INSTDIR}/
	@cp -Rp ${WRKSRC}/* ${INSTDIR}/
	@find ${INSTDIR} -name "*.orig" -exec rm {} ';'

.include <bsd.port.mk>
