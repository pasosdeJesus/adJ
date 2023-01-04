COMMENT = Tools for the blockchain TON to be used with toncli
V =			20221230
REVISION =		

# Patches were added just to change daemon for service

DISTNAME=	ton-toncli-$V
GH_ACCOUNT=	vtamara
GH_PROJECT=	SpyCheese-ton
GH_BRANCH=toncli-local-adJ
GH_COMMIT=	66fa9eb02f4c988295b070d034a1ba495b4dabc1

CATEGORIES =		net

DEBUG_PACKAGES =	${BUILD_PACKAGES}

HOMEPAGE =		https://ton.org
MASTER_SITES =		https://github.com/vtamara/SpyCheese-ton/archive/
MASTER_SITES1 =		https://github.com/abseil/abseil-cpp/archive/
MASTER_SITES2 =		https://github.com/google/crc32c/archive/
MASTER_SITES3 =		https://github.com/ton-blockchain/libRaptorQ/archive/
MASTER_SITES4 =		https://github.com/facebook/rocksdb/archive/

EXTRACT_SUFX=.tar.gz

COMMIT_ABSEIL_CPP=8c6e53ef3adb1227fffa442c50349dab134a54bc
COMMIT_CRC32C=02e65f4fd3065d27b2e29324800ca6d04df16126
COMMIT_LIBRAPTORQ=14baff5994b6faf7739a5f058481797365b57fb1
COMMIT_ROCKSDB=fcf3d75f3f022a6a55ff1222d6b06f8518d38c7c

DISTFILES +=	${GH_COMMIT}${EXTRACT_SUFX}  \
	${COMMIT_ABSEIL_CPP}${EXTRACT_SUFX}:1  \
	${COMMIT_CRC32C}${EXTRACT_SUFX}:2  \
	${COMMIT_LIBRAPTORQ}${EXTRACT_SUFX}:3  \
	${COMMIT_ROCKSDB}${EXTRACT_SUFX}:4

LIBtonlibjson_VERSION=0.0

MAINTAINER =		Vladimir Támara Patiño <vtamara@pasosdeJesus.org>

PERMIT_PACKAGE =	Yes

WANTLIB += ${COMPILER_LIBCXX}
WANTLIB += z

COMPILER =		base-clang 

MODULES =		devel/cmake 
MODPY_RUNDEP =		No

BUILD_DEPENDS =		www/libmicrohttpd devel/gsl

LIB_DEPENDS =		

RUN_DEPENDS =		

#PREFIX=/usr/local/ton-toncli
#CMAKE_INSTALL_PREFIX=${PREFIX}

CONFIGURE_ARGS += 
CPP_FLAGS="-I/usr/local/include"
LD_FLAGS="-L/usr/local/lib"

NO_TEST =		Yes

pre-patch:
	mv -f ${WRKDIR}/abseil-cpp-${COMMIT_ABSEIL_CPP}/* ${WRKDIST}/third-party/abseil-cpp/
	mv -f ${WRKDIR}/crc32c-${COMMIT_CRC32C}/* ${WRKDIST}/third-party/crc32c/
	mv -f ${WRKDIR}/libRaptorQ-${COMMIT_LIBRAPTORQ}/* ${WRKDIST}/third-party/libraptorq/
	mv -f ${WRKDIR}/rocksdb-${COMMIT_ROCKSDB}/* ${WRKDIST}/third-party/rocksdb/

post-install:
	mkdir -p ${WRKINST}/usr/local/bin/ton-toncli/
	mv ${WRKINST}/usr/local/ton-toncli/bin/* ${WRKINST}/usr/local/bin/ton-toncli/
	mkdir -p ${WRKINST}/usr/local/lib/ton-toncli/
	mv ${WRKINST}/usr/local/ton-toncli/lib/* ${WRKINST}/usr/local/lib/ton-toncli/
	mkdir -p ${WRKINST}/usr/local/share/ton-toncli/
	mv ${WRKINST}/usr/local/ton-toncli/share/ton/* ${WRKINST}/usr/local/share/ton-toncli/
	mkdir -p ${WRKINST}/usr/local/include/ton-toncli/
	mv ${WRKINST}/usr/local/ton-toncli/include/tonlib ${WRKINST}/usr/local/include/ton-toncli/
	rm -rf ${WRKINST}/usr/local/ton-toncli/

.include <bsd.port.mk>
