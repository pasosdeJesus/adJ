# Copia archivos faltantes de un parche 
# Dominio público. vtamara@pasosdeJesus.org. 2013.

p=$1;
if (test ! -f "$p") then  {
	echo "Falta ruta de parche como primer parámetro";
	exit 1;
} fi;

f=$2;
if (test ! -d "$f") then {
	echo "Falta ruta con fuentes como segundo parámetro";
	exit 1;
} fi;

d=$3;
if (test "$d" = "") then {
	d="."
} fi;
if (test ! -d "$d") then {
	echo "Tercer parámetro con ruta destino errado";
	exit 1;
} fi;

for i in `grep "^? " $p | sed -e "s/^? //g"`; do
	echo -n "$i: ";
	af="$f/$i"
	ad="$d/$i"
	if (test -d "$af") then {
		cmd="mkdir -p $ad; cp -rf $af/* $ad/"
		echo $cmd;
		eval "$cmd";
	} elif (test ! -f "$af") then {
		echo " No existe";
	} else {
		dd=`dirname $ad`;
		fd=`basename $ad`;
		lc=`echo "$fd" | sed -e "s/\(.*\)\(.\)$/\2/g"`
		if (test "$fd" = "service.c" -o "$fd" = "service.3") then {
			echo "Producido con otros métodos"
		} elif (test "$lc" = "~") then {
			echo "Se excluyen copias antiguas"
		} else {
			if (test ! -d $dd) then {
				cmd="mkdir -p $dd";
				echo -n "$cmd; ";
				eval "$cmd"
			} fi;
			cmd="cp $f/$i $d/$i"
			echo $cmd;
			eval "$cmd";
		} fi;
	} fi;
done;
