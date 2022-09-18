#!/bin/sh
# Si hace falta crea imagen cifrada para postresql y para copias de respaldo

if (test "$TAMPGMB" = "") then {
  TAMPGMB=670;
  # Cabe en CD
} fi;
TAMPG=`expr $TAMPGMB '*' 1000`
if (test "$TAMRESMB" = "") then {
  TAMRESMB=670;
  # Cabe en CD
} fi;
TAMRES=`expr $TAMRESMB '*' 1000`

if (test "$RUTAIMG" = "") then {
  RUTAIMG=/var/
  # Cabe en CD
} fi;

uadJ=$USER

function activarcs {
  ns=$1;
  rcctl enable $ns
} 

function creamontador {
  ar=$1;
  if (test "$ar" = "") then {
    echo "Falta archivo por crear como primer parametro";
    exit 1;
  } fi;
rut=$2;
if (test "$rut" = "") then {
  echo "Falta ruta donde montar como segundo parametro";
  exit 1;
} fi;
dv=$3;
if (test "$dv" = "") then {
  echo "Falta numero de dipositivo vnd por usar como tercer parámetro";
  exit 1;
} fi;
us=$4;
if (test "$us" = "") then {
  echo "Falta usuario dueño de directorio como cuarto parámetro";
  exit 1;
} fi;
gr=$5;
if (test "$gr" = "") then {
  echo "Falta grupo dueño de directorio como quinto parámetro";
  exit 1;
} fi;
im=$6;
if (test "$im" = "") then {
  echo "Falta imagen como sexto parámetro";
  exit 1;
} fi;
cat > $ar << EOF
#!/bin/sh

servicio="/sbin/mount"

. /etc/rc.d/rc.subr

rc_check() {
  /sbin/mount | grep "$rut" > /dev/null 
}

rc_stop() {
  umount $rut
  vnconfig -u vnd${dv}c
}

rc_start() {
  if (test -f $im) then {
    /sbin/umount /dev/vnd${dv}c 2> /dev/null
    /sbin/umount /dev/vnd${dv}a 2> /dev/null
    /sbin/vnconfig -u vnd${dv}c 2> /dev/null
    if (test ! -d $rut) then {
      mkdir $rut
      chown $us:$gr $rut
      chmod o-w $rut
    } fi;
    echo " " > /dev/tty
    /sbin/vnconfig -ckv vnd${dv} $im
    partres=vnd${dv}c
    disklabel vnd${dv}c | grep "  a: " > /dev/null 2>&1
    if (test "\$?" = "0") then {
      partres=vnd${dv}a
    } fi;
    /sbin/fsck_ffs -y /dev/\$partres
    /sbin/mount /dev/\$partres $rut
  } fi;
}

rc_cmd \$1
EOF
chmod +x $ar
}

if (test -f /$RUTAIMG/post.img) then {
  echo "Existe imagen para datos cifrados de PostgreSQL /$RUTAIMG/post.img. " >> /var/www/tmp/inst-adJ.bitacora
  echo "Suponiendo que la base PostgreSQL tendrá datos cifrados allí" >> /var/www/tmp/inst-adJ.bitacora
  postcifra="s";
}
else {
  postcifra="h";
  while (test "$postcifra" = "h") ; do
    dialog --title 'Cifrado de datos de PostgreSQL' --help-button --yesno '\n¿Preparar imagenes cifradas para los datos de PostgreSQL?' 15 60 
    postcifra="$?"
    if (test "$postcifra" = "2") then {
      postcifra="h";
      dialog --title 'Ayuda cifrado de datos de PostgreSQL' --msgbox '\nEn adJ todas las bases de datos de PostgreSQL pueden mantenerse en una partición cifrada con una clave que debe darse durante el arranque (si la clave es errada no podrán usarse las bases de datos).\n' 15 60 
    } fi;
  done;
  if (test "$postcifra" = "0") then {
    postcifra="s";
  } fi;

} fi;


if (test "$postcifra" = "s") then {
  echo "* Crear imagen cifrada para base de ${TAMPGMB}Mbytes (se especifica otra con var. TAMPGMB) en directorio $RUTAIMG (se especifica otra con var RUTAIMG)"  >> /var/www/tmp/inst-adJ.bitacora
  clear;
  cat <<EOF
A continuación por favor ingrese la clave de cifrado para cada una de las
particiones cifradas, no las verá cuando las teclee --procure no equivocarse y 
recuerdelas porque debe digitarlas en cada arranque.
EOF

if (test ! -f /$RUTAIMG/post.img ) then {
  vnconfig -u vnd0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
  dd of=/$RUTAIMG/post.img bs=1024 seek=$TAMPG count=0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
  echo -n "Clave para PostgreSQL (/var/postgresql) "
  vnconfig -ckv vnd0 /$RUTAIMG/post.img 
  newfs /dev/rvnd0c >> /var/www/tmp/inst-adJ.bitacora 2>&1
  vnconfig -u vnd0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
} else {
echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora
} fi;

echo "* Crear imagen cifrada para respaldo de ${TAMRESMB}MBytes (se espeicifica
otra con var. TAMRESMB) en directorio $RUTAIMG (se especifica otra con var RUTAIMG)"  >> /var/www/tmp/inst-adJ.bitacora
if (test ! -f /$RUTAIMG/resbase.img -a ! -f /$RUTAIMG/bakbase.img) then {
  vnconfig -u vnd0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
  dd of=/$RUTAIMG/resbase.img bs=1024 seek=$TAMRES count=0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
  echo -n "Clave para respaldos (/var/www/resbase)"
  vnconfig -ckv vnd0 /$RUTAIMG/resbase.img 
  newfs /dev/rvnd0c >> /var/www/tmp/inst-adJ.bitacora 2>&1
  vnconfig -u vnd0 >> /var/www/tmp/inst-adJ.bitacora 2>&1
} else {
echo "   Saltando..." >> /var/www/tmp/inst-adJ.bitacora;
} fi;

} fi; #postcifra


grep "^ *pkg_scripts.*montaencres" /etc/rc.conf.local > /dev/null 2>&1		
if (test "$?" = "0") then {		
  echo "* Montando imagen cifrada para respaldos" >> /var/www/tmp/inst-adJ.bitacora;		
  clear;		
  /etc/rc.d/montaencres check		
  if (test "$?" != "0") then {		
    echo "No está montada imagen cifrada para respaldo" >> /var/www/tmp/inst-adJ.bitacora;		
    /etc/rc.d/montaencres start		
  } fi;		
} fi;

echo "* Crear scripts para montar imagenes cifradas como servicios" >> /var/www/tmp/inst-adJ.bitacora;
nuevomonta=0;

creamontador /etc/rc.d/montaencres /var/www/resbase 2 $uadJ $uadJ /var/resbase.img
creamontador /etc/rc.d/montaencpos /var/postgresql 1 _postgresql _postgresql /var/post.img

if (test "$postcifra" = "s") then {
  echo "* Montar imagenes cifradas durante arranque" >> /var/www/tmp/inst-adJ.bitacora;
  activarcs montaencres
  activarcs montaencpos

} fi; #postcifra
