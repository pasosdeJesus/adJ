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
 * From src/include/_ctype.h and src/include/xlocale/_ctype.h of FreeBSD.
 */

#include <sys/cdefs.h>

#include <runetype.h>
#include <string.h>
#include <ctype.h>
#include <wctype.h>
#include <stdio.h>
#include <xlocale.h>
#include <wchar.h>
#include <errno.h>
#include "mblocal.h"
#include "_wctrans_local.h"

#ifdef lint
#define __inline
#endif


__inline rune_t
___toupper_l(rune_t c, locale_t l)
{

	size_t lim;
	FIX_LOCALE(l);
	_RuneLocale *_runes = XLOCALE_CTYPE(l)->runes;
	return (_towctrans(c, _wctrans_upper(_runes)));
}

__inline wint_t 
towupper_l(wint_t __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= _CACHED_RUNES) ? ___toupper_l(__c, __l) :
	       __runes->rl_mapupper[__c];
}

__inline int 
toupper_l(int __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= __limit) ? __c :
	       __runes->rl_mapupper[__c];
}

__inline int 
_toupper_l(int __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= __limit) ? __c :
	       __runes->rl_mapupper[__c];
}


__inline rune_t
___tolower_l(wint_t c, locale_t l)
{
	FIX_LOCALE(l);
	_RuneLocale *_runes = XLOCALE_CTYPE(l)->runes;
	return (_towctrans(c, _wctrans_lower(_runes)));
}

__inline wint_t 
towlower_l(wint_t __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= _CACHED_RUNES) ? ___tolower_l(__c, __l) :
	       __runes->rl_maplower[__c];
}

__inline int tolower_l(int __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= __limit) ? __c :
	       __runes->rl_maplower[__c];
}

__inline int _tolower_l(int __c, locale_t __l)
{
	int __limit;
	_RuneLocale *__runes = __runes_for_locale(__l, &__limit);
	return (__c < 0 || __c >= __limit) ? __c :
	       __runes->rl_maplower[__c];
}

__inline int
__wcwidth_l(rune_t _c, locale_t __l)
{
	unsigned int _x;

	if (_c == 0)
		return (0);
	_x = (unsigned int)(__runetype_l(_c, __l) & (_CTYPE_SWM|_CTYPE_R));
	if ((_x & _CTYPE_SWM) != 0)
		return ((_x & _CTYPE_SWM) >> _CTYPE_SWS);
	return ((_x & _CTYPE_R) != 0 ? 1 : -1);
}

wint_t nextwctype_l(wint_t __wc, wctype_t wct, locale_t __l);

__inline int digittoint_l(int __c, locale_t __l)
{ 
	return __sbmaskrune_l((__c), 0xFF, __l); 
}
