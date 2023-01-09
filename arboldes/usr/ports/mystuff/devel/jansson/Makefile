COMMENT =		library for manipulating JSON data

V = 			2.14
DISTNAME =		jansson-${V}
REVISION=1
# Porque adJ 7.1 tenía 2.14 pero con shared_libs 4.1
SHARED_LIBS =		jansson 4.2

CATEGORIES =		devel

HOMEPAGE =		https://digip.org/jansson/

MAINTAINER =		Kirill Bychkov <kirby@openbsd.org>

# MIT
PERMIT_PACKAGE =	Yes

MASTER_SITES =		https://github.com/akheron/jansson/releases/download/v${V}/

SEPARATE_BUILD = 	Yes
CONFIGURE_STYLE =	gnu

.include <bsd.port.mk>
