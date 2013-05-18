
/[0-9]*:[0-9]*/ {
	lin="";
	for (i=1; i<=mv; i++) {
		if (ver[i]=="") {
			print FILENAME ":" FNR ":Falta el " i "-esimo en " nant > "/dev/stderr";
			error=1;
		}
		else {
			lin=lin i"-"ver[i] " ";
		}
	}
	if (lin != "") {
		print nant " " lin;
	}
	mv=-1;
	delete ver;
	nant=$0;
}

/[0-9]*,.*/ {
	split($0, e, /,/);
	if (ver[e[1]] != "") {
		print FILENAME ":" FNR ": Repetido el " e[1] "-esimo en " nant > "/dev/stderr";
		error=1;
	}
	ver[e[1]]=e[2];
	if (e[1]>mv) {
		mv=e[1];
	}
}

BEGIN {
	ultimos="";
	mv=-1;
	error=0;
}

END {
	lin="";
	for (i=1; i<=mv; i++) {
		if (ver[i]=="") {
			print FILENAME ":" FNR ":Falta el " i "-esimo en " nant > "/dev/stderr";
			error=1;
		}
		else {
			lin=lin i"-"ver[i] " ";
		}
	}
	if (lin != "") {
		print nant " " lin;
	}
	mv=-1;
	delete ver;

	exit error;
}
