# Reglas para generar HTML, PostScript y PDF 
# Basadas en reglas de dominio público de repasa
# http://structio.sourceforge.net/repasa


include Make.inc

SOURCE_GBFXML=mateo.gbfxml marcos.gbfxml lucas.gbfxml juan.gbfxml

EXT_DOCBOOK=xdbk

# Variables requeridas por comdocbook.mak
SOURCES=$(PROYECTO).$(EXT_DOCBOOK)

IMAGES=

HTML_DIR=html

HTML_TARGET=$(HTML_DIR)/$(PROYECTO).html

XSLT_HTML=estilohtml.xsl

PRINT_DIR=imp

DSSSL_PRINT=estilo.dsl#print

OTHER_HTML=

# INDEX=
# Si se debe generar índice, nombre del archivo por generar (incluirlo en documento)


# Variables requeridas por comdist.mk

GENDIST=Desarrollo.txt Derechos.txt $(SOURCES) $(IMAGES) 
# Dependencias para generar distribución

ACTHOST=ftp.de.geocities.com
ACTDIR=bdp
USER=nuestroamigojesus


GENACT=dist all $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf $(PROYECTO)-$(PRY_VERSION)_html.tar.gz gutenberg
# Reglas por emplear antes de actualizar sitio en Internet

FILESACT=$(PROYECTO)-$(PRY_VERSION).tgz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).ps.gz $(PRINT_DIR)/$(PROYECTO)-$(PRY_VERSION).pdf $(PROYECTO)-$(PRY_VERSION)_html.tar.gz $(HTML_TARGET) gutenberg/$(PROYECTO).txt
# Archivos que se debe actualizar en sitio de Internet


all: $(HTML_TARGET) $(PRINT_DIR)/$(PROYECTO).ps $(PRINT_DIR)/$(PROYECTO).pdf

valida: 
	xmllint --catalogs $(PROYECTO).gbfxml

$(PROYECTO).$(EXT_DOCBOOK): $(PROYECTO).gbfxml $(SOURCE_GBFXML) derechos.gbfxml biblio.gbfxml

# Reglas para generar HTML y texto con formato Gutenberg
 
gutenberg: gutenberg/$(PROYECTO).html gutenberg/$(PROYECTO).txt
 
herram/u2d: herram/u2d.c
	$(CC) -o herram/u2d herram/u2d.c

gutenberg/$(PROYECTO).html: html/$(PROYECTO).html
	-tidy html/$(PROYECTO).html > gutenberg/$(PROYECTO).html
 
gutenberg/$(PROYECTO).txt: gutenberg/$(PROYECTO).t3 herram/u2d
	$(SED) -e "s/ $$//g" gutenberg/$(PROYECTO).t3 | \
	herram/u2d >gutenberg/$(PROYECTO).txt
	echo "Revisar con gutcheck"

gutenberg/$(PROYECTO).t3: gutenberg/$(PROYECTO).t2  
	perl herram/gut-form2.pl gutenberg/$(PROYECTO).t2 >gutenberg/$(PROYECTO).t3

gutenberg/$(PROYECTO).t2: gutenberg/$(PROYECTO).t1
	$(AWK) -f herram/gut-form1.awk gutenberg/$(PROYECTO).t1 > gutenberg/$(PROYECTO).t2

gutenberg/$(PROYECTO).t1: html/$(PROYECTO).html
	$(W3M) -cols 68 -dump html/$(PROYECTO).html > gutenberg/$(PROYECTO).t1


# Reglas para revisar ortografía con ispell (al texto plano)

ispell: gutenberg/$(PROYECTO).txt ispell/$(PROYECTO).ispell
	$(ISPELL) -d spanish -p ispell/$(PROYECTO).ispell gutenberg/$(PROYECTO).txt

# Para usar DocBook
include herram/comdocbook.mak

# To crear distribución de fuentes y actualizar en Internet
include herram/comdist.mak


# Elimina hasta configuración
limpiadist: limpiamas
	rm -f confv.sh confv.ent Make.inc
	if (test "$(GUT)" = "") then { rm -f gutenberg/$(PROYECTO).*; } fi

# Elimina archivos generables
limpiamas: limpia
	rm -rf $(HTML_DIR)
	rm -rf $(PRINT_DIR)
	rm -f img/*.eps img/*.ps
	rm -f $(PROYECTO)-$(PRY_VERSION).tgz
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
	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) xsltproc --stringparam outlang es --catalogs --nonet gbfxml2db.xsl $< > $@

#.gbfxml.txt: gbfxml2txt.xsl
#	SGML_CATALOG_FILES=$(CATALOG_DOCBOOK) xsltproc --stringparam outlang es --catalogs --nonet gbfxml2txt.xsl $< > $@  # Por ahora está mejor w3m

.gbf.gbfxml:
	($(AWK) -f gbf2gbfxml.awk $< > $@ ; \
	if (test "$$?" != "0") then { \
		tail $@; \
		exit 1; \
	} fi;)

$(PROYECTO).$(EXT_DOCBOOK): $(PROYECTO).gbfxml

Derechos.txt: derechos.gbfxml
	make $(HTML_TARGET)
	w3m -cols 70 -dump $(HTML_TARGET) | $(AWK) -f herram/arrderechos.awk > Derechos.txt

Desarrollo.txt: herram/gbfxml.vim
	cp Desarrollo.txt Desarrollo.txt.bak
	INICIO="Las completaciones disponibles" CMD="awk -f herram/exdocvimgbfxml.awk herram/gbfxml.vim" awk -f herram/rempbloquearch.awk Desarrollo.txt.bak > Desarrollo.txt
