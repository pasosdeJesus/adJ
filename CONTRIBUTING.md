# Contribuir a adJ

Primero, gracias por considerar contribuir a `adJ`. Tu ayuda es valiosa para llevar la Buena Nueva a través de la tecnología.

Este documento proporciona una guía para los desarrolladores que desean aportar cambios, parches o mejoras al proyecto.

## Flujo de Trabajo Típico del Desarrollador

El desarrollo de `adJ` implica un ciclo de modificación, compilación y prueba. A continuación se describen los pasos y herramientas comunes en este proceso.

### 1. Configuración Inicial: Fork y Clon

Antes de poder contribuir con código, necesitas tener tu propia versión del repositorio para trabajar.

1.  **Bifurcar (Fork):** En la página de GitHub del repositorio [pasosdeJesus/adJ](https://github.com/pasosdeJesus/adJ), haz clic en el botón "Fork" para crear una copia del repositorio en tu propia cuenta de GitHub.

2.  **Clonar (Clone):** Ahora, clona tu fork a tu máquina de desarrollo local. Reemplaza `TU-USUARIO` con tu nombre de usuario de GitHub.
    ```sh
    git clone https://github.com/TU-USUARIO/adJ.git
    cd adJ
    ```
    Este directorio local es donde realizarás todos tus cambios.

### 2. Configuración del Entorno de Compilación

*   **Enlazar `mystuff`:** `adJ` contiene portes (paquetes de software) que son únicos o están modificados. Estos se encuentran en `arboldes/usr/ports/mystuff`. Debes crear un enlace simbólico desde `/usr/ports/mystuff` a este directorio para que el sistema de compilación de OpenBSD pueda encontrarlos:
    ```sh
    doas ln -s /ruta/a/tu/repo/adJ/arboldes/usr/ports/mystuff /usr/ports/mystuff
    ```

### 3. Ciclo de Desarrollo y Compilación

La mayoría de las operaciones se controlan activando o desactivando pasos en el archivo `distribucion.sh` a través de tu archivo de configuración personal `ver-local.sh`.

*   **Activar/Desactivar Pasos:** Edita `ver-local.sh` (si no existe, puedes crearlo con `cp ver-local.sh.plantilla ver-local.sh`). Para activar un paso, asigna el valor `'s'` a la variable `auto*` correspondiente (p. ej., `autoCompKernel='s'`). Para desactivarlo, usa `'n'`.

*   **Actualizar Fuentes:** Con regularidad, puedes sincronizar tus fuentes locales con las oficiales de OpenBSD. Para ello, activa `autoCVS='s'` en `ver-local.sh` y ejecuta:
    ```sh
    doas ./distribucion.sh
    ```

*   **Implementar Mejoras:**
    *   Puedes realizar cambios automáticos al sistema base o al kernel mediante scripts. Estos deben ubicarse en `hdes/` o en `arboldd/usr/local/adJ` y ser llamados desde `distribucion.sh`.
    *   También puedes crear parches `.patch`, que se ubican en `arboldes/usr/src` (para el sistema base) o `arboldes/usr/xenocara` (para el sistema gráfico).

*   **Trabajar con Portes:**
    *   Actualiza, mejora o crea nuevos portes en `arboldes/usr/ports/mystuff`.
    *   Si agregas o retiras un porte, asegúrate de actualizar la lista de paquetes en `distribucion.sh`.

*   **Compilación Parcial:** Durante el desarrollo, puedes ejecutar fases específicas de la compilación activando solo las variables `auto*` necesarias en `ver-local.sh`. El orden general y las variables se describen en detalle en el [PROCESO-DE-CONSTRUCCION.md](PROCESO-DE-CONSTRUCCION.md).

### 4. Prueba de la Distribución con QEMU

Una vez que has generado una imagen de instalación `.iso` (ver `PROCESO-DE-CONSTRUCCION.md`), es crucial probarla en un entorno virtual antes de publicarla.

*   **Prueba de Arranque desde ISO:**
    1.  Asegúrate de que la variable `qemuboot` en `ver-local.sh` esté configurada como `qemuboot=d` (para arrancar desde el CD/DVD).
    2.  Ejecuta el script `hdes/qemu.sh`. Si no existe una imagen de disco virtual (`virtual.vid`), se creará una.
    3.  Procede con la instalación de `adJ` dentro de la máquina virtual.

*   **Prueba de Arranque desde Disco Duro Virtual:**
    1.  Después de instalar, cambia `qemuboot` en `ver-local.sh` a `qemuboot=c` (para arrancar desde el disco duro).
    2.  Vuelve a ejecutar `hdes/qemu.sh` para arrancar el sistema recién instalado y verificar su funcionamiento.

*   **Modo Texto:** Para una ejecución más rápida, especialmente en conexiones remotas, puedes iniciar la máquina virtual en modo texto:
    ```sh
    TEXTO=1 hdes/qemu.sh
    ```

### 5. Estrategia de Ramas y Versiones en Git

*   **Ramas (Branches):** Mantenemos una rama separada para cada versión mayor publicada de `adJ` (por ejemplo, `ADJ_7_8`). Las actualizaciones de seguridad y correcciones para una versión ya publicada se aplican a su rama correspondiente.
*   **Etiquetas (Tags):** Creamos una etiqueta Git cada vez que se anuncia una nueva publicación en el sitio web (por ejemplo, `v7.8b1`).
*   **Enviar Contribuciones:** Envía tus mejoras a tu propia bifurcación (fork) en GitHub y luego crea una "Pull Request" para que podamos revisar e integrar tu trabajo.

### 6. Contribuciones a OpenBSD

Cuando creamos parches que podrían ser beneficiosos para el proyecto OpenBSD, procuramos que sean "limpios" y se apliquen en el orden correcto sobre la versión correspondiente de las fuentes de OpenBSD. Estos parches destinados a ser enviados a OpenBSD se organizan en `hdes/src/`.
