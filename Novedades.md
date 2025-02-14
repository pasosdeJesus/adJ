# adJ - Aprendiendo de Jesús

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos
y Educativas y para quienes esperamos el regreso del Señor Jesucristo.

### Versión: 7.6
Fecha de publicación: 14/Feb/2025

Puedes ver novedades respecto a OpenBSD en:
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_6/Novedades_OpenBSD.md>

## 1. DESCARGAS

Puedes ver las diversas versiones publicadas en
<https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/> donde entre otras
encontrarás:

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.6-amd64.usb>
  que es imagen para escribir en una memoria USB y arrancar con esta bien en
  modo UEFI o bien en modo BIOS Legacy. Una vez
  la descargues puedes escribirla en una USB ubicada en `/dev/sd2c`
  (verifica el dispositivo con `dmesg` y remplaza) con:

       doas dd if=AprendiendoDeJesus-7.6-amd64.usb of=/dev/sd2c bs=1M

  Este proceso puede ser demorado, podrás ver el progreso con

      doas pkill -SIGINFO dd

  O si deseas probarla con `qemu` para instalar en un disco `virtual.raw`:

      qemu-system-x86_64 -hda virtual.raw -hdb AprendiendoDeJesus-7.6-amd64.usb -boot menu=on

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/AprendiendoDeJesus-7.6-amd64.iso>
  que es imagen en formato ISO para quemar en DVD e instalar por primera vez
  en modo BIOS Legacy.

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.6-amd64/>
  que es directorio con el contenido del DVD instalador apropiado para 
  descargar con `rsync` desde un adJ o un OpenBSD ya instalado para 
  actualizarlo (ver
  <https://gitlab.com/pasosdeJesus/adJ/-/blob/ADJ_7_6/Actualiza.md> )

* <https://adJ.pasosdeJesus.org/pub/AprendiendoDeJesus/7.6-extra/>
  es directorio con versiones recientes de paquetes no incluidos en
  distribución oficial (pueden no estar firmados y requerir instalación con
  `pkg_add -D unsigned _paquete_`).

## 2. NOVEDADES RESPECTO A ADJ 7.6 PROVENIENTES DE OPENBSD

### 2.1 Kernel y Sistema Base

Novedades tomadas de <https://www.openbsd.org/76.html>

* Aplicados parches de seguridad hasta el 29.Nov.2024 provenientes de
  OpenBSD que incluyen soluciones a fallas
* Controladores ampliados o mejorados para amd64
  * Tarjetas Ethernet: 
  * Tarjetas inalámbricas:
  * Otros:
* Mejoras al kernel y SMP
* Mejoras a `vmm`
* Mejoras a herramientas de Red
* Seguridad
  * 
  * `libressl` actualizado a 
  * Incluye OpenSSH x
* El sistema base incluye mejoras a componentes auditados y mejorados
  como, `llvm xxx`,  `Xenocara` (basado en `Xorg` 7.7),
  `perl xxx`
* El repositorio de paquetes de OpenBSD cuenta con xxx para amd64


## 3. NOVEDADES RESPECTO A ADJ 7.5 PROVENIENTES DE PASOS DE JESÚS

### 3.1 Instalador y documentación

*
* Documentación actualizada
  * `basico_adJ`
    <https://pasosdejesus.github.io/basico_adJ/>
  * `usuario_adJ`
    <https://pasosdejesus.github.io/usuario_adJ/>
  * `servidor_adJ`
    <https://pasosdejesus.github.io/servidor_adJ>

### 3.2 Paquetes

* Incluye `evangelios_dp-0.9.12` con traducción y marcado Strong del
  comienzo del nuevo testamento hasta I Timoteo
* Retroportamos el paquete llama-cpp que permite ejecutar modelos de IA
  usando vulkan y tarjetas graficadoras. Al respecto escribimos este
  artículo: <https://github.com/vtamara/llama.cpp/wiki/Probando-el-espa%C3%B1ol-de-modelos-simplificados-de-IA-con-DeepSeek%E2%80%90R1-en-adJ-OpenBSD-7.6>
* Retroportamos ruby 3.4.1 de OpenBSD-current. Los portes para ruby de OpenBSD 
  diligentemente mantenidos por Jeremy Evans, quitan el aviso de actualizar 
  gemas del sistema cuando hay nuevas versiones disponibles, 
  pues implícitamente sugiere instalar el paquete de la gema de Ruby para 
  OpenBSD más actualizado (en caso de que los haya).
  En adJ recomendamos usar gemas directamente (en lugar de paquetes con gemas)
  y  mantenemos el comportamiento original de Ruby y sugerimos actualizar 
  gemas del sistema tan pronto y tanto como sea posible con
  `doas gem update --system`
* Actualizamos porte de PostgreSQL 16.4 a 16.6
* Para aprovechar el xlocale extendido de adJ se han recompilado todos
  los paquetes incluidos para perl (comienzan con `p5`) y
  `vlc`, `glib2` y `libunistring`.
* Además de `chromium` (con llave del API de Google de adJ) incluimos 
  `firefox-esr` que también ha resultado bastante estable.
* Se han parchado mínimamente los siguientes para usar `servicio` en lugar
  de `daemon`: `postgresql`, y `smartmontools`
* Se han recompilado los siguientes para incluir versiones más recientes
  disponibles para OpenBSD 7.6 que cierra fallas de seguridad:
  `cups`, `curl`, `dkimproxy`,  `firefox-esr`
  `ghostscript`, `libarchive`, `libcupsfilter`, 
  `libppd`, `libunbound`, `mpg123`, 
  `openssl`, `python`, `php-x`,  `rscync`, `vim`

### 3.3 Configuración

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

