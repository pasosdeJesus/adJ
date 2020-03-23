# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.6
Fecha de publicación: 23/Mar/2020

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_6/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.6-amd64.iso> es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.6-amd64/> es directorio con el contenido del DVD instalador apropiado para descargar con rsync y actualizar un adJ ya instalado (ver  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_6/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.6-extra/> es directorio con versiones recientes de paquetes no incluidos en distribución oficial (pueden no estar firmados y requerir instalación con `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.6-amd64.usb> es imagen para escribir en una memoria USB y arrancar
  con esta. Una vez la descargue puede escribirla en una USB ubicada en 
  `/dev/sd2c` (verifiquer dispositivo con `dmesg` y remplace):

	doas dd if=AprendiendoDeJesus-6.6-amd64.usb of=/dev/sd2c bs=1M

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

 	qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.6-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.5 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

* Aplicados parches de seguridad hasta el 16.Mar.2020 provenientes de 
  OpenBSD que incluyen solución a fallas de OpenSMTPD y sysctl
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Soporte para AR9271 en `athn` y arreglado
		  soporte para AR9280
		* Ethernet: Nuevo controlador `mcx` que soporta Mellanox 
		  ConnectX-4 (y posteriores). Agregado soporte para 
		  MSI-X en `bnxt`
		* USB y modems: Soporte para adaptador USB-Ethernet RTL8153B 
	 	  en `ure`
	* Video: Nuevo controlador `amdgpu` que soporta AMD Radeon GPU.
	  Mejoras a `drm` que en conjunto con `amdgpu`, `inteldrm` y/o
	  `radeon` dan acelaración de video por hardware usando la
	   Infraestructra de Presentación Directa (Direct Rendering
	   Infrastructure - DRI).
	* Sonido: Soporte para Realtek ALC285 en `azalia`. Mejorado
 	  `envy` y soporte de tarjetas ESI Juli@
	* Almacenamiento: Mejorado soporte para controladores SAS3 en
	  `mpii`
	* Criptografía: Soporte para co-procesador criptográfico 
	  de los AMD Ryzen recientes
	* Sensores y otros: Añadido soporte para formato KSMEdia 8bit IR a 
	  `uvideo`.  Nuevo `ukspan` que soporta el adapatador serial a USB 
	   TrippLite Keyspan USA-19HS. Mejorado controlador de trackpad 
	   multi-toque `ubcmtp` (usado en Mac). Soporte para USB Tipo-C
	   Fairchild FUSB302  en  `fusbtc`. Nuevo `ksmn` que soporta
	   sesor de temperatura AMD F17 de las nuevas CPUs AMD de la familia
	   17 (Zen/Zen+/Zen2)
	
* Mejoras a herramientas de Red
	* Mejoras a pila inalámbrica general y en particular a `ifconfig` 
	  con `nwflag` y `mode`para poner modo 11a/b/g/n.
	* Soporte para examinar y establecer rxprio via `ifconfig` según
	  RFC 2983. Agregado a `vlan`, `gre`, `mpw`, `mpe`, `mpip`, 
	 `etherip` y `bpe`.
	* Nuevo cliente `snmp` compatible con netsnmp y eliminado `snmpctl`
	* Diversas mejoras a `bgpd`
	* Mejoras a `relayd` en particular ahora soporta SNI
	* `acme-client` ahora soporta API Let's Encrypt v02.
	* Varias mejoras a OpenSMTPD 6.6.0 en particular posibilidad
	  de configurar filtros y operar detras de proxy.

* Seguridad
	* Función `unveil` usada en 77 programas en zona de usuarios para 
	  restringir acceso a sistema de archivos (como `chroot` pero mejor).
	  Y ahora `ps` puede mostrar que procesos usaron `unveil` y `pledge`
	* Se añade soporte para el Protocolo Generador de Númerosa Aleatorios 
	  EFI
	* Incluye OpenSSH 8.1
	* Incluye LibreSSL 3.0.2
* Otros
	* Diversas mejoras a `tmux`

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm` 8.0.1,  `Xenocara` (basado en `Xorg` 7.7),
  `perl` 5.28.2
* El repositorio de paquetes de OpenBSD cuenta con 10736 para amd64


### 2.2 Paquetes 

* Recompilados portes estables más recientes para evitar fallas de seguridad: 
    `certbot`, `dovecot`, `gettext-tools`, `libidn2`, `librsvg`,
    `oniguruma`, `pcre2`, `unzip` y `webkitgtk4`
* Ruby 2.7.0 retroportado de current  (incluye solución de Jeremy Evans a 
  falla con `realpath` para permitir usar `unveil` y de hecho hay 2 gemas 
  que permiten usarlo desde ruby: <https://github.com/jcs/ruby-unveil> y 
  <https://github.com/jeremyevans/ruby-pledge>)
* Algunos paquetes típicos y su versión: dovecot 2.3.7.2, chromium 79.0.3945,
  firefox 69.9.2, libreoffice 6.3.2.2, nginx 1.16.1p0, mariadb 10.3.18,
  node 10.16.3, postgresql 12.2, python 3.7.4, ruby 2.7.0, vim 8.1.2061


## 3. NOVEDADES RESPECTO A ADJ 6.5 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada: 
	* `basico_adJ`: Nueva sección sobre `tmux`
	* `usuario_adJ`: Ampliada sección sobre discos duros
	* `servidor_adJ`: Reescrita sección sobre servidores web con bastantes casos de uso de nginx

### 3.2 Paquetes

* El nuevo paquete `bibletime` remplaza `xiphos` y `biblesync`
* Se agrega `postgresql-pg_upgrade` y `postgresql-previous` que facilitan
  actualizar de la versión 11 a las versión 12 (ver <https://dhobsd.pasosdejesus.org/actualizacion-de-postgresql-con-pg_upgrade.html>). 
  El porte `postgresql-previous` fue levemente modificado para no entrar en 
  conflicto con `postgresql-docs`
* Se compacta más el medio de instalación retirando algunos programas (que
  siguen estando disponibles como paquetes en repositorios de OpenBSD): 
  `dia`, `ganglia`, `midori`, `qgis`, `rdesktop`, `scribus`, `xsane`.  
  Además se retiraron varios programas de soporte y librerías ya no usados 
  como `aspell-es`, `db`, `celt`, `gstreamer1mm`, `gtkhtml4`, `hdf5`, `libao`, `openpam`.
* Entre los paquetes retirados resaltamos `markup` que ya no está disponible
  en sitio de distribución y por lo mismo `sigue` y `repasa` que la requerían.
  Se retiró `SIVeL 1.2` y programas que lo requerían incluyendo porte
  obsoleto de `php-5.6.4` y los diversos paquetes de `pear`. 
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Recompilados muchos paquetes de Perl que ahora son requeridos por 
  `SpamAssassin` y al igual que otros de perl se recompilaron (sin cambiar 
  de versión) con el perl de adJ que si soporta `LC_NUMERIC`.  
* Retroportados y adaptados de OpenBSD-current 
  * `chromium` 79.0.3945-117 con llave de Pasos de Jesús
  * `curl`
  * Postgresql 12.2 adaptado de retroporte de 12.1 (en adJ soporta 
   bien cotejaciones en español)
* Se incluye beta 10 de `sivel2` cuyas novedades son:
    * Mapa de casos sobre OpenStretMap con filtro, acumulados de casos 
      (clusters) y nuevas posibilidades con capas: elegir capa base, 
      superponer una capa con transparencias, cargar pequeñas capas GeoJSON 
      y de exportar la capa de casos en GeoJSON (implementado por Luis 
      Alejandro Cruz)
    * Posibilidad de visualizar casos sobre Google Maps (portado de SIVeL 1.2 
      y mejorado) y sobre Mapbox, pero no se activan por omisión por requerir 
      llave y eventualmente pagos. Ver pantallazos en 
      https://github.com/pasosdeJesus/sivel2_gen/blob/master/doc/mapas.md 
      (implementado por Luis Alejandro Cruz).
    * Permite exportar detalles de un caso a JSON y a XRLAT (XML) mediante 
      rutas de la forma casos/1.json y casos/1.xrlat, cambiando 1 por el 
      número de caso (implementado por Luis Alejandro Cruz)
    * Permite exportar varios casos a XRLAT y generalidades a JSON. Puede 
      hacerse desde el listado de casos, Filtro Avanzado seleccionando el 
      filtro por usar, después en Generar Plantilla elegir bien Exportar a 
      XRLAT o bien Exportar a JSON y presionar el botón Generar. También 
      pueden emplearse rutas de la forma `casos.xrlat?utf8=✓&filtro[departamento_id]=5...` y `casos.json?utf8=✓&filtro[departamento_id]=5....` 
      Los parámetros para el filtro se documentan en: 
      <https://github.com/pasosdeJesus/sivel2/blob/master/doc/API_casos.md>
      (implementado por Luis Alejandro Cruz)
    * Se moderniza la interfaz de 3 formas: (1) haciendola más adaptable a 
      dispositivos móviles (siguiendo lineamientos de diseño visual de twitter 
      y su librería Bootstrap 4), (2) permitiendo personalizar el color de más 
      elementos visuales mediante temas y (3) posibilitando el uso de 
      librerías javascript más recientes. Ver <https://github.com/pasosdeJesus/sip/wiki/Actualizaci%C3%B3n-de-sip-2.0b6-a-sip-2.0b7>   
    * Tema con color en más elementos
    * Se arreglaron fallas 
    * Se ampliaron pruebas de regresión y del sistema con sideex (Implementado por Luis Alejandro y por Blanca Acosta).




## 4. FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en ocasiones en 
	<http://drive.google.com>
  por esto sigue incluyendose firefox que en casos como ese puede operar,
  pero no en otros.

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
		setxkbmap latam
```
