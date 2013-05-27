/**
 * Public domain according to Colombian Legislation. 2013. vtamara@pasosdeJesus.org.
 * http://www.pasosdejesus.org/dominio_publico_colombia.html
 *
 * Parts based on iswctype.c from OpenBSD and xlocale/_ctype.h,
 * wcscoll.c, wcsxfrm.c from FreeBSD
 */

#include <sys/cdefs.h>

#include <xlocale.h>
#include <runetype.h>
#include <string.h>
#include <ctype.h>
#include <wctype.h>
#include <stdio.h>
#include <wchar.h>
#include <errno.h>
#include "mblocal.h"
#include "collate.h"
#include "xlocale_private.h"
#include "_wctrans_local.h"

#ifdef lint
#define __inline
#endif

#define __inline

__inline wctype_t
wctype_l(const char *property, locale_t locale)
{
	int i;
	FIX_LOCALE(locale);
	struct xlocale_ctype *c = XLOCALE_CTYPE(locale);
	_RuneLocale *rl = c->runes;

	for (i=0; i<_WCTYPE_NINDEXES; i++)
		if (!strcmp(rl->rl_wctype[i].te_name, property))
			return ((wctype_t)&rl->rl_wctype[i]);
	return ((wctype_t)NULL);
}


__inline _RuneType
__runetype_l(wint_t c, locale_t l)
{
	FIX_LOCALE(l);
	_RuneLocale *rl = XLOCALE_CTYPE(l)->runes;

	return (_RUNE_ISCACHED(c) ?
			rl->rl_runetype[c] : ___runetype_mb_l(c, l));
}


__inline int
__istype_l(rune_t __c, unsigned long __f, locale_t __loc)
{
	return (!!(__runetype_l(__c, __loc) & __f));
}

__inline int
iswctype_l(wint_t wc, wctype_t charclass, locale_t locale)
{
	return __istype_l(wc, ((_WCTypeEntry *)charclass)->te_mask, locale);
}

__inline int
__sbmaskrune_l(rune_t __c, unsigned long __f, locale_t __loc)
{
	int __limit;
	_RuneLocale *runes = __runes_for_locale(__loc, &__limit);
	return (__c < 0 || __c >= __limit) ? 0 :
	       runes->rl_runetype[__c] & __f;
}

__inline int
__sbistype_l(rune_t __c, unsigned long __f, locale_t __loc)
{
	return (!!__sbmaskrune_l(__c, __f, __loc));
}


__inline int isalnum_l(int __c, locale_t __l)
{
	return __sbistype_l(__c, _CTYPE_A|_CTYPE_D, __l);
}

__inline int isalpha_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_A, __l); 
}

__inline int isblank_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_B, __l); 
}

__inline int iscntrl_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_C, __l);
}

__inline int isdigit_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_D, __l); 
}

__inline int isgraph_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_G, __l); 
}

__inline int ishexnumber_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_X, __l); 
}

__inline int isxdigit_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_X, __l); 
}


__inline int isideogram_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_I, __l);
}

__inline int islower_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_L, __l);
}

__inline int isnumber_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_D, __l);
}

__inline int isphonogram_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_Q, __l);
}

__inline int isprint_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_R, __l);
}

__inline int ispunct_l(int __c, locale_t __l)
{ 
	return __sbistype_l(__c, _CTYPE_P, __l);
}

__inline int isrune_l(int __c, locale_t __l) 
{
	return __sbistype_l(__c, 0xFFFFFF00L, __l);
}

__inline int isspace_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_S, __l);
}

__inline int isspecial_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_T, __l);
}

__inline int isupper_l(int __c, locale_t __l) 
{ 
	return __sbistype_l(__c, _CTYPE_U, __l);
}


__inline int iswalnum_l(wint_t __c, locale_t __l)
{
	return __istype_l(__c, _CTYPE_A|_CTYPE_D, __l);
}

__inline int iswalpha_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_A, __l); 
}

__inline int iswblank_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_B, __l); 
}

__inline int iswcntrl_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_C, __l);
}

__inline int iswdigit_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_D, __l); 
}

__inline int iswgraph_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_G, __l); 
}

__inline int iswhexnumber_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_X, __l); 
}

__inline int iswxdigit_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_X, __l); 
}


__inline int iswideogram_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_I, __l);
}

__inline int iswlower_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_L, __l);
}

__inline int iswnumber_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_D, __l);
}

__inline int iswphonogram_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_Q, __l);
}

__inline int iswprint_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_R, __l);
}

__inline int iswpunct_l(wint_t __c, locale_t __l)
{ 
	return __istype_l(__c, _CTYPE_P, __l);
}

__inline int iswrune_l(wint_t __c, locale_t __l) 
{
	return __istype_l(__c, 0xFFFFFF00L, __l);
}

__inline int iswspace_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_S, __l);
}

__inline int iswspecial_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_T, __l);
}

__inline int iswupper_l(wint_t __c, locale_t __l) 
{ 
	return __istype_l(__c, _CTYPE_U, __l);
}

int wcwidth_l(wchar_t c, locale_t __l)
{
	if (__istype_l((c), _CTYPE_R, __l))
		return (((unsigned)__runetype_l(c, __l) & _CTYPE_SWM) 
				>> _CTYPE_SWS);
	return -1;
}


wctrans_t
wctrans_l(const char *charclass, locale_t l)
{
	int i;
	FIX_LOCALE(l);
	_RuneLocale *rl = XLOCALE_CTYPE(l)->runes;

	if (rl->rl_wctrans[_WCTRANS_INDEX_LOWER].te_name==NULL)
		_wctrans_init(rl);

	for (i=0; i<_WCTRANS_NINDEXES; i++)
		if (!strcmp(rl->rl_wctrans[i].te_name, charclass))
			return ((wctrans_t)&rl->rl_wctrans[i]);

	return ((wctrans_t)NULL);
}

wint_t
towctrans_l(wint_t wc, wctrans_t desc, locale_t locale)
{
	FIX_LOCALE(locale);
	int i;
	if (desc==NULL) {
		errno = EINVAL;
		return (wc);
	}
	/* Supposing that desc was obtained from locale with wctrans_l,
	 * as stated in 
	 * http://pubs.opengroup.org/onlinepubs/9699919799/functions/towctrans.html */
	return (_towctrans(wc, (_WCTransEntry *)desc));
}



