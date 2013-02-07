#!/bin/sh
# Detalles de personalización de adJ
# Run from /usr/src/

ed app/xdm/config/Xresources.cpp << EOF
,s/Welcome to/Bienvenido a/g
,s/Login:$/Cuenta:/g
,s/Login incorrect/Ingreso incorrecto/g
w
q
EOF


