#!/bin/awk
# Extrae y arregla URLs en derechos de reproducción extraidos del HTML
# Dominio público. 2003. Sin garantías.  vtamara@users.sourceforge.net


function probprint(str) {
	if (nop!=1 && int(FNR)>2) { 
		print str
	} 
}

/.*/ { 
	if (surl!="") {
		if (match($0,/^[^ ]*\//)) { # Continuation or URL
			match($0,/^[^ ]*/);
			surl=surl substr($0,1,RLENGTH);
			$0=substr($0,RLENGTH+1,length($0)-RLENGTH);
		}
		probprint(surl);
		surl="";
	}
} 

/[^ ]+[ ]+http:\/\/[^ ]*$/ { 
	match($0,/http:\/\/[^ ]*$/); 
	surl=substr($0,RSTART,RLENGTH); 
	$0=substr($0,1,RSTART-1); 
}  

/---/ { 
	nop=1; 
} 

/.*/ { 
	probprint($0);
} 

BEGIN {
	surl="";
	nop=0;
}
