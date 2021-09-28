COMO PUBLICAR
=============

Anhelamos publicar versión mayor (e.g 7.0) 3 meses después de OpenBSD:

* 11.Ene
* 1.Jul

También publicamos revisiones (e.g 7.0p1) si la seguridad o calidad lo ameritan.

Anhelamos publicar al menos una versión beta (e.g 7.0 en directorio
`desarrollo` del sitio de distribución) en:

	10.Dic
	10.Jun

Sería ideal publicar una versión alfa mucho antes (24.Sep y 24.Mar, e.g 7.0a1).


Pasos importantes para publicar versión beta
--------------------------------------------
1. Cambiar versión en `ver.sh`, `arboldd/usr/local/adJ/inst-adJ.sh`, 
   `Actualiza.md`, `ComoPublicar.md`, 
   {$V-`amd64`,`arboldvd`}`/util/preact-adJ.sh`, `Novedades.md`,
   `README.md`, `Novedades_OpenBSD.md`, 
   {$V-`amd64`,`arboldvd`}`/util/actbase.sh` y
   cambiar `Dedicatoria.md`
2. Instalar o bien la versión alfa de adJ misma versión o bien la
   versión estable de OpenBSD
3. Actualizar parches de locale y xlocale en libc de forma que puedan aplicarse
   sobre la nueva versión de OpenBSD. 

	3.1 Prepara para probar con: `pruebas/preppruebas.sh` que restaura 
 	    `/usr/src` a partir de `/usr/src$V-orig`

	3.2 Tratar de aplicar todos los parches con último parche:
		 `pruebas/aplicahasta.sh arboldes/usr/src/14..` 

	3.3 Compilar libc con `doas pruebas/compila-libc.sh` y correr pruebas 
	    de regresión con `cd /usr/src/regress/lib/libc/locale/; doas make`

	3.4 Si falla compilación o alguna prueba de regresión hacer búsqueda 
	    binaria entre parches, iterando desde 3.1 pero en 3.2 ir bajando a 
	    parche del medio, y así sucesivamente hasta identificar el último 
	    que no produce fallas al correr pruebas de regresión. Puede 
	    aplicarse de a un parche con `pruebas/aplica.sh`.  Aplicar parche 
	    que falla y arreglar en libc hasta que pasen pruebas de regresión 
	    (y en lo posible mejorarlas).
4. Recompilar kernel, perl, sistema base y asegurar que puede crearse una 
   distribución inicial.
   Ver en `distribucion.sh` lo que hace cuando `autoCompBase` es 's'.
   Para verificar que perl está más o menos bien ejecutar `pkg_add`.
5. Recompilar paquetes con actualizaciones de seguridad o mejoras
6. Retroportar paquetes, dejar resultados no incluidos en DVD pero
   útiles en `7.0-extra`
7. Regenerar distribución (sin paquetes ni otras compilaciones) con:
	```
	doas ./distribucion.sh
	```
8. Retocar fecha de publicacion en `Novedades.md` y publicar escondido en
   <http://aprendiendo.pasosdeJesus.org>
9. Generar distribución, imagen iso (`hdes/creaiso.sh`)
9. Probar por ejemplo en `qemu` (`hdes/qemu.sh` o remotamente 
  `TEXTO=1 hdes/qemu.sh`): 
	- Instalación de sistema base, `uname -a` debe reportar 
		`APRENDIENDODEJESUS`
	- Verificar que kernel tiene renombramiento de daemon por servicio con:
	```
	$  vmstat -s | grep servicio
	4 pages reserved for pageservicio
	0 number of times the pageservicio woke up
	0 pages freed by pageservicio
	0 pages scanned by pageservicio
	0 pages reactivated by pageservicio
	0 busy pages found by pageservicio
	```
	- Verificar que se usa la bitácora `/var/log/servicio` y que no 
	  existe `/var/log/daemon`
	```
	$ ls -lat /var/log/servicio  
	-rw-r-----  1 root  wheel  149983 Sep 19 18:48 /var/log/servicio
	```
	- Verificar que libc incluye funciones de locale por ejemplo editando
	  un archivo `l.c` con el siguiente contenido, tras compilar con 
  	  `cc -o l l.c` y ejecutar con `./l` el resulado debería ser 
	  `1.000.000,200000`:
	```c
	#include "locale.h"  
	#include "stdio.h"
	int main() {  
	  setlocale(LC_ALL, "es_CO.UTF-8");
	  printf("%'f", 1000000.2);
	
	  return 0;
	}
	```
	- Operación de locale numeric en perl. El siguiente programa en perl 
	debe dar respuesta 1987,23:
	```perl
	# Basado en http://perldoc.perl.org/perllocale.html
	use locale;
	use POSIX qw(locale_h);
	setlocale(LC_NUMERIC, "es_CO.UTF-8") or die "No pone locale LC_NUMERIC en es_CO.UTF-8";                                                        
	my $a = 1987.23;
	printf "%g\n", $a;
	```
	- Ejecución de /inst-adJ.sh en nuevo y actualización, 
	- Verificar que desde el directorio paquetes del medio de
	  instalacion se ejecute sin fallas PKG_PATH=. doas pkg_add *
	- Con paquete `colorls` modificado y actualizado, verificar cotejacion 
	  en español en terminal grafica:
	```sh
	touch a
	touch í
	touch o
	ls -l
	```
  	  Debe mostrar los directorios en orden alfabético correcto (í 
	  entre a y o).
	- Con paquete postgresql modificado y actualizado, verificar que 
	  coteja en español con:
	```sh
	doas su - _postgresql
	cat > /tmp/cot.sql <<EOF
	SELECT 'Á' < 'B' COLLATE "es_co_utf_8";
	EOF
	psql -h /var/www/var/run/postgresql/ -Upostgres -f /tmp/cot.sql
	```
	  que debe responder con
	```
	 ?column?
	----------
	 t
	(1 row)
	```
	- Que opere bien una aplicación Ruby on Rails
	- Que toda entrada del menú desde la interfaz gráfica opere.  
	  Arreglar y repetir hasta que no haya errores.
10. En computador de desarrollo tras configurar `var-local.sh` enviar a
   adJ.pasosdeJesus.org:
	```
	hdes/rsync-aotro.sh
	```
11. En adJ.pasosdeJesus.org
	```
	hdes/creaiso.sh
	cp -rf AprendiendoDeJesus-6.6-amd64.iso 6.6-amd64 /dirftp
	mkdir /dirftp/6.6-extra
	rsync compdes:comp/adJ/extra-6.6/* /dirftp/6.6-extra
	```
12. Verificar operación de:
  * http://pasosdeJesus.github.io/basico_adJ http://pasosdeJesus.github.io/usuario_adJ http://pasosdeJesus.github.io/servidor_adJ
  * http://sivel.sf.net/
  * http://aprendiendo.pasosdeJesus.org
  * http://www.pasosdeJesus.org
  * http://adJ.pasosdeJesus.org
  * rsync://adJ.pasosdeJesus.org

13. Poner Tag en github e iniciar rama al publicar version alfa o beta (antes en master)
	```
	git tag -a v7.0b1 -m "Version 7.0b1"
	git push origin v7.0b1
	...
	git checkout -b ADJ_7_0
	git push origin ADJ_7_0
	```
14. Publicar en lista de desarrollo

Pasos importantes para publicar versión mayor
--------------------------------------------

1. Usar la rama ADJ_7_0
	```
	git checkout ADJ_7_0
	```
2. Actualizar SIVeL, evangelios, Mt77, cor1440, sal7711 y paquetes propios de 
   adJ.
3. Actualizar documentación (`basico_adJ`, `usuario_adJ` y `servidor_adJ`), 
   publicar en Internet
4. Actualizar versión en logo que presenta xenodm en `arboldd/etc/X11/xenodm/pixmaps/`. 
   Con gimp iniciar con el de resolución 15bpp, modificarlo el número de 
   versión es tipo Sans tamaño 18. Par converitr a xpm en 
   Imagen > Modo > Indexado. 15bpp y 8bpp con paleta de 255 colores. 
   4bpp con paleta de 15 colores, 1bpp con paleta de 2 colores.
5. Análogo a pasos de versión beta
6. Actualizar version en reto de P2PU (las 4 primeras tareas) 
   https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
7. Poner Tag en github
	```
	git tag -a v7.0 -m "Version 7.0"
	git push origin v7.0
	```
8. Publicar en Twitter y Facebook. 
   Si es tambien publicacion de SIVeL en sitio de noticias de SIVeL y Structio.

	Publicado adJ 7.0 distribución para servidores y cortafuegos, 
	segura, amigable para cristian@s y en español, ver 
	http://aprendiendo.pasosdejesus.org/
9. Correo a listas: 
    openbsd-colombia@googlegroups.com, 
    openbsd-mexico@googlegroups.com, sivel-soporte@lists.sourceforge.net

	Tema: Publicado adJ 7.0 para amd64

	Para instalar por primera vez descarga la imagen para DVD de:
	  http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/
	O solicita un DVD o una USB de instalacion por correo postal.

	Si planeas actualizar de una version anterior a 7.0
	hay un procedimiento mas rápido con `rsync` (ver
	https://github.com/pasosdeJesus/adJ/blob/master/Actualiza.md ).

	Si no tienes experiencia con esta distribución de OpenBSD para 
	servidores y cortafuegos, que es segura, usable en español y amigable 
	para cristian@s, puedes aprender a instalar o actualizar con:
	  1. El curso/reto que da una medalla a quienes completen:
	  https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
	  2. La guía de instalación:
	  http://pasosdeJesus.github.io//usuario_adJ/sobre-la-instalacion.html

	Mira las novedades completas de la versión 7.0 en:
	  http://aprendiendo.pasosdejesus.org/?id=AdJ+7.0+-+Aprendiendo+de+Jesus+7.0

	De estas destacamos:
	...

	
	Puedes patrocinar el desarrollo en github:
  		https://github.com/sponsors/vtamara
	

	Bendiciones

10. Actualiza artículos de Wikipedia 
   <https://en.wikipedia.org/wiki/AdJ> y <https://es.wikipedia.org/wiki/AdJ>

11. Publicar noticia en <http://sivel.sf.net> y en  <http://structio.sf.net>

