#!/bin/sh

function genlib {
	rm -rf ../$1
	./libro.sh .. $1 "$2: Traducción de dominio público abierta a mejoras" "$3" "$4" "$5"
}

genlib mateo_dp "Buena Nueva de acuerdo a Mateo" "mateo.gbfxml" 11500 "29 February 2004"
genlib marcos_dp "Buena Nueva de acuerdo a Marcos" "marcos.gbfxml" 11501 "29 February 2004"
genlib lucas_dp "Buena Nueva de acuerdo a Lucas" "lucas.gbfxml" 11502 "29 February 2004"
genlib juan_dp "Buena Nueva de acuerdo a Juan" "juan.gbfxml" 11503 "29 February 2004"
genlib evangelios_dp "Los Evangelios" "intro-evangelios.gbfxml mateo.gbfxml marcos.gbfxml lucas.gbfxml juan.gbfxml" 0 "No"
