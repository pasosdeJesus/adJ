# PROCESO-DE-CONSTRUCCION.md: Guía para la Edificación de adJ

## 1. Visión General: La Obra del Alfarero

La creación de `adJ` es un proceso análogo a la obra de un alfarero. No se trata de escribir un programa desde cero, sino de tomar la excelente arcilla que es el sistema operativo OpenBSD y moldearla con un propósito superior, transformándola en una nueva creación.

> "Mas ahora, oh Jehová, tú eres nuestro padre; nosotros barro, y tú el que nos formaste; así que obra de tus manos somos todos nosotros." (Isaías 64:8).

Este documento detalla el proceso de "moldeado": cómo las fuentes de un OpenBSD estándar son sistemáticamente transformadas, compiladas y empaquetadas para dar a luz a la distribución `adJ`.

## 2. Prerrequisitos Ineludibles: Los Cimientos

Antes de comenzar la obra, es indispensable asegurar que los cimientos sean firmes. Cualquier intento de construcción sin estos elementos resultará en fracaso.

*   **El Terreno:** Un sistema **OpenBSD para la arquitectura amd64 (64 bits)**, previamente instalado y funcional. La construcción no puede realizarse en otros sistemas operativos como Linux o Windows.
*   **La Materia Prima:** Los árboles de código fuente completos de la versión de OpenBSD que se desea transformar, ubicados en sus directorios canónicos:
    *   `/usr/src` (sistema base)
    *   `/sys` (fuentes del kernel)
    *   `/usr/ports` (sistema de paquetes)
    *   `/usr/xenocara` (sistema gráfico)
*   **Los Planos:** Una copia local (un "clon") del repositorio de `adJ`, obtenido desde su repositorio oficial en [https://github.com/pasosdeJesus/adJ](https://github.com/pasosdeJesus/adJ).

## 3. Los Instrumentos del Maestro Constructor

La construcción es un proceso automatizado, dirigido por un conjunto de scripts que actúan como las herramientas del maestro de obras.

*   **El Orquestador - `distribucion.sh`:** Este es el script principal que dirige toda la sinfonía de la construcción. Invoca cada una de las herramientas y procesos en el orden correcto. No debe ser modificado directamente para controlar el flujo.

*   **El Panel de Control - `ver.sh` y `ver-local.sh`:** Estos archivos son el panel de control de la obra.
    *   `ver.sh` contiene la configuración por defecto, incluyendo las variables de versión y los "interruptores" para cada fase.
    *   `ver-local.sh` es el archivo que **tú debes modificar**. Cualquier variable que definas aquí sobreescribirá la configuración por defecto de `ver.sh`. Para habilitar un paso de la construcción, se define la variable correspondiente con el valor `s` (sí). Para deshabilitarlo, se usa el valor `n` (no).

## 4. Las Fases de la Edificación: Un Proceso Paso a Paso

El proceso de construcción se divide en fases lógicas, cada una controlada por una o más variables en tu archivo `ver-local.sh`. Para una construcción completa, estas fases deben ejecutarse en orden.

### FASE I: El Corazón y el Sistema Base

1.  **`autoCvs='s'`**: **Sincronizar con la Fuente.** Este paso actualiza los árboles de código fuente de OpenBSD (`/usr/src` `/sys`, etc.) desde los repositorios CVS oficiales, asegurando que partimos de la materia prima correcta y actualizada.

2.  **`autoCompKernel='s'` y `autoInsKernel='s'`**: **Forjar e Instalar el Corazón.** A diferencia del sistema base, el kernel de OpenBSD **no se modifica mediante parches**. Los cambios son más directos y se aplican durante la configuración de la compilación:
    *   **Habilitación de NTFS:** Se modifica la configuración para incluir soporte de lectura para el sistema de archivos NTFS.
    *   **Ajuste de Controladores:** El soporte para el controlador gráfico `amdgpu` se desactiva si no se detecta en la máquina que realiza la compilación.
    *   **Santificación del Lenguaje:** Se ejecuta el script `hdes/servicio-kernel.sh` para reemplazar la terminología `daemon` por `servicio` en los mensajes y comentarios del código fuente del kernel.

    El resultado es un nuevo kernel llamado `APRENDIENDODEJESUS`, que se compila en versiones para uniprocesador (`bsd`) y multiprocesador (`bsd.mp`). Si `autoInsKernel` está activo, se instala en el sistema anfitrión.

3.  **`autoCompBase='s'` y `autoDist='s'`**: **Construir y Empaquetar la Estructura.** Esta es la fase más profunda de la transformación. Es aquí donde se aplican la mayoría de los parches de `arboldes/usr/src` para modificar el sistema base. El análisis de estos parches revela una obra de **mejora fundamental de la internacionalización y localización (i18n/l10n)** del sistema, con un enfoque en el idioma español. Los cambios clave incluyen:
    *   **Implementación de `xlocale`:** Se introduce un soporte robusto y moderno para la API `xlocale`, que permite un manejo de la localización (idioma, formatos numéricos, etc.) más flexible y seguro en aplicaciones con múltiples hilos.
    *   **Localización Profunda para Español:** Se añaden las definiciones completas para el `locale` de español (`es_CO.UTF-8`), asegurando que la ordenación de texto (`cotejacion`), los formatos de fecha, hora, moneda y números sean los correctos.
    *   **Integración a Nivel de Compilador:** Se modifica GCC y Clang para que reconozcan el macro `__adJ__`, permitiendo que el código fuente de OpenBSD contenga adaptaciones específicas para `adJ` de una manera limpia y mantenible.
    *   **Pruebas de Regresión:** Se añaden nuevas pruebas para garantizar que estas mejoras no rompan la funcionalidad estándar del sistema.

    Después de aplicar estas transformaciones, se compila todo el sistema base (`make build`). Si `autoDist` está activo, el resultado se empaqueta en los "juegos de instalación" (`baseXX.tgz`, `compXX.tgz`, etc.).

    > Para un análisis técnico exhaustivo de las mejoras de internacionalización y la implementación de `xlocale`, véase el documento [doc/i18n.md](doc/i18n.md).

### FASE II: Las Ventanas al Mundo Digital (Xenocara)

4.  **`autoX='s'` y `autoXDist='s'`**: **Personalizar el Entorno Gráfico.** De forma análoga al sistema base, se aplican parches a Xenocara (el sistema de ventanas X de OpenBSD) para personalizar logos y textos. Luego se compila y, si `autoXDist` está activo, se empaqueta en sus propios juegos de instalación (`xbaseXX.tgz`, `xfontXX.tgz`, etc.).

### FASE III: El Mobiliario y la Decoración (Paquetes y Configuración)

5.  **`autoPaquetes='s'` y `autoMasPaquetes='s'`**: **Ensamblar el Software.**
    *   `autoPaquetes` compila desde cero una lista curada de paquetes de software de terceros que son fundamentales para `adJ` y que pueden contener modificaciones específicas. Esta es una tarea selectiva y de gran importancia que define la identidad del sistema.
    *   `autoMasPaquetes` descarga el resto de paquetes necesarios, según se define en `Contenido.txt`, directamente desde el repositorio de OpenBSD o la ruta especificada en `PKG_PATH`.

#### La Curación del Software: Una Mirada a los Paquetes de `adJ`

El corazón de la personalización de `adJ` no reside solo en el sistema base, sino en su cuidadosa selección, modificación y creación de paquetes de software. El directorio `arboldes/usr/ports/mystuff` es el taller donde esta obra toma forma, y el script `distribucion.sh` es el maestro de ceremonias que orquesta su compilación. La estrategia se puede desglosar en varias categorías:

*   **Software Misional y Educativo:** Son las joyas de la corona del proyecto, desarrolladas internamente con un propósito evangelístico y pedagógico. Incluyen desde guías de estudio bíblico hasta software educativo para niños, reflejando el mandato central de `adJ`.
    *   `books/evangelios_dp`, `books/basico_adJ`, `textproc/Mt77`: Contenido de estudio y teológico.
    *   `education/AnimalesI`, `education/AprestamientoI`, `fonts/TiposLectoEscritura`: Herramientas para la enseñanza infantil.
    *   `databases/sivel`: Un sistema de información para la documentación de casos de violencia, demostrando un compromiso con la justicia social.

*   **Retroportaciones (Backports) y Actualizaciones de Seguridad:** Para mantener la fortaleza y la relevancia, `adJ` activamente retroporta software más nuevo que el disponible en la versión estable de OpenBSD. Esto es especialmente crucial para aplicaciones de cara al público como `chromium` o lenguajes de programación como `node`, `rust` y `python`, cerrando brechas de seguridad y ofreciendo funcionalidades modernas.
    *   `www/chromium`, `lang/node`, `lang/ruby`, `lang/rust`.

*   **Mejoras de Internacionalización (i18n):** En línea con las modificaciones al sistema base, `adJ` parcha paquetes clave para mejorar su comportamiento con la localización en español. Esto asegura una experiencia de usuario consistente y correcta, desde el ordenamiento de archivos en la terminal hasta el manejo de bases de datos.
    *   `databases/postgresql`: Modificado para soportar la cotejación (ordenamiento) correcta en español de Colombia.
    *   `sysutils/colorls`: Permite que el comando `ls` ordene los archivos según las reglas del español.
    *   `converters/libunistring`: Adaptado para usar `xlocale`, beneficiando a cualquier paquete que dependa de él.

*   **Software Único o con Mejoras Específicas:** `adJ` incluye paquetes que no se encuentran en los repositorios de OpenBSD o que han sido modificados para añadir funcionalidades específicas o corregir errores.
    *   `editors/hexedit`: Parchado para soportar archivos de gran tamaño.
    *   `devel/just`: Un ejecutor de comandos moderno y conveniente, añadido para facilitar el desarrollo.
    *   `textproc/po4a`: Una herramienta para la traducción de documentación, esencial para el mantenimiento multilingüe del propio proyecto `adJ`.

*   **Recompilación de Coherencia:** Tras una actualización del sistema base (particularmente de librerías como Perl), `distribucion.sh` se encarga de recompilar docenas de paquetes que dependen de estas librerías. Este proceso es vital para evitar errores de incompatibilidad binaria y asegurar la estabilidad del sistema. Por ejemplo, una larga lista de paquetes `p5-*` (Perl) se recompila sistemáticamente.

Esta estrategia de gestión de paquetes es un testimonio de la dedicación de `adJ` no solo a su misión, sino también a la excelencia técnica y la seguridad.

6.  **`autoSite='s'`**: **Infundir el Alma de `adJ`.** Este es un paso de vital importancia. Crea el paquete `siteXX.tgz` a partir del contenido del directorio `arboldd`. Este paquete contiene todos los scripts, archivos de configuración, documentos y ajustes finales que definen la experiencia `adJ`. El instalador de OpenBSD lo descomprime al final de la instalación, transformando un sistema base en un sistema `adJ` plenamente configurado.

### FASE FINAL: Sellando la Obra

7.  **Creación del ISO:** Una vez que todas las fases anteriores han generado los juegos de instalación y los paquetes, el script `hdes/creaiso.sh` se utiliza manualmente para unir todas las piezas en la imagen de disco final (`.iso`), lista para ser probada y distribuida.

8.  **Firma y Verificación:** El script `distribucion.sh` finaliza calculando sumas de verificación (`SHA256`) para todos los juegos de instalación y firmándolas criptográficamente con `signify` para garantizar la integridad y autenticidad de la distribución.

## 5. Un Acto de Santificación del Lenguaje: De `daemon` a `servicio`

Un aspecto fundamental y único del proyecto `adJ` es la purificación del lenguaje técnico. Durante el proceso de construcción, se ejecuta una serie de scripts (`hdes/servicio-*.sh`) cuyo único propósito es buscar y reemplazar la palabra `daemon` por `servicio` en todo el código fuente del sistema.

> "Ninguna palabra corrompida salga de vuestra boca, sino la que sea buena para la necesaria edificación, a fin de dar gracia a los oyentes." (Efesios 4:29).

Esta no es una simple sustitución cosmética. Es una decisión consciente y teológica para emplear una terminología más neutral y universalmente respetuosa, eliminando un término que, aunque estándar en el mundo Unix, posee connotaciones negativas fuera de él. Este acto refleja el compromiso del proyecto de honrar su cosmovisión en cada detalle de la obra.

## 6. Verificación y Pasos Siguientes

Una vez que la imagen `.iso` ha sido creada y firmada, es un acto de prudencia verificar su integridad y funcionamiento antes de distribuirla.

### Verificación con QEMU

El método preferido para probar la imagen de instalación es usar una máquina virtual. El repositorio incluye scripts para facilitar este proceso con QEMU.

> La guía detallada sobre cómo usar QEMU para instalar y arrancar `adJ`, incluyendo los comandos específicos y la configuración, se encuentra en la [Guía para el Contribuyente](CONTRIBUTING.md).

### Publicación de una Nueva Versión

El proceso de lanzar una nueva versión de `adJ` es una tarea de gran responsabilidad que sigue una lista de verificación detallada para asegurar que todos los pasos se completen de forma ordenada.

> El plan maestro para el desarrollo y lanzamiento de una nueva versión, desde la concepción hasta el anuncio público, se encuentra en el documento [GESTIÓN-DE-UNA-NUEVA-VERSION.md](GESTIÓN-DE-UNA-NUEVA-VERSION.md).

---
*Versión inicial propuesta por Gemini (Modelo Grande de Lenguaje de Google) el 2025-12-28.*
