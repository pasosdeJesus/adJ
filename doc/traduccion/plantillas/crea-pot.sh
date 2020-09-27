
# Genera una nueva plantilla .pot para una pagina 
# Licencia ISC. 2020. Vladimir Támara. vtamara@pasosdeJesus.org
# Se inspira en https://salsa.debian.org/manpages-l10n-team/manpages-l10n/-/blob/master/templates/generate-template.sh

p=$1
if [[ ! -f $p ]]; then
  echo "Primer parámetro es página man e.g ../contracorriente/man1/zsh.1" >&2
  exit 1
fi
a=`basename $1`  # e.g zsh.1
d=`dirname $1`   # e.g ../contracorriente/man1
b=`basename $d`  # e.g man1

po4a-gettextize -f man --option groff_code=verbatim \
  --option generated \
  --option untranslated=a.RE,\
  --option unknown_macros=untranslated \
  --msgid-bugs-address vtamara@pasosdeJesus.org \
  --copyright-holder "Vladimir Támara Patiño" \
  --master $p -M utf-8 > $b/$a.pot
