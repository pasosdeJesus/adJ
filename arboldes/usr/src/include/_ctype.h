/*
 * Copyright (c) 1989, 1993
 *	The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 *
 * This code is derived from software contributed to Berkeley by
 * Paul Borman at Krystal Technologies.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * From @(#)ctype.h	8.4 (Berkeley) 1/21/94
 * From FreeBSD: src/include/ctype.h,v 1.27 2004/06/23 07:11:39 tjr Exp
 * $FreeBSD$
 */

#ifndef __CTYPE_H_
#define	__CTYPE_H_

#include <sys/cdefs.h>
#include <sys/_types.h>
#include <runetype.h>

#define	_CTYPE_A	_RUNETYPE_A
#define	_CTYPE_C	_RUNETYPE_C
#define	_CTYPE_D	_RUNETYPE_D
#define	_CTYPE_G	_RUNETYPE_G
#define	_CTYPE_L	_RUNETYPE_L
#define	_CTYPE_P	_RUNETYPE_P
#define	_CTYPE_S	_RUNETYPE_S
#define	_CTYPE_U	_RUNETYPE_U
#define	_CTYPE_X	_RUNETYPE_X
#define	_CTYPE_B	_RUNETYPE_B
#define	_CTYPE_R	_RUNETYPE_R
#define	_CTYPE_I	_RUNETYPE_I
#define	_CTYPE_T	_RUNETYPE_T
#define	_CTYPE_Q	_RUNETYPE_Q
#define	_CTYPE_SWM	_RUNETYPE_SWM
#define	_CTYPE_SWS	_RUNETYPE_SWS
#define	_CTYPE_SW0	_RUNETYPE_SW0
#define	_CTYPE_SW1	_RUNETYPE_SW1
#define	_CTYPE_SW2	_RUNETYPE_SW2
#define	_CTYPE_SW3	_RUNETYPE_SW3


/* See comments in <sys/_types.h> about rune_t. */
__BEGIN_DECLS
unsigned long	___runetype(rune_t) __pure;
rune_t	___tolower(rune_t) __pure;
rune_t	___toupper(rune_t) __pure;
__END_DECLS

/*
 * _EXTERNALIZE_CTYPE_INLINES_ is defined in locale/nomacros.c to tell us
 * to generate code for extern versions of all our inline functions.
 */
#ifdef _EXTERNALIZE_CTYPE_INLINES_
#define	_USE_CTYPE_INLINE_
#define	static
#define	__inline
#endif

extern int __mb_sb_limit;

/*
 * Use inline functions if we are allowed to and the compiler supports them.
 */
#if !defined(_DONT_USE_CTYPE_INLINE_) && \
    (defined(_USE_CTYPE_INLINE_) || defined(__GNUC__) || defined(__cplusplus))

#include <runetype.h>

static __inline int
__maskrune(rune_t _c, unsigned long _f)
{
	return ((_c < 0 || _c >= _CACHED_RUNES) ? ___runetype(_c) :
		_CurrentRuneLocale->rl_runetype[_c]) & _f;
}

static __inline int
__sbmaskrune(rune_t _c, unsigned long _f)
{
	return (_c < 0 || _c >= __mb_sb_limit) ? 0 :
	       _CurrentRuneLocale->rl_runetype[_c] & _f;
}

static __inline int
__istype(rune_t _c, unsigned long _f)
{
	return (!!__maskrune(_c, _f));
}

static __inline int
__sbistype(rune_t _c, unsigned long _f)
{
	return (!!__sbmaskrune(_c, _f));
}

static __inline int
__isctype(rune_t _c, unsigned long _f)
{
	return (_c < 0 || _c >= 128) ? 0 :
	       !!(_DefaultRuneLocale.rl_runetype[_c] & _f);
}

static __inline rune_t
__toupper(rune_t _c)
{
	return (_c < 0 || _c >= _CACHED_RUNES) ? ___toupper(_c) :
	       _CurrentRuneLocale->rl_mapupper[_c];
}

static __inline rune_t
__sbtoupper(rune_t _c)
{
	return (_c < 0 || _c >= __mb_sb_limit) ? _c :
	       _CurrentRuneLocale->rl_mapupper[_c];
}

static __inline rune_t
__tolower(rune_t _c)
{
	return (_c < 0 || _c >= _CACHED_RUNES) ? ___tolower(_c) :
	       _CurrentRuneLocale->rl_maplower[_c];
}

static __inline rune_t
__sbtolower(rune_t _c)
{
	return (_c < 0 || _c >= __mb_sb_limit) ? _c :
	       _CurrentRuneLocale->rl_maplower[_c];
}

static __inline int
__wcwidth(rune_t _c)
{
	unsigned int _x;

	if (_c == 0)
		return (0);
	_x = (unsigned int)__maskrune(_c, _CTYPE_SWM|_CTYPE_R);
	if ((_x & _CTYPE_SWM) != 0)
		return ((_x & _CTYPE_SWM) >> _CTYPE_SWS);
	return ((_x & _CTYPE_R) != 0 ? 1 : -1);
}

#else /* not using inlines */

__BEGIN_DECLS
int		__maskrune(rune_t, unsigned long);
int		__sbmaskrune(rune_t, unsigned long);
int		__istype(rune_t, unsigned long);
int		__sbistype(rune_t, unsigned long);
int		__isctype(rune_t, unsigned long);
rune_t	__toupper(rune_t);
rune_t	__sbtoupper(rune_t);
rune_t	__tolower(rune_t);
rune_t	__sbtolower(rune_t);
int		__wcwidth(rune_t);
__END_DECLS
#endif /* using inlines */

#endif /* !__CTYPE_H_ */
