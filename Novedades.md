# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.6b1
Fecha de publicación: 26/Feb/2020

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_6/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.6b1-amd64.iso> es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.6b1-amd64/> es directorio con el contenido del DVD instalador apropiado para descargar con rsync y actualizar un adJ ya instalado (ver  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_6/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.6-extra/> es directorio con versiones recientes de paquetes no incluidos en distribución oficial (pueden no estar firmados y requerir instalación con `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.6b1-amd64.usb> es imagen para escribir en una memoria USB y arrancar
  con esta. Una vez la descargue puede escribirla en una USB ubicada en 
  `/dev/sd2c` (verifiquer dispositivo con `dmesg` y remplace):

	doas dd if=adJ66b1.fs of=/dev/sd2c bs=1M

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

 	qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-65p1-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.5 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

* Aplicados parches de seguridad hasta el 25.Feb.2020 provenientes de 
  OpenBSD que incluyen solución a fallas de OpenSMTPD
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
	* Mejoras a pila inalámbrica general y en particular en `ifconfig` 
	  con `nwflag` y `mode`para poner modo 11a/b/g/n.
	* Soporte para examinar y establecer rxprio via `ifconfig` según
	  RFC 2983. Agregado a `vlan`, `gre`, `mpw`, `mpe`, `mpip`, 
	 `etherip` y `bpe`.
	* Nuevo cliente `snmp` compatible con netsnmp y eliminado `snmpctl`
	* Diversas mejoras a `bgpd`
	* Mejoras a `relayd` en particular ahora soporte SNI
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

* Entre los paquete agregados resaltamos ``
* Recompilados portes estables más recientes para evitar fallas de seguridad: 
   `dovecot`, `gettext-tools`, `libidn2`, `oniguruma`, `pcre2`, `webkitgtk4`
* Postgresql 12.2 adaptado de retrporte de 12.1 de current (en adJ soporta 
  bien cotejaciones en español)
* Ruby 2.7.0 retroportado de current  (incluye solución de Jeremy Evans a 
  falla con `realpath` para permitir usar `unveil` y de hecho hay 2 gemas 
  que lo usan: <https://github.com/jcs/ruby-unveil> y 
  <https://github.com/jeremyevans/ruby-pledge>)


## 3. NOVEDADES RESPECTO A ADJ 6.5 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Instalador sigue en español pero ahora con codificación ASCII y no 
  ISO8859-1 ni UTF-8, que no son soportadas en tiempo de instalación 
  para mantener un instalador pequeño.
* Documentación actualizada: `basico_adJ`, `usuario_adJ` y `servidor_adJ`

### 3.2 Paquetes

* Entre los paquetes retirados resaltamos `markup` que ya no está disponible
  en sitio de distribución y por lo mismo `sigue` y `repasa` que la requerían.
  `SIVeL 1.2` y programas que lo requierían incluyendo `php-5.6.4`.
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Recompilados muchos paquetes de Perl que ahora son requeridos por 
  `SpamAssassin` y al igual que otros de perl se recompilaron (sin cambiar 
  de versión) con el perl de adJ que si soporta `LC_NUMERIC`.  
* Retroportados y adaptados de OpenBSD-current: 
* `chromium` 79.0.3945-117 con llave de Pasos de Jesús retroportado de 
  OpenBSD-current.
* Se parchan y compilan portes más recientes de:
	* `sword` (que ahora emplea `clang` e `icu` recientes),
	*  `biblesync` y `xiphos` (ahora se compilan con `clang++`),
* Se incluye beta 10 de `sivel2`


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
