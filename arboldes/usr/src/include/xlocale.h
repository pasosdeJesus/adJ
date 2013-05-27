/*-
 * Copyright (c) 2011, 2012 The FreeBSD Foundation
 * All rights reserved.
 *
 * This software was developed by David Chisnall under sponsorship from
 * the FreeBSD Foundation.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $FreeBSD: src/include/xlocale.h,v 1.6 2012/11/17 01:49:15 svnexp Exp $
 */

#ifndef _XLOCALE_H_
#define _XLOCALE_H_

#include <locale.h>
__BEGIN_DECLS
/** From http://svnweb.freebsd.org/base/user/attilio/membarclean/sys/cdefs.h?revision=244685&view=co&pathrev=244685 */
#if !__GNUC_PREREQ__(2, 7) && !defined(__INTEL_COMPILER)
#define	__printflike(fmtarg, firstvararg)
#define	__scanflike(fmtarg, firstvararg)
#define	__format_arg(fmtarg)
#define	__strfmonlike(fmtarg, firstvararg)
#define	__strftimelike(fmtarg, firstvararg)
#else
#define	__printflike(fmtarg, firstvararg) \
		    __attribute__((__format__ (__printf__, fmtarg, firstvararg)))
#define	__scanflike(fmtarg, firstvararg) \
		    __attribute__((__format__ (__scanf__, fmtarg, firstvararg)))
#define	__format_arg(fmtarg)	__attribute__((__format_arg__ (fmtarg)))
#define	__strfmonlike(fmtarg, firstvararg) \
		    __attribute__((__format__ (__strfmon__, fmtarg, firstvararg)))
#define	__strftimelike(fmtarg, firstvararg) \
		    __attribute__((__format__ (__strftime__, fmtarg, firstvararg)))
#endif



#include <xlocale/_locale.h>

#ifdef _STRING_H_
#include <xlocale/_string.h>
#endif

#ifdef _INTTYPES_H_
#include <xlocale/_inttypes.h>
#endif

#ifdef _MONETARY_H_
#include <xlocale/_monetary.h>
#endif

#ifdef _STDLIB_H_
#include <xlocale/_stdlib.h>
#endif

#ifdef _TIME_H_
#include <xlocale/_time.h>
#endif

#ifdef _LANGINFO_H_
#include <xlocale/_langinfo.h>
#endif

#ifdef _CTYPE_H_
#include <xlocale/_ctype.h>
#endif

#ifdef _WCTYPE_H_
#define _XLOCALE_WCTYPES 1
#include <xlocale/_ctype.h>
#endif

#ifdef _STDIO_H_
#include <xlocale/_stdio.h>
#endif

#ifdef _WCHAR_H_
#include <xlocale/_wchar.h>
#endif



struct lconv	*localeconv_l(locale_t);
__END_DECLS

#endif
