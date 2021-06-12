# $OpenBSD$

COMMENT=		free open source disk encryption software

V=			1.24u7
VORIG=			1.24-Update7
VPATH=			1.24-update7
REVISION=		1
PKGNAME=		veracrypt-${V}
CATEGORIES=security
HOMEPAGE=		https://www.veracrypt.fr/

MAINTAINER=		Portsmonitor <portsmonitor@protonmail.com>

# Apache2
PERMIT_PACKAGE=	yes

MASTER_SITES=		https://launchpad.net/veracrypt/trunk/${VPATH}/+download/
DISTNAME=		VeraCrypt_${VORIG}_Source
EXTRACT_SUFX=		.tar.bz2

COMPILER=		base-clang
WANTLIB +=		${COMPILER_LIBCXX} c m fuse wx_baseu-3.0 \
			wx_gtk3u_adv-3.0 wx_gtk3u_core-3.0

BUILD_DEPENDS=		devel/yasm \
			sysutils/coreutils

LIB_DEPENDS=		x11/wxWidgets

RUN_DEPENDS=		security/sudo

WRKDIST=		${WRKDIR}/src
USE_GMAKE=		Yes
ALL_TARGET=		NOTEST=1

post-extract:
	@cp -r ${FILESDIR}/OpenBSD ${WRKDIST}/Core/Unix/

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/Main/veracrypt ${PREFIX}/bin

.include <bsd.port.mk>
