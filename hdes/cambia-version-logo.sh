#!/bin/sh
# Cambia la versión en el logo de xenodm (adJ_*.xpm) a partir del SVG fuente.
# Dominio público. 2026. vtamara@pasosdeJesus.org
#
# Uso: cambia-version-logo.sh [version]
#   version  Número de versión a poner en el logo (por omisión 7.9)
#
# Requiere: convert (ImageMagick) y perl.
#
# Parte de arboldvd/medios/logov.svg (el logo con el <tspan> de versión) y
# genera las 4 profundidades en arboldd/etc/X11/xenodm/pixmaps/adJ_*.xpm.

set -e

VERSION="${1:-7.9}"
SVG="arboldvd/medios/logov.svg"
DEST="arboldd/etc/X11/xenodm/pixmaps"

# Debe ejecutarse desde la raíz del repositorio
if [ ! -f "$SVG" ]; then
  echo "No se encontró $SVG. Ejecuta desde la raíz del repositorio adJ." >&2
  exit 1
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# 1) Cambiar la versión en el <tspan> de la versión (el que precede al
#    </text> final). Se acepta cualquier versión anterior de la forma X.Y[z].
perl -0777 -pe \
  's/>[0-9]+\.[0-9]+[a-zA-Z0-9]*<\/tspan><\/text>/>'"$VERSION"'<\/tspan><\/text>/' \
  "$SVG" > "$TMP/logov.svg"

# 2) Renderizar a las 4 profundidades a 256x185 (mismo tamaño y número de
#    colores que los XPM actuales: 3, 32, 255 y 255).
convert "$TMP/logov.svg" -resize 256x185! -colors 3   "$DEST/adJ_1bpp.xpm"
convert "$TMP/logov.svg" -resize 256x185! -colors 32  "$DEST/adJ_4bpp.xpm"
convert "$TMP/logov.svg" -resize 256x185! -colors 255 "$DEST/adJ_8bpp.xpm"
convert "$TMP/logov.svg" -resize 256x185! -colors 255 "$DEST/adJ_15bpp.xpm"

echo "[OK] Logo actualizado a versión $VERSION en $DEST"
