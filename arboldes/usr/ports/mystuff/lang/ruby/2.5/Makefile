# $OpenBSD: Makefile,v 1.6.2.1 2017/12/18 16:04:00 jeremy Exp $

COMMENT-main =		object oriented script language with threads
COMMENT-gdbm =		gdbm interface for ruby
COMMENT-ri_docs =	ri documentation files for ruby

VERSION =		2.5.0
RUBYLIBREV =		2.5
DISTNAME =		ruby-${VERSION}

SHARED_LIBS =		ruby25	0.0
PKGNAME-main =		ruby-${VERSION}
PKGNAME-gdbm =		ruby25-gdbm-${VERSION}
PKGNAME-ri_docs =	ruby25-ri_docs-${VERSION}

PKG_ARCH-ri_docs =	*
WANTLIB-ri_docs =	# empty

NEXTVER =		2.6
PKGSPEC-main =		ruby->=${RUBYLIBREV},<${NEXTVER}

CONFIGURE_ARGS =	--program-suffix=25 \
			--with-soname=ruby25 \
			--with-ruby-version=minor \
			--with-mantype=doc \
			--enable-pthread \
			--enable-ipv6 \
			--without-bundled-libffi \
			--disable-option-checking

CONFIGURE_ENV =		LIBruby25_VERSION=${LIBruby25_VERSION} \
			PREFIX="${PREFIX}" \
			CPPFLAGS="-DOPENSSL_NO_STATIC_ENGINE -I${LOCALBASE}/include" \
			LDFLAGS="-L${LOCALBASE}/lib" \
			DLDFLAGS="-L${LOCALBASE}/lib" \
			ac_cv_prog_DOXYGEN="" \
			ac_cv_prog_DOT="" 

MAKE_ENV =		DLDFLAGS="-I${LOCALBASE}/lib"

ALL_TARGET =		V=1 main
INSTALL_TARGET =	V=1 install-nodoc

WANTLIB-main =		c crypto ffi gmp m ncurses pthread readline ssl \
			util yaml z
LIB_DEPENDS-main =	devel/gmp \
			devel/libyaml \
			devel/libffi

PSEUDO_FLAVORS=		no_ri_docs bootstrap
# Do not build the RI docs on slow arches
.if ${MACHINE_ARCH:Malpha} || ${MACHINE_ARCH:Marm} || ${MACHINE_ARCH:Mhppa}
FLAVOR?=		no_ri_docs bootstrap
.else
FLAVOR?=
.endif

MULTI_PACKAGES =	-main -gdbm -ri_docs
.include <bsd.port.arch.mk>

WANTLIB-gdbm =		c m gdbm gmp pthread #ruby25
LIB_DEPENDS-gdbm =	databases/gdbm \
			devel/gmp \
			lang/ruby/${REV},-main>=${VERSION},<${NEXTVER}
RUN_DEPENDS-gdbm =

.if ${BUILD_PACKAGES:M-ri_docs}
ALL_TARGET +=		rdoc
INSTALL_TARGET +=	install-doc
.endif

SUBST_VARS +=		RUBYLIBREV

TEST_DEPENDS =		${FULLPKGNAME-main}:${BUILD_PKGPATH}

post-extract:
	rm -rf ${WRKSRC}/ext/fiddle/libffi-* ${WRKSRC}/tool/downloader.rb

# cc(1) uses too much ram to build ext/ripper/ripper.c
# XXX remove arch if vmparam.h + login.conf give more than 1024M to pbuild
.if ${MACHINE_ARCH:Malpha} || ${MACHINE_ARCH:Marm} || ${MACHINE_ARCH:Mhppa}
CFLAGS_OVERRIDE =	-O1
.endif
pre-configure:
	sed -i 's/%%CFLAGS_OVERRIDE%%/${CFLAGS_OVERRIDE}/g' \
	    ${WRKSRC}/ext/ripper/depend

pre-install:
	find ${WRKSRC} -name '*.orig' -print0 | xargs -0r rm
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/ruby \
	${PREFIX}/lib/ruby/gems/${RUBYLIBREV}/extensions/${SUB} \
	${PREFIX}/lib/ruby/gems/${RUBYLIBREV}/extensions/${SUB}/${RUBYLIBREV}

post-install:
	${FIX_RBCONFIG}

# 16984 tests, 2242211 assertions, 1 failures, 5 errors, 107 skips
do-test:
	-cd ${WRKSRC} && make test-sample
	-cd ${WRKSRC} && make btest-ruby
	cd ${WRKSRC} && make test-all TESTOPTS="-v -q"

.include <bsd.port.mk>
