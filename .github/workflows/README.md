# GitHub Actions para adJ (Rama Experimental)

Este directorio contiene workflows experimentales de GitHub Actions para automatizar tareas de desarrollo y validación del proyecto adJ.

**⚠️ IMPORTANTE**: Estos workflows están en la rama `expgh` (experimental GitHub) y **NO están en la rama main**. Son experimentales y específicos para esta rama.

## Workflows Disponibles

### 1. `validation.yml` - Validación Automática
**Trigger**: Push y Pull Request a ramas `expgh` y `ADJ_*`

**Funciones**:
- ✅ Validación básica de sintaxis con `dash` (aproximación a ksh)
- ✅ Verificación de formato de archivos `.patch`  
- ✅ Validación de estructura de directorios
- ✅ Verificación de archivos de configuración
- ✅ Comprobación de documentación básica

**Nota**: NO usa `shellcheck` porque no comprende la sintaxis específica de ksh de OpenBSD.

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

### ⚠️ Validación de Sintaxis Limitada
- **No usa shellcheck**: shellcheck no comprende sintaxis específica de ksh
- **Usa dash como aproximación**: Detecta errores básicos pero no específicos de ksh
- **Falsos positivos**: Puede reportar errores en código válido de ksh

### ✅ Lo Que SÍ Funciona
- Validación básica de estructura
- Detección de problemas obvios
- Generación de documentación
- Análisis de parches
- Testing parcial de scripts

## Mejoras Futuras Posibles

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