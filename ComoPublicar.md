COMO PUBLICAR
=============

Anhelamos publicar versión mayor (e.g 5.6) 3 meses después de OpenBSD:
	1.Ago
	1.Feb

Publicamos revisiones (e.g 5.6) si la seguridad o calidad lo ameritan.

Anhelamos publicar al menos una versión alfa (e.g 5.6a1 en directorio
desarrollo del sitio de distribución) 20 días antes de la versión mayor:
	10.Jul
	10.Ene

Pasos importantes para publicar
-------------------------------

1. Actualizar SIVeL, evangelios y paquetes propios de adJ.

2. Actualizar documentación, publicar en Structio, actualizar portes de esta,
generar y probar paquetes

3. Verificar operación de:
  * http://structio.sf.net/guias/
  * http://sivel.sf.net/guias/
  * http://aprendiendo.pasosdeJesus.org
  * http://www.pasosdeJesus.org
  * ftp://ftp.pasosdeJesus.org
  * rsync://ftp.pasosdeJesus.org

4. Retocar fecha de publicacion en ```Novedades.ewiki``` y publicar escondido en
  http://aprendiendo.pasosdeJesus.org

5. Retocar ```Dedicatoria.txt``` y archivos *.txt y regenar en distribución (sin
  paquetes ni otras compilaciones) con:

	```
	sudo ./distribucion.sh
	```

6. En computador de desarrollo tras configurar ```var-local.sh``` enviar a
ftp.pasosdeJesus.org:

	```
	hdes/rsync-aotro.sh
	```

7. En ftp.pasosdeJesus.org

	```
	hdes/creaiso.sh
	cp -rf AprendiendoDeJesus-5.6-amd64.iso 5.6-amd64 /dirftp
	```

8. Actualiza version en reto en P2PU (las 4 primeras tareas)

https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/

9. Actualizar Artículo como Noticia en http://aprendiendo.pasosdeJesus.org

10. Correo a listas: openbsd-colombia@googlegroups.com, 
    openbsd-colombia@googlegroups.com, colibri@listas.el-directorio.org, 
    openbsd-mexico@googlegroups.com, sivel-soporte@lists.sourceforge.net

	Tema: Publicado adJ 5.6 para amd64

	Para instalar por primera vez descargue imagen para DVD de:
	  ftp://ftp.pasosdejesus.org/pub/AprendiendoDeJesus/
	O solicite un CD por correo postal.

	Si planea actualizar de una version anterior de adJ a adJ 5.6
	hay un procedimiento mas rápido con ```rsync``` (ver
	https://github.com/pasosdeJesus/adJ/blob/master/Actualiza.md ).

	Si no tiene experiencia con esta distribución de OpenBSD para 
	servidores y cortafuegos, que es segura, usable en español y amigable 
	para cristian@s, puede aprender a instalar o actualizar con:
	  1. El curso/reto que da una medalla a quienes completen:
	  https://p2pu.org/es/groups/openbsd-adj-como-sistema-de-escritorio/
	  2. La guía de instalación:
	  http://structio.sourceforge.net/guias/usuario_OpenBSD/sobre-la-instalacion.html

	Vea las novedades completas de la versión 5.6 en:
	  http://aprendiendo.pasosdejesus.org/?id=AdJ+5.6+-+Aprendiendo+de+Jesus+5.6

	De estas destacamos:
	...


	Bendiciones


11. Publicar en Twitter que retrasnmite a cuenta y página en Facebook. 
    Si es tambien publicacion de SIVeL en sitio de noticias de SIVeL y Structio.

	Publicado adJ 5.6 sistema operativo para servidores y cortafuegos, 
	seguro, amigable para cristian@s y en español, ver 
	http://aprendiendo.pasosdejesus.org/

12. Poner Tag en github e iniciar rama

	```
	git tag -a v5.6 -m "Version 5.6"
	git push origin v5.6
	...
	git checkout -b ADJ_5_6
	git push origin ADJ_5_6
	```
