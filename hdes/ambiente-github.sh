#!/bin/bash
# ambiente-github.sh - Preparar ambiente de desarrollo para adJ en GitHub Codespaces
# Parte del proyecto adJ - Aprendiendo de Jesús
# 
# Este script configura automáticamente todo lo necesario para que los agentes
# de GitHub Copilot puedan trabajar efectivamente con el proyecto adJ

set -e  # Salir en caso de error

echo "═══════════════════════════════════════════════════════════════════"
echo "CONFIGURANDO AMBIENTE DE DESARROLLO adJ"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "HANDOFF.md" ] || [ ! -d "arboldvd/evangelios_dp" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz de adJ"
    echo "   Asegúrese de estar en el directorio que contiene HANDOFF.md"
    exit 1
fi

echo "✅ Directorio adJ verificado"

# Función para mostrar progreso
mostrar_progreso() {
    echo ""
    echo "📦 $1..."
    echo "─────────────────────────────────────────────────────────────"
}

# 1. Actualizar sistema e instalar herramientas esenciales
mostrar_progreso "Instalando herramientas XML/XSL"
sudo apt update -qq
sudo apt install -y xsltproc xmlstarlet curl git coreutils

echo "   ✅ xsltproc instalado (para transformaciones XSL)"
echo "   ✅ xmlstarlet instalado (herramientas XML avanzadas)"
echo "   ✅ curl instalado (para descargas)"
echo "   ✅ coreutils instalado (incluye shuf para selección aleatoria)"

# 2. Verificar/instalar oksh (si no existe)
mostrar_progreso "Configurando oksh (OpenBSD ksh)"
if [ ! -f "/tmp/oksh/oksh" ]; then
    echo "   📥 Compilando oksh desde fuentes..."
    cd /tmp
    if [ ! -d "oksh" ]; then
        git clone https://github.com/ibara/oksh.git
    fi
    cd oksh
    ./configure > /dev/null 2>&1
    make > /dev/null 2>&1
    echo "   ✅ oksh compilado en /tmp/oksh/oksh"
    cd - > /dev/null
else
    echo "   ✅ oksh ya está disponible en /tmp/oksh/oksh"
fi

# 3. Configurar repositorio biblia_dp para gbfxml
mostrar_progreso "Configurando fuentes SpaTDP (biblia_dp)"
if [ ! -d "/tmp/biblia_dp" ]; then
    echo "   📥 Clonando repositorio biblia_dp..."
    git clone https://gitlab.com/pasosdeJesus/biblia_dp.git /tmp/biblia_dp > /dev/null 2>&1
    echo "   ✅ Repositorio biblia_dp clonado ($(ls /tmp/biblia_dp/*.gbfxml | wc -l) archivos gbfxml)"
else
    echo "   📥 Actualizando repositorio biblia_dp..."
    cd /tmp/biblia_dp
    git pull > /dev/null 2>&1
    cd - > /dev/null
    echo "   ✅ Repositorio biblia_dp actualizado"
fi

# 4. Crear/verificar transformación XSL personalizada
mostrar_progreso "Configurando transformación XSL personalizada"
if [ ! -f "/tmp/extraer-versiculo.xsl" ]; then
    cat > /tmp/extraer-versiculo.xsl << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:param name="versiculo"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//sv[@id=$versiculo]">
            <xsl:for-each select=".//t[@xml:lang='es']//wi">
                <xsl:value-of select="text()"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
            <xsl:for-each select=".//rb[@xml:lang='es']//wi[not(ancestor::rf)]">
                <xsl:value-of select="text()"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
EOF
    echo "   ✅ Transformación XSL creada en /tmp/extraer-versiculo.xsl"
else
    echo "   ✅ Transformación XSL ya existe"
fi

# 5. Verificar scripts de versículos aleatorios
mostrar_progreso "Verificando scripts de versículos aleatorios"
if [ -f "hdes/versiculo-aleatorio-v2.sh" ]; then
    chmod +x hdes/versiculo-aleatorio-v2.sh
    echo "   ✅ Script híbrido versiculo-aleatorio-v2.sh listo"
else
    echo "   ⚠️  Script híbrido versiculo-aleatorio-v2.sh no encontrado"
fi

if [ -f "hdes/versiculo-aleatorio.sh" ]; then
    chmod +x hdes/versiculo-aleatorio.sh
    echo "   ✅ Script original versiculo-aleatorio.sh listo"
else
    echo "   ⚠️  Script original versiculo-aleatorio.sh no encontrado"
fi

# 6. Verificar estructura de directorios
mostrar_progreso "Verificando estructura del proyecto"
dirs_esperados=("arboldvd/evangelios_dp" "hdes" "pruebas" "tminiroot" ".github/workflows")
for dir in "${dirs_esperados[@]}"; do
    if [ -d "$dir" ]; then
        echo "   ✅ $dir existe"
    else
        echo "   ⚠️  $dir no encontrado"
    fi
done

# 7. Configurar aliases útiles
mostrar_progreso "Configurando aliases útiles para desarrollo"
cat >> ~/.bashrc << 'EOF'

# === ALIASES PARA DESARROLLO adJ ===
alias oksh='/tmp/oksh/oksh'
alias validar-ksh='/tmp/oksh/oksh -n'
alias versiculo='./hdes/versiculo-aleatorio-v2.sh'
alias versiculo-evangelios='./hdes/versiculo-aleatorio-v2.sh -e'
alias versiculo-pablo='./hdes/versiculo-aleatorio-v2.sh -p'
alias build-adj='./distribucion.sh'
alias test-syntax='find hdes/ -name "*.sh" | xargs /tmp/oksh/oksh -n'

# Función para validar archivos ksh
validar_ksh_archivo() {
    if [ -z "$1" ]; then
        echo "Uso: validar_ksh_archivo archivo.sh"
        return 1
    fi
    echo "Validando $1 con oksh..."
    /tmp/oksh/oksh -n "$1"
    if [ $? -eq 0 ]; then
        echo "✅ $1 - Sintaxis correcta"
    else
        echo "❌ $1 - Errores de sintaxis"
    fi
}
EOF

echo "   ✅ Aliases configurados en ~/.bashrc"
echo "      - oksh: Ejecutar oksh directamente"
echo "      - validar-ksh: Validar sintaxis de archivos"
echo "      - versiculo: Script de versículos aleatorios"
echo "      - test-syntax: Validar todos los scripts ksh"

# 8. Prueba de funcionamiento
mostrar_progreso "Ejecutando pruebas de funcionamiento"

# Probar oksh
if /tmp/oksh/oksh -c "echo 'oksh funciona'" > /dev/null 2>&1; then
    echo "   ✅ oksh funcionando correctamente"
else
    echo "   ❌ oksh no funciona correctamente"
fi

# Probar xsltproc
if echo '<test/>' | xsltproc --version > /dev/null 2>&1; then
    echo "   ✅ xsltproc funcionando correctamente"
else
    echo "   ❌ xsltproc no funciona correctamente"
fi

# Probar transformación XSL
if [ -f "/tmp/biblia_dp/juan.gbfxml" ] && [ -f "/tmp/extraer-versiculo.xsl" ]; then
    resultado=$(cd /tmp/biblia_dp && xsltproc --stringparam versiculo "Juan-1-1" /tmp/extraer-versiculo.xsl juan.gbfxml 2>/dev/null)
    if [[ "$resultado" == *"Al comienzo"* ]]; then
        echo "   ✅ Transformación XSL funcionando correctamente"
    else
        echo "   ⚠️  Transformación XSL necesita verificación"
    fi
else
    echo "   ⚠️  No se pueden probar transformaciones XSL (archivos faltantes)"
fi

# Probar script de versículos (si existe)
if [ -f "hdes/versiculo-aleatorio-v2.sh" ]; then
    if ./hdes/versiculo-aleatorio-v2.sh -h > /dev/null 2>&1; then
        echo "   ✅ Script de versículos aleatorios funcionando"
    else
        echo "   ⚠️  Script de versículos necesita verificación"
    fi
fi

# 9. Resumen final
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "AMBIENTE CONFIGURADO EXITOSAMENTE"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 HERRAMIENTAS DISPONIBLES:"
echo "   • oksh (OpenBSD ksh) en /tmp/oksh/oksh"
echo "   • xsltproc para transformaciones XML"
echo "   • Repositorio biblia_dp en /tmp/biblia_dp"
echo "   • Transformación XSL en /tmp/extraer-versiculo.xsl"
echo ""
echo "📖 SCRIPTS SpaTDP:"
echo "   • ./hdes/versiculo-aleatorio-v2.sh (híbrido HTML+gbfxml)"
echo "   • ./hdes/versiculo-aleatorio.sh (original HTML)"
echo ""
echo "🔧 ALIASES CONFIGURADOS:"
echo "   • versiculo, versiculo-evangelios, versiculo-pablo"
echo "   • oksh, validar-ksh, test-syntax"
echo "   • Reinicie el terminal o ejecute: source ~/.bashrc"
echo ""
echo "✨ PRÓXIMOS PASOS:"
echo "   1. Leer HANDOFF.md para contexto completo"
echo "   2. Ejecutar: ./hdes/versiculo-aleatorio-v2.sh -e"
echo "   3. Validar sintaxis: /tmp/oksh/oksh -n distribucion.sh"
echo ""

# Obtener una cita bíblica final (si es posible)
if [ -f "hdes/versiculo-aleatorio-v2.sh" ]; then
    echo "💫 CITA INSPIRADORA:"
    ./hdes/versiculo-aleatorio-v2.sh -e 2>/dev/null || echo "   'En el principio era la Palabra...' - Juan 1:1 (SpaTDP)"
fi

echo ""
echo "¡Ambiente listo para el desarrollo de adJ! 🚀"
echo "═══════════════════════════════════════════════════════════════════"