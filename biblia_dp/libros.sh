#!/bin/sh

function genlib {
	rm -rf ../$1
	./libro.sh .. $1 "$2: Traducción de dominio público abierta a mejoras" "$3" "$4" "$5" "$6"
}

genlib mateo_dp "Buena Nueva de acuerdo a Mateo" "mateo.gbfxml" "1ev" 12500 "2 May 2004"
genlib marcos_dp "Buena Nueva de acuerdo a Marcos" "marcos.gbfxml" "1ev" 12501 "2 May 2004"
genlib lucas_dp "Buena Nueva de acuerdo a Lucas" "lucas.gbfxml" "1ev" 12502 "2 May 2004"
genlib juan_dp "Buena Nueva de acuerdo a Juan" "juan.gbfxml" "1ev" 12503 "2 May 2004"
genlib evangelios_dp "Los Evangelios" "intro-evangelios.gbfxml mateo.gbfxml marcos.gbfxml lucas.gbfxml juan.gbfxml" "4ev" 0 "No"
