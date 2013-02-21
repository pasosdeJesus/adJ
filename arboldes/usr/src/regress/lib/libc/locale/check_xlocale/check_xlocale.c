/**
 * Public domain according to Colombian Legislation. 
 * http://www.pasosdejesus.org/dominio_publico_colombia.html
 * 2013. vtamara@pasosdeJesus.org.
 */

#include <xlocale.h>
#include <ctype.h>
#include <inttypes.h>
#include <langinfo.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <wchar.h>
#include <wctype.h>

int bad;

#define p(t) printf("%s:\t ",#t); \
	if (t) { \
		printf("\x1b[38;5;2mOK\x1b[0m\n"); \
	} else { \
		bad++; \
		printf("\x1b[38;5;1mERROR\x1b[0m\n"); \
	}

void test_ctype() {
	char *nl = setlocale(LC_ALL, "es_CO.UTF-8");
	printf("locale %s\n", nl);
	locale_t es_CO_UTF_8 = uselocale(NULL);

	p(wctype("lower") == wctype_l("lower", es_CO_UTF_8));
	p(iswctype(L'ñ', wctype("lower")));
	p(iswctype_l(L'ñ', wctype("lower"), es_CO_UTF_8));
	p(!iswctype_l(L'Ñ', wctype("lower"), es_CO_UTF_8));
	p(isalnum_l('a', es_CO_UTF_8));
	p(isalnum_l('1', es_CO_UTF_8));
	p(iswalnum_l(L'ñ', es_CO_UTF_8));
	p(iswalnum_l(L'1', es_CO_UTF_8));
	p(!iswalnum_l(L' ', es_CO_UTF_8));
	p(isalpha_l('a', es_CO_UTF_8));
	p(!isalpha_l('1', es_CO_UTF_8));
	p(iswalpha_l(L'ñ', es_CO_UTF_8));
	p(!iswalpha_l(L'1', es_CO_UTF_8));
	p(iscntrl_l('\n', es_CO_UTF_8));
	p(!iscntrl_l(' ', es_CO_UTF_8));
	p(iswcntrl(L'\n'));
	p(iswcntrl_l(L'\n', es_CO_UTF_8));
	p(!iswcntrl_l(L'n', es_CO_UTF_8));
	p(isdigit_l('1', es_CO_UTF_8));
	p(!isdigit_l(' ', es_CO_UTF_8));
	p(iswdigit_l(L'1', es_CO_UTF_8));
	p(!iswdigit_l(L'ñ', es_CO_UTF_8));
	p(isgraph_l('a', es_CO_UTF_8));
	p(!isgraph_l('\0', es_CO_UTF_8));
	p(iswgraph_l(L'ñ', es_CO_UTF_8));
	p(!iswgraph_l(L'\0', es_CO_UTF_8));
	p(islower_l('a', es_CO_UTF_8));
	p(!islower_l('A', es_CO_UTF_8));
	p(iswlower_l(L'ñ', es_CO_UTF_8));
	p(!iswlower_l(L'Ñ', es_CO_UTF_8));
	p(iswprint_l(L'ñ', es_CO_UTF_8));
	p(!iswprint_l(L'\0', es_CO_UTF_8));
	p(ispunct_l('.', es_CO_UTF_8));
	p(!ispunct_l(' ', es_CO_UTF_8));
	p(iswpunct_l(L'.', es_CO_UTF_8));
	p(iswpunct_l(L'.', es_CO_UTF_8));
	p(!iswpunct_l(L'ñ', es_CO_UTF_8));
	p(isspace_l(' ', es_CO_UTF_8));
	p(!isspace_l('n', es_CO_UTF_8));
	p(iswspace_l(L' ', es_CO_UTF_8));
	p(!iswspace_l(L'ñ', es_CO_UTF_8));
	p(isupper_l('N', es_CO_UTF_8));
	p(!isupper_l('n', es_CO_UTF_8));
	p(iswupper_l(L'Ñ', es_CO_UTF_8));
	p(iswupper_l(L'Ñ', es_CO_UTF_8));
	p(!iswupper_l(L'ñ', es_CO_UTF_8));
	p(iswxdigit_l(L'a', es_CO_UTF_8));
	p(iswxdigit_l(L'1', es_CO_UTF_8));
	p(iswxdigit_l(L'f', es_CO_UTF_8));
	p(!iswxdigit_l(L'g', es_CO_UTF_8));
	p(isxdigit_l('f', es_CO_UTF_8));
	p(!isxdigit_l('g', es_CO_UTF_8));
	p(digittoint_l(L'1', es_CO_UTF_8) == 1);
	p(isblank_l(' ', es_CO_UTF_8));
	p(!isblank_l('a', es_CO_UTF_8));
	p(iswblank_l(L'\t', es_CO_UTF_8));
	p(!iswblank_l(L'ñ', es_CO_UTF_8));
	p(ishexnumber_l('a', es_CO_UTF_8));
	p(!ishexnumber_l(' ', es_CO_UTF_8));
	p(iswhexnumber_l(L'a', es_CO_UTF_8));
	p(!iswhexnumber_l(L' ', es_CO_UTF_8));
	p(!isideogram_l(' ', es_CO_UTF_8));
	p(iswideogram_l(0x3006, es_CO_UTF_8));
	p(!iswideogram_l(L' ', es_CO_UTF_8));
	p(isnumber_l('1', es_CO_UTF_8));
	p(!isnumber_l(' ', es_CO_UTF_8));
	p(iswnumber_l(L'1', es_CO_UTF_8));
	p(!iswnumber_l(L' ', es_CO_UTF_8));
	p(!isphonogram_l(' ', es_CO_UTF_8));
	p(iswphonogram_l(0x0f00, es_CO_UTF_8));
	p(!iswphonogram_l(L' ', es_CO_UTF_8));
	p(isprint_l('1', es_CO_UTF_8));
	p(!isprint_l('\0', es_CO_UTF_8));
	p(isrune_l('1', es_CO_UTF_8));
	p(!isrune_l(EOF, es_CO_UTF_8));
	p(iswrune_l(L'1', es_CO_UTF_8));
	p(!iswrune_l(WEOF, es_CO_UTF_8));
	p(!isspecial_l('a', es_CO_UTF_8));
	p(iswspecial_l(0x00b2, es_CO_UTF_8));
	p(!iswspecial_l(L'\0', es_CO_UTF_8));
	p(nextwctype(-1, wctype("graph")) > 0);
	p(tolower_l('A', es_CO_UTF_8) == 'a');
	p(_tolower_l('A', es_CO_UTF_8) == 'a');
	p(tolower('A') == 'a');
	p(_tolower('A') == 'a');
	p(towlower_l(L'Á', es_CO_UTF_8) == L'á');
	p(towupper_l(L'á', es_CO_UTF_8) == L'Á');
	p(toupper_l('a', es_CO_UTF_8) == 'A');
	p(toupper('a') == 'A');
	p(_toupper_l('a', es_CO_UTF_8) == 'A');
	p(_toupper('a') == 'A');
	p(wctrans_l("invalido", es_CO_UTF_8) == 0);
	wchar_t lu[7][2] = {{ L'ñ', L'Ñ'},
		{L'á', L'Á'},
		{L'é', L'É'},
		{L'í', L'Í'},
		{L'ó', L'Ó'},
		{L'ú', L'Ú'},
		{L'ü', L'Ü'}
	};
	wctrans_t tl;
	p((tl = wctrans_l("tolower", es_CO_UTF_8)) != 0);
	wctrans_t tu;
	p((tu = wctrans_l("toupper", es_CO_UTF_8)) != 0);
	int c;
	for(c=0; c<7; c++) {
		p(towctrans_l(lu[c][1], tl, es_CO_UTF_8) == lu[c][0]);
		p(towlower_l(lu[c][1], es_CO_UTF_8) == lu[c][0]);
		p(towctrans_l(lu[c][0], tu, es_CO_UTF_8) == lu[c][1]);
		p(towupper_l(lu[c][0], es_CO_UTF_8) == lu[c][1]);
	}


}


void test_wchar() {
	char *mb = "ñ"; // Source must be in UTF8
	char *mbs = "ñoño"; // Una cadena multibyte 
	char *nl = setlocale(LC_ALL, "C.ISO8859-1");  // ISO8859-1
	size_t s;
	printf("locale %s\n", nl);
	p(sizeof(mb) == 8);
	p((s = mblen(mb, 10)) == 1); 
	printf("s=%i\n", s);
	p((s = mbrlen(mb, 10, NULL)) == 1);
	printf("s=%i\n", s);
	p((s = mblen(mbs, 10)) == 1);
	printf("s=%i\n", s);
	nl = setlocale(LC_ALL, "es_CO.ISO8859-1");
	locale_t es_CO_UTF_8 = uselocale(NULL);
	printf("locale %s\n", nl);
	p(mblen_l(mb, 3, es_CO_UTF_8) == 1);
	p(mbrlen_l(mb, 3, NULL, es_CO_UTF_8) == 1);
	p(mblen_l(mbs, 10, es_CO_UTF_8) == 1);
	p(mbrlen_l(mbs, 10, NULL, es_CO_UTF_8) == 1);
	nl = setlocale(LC_ALL, "es_CO.UTF-8");
	printf("locale %s\n", nl);
	p(mblen(mb, 3) == 2);
	p(mbrlen(mb, 3, NULL) == 2);
	p(mblen(mbs, 10) == 2);
	p(mbrlen(mbs, 10, NULL) == 2);
	wchar_t ws[100];
	p((s = mbtowc_l(ws, mb, 3, es_CO_UTF_8)) == 2);
	p((s = mbtowc_l(ws, mbs, 5, es_CO_UTF_8)) == 2);
	unsigned char bp[1000];
	snprintf(bp, 1000, "%lc", *ws);
	p(bp[0]==195 && bp[1]==177 && bp[2]==0)

	wchar_t w = L'á';
	char mb3[10];
	p((s = wctomb_l(mb3, w, es_CO_UTF_8)) == 2);
	mb3[s] = '\0';
	p((s = mbstowcs_l(ws, mb3, 10, es_CO_UTF_8)) == 1);
	p((s = wcstombs_l(mb3, L"uña", 10, es_CO_UTF_8)) == 4);
	mb3[s] = '\0';
	snprintf(bp, 1000, "%s", mb3);
	//printf("bp=%s, bp[0]=%i && bp[1]==%i && bp[2]==%i && bp[3]==%i && bp[4]==%i\n", bp, bp[0], bp[1], bp[2], bp[3], bp[4]);
	p(bp[0]=117 && bp[1]==195 && bp[2]==177 && bp[3]==97);

//	printf("ws(s)=%s\n", ws);
//	printf("ws(ls)=%ls \n", ws);
//	printf("*ws(lc)=%lc \n", *ws);
	p(btowc_l('a', es_CO_UTF_8) == L'a');	
	mbstate_t mbst;
        bzero(&mbst, sizeof(mbst));
	p(mbsinit_l(&mbst, es_CO_UTF_8));
	p((s = mbrtowc_l(&w, "ñ", 3, &mbst, es_CO_UTF_8)) == 2);
	p(mbsinit_l(&mbst, es_CO_UTF_8));
	bp[0] = 0xf8;
	bp[1] = 0x1a;
	bp[2] = 0;
	p((s = mbrtowc_l(&w, "ñ", 1, &mbst, es_CO_UTF_8)) == -2);
	p((s = mbrtowc_l(&w, bp, 1, &mbst, es_CO_UTF_8)) == -1);
	p((s = mbsrtowcs_l(ws, (const char **)&mbs, 7, &mbst, es_CO_UTF_8)) > 0);
	p((s = mbsnrtowcs_l(ws, (const char **)&mbs, 7, 5, &mbst, es_CO_UTF_8)) > 0);
	p((s = wcrtomb_l(bp, L'ñ', &mbst, es_CO_UTF_8)) > 0);
	p((s = mbstowcs_l(ws, "niño", 10, es_CO_UTF_8)) > 0 && wcsncmp(ws, L"niño", 10) == 0);
	p((s = wcsrtombs_l(mb3, (const wchar_t **)&ws, 10, &mbst, es_CO_UTF_8)) > 0);
	p((s = wcsnrtombs_l(bp, (const wchar_t **)&ws, 10, 10, &mbst, es_CO_UTF_8)) > 0);
	p((s = wcswidth_l(ws, 10, es_CO_UTF_8)) == 4);
	p(wctob_l(L'a', es_CO_UTF_8) == 'a');
	p((s = wcwidth_l(L'a', es_CO_UTF_8)) == 1);

}

void
print_locale(void *l);

locale_t
__get_locale(void);

void __print_ctypetable();

#define dpl(__l) printf("%s ", #__l); print_locale(__l);

void test_xlocale() {
	dpl((void *)__get_locale());
	char *nl = setlocale(LC_ALL, "es_CO.UTF-8");
	dpl((void *)__get_locale());
	printf("locale %s\n", nl);
	locale_t es_CO_UTF_8 = uselocale(NULL);
	dpl(es_CO_UTF_8);
	char *r;
	p(strcmp((r = (char *)querylocale(LC_CTYPE, es_CO_UTF_8)), "es_CO.UTF-8") == 0);
	printf("r=%s\n", r);
	p(strcmp((r = (char *)querylocale(LC_COLLATE, es_CO_UTF_8)), "es_CO.UTF-8") == 0);

	p(es_CO_UTF_8 != NULL);
	locale_t esp = newlocale(LC_CTYPE_MASK | LC_COLLATE_MASK, "es_CO.UTF-8", NULL);
	p(es_CO_UTF_8 != esp);
	p(iswlower_l(L'ñ', esp));
	p(!iswlower_l(L'Ñ', esp));

	//__print_ctypetable();
	locale_t esp2 = duplocale(es_CO_UTF_8);
	locale_t esp3 = duplocale(esp2);
	locale_t esp4 = duplocale(esp3);
	locale_t esp5 = duplocale(esp3);
	locale_t esp6 = duplocale(esp3);
	//__collate_print_tables(NULL);
	p(es_CO_UTF_8 != esp2);
	p(freelocale(esp) == 0);
	p(freelocale(esp2) == 0);
	p(freelocale(esp3) == 0);
	p(freelocale(esp4) == 0);
	p(freelocale(esp5) == 0);
	p(freelocale(esp6) == 0);
}

void test_string() 
{
	char *nl = setlocale(LC_ALL, "es_CO.UTF-8");
	locale_t es_CO_UTF_8 = uselocale(NULL);
	printf("locale %s\n", nl);

	p(strcoll_l("b", "é", es_CO_UTF_8) < 0);
	wchar_t wcsb[1000];
	mbstowcs(wcsb, "b", 1000);
	wchar_t wcse[1000];
	mbstowcs(wcse, "é", 1000);
	p(wcscoll_l(wcsb, wcse, es_CO_UTF_8) < 0);
	
	mbstowcs(wcsb, "b", 1000);
	mbstowcs(wcse, "é", 1000);
	p(wcscoll_l(wcsb, wcse, es_CO_UTF_8) < 0);
	p(wcscoll_l(L"b", L"é", es_CO_UTF_8) < 0);
	p(strcoll("á", "e") < 0);
	p(strcoll("ama", "ana") < 0);
	p(strcoll_l("á", "e", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"b", L"é", es_CO_UTF_8) < 0);
	p(wcscoll(L"á", L"e") < 0);
	p(wcscoll_l(L"á", L"e", es_CO_UTF_8) < 0);
	/* Order in spanish*/
	p(wcscoll_l(L" ", L"á", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"á", L"b", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"d", L"é", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"é", L"f", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"h", L"í", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"í", L"j", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"n", L"ñ", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"ñ", L"o", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"ñ", L"ó", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"ó", L"p", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"t", L"ú", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"t", L"ü", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"ú", L"v", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"ü", L"v", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Á", L"B", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"D", L"É", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"É", L"F", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"H", L"Í", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Í", L"J", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"N", L"Ñ", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Ñ", L"O", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Ñ", L"Ó", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Ó", L"P", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"T", L"Ú", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"T", L"Ü", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Ú", L"V", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"Ü", L"V", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"", L"Á", es_CO_UTF_8) < 0);
	p(wcscoll_l(L"á", L"", es_CO_UTF_8) > 0);
	p(wcscoll_l(L"áá", L"á", es_CO_UTF_8) > 0);
	
	wchar_t wa[10], wb[10], we[10], wf[10], wn[10], wegne[10],
		wo[10];

	p(wcsxfrm_l(wo, L"oro", 1000, es_CO_UTF_8) > 0);
	printf("oro wo='%ls'\n", wo);
	p(wcsxfrm_l(wa, L"", 1000, es_CO_UTF_8) >= 0);
	printf("wa='%ls'\n", wa);
	p(wcsxfrm_l(wa, L"á", 1000, es_CO_UTF_8) > 0);
	printf("wa='%ls'\n", wa);
	p(wcsxfrm_l(wb, L"b", 1000, es_CO_UTF_8) > 0);
	printf("wb='%ls'\n", wb);
	p(wcscmp(wa, wb) < 0);
	p(wcsxfrm_l(we, L"é", 1000, es_CO_UTF_8) > 0);
	printf("we='%ls'\n", we);
	p(wcscmp(wb, we) < 0);
	p(wcsxfrm_l(wf, L"f", 1000, es_CO_UTF_8) > 0);
	printf("wf='%ls'\n", wf);
	p(wcscmp(wb, wf) < 0);
	p(wcscmp(we, wf) < 0);
	p(wcsxfrm_l(wn, L"n", 1000, es_CO_UTF_8) > 0);
	printf("wn='%ls'\n", wn);
	p(wcsxfrm_l(wegne, L"ñ", 1000, es_CO_UTF_8) > 0);
	printf("wegne='%ls'\n", wegne);
	p(wcsxfrm_l(wo, L"o", 1000, es_CO_UTF_8) > 0);
	printf("o wo='%ls'\n", wo);
	p(wcsxfrm_l(wo, L"oso", 1000, es_CO_UTF_8) > 0);
	printf("oso wo='%ls'\n", wo);
	p(wcscmp(wn, wegne) < 0);
	p(wcscmp(wegne, wo) < 0);
	
	char a[1000], b[1000], e[1000], f[1000];
	size_t sr = 0;
	__collate_print_tables(NULL);
	p((sr = strxfrm_l(NULL, "equis", 0, es_CO_UTF_8)) == 5);
	p(strxfrm_l(NULL, "", 1000, es_CO_UTF_8) == 0);
	p(strxfrm_l(a, "", 1000, es_CO_UTF_8) == 0 && a[0] == '\0');
	p(strxfrm_l(a, "á", 1000, es_CO_UTF_8) > 0);
	p(strxfrm_l(b, "b", 1000, es_CO_UTF_8) > 0);
	p(strcmp(a, b) < 0);
	p(strxfrm_l(e, "é", 1000, es_CO_UTF_8) > 0);
	printf("é e=%s\n", e);
	p(strcmp(b, e) < 0);
	p(strxfrm_l(f, "f", 1000, es_CO_UTF_8) > 0);
	p(strcmp(b, f) < 0);
	p(strcmp(e, f) < 0);
	p(strxfrm_l(e, "éa", 1000, es_CO_UTF_8) > 0);
	printf("e=%s\n", e);
	p(strxfrm_l(f, "éb", 1000, es_CO_UTF_8) > 0);
	printf("f=%s\n", f);
	p(strcmp(e, f) < 0);
	p(strxfrm_l(f, "oso", 1000, es_CO_UTF_8) > 0);
	printf("oso f=%s\n", f);
	p(strcmp(e, f) < 0);

	p(strcasecmp_l("n", "N", es_CO_UTF_8) == 0);
	p(strcasecmp_l("largo", "largote", es_CO_UTF_8) < 0);
	p(strcasecmp_l("cortote", "corto", es_CO_UTF_8) > 0);
	p(strncasecmp_l("n", "N", 1, es_CO_UTF_8) == 0);
	p(strcasestr_l("nino", "O", es_CO_UTF_8) != NULL);
	p(wcscasecmp_l(L"ñ", L"Ñ", es_CO_UTF_8) == 0);
	p(wcscasecmp_l(L"á", L"b", es_CO_UTF_8) < 0);
	p(wcscasecmp_l(L"a", L"á", es_CO_UTF_8) <= 0);
	p(wcscasecmp_l(L"", L"á", es_CO_UTF_8) < 0);
	p(wcscasecmp_l(L"", L"a", es_CO_UTF_8) < 0);
	p(wcscasecmp_l(L"", L"a", es_CO_UTF_8) < 0);
	p(wcscasecmp_l(L"á", L"", es_CO_UTF_8) > 0);
	p(wcscasecmp_l(L"áá", L"á", es_CO_UTF_8) > 0);
	p(wcsncasecmp_l(L"n", L"N", 1, es_CO_UTF_8) == 0);
}


int main()
{
	test_wchar();
	test_ctype();
	test_string();
	test_xlocale();
	
	return bad != 0;
}
