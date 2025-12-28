adJ
===

[![Join the chat at https://gitter.im/pasosdeJesus/adJ](https://badges.gitter.im/pasosdeJesus/adJ.svg)](https://gitter.im/pasosdeJesus/adJ?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Distribución de OpenBSD apropiada para organizaciones de Derechos Humanos 
y Educativas y que anhelamos que Jesús use durante el Milenio.

Documentación General
---------------------

* Básica <https://pasosdejesus.org/doc/basico_adJ/>
* Usuario <https://pasosdejesus.org/doc/usuario_adJ/>
* Servidor <https://pasosdejesus.org/doc/servidor_adJ/>
* Anuncios de nuevas versiones: <http://aprendiendo.pasosdejesus.org/> y en la lista <https://groups.google.com/forum/#!forum/openbsd-colombia>

Concepto de este Repositorio
---------------------------

Este repositorio contiene los planos y herramientas para transformar un sistema OpenBSD estándar en la distribución `adJ`. A través de una serie de parches, scripts y configuraciones, se moldea el sistema operativo base para alinearlo con los objetivos del proyecto.


Guías Principales
-----------------

Ya sea que desees construir `adJ` por ti mismo o contribuir a su desarrollo, aquí encontrarás los documentos esenciales para comenzar:

*   **[PROCESO-DE-CONSTRUCCION.md](PROCESO-DE-CONSTRUCCION.md)**: Este es el manual del arquitecto. Describe en detalle cada fase de la construcción de la distribución `adJ`, desde la sincronización de las fuentes hasta la creación de la imagen de instalación final.

*   **[CONTRIBUTING.md](CONTRIBUTING.md)**: Esta es la guía para el contribuyente. Si deseas aportar mejoras, corregir errores o participar en el desarrollo, este documento te explicará el flujo de trabajo, las herramientas de prueba y las convenciones que utilizamos.


Organización del Repositorio
---------------------------

- ```arboldvd```   Directorios y archivos de un DVD instalador
- ```arboldd```    Directorios y archivos de un adJ instalado
- ```arboldes```   Directorios, archivos y parches para desarrollar adJ
- ```distribucion.sh```	Archivo de ordenes para generar distribución
- ```hdes```       Herramientas de desarrollo
- ```pruebas```    Scripts que ayudan a hacer pruebas
- ```tminiroot```  Transforma instalador que va en DVD a español
- ```ver.sh```     Valores por defecto que controlan distribucion.sh
- ```ver-local.sh```		Personalización de ver.sh
