# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.5p1
Fecha de publicación: 14/Ene/2020

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_5/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-6.5p1-amd64.iso> es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.5p1-amd64/> es directorio con el contenido del DVD instalador apropiado para descargar con rsync y actualizar un adJ ya instalado (ver  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_5/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.5-extra/> es directorio con versiones recientes de paquetes no incluidos en distribución oficial (pueden no estar firmados y requerir instalación con `pkg_add -D unsigned _paquete_`).


## 2. NOVEDADES RESPECTO A ADJ 6.4 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

* Aplicados parches de seguridad hasta el 3.Ene.2020 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidades en CPU.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Mejoras a `athn`, `bwfm`, 
			`iwn` ahora autojoin debe incluir ""
 		        explicitamente para conectar a red abierta desconocida
		* Ethernet: Nuevo `ixl` para Intel Ethernet 700.
		  `alc` ahora soporta QCA AR816x/AR817x 
		* USB y modems: Nuevo `uxrcom` para adaptadores USB
		  seriales Exar XR21V1410
	* Sensores y otros: Nuevo `abcrtc` para relojes Abracon AB1805.
 	  Mejorad `nmea` para proveer velocidad  y altitud.
	* Almacenamiento: Controlador `mpii` soporta SAS 3.5 
	
* Mejoras a herramientas de Red
	* Nuevos seudo-dispositivo `bpe` que soportan protocolo Backbone 
	  Povider Edge, útil en vpns y `mpip` que soporta tuneles de 
          capa 2 MPLS IP.
* Seguridad
	* Nuevo protector de pila RETGUARD que instrumetna todo retorno 
	  de funciones con mejores propiedades de seguridad. 
	* Función `unveil` que permite hacer como un chroot pero mejor
	  para cada programa mejorada y aplicada de forma sistemática a
	  diversas utilidades y programas como: `ospfd`, `ospf6d`, `rebound`, 
	  `getconf`, `kvm_mkdb`, `bdftopcf`, `Xserver`, `passwd`, `spamlogd`, 
	  `spamd`, `sensorsd`, `snmpd`, `htpasswd`, `ifstated`. 
	* Incluye OpenSSH 8.0
	* Incluye LibreSSL 2.9.3
* Otros
	* Enlazador (linker) por omisión ahora es `lld` (de LLVM) en 
	  lugar del basado en binutils bfd (de GNU)
	* Incluye fuentes de OpenRsync, nueva implementación de `rsync`
	  con licencia ISC

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 7.0.1,  ```Xenocara``` (```Xorg```) 1.19.7, 
  ```perl``` 5.28
* El repositorio de paquetes de OpenBSD cuenta con 10605 para amd64


### 2.2 Paquetes 

* Entre los paquete agregados resaltamos `rdesktop`
* Entre los paquetes retirados resaltamos `abiword`, `texlive_texmf_minimal`, 
  `gcc` y `GeoIP`
* Recompilados portes estables más recientes para evitar fallas de seguridad: 
   `cups`, `curl`, `cups`, `dovecot`, `gvfs`, `libgcrypt`, `mpg123`, `php-7.1`
   `webkitgtk4`
* Postgresql 11.6 retroportado de 6.6 (en adJ soporta bien cotejaciones en español)
* nginx 1.16.1 retroportado de 6.6
* Ruby 2.6.5 retroportado de 6.6. A su vez incluye retroporte para Ruby 2.7 
  de solución de Jeremy Evans a falla con `realpath` para permitir usar 
  `unveil` y de hecho hay 2 gemas que lo usan: 
  <https://github.com/jcs/ruby-unveil> y 
  <https://github.com/jeremyevans/ruby-pledge>.
* Ocaml fue actualizado a la versión 4.0.7 que renombra la librería
  `pervasives` por `stdlib` y que separa `String` de `Bytes` siendo 
   mutable sólo el segundo. `Bytes` ofrece las funciones `Bytes.to_string` y 
  `Bytes.of_string` que facilitan portar fuentes existentes.
* La librería `icu4c` fue actualizada a la versión 63.1. Esta versión 
  y/o clang son más exigente en espacio de nombres. Ha resultado típico 
  tener que cambiar por ejemplo `UnicodeString` por `icu::UnicodeString` 
  en portes que la usan 


## 3. NOVEDADES RESPECTO A ADJ 6.4 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Instalador sigue en español pero ahora con codificación ASCII y no 
  ISO8859-1 ni UTF-8, que no son soportadas en tiempo de instalación 
  para mantener un instalador pequeño.
* Documentación actualizada: `basico_adJ`, `usuario_adJ` y `servidor_adJ`
* Como medio de instalación además de la imagen para quemar en CD-ROM 
  (`AprendiendoDeJesus-6.5p1-amd64.iso`) ahora se distribuye una
  imagen que se puede escribir en una memoria USB y arrancar con
  esta 
	<http://adj.pasosdejesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-6.5p1-amd64.usb> 
  Una vez la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (remplace ese dispositivo por el de su USB una vez lo verifique con 
  `dmesg`):

 	doas dd if=AprendiendoDeJesus-6.5p1-amd64.usb of=/dev/sd2c bs=1M

 O si desea probarla con qemu para instalar en un disco virtual.raw:

  	qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-65p1-amd64.usb -boot menu=on


### 3.2 Paquetes

* Se han recompilado los siguientes para aprovechar `xlocale`: `libunistring`, 
  `vlc`, `djvulibre`, `gettext-tools`, `gdk-pixbuf`, `glib2`, `gtar`, 
  `libidn`, `libspectre`, `libxslt`, `scribus`, `wget`
* Recompilados muchos paquetes de Perl que ahora son requeridos por 
  `SpamAssassin` y al igual que otros de perl se recompilaron (sin cambiar 
  de versión) con el perl de adJ que si soporta `LC_NUMERIC`.  
* Retroportados y adaptados de OpenBSD-current: 
* `chromium` 75.0.3770 con llave de Pasos de Jesús retroportado de 
  OpenBSD-6.6.
* Paquete obsoleto php-5.6.40: OpenBSD ya no incluye porte para php-5.6.40. 
  Incluimos el que había en adJ 6.4 pero es una versión obsoleta, sin 
  soporte, que puede tener fallas de seguridad como se explica en 
  http://php.net/archive/2019.php#id2019-01-10-4 y 
  http://php.net/archive/2019.php#id2019-01-10
  Tuvo que inclurse porque buena parte e la librería `pear` aún lo requiere 
  (particularmente librerías requeridas por SIVeL 1.2 como `HTML_QuickForm`) 
  aunque por lo visto otras partes de `pear` requieren php-7. También se 
  mantienen versiones obsoletas de paquetes de `pear` que ya no están en 
  OpenBSD como `pear-MDB2` y `pear-DB`.
  Es indispensable el transito a SIVeL 2 porque en futuras versiones de adJ 
  no incluiremos `php-5.6` ni `pear`.
  Además `php-5.6` tuvo que parcharse masivamente para que operara con 
  el nuevo `icu4c`.
  Para que opere SIVeL 1.2 en esta versión inst-adJ.sh configurará por omisión 
  php-5.6.40 que es el requerido por `HTML_QuickForm` usando el script 
  `php56_fpm`, la configuración `/etc/php-fpm.conf` y el socket 
  `/var/www/var/run/php-fpm.sock`.
  Si en un servidor necesita correr SIVeL con PHP 5 y otra aplicación con 
  PHP 7, la sugerencia es modificar `/etc/rc.d/php71_fpm` para que emplee un 
  segundo archivo `/etc/php71-fpm.conf` que ubique el socket para
  php 7 en otro directorio (el paquete de php-7.1 se ha modificado para 
  facilitarlo).
  Otras extensiones no incluidas como de costumbre se dejan en el sitio de 
  distribución en el directorio extra-6.5
* Para minar monero se remplaza `xmr-stak` por `xmrig` 	
* Se parchan y compilan portes más recientes de:
	* `sword` (que ahora emplea `clang` e `icu` recientes),
	*  `biblesync` y `xiphos` (ahora se compilan con `clang++`),
	*  `markup`,  `repasa` y `sigue` (fueron modificados para emplear 
	   las nuevas convenciones de Ocaml 4.0.7), pero estamos considerando
	   retirarlos en un próxima versión de adJ por no conocer usuarios.
* Se incluye beta 10 de `sivel2` cuyas novedades principales respecto al beta 8 son:
	* Más reportes y conteos: Listado de víctimas y casosi,  Reporte revista, Conteo de victimizaciones individuales, Reporte General.
	* Actualización del DIVIPOLA a la versión oficial del 2018. Ver cambios buscando 2018 en campo Observaciones de Municipios y Centros Poblados. Resumen ejecutivo en: https://github.com/pasosdeJesus/sivel2/wiki/Resumen-ejecutivo-de-la-actualizaci%C3%B3n-a-DIVIPOLA-2018
	* Ahora al elegir una ubicación se puede especificar si es la principal.
	* Se han implementado 12 de las 21 validaciones de SIVeL 1.2 y otra nueva, así como detector de casos repetidos.
	* Mapa de casos sobre OpenStretMap con filtro, acumulados de casos 
	(clusters) y nuevas posibilidades con capas: elegir capa base, 
	superponer una capa con transparencias, cargar pequeñas capas 
	GeoJSON y de exportar la capa de casos en GeoJSON.  Ver pantallazos 
	en <https://github.com/pasosdeJesus/sivel2_gen/blob/master/doc/mapas.md>
	* Exportación  de casos a a JSON y XRLAT (XML)
	* Se moderniza la interfaz de 3 formas: (1) haciendola más adaptable 
	  a dispositivos móviles (siguiendo lineamientos de diseño visual de 
	  twitter y su librería Bootstrap 4), (2) permitiendo personalizar el 
	  color de más elementos visuales mediante temas y (3) posibilitando 
	  el uso de librerías javascript más recientes. Ver 
	  https://github.com/pasosdeJesus/sip/wiki/Actualizaci%C3%B3n-de-sip-2.0b6-a-sip-2.0b7 
	* Temas con colores para bastantes elementos de la interfaz.
	* Resueltas fallas y pruebas de regresión mejoradas y ampliadas.

* Incluye SIVeL 1.2.8 que es última versión de la serie 1.2 y cuyas novedades son:
	* Al validar incluye entre los casos vacios los que tengan memo de 
	   menos de 30 caracteres.
	* En consulta web los usuarios autenticados pueden buscar por 
	  categorias deshabilitadas.


## 4. FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en ocasiones en <facebook.com>
  por esto sigue incluyendose firefox que en casos como ese puede operar,
  pero no en otros.

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
		setxkbmap latam
```
