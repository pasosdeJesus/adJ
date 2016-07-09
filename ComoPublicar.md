COMO PUBLICAR
=============

Anhelamos publicar versión mayor (e.g 5.9a1) 4 meses después de OpenBSD:

	1.Sep
	1.Mar

Publicamos revisiones (e.g 5.9a1) si la seguridad o calidad lo ameritan.

Anhelamos publicar al menos una versión beta (e.g 5.9a1 en directorio
```desarrollo``` del sitio de distribución) 20 días antes de la versión mayor:

	10.Ago
	10.Feb

Sería ideal publicar una versión alfa mucho antes.


Pasos importantes para publicar versión beta
--------------------------------------------

1. Recompilar paquetes con actualizaciones de seguridad o mejoras
2. Retroportar paquetes
3. Cambiar versión en ver.sh, arboldd/usr/local/adJ/inst-adJ.sh, Actualiza.md,
	ComoPublicar.md, {$V-amd64,arboldvd}/util/preact-adJ.sh, 
	{$V-amd64,arboldvd}/util/actbase.sh, 
4. Retocar ```Dedicatoria.md``` y archivos *.md (por lo menos versión),
   regenar en distribución (sin paquetes ni otras compilaciones) con:
	```
	doas ./distribucion.sh
	```
5. Retocar fecha de publicacion en ```Novedades.md``` y publicar escondido en
   http://aprendiendo.pasosdeJesus.org
6. Generar distribución, imagen iso (```hdes/creaiso.sh```) y probar por 
  ejemplo en ```qemu``` (```hdes/qemu.sh``` o remotamente 
  ```TEXTO=1 hdes/qemu.sh```): instalación de sistema base, 
   ejecución de inst-adJ.sh en nuevo y actualización, 
   ejecución de inst-sivel.sh, que opere SIVeL2,
   que toda entrada del menú opere.  
   Arreglar y repetir hasta que no haya errores.
7. En computador de desarrollo tras configurar ```var-local.sh``` enviar a
   adJ.pasosdeJesus.org:
	```
	hdes/rsync-aotro.sh
	```
8. En adJ.pasosdeJesus.org
	```
	hdes/creaiso.sh
	cp -rf AprendiendoDeJesus-5.9a1-amd64.iso 5.9a1-amd64 /dirftp
	mkdir /dirftp/5.9a1-amd64-extra
	rsync compdes:/usr/ports/packages/amd64/all/* /dirftp/5.9a1-amd64-extra
	```
9. Verificar operación de:
  * http://pasosdeJesus.github.io/basico_adJ http://pasosdeJesus.github.io/usuario_adJ http://pasosdeJesus.github.io/servidor_adJ
  * http://sivel.sf.net/
  * http://aprendiendo.pasosdeJesus.org
  * http://www.pasosdeJesus.org
  * http://adJ.pasosdeJesus.org
  * rsync://adJ.pasosdeJesus.org
10. Poner Tag en github e iniciar rama
	```
	git tag -a v5.9a1 -m "Version 5.9a1"
	git push origin v5.9a1
	...
	git checkout -b ADJ_5_9
	git push origin ADJ_5_9
	```
10. Publicar en lista de desarrollo

Pasos importantes para publicar versión mayor
--------------------------------------------

1. Usar la rama ADJ_5_9
	git checkout ADJ_5_9
2. Actualizar SIVeL, evangelios, Mt77, cor1440, sal7711 y paquetes propios de adJ.
3. Actualizar documentación, publicar en Internet
4. Análogo a pasos 5-9 de versión beta
5. Actualiza version en reto de P2PU (las 4 primeras tareas) 
   https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
6. Actualizar Artículo como Noticia en http://aprendiendo.pasosdeJesus.org,
   http://aprendiendo.pasosdejesus.org/?id=MainMenu,  
7. Poner Tag en github

	```
	git tag -a v5.9 -m "Version 5.9"
	git push origin v5.9
	```
8. Correo a listas: 
    openbsd-colombia@googlegroups.com, colibri@listas.el-directorio.org, 
    openbsd-mexico@googlegroups.com, sivel-soporte@lists.sourceforge.net

	Tema: Publicado adJ 5.9 para amd64

	Para instalar por primera vez descarga la imagen para DVD de:
	  http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/
	O solicita un CD por correo postal.

	Si planeas actualizar de una version anterior a 5.9
	hay un procedimiento mas rápido con ```rsync``` (ver
	https://github.com/pasosdeJesus/adJ/blob/master/Actualiza.md ).

	Si no tienes experiencia con esta distribución de OpenBSD para 
	servidores y cortafuegos, que es segura, usable en español y amigable 
	para cristian@s, puedes aprender a instalar o actualizar con:
	  1. El curso/reto que da una medalla a quienes completen:
	  https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
	  2. La guía de instalación:
	  http://pasosdeJesus.github.io//usuario_adJ/sobre-la-instalacion.html

	Mira las novedades completas de la versión 5.9a1 en:
	  http://aprendiendo.pasosdejesus.org/?id=AdJ+5.9+-+Aprendiendo+de+Jesus+5.9

	De estas destacamos:
	...


	Bendiciones

9. Publicar en Twitter que retrasnmite a cuenta y página en Facebook. 
   Si es tambien publicacion de SIVeL en sitio de noticias de SIVeL y Structio.

	Publicado adJ 5.9 sistema operativo para servidores y cortafuegos, 
	seguro, amigable para cristian@s y en español, ver 
	http://aprendiendo.pasosdejesus.org/

10. Actualiza artículos de Wikipedia 
   https://en.wikipedia.org/wiki/AdJ y https://es.wikipedia.org/wiki/AdJ 

