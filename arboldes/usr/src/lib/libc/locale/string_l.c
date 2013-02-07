/**
 * Public domain according to Colombian Legislation. 2013. vtamara@pasosdeJesus.org.
 * http://www.pasosdejesus.org/dominio_publico_colombia.html
 *
 * Parts based on wcscoll.c, strcoll.c, wcsxfrm.c and strxfrm.c from FreeBSD
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



int
wcscoll_l(const wchar_t *s, const wchar_t *s2, locale_t locale)
{
	int len, len2, ret, ret2;
	wint_t prim, prim2, sec, sec2;
	const wchar_t *t, *t2;
	wchar_t *tt, *tt2;
	FIX_LOCALE(locale);
	struct xlocale_collate *table = 
		((struct xlocale_collate *)(locale)->components[XLC_COLLATE]);

	if (table->__collate_load_error)
		return wcscmp(s, s2);

	len = len2 = 1;
	ret = ret2 = 0;
	if (table->__collate_substitute_nontrivial) {
		t = tt = __collate_substitute_w(table, s);
		t2 = tt2 = __collate_substitute_w(table, s2);
	} else {
		tt = tt2 = NULL;
		t = s;
		t2 = s2;
	}
	while(*t && *t2) {
		prim = prim2 = 0;
		while(*t && !prim) {
			__collate_lookup_w(table, t, &len, &prim, &sec);
			t += len;
		}
		while(*t2 && !prim2) {
			__collate_lookup_w(table, t2, &len2, &prim2, &sec2);
			t2 += len2;
		}
		if(!prim || !prim2)
			break;
		if(prim != prim2) {
			ret = prim - prim2;
			goto end;
		}
		if(!ret2)
			ret2 = sec - sec2;
	}
	if(!*t && *t2)
		ret = -(int)((u_char)*t2);
	else if(*t && !*t2)
		ret = (u_char)*t;
	else if(!*t && !*t2)
		ret = ret2;
  end:
	free(tt);
	free(tt2);

	return ret;
}


size_t
wcsxfrm_l(wchar_t * __restrict dest, const wchar_t * __restrict src, size_t len, locale_t locale)
{
	wint_t prim, sec;
	int l;
	size_t slen;
	wchar_t *s, *ss;
	FIX_LOCALE(locale);
	struct xlocale_collate *table =
		(struct xlocale_collate*)locale->components[XLC_COLLATE];

	if (!*src) {
		if (len > 0 && dest != NULL)
			*dest = '\0';
		return 0;
	}

	if (table->__collate_load_error)
		return wcslcpy(dest, src, len);

	slen = 0;
	prim = sec = 0;
	ss = s = __collate_substitute_w(table, src);
	while (*s != L'\0') {
		while (*s != L'\0' && !prim) {
			__collate_lookup_w(table, s, &l, &prim, &sec);
			s += l;
		}
		if (prim) {
			if (len > 1) {
			       	if (dest != NULL) {
					*dest++ = prim;
				}
				len--;
			}
			slen++;
			prim = 0;
		}
	}
	free(ss);
	if (len > 0 && dest != NULL) {
		*dest = '\0';
	}

	return slen;
}


/** Duplicate a mb string as wc string, 
 * see https://buildsecurityin.us-cert.gov/bsi/articles/knowledge/coding/769-BSI.html */
wchar_t *__dup_as_wcs_l(const char *s, locale_t locale)
{
	int numc = mbstowcs(NULL, s, 0) + 1; 
	if (numc == 0 || numc > ULONG_MAX / sizeof(wchar_t)) { 
		errno = EINVAL;
		return NULL;
	}
	wchar_t *ws = (wchar_t *)malloc(numc * sizeof(wchar_t) );
	if (ws == NULL) {
		errno = ENOMEM;
		return NULL;
	}
	mbstowcs_l(ws, s, numc, locale);

	return ws;
}


int
strcoll_l(const char *s, const char *s2, locale_t locale)
{
	int r = 0;
	wchar_t *ws = NULL;
	wchar_t *ws2 = NULL;

	ws = __dup_as_wcs_l(s, locale);
	if (ws != NULL) {
		ws2 = __dup_as_wcs_l(s2, locale);
		if (ws2 != NULL) {
			r = wcscoll_l(ws, ws2, locale);
		}
	}
	if (ws != NULL) {
		free(ws);
	}
	if (ws2 != NULL) {
		free(ws2);
	}
	return r;
}


size_t
strxfrm_l(char * __restrict dest, const char * __restrict src, size_t len, 
		locale_t locale)
{
	size_t r = 0;
	wchar_t *ws = NULL;
	wchar_t *wd = NULL;

	ws = __dup_as_wcs_l(src, locale);
	if (ws != NULL) {
		if (len > 0 && dest != NULL) {
			if (len > ULONG_MAX / sizeof(wchar_t)) { 
				errno = EINVAL;
				goto end;
			}
			wd = (wchar_t *)malloc(len * sizeof(wchar_t) );
			if (wd == NULL) {
				errno = ENOMEM;
				goto end;
			}
		}
		r = wcsxfrm_l(wd, ws, len, locale);
		if (len>0 && dest != NULL) {
			wcstombs_l(dest, wd, len, locale);
		}
	}
end:
	if (ws != NULL) {
		free(ws);
	}
	if (wd != NULL) {
		free(wd);
	}
	return r; 
}


