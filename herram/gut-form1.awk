#!/usr/bin/awk -f
# First stage of indentation to format text like Bibles in project Gutenberg
# Released to the public domain. 2003. No warranties.  vtamara@users.sourceforge.net

function str_to(str,i) {
        return substr(str,1,i-1);
}


function str_from(str,i) {
        return substr(str,i,length(str)-i+1);
}

function fill_zero(str,n) {
	while (length(str)<n) {
		str="0" str;
	}
	return str;
}

function remspace(str) {
	ts=RSTART;
	tl=RLENGTH;
	while (match(str,/^ /)>0) {
		gsub(/^ /,"",str);
	}
	while (match(str,/  /)>0) {
		gsub(/  /," ",str);
	}
	while (match(str,/ $/)>0) {
		gsub(/ $/,"",str);
	}
	RSTART=ts;
	RLENGTH=tl;
	return str;
}

/^Buena Nueva de acuerdo a/ { 
	lcap="";
}

/^[0-9]+$/ {
	cap=$0;
	if (lcap!="" && int(cap)!=int(lcap)+1) {
		print FILENAME ":" FNR ": Capitulo errado" > stderr;
		error=1;
	}
	lcap=int(cap);
	lver=0;
	br=1;
}

/\^?[0-9]+[«A-Za-záéíóúÁÉÍÓÚñÑÜü¿¡(`_]/  {
	while (substr($0,1,6)!="501(c)" && 
		match($0,/\^?[0-9]+[«A-Za-záéíóúÁÉÍÓÚñÑÜü¿¡(`_]/)!=0) {
		p=str_to($0,RSTART);
		num=substr($0,RSTART,RLENGTH-1);
		n=remspace(str_from($0,RSTART+RLENGTH-1));
		if (match(num,/^\^/)) {
			num=str_from(num,2);
		}
#		print "OJO 0=" $0;
#		print "OJO p=" p;
#		print "OJO num=" num;
#		print "OJO n=" n;
#exit 1;
		print remspace(p);
		if (int(num)!=int(lver)+1) {
			print FILENAME ":" FNR ": Versículo errado" > "/dev/stderr";
			error=1;
		}
		lver=int(num);		
		$0=fill_zero(cap,3) ":" fill_zero(num,3) " " n;
	}
	printf "%s ",$0
	nopr=1;
}

/ [0-9]+$/ {
	match($0,/[0-9]+$/);
	p=str_to($0,RSTART);
	num=str_from($0,RSTART);
	if (int(num)==int(lver)+1) {
		print remspace(p);
		lver=int(num);
		$0=fill_zero(cap,3) ":" fill_zero(num,3) " " ;
		printf "%s ",$0;
		nopr=1;
	}
}

/------------/ {
	print "";
	cap="";
}

/.*/ {
	if (br==1) {
		print "";
		br=0;
	}
	if (cap=="") {
		print $0;
	} else 
	if ($0=="") {
		print "";
	}
	else if (nopr!=1) {
		printf "%s ",remspace($0);
	}
	else {
		nopr=0;
	}

}

