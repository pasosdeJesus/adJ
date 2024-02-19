#!/bin/sh
# Redimensiona un contendor cifrado opcionalmente cambiando clave
# Dominio público. 2015. vtamara@pasosdeJesus.org
# amplia-vn.sh 1 

if (test "$1" = "") then {
	echo "Parametro 1 es número de dispositivo vnd (ya debe haber bajado servicios)"
	exit 1;
} fi;

nd="$1"
u=`whoami`
if (test "$u" != "root") then {
	echo "Debe ser ejecutado por root"
	exit 1;
} fi;
mount | grep "^/dev/vnd${nd}c" > /dev/null 2>&1
if (test "$?" != "0") then {
	echo "No se encontro montado contenedor /dev/vdn${nd}c";
	exit 1;
} fi;
dir=`mount | grep "^/dev/vnd${nd}c" | sed -e "s/^.dev.vnd.c on \([^ ]*\) type.*/\1/g"`

echo "Seguro ya termino servicios que operaban en $dir ?"
echo "[Enter] para proceder"
read

cont=`vnconfig -l | grep "^vnd${nd}:" | sed -e "s/vnd.*: covering \([^ ]*\) on .*/\1/g"`
if (test "$TAM" = "") then {
	TAM=4000000;
	# Cabe en DVD
} fi;        
if (test "$RUTAIMG" = "") then {
	RUTAIMG=/var/
} fi;

if (test -f "/$RUTAIMG/nuevo-tmp.img") then {
	echo "Existe /$RUTAIMG/nuevo-tmp.img que se espera usar temporalmente"
	exit 1;
} fi;
vnconfig -l | grep "^vnd0:.*covering" > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "Se esta usando vnd0 que se espera usar temporalemnte"
	exit 1;
} fi;
mount | grep "\/mnt\/tmp" > /dev/null 2>&1
if (test "$?" = "0") then {
	echo "/mnt/tmp usado pero se espera usar temporalemnte"
	exit 1;
} fi;

ncont=`basename $cont`
hoy=`date +%Y-%m-%d`
if (test -f "/$RUTAIMG/copia-$hoy-$ncont") then {
	echo "Existe /$RUTAIMG/copia-$hoy-$ncont donde se esperaba hacer copia"
	exit 1;
} fi;
echo "Por: "
echo "1- Crear /$RUTAIMG/nuevo-tmp.img contendor cifrado de tamaño $TAM (cambiable con variable TAM)."
echo "2- Montar contenedor en /mnt/tmp"
echo "3- Copiar de $dir a /mnt/tmp"
echo "4- Desmontar /mnt/tmp y desconfiguar vnd0"
echo "5- Desmontar $dir y desconfigurar vnd${nd}"
echo "6- Sacar copia de $cont como /$RUTAIMG/copia-$hoy-$ncont"
echo "7- Renombar /$RUTAIMG/nuevo-tmp.img como $cont"
echo "8- Configurar nuevo $cont y volver a montar en $dir"
echo "[Enter] para proceder"
read

dd of=/$RUTAIMG/nuevo-tmp.img bs=1024 seek=$TAM count=0
if (test "$?" != "0") then {
	echo "Fallo dd";
	exit 1;
} fi;
vnconfig -ckv vnd0 /$RUTAIMG/nuevo-tmp.img
if (test "$?" != "0") then {
	echo "Fallo vnconfing";
	exit 1;
} fi;
newfs /dev/rvnd0c 
if (test "$?" != "0") then {
	echo "Fallo newfs";
	exit 1;
} fi;
mkdir -p /mnt/tmp
mount /dev/vnd0c /mnt/tmp
if (test "$?" != "0") then {
	echo "Fallo mount";
	exit 1;
} fi;
rsync -ravzp $dir/ /mnt/tmp
if (test "$?" != "0") then {
	echo "Fallo rsync";
	exit 1;
} fi;

umount /mnt/tmp
if (test "$?" != "0") then {
	echo "Fallo umount";
	exit 1;
} fi;
vnconfig -u vnd0 
if (test "$?" != "0") then {
	echo "Fallo vnconfig -u";
	exit 1;
} fi;
umount $dir
if (test "$?" != "0") then {
	echo "Fallo umount $dir";
	exit 1;
} fi;
vnconfig -u vnd${nd}
if (test "$?" != "0") then {
	echo "Fallo segundo vnconfig -u ";
	exit 1;
} fi;
mv $cont /$RUTAIMG/copia-$hoy-$ncont
if (test "$?" != "0") then {
	echo "Fallo primer mv ";
	exit 1;
} fi;
mv /$RUTAIMG/nuevo-tmp.img $cont
if (test "$?" != "0") then {
	echo "Fallo segundo mv ";
	exit 1;
} fi;
vnconfig -ckv vnd${nd} $cont
if (test "$?" != "0") then {
	echo "Fallo vnconfig final ";
	exit 1;
} fi;
mount /dev/vnd${nd}c $dir
if (test "$?" != "0") then {
	echo "Fallo mount final ";
	exit 1;
} fi;

