# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 6.7
Fecha de publicación: 5/Oct/2020

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_7/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-6.7-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.7-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync y actualizar un adJ ya instalado (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_7/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/6.7-extra/> es 
  directorio con versiones recientes de paquetes no incluidos en distribución 
  oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-6.7-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-6.7-amd64.usb of=/dev/sd2c bs=1M

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-6.7-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 6.6 PROVENIENTES DE OPENBSD

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
	* Vídeo: Nuevo controlador `amdgpu` que soporta AMD Radeon GPU.
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
	  con `nwflag` y `mode` para establecer modos 11a/b/g/n.
	* Soporte para examinar y establecer rxprio vía `ifconfig` según
	  RFC 2983. Agregado a `vlan`, `gre`, `mpw`, `mpe`, `mpip`, 
	 `etherip` y `bpe`.
	* Nuevo cliente `snmp` compatible con netsnmp y eliminado `snmpctl`
	* Diversas mejoras a `bgpd`
	* Mejoras a `relayd` en particular ahora soporta SNI
	* `acme-client` ahora soporta la API de Let's Encrypt v02.
	* Varias mejoras a OpenSMTPD 6.6.0 en particular posibilidad
	  de configurar filtros y operar detras de un proxy.

* Seguridad
	* Función `unveil` usada en 77 programas en zona de usuarios para 
	  restringir acceso al sistema de archivos (como `chroot` pero mejor).
	  Y ahora `ps` puede mostrar que procesos usaron `unveil` y `pledge`
	* Se añade soporte para el Protocolo Generador de Números Aleatorios 
	  EFI
	* Incluye OpenSSH 8.1
	* Incluye LibreSSL 3.0.2
* Otros
	* Diversas mejoras a `tmux`

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm` 8.0.1,  `Xenocara` (basado en `Xorg` 7.7),
  `perl` 5.30.2
* El repositorio de paquetes de OpenBSD cuenta con 11268 para amd64


### 2.2 Paquetes 

* Recompilados portes estables más recientes para evitar fallas de seguridad de : 
    `certbot`, `curl`, `dovecot`, `gettext-tools`, `libidn2`, `librsvg`,
    `oniguruma`, `python`, `pcre2`, `unzip` y `webkitgtk4`
* Ruby 2.7.1 retroportado de current
* Algunos paquetes típicos y su versión: dovecot 2.3.10, chromium 81.0.4044
  firefox 76.0 , libreoffice 6.4.3.2, nginx 1.16.1p1, mariadb 10.4.12v1,
  node 12.16.1, postgresql 12.3, python 3.7.9, ruby 2.7.1p0, vim 8.2.534,
  neovim 0.4.3, zsh 5.8


## 3. NOVEDADES RESPECTO A ADJ 6.6 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación
* Segunda etapa de instalador con `inst-adJ.sh` simplificada quitando 
  preguntas sobre PHP y sobre cifrado.   Por lo visto el cifrado con 
  `vnconfig` tiene problemas desde OpenBSD 6.6 y no serán solucionados.  
  Ahora se recomienda cifrado con `softraid`.  No hay un procedimiento
  automático para pasar de `vnconfig` a `softraid`, pero recomendamos 
  enfáticamente realizar el cambio siguiendo instrucciones de:
  <https://pasosdejesus.github.io/usuario_adJ/ar01s03.html#idm3197209600>
* Documentación actualizada: 
	* `basico_adJ`: Nueva sección sobre el uso de zsh como interprete de ordenes
	* `usuario_adJ`: Nueva sección sobre cifrados con softraid
	* `servidor_adJ`: Nueva sección sobre Jaula sftp.

### 3.2 Paquetes

* Ahora se incluyen paquetes `zsh`, `neovim` y `rcm` así como unos
  archivos de configuración para sustituir la pila de edición en consola:
  `tmux`+`pdksh`+`vim` por `rcm`+`tmux`+`zsh`+`neovim`.  
  Estos archivos de configuración se basan en los dotfiles de Thoughtbot 
  (ver <https://github.com/thoughtbot/dotfiles>) y quedarán en el directorio 
  `/usr/local/share/adJ/archconf`. Para adoptar esta nueva pila de edición
  en consola siga las instrucciones disponibles en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_7/arboldd/usr/local/share/adJ/archconf/README.md>
* Nueva versión 1.0a5 del motor de búsqueda Mt77 que ahora emplea
  la codificación UTF-8 internamente y como codificación por omisión
  en las diversas herramientas. Mantiene soporte para codificación 
  Latin1 con opción `-l` del indexador de textos planos y del buscador.
  Agradecemos el trabajo de Daniel Hamilton-Smith.
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`
* Retroportados y adaptados de OpenBSD-current 
  * `chromium` 81.0.4044-138 con llave de Pasos de Jesús
* Se incluye la versión beta 12 de `sivel2` cuyas novedades con respecto al 
  beta 10 includo en adJ 6.6 se describen a continuación. Agradecimiento por
  varias de  las novedades a Luis Alejandro Cruz:
    - Control de acceso mediante grupos. 
    - Cada caso tiene una bitácora de cambios que puede verse desde el 
      resumen del caso en una sección colapsable o por parte de 
      administradores en `Administrar->Bitácora`
    - Más posibilidades de sistematizar en formulario de caso: (1) Nueva 
      tabla básica Contexto de una víctima (por ejemplo FALSO POSITIVO) y 
      campo en la pestaña Víctima del formulario Casos que permite ponerle 
      contexto a una víctima. (2) En pestaña víctima, puedan agregarse 
      familiares, de forma similar a la de SIVeL 1.2, pero con 
      autocompletación de nombre. (3) Posibilidad de añadir varios sectores 
      sociales secundarios a una víctima individual. (4) En pestaña víctima 
      colectiva ahora se pueden especificar las etnias, y se presentan en 
      el resumen del caso.  
    - Mejores listados y reportes: (1) En listado de casos, el filtro 
      avanzado ahora presenta nuevos criterios a usuarios autenticados: 
      filtro por profesión, sector social y organización. (2) Posibilidad 
      de presentar al público general hasta 2000 casos en el listado de casos 
      y en el mapa cuando un administrador del servidor lo configura en 
      fuentes (en `config/application.rb` con
      `config.x.sivel2_consulta_web_publica = true`). (3) En filtro avanzado 
      ahora los usuarios autenticados puede buscar por contexto de caso y 
      por contexto de víctima. (4) Desde el listado de casos, Filtro avanzado, 
      nuevo reporte "Revista no bélicas HTML", que se comporta como reporte 
      revista pero que excluye casos con categorías de tipo Bélicas. 
    - Mejoras en usabilidad: (1) Al intentar eliminar un Presunto Responsable 
      con actos asociados, aparece una alerta informando, que permite 
      continuar con la eliminación o cancelarla. (2) Mejoras al conteo 
      general de víctimas para generar una tabla como la de la revista Noche 
      y Niebla más reciente.  (3) En ficha de caso, pestaña ubicación, en 
      nuevas ubicaciones el país ahora comienza por omisión en Colombia.  
      (3) El listado de víctimas y casos, ahora tiene un filtro por cada 
      categoria. (4)  Un administrador puede exportar el listado de usuarios 
      a hoja de cálculo.
     - Actualización del DIVIPOLA a su versión 2019. Hay un resumen ejecutivo en <https://github.com/pasosdeJesus/sip/wiki/Resumen-ejecutivo-de-la-actualizaci%C3%B3n-a-DIVIPOLA-2019>
    - Soluciona diversas fallas incluyendo: (1) Mejorar velocidad al editar 
      cuando un sistema tiene más de 10.000 casos, en tales casos tras editar 
      debe elegirse del menú la opción `Casos`->`Refrescar`. (2) Conteo 
      demografía de víctimas estaba replicando cuando la misma víctima estaba 
      en 2 casos.
    - Características experimentales: (1) Prototipo de importación de casos 
      desde un archivo XML con relatos (XRLAT) desde Casos->Importar de XRLAT. 
      Nueva versión del DTD de Relatos XRLAT. (2) Prototipo de pestaña 
      Desaparición para usuarios del grupo Desaparición



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
* Si tiene una cuenta en github por favor pongale una estrella al
  repositorio <https://github.com/pasosdeJesus/adJ/>
* Le invitamos a patronicar nuestro trabajo empleando el botón
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

