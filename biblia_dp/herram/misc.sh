

# Miscelaneous shell functions
# This is released to the public domain. No warranties.
# Citation of the source is appreciated http://structio.sourceforge.net

# To run a regression test run with parameter -t

# Creates a string by concatenating $1, $2 times to $3 prints the result.
function mkstr {
	if (test "$2" -lt "0") then {
		echo "Bug.  Times cannot be negative";
		exit 1;
	}
	elif (test "$2" = "0") then {
		echo $3;
	}
	else {
		mkstr "$1" $(($2 -1)) "$3$1"
	} fi;
}


# Decides if the  number $1 (float or integer in base 10) is less than  
# $2 (also float or integer in base 10).
# Returns 0 if it is  or 1 otherwise.
function ltf {
	local n1=$1;
	local n2=$2;

# Add .0 to integers
	t=`echo $n1 | grep "[.]"`;
	if (test "$t" = "") then {
		n1="${n1}.0"
	} fi;
	t=`echo $n2 | grep "[.]"`;
	if (test "$t" = "") then {
		n2="${n2}.0"
	} fi;
		
# Multiply each number with an appropiate power of tenth to 
# eliminate decimal part
	d1=`echo $n1 | sed -e "s/[0-9]*[.]\([0-9]*\)/\1/g"`;
	d2=`echo $n2 | sed -e "s/[0-9]*[.]\([0-9]*\)/\1/g"`

	nn1=`echo $n1 | sed -e "s/\([0-9]*\)[.]\([0-9]*\)/\1\2/g"`
	nn2=`echo $n2 | sed -e "s/\([0-9]*\)[.]\([0-9]*\)/\1\2/g"`
	
	t=`echo $((${#d1} < ${#d2}))`
	if (test "$t" = "1") then { 
		# n1 has less decimal digits
		nn1=`mkstr "0" $((${#d2}-${#d1})) $nn1`
	} 
	else { 
		# n2 has less or the same amount of decimal digits than n1
		nn2=`mkstr "0" $((${#d1}-${#d2})) $nn2`;
	}  fi;

	t=`echo $((${nn1} < ${nn2}))`;
	if (test "$t" = "1") then {
		return 0;
	}
	else {
		return 1;
	} fi;
}


function regtest {
	r=`mkstr "hola" 2 ""`;
	if (test "$r" != "holahola") then {
		echo "Problema $r";
	} 
	else {
		echo "Pasa";
	} fi;
	r=`mkstr "0" 1 "hola"`;
	if (test "$r" != "hola0") then {
		echo "Problema $r";
	} 
	else {
		echo "Pasa";
	} fi;
	if (ltf "1" "1.2") then {
		echo "Pasa";
	}
	else {
		echo "Problema ltf $?";
	} fi;
	if (ltf "1.64" "1.4") then {
		echo "Problema ltf $?";
	} 
	else {
		echo "Pasa";
	} fi;
}

if (test "$1" = "-t") then {
	regtest;
} fi;
