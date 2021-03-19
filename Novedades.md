# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.8
Fecha de publicación: 23/Mar/2021

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-6.8-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.8-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync y actualizar un adJ ya instalado (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/6.8-extra/> es 
  directorio con versiones recientes de paquetes no incluidos en distribución 
  oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarollo/AprendiendoDeJesus-6.8-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-6.8-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.8-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.8 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/68.html> y de 
<https://home.nuug.no/~peter/openbsd_and_you_68/#1>

* Aplicados parches de seguridad hasta el 12.Mar.2021 provenientes de 
  OpenBSD que incluyen solución a fallas de OpenSMTPD y sysctl
* Controladores ampliados o mejorados para amd64
	* Red:
		* Inalámbrica: Soporte para TP-Link TL-WN822N-EU v5 (y v4) en `urtwn`.
    Soporte para AP6359SA y otras variantes de BCM4359 SDIO en `bwfm`.
		* Ethernet: Soporte para BCM5719A1 en `bge`. Habilitadas
    varias colas tx/rx con condensado RSS Teplitz en 
    `vmx`, `ix` e `ixl`.  Soporte para RK3308 en `dwe`. 
    Soporte para RTL8125B en `rge`. Soporte para ConnectX-6 Dx y para VLANs y
    otras mejoras a `mcx`
	* Vídeo: Se mejoró ampliamente el código DRM. Como indica
    <https://undeadly.org/cgi?action=article;sid=20200608075708> ahora 
    `amdgpu` soporta vega20, raven2, renoir, navil10 y navil4, mientras que 
    `inteldrm` soporta icelake y tigerlake.
	* Sonido: Nuevos controladores genéricos `simpleaudio` y `simpleamp`.
	* Sensores y otros: Soporte para sensores de temperauta RK3308 en `rktemp`.
  Soporte para touchpad Elantech v1 en `pms`. Mejorado soporte para
  touchpad de varios portatiles Dell Latitude en `imt`.

* Mejoras a herramientas de Red
  * Nuevo protocolo WireGuard para VPNs en kernel (antes había implementación
  en portes) mediante el seudo-dispositivo `wg`.
  * Mejoras a `tcpdump` y `pppoe`
  * Mejoras a SMP en la pila de red.

* Seguridad
	* Más programas del sistema base y portes usan `unveil`.
	* Más mitigaciones a fallas en CPUs Intel
	* Incluye LibreSSL 3.2.2 con TLSv1.3 habilitado.  Nuevo validador de cadenas 
    de certificados X509
	* Incluye OpenSSH 8.4
* Otros
  * `login_ldap` añadido a base. Con este es posible autenticar usuarios
    que no tengan cuenta en el sistema sino en un directorio LDAP.
  * Ahora pueden leerse contadores de tiempo desde el ambiente del usuario
  sin hacer llamadas al sistema, lo que hace más veloz la operación de 
  varias aplicaciones comos suits de oficina,  `mplayer` y navegadores. Ver
  <https://undeadly.org/cgi?action=article;sid=20200708055508>
  * Cambio en el sistema de archivos de FFS1 (Fast File System) a 
    FFS2 (Enhanced Fast File System). Puede determinar
    el tipo de sistema de archivos que tiene con: `dumpfs /dev/rsd2a | head -1`
    cambiando el dispositivo por la subpartición que va a examinar. 
    En OpenBSD/adJ 6.8 tanto el instalador como `newfs` por omisión 
    formatean en FFS2 (podría formatearse en FFS1 con la opción `-O1`).
    Las principales ventajas de FFS2, mencionadas en
    <https://undeadly.org/cgi?action=article;sid=20200528091634>, son:
    * Soporta particiones de más de 1TB
    * Es más rápido que FFS1 al crear y al chequear (con `fsck`)
    * Usa marcas de tiempo y bloques de 64 bits, así que maneja fechas
      posteriores a 2038 y particiones mucho más grandes.
    * En todo caso las particiones muy grandes requieren mucho tiempo para
      chequearse.
    * No hay herramienta para convertir entre FFS1 y FFS2 --debe respaldar 
      toda la información y formatear.
* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm` 10.0.1,  `Xenocara` (basado en `Xorg` 7.7),
  `perl` 5.30.3
* El repositorio de paquetes de OpenBSD cuenta con 11234 para amd64


### 2.2 Paquetes 

* Ruby 3.0.0 retroportado de current.  Ver novedades completas en 
  <https://www.ruby-lang.org/es/news/2020/12/25/ruby-3-0-0-released/>, unas
  que nos parecen destacadas:
  * Es más rápido que Ruby 2, con algunas cargas de trabajo que ejecuten 
    muchas veces unos pocos métodos.
  * Nuevos mecanismos de concurrencia: Ractor y planificador de fibras.
  * Introduce una notación para especificar tipos y hacer chequeo estático 
    de tipos
* Postgresql 13.1 tomado de correos a ports-openbsd
* Veracrypt 13.1 tomado de correos a ports-openbsd
* Recompilados portes estables más recientes para evitar fallas de seguridad 
  de: dovecot, mutt, oniguruma, php
* Algunos paquetes típicos y su versión: dovecot 2.3.11.3, 
  chromium 85.0.4183.121, firefox 81.0 , libreoffice 7.0.1.2, 
  nginx 1.18.0, mariadb 10.5.5, node 12.16.1, python 3.8.6, neovim 0.4.4, 
  zsh 5.8p0


## 3. NOVEDADES RESPECTO A ADJ 6.7 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada: 
	* `basico_adJ`: Aumentada Sección 2.3, “Uso de zsh como interprete de ordenes” 
	* `usuario_adJ`: Actualizada información de modo UEFI y FFS2 en Sección 1,
    “Sobre la instalación”, Sección 4.3, “Discos duros” y Sección 5,
    “Instalaciones duales”.
	* `servidor_adJ`: Mejorada Sección 5.4, “Servidor ldapd”

### 3.2 Paquetes

* El paquete `evangelios_dp` ahora incluye concordancia Strong del 
  evangelio de Juan.
* Compiladas versiones más recientes de `ocaml` (4.10.2), `hevea`, 
  `ocamlbuild` y `ocaml-camlp4`
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Retroportados y adaptados de OpenBSD-current 
  * `chromium` x85.0.4183.121 con llave para API de Google de Pasos de Jesús 
     en lugar de OpenBSD
* Se incluye la versión beta 14 de `sivel2` cuyas novedades con respecto al 
  beta 12 incluido en adJ 6.7 se describen a continuación. Agradecimiento por
  algunas de las novedades a Luis Alejandro Cruz:
  * Mejoras en consultas
    * En listado de casos el filtro avanzado, ahora los usuarios autenticados 
      pueden buscar víctimas colectivas.
    * En listado de casos ahora se ven víctimas colectivas y víctimas 
      combatientes en la columna víctimas y se ven tipificaciones colectivas 
      y tipificaciones de combatientes en la columna tipificación.
    * En listado de casos el filtro avanzado que permita buscar varios 
      presuntos responsables (así como permite buscar varias categorías
      de violencia).
    * En listado de casos al usar simultáneamente filtro avanzado y el
      filtro básico la consulta ahora tiene en cuenta ambos (antes sólo
      tenía en cuenta el filtro básico).
    * API pública `casos.json` ampliada para incluir opcionalmente información 
      de departamento, municipio y descripción del caso. Nueva ruta para la 
      API pública `casos/cuenta.json` que retorna conteos de casos en un rango
      de fechas.
  * Mejoras en sistematización y en importación 
    * En el formulario de un caso, en la pestaña ubicación al elegir
      un centro poblado aparece automaticamente el tipo de centro poblado
    * Al importar un caso ahora si registra ubicación principal. Tras la 
      importación de un nuevo caso ahora (1) agrega a la bitácora una 
      entrada con operación importar, (2) agrega al caso la etiqueta 
      IMPORTA_RELATO, (3) presenta listado de casos importados con todas 
      las columnas. 
  * Mejoras en reportes 
    * Se incluye comienzo de una plantilla para generar en una hoja de
      cálculo el listado de víctimas y casos como el de la revista Noche
      y Niebla. 
    * Para usarlo filtre el listado de víctimas y casos para que no sean
      tantos registros y en la parte inferior en el selector de plantilla
      elija 
    * Reporte de Casos y Víctimas.
  * Control de acceso y bitácoras
    * Refina el control de acceso: no autenticados sólo pueden ver
      reporte revista cuando la consulta web es pública.
    * Ahora los registros de la bitácora de cambios se ordenan por
      fecha de reciente a antiguo (visible para administradores
      desde Administrar->Bitacora).


### 3.3 Configuración
* Es sencillo emplear como interprete de ordenes zsh con tmux para
  tener varias terminales y neovim como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_8/arboldd/usr/local/share/adJ/archconf/README.md>

## 4. FE DE ERRATAS

- Chromium sigue siendo inestable por ejemplo en ocasiones en 
  <http://drive.google.com>
  por esto sigue incluyendose firefox que en casos como ese puede operar.

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```

## 5. SI QUIERE AYUDARNOS

* Agradecemos sus oraciones.
* Si tiene una cuenta en github por favor póngale una estrella al
  repositorio <https://github.com/pasosdeJesus/adJ/>
* Le invitamos a patrocinar nuestro trabajo empleando el botón
  Patrocinar (__Sponsor__) de <https://github.com/pasosdeJesus/adJ/>
* También puede donarnos para recibir una USB para instalar la
  versión más reciente de adJ o alguno de los servicios de Pasos
  de Jesús desde <https://www.pasosdeJesus.org>
* Agradecemos su ayuda mejorando este sitio, la documentación
  para usuario final y la documentación técnica.
* Agradecemos su ayuda traduciendo a español páginas del
  manual desde: <https://hosted.weblate.org/projects/adj/>
* Agradecemos su ayuda en el desarrollo que llevamos
  en <https://github.com/pasosdeJesus/adJ/>

