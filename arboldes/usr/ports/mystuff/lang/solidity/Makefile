COMMENT =		Solidity contract-oriented programming language

V =			0.8.37
DISTNAME =		solidity_${V}
PKGNAME =		solidity-${V}

CATEGORIES =		lang

HOMEPAGE =		https://soliditylang.org/

# GPLv3
PERMIT_PACKAGE =	Yes

# C++20
COMPILER =		base-clang ports-gcc
COMPILER_LANGS =	c++

MODULES =		devel/cmake

SITES =			https://github.com/argotorg/solidity/releases/download/v${V}/

BUILD_DEPENDS =		devel/boost \
			textproc/nlohmann-json \
			devel/range-v3

LIB_DEPENDS =		devel/fmt

CONFIGURE_ARGS =	-DTESTS=OFF \
			-DIGNORE_VENDORED_DEPENDENCIES=ON \
			-DPEDANTIC=OFF

NO_TEST =		Yes

.include <bsd.port.mk>
