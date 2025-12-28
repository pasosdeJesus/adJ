# GESTIÓN-DE-UNA-NUEVA-VERSION.md

Este documento es la lista de verificación maestra para el desarrollo y publicación de una nueva versión de `adJ`. Guía al responsable a través de todos los pasos, desde la concepción de novedades hasta el anuncio público.

## Calendario Anhelado

Anhelamos publicar una versión mayor (e.g., 7.8) aproximadamente 3 meses después del lanzamiento de OpenBSD:

*   **Versiones de Invierno:** Publicación el 11 de Enero.
*   **Versiones de Verano:** Publicación el 1 de Julio.

Publicamos revisiones (e.g., 7.8p1) si la seguridad o la calidad lo ameritan.

### Hitos de Desarrollo

*   **Versión Beta (e.g., 7.8b1):** Publicada en el directorio `desarrollo` del sitio de distribución el 10 de Diciembre o el 10 de Junio.
*   **Versión Alfa (e.g., 7.8a1):** Publicada idealmente el 24 de Septiembre o el 24 de Marzo.

## Pasos para Desarrollar una Versión Beta

--------------------------------------------

### 1. Definir e Implementar Novedades
Este es el primer paso creativo. Antes de los pasos técnicos, se deben definir, desarrollar e integrar las nuevas características o mejoras que justificarán la nueva versión. Esto puede incluir:
*   Añadir o actualizar parches al kernel o al sistema base.
*   Desarrollar, actualizar o retroportar paquetes de software.
*   Mejorar los scripts de configuración o del sistema `adJ`.

### 2. Sincronizar Archivos de Versión
Cambiar el número de versión en todos los archivos relevantes: `ver.sh`, `arboldd/usr/local/adJ/inst-adJ.sh`, `Actualiza.md`, `GESTIÓN-DE-UNA-NUEVA-VERSION.md`, `arboldvd/util/preact-adJ.sh`, `Novedades.md`, `README.md`, `Novedades_OpenBSD.md`, `arboldvd/util/actbase.sh` y la `Dedicatoria.md`.

### 3. Actualizar Parches de Localización
Este es un paso técnico profundo para asegurar que las mejoras de internacionalización se apliquen correctamente a la nueva versión de OpenBSD.
*   **3.1.** Preparar para probar con: `pruebas/preppruebas.sh`.
*   **3.2.** Intentar aplicar todos los parches con `pruebas/aplicahasta.sh arboldes/usr/src/15..`.
*   **3.3.** Compilar libc (`doas pruebas/compila-libc.sh`) y correr pruebas de regresión (`cd /usr/src/regress/lib/libc/locale/; doas make`).
*   **3.4.** Si falla, identificar el parche problemático y corregir.

> Para un entendimiento profundo de la arquitectura de estos parches, consulte la [documentación técnica de i18n](doc/i18n.md).

### 4. Recompilar el Sistema
Una vez los parches están actualizados, se debe proceder a compilar el kernel y el sistema base para integrar los cambios.

> El proceso detallado de compilación de cada componente del sistema se describe en el [PROCESO-DE-CONSTRUCCION.md](PROCESO-DE-CONSTRUCCION.md).

### 5. Recompilar Paquetes
Recompilar paquetes que tengan actualizaciones de seguridad o mejoras funcionales.

### 6. Retroportar Paquetes
Trabajar en la adaptación de paquetes de versiones más nuevas de OpenBSD para que funcionen en la versión actual de `adJ`. Los resultados útiles no incluidos en el DVD se pueden dejar en un directorio `extra`.

### 7. Regenerar la Distribución
Ejecutar el script principal para empaquetar todos los componentes (sin volver a compilar todo).
```sh
doas ./distribucion.sh
```

### 8. Documentar Novedades
Retocar la fecha de publicación en `Novedades.md` y publicar una versión preliminar en <http://aprendiendo.pasosdeJesus.org>.

### 9. Generar la Imagen de Instalación
Usar `hdes/creaiso.sh` para crear el archivo `.iso` final.

### 10. Probar la Imagen Generada
Es crucial verificar la imagen de instalación en un entorno controlado como QEMU.

> Para las instrucciones detalladas sobre cómo ejecutar las pruebas en QEMU, consulte la [Guía para el Contribuyente](CONTRIBUTING.md).

A continuación, la lista de verificación de pruebas:
*   **Instalación:** Completar la instalación del sistema base. `uname -a` debe reportar `APRENDIENDODEJESUS`.
*   **Kernel:** Verificar el renombramiento de `daemon` a `servicio` con:
    ```sh
    $ vmstat -s | grep servicio
    ```
*   **Logs:** Verificar que se usa la bitácora `/var/log/servicio` y que no existe `/var/log/daemon`.
*   **Libc:** Verificar que libc incluye funciones de locale por ejemplo editando un archivo `l.c` con el siguiente contenido, tras compilar con `cc -o l l.c` y ejecutar con `./l` el resulado debería ser `1.000.000,200000`:
    ```c
    #include "locale.h"  
    #include "stdio.h"
    int main() {  
      setlocale(LC_ALL, "es_CO.UTF-8");
      printf("%'f", 1000000.2);
    
      return 0;
    }
    ```
*   **Scripts de `adJ`:** Verificar la ejecución de `/inst-adJ.sh` tanto en instalaciones nuevas como en actualizaciones.
*   **Paquetes:** Desde el directorio de paquetes del medio de instalación, ejecutar `PKG_PATH=. doas pkg_add *` y asegurar que no haya fallos.
*   **Cotejación (Terminal):** Con el paquete `colorls` modificado y actualizado, verificar cotejación en español en terminal gráfica:
    ```sh
    touch a
    touch í
    touch o
    ls -l
    ```
    Debe mostrar los directorios en orden alfabético correcto (í entre a y o).
*   **Cotejación (PostgreSQL):** Con paquete PostgreSQL modificado y actualizado, verificar que coteja en español con:
    ```sh
    doas su - _postgresql
    cat > /tmp/cot.sql <<EOF
    SELECT 'Á' < 'B' COLLATE "es_co_utf_8";
    EOF
    psql -h /var/www/var/run/postgresql/ -Upostgres -f /tmp/cot.sql
    ```
    que debe responder con
    ```
     ?column?
    ----------
     t
    (1 row)
    ```
*   **Aplicaciones:** Confirmar que una aplicación Ruby on Rails opera correctamente.
*   **Interfaz Gráfica:** Verificar que toda entrada del menú gráfico opere sin errores.

### 11. Crear Directorio en Servidor
En `adJ.pasosdeJesus.org`, crear el directorio para los paquetes extra: `mkdir /dirftp/7.8-extra`.

### 12. Subir Archivos al Servidor
Desde el computador de desarrollo, subir la distribución y los paquetes extra.
```sh
hdes/rsync-aotro.sh
scp -rf AprendiendoDeJesus-7.8-amd64.{img,iso} 7.8-amd64 adJ.pasosdeJesus.org:/dirftp/
rsync extra-7.8/* adJ.pasosdeJesus.org:/dirftp/7.8-extra/
```

### 13. Verificar Servicios en Línea
Verificar la operación de todos los sitios y servicios públicos del proyecto.

### 14. Crear Etiqueta y Rama en Git
Al publicar una versión alfa o beta, es necesario marcar el estado del código fuente.

> Para más detalles sobre la estrategia de ramas y etiquetas, consulte la [Guía para el Contribuyente](CONTRIBUTING.md).
```sh
git tag -a v7.8b1 -m "Version 7.8b1"
git push origin v7.8b1
git checkout -b ADJ_7_8
git push origin ADJ_7_8
```

### 15. Anunciar
Publicar en la lista de desarrollo.

## Pasos para Publicar una Versión Mayor

--------------------------------------------

1.  **Usar la Rama de la Versión:** Asegurarse de estar trabajando sobre la rama correcta (e.g., `git checkout ADJ_7_8`).
2.  **Actualizar Contenido Propio:** Actualizar SIVeL, evangelios, Mt77 y otros paquetes específicos de `adJ`.
3.  **Actualizar Documentación:** Actualizar los manuales `basico_adJ`, `usuario_adJ` y `servidor_adJ` y publicarlos.
4.  **Actualizar Logo:** Con GIMP, actualizar el número de versión en el logo que presenta `xenodm`.
5.  **Actualizar Instalador:** Revisar y adaptar el instalador (`tminiroot`) a las novedades de OpenBSD.
6.  **Realizar Pasos de Beta:** Ejecutar los pasos análogos a la publicación de una versión beta.
7.  **Publicar "Release" en GitHub:** Crear una nueva publicación en la página de releases del repositorio.
8.  **Difundir en Redes Sociales:** Publicar en Twitter y Facebook.
9.  **Enviar Correo a Listas:** Enviar el anuncio a las listas de correo relevantes.
10. **Actualizar Wikipedia:** Actualizar los artículos de Wikipedia relacionados con `adJ`.
