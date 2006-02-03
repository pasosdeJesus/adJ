#!/bin/sh
# Arregla enlaces en sitio de desarrollo.
# Public domain. 2006

op=$1;

cmd="ln -s"
if (test "$op" = "-cvs") then {
	cmd="cp"
} fi;

if (test "$DREPASA" = "") then {
	DREPASA=$HOME/structio/repasa;
} fi;

function opera {
	f=$1;
	d=$2;
	diff $f $d > /dev/null
	if (test "$?" != "0") then {
		echo "No enlace por diferencias entre $d $f";
	} 
	else {
		rm -f $d;
		eval "$cmd $f $d"
	} fi;
}

opera $DREPASA/docbook/conf.sh conf.sh
opera $DREPASA/docbook/docbookrep_html.xsl docbookrep_html.xsl
opera $DREPASA/docbook/docbookrep_tex.dsl docbookrep_tex.dsl
opera $DREPASA/docbook/docbookrep_html.dsl docbookrep_html.dsl

opera $DREPASA/docbook/herram/comdocbook.mak herram/comdocbook.mak
opera $DREPASA/docbook/herram/conthtmldoc.awk herram/conthtmldoc.awk
opera $DREPASA/docbook/herram/comdist.mak herram/comdist.mak
opera $DREPASA/docbook/herram/confaux.sh herram/confaux.sh
opera $DREPASA/docbook/herram/db2rep herram/db2rep
opera $DREPASA/docbook/herram/misc.sh herram/misc.sh

opera $DREPASA/docbook/img/home.png img/home.png
opera $DREPASA/docbook/img/prev.png img/prev.png
opera $DREPASA/docbook/img/toc-minus.png img/toc-minus.png
opera $DREPASA/docbook/img/blank.png img/blank.png
opera $DREPASA/docbook/img/important.png img/important.png
opera $DREPASA/docbook/img/toc-plus.png img/toc-plus.png
opera $DREPASA/docbook/img/caution.png img/caution.png
opera $DREPASA/docbook/img/next.png img/next.png
opera $DREPASA/docbook/img/tip.png img/tip.png
opera $DREPASA/docbook/img/up.png img/up.png
opera $DREPASA/docbook/img/draft.png img/draft.png
opera $DREPASA/docbook/img/note.png img/note.png
opera $DREPASA/docbook/img/toc-blank.png img/toc-blank.png
opera $DREPASA/docbook/img/warning.png img/warning.png
