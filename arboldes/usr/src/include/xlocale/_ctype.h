/**
 * Public domain according to Colombian Legislation. 2013. vtamara@pasosdeJesus.org.
 * http://www.pasosdejesus.org/dominio_publico_colombia.html
 *
 * Based on xlocale/_ctype from FreeBSD
 */

#if !defined(_XLOCALE_CTYPE_H)

#include <sys/types.h>
#include <runetype.h>

#define _XLOCALE_WCTYPE_H
#define _XLOCALE_CTYPE_H

#ifndef _LOCALE_T_DEFINED
#define _LOCALE_T_DEFINED
typedef struct	_xlocale *locale_t;
#endif

#ifndef	_WCTYPE_T_DEFINED_
#define	_WCTYPE_T_DEFINED_
typedef	__wctype_t	wctype_t;
#endif

#ifndef	_WINT_T_DEFINED_
#define	_WINT_T_DEFINED_
typedef	__wint_t	wint_t;
#endif

#ifndef _WCTRANS_T_DEFINED_
#define _WCTRANS_T_DEFINED_
typedef __wctrans_t     wctrans_t;
#endif

#ifndef _RUNE_T_DEFINED_
#define _RUNE_T_DEFINED_
typedef uint32_t        rune_t;
#endif

#ifndef _XLOCALE_RUN_FUNCTIONS_DEFINED
#define _XLOCALE_RUN_FUNCTIONS_DEFINED 1
unsigned long	 ___runetype_l(rune_t, locale_t) __pure;
_RuneLocale	*__runes_for_locale(locale_t, int*);
#endif

inline int iswctype_l(wint_t, wctype_t, locale_t);

inline int isalnum_l(int, locale_t);

inline int isalpha_l(int, locale_t);

inline int isblank_l(int, locale_t);

inline int iscntrl_l(int, locale_t);

inline int isdigit_l(int, locale_t);

inline int isgraph_l(int, locale_t);

inline int ishexnumber_l(int, locale_t);

inline int isideogram_l(int, locale_t);

inline int islower_l(int, locale_t);

inline int isnumber_l(int, locale_t);

inline int isphonogram_l(int, locale_t);

inline int isprint_l(int, locale_t);

inline int ispunct_l(int, locale_t);

inline int isrune_l(int, locale_t);

inline int isspace_l(int, locale_t);

inline int isspecial_l(int, locale_t);

inline int isupper_l(int, locale_t);

inline int isxdigit_l(int, locale_t);

inline int iswalnum_l(wint_t, locale_t);

inline int iswalpha_l(wint_t, locale_t);

inline int iswblank_l(wint_t, locale_t);

inline int iswcntrl_l(wint_t, locale_t);

inline int iswdigit_l(wint_t, locale_t);

inline int iswgraph_l(wint_t, locale_t);

inline int iswhexnumber_l(wint_t, locale_t);

inline int iswideogram_l(wint_t, locale_t);

inline int iswlower_l(wint_t, locale_t);

inline int iswnumber_l(wint_t, locale_t);

inline int iswphonogram_l(wint_t, locale_t);

inline int iswprint_l(wint_t, locale_t);

inline int iswpunct_l(wint_t, locale_t);

inline int iswrune_l(wint_t, locale_t);

inline int iswspace_l(wint_t, locale_t);

inline int iswspecial_l(wint_t, locale_t);

inline int iswupper_l(wint_t, locale_t);

inline int iswxdigit_l(wint_t, locale_t);

inline wint_t towlower_l(wint_t, locale_t);

inline wint_t towupper_l(wint_t, locale_t);

inline int __wcwidth_l(rune_t, locale_t);

int iswctype_l(wint_t, wctype_t, locale_t);

wctype_t wctype_l(const char *, locale_t);

wint_t towctrans_l(wint_t, wctrans_t, locale_t);

wint_t nextwctype_l(wint_t, wctype_t, locale_t);

wctrans_t wctrans_l(const char *, locale_t);

inline int digittoint_l(int, locale_t);

inline int tolower_l(int, locale_t);

inline int toupper_l(int, locale_t);

inline int _tolower_l(int, locale_t);

inline int _toupper_l(int, locale_t);
#endif /* !defined(_XLOCALE_CTYPE_H) */
