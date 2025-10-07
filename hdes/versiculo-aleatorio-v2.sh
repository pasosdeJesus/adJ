#!/bin/ksh
# versiculo-aleatorio.sh - Selecciona un versículo aleatorio de SpaTDP
# Parte del proyecto adJ - Aprendiendo de Jesús
# ESTRATEGIA HÍBRIDA: HTML local + gbfxml con XSL para texto limpio

SPATDP_DIR="arboldvd/evangelios_dp"
BIBLIA_DP_REPO="/tmp/biblia_dp"
XSL_EXTRAER="/tmp/extraer-versiculo.xsl"

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "OPCIONES:"
    echo "  -h, --help         Mostrar esta ayuda"
    echo "  -e, --evangelios   Solo evangelios (Mateo, Marcos, Lucas, Juan)"
    echo "  -p, --pablo        Solo epístolas de Pablo"
    echo "  -l, --libro LIBRO  Seleccionar de un libro específico"
    echo "  -o, --offline      Solo fuentes locales HTML"
    echo ""
    echo "ESTRATEGIA HÍBRIDA: HTML local + gbfxml/XSL para texto perfecto"
}

# Mapear nombres de archivos a nombres gbfxml
mapear_libro_gbfxml() {
    libro_archivo="$1"
    case "$libro_archivo" in
        "Mateo") echo "mateo.gbfxml" ;;
        "Marcos") echo "marcos.gbfxml" ;;
        "Lucas") echo "lucas.gbfxml" ;;
        "Juan") echo "juan.gbfxml" ;;
        "Hechos") echo "hechos.gbfxml" ;;
        "Romanos") echo "romanos.gbfxml" ;;
        "1_Corintios") echo "corintios1.gbfxml" ;;
        "2_Corintios") echo "corintios2.gbfxml" ;;
        "Gálatas") echo "galatas.gbfxml" ;;
        "Efesios") echo "efesios.gbfxml" ;;
        "Filipenses") echo "filipenses.gbfxml" ;;
        "Colosenses") echo "colosenses.gbfxml" ;;
        "1_Tesalonicenses") echo "tesalonicenses1.gbfxml" ;;
        "2_Tesalonicenses") echo "tesalonicenses2.gbfxml" ;;
        "1_Timoteo") echo "timoteo1.gbfxml" ;;
        "2_Timoteo") echo "timoteo2.gbfxml" ;;
        "Tito") echo "tito.gbfxml" ;;
        "Filemon") echo "filemon.gbfxml" ;;
        *) echo "" ;;
    esac
}

# Función principal
obtener_versiculo_aleatorio() {
    patron_archivos="$1"
    modo_offline="$2"
    
    # Obtener archivo aleatorio de HTML local
    archivos=$(ls ${SPATDP_DIR}/${patron_archivos} 2>/dev/null | grep -v -E "(index|referencias|strong|terminos|biblia_dp)")
    if [ -z "$archivos" ]; then
        echo "Error: No se encontraron archivos que coincidan con el patrón '$patron_archivos'"
        return 1
    fi
    
    archivo_aleatorio=$(echo "$archivos" | shuf -n 1)
    nombre_archivo=$(basename "$archivo_aleatorio" .html)
    libro_crudo=$(echo "$nombre_archivo" | sed 's/-[0-9]*$//')
    capitulo=$(echo "$nombre_archivo" | sed 's/.*-//')
    
    # Obtener versículo aleatorio
    versiculos=$(grep -n '<sup class="verse"' "$archivo_aleatorio")
    linea_versiculo=$(echo "$versiculos" | shuf -n 1)
    numero_linea=$(echo "$linea_versiculo" | cut -d: -f1)
    numero_versiculo=$(sed -n "${numero_linea}p" "$archivo_aleatorio" | sed -n 's/.*verse[^>]*>\([0-9]*\)<.*/\1/p')
    
    # Intentar obtener texto limpio con XSL
    texto_limpio=""
    metodo_usado="HTML local"
    
    if [ "$modo_offline" != "si" ] && [ -d "$BIBLIA_DP_REPO" ] && [ -f "$XSL_EXTRAER" ]; then
        archivo_gbfxml=$(mapear_libro_gbfxml "$libro_crudo")
        if [ -n "$archivo_gbfxml" ] && [ -f "${BIBLIA_DP_REPO}/${archivo_gbfxml}" ]; then
            versiculo_id="${libro_crudo}-${capitulo}-${numero_versiculo}"
            texto_gbfxml=$(cd "$BIBLIA_DP_REPO" && xsltproc --stringparam versiculo "$versiculo_id" "$XSL_EXTRAER" "$archivo_gbfxml" 2>/dev/null)
            if [ -n "$texto_gbfxml" ] && [ ${#texto_gbfxml} -gt 5 ]; then
                texto_limpio="$texto_gbfxml"
                metodo_usado="gbfxml + XSL"
            fi
        fi
    fi
    
    # Fallback a HTML local si es necesario
    if [ -z "$texto_limpio" ]; then
        # Usar el método HTML simplificado anterior
        siguiente_versiculo=$((numero_linea + 1))
        while [ $siguiente_versiculo -lt $((numero_linea + 15)) ]; do
            linea_siguiente=$(sed -n "${siguiente_versiculo}p" "$archivo_aleatorio")
            if echo "$linea_siguiente" | grep -q '<sup class="verse"'; then
                break
            fi
            siguiente_versiculo=$((siguiente_versiculo + 1))
        done
        
        texto_html=$(sed -n "${numero_linea},$((siguiente_versiculo - 1))p" "$archivo_aleatorio")
        texto_limpio=$(echo "$texto_html" | \
            sed 's/<[^>]*>//g' | \
            sed 's/&nbsp;/ /g' | \
            tr -d '\n\r' | \
            sed 's/  */ /g' | \
            sed 's/^ *//g' | \
            sed 's/ *$//g')
        metodo_usado="HTML local (fallback)"
    fi
    
    # Formatear nombre del libro
    libro=$(echo "$libro_crudo" | sed 's/_/ /g')
    case "$libro" in
        "1 Corintios") libro="1 Corintios" ;;
        "2 Corintios") libro="2 Corintios" ;;
        "1 Tesalonicenses") libro="1 Tesalonicenses" ;;
        "2 Tesalonicenses") libro="2 Tesalonicenses" ;;
        "1 Timoteo") libro="1 Timoteo" ;;
        "2 Timoteo") libro="2 Timoteo" ;;
    esac
    
    # Mostrar resultado
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo "VERSÍCULO ALEATORIO DE SpaTDP"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "\"$texto_limpio\""
    echo ""
    echo "— $libro $capitulo:$numero_versiculo (SpaTDP)"
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "Fuente: $archivo_aleatorio"
    echo "Método: $metodo_usado"
    echo "Traducción: SpaTDP (Nuevo Testamento - traduccion.pasosdejesus.org)"
    echo ""
}

# Procesar argumentos
PATRON="*.html"
MODO_OFFLINE=""

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
        -l|--libro)
            PATRON="$2-*.html"
            shift 2
            ;;
        -o|--offline)
            MODO_OFFLINE="si"
            shift
            ;;
        *)
            echo "Opción desconocida: $1"
            exit 1
            ;;
    esac
done

# Verificar directorio SpaTDP
if [ ! -d "$SPATDP_DIR" ]; then
    echo "Error: No se encuentra el directorio $SPATDP_DIR"
    exit 1
fi

# Ejecutar
obtener_versiculo_aleatorio "$PATRON" "$MODO_OFFLINE"