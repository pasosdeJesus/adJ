# GitHub Actions para adJ (Rama Experimental)

Este directorio contiene workflows experimentales de GitHub Actions para automatizar tareas de desarrollo y validación del proyecto adJ.

**⚠️ IMPORTANTE**: Estos workflows están en la rama `expgh` (experimental GitHub) y **NO están en la rama main**. Son experimentales y específicos para esta rama.

## Workflows Disponibles

### 1. `validation.yml` - Validación Automática
**Trigger**: Push y Pull Request a ramas `expgh` y `ADJ_*`

**Funciones**:
- ✅ Validación de sintaxis con `oksh` (ksh portable de OpenBSD)
- ✅ Verificación de formato de archivos `.patch`  
- ✅ Validación de estructura de directorios
- ✅ Verificación de archivos de configuración
- ✅ Comprobación de documentación básica

**Nota**: Usa `oksh` (compilado desde fuentes) para validación idéntica a OpenBSD.

### 2. `build-attempt.yml` - Intentos de Compilación
**Trigger**: Manual (workflow_dispatch)

**Modos de Operación**:

#### `validation-only` (Por defecto)
- Validación mejorada de scripts
- Simulación de directorios de build
- Test de configuración

#### `vm-build` (Experimental)
- **⚠️ Proof-of-concept**: Setup de VM OpenBSD
- Demostración de proceso de instalación automatizada
- **Limitaciones**: Requiere configuración manual completa

#### `container-experiment`
- Experimentos con herramientas BSD en Linux
- Validación avanzada de parches
- Análisis de estructura de archivos

### 3. `documentation.yml` - Documentación Automática
**Trigger**: Push a `expgh` con cambios en Markdown o manual

**Genera**:
- 📁 `ESTRUCTURA.md`: Árbol completo del proyecto
- 🔧 `PARCHES.md`: Análisis detallado de todos los parches
- 📜 `SCRIPTS.md`: Inventario de todos los scripts
- 📊 Estadísticas del proyecto

**Utilidad**: Mantiene documentación siempre actualizada.

## Uso Recomendado

### Para Desarrollo Diario
```bash
# Los workflows de validación se ejecutan automáticamente en:
git push origin expgh  # Triggerea validation.yml en rama experimental
```

### Para Experimentos de Build
```bash
# Ir a Actions tab en GitHub → "adJ Build Attempt" → "Run workflow"
# Seleccionar modo: validation-only | vm-build | container-experiment
```

### Para Actualizar Documentación
```bash
# Se ejecuta automáticamente al cambiar archivos .md
git add README.md
git commit -m "docs: actualizar documentación"
git push  # Triggerea documentation.yml
```

## Limitaciones Actuales

### ❌ Compilación Completa
- **Requiere OpenBSD real**: Los workflows no pueden compilar adJ completamente
- **Necesita VM completa**: ~20GB+ y 8+ horas de compilación
- **Configuración compleja**: auto_install.conf, SSH automation, etc.

### ✅ Validación de Sintaxis con oksh (Aproximación)
- **Usa oksh**: Versión portable mantenida por terceros de ksh de OpenBSD
- **Buena compatibilidad**: Muy similar al ksh nativo de OpenBSD pero no idéntico
- **Pocos falsos positivos**: Mucho mejor que shellcheck o otros shells
- **Limitación**: No es exactamente el mismo que el ksh nativo de OpenBSD
- **Solución definitiva necesaria**: Validación en VM real de OpenBSD/adJ

### ✅ Lo Que SÍ Funciona
- Validación básica de estructura
- Detección de problemas obvios
- Generación de documentación
- Análisis de parches
- Testing parcial de scripts

## Prioridades de Desarrollo

### 🚀 **ALTA PRIORIDAD: VM de OpenBSD Real**
La validación actual con `oksh` es una buena aproximación, pero la **solución definitiva** es implementar una máquina virtual real de OpenBSD/adJ en GitHub Actions:

#### Beneficios de VM Real:
- ✅ **ksh nativo**: El shell exacto de OpenBSD, no una aproximación
- ✅ **Compilación real**: Posibilidad de compilar adJ completamente  
- ✅ **Testing auténtico**: Pruebas en el entorno real de destino
- ✅ **Detección precisa**: Errores exactos que verían los usuarios finales

#### Desafíos a Resolver:
- ⚠️ **Tiempo**: Instalación automatizada puede tomar 15-30 minutos
- ⚠️ **Espacio**: Requiere ~8-10GB para instalación completa
- ⚠️ **Automatización**: Necesita auto_install.conf y scripts no interactivos
- ⚠️ **Caching**: Optimizar para evitar reinstalar en cada ejecución

#### Plan de Implementación:
1. **Fase 1**: VM básica con validación de sintaxis únicamente
2. **Fase 2**: VM con compilación parcial (kernel + base)
3. **Fase 3**: VM con compilación completa de adJ

### 1. Compilación Real en VM
```yaml
# Requiere implementar:
- auto_install.conf para OpenBSD
- Scripts de SSH automation  
- Descarga automática de fuentes OpenBSD
- Aplicación automatizada de parches
- Compilación y packaging
- Upload de artefactos (ISOs)
```

### 2. Testing Más Robusto
```yaml
# Posibles mejoras:
- Unit tests para funciones de shell
- Integration tests con mocks
- Regression tests para parches
- Performance benchmarks
```

### 3. Release Automation
```yaml
# Para automatizar releases:
- Tag-based releases
- Automatic changelog generation
- ISO publishing to releases
- Notification systems
```

## Configuración de Secrets

Para funcionalidad avanzada, configurar en GitHub Settings → Secrets:

```bash
# Para deployment (futuro)
DEPLOY_HOST=ftp.pasosdejesus.org
DEPLOY_USER=usuario
DEPLOY_KEY=ssh_private_key

# Para notificaciones (futuro)  
SLACK_WEBHOOK=webhook_url
DISCORD_WEBHOOK=webhook_url
```

## Contribuir

Para agregar nuevos workflows:

1. Crear archivo en `.github/workflows/nombre.yml`
2. Seguir formato de los existentes
3. Documentar en este README
4. Testear con workflow_dispatch primero
5. Crear PR con los cambios

---

**⚠️ RAMA EXPERIMENTAL**: Estos workflows están en la rama `expgh` únicamente. No están diseñados para la rama `main` ya que están adaptados para experimentación con GitHub Actions y pueden no ser apropiados para el flujo de trabajo principal del proyecto adJ.