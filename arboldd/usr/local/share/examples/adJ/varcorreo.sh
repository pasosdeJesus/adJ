#!/bin/sh
# Variables para servidor de correo seguro sobre adJ

# Particion de correo y posible imagen Encriptada
partenc=/var/maildir
imgenc=
svnimg=
tamimg=

# Particion de respaldo e imagen encriptada de respaldo
partenc2=
imgenc2=
svnimg2=
tamimg2=

# Directorio con correos (prefiera Maildir)
Maildir=Maildir

# Grupo en servidor de los usuarios de correo (en blanco si no hay uno)
grupous=

### RESPALDO EN OTRO SERVIDOR DE CORREO SEGURO AMIGO
# Servidor de respaldo 
sresp="otroservidor.pasosdeJesus.org"

# Opciones para conectarse a servidor de respaldo
opsresp=""

# Usuario en servidor de respaldo que hace mantenimientos
usrespaldo=usuarioremoto

# Usuario en computador local que sincroniza con servidor de respaldo
usrespaldolocal=usuariolocal

# Nombre de la organización ante servidor de respaldo --usado para grupo y posfijo de cuentas
orgrespaldo=miorg

# Dominio con el que se configuraran cuentas virtuales en servidor de respaldo
domrespaldo=miorg.org
