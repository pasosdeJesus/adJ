#!/bin/awk -f
# Adiciona <t lang="es"></t> a un archivo gbfxml
# Dominio público. 2003. vtamara@users.sourceforge.net

	
/<sv/ || /<fr/ || /<\/fr>/ || /<\/cm/ || /<pp/ || /<cl/ { 
	if (solotag!=1) {
		print "<t lang=\"es\"></t>"; 
	}
} 

/.*/ { 
	if (solotag==1 && match($0,/^[ ]*$/)==0) {
		solotag=0;
	}
	print $0; 
} 

/^[ ]*(<[^>]*>)*[ ]*$/ { 
	solotag=1;
}


