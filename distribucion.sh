#!/bin/sh
# Generar distribución Aprendiendo de Jesús.
# Dominio público de acuerdo a la legislación colombiana. 
# http://www.pasosdejesus.org/dominio_publico_colombia.html
# 2007. vtamara@pasosdeJesus.org. 

inter=$1;
sp=$2;

if (test ! -f "ver.sh") then {
  echo "Falta archivo de configuración ver.sh";
  if (test "ver.sh.plantilla") then {
    echo "Copiando configuración por defecto de ver.sh.plantilla";
    cp ver.sh.plantilla ver.sh
    echo "Este archivo de ordenes es controlado por ver.sh, por favor editelo y vuelva a ejecutar"
    exit 0;
  } fi;
} fi;
if (test "$inter" = "-c") then {
  . ./$sp
} else {
  . ./ver.sh
} fi;


mkdir -p ./tmp

dini=`pwd`;

function die {
  echo $1;
  exit 1;
}

function vardef {
  if (test "$2" = "") then {
    die "Falta variable $1";
  } fi;
}

vardef DESTDIR $DESTDIR
D_DESTDIR=$DESTDIR
vardef RELEASEDIR $RELEASEDIR
D_RELEASEDIR=$RELEASEDIR
vardef XSRCDIR ${XSRCDIR}
echo "Genera distribución de adJ" | tee -a /var/www/tmp/distrib-adJ.bitacora
date | tee -a /var/www/tmp/distrib-adJ.bitacora
echo "DESTDIR=$DESTDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora
echo "RELEASEDIR=$RELEASEDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora
echo "XSRCDIR=$XSRCDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora

mkdir -p $DESTDIR/usr/share/mk

cdir=`pwd`
if (test ! -d /usr/src) then {
  echo "Se requieren fuentes de sistema base en /usr/src";
} fi;
if (test ! -d /sys) then {
  echo "Se requieren fuentes del kernel en /sys";
} fi;
if (test ! -d $XSRCDIR) then {
  echo "Se requieren fuentes de Xorg 4 en $XSRCDIR";
} fi;
if (test ! -d /usr/obj) then {
  die "Se requiere directorio para compilar sistema base y kernel: /usr/obj";
} fi;

narq=`uname -m`

if (test ! -d $V$VESP-$ARQ) then {
  mkdir -p $V$VESP-$ARQ/paquetes/
  cp -rf arboldvd/* $V$VESP-$ARQ/
} fi;

ANONCVS="anoncvs@anoncvs1.ca.openbsd.org:/cvs"
ANONCVS="anoncvs@mirror.planetunix.net:/cvs"

echo " *> Actualizar fuentes de CVS" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test "$inter" = "-i") then {
  echo -n "(s/n)?"
  read sn
}
else {
  sn=$autoCvs;
} fi;
if (test "$sn" = "s") then {  
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
  fi

  if (test -d /usr/src$VP-orig/) then {
    cd /usr/src$VP-orig
    echo "/usr/src$VP-orig"
  } else {
    cd /usr/src
    echo "/usr/src"
  } fi;
  if (test ! -f CVS/Root) then {
    for i in `find . -name CVS`; do 
      echo $i;
      echo "$ANONCVS" > $i/Root;
    done;
  } fi;
  cvs -z3 update -Pd -r$R 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  if (test -d /usr/src$VP-orig/) then {
    rsync -ravzp --delete /usr/src$VP-orig/* /usr/src/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test -d /usr/src$VP-orig/) then {
    cd /usr/src$VP-orig/sys 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } else {
    cd /sys 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test ! -f CVS/Root) then {
    for i in `find . -name CVS`; do 
      echo $i;
      echo "$ANONCVS" > $i/Root;
    done;
  } fi;
  cvs -z3 update -Pd -r$R 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  if (test -d /usr/src$VP-orig/) then {
    rsync -ravzp --delete /usr/src$VP-orig/sys/* /sys/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test -d /usr/xenocara$VP-orig/) then {
    cd /usr/xenocara$VP-orig/sys 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } else {
    cd $XSRCDIR 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test ! -f CVS/Root) then {
    for i in `find . -name CVS`; do 
      echo $i;
      echo "$ANONCVS" > $i/Root;
    done;
  } fi;
  cvs -z3 update -Pd -r$R 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  if (test -d /usr/xenocara$VP-orig/) then {
    rsync -ravzp --delete /usr/xenocara$VP-orig/* $XSRCDIR 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test -d /usr/ports$VP-orig/) then {
    cd /usr/ports$VP-orig/ 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } else {
    cd /usr/ports/ 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  } fi;
  if (test ! -f CVS/Root) then {
    for i in `find . -name CVS`; do 
      echo $i;
      grep "mystuff" $i > /dev/null 2>&1
      if (test "$?" != "0") then {
        echo "$ANONCVS" > $i/Root;
      } fi;
    done;
  } fi;
  cvs -z3 update -Pd -r$R 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  if (test -d /usr/ports$VP-orig/) then {
    rsync -ravzp /usr/ports$VP-orig/* /usr/ports 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  } fi;
} fi;

echo " *> Transformar y compilar kernel APRENDIENDODEJESUS" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn;
}
else {
  sn=$autoCompKernel;
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;

  cd /sys
  $dini/hdes/servicio-kernel.sh 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora  
  # Esta en general se cambiaron comentarios a lo largo de todas
    # las fuentes.  Ver documentación en 
    # http://aprendiendo.pasosdejesus.org/?id=Renombrando+Daemon+por+Service

  # Para compilar vmstat
  cp /sys/uvm/uvm_extern.h /usr/include/uvm/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora

  cd /sys/arch/$ARQ/conf 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  echo "pwd=" `pwd` 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  sed -e "s/^#\(option.*NTFS.*\)/\1/g" GENERIC > APRENDIENDODEJESUS
  rm -rf /sys/arch/$ARQ/compile/APRENDIENDODEJESUS/obj/* 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  chown -R build:wsrc /usr/obj
  config APRENDIENDODEJESUS 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd ../compile/APRENDIENDODEJESUS 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  echo "pwd=" `pwd` 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  rm -f .depend 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make clean  2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make obj 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make config 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make -j4 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cp /sys/arch/$ARQ/compile/APRENDIENDODEJESUS/obj/bsd $dini/$V$VESP-$ARQ/bsd 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /sys/arch/$ARQ/conf 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  sed -e "s/GENERIC/APRENDIENDODEJESUS/g" GENERIC.MP > APRENDIENDODEJESUS.MP
  rm -rf /sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/obj/* 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  config APRENDIENDODEJESUS.MP 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd ../compile/APRENDIENDODEJESUS.MP 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  rm .depend 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make clean  2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make obj 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make config 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  make -j4 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cp /sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/obj/bsd $dini/$V$VESP-$ARQ/bsd.mp 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora

} fi;

echo " *> Instalar kernel recién compilado" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoInsKernel
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;
  cd /sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  make install 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "Debe reiniciar sistema para iniciar kernel mp (si prefiere el que es para un procesador simple instalelo manualmente)..." | tee -a /var/www/tmp/distrib-adJ.bitacora
#/  exit 0;
} fi;


function compilabase   {
  echo 'Inicia compilabase' | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo 'cd /usr/src/ && LANG=POSIX make depend' | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/ && make depend 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/sbin/wsconsctl && if (test ! -f obj/keysym.h) then { make keysym.h; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.bin/compile_et && if (test ! -f obj/error_table.h) then { make error_table.h; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.bin/tic && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make  2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.bin/infocmp && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make  2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.bin/sudo/lib && if (test ! -f obj/gram.c) then { make gram.h; } fi && cd .. && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.bin/tset && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.sbin/rpc.statd && if (test ! -f obj/sm_inter.h) then { make sm_inter.h; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.sbin/afs/usr.sbin/ydr && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/usr.sbin/afs/lib/libarla && if (test ! -f obj/fs.h) then { make fs.h; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/gnu/usr.bin/cc/libcpp && if (test ! -f obj/localedir.h) then { make localedir.h; } fi && make 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/lib/libiberty/ && make depend -f Makefile.bsd-wrapper depend && make -f Makefile.bsd-wrapper 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/gnu/usr.bin/cc/libobjc && make depend 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/gnu/lib/libiberty/ && make -f Makefile.bsd-wrapper config.status 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/kerberosV/usr.sbin/kadmin/ && make kadmin-commands.h 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/kerberosV/usr.sbin/ktutil/ && make ktutil-commands.h 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/kerberosV/lib/libasn1 && make rfc2459_asn1.h && make rfc2459_asn1-priv.h && make cms_asn1.h && make cms_asn1-priv.h && make krb5_asn1-priv.h && make  digest_asn1-priv.h 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
#  cd /usr/src/gnu/usr.bin/perl && make -f Makefile.bsd-wrapper depend 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  #find /usr/obj -name ".depend" -exec rm {} ';'
  DT=$DESTDIR
  unset DESTDIR 
  echo "whoami 2" >> /var/www/tmp/distrib-adJ.bitacora
  whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
  cd /usr/src && LANG=C make -j4 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "whoami 2.5" >> /var/www/tmp/distrib-adJ.bitacora
  whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
  export DESTDIR=$DT;
}

echo " *> Actualizar zonas horarias" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoActZonasHorarias
} fi;
if (test "$sn" = "s") then {
  mkdir -p /tmp/tz 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  rm -rf /tmp/tz/* 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /tmp/tz 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  ftp ftp://ftp.iana.org/tz/tzdata-latest.tar.gz 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  mkdir datfiles 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd datfiles 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  tar xvfz ../tzdata-latest.tar.gz 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cp -rf * /usr/src/share/zoneinfo/datfiles/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
} fi;  

echo " *> Transformar y compilar resto del sistema base" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoCompBase
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq" | tee -a /var/www/tmp/distrib-adJ.bitacora 
    exit 1;
  } fi;


  echo -n "Eliminar /usr/obj ";
  if (test "$inter" = "-i") then {
    echo -n "(s/n)? "
    read sn
  } 
  else {
    sn=$autoElimCompBase
  } fi;
  if (test "$sn" = "s" ) then {
    echo "Uyy, Eliminando"; 
    rm -rf /usr/obj/* 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  } fi;
  echo "Esta operacion modificará tanto las fuentes en /usr como archivos en /etc e /include del sistema donde se emplea para hacer posible la compilación;"
  rm -rf ${DESTDIR}/usr/include/g++  2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  mkdir -p ${DESTDIR}/usr/include/g++ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  #export CFLAGS=-I/usr/include/g++/${ARQ}-unknown-openbsd${V}/
  # Aplicando parches sobre las fuentes de OpenBSD sin cambios para
  # facilitar aportar  a OpenBSD con prioridad cambios que posiblemente
  # serán aceptados más facilmente
  (cd $dini/arboldes/usr/src; 
  for i in *patch; do 
    echo $i; 
    if (test ! -f /usr/src/$i) then { 
      cp $i /usr/src; 
      ( cd /usr/src; 
        echo "A mano"; 
        patch -p1 < $i;
        if (test "$?" != "0") then { exit $?; } fi; 
      )
    } fi; 
  done) 2>&1 |  tee -a  /var/www/tmp/distrib-adJ.bitacora
  (cd $dini/arboldes/usr/ports; 
  for i in *patch; do 
    echo $i; 
    if (test ! -f /usr/ports/$i) then { 
      cp $i /usr/ports; 
      ( cd /usr/ports; 
        echo "A mano"; 
        patch -p1 < $i;
        if (test "$?" != "0") then { exit $?; } fi; 
      ) 
    } fi;
  done) 2>&1 |  tee -a  /var/www/tmp/distrib-adJ.bitacora

  echo "* Copiando archivos nuevos en /usr/src" | tee -a /var/www/tmp/distrib-adJ.bitacora
  (cd $dini/arboldes/usr/src ; for i in `find . -type f | grep -v CVS | grep -v .patch`; do  if (test ! -f /usr/src/$i) then { echo $i; n=`dirname $i`; mkdir -p /usr/src/$n; cp $i /usr/src/$i; } fi; done ) 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Cambiando /etc " | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /etc 2>&1 >>  /var/www/tmp/distrib-adJ.bitacora
  $dini/arboldd/usr/local/adJ/servicio-etc.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Cambiando /usr/src/etc" | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/etc 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  $dini/arboldd/usr/local/adJ/servicio-etc.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Cambios iniciales a /usr/src" | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/ 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
  $dini/hdes/servicio-base.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  grep LOG_SERVICE  /usr/include/syslog.h > /dev/null 2>&1
  if (test "$?" != "0") then {
    echo "* Cambiando /sys" | tee -a /var/www/tmp/distrib-adJ.bitacora
    cd /sys 2>&1 >> /var/www/tmp/distrib-adJ.bitacora
    $dini/hdes/servicio-kernel.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora  
  } fi;
  #echo "* Usar llaves de adJ en lugar de las de OpenBSD" | tee -a /var/www/tmp/distrib-adJ.bitacora
  #grep "signfiy\/adJ" /usr/src/usr.sbin/sysmerge/sysmerge.sh > /dev/null 2>&1
  #if (test "$?" != "0") then {
  #  cp /usr/src/usr.sbin/sysmerge/sysmerge.sh /usr/src/usr.sbin/sysmerge/sysmerge.sh.orig 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  #  sed -e 's/signify\/openbsd/signify\/adJ/g' /usr/src/usr.sbin/sysmerge/sysmerge.sh.orig > /usr/src/usr.sbin/sysmerge/sysmerge.sh 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  #} fi;
  cd /usr/src && make obj 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Completo make obj" | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "whoami 0" >>  /var/www/tmp/distrib-adJ.bitacora
  whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
  # Antes de compilar todo /usr/src, compilar perl porque pkg_add
  # depende de ese
  cd /usr/src/gnu/usr.bin/perl && make -f Makefile.bsd-wrapper depend 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/gnu/usr.bin/perl && make -f Makefile.bsd-wrapper 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/gnu/usr.bin/perl && unset DESTDIR && make install 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora

  echo "* Completo compilación e instalación de perl" | tee -a /var/www/tmp/distrib-adJ.bitacora

  # Además de esto en adJ 6.8 nos toco inicialmente:
  # doas cp /usr/src/gnu/usr.bin/perl/libperl.so.20.0 /usr/libdata/perl5/amd64-openbsd/CORE/
  # Pero fue mejor:
  # doas rm /usr/libdata/perl5/amd64-openbsd/CORE/libperl.so.20.0

  # Nos ha servidor para en este punto y recompilar todos los paquetes p5-*
  # incluidos en adJ con el nuevo perl.
  # Forzar su instalación y entonces si continuar con build

  # build borrará código objeto 
  # reconstruira dependencias, compilará e instalará
  cd /usr/src && unset DESTDIR && LANG=POSIX nice make -j4 build 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "whoami 4" >> /var/www/tmp/distrib-adJ.bitacora
  whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
  cd $D_DESTDIR/etc && $dini/arboldd/usr/local/adJ/servicio-etc.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Completo make build" | tee -a /var/www/tmp/distrib-adJ.bitacora
} fi;

export DLENG=es

function verleng {
  a=$1;
  if (test "$a" = "") then {
    echo "Falta archivo como primer parámetro en verleng" | tee -a /var/www/tmp/distrib-adJ.bitacora
    exit 1;
  } fi;
  echo $a;
  grep "DLENG" $a > /dev/null 2> /dev/null
  if (test "$?" != "0") then {
    echo "Instalador en español no está bien configurado en fuentes" | tee -a /var/www/tmp/distrib-adJ.bitacora
    echo "Agregar:
SCRIPT  \${CURDIR}/upgrade-\${DLENG}.sh                   upgrade
SCRIPT  \${CURDIR}/install-\${DLENG}.sh                   install
SCRIPT  \${CURDIR}/install-\${DLENG}.sub                  install.sub"
    echo "en $a";
    cp $a $a.antestrad 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
    sed -e "s/upgrade.sh/upgrade-\${DLENG}.sh/g;s/install.sh/install-\${DLENG}.sh/g;s/\/install.sub/\/install-\${DLENG}.sub/g;s/\/install.md/\/install-\${DLENG}.md/g" $a.antestrad > $a
  } fi;
}



#
echo " *> Hacer una distribución en $DESTDIR y unos juegos de instalación en $RELEASEDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoDist
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;


#  cd /usr/src/distrib/crunch && make obj depend \ && make all install
  echo -n " *> Eliminar $DESTDIR y $RELEASEDIR antes " | tee -a /var/www/tmp/distrib-adJ.bitacora;
  if (test "$inter" = "-i") then {
    echo -n "(s/n)? "
    read sn
  } 
  else {
    sn=$autoElimDist
  } fi;
  if (test "$sn" = "s") then {
    test -d ${DESTDIR}- && mv ${DESTDIR}- ${DESTDIR}d- && \
                   rm -rf ${DESTDIR}d- &
    test -d ${DESTDIR} && mv ${DESTDIR} ${DESTDIR}- 
  } fi;
  mkdir -p ${DESTDIR} ${RELEASEDIR} 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  ed /usr/src/etc/Makefile << EOF
/^LOCALTIME=
s/Canada\/Mountain/America\/Bogota/g
w
q
EOF
  #compilabase
  echo "DESTDIR=$DESTDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  chown build /usr/src/etc/master.passwd 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  chown build /usr/src/sys/arch/amd64/compile/APRENDIENDODEJESUS/obj/version 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  chown build /usr/src/sys/arch/amd64/compile/APRENDIENDODEJESUS.MP/obj/version 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  chown build /usr/src/usr.sbin/fw_update/obj/firmware_patterns 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/etc && RELEASEDIR=/$D_RELEASEDIR DESTDIR=/$D_DESTDIR nice make release 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora;
  echo "* Completo make release"
  cd $D_DESTDIR/etc && $dini/arboldd/usr/local/adJ/servicio-etc.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  echo "* Parece que sobreescribe /releasedir/bsd y /releasedir/bsd.mp con GENERIC tocaria recuperar los compilador antes"
  find "$DESTDIR"  -exec touch {} ';' 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  find "$RELEASEDIR"  -exec touch {} ';' 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
#} fi;

echo " *> Suponiendo que ya se completo un build en /, instalar en $DESTDIR y de este dejar comprimidos en $RELEASEDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;
# if (test "$inter" = "-i") then {
#   echo -n "(s/n)? "
#   read sn
# }
# else {
#   sn=$autoGenTGZ
#} fi;
#if (test "$sn" = "s") then {
  cd $D_DESTDIR/etc && $dini/arboldd/usr/local/adJ/servicio-etc.sh 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora
  cd /usr/src/etc && DESTDIR=/$D_DESTDIR nice make release-sets 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora;
  echo "* Completo make release-sets"

} fi;



echo " *> Recompilar e instalar X-Window con fuentes de $XSRCDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;

if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoX
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq" | tee -a /var/www/tmp/distrib-adJ.bitacora;
    exit 1;
  } fi;

  echo -n "Eliminar /usr/xobj ";
  if (test "$inter" = "-i") then {
    echo -n "(s/n)? "
    read sn
  } 
  else {
    sn=$autoElimX
  } fi;
  if (test "$sn" = "s" ) then {
    echo "Uyy, Eliminando"; 
    rm -rf /usr/xobj/*
  } fi;

  mkdir -p ${DESTDIR}/usr/include 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cp -rf /usr/include/* ${DESTDIR}/usr/include/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  mkdir -p ${DESTDIR}/usr/lib 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  cp -rf /usr/lib/crt* ${DESTDIR}/usr/lib/ 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora
  if (test "$XSRCDIR" != "/usr/xenocara") then {
    ln -s $XSRCDIR /usr/xenocara 2>&1 |  tee -a /var/www/tmp/distrib-adJ.bitacora;
  } fi;
  cd $XSRCDIR

  echo "* Aplicando parches en /usr/xenocara/" | tee -a /var/www/tmp/distrib-adJ.bitacora
  (cd $dini/arboldes/usr/xenocara/; for i in *patch; do echo $i; if (test ! -f /usr/xenocara/$i) then { cp $i /usr/xenocara/; (cd /usr/xenocara/; echo "A mano"; patch -p1 < $i;) } fi; done) 2>&1 |  tee -a  /var/www/tmp/distrib-adJ.bitacora
  echo "* Copiando archivos nuevos en /usr/xenocara" | tee -a /var/www/tmp/distrib-adJ.bitacora
  (cd $dini/arboldes/usr/xenocara; for i in `find . -type f | grep -v CVS | grep -v .patch`; do  if (test ! -f /usr/xenocara/$i) then { echo $i; n=`dirname $i`; mkdir -p /usr/xenocara/$n; cp $i /usr/xenocara/$i; } fi; done )
  # Pequeños cambios (logo, bienvenida)
  $dini/hdes/xenocaraadJ.sh  
  mkdir -p ${DESTDIR}/usr/X11R6/bin
  mkdir -p ${DESTDIR}/usr/X11R6/man/cat1
  export X11BASE=/usr/X11R6
  echo "** bootstrap" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  make bootstrap
  if (test "$?" != "0") then {
    echo " *> bootstrap incompleto";
    exit $?;
  } fi;
  echo "** obj" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  make obj
  if (test "$?" != "0") then {
    echo " *> obj incompleto";
    exit $?;
  } fi;
  #rm -rf /usr/xobj/*
  #mkdir -p /usr/xobj/app/fvwm/libs
  echo "** build" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  find /usr/xenocara -name config.status | xargs rm -f
  # en 4.6 toco agregar a /usr/xenocara/kdrive/Makefile.bsd-wrapper:
  #clean:
  # mv  $(_SRCDIR)/config.status $(_SRCDIR)/config.status-copia
  mkdir -p ${DESTDIR}
  (unset DESTDIR; AUTOCONF_VERSION=2.69 make -j4 build)
  # Despues de este toco
  #cp /usr/xenocara/xserver/config.status-copia /usr/xenocara/xserver/config.status 
  #rm -rf /usr/xobj/*
  #mkdir -p /usr/xobj/app/fvwm/libs
  #echo "** build 2";
  #make build
  if (test "$?" != "0") then {
    echo " *> build incompleto";
    exit $?;
  } fi;
} fi;

echo " *> Distribución de X-Window en $DESTDIR y un juego de instalación en $RELEASEDIR  con fuentes de $XSRCDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoXDist
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;


  echo -n " *> Eliminar $DESTDIR " | tee -a /var/www/tmp/distrib-adJ.bitacora;
  if (test "$inter" = "-i") then {
    echo -n "(s/n)? "
    read sn
  } 
  else {
    sn=$autoElimXDist
  } fi;
  if (test "$sn" = "s") then {
          test -d ${DESTDIR}- && mv ${DESTDIR} ${DESTDIR}d- && \
            rm -rf ${DESTDIR}d- &
          test -d ${DESTDIR} && mv ${DESTDIR} ${DESTDIR}- &
  } fi;
        mkdir -p ${DESTDIR} ${RELEASEDIR}
  (cd $XSRCDIR; nice make release)
  find $DESTDIR  -exec touch {} ';'

} fi;

echo " *> Preparar bsd.rd" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoBsdrd
} fi;
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;
  
  rm -f /usr/src/distrib/miniroot/install-es.sub
  ln -s $dini/tminiroot/install-es.sub /usr/src/distrib/miniroot/install-es.sub
  rm -f /usr/src/distrib/amd64/common/install-es.md
  ln -s $dini/tminiroot/install-amd64-es.md /usr/src/distrib/amd64/common/install-es.md
  #verleng /usr/src/distrib/miniroot/list 
  #verleng /usr/src/distrib/amd64/common/list 

  cp /etc/signify/adJ-*pub /$D_DESTDIR/etc/signify/
  cp /usr/src/distrib/amd64/ramdisk_cd/list /tmp/ramdisk_list
  #cp /usr/src/distrib/amd64/common/list /tmp/common_list
  sed -e 's/signify\/openbsd/signify\/adJ/g;s/install.sub/install-es.sub/g;s/install-adm64.md/install-amd64-es.md/g' /tmp/ramdisk_list > /usr/src/distrib/amd64/ramdisk_cd/list 
  verleng /usr/src/distrib/amd64/ramdisk_cd/list 
  #sed -e 's/signify\/openbsd/signify\/adJ/g' /tmp/common_list > /usr/src/distrib/amd64/common/list

  cd /usr/src/distrib/special/libstubs
  make
  cd /sys/arch/$ARQ/stand/cdbr
  make clean
  cd ..
  make
  DESTDIR=/$D_DESTDIR make install
  cd /usr/src/distrib/$ARQ/ramdisk_cd
  DLENG=es RELEASEDIR=${RELEASEDIR} make
  cp obj/bsd.rd ${RELEASEDIR}
  cp obj/bsd.rd $dini/$V$VESP-$ARQ
} fi;

cd $cdir
echo " *> Copiar juegos de instalación de sistema base y X-Window de $RELEASEDIR a $dini/$V$VESP-$ARQ?" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoJuegosInstalacion
} fi;

if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;


  if (test -f /sys/arch/$ARQ/compile/APRENDIENDODEJESUS/obj/bsd) then {
    cp /sys/arch/$ARQ/compile/APRENDIENDODEJESUS/obj/bsd ${RELEASEDIR}/bsd
  } fi;
  if (test -f /sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/obj/bsd) then {
    cp /sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/obj/bsd ${RELEASEDIR}/bsd.mp
  } fi;
  find $DESTDIR -exec touch {} ';'
  cd /usr/src/distrib/sets && sh checkflist
  find $RELEASEDIR  -exec touch {} ';'
  cp $RELEASEDIR/* $dini/$V$VESP-$ARQ
  rm -f $dini/$V$VESP-$ARQ/{MD5,CKSUM,index.txt,cd??.iso,}
} fi;


paraexc="";
function paquete {
  nom=$1;
  dest=$2;
  copiar=$3;
  subd=$4;
  if (test "$dest" = "") then {
    dest=paquetes;
  } fi;
  if (test "$nom" = "") then {
    echo "En llamado a funcion paquete falta nombre del paquete";
    exit 1;
  } fi;
  echo $nom
  echo $nom | grep "\/" > /dev/null 2>&1
  if (test "$?" = "0") then {
    # categoria va con nombre para paquetes en mystuff
    cat=`echo $nom | sed -e "s/\/.*//g"`
    echo "OJO cat=$cat"
    d1="$nom"
    echo "OJO d1=$d1"
    if (test "$subd" != "") then {
      d1="$d1/$subd"
    } fi;
    nom=`echo $nom | sed -e "s/^.*\///g"`
    echo "OJO nom=$nom"
  } else {
    l=`grep "^$nom-[0-9]" /usr/local/share/ports-INDEX | head -n 1`
    if (test "$l" = "") then {
      echo "Desconocido $nom en /usr/local/share/ports-INDEX"
      exit 1;
    } fi;
    d1=`echo "$l" | sed -e 's/^[^|]*|\([^,|]*\)[,|].*/\1/g'`
    if (test "$subd" != "") then {
      d1=`echo $d1 | sed -e 's/\/[^\/]*$//g'`
      d1="$d1/$subd"
    } fi;
    cat=`echo $d1 | sed -e 's/\/[^\/]*$//g'`
  } fi;
  mys="mystuff";
  dir="/usr/ports/mystuff/$d1/"
  echo "OJO dir=$dir"
  test -d "$dir"
  r=$?
  echo "r=$r"
  if (test "$r" != "0") then {
    echo "OJO no es dir $dir"
    dir="/usr/ports/$d1/"
    if (test ! -d "$dir") then {
      echo "No es directorio $dir";
      exit 1;
    } fi;
  } fi;
  if (test "$nom" = "") then {
    echo "Falla en funcion paquete nom es vacio"
    exit 1;
  } fi;
  echo "*> Creando paquete $nom:$cat pasando a $dir" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  if (test "$PAQ_LIMPIA_PRIMERO" != "") then {
    (cd "$dir" ; make clean; rm /usr/ports/packages/$ARQ/all/$nom-[0-9][0-9a-z.]*.tgz)
  } fi;
  echo "*> Compila" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  (cd "$dir" ; make -j4)
  (cd "$dir" ; make package)
  if (test ! -f /etc/signify/adJ-$VP-pkg.sec) then {
    echo "No hay llave privada /etc/signify/adJ-$VP-pkg.sec";
    echo "Si no lo ha hecho con signify -G -c \"Firma adJ $V para paquetes\" -n -s /etc/signify/adJ-$VP-pkg.sec -p /etc/signify/adJ-$VP-pkg.pub"
    exit 1;
  } fi;
  echo "*> Copia $copiar" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  if (test "$copiar" = "") then {
    f1=`ls /usr/ports/packages/$ARQ/all/$nom-$subd[-0-9][0-9a-z.]*.tgz | head -n 1`
    f2=`ls $dini/$V$VESP-$ARQ/$dest/$nom-$subd[-0-9][0-9a-z.]*.tgz | head -n 1`
    echo "*> simple f1=$f1, f2=$f2, subd=$subd " | tee -a /var/www/tmp/distrib-adJ.bitacora;
    if (test ! -f "$f2" -o "$f2" -ot "$f1") then {
      echo "*> Firmando y copiando /usr/ports/packages/$ARQ/all/$nom-*.tgz" | tee -a /var/www/tmp/distrib-adJ.bitacora
      cmd="rm -f $dini/$V$VESP-$ARQ/$dest/$nom-[0-9][0-9a-z.]*.tgz"
      echo "cmd=$cmd";
      eval "$cmd";
      cmd="pkg_sign -v -o $dini/$V$VESP-$ARQ/$dest/ -s signify2 -s /etc/signify/adJ-$VP-pkg.sec /usr/ports/packages/$ARQ/all/$nom*.tgz"
      echo "cmd=$cmd";
      eval "$cmd";
    } fi;
    if (test "$paraexc" != "") then {
      paraexc="$paraexc $nom-*"
    } else {
      paraexc="$nom-*"
    } fi;
  } else {
    for i in $copiar; do
      if (test "$subd" != "") then {
        echo "OJO subd no vacio: /usr/ports/packages/$ARQ/all/$i-$subd*.tgz " >> /var/www/tmp/distrib-adJ.bitacora
        f1=`ls /usr/ports/packages/$ARQ/all/$i-$subd*.tgz | head -n 1`
        f2=`ls $dini/$V$VESP-$ARQ/$dest/$i-$subd*.tgz | head -n 1`
      } else {
        echo "OJO subd vacio"  >> /var/www/tmp/distrib-adJ.bitacora
        f1=`ls /usr/ports/packages/$ARQ/all/$i*.tgz | head -n 1`
        f2=`ls $dini/$V$VESP-$ARQ/$dest/$i*.tgz | head -n 1`
      } fi;
      echo "*> varios copiar=$copiar, d1=$d1, nom=$nom, i=$i f1=$f1, f2=$f2 " | tee -a /var/www/tmp/distrib-adJ.bitacora;
      if (test ! -f "$f2" -o "$f2" -ot "$f1") then {
        cmd="rm -f $f2"
        echo "cmd=$cmd";
        eval "$cmd";
        cmd="pkg_sign -v -o $dini/$V$VESP-$ARQ/$dest/ -s signify2 -s /etc/signify/adJ-$VP-pkg.sec /usr/ports/packages/$ARQ/all/$i*.tgz"
        echo $cmd;
        eval $cmd
      } fi;
      if (test "$paraexc" != "") then {
        paraexc="$paraexc $i-*"
      } else {
        paraexc="$i-*"
      } fi;
    done;
  } fi;
}

echo " *> Compilar todos los paquetes de Contenido.txt en $dini/$V$VESP-$ARQ/paquetes " | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoTodosPaquetes
} fi;
echo $sn
if (test "$sn" = "s") then {
  for i in `grep "^.*-\\[v\\]" Contenido.txt | sed -e "s/^\(.*\)-\[v\].*/\1/g"`; do 
    paquete $i $s
  done
} fi;
  
echo " *> Generar paquetes de la distribución AprendiendoDeJesús en $dini/$V$VESP-$ARQ/paquetes " | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn=$autoPaquetes
} fi;


echo $sn
if (test "$sn" = "s") then {
  if (test "$ARQ" != "$narq") then {
    echo "Esta operación requiere que ARQ en ver.sh sea $narq";
    exit 1;
  } fi;


  if (test ! -d "/usr/ports/mystuff") then {
    mkdir -p /usr/ports
    ln -s $dini/arboldes/usr/ports/mystuff /usr/ports/mystuff
  } fi;
  rm tmp/disponibles*

  # Modificados para posibilitar compilación
  # Deben estar en mystuff


  # Todo lo de perl tuvo que recompilarse
  # evita error loadable library and perl binaries are mismatched (got handshake key 0xca80000, needed 0xcd80000)
  # Si por ejemplo es:
  #Name.c: loadable library and perl binaries are mismatched (got handshake key 0xb700000, needed 0xbb00000)
  # Buscar módulo de Perl con pkg_locate Name.so, recompilarlo e instalarlo 
  paquete p5-XML-LibXML
  paquete p5-Module-Build-Tiny
  paquete p5-Module-Build
  paquete p5-Test-Fatal
  paquete p5-Test-Requires
  paquete p5-ExtUtils-Helpers
  paquete p5-Net-LibIDN2
  paquete p5-Digest-HMAC
  paquete p5-NetAddr-IP
  paquete p5-Params-Validate
  paquete p5-Params-Util
  paquete p5-DBD-SQLite
  paquete p5-Package-Stash-XS
  paquete p5-Class-Inspector
  paquete p5-Class-Load-XS
  paquete p5-Cpanel-JSON-XS
  paquete p5-List-MoreUtils-XS
  paquete p5-List-SomeUtils-XS
  paquete p5-Ref-Util-XS
  paquete p5-YAML-XS
  paquete p5-List-MoreUtils
  paquete p5-Class-XSAccessor
  paquete p5-MooX-Types-MooseLike
  paquete p5-Digest-SHA1
  paquete p5-Authen-SASL
  paquete p5-CGI
  paquete p5-Email-Abstract
  paquete p5-Email-Date-Format
  paquete p5-Email-MIME-ContentType
  paquete p5-Email-MessageID
  paquete p5-File-Copy-Recursive
  paquete p5-MIME-Types
  paquete p5-XML-NamespaceSupport
  paquete p5-XML-SAX
  paquete p5-XML-SAX-Base
  paquete p5-Data-OptList
  paquete p5-Devel-GlobalDestruction
  paquete p5-Devel-OverloadInfo
  paquete p5-Devel-StackTrace
  paquete p5-Dist-CheckConflicts
  paquete p5-Module-Implementation
  paquete p5-Eval-Closure
  paquete p5-MRO-Compat
  paquete p5-Module-Runtime
  paquete p5-Package-DeprecationManager
  paquete p5-Package-Stash-XS
  paquete p5-Sub-Exporter
  paquete p5-Sub-Name
  paquete p5-Try-Tiny
  paquete p5-Task-Weaken
  paquete p5-Moose
  paquete p5-File-ShareDir
  paquete p5-File-ShareDir-Install
  paquete p5-Params-ValidationCompiler
  paquete p5-Specio
  paquete p5-namespace-autoclean
  paquete p5-DateTime-Locale
  paquete p5-DateTime-TimeZone


  paquete p5-DBI
  paquete p5-BSD-Resource

  paquete p5-B-Hooks-EndOfScope
  paquete p5-BSD-Resource
  paquete p5-Class-Load
  paquete p5-Class-Method-Modifiers
  paquete p5-Class-Singleton
  paquete p5-Class-XSAccessor
  paquete p5-Clone
  paquete p5-Clone-PP
  paquete p5-Crypt-OpenSSL-Bignum
  paquete p5-Crypt-OpenSSL-RSA
  paquete p5-Crypt-OpenSSL-Random
  paquete p5-DBD-mysql
  paquete p5-DBI
  paquete p5-Data-Dumper-Concise
  paquete p5-Data-IEEE754
  paquete p5-Data-Printer
  paquete p5-Data-Validate-IP
  paquete p5-DateTime
  paquete p5-Encode-Detect
  paquete p5-Encode-Locale
  paquete p5-Error
  paquete p5-Exporter-Tiny
  paquete p5-File-HomeDir
  paquete p5-File-Listing
  paquete p5-File-Which
  paquete p5-FreezeThaw
  paquete p5-GeoIP2
  paquete p5-HTML-Parser
  paquete p5-HTML-Tagset
  paquete p5-HTTP-Cookies
  paquete p5-HTTP-Daemon
  paquete p5-HTTP-Date
  paquete p5-HTTP-Message
  paquete p5-HTTP-Negotiate
  paquete p5-IO-HTML
  paquete p5-IO-Socket-SSL
  paquete p5-JSON
  paquete p5-JSON-MaybeXS
  paquete p5-LWP-MediaTypes
  paquete p5-LWP-Protocol-https
  paquete p5-List-AllUtils
  paquete p5-List-SomeUtils
  paquete p5-List-UtilsBy
  paquete p5-MLDBM
  paquete p5-Mail-AuthenticationResults
  paquete p5-Mail-DKIM
  paquete p5-Mail-SPF
  paquete p5-Mail-Tools
  paquete p5-Math-Base-Convert
  paquete p5-Math-Int64
  paquete p5-MaxMind-DB-Common
  paquete p5-MaxMind-DB-Reader
  paquete p5-Moo
  paquete p5-MooX-StrictConstructor
  paquete p5-Moose
  paquete p5-Mozilla-CA-Fake
  paquete p5-Net-CIDR-Lite
  paquete p5-Net-DNS
  paquete p5-Net-DNS-Resolver-Programmable
  paquete p5-Net-Daemon
  paquete p5-Net-HTTP
  paquete p5-Net-LibIDN
  paquete p5-Net-Patricia
  paquete p5-Net-SSLeay
  paquete p5-PlRPC
  paquete p5-Pod-Parser
  paquete p5-Role-Tiny
  paquete p5-SQL-Statement
  paquete p5-Socket6
  paquete p5-Sort-Naturally
  paquete p5-Sub-Exporter-Progressive
  paquete p5-Sub-Identify
  paquete p5-Sub-Install
  paquete p5-Sub-Quote
  paquete p5-Throwable
  paquete p5-Time-TimeDate
  paquete p5-URI
  paquete p5-Variable-Magic
  paquete p5-WWW-RobotRules
  paquete p5-XML-Parser
  paquete p5-libwww
  paquete p5-namespace-autoclean
  paquete p5-namespace-clean
  paquete p5-strictures

  paquete p5-Locale-gettext
  paquete p5-MIME-Charset
  paquete textproc/p5-SGMLSpm
  paquete p5-Unicode-LineBreak

  paquete p5-Mail-SpamAssassin

  ### Requieren recompilación por cambio en FILE
  paquete unzip  # De no hacerse envía descompresiones a salida estándar
  paquete python paquetes "python" "3.9"
  paquete ruby paquetes "ruby ruby32-ri_docs" 3.2
  paquete gettext-tools paquetes 'gettext-tools gettext-runtime'  # Requerido para compilar muchos
  paquete m4 # Requerido para compilar bison (instalar antes de compilar bison)
  paquete bison # Requerido para compilar MariaDB
  paquete gmake # requerido para compilar PostgreSQL
  paquete ImageMagick  # requerido para compilar postgis

  paquete print/texlive/base paquetes texlive_base # Requerido para compilar ton
  paquete print/texlive/texmf paquetes texlive_texmf-minimal-2021 # Requerido para compilar ton

  ####
  # Retroportados para cerrar fallas o actualizar
  # Deben estar en arboldes/usr/ports/mystuff y en /usr/ports de current

  paquete postgresql-client paquetes "postgresql-server postgresql-client postgresql-contrib postgresql-docs postgresql-pg_upgrade" 
  paquete postgresql-previous 
  paquete postgis
  #paquete geo/spatialite/libspatialite
  paquete jansson

  # Recompilado con llave de adJ
  paquete chromium

  ###
  # Actualizados.  Están desactualizado en OpenBSD estable y current
  #paquete git paquetes "git"
  #paquete hevea # requiere ocamlbuild

  ####
  # Recompilados para cerrar fallas de portes actualizados (estable)
  # Para que operen bien basta actualizar CVS de /usr/ports 
  # Los siguientes no deben estar en arboldes/usr/ports/mystuff


  paquete zstd

  #paquete certbot paquetes "certbot py3-acme"
  #paquete cups
  #paquete dovecot
  #paquete dtc
  paquete firefox-esr
  #paquete flac
  #paquete gtk+3 paquetes "gtk+3-cups"
  #paquete gdal
  #paquete gnutls
  #paquete gnupg
  #paquete gvfs
  #paquete libgcrypt
  #paquete libmad
  #paquete libssh
  #paquete libxml
  #paquete libxslt
  #paquete lz4
  #paquete mariadb-client paquetes "mariadb-client mariadb-server" 
  #paquete mpg123
  #paquete mutt
  #paquete nginx
  paquete node
  #paquete nspr
  #paquete oniguruma 
  paquete openssl paquetes "openssl" 3.0
  #paquete quirks
  #paquete pcre2 
  #paquete python paquetes "python" "2.7"
  #paquete python paquetes "python" "3.9"
  #paquete rsync
  paquete samba paquetes "ldb samba tevent"
  #paquete sqlite3
  paquete tiff
  #paquete unrar
  #paquete wavpack
  #paquete webkitgtk41
  #paquete zsh

  ###  
  # Recompilados de estable que usan xlocale (y pueden cerrar fallas)
  # No deben estar en mystuff
  paquete curl

  paquete php paquetes "php php-bz2 php-curl php-gd php-intl php-ldap php-mcrypt php-mysqli php-pdo_pgsql php-pgsql php-zip" 8.2

  ###
  # Recompilados para mejorar dependencias y actualizar

  #paquete libidn2

  #FLAVOR=light paquete evince paquetes evince-light
  #paquete gcc paquetes "gcc" 4.9
  #paquete git paquetes "git"
  #paquete p7zip paquetes "p7zip p7zip-rar"
  #paquete pidgin paquetes "libpurple pidgin"
  #paquete webkit paquetes "webkit webkit-gtk3"
  # FLAVOR=gtk3 make paquete webkit-gtk3
  #FLAVOR=python3 paquete py-gobject3 paquetes py3-gobject3
  #paquete py-gobject3 paquetes py-gobject3


  #Por reubicar

  ##
  # Nueva revisión para operar con librerías retroportadas o actualizadas
  # Deben estar en arbodes/usr/ports/mystuff
  #paquete libreoffice paquetes "libreoffice libreoffice-i18n-es"

  ####
  # Modificados para que usen xlocale (pueden cerrar fallas)
  # Estan en mystuff
  paquete glib2
  paquete libunistring
  paquete vlc

  ##
  # Retroportados no existentes en versión actual

  paquete security/veracrypt

  ####
  # Adaptados de portes estables pero mejorados para adJ, por 
  # ejemplo ordenamientos en español deben ser correctos.
  # Deben estar en arboldes/usr/ports/mystuff 
  paquete xfe
  paquete colorls
  paquete editors/hexedit # Soporta tamaños de archivos más grandes

  ####
  # Unicos en adJ 
  # Deben estar en arboldes/usr/ports/mystuff pero no en /usr/ports
  paquete net/ton
  paquete net/ton-toncli
  paquete emulators/realboy
  #paquete net/xmrig
  #paquete sysutils/ganglia
  paquete textproc/sword
  paquete textproc/bibletime
  paquete textproc/po4a

  ####
  # Unicos en adJ liderados por pdJ
  # Deben estar en arboldes/usr/ports/mystuff 
  paquete books/evangelios_dp
  paquete books/basico_adJ
  paquete books/usuario_adJ
  paquete books/servidor_adJ
  paquete education/AnimalesI
  paquete education/AprestamientoI
  paquete education/PlantasCursiva
  paquete education/NombresCursiva
  paquete fonts/TiposLectoEscritura
  paquete education/asigna
  #paquete textproc/markup  --fuentes ya no existen
  #paquete education/repasa -- dependia de markup
  #paquete education/sigue -- dependía de repasa
  paquete textproc/Mt77

  #paquete databases/sivel sivel sivel 1.2
  paquete databases/sivel sivel sivel 2.0

  rm $dini/$V$VESP-$ARQ/$dest/php5-gd-*-no_x11.tgz > /dev/null 2>&1

} fi;  

echo " *> Copiar otros paquetes de repositorio de OpenBSD" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn="$autoMasPaquetes"
} fi;


cd $dini
echo "$paraexc" | tr " " "\n" | grep -v "^[ \t]*$" | sed -e "s/^/ /g" > tmp/excluye.txt
cmd="echo \$excluye | tr \" \" \"\\n\" | sed -e \"s/^/ /g\" >> tmp/excluye.txt"
eval "$cmd"
if (test "$sn" = "s") then {
  mkdir -p $V$VESP-$ARQ/paquetes
  cp -rf arboldvd/* $V$VESP-$ARQ/
  find $V$VESP-$ARQ/ -name CVS | xargs rm -rf

  arcdis="tmp/disponibles.txt";
  arcdis2="tmp/disponibles2.txt";

  echo "Extrayendo paquetes de $PKG_PATH"

  pftp=`echo $PKG_PATH | sed -e "s/^ftp:.*/ftp/g;s/^http:.*/http/g"`;
  echo pftp $pftp

  if (test ! -f "$arcdis") then {
    echo "Obteniendo lista de paquetes disponibles de $PKG_PATH" | tee -a /var/www/tmp/distrib-adJ.bitacora;
    if (test "$pftp" = "ftp") then {
      cmd="echo \"ls\" | ftp $PKG_PATH > /tmp/actu2-l"
    } elif (test "$pftp" = "http") then {
    cmd="ftp -o /tmp/actu2-l $PKG_PATH"
  } else {
  cmd="ls $PKG_PATH > /tmp/actu2-l";
} fi;
echo $cmd; eval $cmd;
cmd="grep -a \".tgz\" /tmp/actu2-l | sort "
if (test "$autoMasPaquetesInv" = "s") then {
  cmd="$cmd -r ";
} fi;
cmd="$cmd > /tmp/actu2-g"
echo $cmd; eval $cmd;
cmd="sed -e \"s/.*[^_A-Za-z0-9.@+-]\([A-Za-z0-9.-][_A-Za-z0-9.@+-_]*.tgz\).*/\1 /g\" /tmp/actu2-g > /tmp/actu2-s"
echo $cmd; eval $cmd;
if (test "$excluye" != "") then {
  cmd="grep -v -f tmp/excluye.txt /tmp/actu2-s > $arcdis";
} else {
  cmd="cp /tmp/actu2-s $arcdis";
} fi;
echo $cmd; eval $cmd;

if (test ! -s "$arcdis") then {
  echo "No pudo obtenerse lista (asegurese de terminar ruta con /)";
  exit 1;
    } fi;
  } else  {
    echo "Usando lista de disponibles de $arcdis" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  } fi;

  disp=`cat $arcdis`;

  tr " " "\\n" < $arcdis > $arcdis2

  echo "Buscando paquetes sobrantes con respecto a Contenido.txt" | tee -a /var/www/tmp/distrib-adJ.bitacora
  inv=""
  if (test "$autoMasPaquetesInv" = "s") then {
    inv="-r"
  } fi;
  grep ".-\[v\]" Contenido.txt | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[0-9][0-9alphabetcdfgnmpruvSTABLERC._+]*\1.tgz/g" | sort $inv > tmp/esperados.txt
  ne=`(ls $V$VESP-$ARQ/paquetes/ ; ls $V$VESP-$ARQ/sivel/*tgz) | grep -v -f tmp/esperados.txt`;
  if (test "$ne" != "") then {
    echo "Los siguientes paquetes presentes en el directorio $V$VESP-$ARQ/paquetes no están entre los esperados:" | tee -a /var/www/tmp/distrib-adJ.bitacora;
    echo $ne | tee -a /var/www/tmp/distrib-adJ.bitacora;
    echo -n "[ENTER] para continuar: ";
    read;
  } fi;

  echo "Buscando repetidos con respecto a Contenido.txt" | tee -a /var/www/tmp/distrib-adJ.bitacora
  m=""
  (cd $V$VESP-$ARQ/paquetes; ls ../sivel/*tgz; ls > /tmp/actu2-l)
  for i in `cat tmp/esperados.txt`; do
    n=`grep "^$i" /tmp/actu2-l | wc -l | sed -e "s/ //g"`;
    if (test "$n" -gt "1") then {
      m="enter";
      echo -n "$i $n: "
      echo `grep "^$i" /tmp/actu2-l`;
    } fi;
  done

  if (test "$m" = "enter") then {
    echo "Presione [ENTER] para continuar";
    read;
  } fi;

  rm -f tmp/poract.txt
  t=0;
  for i in `cat tmp/esperados.txt`; do 
    cmd="grep \"^$i\" $arcdis2 | tail -n 1";
    p=`grep "^$i" $arcdis2 | tail -n 1`; 
    echo -n "($p)"
    da=`ls $V$VESP-$ARQ/paquetes/ | grep "^$i"`
    echo -n " -> $p"; 
    e=`grep "^$i" tmp/excluye.txt | tail -n 1`;
    echo " $e"; 
    if (test "$da" = "" -a "$p" != "$e" -a "X$p" != "X") then {
      echo $p >> tmp/poract.txt
      t=1;
    } fi;
  done

  if (test "$t" = "1") then {
    pa=`cat tmp/poract.txt | grep . | tr "\n" "," | sed -e "s/,$//g"`
    if (test "$pftp" = "ftp" -o "$pftp" = "http") then {
      cmd="(cd $V$VESP-$ARQ/paquetes; ftp $PKG_PATH/{$pa} )"
    } else {
      echo $pa | grep "," > /dev/null
      if (test "$?" = "0") then {
        cmd="cp $PKG_PATH/{$pa} $V$VESP-$ARQ/paquetes"
      } else {
        cmd="cp $PKG_PATH/$pa $V$VESP-$ARQ/paquetes"
      } fi;
    } fi;
    echo $cmd;
    eval $cmd;
  } else {
    echo "Nada por actualizar";
  } fi;

  echo "Buscando faltantes con respecto a Contenido.txt" | tee -a /var/www/tmp/distrib-adJ.bitacora
  m=""
  (cd $V$VESP-$ARQ/paquetes; ls > /tmp/actu2-l)
  for i in `cat tmp/esperados.txt`; do  
    n=`grep "^$i" /tmp/actu2-l | wc -l | sed -e "s/ //g"`; 
    if (test "$n" = "0") then {
      echo "$i"
    } fi; 
  done

} fi;

echo " *> Preparar site$VP.tgz" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn="$autoSite"
} fi;


if (test "$sn" = "s") then {
  #Asegurar versiones 
  grep "rsync-adJ $V" arboldd/usr/local/bin/rsync-adJ > /dev/null
  if (test "$?" = "0") then {
    ed arboldd/usr/local/bin/rsync-adJ <<EOF
,s/rsync-adJ $V/rsync-adJ $VS/g
w
q
EOF
  } fi;
  grep "actbase.sh $V" arboldvd/util/actbase.sh > /dev/null
  if (test "$?" = "0") then {
    ed arboldvd/util/actbase.sh <<EOF
,s/actbase.sh $V/actbase.sh $VS/g
w
q
EOF
  } fi;
  mkdir -p /tmp/i
  rm -rf /tmp/i/*
  mkdir -p /tmp/i/usr/local/adJ/
  cp -rf $dini/arboldd/* /tmp/i/
  find /tmp/i -name "*~" | xargs rm 
  cp $dini/arboldd/usr/local/adJ/inst.sh /tmp/i/inst-adJ.sh
  mkdir -p /tmp/i/usr/src/etc/
  cp /usr/src/etc/Makefile  /tmp/i/usr/src/etc/
  for i in `cat $dini/lista-site`; do 
    if (test -d "/$D_DESTDIR/$i" -o -d "$i") then {
      mkdir -p /tmp/i/$i
    } elif (test -f "/$D_DESTDIR/$i") then {
      d=`dirname $i`
      mkdir -p /tmp/i/$d
      cp /$D_DESTDIR/$i /tmp/i/$i
    } else {
      echo "lista-site errada, falta $i en /$D_DESTDIR, intentando de /";
      mkdir -p /tmp/i/`dirname $i`; 
      cp -f /$i /tmp/i/$i  
    } fi;
  done;
  mkdir -p /tmp/i/etc/
  d=`pwd`
  (cd /tmp/i ; tar cvfz $d/$V$VESP-$ARQ/site$VP.tgz .)
} fi;

echo " *> Crear Contenido.txt" | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
  echo -n "(s/n)? "
  read sn
}
else {
  sn="$autoTextos"
} fi;


if (test "$sn" = "s") then {
  echo "s/\[V\]/$V/g"  > tmp/rempCont.sed
  for i in `grep ".-\[v\]" Contenido.txt | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[v]\1/g"`; do
    n=`echo $i | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[0-9][0-9alphabetcdfgruvSTABLERC._+]*\1.tgz/g"`
    d=`(cd $V$VESP-$ARQ/paquetes; ls | grep "^$n"; cd ../sivel; ls | grep "^$n" 2>/dev/null | tail -n 1)`
    e=`echo $d | sed -e 's/.tgz//g'`;
    ic=`echo $i | sed -e 's/\[v\]/\\\\[v\\\\]/g'`;
    echo "s/^$ic/$e/g" >> tmp/rempCont.sed
  done;

  sed -f tmp/rempCont.sed Contenido.txt > $V$VESP-$ARQ/Contenido.txt

echo " *> Revisando faltantes con respecto a Contenido.txt" | tee -a /var/www/tmp/distrib-adJ.bitacora;
  l=`(cd $V$VESP-$ARQ/paquetes; ls *tgz)`
  for i in $l; do 
    n=`echo $i | sed -e "s/-[0-9].*//g"`; 
    grep $n Contenido.txt > /dev/null ; 
    if (test "$?" != "0") then { 
      echo "En Contenido.txt falta $n"; 
    } fi; 
  done
  echo " *> Copiando otros textos";
  if (test -f Actualiza.md) then {
    cp Actualiza.md $V$VESP-$ARQ/
  } fi;
  if (test -f Dedicatoria.md) then {
    cp Dedicatoria.md $V$VESP-$ARQ/
  } fi;
  if (test -f Derechos.md) then {
    cp Derechos.md $V$VESP-$ARQ/
  } fi;
  if (test -f Novedades.md) then {
    echo "*** Novedades" | tee -a /var/www/tmp/distrib-adJ.bitacora;
    cp Novedades.md $V$VESP-$ARQ/
  } fi;
  if (test -f Novedades_OpenBSD.md) then {
    echo "*** Novedades_OpenBSD" | tee -a /var/www/tmp/distrib-adJ.bitacora;
    cp Novedades_OpenBSD.md $V$VESP-$ARQ/
  } fi;
} fi;

echo "** Generando semilla de aleatoreidad" | tee -a /var/www/tmp/distrib-adJ.bitacora
# https://github.com/yellowman/flashrd/issues/17
touch $V$VESP-$ARQ/etc/random.seed
chmod 600 $V$VESP-$ARQ/etc/random.seed
dd if=/dev/random of=$V$VESP-$ARQ/etc/random.seed bs=512 count=1 2>&1 | tee -a /var/www/tmp/distrib-adJ.bitacora

echo "** Verificando que kernel de instalador sea adJ"| tee -a /var/www/tmp/distrib-adJ.bitacora
grep APRENDIENDO $V$VESP-$ARQ/bsd > /dev/null 2>&1
if (test "$?" != "0") then {
  echo "No se ve adJ en instalador $V$VESP-$ARQ/bsd";
  exit 1;
} fi;
grep APRENDIENDO $V$VESP-$ARQ/bsd.mp > /dev/null 2>&1
if (test "$?" != "0") then {
  echo "No se ve adJ en instalador $V$VESP-$ARQ/bsd.mp";
  exit 1;
} fi;

echo "** Generando suma sha256" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test ! -f /etc/signify/adJ-$VP-base.sec) then {
  echo "*** Falta llave /etc/signify/adJ-$VP-base.sec, generarla de forma análoga a la de paquetes";
  exit 1;
} fi;
if (test ! -f $V$VESP-$ARQ/INSTALL.amd64) then {
  echo "*** Falta $V$VESP-$ARQ/INSTALL.amd64 que será examinado al instalar";
  exit 1;
} fi;
cmd="find $V$VESP-$ARQ  -name \"*~\" -exec rm {} ';'"
echo $cmd;
eval $cmd;
rm $V$VESP-$ARQ/SHA256*
l=`(cd $V$VESP-$ARQ; ls *tgz INSTALL.amd64 bsd* cd*)`;
cmd="(cd $V$VESP-$ARQ; cksum -a sha256 $l >  SHA256; signify -S -e -s /etc/signify/adJ-$VP-base.sec -x SHA256.sig -m SHA256)";
echo $cmd;
eval $cmd;
cmd="find $V$VESP-$ARQ  -exec touch {} ';'"
echo $cmd;
eval $cmd;
cmd="(cd $V$VESP-$ARQ; ls -l | grep -v index.txt > index.txt)"
echo $cmd;
eval $cmd;
