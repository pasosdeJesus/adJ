#!/bin/sh
# Ensure that some files are links to development files of docbook/repasa
# Public domain. 2003

if (test "$DREPASA" = "") then {
	DREPASA=$HOME/structio/repasa;
} fi;


rm -f conf.sh docbookrep_html.xsl docbookrep_tex.dsl docbookrep_html.dsl
ln -s $DREPASA/docbook/conf.sh $DREPASA/docbook/docbookrep_html.xsl $DREPASA/docbook/docbookrep_tex.dsl $DREPASA/docbook/docbookrep_html.dsl .

cd herram
rm -f comdocbook.mak conthtmldoc.awk comdist.mak confaux.sh db2rep misc.sh
ln -s $DREPASA/docbook/herram/comdocbook.mak $DREPASA/docbook/herram/conthtmldoc.awk $DREPASA/docbook/herram/comdist.mak $DREPASA/docbook/herram/confaux.sh $DREPASA/docbook/herram/db2rep $DREPASA/docbook/herram/misc.sh .

cd ../img
rm -f home.png prev.png toc-minus.png blank.png important.png toc-plus.png caution.png next.png tip.png up.png draft.png note.png toc-blank.png warning.png
ln -s $DREPASA/docbook/img/home.png $DREPASA/docbook/img/prev.png $DREPASA/docbook/img/toc-minus.png $DREPASA/docbook/img/blank.png $DREPASA/docbook/img/important.png $DREPASA/docbook/img/toc-plus.png $DREPASA/docbook/img/caution.png $DREPASA/docbook/img/next.png $DREPASA/docbook/img/tip.png $DREPASA/docbook/img/up.png $DREPASA/docbook/img/draft.png $DREPASA/docbook/img/note.png $DREPASA/docbook/img/toc-blank.png $DREPASA/docbook/img/warning.png .
 
