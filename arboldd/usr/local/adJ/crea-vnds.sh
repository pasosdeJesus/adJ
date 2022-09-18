#!/bin/sh
# Si hace falta crea imagen cifrada para postresql y para copias de respaldo

ar=$1;
if (test "$ar" = "") then {
  echo "Falta archivo RC por crear como primer parametro";
  exit 1;
} fi;
rut=$2;
if (test "$rut" = "") then {
  echo "Falta ruta donde montar como segundo parametro";
  exit 1;
} fi;
dv=$3;
if (test "$dv" = "") then {
  echo "Falta numero de dipositivo vnd por usar como tercer parámetro (en la
  creación se usará el 0)";
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
  echo "Falta imagen por crear como sexto parámetro";
  exit 1;
} fi;
tam=$7
if (test "$tam" = "") then {
  echo "Falta tamaño de la imagen como septimo parámetro en MB";
  exit 1;
} fi;


TAMRES=`expr $tam '*' 1000`
echo "TAMRES=$TAMRES"

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

if (test -f $im) then {
  echo "Ya existe imagen $im"
  exit 1
} fi;

echo "* Crear imagen cifrada $im de tamaño ${tam}Mbytes"
cat <<EOF
A continuación por favor ingrese la clave de cifrado.
No la verá cuando la teclee --procure no equivocarse y 
recuerdela porque debe digitarla en cada arranque y si la
olvida pierde los datos.
EOF

vnconfig -u vnd0 
dd of=$im bs=1024 seek=$TAMRES count=0
echo -n "Clave para PostgreSQL (/var/postgresql) "
vnconfig -ckv vnd0 $im
newfs /dev/rvnd0c 
vnconfig -u vnd0 


echo "* Crear scripts para montar imagén cifrada como servicios" 

if (test -f $ar) then {
  echo "ya existe script rc"
  exit 1;
} fi;

creamontador $ar $rut $dv $us $gr $im
