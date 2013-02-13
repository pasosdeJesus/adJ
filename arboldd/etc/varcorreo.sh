#!/bin/sh
# Variables para servidor con adJ


#### MONITOREO
ipmaqint=192.168.191.1
ipotraorg=180.126.248.410
nomotraorg=www.otra.org
nomotraorg2=
rutamon=/var/adJ/monitorea/


#### BASES DE DATOS SEGURAS

#### SERVIDOR DE CORREO SEGURO
# Particion de correo y posible imagen Encriptada
partenc=/var/maildir
imgenc=/var/datos.img
svnimg=svnd1
tamimg=120000000

# Particion de respaldo e imagen encriptada de respaldo
partenc2=/var/respaldo
imgenc2=/var/respdatos.img
svnimg2=svnd2
tamimg2=120000000

# Directorio con correos (prefiera Maildir)
Maildir=Maildir

# Grupo en servidor
grupous=grupo

### RESPALDO EN OTRO SERVIDOR DE CORREO SEGURO AMIGO
# Servidor de respaldo 
sresp="192.168.181.5"

# Opciones para conectarse a servidor de respaldo
opsresp=""

# Usuario en servidor de respaldo que hace mantenimientos
usrespaldo=org

# Usuario en computador local que sincroniza con servidor de respaldo
usrespaldolocal=usuario

# Nombre de la organización ante servidor de respaldo --usado para grupo y posfijo de cuentas
orgrespaldo=org

# Dominio con el que se configuraran cuentas virtuales en servidor de respaldo
domrespaldo=reiniciar.org


#### SERVIDOR WEB CON CMS DRUPAL
#
# Respaldos drupal, por defecto base de datos diaria del ultimo mes y
# directorio de sitios de martes, jueves y domingo.

# Directorio donde quedaran los respaldos 
DIRRESPDRUPAL=/var/respaldo/drupal

# Usuario de base de datos, el usuario del sistema que ejecuta debe tener un archivo .pgpass con la clave para este usuario, asi como para el usuario postgres
DBUSUARIODRUPAL=drupal

# Nombre de base drupal
BASEDRUPAL=drupal3

# Opcional. Nombre de una segunda base drupal
BASEDRUPAL2=

# Directorio con sitios 
SITESDRUPAL=/var/www/htdocs/drupal6/sites

# Opcional. Segundo directorio de sitios
SITESDRUPAL2=


