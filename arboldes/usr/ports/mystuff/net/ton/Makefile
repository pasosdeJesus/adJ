COMMENT =		Tools for the Blockchain TON - The Open Network
V =			20220430
REVISION =		

# Patches were added just to change daemon for service

DISTNAME=	ton-$V
GH_ACCOUNT=	vtamara
GH_PROJECT=	ton
GH_BRANCH=adJ
GH_COMMIT=	a67a00f0df41cf00c2317d3cbe5f535fd1ae8738

CATEGORIES =		net

DEBUG_PACKAGES =	${BUILD_PACKAGES}

HOMEPAGE =		https://ton.org
MASTER_SITES =		https://github.com/vtamara/ton/archive/
MASTER_SITES1 =		https://github.com/abseil/abseil-cpp/archive/
MASTER_SITES2 =		https://github.com/google/crc32c/archive/
MASTER_SITES3 =		https://github.com/ton-blockchain/libRaptorQ/archive/
MASTER_SITES4 =		https://github.com/facebook/rocksdb/archive/

EXTRACT_SUFX=.tar.gz

COMMIT_ABSEIL_CPP=8c6e53ef3adb1227fffa442c50349dab134a54bc
COMMIT_CRC32C=fd33bccdf4824716df2552f7addd735264f77872
COMMIT_LIBRAPTORQ=14baff5994b6faf7739a5f058481797365b57fb1
COMMIT_ROCKSDB=0915c99f01b46f50af8e02da8b6528156f584b7c
DISTFILES +=	ton-20220417-a67a00f0${EXTRACT_SUFX}  \
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

BUILD_DEPENDS =		www/libmicrohttpd

LIB_DEPENDS =		

RUN_DEPENDS =		

CONFIGURE_ARGS +=	

NO_TEST =		Yes

pre-patch:
	mv -f ${WRKDIR}/abseil-cpp-${COMMIT_ABSEIL_CPP}/* ${WRKDIST}/third-party/abseil-cpp/
	mv -f ${WRKDIR}/crc32c-${COMMIT_CRC32C}/* ${WRKDIST}/third-party/crc32c/
	mv -f ${WRKDIR}/libRaptorQ-${COMMIT_LIBRAPTORQ}/* ${WRKDIST}/third-party/libraptorq/
	mv -f ${WRKDIR}/rocksdb-${COMMIT_ROCKSDB}/* ${WRKDIST}/third-party/rocksdb/


.include <bsd.port.mk>

