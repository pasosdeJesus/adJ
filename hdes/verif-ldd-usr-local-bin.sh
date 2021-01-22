#!/bin/sh
# Revisa en /usr/local/bin y en /usr/local/sbin/ si todas las
# dependencias de librerías están bien

cd /usr/local/bin
porborrar=""
for i in *; do
  t=`stat -f "%HT" $i`
  if (test "$t" != "Directory") then {
    doas ldd $i > /dev/null 2> /tmp/el2;
    r1=`cat /tmp/el2`;
    r2=`echo $r1 | sed -e "s/.*not an ELF executable/Aguanta/g;s/.*No such file or directory/Borrar/g"`
    if (test "$r1" != "" -a "$r2" != "Aguanta") then {
      if (test "$r2" = "Borrar") then {
        porborrar="$porborrar $i";
      } else {
        echo "$i: $r2";
      } fi;
    } fi;
  } fi;
done

if (test "$porborrar" != "") then {
  echo "Por borrar: $porborrar"
  ord="doas rm $porborrar";
  echo "ENTER para ejecutar"
  echo $ord
  read
  eval $ord
} fi;
