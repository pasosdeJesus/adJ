# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.0
Fecha de publicación: 26/Feb/2022

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_0/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en: 
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/>

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.0-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.0-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync desde un adJ o un OpenBSD ya instalado para actualizarlo (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_0/Actualiza.md> )
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.0-extra/> 
  es directorio con versiones recientes de paquetes no incluidos en 
  distribución oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).
* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.0-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-7.0-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.0-amd64.usb -boot menu=on


## 2. NOVEDADES RESPECTO A ADJ 7.0 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/70.html> 

* Aplicados parches de seguridad hasta el 24.Feb.2022 provenientes de 
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * CPU: Se puede habilitar modo turbo poniendo hw.setperf en 100 (su operación
    normal es en 99). Corrección a fallas con TLB.
  * Tarjetas Ethernet: Ampliado `re`  para soportar 
    RTL8168FP/RTL8111FP/RTL8117, Ampliado 
    `brgphy` para soportar BCM5725. Nuevo controlador `aq` para tarjetas
    PCI Express Ethernet 10G Aquantia.  Nuevo controlador `uaq`  para
    tarjetas USB Ethernet Aquantia AQC111U/AQC112U.
  * Tarjetas inalámbricas: Mejorados controladores `iwm`, `iwx` y
    `bwfm`
  * Video: Actualizados drm, inteldrm y amdgpu para soportar mejor Tiger Lake,
    Navi 12, Navi 21 "Sienna Cichlid", Arcturus y Cezanne "Green Sardine" Ryzen
    5000 APU
  * Sonido: Mejorado `azalia` con X1 Extreme Gen 1, Thinkpad X1 Extreme, 
  * Sensores y otros: Controlador `cy` para boards multipuertos seriales 
    Cyclom-4Y, Cyclom-8Y y Cyclom-16Y.
* Mejoras a herramientas de Red
  * OpenSMTDP 7.0.0
  * Mejoras a bgpd, pf e IPSEC
  * DHCP ahora es manejado por dhcpleased
* Seguridad
  * ssh actualizado a la versión 8.8 que por ejemplo deshabilita firmas RSA
    que usan condensados SHA-1. Avanza en remplazar SCP/RCP con SFTP cuando
    se use scp.
  * libressl actualizado a la versión 3.4.1 que amplió el API para soportar
    OpenSSL 1.1.1 TLSv1.3 y habilita un nuvo validador X.509
* Otros
  * Seudo-dispositivo `dt` habilitado de manera predeterminada y 
    la herramienta asociada `btrace` mejorada para pemitir
    depuración dinámica del kernel. 
  * Mejoras a SMP por ejemplo eliminando candados en algunas operaciones
  * Mejoras a VMM/VMD
  * Mejoras a tmux

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm 11.1.0`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.32` 
* El repositorio de paquetes de OpenBSD cuenta con 11325 para amd64


### 2.2 Paquetes 

* Para cerrar fallas se usan las versiones más recientes preparadas
  por OpenBSD de: `zsh`, `node`, `php`, `libxml`, `libxslt`, 
  `gnutls`, `firefox-esr`, `samba`, `colorls`, `quirks`,
  `webkitgtk4`

* Algunos paquetes típicos y su versión: `dovecot 2.3.16p1v0`,
  `chromium 93.0.4577.82p1`, `firefox-esr 91.6.0`, `libreoffice 7.2.1.2v0`,
  `nginx 1.20.1p0`, `mariadb 10.6.4p2v1`, `node 12.22.9p0`, `python 3.8.12`,
  `neovim 0.5.0`, `zsh 5.8.1`


## 3. NOVEDADES RESPECTO A ADJ 6.9 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada 
	* `basico_adJ`: 
    <http://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ` 
    <http://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`: 
    <http://pasosdejesus.github.io/servidor_adJ>

### 3.2 Paquetes

* Chromium recompilado con llave de Pasos de Jesús.  Ahora permite autenticar
  y usar sitios como https://drive.google.com  --si tiene problemas para
  autenticarse intente desde un nuevo perfil .
* Además de chromium incluimos `firefox-esr` que también ha resultado
  bastante estable.

* Se incluye la versión 2.0  de `sivel2` cuyas novedades con respecto al 
  beta 16 incluido en adJ 6.9 se describen a continuación. Agradecimiento por
  algunas de las novedades a Luis Alejandro Cruz:
  * Mejoras en consultas, reportes y conteos
    *
  * Mejoras en sistematización y en importación 
    *
  * Tablas básicas
    * 
  * Mejoras al diseño visual con actualización a Bootsrap 5:
    * 
* evangelios 0.9
* Adaptados de propuestas de portes para OpenBSD-current:
  * `postgresql 14.2`
  * `ruby-3.1.1`
* Portes más actualizados que los disponibles en OpenBSD:
  * `ocaml 4.12`, `ocamlbuild`, `findlib`, `dune`, `hevea`, `postgis`
* Se han recompilado los siguientes para aprovechar `xlocale`:
   `glib2`, `libunistring`, `vlc`

### 3.3 Configuración

* Es sencillo emplear como interprete de ordenes `zsh` con `tmux` para
  tener varias terminales y `neovim` como editor con archivos de 
  configuración incluidos en adJ e instrucciones en:  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_0/arboldd/usr/local/share/adJ/archconf/README.md>

## 4. FE DE ERRATAS

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
* Agradecemos su ayuda en el desarrollo de fuentes abiertas que llevamos
  en <https://github.com/pasosdeJesus/adJ/>

