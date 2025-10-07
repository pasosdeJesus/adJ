#!/bin/ksh
# versiculo-aleatorio.sh - Selecciona un versículo aleatorio de SpaTDP
# Parte del proyecto adJ - Aprendiendo de Jesús
# Para uso ocasional durante el desarrollo, siguiendo principios menonitas
# 
# ESTRATEGIA HÍBRIDA:
# 1. Usar archivos HTML locales para seleccionar libro/capítulo/versículo aleatorio
# 2. Obtener texto limpio desde fuentes gbfxml en GitLab
# 3. Fallback a parsing HTML local si gbfxml no está disponible

# Directorio de SpaTDP
SPATDP_DIR="arboldvd/evangelios_dp"

# URL base para fuentes gbfxml en GitLab
GBFXML_BASE_URL="https://gitlab.com/pasosdeJesus/biblia_dp/-/raw/main"

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "OPCIONES:"
    echo "  -h, --help         Mostrar esta ayuda"
    echo "  -e, --evangelios   Solo evangelios (Mateo, Marcos, Lucas, Juan)"
    echo "  -p, --pablo        Solo epístolas de Pablo"
    echo "  -t, --tema TEMA    Buscar versículos que contengan un tema específico"
    echo "  -l, --libro LIBRO  Seleccionar de un libro específico"
    echo "  -o, --offline      Forzar uso de archivos locales (sin gbfxml)"
    echo ""
    echo "EJEMPLOS:"
    echo "  $0                  # Versículo completamente aleatorio"
    echo "  $0 -e              # Solo de los evangelios"
    echo "  $0 -t amor         # Versículos que mencionen 'amor'"
    echo "  $0 -l Juan         # Solo del evangelio de Juan"
    echo "  $0 -o              # Solo fuentes locales HTML"
    echo ""
    echo "ESTRATEGIA HÍBRIDA:"
    echo "  1. Selecciona versículo aleatorio de archivos HTML locales"
    echo "  2. Obtiene texto limpio desde gbfxml en GitLab"
    echo "  3. Si falla, usa parsing HTML local como fallback"
    echo ""
    echo "Este script es parte del proyecto adJ y sigue principios menonitas"
    echo "de honestidad total - solo cita texto verificado de SpaTDP."
}

# Función para mapear nombres de archivos a nombres gbfxml
mapear_libro_gbfxml() {
    libro_archivo="$1"
    case "$libro_archivo" in
        "Mateo") echo "40-Matthew" ;;
        "Marcos") echo "41-Mark" ;;
        "Lucas") echo "42-Luke" ;;
        "Juan") echo "43-John" ;;
        "Hechos") echo "44-Acts" ;;
        "Romanos") echo "45-Romans" ;;
        "1_Corintios") echo "46-1Corinthians" ;;
        "2_Corintios") echo "47-2Corinthians" ;;
        "Gálatas") echo "48-Galatians" ;;
        "Efesios") echo "49-Ephesians" ;;
        "Filipenses") echo "50-Philippians" ;;
        "Colosenses") echo "51-Colossians" ;;
        "1_Tesalonicenses") echo "52-1Thessalonians" ;;
        "2_Tesalonicenses") echo "53-2Thessalonians" ;;
        "1_Timoteo") echo "54-1Timothy" ;;
        "2_Timoteo") echo "55-2Timothy" ;;
        "Tito") echo "56-Titus" ;;
        "Filemon") echo "57-Philemon" ;;
        "Timoteo1") echo "54-1Timothy" ;;
        *) echo "" ;;
    esac
}

# Función para obtener texto desde gbfxml
obtener_texto_gbfxml() {
    libro_archivo="$1"
    capitulo="$2"
    numero_versiculo="$3"
    
    # Mapear nombre del libro
    libro_gbfxml=$(mapear_libro_gbfxml "$libro_archivo")
    if [ -z "$libro_gbfxml" ]; then
        return 1
    fi
    
    # Construir URL del archivo gbfxml
    url_gbfxml="${GBFXML_BASE_URL}/${libro_gbfxml}.gbfxml"
    
    # Intentar descargar y extraer el versículo
    texto_gbfxml=$(curl -s --max-time 10 "$url_gbfxml" 2>/dev/null | \
        grep -A 5 -B 5 "verseID=\"${libro_gbfxml}.${capitulo}.${numero_versiculo}\"" | \
        sed 's/<[^>]*>//g' | \
        grep -v '^$' | \
        head -1 | \
        sed 's/^ *//g' | \
        sed 's/ *$//g')
    
    if [ -n "$texto_gbfxml" ] && [ ${#texto_gbfxml} -gt 10 ]; then
        echo "$texto_gbfxml"
        return 0
    else
        return 1
    fi
}

# Función para obtener versículo aleatorio (estrategia híbrida)
obtener_versiculo_aleatorio() {
    patron_archivos="$1"
    filtro_tema="$2"
    modo_offline="$3"
    
    # Obtener lista de archivos según el patrón
    archivos=$(ls ${SPATDP_DIR}/${patron_archivos} 2>/dev/null | grep -v -E "(index|referencias|strong|terminos|biblia_dp)")
    
    if [ -z "$archivos" ]; then
        echo "Error: No se encontraron archivos que coincidan con el patrón '$patron_archivos'"
        return 1
    fi
    
    # Seleccionar archivo aleatorio
    archivo_aleatorio=$(echo "$archivos" | shuf -n 1)
    
    if [ ! -f "$archivo_aleatorio" ]; then
        echo "Error: No se pudo acceder al archivo $archivo_aleatorio"
        return 1
    fi
    
    # Obtener nombre del libro y capítulo del archivo
    nombre_archivo=$(basename "$archivo_aleatorio" .html)
    libro_crudo=$(echo "$nombre_archivo" | sed 's/-[0-9]*$//')
    capitulo=$(echo "$nombre_archivo" | sed 's/.*-//')
    
    # Buscar versículos en el archivo
    if [ -n "$filtro_tema" ]; then
        # Buscar versículos que contengan el tema específico
        versiculos=$(grep -n "verse.*$filtro_tema" "$archivo_aleatorio" | head -10)
    else
        # Obtener todos los versículos del archivo
        versiculos=$(grep -n '<sup class="verse"' "$archivo_aleatorio")
    fi
    
    if [ -z "$versiculos" ]; then
        echo "No se encontraron versículos en $archivo_aleatorio"
        return 1
    fi
    
    # Seleccionar versículo aleatorio
    linea_versiculo=$(echo "$versiculos" | shuf -n 1)
    numero_linea=$(echo "$linea_versiculo" | cut -d: -f1)
    
    # Extraer el número del versículo de manera más robusta
    numero_versiculo=$(sed -n "${numero_linea}p" "$archivo_aleatorio" | sed -n 's/.*verse[^>]*>\([0-9]*\)<.*/\1/p')
    
    # ESTRATEGIA HÍBRIDA: Intentar obtener texto desde gbfxml primero
    texto_limpio=""
    metodo_usado="HTML local"
    
    if [ "$modo_offline" != "si" ]; then
        echo "Intentando obtener texto desde gbfxml..." >&2
        texto_gbfxml=$(obtener_texto_gbfxml "$libro_crudo" "$capitulo" "$numero_versiculo")
        if [ $? -eq 0 ] && [ -n "$texto_gbfxml" ]; then
            texto_limpio="$texto_gbfxml"
            metodo_usado="gbfxml (GitLab)"
        fi
    fi
    
}

# Función de fallback para parsing HTML local
obtener_texto_html_local() {
    archivo_aleatorio="$1"
    numero_linea="$2"
    
    # Extraer texto del versículo completo hasta el siguiente versículo
    siguiente_versiculo=$((numero_linea + 1))
    while [ $siguiente_versiculo -lt $((numero_linea + 20)) ]; do
        linea_siguiente=$(sed -n "${siguiente_versiculo}p" "$archivo_aleatorio")
        if echo "$linea_siguiente" | grep -q '<sup class="verse"'; then
            break
        fi
        siguiente_versiculo=$((siguiente_versiculo + 1))
    done
    
    # Extraer el texto del versículo completo
    texto_html=$(sed -n "${numero_linea},$((siguiente_versiculo - 1))p" "$archivo_aleatorio")
    
    # Proceso de limpieza (versión simplificada)
    texto_limpio=$(echo "$texto_html" | \
        sed 's/<sup class="strong"><a href="strong\.html#st[0-9]*" class="strong">[0-9]*<\/a><\/sup>//g' | \
        sed 's/<sup class="strong"><a href="strong\.html#st[0-9]*" class="strong">[0-9]*,<\/a><\/sup>//g' | \
        sed 's/<[^>]*>//g' | \
        sed 's/&nbsp;/ /g' | \
        sed 's/&amp;/\&/g' | \
        sed 's/[0-9][0-9][0-9][0-9]*,//g' | \
        sed 's/[0-9][0-9][0-9][0-9]*//g' | \
        sed 's/[0-9][0-9],//g' | \
        sed 's/[0-9][0-9]//g' | \
        tr -d '\n\r' | \
        sed 's/  */ /g' | \
        sed 's/^ *//g' | \
        sed 's/ *$//g')
    
    echo "$texto_limpio"
}

# Continuación de obtener_versiculo_aleatorio
obtener_versiculo_aleatorio_continuacion() {
    archivo_aleatorio="$1"
    libro_crudo="$2"
    capitulo="$3"
    numero_versiculo="$4"
    texto_limpio="$5"
    metodo_usado="$6"
    
    # Limpiar el nombre del libro (remover guiones bajos y números)
    libro=$(echo "$libro_crudo" | \
        sed 's/_/ /g' | \
        sed 's/1 /1 /' | \
        sed 's/2 /2 /' | \
        sed 's/Timoteo1/1 Timoteo/')
    
    # Correcciones específicas para nombres de libros
    case "$libro" in
        "1 Corintios") libro="1 Corintios" ;;
        "2 Corintios") libro="2 Corintios" ;;
        "1 Tesalonicenses") libro="1 Tesalonicenses" ;;
        "2 Tesalonicenses") libro="2 Tesalonicenses" ;;
        "1 Timoteo") libro="1 Timoteo" ;;
        "2 Timoteo") libro="2 Timoteo" ;;
        "Timoteo1") libro="1 Timoteo" ;;
    esac
    
    # Mostrar el versículo
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo "VERSÍCULO ALEATORIO DE SpaTDP"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    if [ -n "$numero_versiculo" ] && [ -n "$texto_limpio" ]; then
        echo "\"$texto_limpio\""
        echo ""
        echo "— $libro $capitulo:$numero_versiculo (SpaTDP)"
    else
        echo "\"$texto_limpio\""
        echo ""
        echo "— $libro $capitulo (SpaTDP)"
    fi
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "Fuente: $archivo_aleatorio"
    echo "Traducción: SpaTDP (Nuevo Testamento - traduccion.pasosdejesus.org)"
    echo ""
}

# Procesar argumentos
PATRON="*.html"
FILTRO_TEMA=""

while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            mostrar_ayuda
            exit 0
            ;;
        -e|--evangelios)
            PATRON="{Mateo,Marcos,Lucas,Juan}-*.html"
            shift
            ;;
        -p|--pablo)
            PATRON="{Romanos,1_Corintios,2_Corintios,Gálatas,Efesios,Filipenses,Colosenses,1_Tesalonicenses,2_Tesalonicenses,1_Timoteo,2_Timoteo,Tito,Filemon}-*.html"
            shift
            ;;
        -t|--tema)
            FILTRO_TEMA="$2"
            shift 2
            ;;
        -l|--libro)
            PATRON="$2-*.html"
            shift 2
            ;;
        *)
            echo "Opción desconocida: $1"
            echo "Use -h para ayuda."
            exit 1
            ;;
    esac
done

# Verificar que existe el directorio SpaTDP
if [ ! -d "$SPATDP_DIR" ]; then
    echo "Error: No se encuentra el directorio $SPATDP_DIR"
    echo "Asegúrese de ejecutar este script desde el directorio raíz de adJ"
    exit 1
fi

# Obtener y mostrar versículo aleatorio
obtener_versiculo_aleatorio "$PATRON" "$FILTRO_TEMA"