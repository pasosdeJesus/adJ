# adJ - Aprendiendo de Jesús

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.4b1
Fecha de publicación: 28/Nov/2023

Puedes ver novedades respecto a OpenBSD en:
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_4/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puedes ver las diversas versiones publicadas en
<https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
encontrarás:

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.4b1-amd64.usb>
  que es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez
  la descargues puedes escribirla en una USB ubicada en `/dev/sd2c`
  (verifica el dispositivo con `dmesg` y remplaza) con:

       doas dd if=AprendiendoDeJesus-7.4b1-amd64.usb of=/dev/sd2c bs=1M

  Este proceso puede ser demorado, podrás ver el progreso con

      doas pkill -SIGINFO dd

  O si deseas probarla con `qemu` para instalar en un disco `virtual.raw`:

       qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.4b1-amd64.usb -boot menu=on

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.4b1-amd64.iso>
  que es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.4b1-amd64/>
  que es directorio con el contenido del DVD instalador apropiado para descargar
  con `rsync` desde un adJ o un OpenBSD ya instalado para actualizarlo (ver
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_4/Actualiza.md> )

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.4-extra/>
  es directorio con versiones recientes de paquetes no incluidos en
  distribución oficial (pueden no estar firmados y requerir instalación con
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES RESPECTO A ADJ 7.4 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/74.html>

* Aplicados parches de seguridad hasta el 26.Nov.2023 provenientes de
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: Nuevo `ngbe` que soporta dispositivos Ethernet
    WangXun WX1860 PCI Express 10/100/1Gb. Añadido soporte para 100GB
    y para Mellanox ConnectX-6 Lx en `mcx.` Ethernet USB: `ure` soporta 
    RTL8153D. 
  * Tarjetas inalámbricas: Soporte para Quectel LTE&5G en `umb`, soporte para
    RTL8188FTV en `urtwn`. Mejoras a `iwm` e `iwx`.
  * Video: Se actualizó `drm` al de Linux 6.1.55. 
  * Otros: sensores térmicos de Ryzen 9 79xx en `ksmn`.
* Mejoras al kernel, SMP y seguridad: Implmentados dt y utrace en amd64, 
  retira soporte a softdep en mount.
* Mejoras a `vmm`
* Mejoras a herramientas de Red
* Seguridad
  * Evita falla Zenbleed en CPUs AMD y permite actualizar microcódigo.
  * Habilita "indirect branch tracking (IBT)" en amd64 que ayuda a
    garantizar integridad del control de flujo evitando que código
    malicioso salte a la mitad de una función.
  * `libressl` actualizado a 3.8.2
  * Incluye OpenSSH 9.5
  * `shutdown` sólo puede ser ejecutado por miembros del nuevo grupo `_shutdown`

* El sistema base incluye mejoras a componentes auditados y mejorados
  como, `llvm 13.0.0`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl 5.x.0`
* El repositorio de paquetes de OpenBSD cuenta con 11.845 para amd64


### 2.2 Paquetes

* Para cerrar fallas se usan las versiones más recientes de portes
  para OpenBSD 7.4 de: ``
* Para aprovechar el xlocale extendido de adJ se han recompilado
  `vlc`, `glib2` y `libunistring`.
* Algunos paquetes típicos y su versión: `dovecot 0`,
  `chromium 0`, `firefox-esr-0`,
  `libreoffice 0`,
  `nginx 0`, `mariadb 0`,
  `python 0`, `vim 0`, `zsh 5.9`


## 3. NOVEDADES RESPECTO A ADJ 7.3 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

* Documentación actualizada
  * `basico_adJ`
    <https://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ`
    <https://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`
    <https://pasosdejesus.github.io/servidor_adJ>

### 3.2 Paquetes

* Incluye `evangelios_dp-0.9.9` con traducción y marcado Strong del
  comienzo del nuevo testamento hasta Galatas
* El porte para OpenBSD-current de Ruby 3.3, diligentemente mantenido
  por Jeremy Evans, quita el aviso de actualizar gemas del sistema cuando
  hay nuevas versiones disponibles, pues implícitamente sugiere instalar el
  paquete de la gema de Ruby para OpenBSD más actualizado 
  (en caso de que los haya).
  En adJ recomendamos usar gemas directamente (en lugar de paquetes con gemas)
  y  retro-portamos la mayoría de ese porte pero mantenemos el
  comportamiento original de Ruby y sugerimos actualizar gemas del
  sistema tan pronto y tanto como sea posible con
  `doas gem update --system`
* Retroportados de OpenBSD-current los paquetes postgresql (incluyendo 
  parches por correo de Jeremy Evans del 8.Feb),  postgis y blosc.
* Se han retirado
* `chromium` recompilado con llave de Pasos de Jesús.  Ya permite autenticar
  y usar sitios como <https://drive.google.com>  --si tiene problemas para
  autenticarse intente desde un nuevo perfil (obligatorio por ejemplo si
  cambia su clave en gmail).
* Además de `chromium` incluimos `firefox-esr` que también ha resultado
  bastante estable.
* Se han recompilado los siguientes para aprovechar `xlocale` (además de muchos
  para `perl`): `glib2`, `libunistring`, `vlc`
* Se han parchado minimamente los siguientes para usar `servicio` en lugar
  de `daemon`: `postgresql`, `git` y `smartmontools`

### 3.3 Configuración

* Guión `/usr/local/adJ/pg_preact_postgis.sh` para facilitar actualización
  de versiones mayores de PostgreSQL cuando hay bases con PostGIS.
  Ver documentación en
  <https://pasosdejesus.org/doc/servidor_adJ/otros_servicios_que_puede_prestar_el_servidor.html#pg-upgrade>

## 4. FE DE ERRATAS

- `xenodm` no logra utilizar un teclado latinoamericano que se haya
  configurado en `/etc/kbdtype`.  Para usarlo
  agregue en `/etc/X11/xenodm/Xsetup_0`:
```
  setxkbmap latam
```

## 5. SI QUIERES AYUDARNOS

* Agradecemos tus oraciones.
* Si tienes una cuenta en gitlab o en github por favor ponle una estrella al
  repositorio en [gitlab](https://gitlab.com/pasosdeJesus/adJ) o
  en [github](https://github.com/pasosdeJesus/adJ/)
* Te invitamos a patrocinar nuestro trabajo empleando el botón
  Patrocinar (__Sponsor__) de <https://github.com/pasosdeJesus/adJ/>
* También puedes donarnos para recibir una USB para instalar la
  versión más reciente de adJ o alguno de los servicios de Pasos
  de Jesús desde <https://www.pasosdeJesus.org>
* Agradecemos tu ayuda mejorando este sitio, la documentación
  para usuario final y la documentación técnica.
* Agradecemos tu ayuda traduciendo a español páginas del
  manual desde: <https://hosted.weblate.org/projects/adj/>
* Agradecemos tu ayuda en el desarrollo de fuentes abiertas que llevamos
  en <https://gitlab.com/pasosdeJesus/adJ/>

