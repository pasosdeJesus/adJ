#!/bin/awk
# Para eliminar encabezado y pie de p�ginas en textos
# obtenidos con lynx o w3m a partir de HTMLs de DocBook
# Dominio p�blico. 

/___________________________/ || /^-----------------------------------/ {
	estado=estado+1;
}

/.*/ {
	if (estado==1) {
		estado=2;
	}
	else if (estado==2) {
		print $0;
	}
}

BEGIN {
	estado=0;
}
