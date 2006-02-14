#!/bin/sh
# Functions to include in a configuration script
# Released to the public domain, 2002.   No warranties.
# Citation of the source is appreciated.
# Project Structio http://structio.sourceforge.net, 
# structio-info@lists.sourceforge.net

# Run this script with parameter -t to make a regression test

# Caution: Variables in file with configuration variables must be assigned to values
# between quotes ALWAYS.
# Things to improve: NLS, other tests (libraries, functions, functionality of tools)

rutaconfsh="herram"

# Set to 1 if debuggin information is desired.
debug=0;

# File with configuration variables (can be altered after including this file)
confvar_file="confv.sh"

. ${rutaconfsh}/misc.sh


# Prints value of a variable
function valvar {
	echo "echo \$$1" > confaux.tmp
	valp1=`. ./confaux.tmp`;
	echo $valp1;
}



# Auxiliar variable for next function
ret_checkPred=0;

# Checks a predicate on a configuration variable, trying its current value
# and then provided ones and finally if all fails and it is not optional
# asking the user.
# @param $1 Hint in case of problem with this variable.
# @param $2 Name of configuration variable in this script.
# @param $3 If its value is "optional" the configuration variable is
#	    supposed to be optional and the user is not asked for any value
#           if the default value and the provided value fail.
# @param $4 Predicate to check, this must be a command that returns 0 iff 
#           the predicate is true, the value of the configuration variable
#	    can be refered as ${!1} (e.g "test -x ${!1}").
# @param $5, $6, ... Provided expressions to try after the current value
# 	    of the variable.  Each one must be a shell expression.
# @return  In the variable the first value that made true the predicate or
# empty if it was optional and not found.
# Returns value 0 if the initial value of the variable made true the predicate 
# or 1 if it had to try provided values.
function checkPred  {
	local hint=$1;
	local var=$2;
	local opt=$3;
	local pred=$4;
	
	if (test "x$debug" = "x1") then { echo "var=$var, opt=$opt, pred=$pre3, hint=$hint, 5=$4"; } fi;
	if (test "x$var" = "x") then {
		echo "prog. Falta nombre de variable.";
		exit 1;
	} fi;
	if (test "x$opt" != "x" -a "x$opt" != "xoptional") then {
		echo "prog. Parametro que indica si es opcional o no debe ser vacio o la cadena \"optional\".";
		exit 1;
	} fi;
	if (test "x$pred" = "x") then {
		echo "prog. Falta predicado";
		exit 1;
	} fi;
	echo "echo \$$var" > confaux.tmp
	valp1=`. ./confaux.tmp`;
	if (test "x$debug" = "x1") then { echo "\$$var=$valp1"; } fi;
	if (test "x$valp1" = "x" -a "x$5" = "x") then {
		echo ": No encontrado(a)";
		if (test "x$opt" = "xoptional") then {
			export $var="";
			return 1;
		} fi;
		echo "Valores probados fallaron y este dato es indispensable";
		echo "$hint";
		echo -n "Por favor especifique un valor o cancele la configuración (con Ctrl-C) y realicela nuevamente después de hacer cambios en su sistema o de cambiar directamente el script $confvar_file (variable $var) :";
		read val;
		export $var="$val";
	}
	elif (test "x$valp1" = "x") then {
		export $var=`expr "$5"`;
	}
	elif (eval $pred) then {
		echo ": $valp1";
		return $ret_checkPred;
	}
	else {
		export $var=`expr "$5"`;
	} fi;

	ret_checkPred=1;
	if (test "$#" = 4) then {
		checkPred "$hint" "$var" "$opt" "$pred";
	}
	else {
		shift 5
		if (test "$#" = 0) then {
			checkPred "$hint" "$var" "$opt" "$pred";
		}
		else {
			checkPred "$hint" "$var" "$opt" "$pred" "$@";
		} fi;
	} fi;
	return 1;
}


# Sed expressions to change script with configuration variables $confvar_file
sedexp="";

function changeVar {
	echo "echo \$$1" > confaux.tmp
	valp1=`. ./confaux.tmp`;
	if (test "$2" != "") then {
		desc=`grep -A 1 "^[ \t]*$1[ \t]*=" $confvar_file | tail -n 1 | sed "s/#\(.*\)/\1/g"`
		sol=`grep -A 2 "^[ \t]*$1[ \t]*=" $confvar_file | tail -n 1 | sed "s/#\(.*\)/\1/g"`
		if (test "x$desc" = "x") then {
			echo "Falta descripción de variable de configuración $1";
			echo "desc: $desc, sol: $sol, confvar_file: $confvar_file";
			exit 1;
		} fi;
		echo "$desc : $valp1";
	} fi;
	sexp="s|^\([ \t]*$1[ \t]*=[ \t]*\)\(.*\)$|\1\"${valp1}\"|g";
	if (test "x$sedexp" = "x") then {
		sedexp="$sexp";
		echo "$sexp" > confaux.sed
	} else {
		sedexp="$sedexp;$sexp";
		echo "$sexp" >> confaux.sed
	} fi;
}

# This function receives the same parameters as checkPred but not 
# the first one (the second of checkPred corresponds to the first of this one).
# @return If the value of the variable must be changed leaves in
# sedexp a sed expression to change this script adjusting the variable.
function check  {
	desc=`grep -A 1 "^[ \t]*$1[ \t]*=" $confvar_file | tail -n 1 | sed "s/#\(.*\)/\1/g"`
	sol=`grep -A 2 "^[ \t]*$1[ \t]*=" $confvar_file | tail -n 1 | sed "s/#\(.*\)/\1/g"`
	if (test "x$desc" = "x") then {
		echo "Falta descripción de variable de configuración $1";
		exit 1;
	} fi;
	echo -n "$desc ";
	ret_checkPred=0;
	checkPred "$sol" "$@"

	if (test "$?" = 1) then {
		changeVar $1
	} fi;
}

# Changes file with configuration variables
function changeConfv  {
	if (test "x$sedexp" != "x") then {
		cp $confvar_file confv.bak
		sed -f confaux.sed < confv.bak > $confvar_file;
	} fi;
}

### Generates configuration variables for several file formats

# Adds configuration variables to a file for LATeX
function addLATeXConfv  {
	outf=$1;
	echo "% Configuration variables" >> $1;
	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ ]*\([A-Za-z_0-9]*\)[ ]*=[ ]*["]*\([^"]*\)["]*|\1 \2|g' |  while read vvar vval; do oval=`echo $vval | sed -e 's|\$\([A-Za-z_0-9]*\)|\\\1 |g'` ; ovar=`echo $vvar | sed -e 's|_||g'`;echo -e "\\\\newcommand{\\\\$ovar}{$oval}" >> $outf ; done 
}


# Adds configuration variables to a file for sed with macros
# $1 Name of sed file to use (lines will be appended)
# $2 String to the left of the macro name in input file (e.g @value{ or @ )
# $3 String to the right of the macro name in input file (e.g } or @ )
function addMacsedConfv  {
	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]*\([^"]*\)["]*|\1 \2|g' |  while read ovar vval; do vr=`valvar $ovar`; vs=`echo $vr | sed -e "s/|/\\|/g"`; echo "s|$2$ovar$3|$vs|g" >> $1; done
}


# Adds configuration variables to a file for make
function addMakeConfv  {
	echo "# Configuration variables" >> $1;
	grep "^[A-Za-z_0-9]*[ ]*=.*" < $confvar_file | sed -e 's|[ ]*\([A-Za-z_0-9]*\)[ ]*=[ ]*["]*\([^"]*\)["]*|\1=\2|g' | sed -e 's|\$\([A-Za-z_0-9]*\)|\$(\1)|g' >> $1;
}

# Adds configuration variables to a file for Ocaml
function addOcamlConfv  {
	rm -f confv.tm1 confv.tm2
	tifs=$IFS;
	IFS="%";
	LC_ALL=es_CO LANG=es_CO LANGUAGE=es_CO grep -A 1 "^[A-Za-z_0-9]*[ \t]*=.*"< $confvar_file | tr "\n" "#" | sed -e "s/--#//g" | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]\([^"]*\)["][^#]*## \([^#]*\)#|\1%\2%\3#|g' | tr "#" "\n" | while read nvar vval comm ; do  ovar=`echo $nvar | tr A-Z a-z`; oval=`echo $vval | sed -e 's|\$\([A-Za-z_0-9]*\)|"^\1^"|g'` ; echo "let $ovar=\"$oval\";;" >> confv.tm1 ; echo "(** $comm *)" >> confv.tm1; echo "" >> confv.tm1 ; echo "s|\"\^$nvar\^\"|\"\^$ovar\^\"|g" >> confv.tm2 ; done
	sed -f confv.tm2 confv.tm1 | sed -e 's|""\^||g' -e 's|\^""||g' >> $1;
	IFS=$tifs;
	rm -f confv.tm1 confv.tm2
}

# Adds configuration variables to a file for PHP
function addPHPConfv  {
	echo "/* Configuration variables */" >> $1;
	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]*\([^"]*\)["]*|\$\1="\2";|g' >> $1 #| sed -e 's|\$\([A-Za-z_0-9]*\)|\$(\1)|g' >> $1;
#	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]\([^"]*\)["]|\1 \2|g' |  while read nvar vval; do echo "\$$nvar=\"$vval\";" >>$1; done 
}

# Adds configuration variables to a file for Texinfo
function addTexinfoConfv  {
	echo "@c Configuration variables " >> $1;
	rm -f confv.tm1 confv.tm2
	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]*\([^"]*\)["]*|\1 \2|g' |  while read ovar vval; do oval=`echo $vval | sed -e 's|\$\([A-Za-z_0-9]*\)|@value{\1}|g'` ; echo "@set $ovar $oval" >> $1 ; done 
}

# Adds configuration variables to an XML file
function addXMLConfv  {
	outf=$1;
	rm -f confv.tm1 confv.tm2
	grep "^[A-Za-z_0-9]*[ \t]*=.*" < $confvar_file | sed -e 's|[ \t]*\([A-Za-z_0-9]*\)[ \t]*=[ \t]*["]*\([^"]*\)["]*|\1 \2|g' |  while read ovar vval; do  oval=`echo $vval | sed -e 's|\$\([A-Za-z_0-9]*\)|\&\1;|g'` ; nvar=`echo $ovar | sed -e "s/_/-/g"`; echo "s|\&$ovar;|\&$nvar;|g" >> confv.tm2; echo "<!ENTITY $nvar \"$oval\">" >> confv.tm1 ; done 
	sed -f confv.tm2 confv.tm1 >> $outf
	rm -f confv.tm1 confv.tm2
}


r=`echo "a" | sed -e "s/a/b/g"`;
if (test "$?" != 0 -o "$r" != "b") then {
        echo "  El programa 'sed' es requerido";
        exit 1;
} fi;
r=`grep -V 2> /dev/null`;
if (test "$?" != 0) then {
        echo " El programa 'grep' es requerido";
        exit 1;
} fi;


