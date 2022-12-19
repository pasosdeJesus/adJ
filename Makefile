# Reglas para generar HTML, PostScript y PDF 
# Basadas en reglas de dominio público de repasa
# http://structio.sourceforge.net/repasa


include Make.inc

SOURCE_GBFXML=mateo.gbfxml marcos.gbfxml lucas.gbfxml juan.gbfxml hechos.gbfxml romanos.gbfxml corintios1.gbfxml

EXT_DOCBOOK=xdbk

VS_SWORDBOOK_I=I Corinthians
#VS_SWORDBOOK_I=Acts
VS_SWORDBOOK=I_Corinthians
#VS_SWORDBOOK=Acts

# Variables requeridas por comdocbook.mak
SOURCES=$(PROYECTO).$(EXT_DOCBOOK)

IMAGES=

HTML_DIR=html

HTML_TARGET=$(HTML_DIR)/$(PROYECTO).html

XSLT_HTML=estilohtml.xsl

PRINT_DIR=imp

DSSSL_PRINT=estilo.dsl\#print

DSSSL_HTML=estilo.dsl\#html

OTHER_HTML=

# INDEX=
# Si se debe generar índice, nombre del archivo por generar (incluirlo en documento)


# Variables requeridas por comdist.mk

GENDIST=Desarrollo.txt Derechos.txt $(SOURCES) $(IMAGES) 
# Dependencias para generar distribución

ACTHOST=traduccion.pasosdeJesus.org
ACTDIR=/var/www/pasosdeJesus/traduccion/
USER=vtamara


GENACT=dist all $(PROYECTO)-$(PRY_VERSION)_html.tar.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf #gutenberg 
# Reglas por emplear antes de actualizar sitio en Internet

FILESACT=$(PROYECTO)-$(PRY_VERSION).tar.gz $(PROYECTO)-$(PRY_VERSION)_html.tar.gz $(HTML_TARGET) gutenberg/$(PROYECTO).txt $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf 
# Archivos que se debe actualizar en sitio de Internet

$(HTML_TARGET).bak: gbfxml2html.xsl $(PROYECTO).gbfxml 
	mkdir -p $(HTML_DIR)/
	cp $(PROYECTO).css $(HTML_DIR)/
	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) $(XSLTPROC) --stringparam outlang es --catalogs --nonet gbfxml2html.xsl $(PROYECTO).gbfxml > $(HTML_TARGET).bak
	sed -e "s/biblia_dp/$(PROYECTO)/g" $(HTML_TARGET).bak > $(HTML_TARGET)

multi: gbfxml2vhtml.xsl $(PROYECTO).gbfxml
	mkdir -p $(HTML_DIR)/
	cp -f $(PROYECTO).css $(PROYECTO).js $(HTML_DIR)/
	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) $(XSLTPROC) --stringparam outlang es --stringparam css $(PROYECTO).css --catalogs --nonet gbfxml2vhtml.xsl $(PROYECTO).gbfxml 


all: $(HTML_TARGET).bak $(PRINT_DIR)/$(PROYECTO).ps $(PRINT_DIR)/$(PROYECTO).pdf

valida-gbfxml: 
	$(XMLLINT) --catalogs $(PROYECTO).gbfxml

$(PROYECTO).$(EXT_DOCBOOK): $(PROYECTO).gbfxml $(SOURCE_GBFXML) derechos.gbfxml biblio.gbfxml

# Reglas para generar HTML y texto con formato Gutenberg
 
gutenberg: gutenberg/$(GUTNUM)

gutenberg/$(GUTNUM): gutenberg/$(PROYECTO).html gutenberg/$(PROYECTO)-2.txt gutenberg/$(PROYECTO)-$(PRY_VERSION).zip
	mkdir -p gutenberg/$(GUTNUM)
	mkdir -p gutenberg/$(GUTNUM)/$(GUTNUM)-h
	mkdir -p gutenberg/$(GUTNUM)/$(GUTNUM)-x
	cp gutenberg/$(PROYECTO)-2.txt gutenberg/$(GUTNUM)/$(GUTNUM)-8.txt
	cd gutenberg/$(GUTNUM); zip $(GUTNUM).zip $(GUTNUM)-8.txt
	cp gutenberg/$(PROYECTO).html gutenberg/$(GUTNUM)/$(GUTNUM)-h/$(GUTNUM)-h.html
	cd gutenberg/$(GUTNUM); zip -r $(GUTNUM)-h.zip $(GUTNUM)-h
	$(XMLLINT) --noent --format $(PROYECTO).gbfxml > gutenberg/$(GUTNUM)/$(GUTNUM)-x/$(GUTNUM)-x.xml
	cp gutenberg/$(PROYECTO)-$(PRY_VERSION).zip gutenberg/$(GUTNUM)/$(GUTNUM)-x/$(GUTNUM)-x.zip

 
herram/u2d: herram/u2d.c
	$(CC) -o herram/u2d herram/u2d.c

gutenberg/$(PROYECTO).html: html/$(PROYECTO).html
	-$(TIDY) html/$(PROYECTO).html | \
	$(AWK) 'function mayusculas(str) { r=toupper(str); gsub(/á/,"Á",r); gsub(/é/,"É",r); gsub(/í/,"Í",r); gsub(/ó/,"Ó",r); gsub(/ú/,"Ú",r); return r}\
	/<title>/ { nopr=1; } \
	/<\/title>/ { $$0="<title>The Project Gutenberg eBook of $(PRY_DESC)</title>"; nopr=0; } \
	/<h1 class="title">/ { h1tit=1; nopr=1; } \
	/<\/h1>/ { if (h1tit==1) { $$0="<h1 class=\"title\">The Project Gutenberg eBook of $(PRY_DESC)</h1>\n<pre>This eBook is for the use of anyone anywhere at no cost and with\nalmost no restrictions whatsoever.  You may copy it, give it away or\nre-use it under the terms of the Project Gutenberg License included\nwith this eBook or online at <a href =\" http://www.gutenberg.net\">www.gutenberg.net</a></pre>\n<p>Title: $(PRY_DESC)</p>\n <p>Release Date: $(GUTDATE) [eBook #$(GUTNUM)]</p>\n <p>Language: Spanish </p>\n <p>Character set encoding: iso-8859-1</p>\n <p>***START OF THE PROJECT GUTENBERG EBOOK " dup "***</p>\n<br><center><b>Development site <a href=\"$(URLSITE)\">$(URLSITE)</a></b></center><br>\n<hr class=\"full\">"; nopr=0;} }  \
	/<\/body>/ { print "<hr class=\"full\">\n<p>***END OF THE PROJECT GUTENBERG EBOOK " dup "***</p>\n <p>******* This file should be named $(GUTNUM)-h.html or $(GUTNUM)-h.zip *******</p>\n <p>This and all associated files of various formats will be found in:<br />\n <a href=\"$(GUTURL)\">$(GUTURL)</a></p>\n"; system("cat gutenberg/footer.inc"); } \
	/.*/ { if (nopr!=1) { print $0; }} \
	BEGIN { dup=mayusculas("$(PRY_DESC)"); nopr=0;} ' > gutenberg/$(PROYECTO).html

 
gutenberg/$(PROYECTO).txt: gutenberg/$(PROYECTO).t3 herram/u2d
	$(SED) -e "s/ $$//g" gutenberg/$(PROYECTO).t3 | \
	herram/u2d >gutenberg/$(PROYECTO).txt
	echo "Revisar con gutcheck"

gutenberg/$(PROYECTO)-2.txt: gutenberg/$(PROYECTO)-2.t3 herram/u2d
	$(SED) -e "s/ $$//g" gutenberg/$(PROYECTO)-2.t3 | \
	herram/u2d >gutenberg/$(PROYECTO)-2.txt
	echo "Revisar con gutcheck"

gutenberg/$(PROYECTO).t3: gutenberg/$(PROYECTO).t2  
	$(PERL) herram/gut-form2.pl gutenberg/$(PROYECTO).t2 >gutenberg/$(PROYECTO).t3

gutenberg/$(PROYECTO)-2.t3: gutenberg/$(PROYECTO)-2.t2  
	$(PERL) herram/gut-form2.pl gutenberg/$(PROYECTO)-2.t2 >gutenberg/$(PROYECTO)-2.t3

gutenberg/$(PROYECTO).t2: gutenberg/$(PROYECTO).t1
	$(AWK) -f herram/gut-form1.awk gutenberg/$(PROYECTO).t1 > gutenberg/$(PROYECTO).t2

gutenberg/$(PROYECTO)-2.t2: gutenberg/$(PROYECTO)-2.t1
	$(AWK) -f herram/gut-form1.awk gutenberg/$(PROYECTO)-2.t1 > gutenberg/$(PROYECTO)-2.t2

gutenberg/$(PROYECTO).t1: html/$(PROYECTO).html
	$(W3M) -cols 68 -dump html/$(PROYECTO).html | $(SED) -e "s/$(GUTNUM)-h.html/$(GUTNUM)-8.txt/g;s/$(GUTNUM)-h.zip/$(GUTNUM).zip/g;s/\^[ ]*$$//g" > gutenberg/$(PROYECTO).t1
 
gutenberg/$(PROYECTO)-2.t1: gutenberg/$(PROYECTO).html
	$(W3M) -cols 68 -dump gutenberg/$(PROYECTO).html | $(SED) -e "s/$(GUTNUM)-h.html/$(GUTNUM)-8.txt/g;s/$(GUTNUM)-h.zip/$(GUTNUM).zip/g;s/\^[ ]*$$//g" > gutenberg/$(PROYECTO)-2.t1
 
gutenberg/$(PROYECTO)-$(PRY_VERSION).zip: dist
	$(TAR) xvfz $(PROYECTO)-$(PRY_VERSION).tar.gz
	rm -f gutenberg/$(PROYECTO)-$(PRY_VERSION).zip
	$(ZIP) -r gutenberg/$(PROYECTO)-$(PRY_VERSION).zip $(PROYECTO)-$(PRY_VERSION)

gutact: gutenberg
	$(NCFTPPUT) -u $(USER) $(ACTHOST) bdp/$(GUTNUM)/$(GUTNUM)-h gutenberg/$(GUTNUM)/$(GUTNUM)-h/*
	$(NCFTPPUT) -u $(USER) $(ACTHOST) bdp/$(GUTNUM)/$(GUTNUM)-x gutenberg/$(GUTNUM)/$(GUTNUM)-x/*
	$(NCFTPPUT) -u $(USER) $(ACTHOST) bdp/$(GUTNUM) gutenberg/$(GUTNUM)/*.{txt,zip}


# Reglas para revisar ortografía con ispell (al texto plano)

ispell-gut: gutenberg/$(PROYECTO).txt ispell/$(PROYECTO).ispell
	$(ISPELL) -d spanish -p ispell/$(PROYECTO).ispell gutenberg/$(PROYECTO).txt

# Para usar DocBook
include herram/comdocbook.mak

# To crear distribución de fuentes y actualizar en Internet
include herram/comdist.mak

instala:
	$(MKDIR) -p $(DESTDIR)$(INSDOC)
	$(CP) html/*html $(DESTDIR)$(INSDOC)
	$(CP) imp/*ps $(DESTDIR)$(INSDOC)
	$(CP) imp/*pdf $(DESTDIR)$(INSDOC)

instalahtml:
	$(MKDIR) -p $(DESTDIR)$(INSDOC)
	$(CP) html/*html $(DESTDIR)$(INSDOC)

desinstala:
	$(RM) -rf $(DESTDIR)$(INSDOC)

# Elimina hasta configuración
limpiadist: limpiamas
	rm -f confv.sh confv.ent Make.inc
	if (test "$(GUT)" = "") then { rm -f gutenberg/$(PROYECTO).*; } fi

# Elimina archivos generables
limpiamas: limpia
	rm -rf $(HTML_DIR)
	rm -rf $(PRINT_DIR)
	rm -f img/*.eps img/*.ps
	rm -f $(PROYECTO)-$(PRY_VERSION).tar.gz
	rm -f $(PROYECTO).$(EXT_DOCBOOK)
	rm -f $(PROYECTO)-$(PRY_VERSION)_html.tar.gz
	rm -f $(PROYECTO)-4.1.2*
	rm -f herram/u2d
	rm -f gutenberg/t1.txt

# Elimina backups y archivos temporales
limpia:
	rm -f *bak *~ *tmp confaux.tmp $(PROYECTO)-$(PRY_VERSION)_html.tar.gz
	rm -f $(PROYECTO)-4.1.2.$(EXT_DOCBOOK)

.SUFFIXES: .$(EXT_DOCBOOK) .gbfxml .gbf .txt

.gbfxml.$(EXT_DOCBOOK): gbfxml2db.xsl
	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) $(XSLTPROC) --stringparam outlang es --catalogs --nonet gbfxml2db.xsl $< > $@

#.gbfxml.txt: gbfxml2txt.xsl
#	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) $(XSLTPROC) --stringparam outlang es --catalogs --nonet gbfxml2txt.xsl $< > $@  # Por ahora está mejor w3m

.gbf.gbfxml:
	($(AWK) -f gbf2gbfxml.awk $< > $@ ; \
	if (test "$$?" != "0") then { \
		tail $@; \
		exit 1; \
	} fi;)

$(PROYECTO).$(EXT_DOCBOOK): $(PROYECTO).gbfxml

Derechos.txt: derechos.gbfxml
	$(MAKE) $(HTML_TARGET)
	$(W3M) -cols 70 -dump $(HTML_TARGET) | $(AWK) -f herram/arrderechos.awk > Derechos.txt

Desarrollo.txt: herram/vim/ftplugin/gbfxml.vim
	cp Desarrollo.txt Desarrollo.txt.bak
	INICIO="Las completaciones disponibles" CMD="$(AWK) -f herram/exdocvimgbfxml.awk herram/vim/ftplugin/gbfxml.vim" $(AWK) -f herram/rempbloquearch.awk Desarrollo.txt.bak > Desarrollo.txt

KJV.imp: 
	-if (test ! -f /usr/local/share/sword/mods.d/kjv.conf  -o ! -f /usr/share/sword/mods.d/kjv.conf) then { echo "Parece que le falta instalar modulo KJV"; } fi;
	mod2imp KJV > KJV.imp

$(VS_SWORDBOOK)-KJV.tmp: KJV.imp
	awk '/.*/ { if (imp==1) { print $$0; } } /\$$\$$\$$.*/ { match($$0,/ [0-9]/); n=substr($$0, 4, RSTART-4); if (n=="$(VS_SWORDBOOK_I)") { imp=1; } else { imp=0; } }' KJV.imp > /tmp/kjv-awk
	sed -e "s/<w /|<w /g" /tmp/kjv-awk | tr "|" "\n" | sed -e  "s/ [ ]*$$//g" | sed -e "s/\(<\/w>[.,;]*\)[ ]*\(.\)/\1|\2/g" | tr "|" "\n" > $(VS_SWORDBOOK)-KJV.tmp

$(VS_SWORDBOOK)-n-KJV.tmp: $(VS_SWORDBOOK)-KJV.tmp
	grep -v '^[ ]*$$' $(VS_SWORDBOOK)-KJV.tmp | \
		grep -v "Heading \]" |\
		grep -v "strongsMarkup" | \
		grep -v "^[A-Za-z].*" | \
		grep -v "^<q .*" | \
		sed -e 's/.*src=.\([0-9]*\).*:G\([0-9]*\).*x-Robinson:\([^"]*\)".*/\1,\2,\3/g' | \
		sed -e 's/.*lemma="strong:G\([0-9]*\) *\([^"]*\)".*morph="robinson:\([^ "]*\) *\([^"]*\)".*src="\([0-9]*\) *\([^"]*\)".*/\5,\1,\3|lemma="\2" morph="\4" src="\6"/g' |\
		sed -e 's/lemma="strong:G\([0-9]*\) *\([^"]*\)".*morph="robinson:\([^ "]*\) *\([^"]*\)".*src="\([0-9]*\) *\([^"]*\)".*/\5,\1,\3|lemma="\2" morph="\4" src="\6"/g' |\
		sed -e 's/lemma="strong:G\([0-9]*\) *\([^"]*\)".*morph="robinson:\([^ "]*\) *\([^"]*\)".*src="\([0-9]*\) *\([^"]*\)".*/\5,\1,\3|lemma="\2" morph="\4" src="\6"/g' |\
		sed -e 's/lemma="strong:G\([0-9]*\) *\([^"]*\)".*morph="robinson:\([^ "]*\) *\([^"]*\)".*src="\([0-9]*\) *\([^"]*\)".*/\5,\1,\3|lemma="\2" morph="\4" src="\6"/g' |\
		sed -e 's/|lemma="".*morph="".*src="".*//g' |\
		sed -e 's/|lemma="lemma.TR.*//g' | \
		sed -e 's/.*lemma="strong:G\([0-9]*\)"  *src="\([0-9]*\)" *>/\2,\1, /g' |\
		sed -e 's/\$$\$$\$$[^0-9]*\([0-9][0-9:]*\)/\1/g' | \
		grep "^[0-9]" | tr "|" "\n" > $(VS_SWORDBOOK)-n-KJV.tmp
	#grep -v '^[ ]*$$' $(VS_SWORDBOOK)-KJV.tmp | grep -v "Heading \]" | grep -v "strongsMarkup" | grep -v "^[A-Za-z].*" | grep -v "^<q .*" | sed -e 's/.*src=.\([0-9]*\).*:G\([0-9]*\).*x-Robinson:\([^"]*\)".*/\1,\2,\3/g;s/.*lemma="strong:G\([0-9]*\) *\([^"]*\)".*morph="robinson:\([^ "]*\) *\([^"]*\)".*src="\([0-9]*\) *\([^"]*\)".*/\5,\1,\3|lemma="strong:\2" morph="robinson:\4" src="\6"/g;s/1,\3,\7|\12,\4,\8/g;s/.*lemma="strong:G\([0-9]*\) strong:G\([0-9]*\) strong:G\([0-9]*\)".*robinson:\([^ ]*\) robinson:\([^ ]*\) robinson:\([^"]*\)".*src="\([0-9]*\) \([0-9]*\) \([0-9]*\)".*/\7,\1,\4|\8,\2,\5|\9,\3,\6/g;s/.*lemma="strong:G\([0-9]*\) strong:G\([0-9]*\)".*robinson:\([^ ]*\) robinson:\([^"]*\)".*src="\([0-9]*\) \([0-9]*\)".*/\5,\1,\3|\6,\2,\4/g;s/.*lemma="strong:G\([0-9]*\).*robinson:\([^"]*\)".*src=.\([0-9]*\).*/\3,\1,\2/g;s/.*lemma="strong:G\([0-9]*\)"  *src="\([0-9]*\)" *>/\2,\1, /g;s/\$$\$$\$$[^ ]* \([0-9:]*\)/\1/g' | grep "^[0-9]" | tr "|" "\n" > $(VS_SWORDBOOK)-n-KJV.tmp
# Formato tanto de sword-1.5.8 como 1.5.10

$(VS_SWORDBOOK)-o-KJV.tmp: $(VS_SWORDBOOK)-n-KJV.tmp
	-awk -f herram/ordenastrong.awk $(VS_SWORDBOOK)-n-KJV.tmp > $(VS_SWORDBOOK)-o-KJV.tmp

valida-strong: $(VS_SWORDBOOK)-o-KJV.tmp
	-xsltproc gbfxml2strong.xsl libro_dp.gbfxml > strong-dp.tmp
	-awk -f herram/ordenastrong.awk strong-dp.tmp > strong-o-dp.tmp 
	diff -b $(VS_SWORDBOOK)-o-KJV.tmp strong-o-dp.tmp


html/em.html: gbfxml2html.xsl biblia_dp.gbfxml  mateo.gbfxml
	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) $(XSLTPROC) --stringparam outlang es --catalogs --nonet gbfxml2html.xsl biblia_dp.gbfxml > html/em.html

valida-formateo: 
	echo "Espacios horizontales que posiblemente deben omitirse (para que no quede espacio entre número de versículo y la primera palabra del mismo)"
	-xmllint --noent biblia_dp.gbfxml | grep "<t xml:lang=.es.>[^/]*\/>[ ]*$$" 
	echo "Espacios horizontales que posiblemente deben añadirse (para que al ver números strong quede espacio entre uno y otro que no tienen palabra en español asociada)"
	-xmllint --noent biblia_dp.gbfxml | grep -n "<wi[^/]*\/><wi[^/]*\/>"
	-xmllint --noent biblia_dp.gbfxml | grep -n "\/wi><wi"
	echo "Marcado errado"
	-xmllint --noent biblia_dp.gbfxml | grep -n "type=\"G\" value=\"[0-9]*\""
	echo "Apostrofes por cambiar por ´"
	-xmllint --noent biblia_dp.gbfxml | grep -n "\`[^\´']*\'"
	echo "Signos de puntuación fuera de \` \´"
	-xmllint --noent biblia_dp.gbfxml | grep -n "\´\."
	-xmllint --noent biblia_dp.gbfxml | grep -n "\´\,"
	echo "Marcación Strong errada"
	grep "wi type=\"G[^C]" biblia_dp.gbfxml | grep -v "wi type=\"G\""
	echo "Errores comunes"
	grep "i<w" biblia_dp.gbfxml

