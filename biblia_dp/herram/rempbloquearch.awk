#!/bin/awk -f
# Remplaza un bloque de texto por la salida de un comando.
# El bloque comienza con una cadena, en la siguiente l�nea
# una secuencia de guiones (m�s de 2)
# Termina con una secuencia de guiones (m�s de 2)
# Dominio p�blico. 2003. Sin garant�as. vtamara@users.sourceforge.net.

/--[-]*/ { 
	if (repbloque==1) {
		if (primlinea==1) {
			repbloque=0;
			primlinea=0;
			noimp=0;
			system(cmd);
		} else {
			primlinea=1;
			noimp=1;
			print $0;
		}
	}
}

/.*/ {
	if (match($0,inicio)>=0) {
		repbloque=1;
	}
	if (noimp!=1) {
		print $0;
	}
}

BEGIN {
	if (ENVIRON["INICIO"]=="") {
		print "Falta cadena que marca el inicio del bloque en variable INICIO";
		exit 1;
	}
 	inicio=ENVIRON["INICIO"];
	if (ENVIRON["CMD"]=="") {
		print "Falta comando cuya salida se insertar� en variable CMD";
		exit 1;
	}
	cmd=ENVIRON["CMD"];
}
