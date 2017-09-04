# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y que anhelamos sea usada por Jesús durante el Milenio.

### Versión: 6.1b2
Fecha de publicación: 6/Sep/2017

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_6_1/Novedades_OpenBSD.md>

## NOVEDADES RESPECTO A adJ 6.0 provenientes de OpenBSD 6.1

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
	* mandoc -mdoc -T markdown

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como ```Xenocara``` (```Xorg 7.7```), ```gcc``` 4.2.1, ```perl``` 5.24.1, 
  ```nsd``` 4.1.15


- Paquetes más actualizados: 
	- ruby 2.4.1 retroportado
	- php-5.6.30
	- ocaml 4.0.5 junto con ocamlbuild y ocaml-camlp4
	- samba-4.4.5p3 actualizado en fuentes de OpenBSD 6.1
	- curl-7.53.1p0 actualizado en fuentes de OpenBSD 6.1
- Archivo de ordenes /usr/local/adJ/resto-altroot.sh para copiar 
  resto de particiones altroot ver 
  <http://dhobsd.pasosdejesus.org/Respaldo_altroot.html>


# Novedades respecto a paquetes 
Se han actualizado más los binarios de los siguientes (a partir de portes recientes para OpenBSD 6.1):
nss-3.29.3, nghttp2-1.4.0, mutt-1.8.0, mupdf-1.10ap0, mariadb-{server,client}-10.0.30v1, libxml-2.9.4p1, libvpx-1.6.1, libv4l-1.12.3, libmatorksa-1.4.6, evince-3.22.1p2, dbus-1-10.16v0, ImageMagick-6.9.8.3, imlib2-1.4.9p0, gtk+3, gimp-2.8.18p4, ghostscript-9.07p4, cups-filters-1.313.4p0, p5-XML-Parser-2.44, gvf-1.30.4, gstraemer1-1.10.4, abiword-3.0.1p7, libcroco-0.6.11,harfbuzz-1.4.5, harfbuzz-icu-1.4.5, ocaml-4.04.0p0, vim-8.0.0388, tiff-4.0.8, tevent-0.9.29, samba-util-4.5.8, samba-4.5.8p0, ldb-1.1.27, ruby-2.4.1, rrdtool, pear-Net-SMTP-1.7.3, pango-1.40.4, p5-Net-DNS, openssl-1.0.2k, 

