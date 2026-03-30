# adJ — Aprendiendo de Jesús

[![Join the chat at https://gitter.im/pasosdeJesus/adJ](https://badges.gitter.im/pasosdeJesus/adJ.svg)](https://gitter.im/pasosdeJesus/adJ?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**adJ** es una distribución de [OpenBSD](https://www.openbsd.org/) orientada a organizaciones de derechos humanos, instituciones educativas y todos aquellos que buscan un sistema operativo seguro, estable y éticamente fundamentado.

*"Encomienda a Jehová tus obras, y tus pensamientos serán afirmados" (Proverbios 16:3).*

---

## 📖 Documentación

| Documento | Descripción |
|-----------|-------------|
| [Básico](https://pasosdejesus.org/doc/basico_adJ/) | Primeros pasos, instalación y uso esencial |
| [Usuario](https://pasosdejesus.org/doc/usuario_adJ/) | Uso de adJ como sistema de escritorio |
| [Servidor](https://pasosdejesus.org/doc/servidor_adJ/) | Configuración como servidor y cortafuegos |

**Novedades:**
- [Anuncios de versiones](http://aprendiendo.pasosdejesus.org/)
- [Lista de correo OpenBSD-Colombia](https://groups.google.com/forum/#!forum/openbsd-colombia)

---

## 🛠️ Acerca de este repositorio

Este repositorio contiene los **planos y herramientas** para transformar un sistema OpenBSD estándar en la distribución `adJ`. Aquí encontrará:

- Parches para el kernel, sistema base y Xenocara
- Scripts de construcción (`distribucion.sh`)
- Portes de software específicos (`arboldes/usr/ports/mystuff/`)
- Configuraciones personalizadas (`arboldd/`)

El resultado final es un sistema operativo completamente funcional, con mejoras como:
- Soporte completo de **internacionalización (xlocale)** y localización en español
- Terminología coherente (renombramiento de `daemon` → `servicio`)
- Herramientas propias para administración y monitoreo
- Software preconfigurado para educación y derechos humanos

---

## 🚀 Primeros pasos

### Usuario final
Si desea **instalar o actualizar adJ**, consulte:
- [Actualiza.md](Actualiza.md) — proceso de actualización
- [Novedades.md](Novedades.md) — cambios en la última versión

### Desarrollador / Contribuyente
Si desea **construir adJ desde las fuentes** o contribuir al proyecto:

1. Revise la **[Guía de construcción](PROCESO-DE-CONSTRUCCION.md)** — describe cada fase del proceso
2. Lea las **[pautas de contribución](CONTRIBUTING.md)** — flujo de trabajo, pruebas y envío de parches
3. Explore la **[gestión de nuevas versiones](GESTIÓN-DE-UNA-NUEVA-VERSION.md)** — hitos y lista de verificación

---

## 📁 Estructura del repositorio

```
.
├── arboldd/               # Árbol de un sistema adJ instalado
├── arboldes/              # Árbol de desarrollo (parches, portes)
├── arboldvd/              # Árbol para el DVD de instalación
├── distribucion.sh        # Script principal de construcción
├── hdes/                   # Herramientas de desarrollo
├── pruebas/                # Scripts de prueba
├── tminiroot/              # Transformación del instalador a español
├── ver.sh                  # Configuración por defecto
├── ver-local.sh (plantilla)# Configuración personal (sobrescribe ver.sh)
├── Actualiza.md            # Instrucciones de actualización
├── CONTRIBUTING.md         # Guía para contribuyentes
├── DEDICATORIA.md          # Texto devocional 
├── GESTIÓN-DE-UNA-NUEVA-VERSION.md # Plan de lanzamientos
├── LICENCIA.md / LICENSE.md # Licencia ISC (español/inglés)
├── Novedades.md            # Novedades de adJ
└── Novedades_OpenBSD.md    # Novedades heredadas de OpenBSD
```

---

## 🤝 Contribuir

Valoramos toda contribución, sea técnica o no:

- **Código**: parches, nuevos portes, correcciones de errores
- **Documentación**: mejoras en manuales, traducciones
- **Pruebas**: reporte de fallos, verificación de nuevas versiones
- **Difusión**: compartir el proyecto, dar una estrella en GitHub/GitLab
- **Oración**: por los usuarios, por las causas que atienden y por el equipo

Para contribuir técnicamente, siga la **[Guía para contribuyentes](CONTRIBUTING.md)**.

---

## 💖 Apoyo

- **Patrocinio**: puede patrocinar nuestro trabajo a través de [Patreon](https://patreon.com/pasosdeJesus) o el botón *Sponsor* en [GitHub](https://github.com/pasosdeJesus/adJ/)
- **Servicios**: Pasos de Jesús ofrece soporte, instalación personalizada y desarrollo a medida — más información en [nuestro sitio](https://www.pasosdeJesus.org)

---

## 📜 Licencia

El código original de adJ se distribuye bajo la **Licencia ISC** (equivalente a dominio público en Colombia). Consulte [LICENCIA.md](LICENCIA.md) para más detalles.

OpenBSD conserva sus propias licencias (mayoritariamente BSD e ISC).

---

*"Así que, hermanos míos amados, estad firmes y constantes, creciendo en la obra del Señor siempre, sabiendo que vuestro trabajo en el Señor no es en vano" (1 Corintios 15:58).*
