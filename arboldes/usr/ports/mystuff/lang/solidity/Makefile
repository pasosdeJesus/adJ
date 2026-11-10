COMMENT =		Solidity contract-oriented programming language

V =			0.8.38
DISTNAME =		solidity_${V}
PKGNAME =		solidity-${V}

CATEGORIES =		lang

HOMEPAGE =		https://soliditylang.org/

# GPLv3
PERMIT_PACKAGE =	Yes

# C++23
COMPILER =		base-clang ports-gcc
COMPILER_LANGS =	c++

MODULES =		devel/cmake

SITES =			https://github.com/argotorg/solidity/releases/download/v${V}/

BUILD_DEPENDS =		devel/boost \
			textproc/nlohmann-json \
			devel/range-v3 \
			devel/fmt

# z3 is the SMT solver invoked by solc's SMTChecker as an external SMT-LIB2
# process; the checker is built without linking libz3, so this is a run dep.
RUN_DEPENDS =		math/z3

# Needed so make test actually runs the SMT tests; they are silently skipped
# when z3 is not found (soltest does not report them as failures).
TEST_DEPENDS =		math/z3

CONFIGURE_ARGS =	-DTESTS=ON \
			-DIGNORE_VENDORED_DEPENDENCIES=ON \
			-DPEDANTIC=OFF

# Regression tests: unit + syntax + SMT. Semantic tests need evmone (not
# ported), so they are skipped. The SMT suite runs against the packaged z3;
# four tests whose expected output was recorded with z3 4.13.3 are skipped
# via SMTIgnoreOS: openbsd (see patches/) because the packaged z3 4.16.0
# produces different (still valid) solver output.
do-test:
	cd ${WRKBUILD} && ./test/soltest --log_level=test_suite -- \
		--testpath ${WRKSRC}/test --no-semantic-tests

.include <bsd.port.mk>
