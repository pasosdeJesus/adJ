# adJ - Aprendiendo de Jesús.
Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.3
Fecha de publicación: 28/Ago/2022

Puede ver novedades respecto a OpenBSD en:
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_3/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puede ver las diversas versiones publicadas en
  <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
  encontrará:

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.3-amd64.usb> 
  es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez 
  la descargue puede escribirla en una USB ubicada en `/dev/sd2c` 
  (verifique dispositivo con `dmesg` y remplace) con:

       doas dd if=AprendiendoDeJesus-7.3-amd64.usb of=/dev/sd2c bs=1M

 Este proceso puede ser demorado, puede ver el progreso con 

      doas pkill -SIGINFO dd

 O si desea probarla con qemu para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.3b1-amd64.usb -boot menu=on

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/AprendiendoDeJesus-7.3b1-amd64.iso> 
  es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/endesarrollo/7.3b1-amd64/>
  es directorio con el contenido del DVD instalador apropiado para descargar 
  con rsync desde un adJ o un OpenBSD ya instalado para actualizarlo (ver  
  <https://github.com/pasosdeJesus/adJ/blob/ADJ_7_3/Actualiza.md> )

* <http://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.3-extra/> 
  es directorio con versiones recientes de paquetes no incluidos en 
  distribución oficial (pueden no estar firmados y requerir instalación con 
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES RESPECTO A ADJ 7.3 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/73.html> 

* Aplicados parches de seguridad hasta el 26.Ago.2023 provenientes de 
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: Mejorados `em`, `mcx`. Hasta 2.5GB `rge`.
  * Tarjetas inalámbricas: Mejorados `iwx`, `iwm`, `bwfm`
  * Video: Actualizado drm a Linux 6.1.15. Ampliado soporte de `amdgpu`. 
    Mejorado `inteldrm.`
* Mejoras al kernel, SMP y seguridad
* Mejoras a vmm
* Mejoras a herramientas de Red
  * Mejorados iked, bgp, bgpd, rpki-client, tftpd, rarpd, ypldap, ndp, route,
    netstat, systat, nc, acme-client, smtpd
* Seguridad
  * Separación de privilegios en más programas
  * Mejorada seguridad de ypldap, dhcpleased, mountd, nfsd, pflogd, 
    resolvd, nwind entre otros.
  * libressl actualizado a la versión 3.7.2 que entre otros agrega
    soporte a ED25519 como primitiva.
  * Incluye OpenSSH 9.3
* Otros
  * Mejoras a tmux

* El sistema base incluye mejoras a componentes auditados y mejorados 
  como, `llvm 13.0.0`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.36.0` 
* El repositorio de paquetes de OpenBSD cuenta con 11764 para amd64


### 2.2 Paquetes 

* Para cerrar fallas se usan las versiones más recientes de portes
  para OpenBSD 7.3 de: `curl`, `firefox-esr`, `openssl`, `php`, `postgis`,
  `postgresql`, `samba`, `webkitgtk4`,
* Para aprovechar el xlocale extendido de adJ se han recompilado
  `vlc`, `glib2` y `libunistring`.
* Algunos paquetes típicos y su versión: `dovecot 2.3.20v0`,
  `chromium 111.0.5563.110`, `firefox-esr-102.9.0`, 
  `libreoffice 7.5.1.2v0`,
  `nginx 1.22.0p0`, `mariadb 10.9.4v1`,
  `python 3.10.12`, `vim 9.0.1388`, `zsh 5.9`


## 3. NOVEDADES RESPECTO A ADJ 7.3 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada 
	* `basico_adJ`: 
    <http://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ` 
    <http://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`: 
    <http://pasosdejesus.github.io/servidor_adJ>

### 3.2 Núcleo y librerías fundamentales

* Se ha retirado el soporte para muchos descriptores de archivo porque: 
  (1) quitaba compatibilidad de diversos binarios con OpenBSD y
  (2) actualmente no hay una aplicación en uso que justifique el cambio.

### 3.3 Paquetes

* Incluye evangelios_dp 0.9.8 con traducción y marcado Strong del
  comienzo del nuevo testamento hasta 2 Corintios.
* El porte para OpenBSD-current de Ruby 3.2.2, diligentemente mantenido
  por Jeremy Evans, quita el aviso de actualizar gemas del sistema cuando
  hay nuevas versiones disponibles, pues implícitamente sugiere instalar el 
  paquete de Ruby para OpenBSD más actualizado (en caso de que los haya).
  En adJ retro-portamos la mayoría de ese porte pero mantenemos el 
  comportamiento original de Ruby y sugerimos actualizar gemas del 
  sistema tan pronto y tanto como sea posible con 
  `doas gem update --system`
  actualizado y sin fallas de seguridad conocidas hasta el momento. Ver
  <https://github.com/nodejs/release#release-schedule>
* Retroportados de OpenBSD-current los paquetes openssl y node para
  tener la versión de node estable recomendada en <https://nodejs.org>
* Se ha retirado el paquete neovim por cuanto vim es tipicamente
  suficiente y no depende de paquetes desactualizados (neovim depende de
  una versión antigua de lua).
* Chromium recompilado con llave de Pasos de Jesús.  Ya permite autenticar
  y usar sitios como <https://drive.google.com>  --si tiene problemas para
  autenticarse intente desde un nuevo perfil (obligatorio por ejemplo si 
  cambia su clave en gmail).
* Además de chromium incluimos `firefox-esr` que también ha resultado
  bastante estable.
* Se han recompilado los siguientes para aprovechar `xlocale` (además de muchos
  para perl): `glib2`, `libunistring`, `vlc`
* Se han parchado minimamente los siguientes para usar `servicio` en lugar
  de `daemon`: `postgresql`, `git` y `smartmontools`

### 3.4 Configuración

* Guión `/usr/local/adJ/reconf-fluxbox.sh` para configurar o reconfigurar
  fluxbox en una cuenta.

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

