#adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

###Versión: 6.0p2
Fecha de publicación: 16/May/2017

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_0/Novedades_OpenBSD.md>

##NOVEDADES RESPECTO A adJ 6.0

- Parches al sistema basta hasta el 16.May.2017 que cierran 7 fallas 
  de seguridad y 16 de robustez.
- Paquetes más actualizados: 
	- ruby 2.4.1 retroportado
	- php-5.6.30
	- samba-4.4.5p3 actualizado en fuentes de OpenBSD 6.0
	- curl-7.53.1p0 actualizado en fuentes de OpenBSD 6.0
- Archivo de ordenes /usr/local/adJ/resto-altroot.sh para copiar 
  resto de particiones altroot ver 
  <http://dhobsd.pasosdejesus.org/Respaldo_altroot.html>

Esta versión actualiza algunos pocos binarios respecto a la versión 
6.0, lo invitamos a ver las novedads completas de adJ 6.0 en:
<http://aprendiendo.pasosdejesus.org/?id=AdJ+6.0+-+Aprendiendo+de+Jesus+6.0>


##FE DE ERRATAS

La configuración del teclado que haga para las consolas tipo texto ya no se aplica para X-Window. Para establecer una configuracion de teclado agregue al archivo ```/etc/X11/xdm/Xsetup_0```
```
setxkbmap -layout latam 
```
cambiando ```latam``` por ```es``` o por la distribución de su teclado (ve las posibles con man ```xkeyboard-config```)
