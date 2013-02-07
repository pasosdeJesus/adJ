#	$OpenBSD: Makefile,v 1.1 2005/08/11 21:57:02 espie Exp $

NOMAN=
PROG=check_xlocale

CFLAGS=-g


run-regress-check_xlocale: ${PROG}
	./${PROG} >/dev/null

.include <bsd.regress.mk>
