#!/bin/sh

function genlib {
	rm -rf ../$1
	./libro.sh .. $1 "$2: Traducción de dominio público abierta a mejoras" "$3"
}

genlib marcos_dp "Buena Nueva de acuerdo a Marcos" "marcos.gbfxml"
genlib lucas_dp "Buena Nueva de acuerdo a Lucas" "lucas.gbfxml"
genlib juan_dp "Buena Nueva de acuerdo a Juan" "juan.gbfxml"
genlib mateo_dp "Buena Nueva de acuerdo a Mateo" "mateo.gbfxml"
genlib evangelios_dp "Los Evangelios" "mateo.gbfxml marcos.gbfxml lucas.gbfxml juan.gbfxml"
