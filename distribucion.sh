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
		echo "Este archivo de comandos es controlado por ver.sh, por favor editelo y vuelva a ejecutar"
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
vardef RELEASEDIR $RELEASEDIR
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
if (test ! -d /usr/src/sys) then {
	echo "Se requieren fuentes del kernel en /usr/src/sys";
} fi;
if (test ! -d $XSRCDIR) then {
	echo "Se requieren fuentes de Xorg 4 en $XSRCDIR";
} fi;
if (test ! -d /usr/obj) then {
	die "Se requiere directorio para compilar sistema base y kernel: /usr/obj";
} fi;

narq=`uname -m`

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
	} else {
		cd /usr/src
	} fi;
	if (test ! -f CVS/Root) then {
		for i in `find . -name CVS`; do 
			echo $i;
			echo "$ANONCVS" > $i/Root;
		done;
	} fi;
	cvs -z3 update -Pd -r$R
	if (test -d /usr/src$VP-orig/) then {
		rsync -ravzp --delete /usr/src$VP-orig/* /usr/src/
	} fi;
	if (test -d /usr/src$VP-orig/) then {
		cd /usr/src$VP-orig/sys
	} else {
		cd /usr/src/sys
	} fi;
	if (test ! -f CVS/Root) then {
		for i in `find . -name CVS`; do 
			echo $i;
			echo "$ANONCVS" > $i/Root;
		done;
	} fi;
	cvs -z3 update -Pd -r$R
	if (test -d /usr/src$VP-orig/) then {
		rsync -ravzp --delete /usr/src$VP-orig/sys/* /usr/src/sys/
	} fi;
	if (test -d /usr/xenocara$VP-orig/) then {
		cd /usr/xenocara$VP-orig/sys
	} else {
		cd $XSRCDIR
	} fi;
	if (test ! -f CVS/Root) then {
		for i in `find . -name CVS`; do 
			echo $i;
			echo "$ANONCVS" > $i/Root;
		done;
	} fi;
	cvs -z3 update -Pd -r$R
	if (test -d /usr/xenocara$VP-orig/) then {
		rsync -ravzp --delete /usr/xenocara$VP-orig/* $XSRCDIR
	} fi;
	if (test -d /usr/ports$VP-orig/) then {
		cd /usr/ports$VP-orig/
	} else {
		cd /usr/ports/
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
	cvs -z3 update -Pd -r$R
	if (test -d /usr/ports$VP-orig/) then {
		rsync -ravzp /usr/ports$VP-orig/* /usr/ports
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

	cd /usr/src/sys
	$dini/hdes/servicio-kernel.sh	
	# Esta en general se cambiaron comentarios a lo largo de todas
    # las fuentes.  Ver documentación en 
    # http://aprendiendo.pasosdejesus.org/?id=Renombrando+Daemon+por+Service

	# Para compilar vmstat
	cp /usr/src/sys/uvm/uvm_extern.h /usr/include/uvm/

	cd /usr/src/sys/arch/$ARQ/conf
	sed -e "s/^#\(option.*NTFS.*\)/\1/g" GENERIC > APRENDIENDODEJESUS
	rm -rf /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS/*
	config APRENDIENDODEJESUS
	cd ../compile/APRENDIENDODEJESUS
	rm .depend
	make clean 
	make -j4
	cp /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS/bsd $dini/$V$VESP-$ARQ/bsd
	cd /usr/src/sys/arch/$ARQ/conf
	sed -e "s/GENERIC/APRENDIENDODEJESUS/g" GENERIC.MP > APRENDIENDODEJESUS.MP
	rm -rf /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/*
	config APRENDIENDODEJESUS.MP
	cd ../compile/APRENDIENDODEJESUS.MP
	rm .depend
	make clean 
	make -j4
	cp /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/bsd $dini/$V$VESP-$ARQ/bsd.mp

} fi;

echo " *> Instalar kernel recien compilado" | tee -a /var/www/tmp/distrib-adJ.bitacora
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
	cd /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP
	make install
	echo "Debe reiniciar sistema para iniciar kernel mp (si prefiere el que es para un procesador simple instalelo manualmente)..." | tee -a /var/www/tmp/distrib-adJ.bitacora
#/	exit 0;
} fi;


function compilabase 	{
	cd /usr/src/sbin/wsconsctl && if (test ! -f obj/keysym.h) then { make keysym.h; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.bin/compile_et && if (test ! -f obj/error_table.h) then { make error_table.h; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.bin/tic && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make  | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.bin/infocmp && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make  | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.bin/sudo/lib && if (test ! -f obj/gram.c) then { make gram.h; } fi && cd .. && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.bin/tset && if (test ! -f obj/termsort.c) then { make termsort.c; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.sbin/rpc.statd && if (test ! -f obj/sm_inter.h) then { make sm_inter.h; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.sbin/afs/usr.sbin/ydr && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/usr.sbin/afs/lib/libarla && if (test ! -f obj/fs.h) then { make fs.h; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/gnu/usr.bin/cc/libcpp && if (test ! -f obj/localedir.h) then { make localedir.h; } fi && make | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/lib/libiberty/ && make depend -f Makefile.bsd-wrapper depend && make -f Makefile.bsd-wrapper | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/gnu/usr.bin/cc/libobjc && make depend | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/gnu/lib/libiberty/ && make -f Makefile.bsd-wrapper config.status | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/kerberosV/usr.sbin/kadmin/ && make kadmin-commands.h | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/kerberosV/usr.sbin/ktutil/ && make ktutil-commands.h | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/kerberosV/lib/libasn1 && make rfc2459_asn1.h && make rfc2459_asn1-priv.h && make cms_asn1.h && make cms_asn1-priv.h && make krb5_asn1-priv.h && make  digest_asn1-priv.h | tee -a /var/www/tmp/distrib-adJ.bitacora
	#find /usr/obj -name ".depend" -exec rm {} ';'
	DT=$DESTDIR
	unset DESTDIR 
	echo "whoami 1" >> /var/www/tmp/distrib-adJ.bitacora
	whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
	cd /usr/src && make -j4 | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "whoami 1" >> /var/www/tmp/distrib-adJ.bitacora
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
	mkdir -p /tmp/tz
	rm -rf /tmp/tz/*
	cd /tmp/tz
	ftp ftp://ftp.iana.org/tz/tzdata-latest.tar.gz
	mkdir datfiles
	cd datfiles
	tar xvfz ../tzdata-latest.tar.gz
	cp -rf * /usr/src/share/zoneinfo/datfiles/
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
		rm -rf /usr/obj/*
	} fi;
	echo "Esta operacion modificar tanto las fuentes en /usr como archivos en /etc e /include del sistema donde se emplea para hacer posible la compilación;"
	rm -f ${DESTDIR}/usr/include/g++ 
	mkdir -p ${DESTDIR}/usr/include/g++
	#export CFLAGS=-I/usr/include/g++/${ARQ}-unknown-openbsd${V}/
	# Aplicando parches sobre las fuentes de OpenBSD sin cambios para
	# facilitar aportar  a OpenBSD con prioridad cambios que posiblemente
	# serán aceptados más facilmente
	(cd $dini/arboldes/usr/src; for i in *patch; do echo $i; if (test ! -f /usr/src/$i) then { cp $i /usr/src; (cd /usr/src; echo "A mano"; patch -p1 < $i;) } fi; done) |  tee -a  /var/www/tmp/distrib-adJ.bitacora

	echo "* Copiando archivos nuevos en /usr/src" | tee -a /var/www/tmp/distrib-adJ.bitacora
	(cd $dini/arboldes/usr/src ; for i in `find . -type f | grep -v CVS | grep -v .patch`; do  if (test ! -f /usr/src/$i) then { echo $i; n=`dirname $i`; mkdir -p /usr/src/$n; cp $i /usr/src/$i; } fi; done )
	echo "* Cambiando /etc " | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /etc
	$dini/arboldd/usr/local/adJ/servicio-etc.sh | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "* Cambiando /usr/src/etc" | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/etc
	$dini/arboldd/usr/local/adJ/servicio-etc.sh | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "* Cambios iniciales a /usr/src" | tee -a /var/www/tmp/distrib-adJ.bitacora
	cd /usr/src/
	$dini/hdes/servicio-base.sh | tee -a /var/www/tmp/distrib-adJ.bitacora
	grep LOG_SERVICE  /usr/include/syslog.h > /dev/null 2>&1
	if (test "$?" != "0") then {
		echo "* Cambiando /usr/src/sys" | tee -a /var/www/tmp/distrib-adJ.bitacora
		cd /usr/src/sys
		$dini/hdes/servicio-kernel.sh | tee -a /var/www/tmp/distrib-adJ.bitacora	
	} fi;
	# usar llaves de adJ en lugar de las de OpenBSD
	grep "signfiy\/adJ" /usr/src/usr.sbin/sysmerge/sysmerge.sh > /dev/null 2>&1
	if (test "$?" != "0") then {
		cp /usr/src/usr.sbin/sysmerge/sysmerge.sh /usr/src/usr.sbin/sysmerge/sysmerge.sh.orig
		sed -e 's/signify\/openbsd/signify\/adJ/g' /usr/src/usr.sbin/sysmerge/sysmerge.sh.orig > /usr/src/usr.sbin/sysmerge/sysmerge.sh
	} fi;
	cd /usr/src && make obj
	echo "* Completo make obj" | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "whoami 2" >>  /var/www/tmp/distrib-adJ.bitacora
	whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
	cd /usr/src/etc && env DESTDIR=/ make distrib-dirs
	echo "whoami 2" >> /var/www/tmp/distrib-adJ.bitacora
	whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
	echo "* Completo make distrib-dirs" | tee -a /var/www/tmp/distrib-adJ.bitacora
	#cd /usr/src/etc && env DESTDIR=$DESTDIR make distrib-dirs
	# Algunos necesarios para que make lo logre
	cd /usr/src/include
	make includes
	compilabase
	echo "* Completo compilabase" | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "whoami 3" >> /var/www/tmp/distrib-adJ.bitacora
	whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
	cd /usr/src && unset DESTDIR && LANG=POSIX nice make -j4 SUDO=doas build | tee -a /var/www/tmp/distrib-adJ.bitacora
	echo "whoami 3" >> /var/www/tmp/distrib-adJ.bitacora
	whoami >> /var/www/tmp/distrib-adJ.bitacora 2>&1
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
		cp $a $a.antestrad
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


#	cd /usr/src/distrib/crunch && make obj depend \ && make all install
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
	mkdir -p ${DESTDIR} ${RELEASEDIR}
	ed /usr/src/etc/Makefile << EOF
/^LOCALTIME=
s/Canada\/Mountain/America\/Bogota/g
w
q
EOF
	#compilabase
	echo "DESTDIR=$DESTDIR" | tee -a /var/www/tmp/distrib-adJ.bitacora;
	cd /usr/src/etc && DESTDIR=/destdir nice make release | tee -a /var/www/tmp/distrib-adJ.bitacora;
	find $DESTDIR  -exec touch {} ';'
	find $RELEASEIR  -exec touch {} ';'
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

	mkdir -p ${DESTDIR}/usr/include
	cp -rf /usr/include/* ${DESTDIR}/usr/include/
	mkdir -p ${DESTDIR}/usr/lib
	cp -rf /usr/lib/crt* ${DESTDIR}/usr/lib/
	if (test "$XSRCDIR" != "/usr/xenocara") then {
		ln -s $XSRCDIR /usr/xenocara;
	} fi;
	cd $XSRCDIR

	echo "* Aplicando parches en /usr/xenocara/" | tee -a /var/www/tmp/distrib-adJ.bitacora
	(cd $dini/arboldes/usr/xenocara/; for i in *patch; do echo $i; if (test ! -f /usr/xenocara/$i) then { cp $i /usr/xenocara/; (cd /usr/xenocara/; echo "A mano"; patch -p1 < $i;) } fi; done) |  tee -a  /var/www/tmp/distrib-adJ.bitacora
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
	make build
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
	
	rm -f /usr/src/distrib/miniroot/install-es.sh
	ln -s $dini/tminiroot/install-es.sh /usr/src/distrib/miniroot/install-es.sh
	rm -f /usr/src/distrib/miniroot/install-es.sub
	ln -s $dini/tminiroot/install-es.sub /usr/src/distrib/miniroot/install-es.sub
	rm -f /usr/src/distrib/miniroot/upgrade-es.sh
	ln -s $dini/tminiroot/upgrade-es.sh /usr/src/distrib/miniroot/upgrade-es.sh
	rm -f /usr/src/distrib/amd64/common/install-es.md
	ln -s $dini/tminiroot/install-amd64-es.md /usr/src/distrib/amd64/common/install-es.md
	rm -f /usr/src/distrib/i386/common/install-es.md
	ln -s $dini/tminiroot/install-i386-es.md /usr/src/distrib/i386/common/install-es.md
	verleng /usr/src/distrib/miniroot/list 
	verleng /usr/src/distrib/amd64/common/list 
	verleng /usr/src/distrib/i386/common/list 

	cp /etc/signify/adJ-*pub /destdir/etc/signify/
	cp /usr/src/distrib/ramdisk/list /tmp/ramdisk_list
	cp /usr/src/distrib/amd64/common/list /tmp/common_list
	sed -e 's/signify\/openbsd/signify\/adJ/g' /tmp/ramdisk_list > /usr/src/distrib/ramdisk/list 
	sed -e 's/signify\/openbsd/signify\/adJ/g' /tmp/common_list > /usr/src/distrib/amd64/common/list

	cd /usr/src/distrib/special/libstubs
	make
	cd /usr/src/sys/arch/$ARQ/stand/cdbr
	make clean
	cd ..
	make
	DESTDIR=/destdir make install
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


	cp /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS/bsd ${RELEASEDIR}/bsd
	cp /usr/src/sys/arch/$ARQ/compile/APRENDIENDODEJESUS.MP/bsd ${RELEASEDIR}/bsd.mp
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
	echo $nom | grep "\/" > /dev/null 2>&1
	if (test "$?" = "0") then {
		# categoria va con nombre para paquetes en mystuff
		cat=`echo $nom | sed -e "s/\/.*//g"`
		d1="$nom"
		if (test "$subd" != "") then {
			d1="$d1/$subd"
		} fi;
		nom=`echo $nom | sed -e "s/.*\///g"`
	} else {
		l=`grep "^$nom-[0-9]" /usr/ports/INDEX | head -n 1`
		if (test "$l" = "") then {
			echo "Desconocido $nom en /usr/ports/INDEX"
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
	if (test -d "/usr/ports/mystuff/$d1/") then {
		dir="/usr/ports/mystuff/$d1/"
	} else {
		dir="/usr/ports/$d1/"
	} fi;
	if (test ! -d "$dir") then {
		echo "No es directorio $dir";
		exit 1;
	} fi;
	echo "*> Creando paquete $nom:$cat pasando a $dir" | tee -a /var/www/tmp/distrib-adJ.bitacora;
	if (test "$PAQ_LIMPIA_PRIMERO" != "") then {
		(cd "$dir" ; make clean; rm /usr/ports/packages/$ARQ/all/$nom-[0-9][0-9a-z.]*.tgz)
	} fi;
	echo "*> Compila" | tee -a /var/www/tmp/distrib-adJ.bitacora;
	(cd "$dir" ; make -j4 package)
	if (test ! -f /etc/signify/adJ-$VP-pkg.sec) then {
		echo "No hay llave privada /etc/signify/adJ-$VP-pkg.sec";
		echo "Si no lo ha hecho con signify -G -c \"Firma adJ $V para paquetes\" -n -s /etc/signify/adJ-$VP-pkg.sec -p /etc/signify/adJ-$VP-pkg.pub"
		exit 1;
	} fi;
	echo "*> Copia $copiar" | tee -a /var/www/tmp/distrib-adJ.bitacora;
	if (test "$copiar" = "") then {
#		if (test "$subd" != "") {
			f1=`ls /usr/ports/packages/$ARQ/all/$nom-$subd[-0-9][0-9a-z.]*.tgz | head -n 1`
			f2=`ls $dini/$V$VESP-$ARQ/$dest/$nom-$subd[-0-9][0-9a-z.]*.tgz | head -n 1`
#		} else {
#			f1=`ls /usr/ports/packages/$ARQ/all/$nom[-0-9][0-9a-z.]*.tgz | head -n 1`
#			f2=`ls $dini/$V$VESP-$ARQ/$dest/$nom[-0-9][0-9a-z.]*.tgz | head -n 1`
#		} fi;
		echo "*> simple f1=$f1, f2=$f2, subd=$subd " | tee -a /var/www/tmp/distrib-adJ.bitacora;
		if (test ! -f "$f2" -o "$f2" -ot "$f1") then {
			echo "*> Firmando y copiando /usr/ports/packages/$ARQ/all/$nom-*.tgz" | tee -a /var/www/tmp/distrib-adJ.bitacora
			cmd="rm -f $dini/$V$VESP-$ARQ/$dest/$nom-[0-9][0-9a-z.]*.tgz"
			echo "cmd=$cmd";
			eval "$cmd";
			cmd="pkg_sign -v -o $dini/$V$VESP-$ARQ/$dest/ -s signify -s /etc/signify/adJ-$VP-pkg.sec /usr/ports/packages/$ARQ/all/$nom*.tgz"
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
				cmd="pkg_sign -v -o $dini/$V$VESP-$ARQ/$dest/ -s signify -s /etc/signify/adJ-$VP-pkg.sec /usr/ports/packages/$ARQ/all/$i*.tgz"
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

echo " *> Compilar todos los paquetes de Conteniod.txt en $dini/$V$VESP-$ARQ/paquetes " | tee -a /var/www/tmp/distrib-adJ.bitacora;
if (test "$inter" = "-i") then {
	echo -n "(s/n)? "
	read sn
}
else {
	sn=$autoTodosPaquetes
} fi;
echo $sn
if (test "$sn" = "s") then {
  #PAQ_LIMPIA_PRIMERO=1
  #paquete webkit-gtk3
  #exit 1;
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


	####
	# Retroportados de versión ste o current para cerrar fallas o actualizar
	# Deben estar en arboldes/usr/ports/mystuff y en /usr/ports de current
	paquete postgresql-client paquetes "postgresql-server postgresql-client postgresql-contrib postgresql-docs" 
	#paquete chromium
	#paquete node 
	#paquete ruby paquetes "ruby ruby23-ri_docs" 2.3

	# Requeridos para operar con postgresql retroportado
	paquete gdal	

	####
	# Recompilados para cerrar fallas, portes actualizados de OpenBSD estable
	
	# Para que operen bien basta actualizar CVS de /usr/ports 
	# Los siguientes no deben estar en arboldes/usr/ports/mystuff
	#paquete a2ps
	#paquete cups-filters
	#paquete gnutls
	#paquete jasper
	#paquete libxml
	#paquete mariadb-client paquetes "mariadb-client mariadb-server" 
	#paquete net-snmp
	#paquete owncloud
	#paquete p5-Mail-SpamAssassin
	#paquete png
	#paquete postgis
	#paquete postgresql-client paquetes "postgresql-server postgresql-client postgresql-contrib postgresql-docs" 
	#paquete qemu

	#paquete webkit paquetes "webkit webkit-gtk3"
	# FLAVOR=gtk3 make paquete webkit-gtk3

	####
	# Recompilados de estable que usan xlocale (y pueden cerrar fallas)
	# No deben estar en mystuff
	#paquete boost
	#paquete djvulibre
	#paquete gettext-tools
	#paquete ggrep
	#paquete gdk-pixbuf
	#paquete glib2
	#paquete gtar
	#paquete libidn
	#paquete libunistring
	#paquete libxslt
	#paquete llvm
	#paquete scribus
	#paquete vlc
	#paquete wget
	#paquete wxWidgets-gtk2

	####
	# Tomados de portes de OpenBSD 5.9 pero mejorados para adJ
	# Deben estar en arboldes/usr/ports/mystuff 
	#paquete xfe

	###
        # Actualizados.  Están desactualizado en OpenBSD estable y current
	#paquete php paquetes "php php-bz2 php-curl php-fpm php-gd php-intl php-ldap php-mcrypt php-mysqli- php-pdo_pgsql php-pgsql php-zip" 5.6
	paquete pear-Auth
	paquete pear-DB_DataObject
       		
	####
	# Unicos en adJ 
	# Deben estar en arboldes/usr/ports/mystuff pero no en /usr/ports
	paquete editors/hexedit # Soporta tamaños de archivos más grandes
	paquete emulators/realboy
	paquete lang/ocaml-labltk
	paquete sysutils/ganglia
	paquete textproc/sword
	paquete textproc/xiphos
	paquete www/pear-HTML-Common
	paquete www/pear-HTML-Common2
	paquete www/pear-HTML-CSS
	paquete www/pear-HTML-Javascript
	paquete www/pear-HTML-Menu
	paquete www/pear-HTML-QuickForm
	paquete www/pear-HTML-Table
	paquete www/pear-DB-DataObject-FormBuilder
	paquete www/pear-HTML-QuickForm-Controller
	paquete x11/fbdesk
	#paquete devel/ruby-apacheconf_parser paquetes "ruby21-apacheconf-parser"

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
	paquete textproc/markup
	paquete education/repasa
	paquete education/sigue
	paquete textproc/Mt77

	paquete databases/sivel sivel sivel 1.2
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
	grep ".-\[v\]" Contenido.txt | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[0-9][0-9alphabetcdgprvSTABLERC._]*\1.tgz/g" | sort $inv > tmp/esperados.txt
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
		if (test -d "/destdir/$i" -o -d "$i") then {
			mkdir -p /tmp/i/$i
		} elif (test -f "/destdir/$i") then {
			d=`dirname $i`
			mkdir -p /tmp/i/$d
			cp /destdir/$i /tmp/i/$i
		} else {
			echo "lista-site errada, falta $i en /destdir, intentando de /";
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
		n=`echo $i | sed -e "s/-\[v\]\([-a-zA-Z_0-9]*\).*/-[0-9][0-9alphabetcdgrv._]*\1.tgz/g"`
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
	if (test -f Actualiza.txt) then {
		cp Actualiza.txt $V$VESP-$ARQ/Actualiza.txt 
	} fi;
	if (test -f Dedicatoria.txt) then {
		cp Dedicatoria.txt $V$VESP-$ARQ/Dedicatoria.txt
	} fi;
	if (test -f Derechos.txt) then {
		cp Derechos.txt $V$VESP-$ARQ/Derechos.txt
	} fi;
	if (test -f Novedades.ewiki) then {
		echo "*** De Ewiki a Texto" | tee -a /var/www/tmp/distrib-adJ.bitacora
		awk -f hdes/ewikiAtexto.awk Novedades.ewiki > tmp/Novedades.txt
		#recode latin1..utf8 tmp/Novedades.txt
	} fi;
	if (test -f tmp/Novedades.txt) then {
		echo "*** Novedades" | tee -a /var/www/tmp/distrib-adJ.bitacora;
		cp tmp/Novedades.txt $V$VESP-$ARQ/Novedades.txt
	} fi;
} fi;

echo "** Generando semilla de aleatoreidad" | tee -a /var/www/tmp/distrib-adJ.bitacora
# https://github.com/yellowman/flashrd/issues/17
touch $V$VESP-$ARQ/etc/random.seed
chmod 600 $V$VESP-$ARQ/etc/random.seed
dd if=/dev/random of=$V$VESP-$ARQ/etc/random.seed bs=512 count=1 | tee -a /var/www/tmp/distrib-adJ.bitacora


echo "** Generando suma sha256" | tee -a /var/www/tmp/distrib-adJ.bitacora
if (test ! -f /etc/signify/adJ-$VP-base.sec) then {
	echo "*** Falta llave /etc/signify/adJ-$VP-base.sec, generarla de forma análoga a la de paquetes";
	exit 1;
} fi;
if (test ! -f $V$VESP-$ARQ/INSTALL.amd64) then {
	echo "*** Falta $V$VESP-$ARQ/INSTALL.amd64 que será examinado al instalar";
	exit 1;
} fi;
rm $V$VESP-$ARQ/SHA256*
l=`(cd $V$VESP-$ARQ; ls *tgz INSTALL.amd64 bsd* cd*)`;
cmd="(cd $V$VESP-$ARQ; cksum -a sha256 $l >  SHA256; signify -S -e -s /etc/signify/adJ-$VP-base.sec -x SHA256.sig -m SHA256)";
echo $cmd;
eval $cmd;
cmd="find $V$VESP-$ARQ  -exec touch {} ';'"
echo $cmd;
eval $cmd;
