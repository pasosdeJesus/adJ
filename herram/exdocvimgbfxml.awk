#!/bin/awk -f
# Extrae documentación del modo gbfxml para vim
# Dominio público. 2003. vtamara@users.sourceforge.net

/imap .* <LocalLeader>[^ ]*/ {
	match($0,/<LocalLeader>[^ ]/);
	abr=substr($0,RSTART+13,RLENGTH-13);
}

/inoremap .*<Plug>[^ ]* [^ ]*/ {
	match($0,/<Plug>[^ ]* /);
	s=RSTART+RLENGTH;
	pla=substr($0,s,length($0)-s+1);
	print "* '<" abr "' genera '" pla "'";
}

