Actualización a Aprendiendo De Jesús 5.6
========================================

La actualización consta de 3 partes:

1. Preparar su sistema y descargar instalador
2. Actualizar el Sistema Base
3. Actualizar Aplicaciones


1. Preparar su sistema
----------------------

* Aunque puede descargar el DVD de instalación, es más breve y robusto ante 
  fallas que descargue los directorios y archivos del instalador con rsync
	```
	mkdir -p ~/comp/adJ;
	cd ~/comp/adJ;
	rsync-adJ 5.6
	```

  Si ocurre alguna falla durante la transmisión podrá continuar donde
  quedó repitiendo estas instrucciones.
* Si va a actualizar, debe sacar copia de la base de datos y realizar
  otras operaciones para preparar su sistema (por ejemplo la actualización
  a 5.5 requería eliminar todos los paquetes del sistema), 
  puede hacerlo ejecutando el archivo de ordenes ```preact-adJ.sh```
  incluido en el directorio ```util``` del DVD de instalación.
  Si descargó fuentes con el procedimiento anterior ejecutelo con:

	```
       	~/comp/adJ/5.6-amd64/util/preact-adJ.sh
	```

2. Actualizar el sistema base:
------------------------------
* Copie kernel y descomprima los archivos comprimidos con el sistema base en 
  su directorio raiz y reinicie, esto lo puede hacer con el 
  archivo de órdenes ```actbase.sh```:

		```
		cd ~/comp/adJ; 
		5.6-amd64/util/actbase.sh 5.6
		```

3. Actualizar aplicaciones:
---------------------------------------------
* Después de reinicar debe ejecutar  el archivo de ordenes ```/inst-adJ.sh```
  Este archivo de comandos emplea codificación UTF8, por lo que para 
  iniciarlo se recomienda desde una terminal gráfica.  
  Si descargo la distribución con las instrucciones dadas en la primer parte
  puede usar:

	```
	sudo ARCH=~/comp/adJ/5.6-amd64 /inst-adJ.sh
	```

  Este archivo de comandos asiste actualizaciones que puedan hacer 
  falta de una versión a otra del sistema base (descritas en
  http://openbsd.org/faq/upgrade55.html ) y actualiza cuando es posible
  archivos de configuración de diversos paquetes.
* Puede ejecutar varias veces este archivo de órdenes, pero si el 
  proceso no concluye exitosamente por favor después de ejecutar
  el instalador varias veces y avanzar tanto como pueda envíe el archivo
  ```/var/tmp/inst-adJ.bitacora``` a info@pasosdeJesus.org
* Este archivo de ordenes utiliza ```sysmerge``` para actualizar algunos 
  archivos de configuración. Como se explica en 
  http://www.openbsd.org/faq/upgrade48.html :

  	```sysmerge(8)``` muestra el resultado del comando ```diff(1)``` 
	unificado, pasando por un paginador (el que haya configurado en la 
	variable de ambiente ```$PAGER```) y para la mayoría de archivos 
	presenta un mensaje como el siguiente:

		Use 'd' to delete the temporary ./var/www/htdocs/index.html
		Use 'i' to install the temporary ./var/www/htdocs/index.html
		Use 'm' to merge the temporary and installed versions
		Use 'v' to view the diff results again
	
		Default is to leave the temporary file to deal with by hand

	Si desea retener su archivo actual, borre el temporal con la opción 
	```d```, si dese remplazar su archivo existente con la nueva versión, 
	instale el archivo temporal con ```i``` Si desea mezclar los dos, 
	al alejir ```m``` ingresará al programa ```sdiff``` (1) donde podrá 
	mezclar manualmente el archivo.  Por defecto continuará y dejará el 
	archivo sin modificar para manejarlo posteriormente de manera manual.
	
	Aunque puede funcionar, no se recomienda usar sysmerge para integrar
	nuevos usuarios en el sistema, sino para esto usar useradd, que es 
	menos proclive a errores (ayuda: no instale el archivo temporal 
	```master.passwd``` sobre su archivo existente!).
	
	```sysmerge(8)``` salva todos sus archivos remplazados en un directorio 
	temporal, como ```/var/tmp/sysmerge.24959/backups```, así que si por 
	accidente elimina algo que no era buena idea eliminar, tiene 
	oportunidad de recuperarlo.  Advertencia: Note que la rutina 
	```daily(8)``` limpia archivos antiguos de ese directorio.
	
	En general al usar sysmerge puede remplazar (opción ```i```) todos los 
	archivos por sus versiones más recientes, pero dependiendo de los 
	servicios que preste el servidor, hay algunos archivos de 
	configuración que es mejor no remplazar (opción ```d```) o que es      
	mejor mezclar si conoce la sintaxis (opción ```m```).

  * Evite remplazar ```/etc/rc.local``` y ```/etc/hosts```
  * Si es cortafuegos evite remplazar ```/etc/pf.conf``` y ```/etc/sysctl.conf```
  * Si es servidor DNS evite remplazar ```/var/named/etc/named.conf```
  * Si es servidor de correo evite remplazar archivos del directorio 
   ```/etc/mail``` (tras actualizar recuerde recompilar sendmail).
  * Si es servidor web evite remplazar ```/var/www/conf/httpd.conf```
	

