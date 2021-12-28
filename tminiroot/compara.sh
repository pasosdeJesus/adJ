./conv.sh 

comp() {
	echo "Por comparar $1 y $2"
	echo "[RETORNO] para continuar"
	read
	egrep -v "^[[:space:]]*#" "$1" > /tmp/f1
	egrep -v "^[[:space:]]*#" "$2" > /tmp/f2
	diff -u /tmp/f1 /tmp/f2 | less
}

comp install-amd64.md install-amd64-en.md 
comp install.sub install-en.sub 
