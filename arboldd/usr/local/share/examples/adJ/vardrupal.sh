#!/bin/sh
# Variables para Drupal en servidor adJ

#### SERVIDOR WEB CON CMS DRUPAL
#
# Respaldos drupal, por defecto base de datos diaria del ultimo mes y
# directorio de sitios de martes, jueves y domingo.

# Directorio donde quedaran los respaldos 
DIRRESPDRUPAL=/home/respaldo/

# Usuario de base de datos, el usuario del sistema que ejecuta debe tener un archivo .pgpass con la clave para este usuario, asi como para el usuario postgres
DBUSUARIODRUPAL=miusuario

# Nombre de base drupal
BASEDRUPAL=drupal

# Opcional. Nombre de una segunda base drupal
BASEDRUPAL2=

# Directorio con sitios 
SITESDRUPAL=/var/www/htdocs/drupal6/sites

# Opcional. Segundo directorio de sitios
SITESDRUPAL2=



