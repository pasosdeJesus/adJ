# $OpenBSD: Makefile,v 1.69.2.1 2018/12/11 17:01:06 sthen Exp $

PV=		7.0
V=		${PV}.33
PKGSTEM-main=	php-7.0

BUILD_DEPENDS+=	devel/bison

CONFIGURE_ENV+=		YACC="${LOCALBASE}/bin/bison -y"
CONFIGURE_ARGS+=	--with-pcre-jit=no

.include <bsd.port.mk>
