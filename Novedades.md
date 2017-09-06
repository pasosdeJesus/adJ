# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

### Versión: 6.1b2
Fecha de publicación: 6/Sep/2017

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_1/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A adJ 6.0 PROVENIENTES DE OpenBSD 

# Kernel y Sistema Base

* Parches al sistema basta hasta el 30.Ago.2017 que cierran 16 fallas 
  de seguridad y 11 de robustez.
* syspatch ahora puede actualizar binarios de sistema base para cerrar 
  fallas de robustez y de seguridad.
* Controladores ampliados o mejorados para amd64
	* Red:
		* Ethernet: Nuevo ```dwge``` para Designware GMAC 10/100/Gigabit.   Soporte en ```em``` para MACs Kaby Lake y Lewisburg PCH con PHYs I219. Soport en ```ure``` para dispositivos USB 3.0 Gigabit RTL8153.  Soporte en ```ix``` para la familia X550 de dispositivos 10 Gigabits.
		* Inalámbrica: ```ral``` soporta Ralink RT3900E (RT5390, RT3292).  ```iwm``` y ```iwn``` soportan short guard interval (SGI) en modo 11n.  Nueva implementación de de MiRa, algoritmo de adaptación de rata diseñado para 802.11n.  ```iwm``` ahora soporta MIMO 802.11n (MCS 0-15).  ```athn``` ahora soporta 802.11n con MIMO (MCS 0-15) y modo hostap.  ```iwn``` ahora recibe tramas MIMO en modo monitor.  ```rtwn```y ```urtwn``` usan adaptación de rata AMRR (dispositivios 8188EU y 8188CE).  Por omisión se deshabilitó TKIP/WPA1 por la debilidad inherente de este protocolo.
		* Otros: 
	* Almacenamiento: Nuevo ```octmmc``` para controladores MMC OCTEON.  Nuevo ```sximmc```  para controladores Allwinner A1X/A20 MMC/SD/SDIO.  
	* Interfaces con usuario: Nuevo ```iatp``` para pantaillas y padas tactiles Atmel maXTouch.  Nuevo ```simplefb```  para buffer de frames simple en sistemas que usan árbol de dispositivos. Nuevo ```uwacom``` para tabletas USB Wacom.
	* Virtualización: Nuevo ```acpihve`` que alimenta piscina de entropia del kenerl a partir de Hyper-V. Nuevo ` `hvn``` para interfaces de red Hyper-V.  Nuevo ```hyperv```para dispositivo huesped nexus Hyper-V.  Nuevo interfaz de control ```vmmci```. Nuevo xbf(4) para discos virtuales Xen Blkfront.
	* Sensores y otros: Nuevo ```acpials``` sensor de luz ACPI.  Nuevo ```acpisbs``` para dispositivod de bateria inteligente ACPI. Nuevo ```htb``` para puentes PCI Loongson 3A.   Nuevo ```imxtemp```sensor de temperatura Freescale i.MX6.  Nuevo ```leioc``` para controladores ES Loongson 3A.  Nuevo ```tpm```para dispositivos con Modulos de Plataforma Confiable.
* Virtualización: Operacionales ```vmm```, ```vmd```. Soporta máquinas virtuales invitadas Linux 
* Mejoras a herramientas de Red
	* Nuevo dispositivo ```switch```junto con los programas ```switchd```  y ```switchctl``` que permiten manejar switch lógico con estandar OpenFlow.
	* Mejoras a pf especialmente para el caso IPv6 por ejemplo de acuerdo a RFC 5722 y RFC 8021
	* Mejoras a iked e ikectl, ospfd, ospf6d,  bpgd RFC 8092,
	* Mejoras a dhclient, dhcpd y dhcrelay
	* Nuevo acme-client para manejo automático de certificados SSL 
	* httpd soporta SNI (diversos dominios con SSL sobre la imisma IP)

* Seguridad
	* Más datos de solo lectura tras relocalización (RELRO) en librerías compatidas, dinámicas y el mismo ld.so
	* OpenSSH 7.4
	* LibreSSL 2.5.3 que soporta ALPN  y SNI

* Otros
	* Facil producir páginas del manual en markdown: `mandoc -mdoc -T markdown`

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.24.1, 
  ```nsd``` 4.1.15



# Novedades respecto a paquetes 

ruby 2.4.1 retroportado de Current

Se han actualizado más los binarios de los siguientes paquetes para
cerrar fallas de seguridad (a partir de portes más recientes para 
OpenBSD 6.1 --no incluidos en distribución inicial de binarios):

GeoIP-1.6.5p5.tgz, ImageMagick-6.9.8.3.tgz, abiword-3.0.1p7.tgz, 
at-spi2-core-2.22.1.tgz, chromium-57.0.2987.133, colorls-5.7p2.tgz, 
cups-2.2.3.tgz, cups-filters-1.13.4p0.tgz, curl-7.53.1p0.tgz, 
dbus-1.10.16v0.tgz, djvulibre-3.5.27p0.tgz, dovecot-2.2.28p0.tgz, 
ffmpeg-20170208.tgz, foomatic-db-4.0.20161003p0.tgz, freetds-0.95.95p2.tgz, 
gdal-2.1.3.tgz, gdk-pixbuf-2.34.0.tgz, gettext-tools-0.19.7p1.tgz, 
ghostscript-9.07p4.tgz, gimp-2.8.18p4.tgz, glib2-2.48.1.tgz, 
gnumeric-1.12.34.tgz, gnutls-3.5.10p0.tgz, gstreamer1-1.10.4.tgz, 
gtar-1.29.tgz, gtk+2-2.24.31p0.tgz, gtk+3-3.22.11.tgz, 
gvfs-1.30.4.tgz, harfbuzz-1.4.5.tgz, 
hexedit-1.2.12p0.tgz, htop-2.0.1.tgz, icu4c-58.2p1.tgz, 
imlib2-1.4.9p0.tgz, inkscape-0.92.1.tgz, libcroco-0.6.11.tgz, 
libgcrypt-1.7.8.tgz, libgpg-error-1.27.tgz, libidn-1.32p1.tgz, 
libmatroska-1.4.6.tgz, libspectre-0.2.7p7.tgz, libspectre-0.2.7p7.tgz, 
libunistring-0.9.6.tgz, libv4l-1.12.3.tgz, libvpx-1.6.1.tgz, 
libxml-2.9.4p1.tgz, libxslt-1.1.28p5.tgz, llvm-3.8.0p2.tgz, 
mupdf-1.10ap0.tgz, mutt-1.8.0v3.tgz, nghttp2-1.21.0.tgz, 
node-6.10.1.tgz, nss-3.29.3.tgz, openssl-1.0.2k.tgz, 
p5-IO-Socket-SSL-2.047.tgz, p5-Net-DNS-1.09.tgz, p5-XML-Parser-2.44.tgz, 
pango-1.40.4.tgz, pear-DB-DataObject-FormBuilder-1.0.2p2.tgz, 
pear-HTML-CSS-1.5.4.tgz, pear-HTML-Common-1.2.5.tgz, 
pear-HTML-Common2-0.1.0p4.tgz, pear-HTML-Javascript-1.1.2.tgz, 
pear-HTML-Menu-2.1.4.tgz, pear-HTML-QuickForm-3.2.14p1.tgz, 
pear-HTML-QuickForm-Controller-1.0.10p1.tgz, pear-HTML-Table-1.8.4.tgz, 
pear-Net-SMTP-1.7.3.tgz, phantomjs-1.9.8p3.tgz, 
pidgin-2.11.0.tgz, podofo-0.9.5.tgz, poppler-0.52.0.tgz, 
postgis-2.3.2.tgz, py-idna-2.4.tgz, py-werkzeug-0.11.15.tgz, 
qemu-2.8.0p0.tgz, qgis-2.18.3.tgz, rrdtool-1.6.0p2.tgz, 
scribus-1.4.5.tgz, tiff-4.0.8.tgz, vim-8.0.0388-gtk2.tgz, 
wget-1.18.tgz, wxWidgets-gtk2-2.8.12p12.tgz, x264-20170125p0.tgz, 
x265-2.3p0.tgz, xfe-1.40.1p0.tgz

## NOVEDADES RESPECTO A adJ 6.0 PROVENIENTES DE PASOS DE JESÚS

- Paquetes más actualizados: 
	- php-5.6.31 --no es posible actualizar a 7 porque pear no opera y
		sivel 1.2 depende de pear
	- Ocaml 4.0.5 junto con ocamlbuild, ocaml-labltk, ocaml-camlp4 y hevea

- Documentación actualizada:
	- basico_adJ, usuario_adJ y servidor_adJ

- Se parchan y compilan portes más recientes de:
	- biblesync, sword y xiphos
	- markup, repasa y sigue con Ocaml 4.0.5

- Se incluye beta 3 de sivel2 que tiene entres sus novedades: Salva formulario de caso cada 60 segundos; Actualiza marco conceptual al más reciente del Banco de Datos del CINEP, que incluye más categorias del Derecho Internacional Humanitario Consetudinario; Nuevo menú para respaldo cifrado; Formulario de caso ampliado con actos colectivos, título, contexto, actor social para poder capturar toda la información que se captura con 1.2; Rediseñado llenado de plantillas en hoja de cálculo desde el listado de casos para ser más veloz así como el listado de casos

- Archivo de ordenes /usr/local/adJ/resto-altroot.sh para copiar 
  resto de particiones altroot ver 
  <http://dhobsd.pasosdejesus.org/Respaldo_altroot.html>


