# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.5b2
Fecha de publicación: 22/Ago/2019

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_5/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.5b2-amd64.iso> es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.5b2-amd64/> es directorio con el contenido del DVD instalador apropiado para descargar con rsync y actualizar un adJ ya instalado (ver  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_5/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.5-extra/> es directorio con versiones recientes de paquetes no incluidos en distribución oficial (pueden no estar firmados y requerir instalación con `pkg_add -D unsigned _paquete_`).


## 2. NOVEDADES RESPECTO A ADJ 6.4 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

* Aplicados parches de seguridad hasta el 9.Ago.2019 provenientes de 
  OpenBSD que incluyen mitigación a vulnerabilidades en CPU.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Mejoras a `athn`, `bwfm`, 
			`iwn` Lista autojoin debe incluir ahora ""
 		        explicito para conectar a red abierta desconocida
		* Ethernet: Nuevo `ixl` para Intel Ethernet 700.
		  `alc` ahora soporta QCA AR816x/AR817x 
		* USB y modems: Nuevo `uxrcom` para adaptadores USB
		  seriales Exar XR21V1410
	* Sensores y otros: Nuevo `abcrtc` para relojes Abracon AB1805.
 	  Mejorad `nmea` para proveer velocidad  y altitud.
	* Almacenamiento: Controlador `mpii` soporta SAS 3.5 (SAS34xx and 
	
* Mejoras a herramientas de Red
	* Nuevos seudo-dispositivo `bpe` que soporta protocolo Backbone 
	  Povider Edge, útil en vpns y `mpip` que soporta tuneles de 
          capa 2 MPLS IP.
* Seguridad
	* Nuevo protector de pila RETGUARD que instrumetna todo retorno 
	  de funciones con mejores propiedades de seguridad. 
	* Incluye OpenSSH 8.0
	* Incluye LibreSSL 2.9.3
* Otros
	* Enlazador (linker) por omisión ahora es lld (de LLVM) en 
	  lugar del basado en binutils bfd (de GNU)
	* Incluye fuentes de OpenRsync, nueva implementación de rsync
	  con licencia ISC

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, ```llvm``` 7.0.1,  ```Xenocara``` (```Xorg```) 1.19.7, 
  ```perl``` 5.28
* El repositorio de paquetes de OpenBSD cuenta con 10605 para amd64


### 2.2 Paquetes 


* Entre los paquetes retirados resaltamos abiword, 
  texlive_texmf_minimal, gcc y GeoIP
* Entre los paquete agregados resaltamos rdesktop y muchos paquetes
  de Perl que ahora son requeridos por SpamAssassin 
* Recompilados de portes más recientes para evitar fallas de seguridad: 
	d...
* Retroportados y adaptados de current: 
	* ruby 2...
	* chromium ...
	* PostgreSQL actualizado a .. que tiene entres sus novedades:...
	* curl...
* Se han recompilado los siguientes para aprovechar xlocale: libunistring, 
  vlc, djvulibre, gettext-tools, gdk-pixbuf, glib2, gtar, libidn, 
  libspectre, libxslt, scribus, wget, wxWidgets-gtk2
* Ocaml fue actualizado a la versión 4.0.7 que renombra la librería
  pervasives por stdlib y que separa String de Bytes siendo mutable sólo 
  el segundo. Bytes ofrece las funciones Bytes.to_string y 
  Bytes.of_string que facilita portar fuentes existentes.
* La librería icu4c fue actualizada a la versión 63.1. Esta versión 
  es más exigente en espacio de nombre, ha resultado típico tener que
  cambiar por ejemplo UnicodeString por icu::UnicodeString en portes que la 
  usan 



## 3. NOVEDADES RESPECTO A ADJ 6.4 PROVENIENTES DE PASOS DE JESÚS

* Instalador ...


* Paquetes actualizados:
	* php 
		OpenBSD ya no incluye porte para php-5.6.40. 
		Incluimos el que había en adJ 6.4 pero es una versión
		obsoleta, sin soporte, que puede tener fallas de 
		seguridad como se explica en 
		http://php.net/archive/2019.php#id2019-01-10-4 y 
		http://php.net/archive/2019.php#id2019-01-10
		Tuvo que inclurse porque buena parte e la librería pear 
		aún requiere php-5.6 (incluyendo partes requeridas por 
		SIVeL 1.2 como `HTML_QuickForm`) aunque al parecer otras 
		partes de pear requieren php-7. También se mantiene
		versiones obsoletas de paquetes de pear que ya no están
		en OpenBSD como `pear-MDB2`.
		Es indispensable el transito a SIVeL 2 porque en
		futuras versiones de adJ buscaremos no incluir
		`php-5.6` ni `pear`.
 		Además `php-5.6` tuvo que parcharse masivamente para que 
		operara con nuevo `icu4c`.
		Para que opere SIVeL 1.2 en esta versión inst-adJ.sh
		configurará por omisión php-5.6.40 que es el requerido 
		por `HTML_QuickForm` usando el script `php56_fpm`, la 
		configuración /etc/php-fpm.conf y el socket 
		/var/www/var/run/php-fpm.sock.
		Si en un servidor necesita correr SIVeL con PHP 5 y otra
		aplicación con PHP 7, la sugerencia es modificar 
		/etc/rc.d/php71_fpm para que emplee un segundo
		archivo /etc/php71-fpm.conf que ubique el socket para
		php 7 en otro directorio (el paquete de php-7.1 se ha 
		modificado para facilitarlo).
		Otras extensiones no incluidas como de costumbre se 
		dejan en el sitio de distribución en el directorio 
		extra-6.5
	- Para minar monero se remplaza `xmr-stak` por `xmrig` 	
	- Se recompilaron todos los paquetes de perl (sin cambiar de 
	  versión) con el perl de adJ que soporta `LC_NUMERIC`.  
	- Se parchan y compilan portes más recientes de:
	  `sword` (que ahora emplea `clang` e `icu` reciente),
	  `biblesync` y `xiphos` (ahora se compilan con `clang++`),
	  `markup`,  `repasa` y `sigue` (fueron modificados para emplear 
	   las nuevas convenciones de Ocaml 4.0.7)

* Documentación actualizada: `basico_adJ`, `usuario_adJ` y `servidor_adJ`

* Se incluye beta 9 de `sivel2` cuyas novedades respecto al beta 8 son:
  * ...
* Incluye SIVeL 1.2.8 que es última versión de la serie 1.2


## 4. FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en ocasiones en facebook.com
  por esto sigue incluyendose firefox que en casos como ese puede operar.

- `xenodm` no logra utilizar un teclado latinoamericano.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:

		setxkbmap latam

