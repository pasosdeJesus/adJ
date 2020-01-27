#!/bin/sh
# Busca paquetes de los que otros no dependen y que no están entre los 
# esperados en Contenido.txt

doas find /var/db/pkg/ -name "+REQUIRED_BY" | sed -e "s/.*pkg\///g;s/\/.*//g" | sort -u > /tmp/rb
ls /var/db/pkg/ > /tmp/t

diff /tmp/t /tmp/rb

