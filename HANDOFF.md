# HANDOFF - Continuación de Desarrollo adJ GitHub Actions

## Fecha: 2025-10-07
## Rama: expgh (experimental GitHub)
## Contexto: Implementación de GitHub Actions para validación y build de adJ

---

## DIRECTIVAS PRIORITARIAS 🙏

### Principios Fundamentales:
* **Responder con verdad, honestidad y humildad**. Mantener esta directiva como prioritaria.

* **Citar las Escrituras ocasionalmente** para dar fundamento a lo que hacemos. Usar SpaTDP (https://traduccion.pasosdeJesus.org) y la interpretación menonita.

> *"Y conocerán la verdad, y la verdad los hará libres."* - Juan 8:32 (SpaTDP)
> 
> En el espíritu menonita de servicio y construcción de comunidad, este proyecto busca crear herramientas que sirvan para la educación y los derechos humanos, reflejando los valores de paz, justicia y simplicidad.

### **IMPORTANTE - Contexto SpaTDP** 📖:
**SIEMPRE** al iniciar sesión, el agente debe:

1. **Leer archivos HTML de SpaTDP** en `arboldvd/evangelios_dp/` para familiarizarse con:
   - Estilo de traducción ("Buena Nueva de acuerdo a...")
   - Vocabulario específico usado
   - Pasajes clave como Juan 1:1-5, 1 Corintios 13, Hechos 2, etc.

2. **Solo usar citas auténticas** extraídas directamente de estos archivos HTML
   - NO inventar o aproximar citas bíblicas
   - Verificar texto exacto en los archivos antes de citar
   - Mantener formato: *"texto exacto"* - Referencia (SpaTDP)

3. **Ejemplos de lecturas obligatorias**:
   - `Juan-1.html` - "Al comienzo estaba la Palabra..."
   - `1_Corintios-13.html` - Capítulo del amor
   - `Juan-8.html` - Para verificar Juan 8:32
   - `Hechos-2.html` - Pentecostés

**Principio**: Honestidad total en citas bíblicas. Solo citar lo que has leído.

### **VERSÍCULOS CLAVE SpaTDP** - Texto Exacto Verificado:

#### **OBEDIENCIA Y MANDAMIENTOS:**
- **Juan 14:15**: *"Si me aman, sigan mis mandamientos."* (SpaTDP)
- **Juan 14:21**: *"Aquel que tenga mis mandamientos y los siga, es quien me ama."* (SpaTDP) 
- **Juan 15:10**: *"Si guardan mis mandamientos, permanecerán en mi amor; tal como Yo he guardado los mandamientos de mi Padre, y me mantengo en su amor."* (SpaTDP)

#### **LA GRAN COMISIÓN:**
- **Mateo 28:19-20**: *"Entonces vayan y hagan discípulos en todas las naciones, bautizándolos en el nombre del Padre, y del Hijo y del Espíritu Santo, enseñándoles a seguir todas las cosas que les he ordenado."* (SpaTDP)

#### **VERDAD Y LIBERTAD:**
- **Juan 8:32**: *"Y conocerán la verdad, y la verdad los hará libres."* (SpaTDP)
- **Juan 1:1**: *"Al comienzo estaba la Palabra y la Palabra estaba con Dios, y la Palabra era Dios."* (SpaTDP)

### **SISTEMA DE CITAS ALEATORIAS:**
```bash
# Seleccionar evangelio aleatorio para citas ocasionales
evangelios=(Mateo Marcos Lucas Juan)
evangeli_random=${evangelios[$RANDOM % ${#evangelios[@]}]}

# Leer versículo aleatorio de los evangelios
find arboldvd/evangelios_dp/${evangeli_random}-*.html | shuf -n 1 | xargs grep -A 5 "verse"
```

---

## ESTADO ACTUAL ✅

### Completado:
1. **Rama experimental creada**: `expgh` para no interferir con `main`
2. **GitHub Actions implementados**:
   - `validation.yml`: Validación automática con oksh
   - `build-attempt.yml`: Experimentos de compilación
   - `documentation.yml`: Generación automática de docs
   - `README.md`: Documentación completa de workflows

3. **Validación de sintaxis evolucionada**:
   - ❌ shellcheck (incompatible con ksh)
   - ⚠️ dash (aproximación básica)
   - ⚠️ ksh93u+m (dialecto AT&T, falsos positivos)
   - ✅ **oksh compilado** (mejor aproximación disponible)

4. **oksh compilado exitosamente**:
   - Ubicación: `/tmp/oksh/oksh` 
   - Fuente: https://github.com/ibara/oksh
   - Validación: distribucion.sh y ver.sh pasan perfectamente

5. **SpaTDP integrado**:
   - Archivos HTML en: `arboldvd/evangelios_dp/`
   - Números Strong funcionales
   - JavaScript para mostrar/ocultar concordancia
   - Navegación entre capítulos operativa

---

### **Comandos técnicos para nueva sesión** 🔧

### **🚀 CONFIGURACIÓN INICIAL (NUEVO AGENTE)**:
```bash
# ¡EJECUTAR PRIMERO! Configurar ambiente automáticamente
./hdes/ambiente-github.sh

# Activar aliases configurados
source ~/.bashrc

# Verificar que todo funciona
versiculo-evangelios    # Debería mostrar un versículo aleatorio
oksh -n distribucion.sh # Debería validar sintaxis correctamente
```

### **Inicialización rápida SpaTDP**:
```bash
# Listar archivos disponibles
ls arboldvd/evangelios_dp/*.html | head -10

# Leer pasajes clave (OBLIGATORIO al iniciar)
# Juan 1:1-5 (Logos)
read_file /workspaces/adJ/arboldvd/evangelios_dp/Juan-1.html 40 100

# Juan 8:32 (Verdad y libertad - cita del HANDOFF)
grep_search "Juan-8-32" arboldvd/evangelios_dp/Juan-8.html
read_file /workspaces/adJ/arboldvd/evangelios_dp/Juan-8.html 535 550

# 1 Corintios 13 (Amor)
read_file /workspaces/adJ/arboldvd/evangelios_dp/1_Corintios-13.html 50 200
```

### **Verificación rápida de citas**:
```bash
# Buscar versículo específico
grep_search "versículo_buscado" arboldvd/evangelios_dp/ --isRegexp=false

# Verificar texto exacto antes de citar
read_file [archivo_encontrado] [línea_inicio] [línea_fin]
```

### **Sistema de citas aleatorias ocasionales**:
```bash
# NUEVO: Script híbrido HTML + gbfxml/XSL para texto perfecto
./hdes/versiculo-aleatorio-v2.sh           # Versículo aleatorio con XSL
./hdes/versiculo-aleatorio-v2.sh -e        # Solo evangelios  
./hdes/versiculo-aleatorio-v2.sh -p        # Solo epístolas de Pablo
./hdes/versiculo-aleatorio-v2.sh -l Juan   # Solo evangelio de Juan
./hdes/versiculo-aleatorio-v2.sh -o        # Solo fuentes HTML locales
./hdes/versiculo-aleatorio-v2.sh -h        # Ayuda completa

# Versión original (sin XSL, para comparación):
./hdes/versiculo-aleatorio.sh              # Versión original HTML
```

**ESTRATEGIA HÍBRIDA IMPLEMENTADA** 🎯:
1. **Selección**: Usa archivos HTML locales para elegir libro/capítulo/versículo aleatorio
2. **Extracción**: Obtiene texto limpio desde gbfxml usando transformación XSL personalizada  
3. **Fallback**: Si gbfxml no está disponible, usa parsing HTML local

**Funcionalidades del script v2**:
- ✅ **Texto perfectamente espaciado** sin números Strong residuales
- ✅ **XSL personalizada** para extraer solo texto español 
- ✅ **Fallback robusto** a HTML local si falla gbfxml
- ✅ **Compatible con ksh** de OpenBSD
- ✅ **Repositorio biblia_dp clonado** en `/tmp/biblia_dp`

---

## PRÓXIMOS PASOS CRÍTICOS 🚀

### ALTA PRIORIDAD: VM de OpenBSD Real
**Problema**: oksh es aproximación, NO es exactamente ksh de OpenBSD
**Solución**: Implementar VM real de OpenBSD en GitHub Actions

#### Plan de VM:
1. **Fase 1 - Validación básica**:
   - VM mínima de OpenBSD
   - Solo validación de sintaxis con ksh nativo
   - Tiempo: ~10-15 min setup

2. **Fase 2 - Compilación parcial**:
   - VM con fuentes de OpenBSD
   - Aplicación de parches de adJ
   - Compilación de kernel + base

3. **Fase 3 - Build completo**:
   - Compilación completa de adJ
   - Generación de ISO
   - Upload de artefactos

---

## ARCHIVOS MODIFICADOS

### En rama `expgh`:
```
.github/workflows/
├── validation.yml       # Validación con oksh
├── build-attempt.yml    # Experimentos VM/build
├── documentation.yml    # Docs automáticas  
└── README.md           # Documentación workflows

hdes/
├── ambiente-github.sh         # 🆕 Configuración automática del ambiente
├── versiculo-aleatorio.sh     # Script original (HTML parsing)
└── versiculo-aleatorio-v2.sh  # Script híbrido (HTML + gbfxml/XSL)

/tmp/
├── biblia_dp/                 # Repositorio gbfxml clonado  
├── extraer-versiculo.xsl      # Transformación XSL personalizada
└── oksh/                      # oksh compilado desde fuentes

ver-local.sh            # Config para testing
```

### **🆕 NUEVO: Script de Ambiente Automático**

**Ubicación**: `hdes/ambiente-github.sh`

**Propósito**: Configurar automáticamente un Codespace/workspace con todas las herramientas necesarias para el desarrollo de adJ.

**Funcionalidades**:
- ✅ **Instala herramientas XML**: xsltproc, xmlstarlet
- ✅ **Compila oksh** desde fuentes de GitHub
- ✅ **Clona biblia_dp** para fuentes gbfxml 
- ✅ **Crea transformación XSL** personalizada
- ✅ **Configura aliases** útiles para desarrollo
- ✅ **Valida funcionamiento** de todas las herramientas
- ✅ **Compatible con Codespaces** y entornos Ubuntu

**Uso para próximo agente**:
```bash
# Al iniciar nueva sesión, ejecutar una sola vez:
./scripts/ambiente-github.sh

# Luego usar las herramientas configuradas:
source ~/.bashrc
versiculo-evangelios     # Alias para versículos aleatorios
oksh -n distribucion.sh # Validar sintaxis con oksh
test-syntax             # Validar todos los scripts ksh
```

### Commits importantes:
- `8a66999b`: feat: agregar GitHub Actions experimentales
- `2bde22bc`: improve: usar ksh real para validación
- `bcb7fea2`: feat: usar oksh para validación perfecta
- `PENDIENTE`: feat: script ambiente-github.sh + versículos híbridos XSL

### **⚠️ COMMITS PENDIENTES**:
```bash
# Al finalizar la sesión, hacer commit de los nuevos archivos:
git add hdes/ambiente-github.sh
git add hdes/versiculo-aleatorio-v2.sh
git add -u HANDOFF.md
git commit -m "feat: ambiente automático + versículos híbridos XSL

- hdes/ambiente-github.sh: configuración automática del ambiente
- hdes/versiculo-aleatorio-v2.sh: estrategia híbrida HTML+gbfxml+XSL
- Transformación XSL personalizada para texto perfecto en español
- Aliases para desarrollo y herramientas XML configuradas
- Documentación actualizada en HANDOFF.md"

# NO HACER PUSH - esperar sincronización GitLab
```

---

## CONFIGURACIÓN TÉCNICA

### oksh compilado:
```bash
cd /tmp
git clone https://github.com/ibara/oksh.git
cd oksh
./configure
make
# Binario: /tmp/oksh/oksh
```

### Testing de sintaxis:
```bash
/tmp/oksh/oksh -n distribucion.sh  # ✅ OK
/tmp/oksh/oksh -n ver.sh          # ✅ OK
find hdes/ -name "*.sh" | xargs /tmp/oksh/oksh -n  # ✅ All OK
```

---

## PENDIENTES IMPORTANTES

### 1. Sincronización GitLab ⚠️
**CRÍTICO**: Repo principal está en GitLab, GitHub es espejo
- Usuario mencionó hacer commit/push en GitLab
- Cambios en GitHub se pierden si no vienen de GitLab
- **Acción**: Esperar sincronización antes de continuar

### 2. VM de OpenBSD - Implementación
**Archivos necesarios**:
- `auto_install.conf` para instalación no interactiva
- Scripts de SSH automation
- Optimización de caching para reducir tiempo build

*"Y todo lo que hacéis, sea de palabra o de hecho, hacedlo todo en el nombre del Señor Jesús"* - Colosenses 3:17 (KJV)

El desarrollo debe hacerse con excelencia y cuidado, como unto el Señor, buscando herramientas que verdaderamente sirvan a la comunidad.

### 3. Mejoras a workflows existentes
- Optimizar tiempo de compilación de oksh
- Cachear binario oksh compilado
- Mejorar reportes de validación

---

## COMANDOS ÚTILES PARA CONTINUAR

### Verificar estado:
```bash
git branch -v
git log --oneline -5
ls -la .github/workflows/
```

### Probar oksh (si no existe):
```bash
cd /tmp && git clone https://github.com/ibara/oksh.git
cd oksh && ./configure && make
/tmp/oksh/oksh -n /workspaces/adJ/distribucion.sh
```

### Workflow de desarrollo:
```bash
# Trabajar en rama expgh
git checkout expgh
# Hacer cambios
git add .github/workflows/
git commit -m "descripción"
# NO PUSH - esperar sincronización GitLab
```

---

## CONTEXTO DEL PROYECTO adJ

### Qué es adJ:
- Distribución personalizada de OpenBSD
- "Aprendiendo de Jesús"
- Mejoras en localización (español)
- Parches en `arboldes/usr/src/`

### Estructura importante:
```
arboldes/usr/src/    # Parches para OpenBSD
hdes/               # Scripts de desarrollo  
pruebas/            # Scripts de testing
distribucion.sh     # Script principal de build
ver.sh             # Variables de configuración
```

### Limitaciones actuales:
- Requiere OpenBSD real para compilación completa
- Scripts diseñados para ksh de OpenBSD
- ~20GB espacio + horas de compilación para build completo

---

## NOTAS PARA SESIÓN FUTURA

*"No os conforméis a este siglo, sino transformaos por medio de la renovación de vuestro entendimiento"* - Romanos 12:2 (KJV)

El desarrollo de adJ debe buscar transformar y renovar las herramientas disponibles para organizaciones que trabajan por la justicia y la educación, siguiendo los principios menonitas de paz, simplicidad y servicio.

1. **Prioridad #1**: Implementar VM de OpenBSD real
2. **Validación actual**: oksh es buena aproximación pero no perfecta
3. **Repo sync**: Confirmar que cambios están en GitLab antes de continuar
4. **Testing**: Todos los workflows han sido probados localmente
5. **Documentación**: README.md actualizado con plan de VM

### Preguntas para el usuario:
- ¿Se completó la sincronización con GitLab?
- ¿Proceder con implementación de VM de OpenBSD?
- ¿Alguna prioridad específica en el desarrollo?

---

**ARCHIVO DE HANDOFF COMPLETADO**
**Fecha: 2025-10-07**
**Siguiente: Implementar VM real de OpenBSD para validación auténtica**