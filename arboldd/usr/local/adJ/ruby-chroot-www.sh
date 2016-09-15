#!/bin/sh
# Prepara jaula para ruby en /var/www
# Dominio público. 2016. vtamara@pasosdeJesus.org
# Referencias:
# http://web.archive.org/web/20100110060204/http://bsd.phoenix.az.us/faq/openbsd/rails-chroot-fastcgi
# proot

apenchroot=$1;
dchroot=$2;
if (test "$dchroot" = "") then {
	dchroot="/var/www";
} fi;

jk=`ls /var/db/pkg | grep "^jailkit-[0-9]"`
if (test "$jk" = "") then {
	echo "Se requiere paquete jailkit"
	exit 1;
} fi;

# Agrega un binario/libreria junto con librerias compartidas de las que dependa
# Necesaria porque jk_cp no examina ni copia dependencias de 
# librerías compartidas
function agrega_so {
	b=$1
	echo "OJO agrega_so $b" >> /tmp/rcw.log
	if (test ! -f "$b") then {
		echo "agrega_so: primer parametro debía ser binario/librería a copiar";
		return	
	} fi;
	d=`dirname $b`
	sub=`echo $d | sed -e "s|^$dchroot.*|...|g"`
	echo "OJO d=$d, sub=$sub, mira si corre jk_cp -j $dchroot $b" >> /tmp/rcw.log
	if (test "$sub" != "..." -a ! -f $dchroot/$b) then {
		# No pone lo que viene de jaula ni lo que ya esta
		jk_cp -j $dchroot $b
		for i in `ldd $b | grep "\.so" | grep ".* \/" | sed -e "s/.* \//\//g"`; do
			echo "OJO 2 i=$i" >> /tmp/rcw.log
			if (test ! -f $dchroot/$i) then {
				agrega_so $i
			} fi;
		done
	} fi;
} 

# Agrega una serie de archivos al chroot y de los binarios
# y librerías compartidas tambień copia librerías de los que 
# dependan
function agrega_ar {
	for f in $@; do 
		echo "OJO agrega_ar $f" >> /tmp/rcw.log
		so=`echo $f | sed -e "s/.*.so$/.../g"`
		if (test "$so" = "..." -o -x "$f") then {
			agrega_so $f
		} else {	
			echo "OJO corre jk_cp -j $dchroot $f" >> /tmp/rcw.log
			jk_cp -j $dchroot $f
		} fi;
	done;
}


# Agrega un paquete asi como otros de los que dependa a /tmp/l
function agrega_paquete {
	p=$1
	if (test "$p" = "") then {
		echo "agrega_paquete: primer parametro debía ser paquete a copiar";
		exit 1;
	} fi;
	q=`ls /var/db/pkg/ | grep "^$p-[0-9]" | tail -n 1`
	if (test "$q" = "") then {
		echo "No se encontró paquete $p";
		exit 1;
	} fi;
	agrega_ar `pkg_info -L $q | grep "^/"`
	for i in `cat /var/db/pkg/$q/+REQUIRING`; do
		agrega_ar `pkg_info -L $i | grep "^/"`
	done
} 

# Agrega un enlace (origen y crea)
function agrega_enlace {
	e=$1
	if (test ! -h "$e") then {
		echo "agrega_enlace: primer parametro debía ser enlace a copiar";
		exit 1;
	} fi;
	r=`ls -l $e | sed -e  "s/.* -> //g"`
	agrega_ar $r
	ln -sf $r /var/www/$e
}

echo "1. Actualizar basico de ruby fuera de chroot" | tee /tmp/rcw.log
gem update --system

echo "2. Instala ruby y node y entorno de ruby en jaula chroot $dchroot"


# Facilita muchas operaciones:
if (test ! -h ${dchroot}${dchroot}) then {
	ln -sf / ${dchroot}${dchroot}
} fi;

# Crea dispositivos tipicos
cd /var/www/dev
/dev/MAKEDEV std

# Para que ruby pueda entender UTF-8:
jk_cp -j $dchroot /usr/share/locale/UTF-8/ 
jk_cp -j $dchroot /usr/share/locale/es.UTF-8/
jk_cp -j $dchroot /usr/share/locale/es_CO.UTF-8/

# Para poder ejecutar binarios con librerias compartidas
agrega_ar /sbin/ldconfig
agrega_ar /etc/resolv.conf

agrega_paquete ruby
agrega_paquete node
agrega_ar /usr/bin/env
agrega_ar `gem contents bundler` 
agrega_ar `gem contents rubygems-update` 

agrega_enlace /usr/local/bin/bundle
agrega_enlace /usr/local/bin/gem

#ldd `gem contents nokogiri | grep "\.so"` | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l

#ldd `find /home/vtamara/.bundler/gems/ -name "*.so"` | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l

# Otros que pueden requerirse
#echo /usr/local/bin/convert >> /tmp/l
#ldd /usr/local/bin/convert | grep ".* \/" | sed -e "s/.* \//\//g" >> /tmp/l

if (test "$apenchroot" != "" -a -d "$apenchroot" ) then {
	echo "3. Agrega librerías compartidas que pueda requerir $apenchroot";
	#cmd="find \"$apenchroot\" -name \"*.so\""
	#echo "$cmd";
	#eval "$cmd";
	agrega_so `find "$apenchroot" -name "*.so"` 
	# La aplicacion requiere posibilidad de escritura en tmp log public/assets
} fi;

echo "4. Ejecuta ldconfig"
chroot $dchroot /sbin/ldconfig /usr/local/lib /usr/X11R6/lib/ /usr/local/lib/ruby/2.3/x86_64-openbsd/

# Para correr aplicación en jaula, por ejemplo:
# export HOME=/htdocs/sivel2 
# export GEM_PATH=$GEM_PATH:/htdocs/sivel2/vendor/bundle/ruby/2.3/ 
