#!/bin/bash
# ============================================================
#  iAmasters OS — add-client.sh
#  Crea cliente nuevo en clients/<nombre>/ desde un template vertical
#  Uso: bash scripts/add-client.sh <nombre-cliente> [vertical]
#       bash scripts/add-client.sh acme-corp freelance-ia
#       bash scripts/add-client.sh widget-shop agencia-marketing
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLIENTS_DIR="$REPO_ROOT/clients"
TEMPLATES_DIR="$CLIENTS_DIR/_templates"

# Validate args
CLIENT_NAME="${1:-}"
TEMPLATE="${2:-}"

if [ -z "$CLIENT_NAME" ]; then
    echo -e "${RED}ERROR${NC} Falta nombre del cliente"
    echo ""
    echo "Uso: bash scripts/add-client.sh <nombre-cliente> [vertical]"
    echo ""
    echo "Verticales disponibles:"
    if [ -d "$TEMPLATES_DIR" ]; then
        for t in "$TEMPLATES_DIR"/*/; do
            tname=$(basename "$t")
            [ "$tname" = "_templates" ] && continue
            echo "  - $tname"
        done
    fi
    echo "  - vacio (sin template, estructura mínima)"
    echo ""
    echo "Ejemplo: bash scripts/add-client.sh acme-corp freelance-ia"
    exit 1
fi

# Sanitize client name (kebab-case only)
if [[ ! "$CLIENT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}ERROR${NC} Nombre del cliente solo permite [a-z0-9-]"
    echo "       Convierte espacios a guiones: 'Acme Corp' → 'acme-corp'"
    exit 1
fi

CLIENT_DIR="$CLIENTS_DIR/$CLIENT_NAME"

# Check if client already exists
if [ -d "$CLIENT_DIR" ]; then
    echo -e "${RED}ERROR${NC} El cliente '$CLIENT_NAME' ya existe en $CLIENT_DIR"
    exit 1
fi

# Resolve template
if [ -z "$TEMPLATE" ] || [ "$TEMPLATE" = "vacio" ]; then
    USE_TEMPLATE=false
    echo -e "${CYAN}Modo:${NC} estructura vacía (sin template)"
else
    TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE"
    if [ ! -d "$TEMPLATE_DIR" ]; then
        echo -e "${RED}ERROR${NC} Template '$TEMPLATE' no existe en $TEMPLATES_DIR"
        echo ""
        echo "Verticales disponibles:"
        for t in "$TEMPLATES_DIR"/*/; do
            tname=$(basename "$t")
            [ "$tname" = "_templates" ] && continue
            echo "  - $tname"
        done
        exit 1
    fi
    USE_TEMPLATE=true
    echo -e "${CYAN}Modo:${NC} clonar desde template '$TEMPLATE'"
fi

echo ""
echo -e "${BLUE}Creando cliente '$CLIENT_NAME'...${NC}"

# Step 1: Create base structure
mkdir -p "$CLIENT_DIR"/{brand-context/{voice,positioning,icp,assets},context,projects/briefs}

# Step 2: Copy template if applicable
if $USE_TEMPLATE; then
    # Copy brand-context templates
    cp "$TEMPLATE_DIR/brand-context/voice/voice-profile.template.md" "$CLIENT_DIR/brand-context/voice/voice-profile.md"
    cp "$TEMPLATE_DIR/brand-context/positioning/positioning.template.md" "$CLIENT_DIR/brand-context/positioning/positioning.md"
    cp "$TEMPLATE_DIR/brand-context/icp/icp.template.md" "$CLIENT_DIR/brand-context/icp/icp.md"

    # Copy context
    cp "$TEMPLATE_DIR/context/soul.md" "$CLIENT_DIR/context/soul.md"
    cp "$TEMPLATE_DIR/context/user.template.md" "$CLIENT_DIR/context/user.md"

    # Replace {{CLIENT_NAME}} placeholder in copied files
    if command -v sed &> /dev/null; then
        find "$CLIENT_DIR" -type f -name "*.md" -exec sed -i.bak "s/{{CLIENT_NAME}}/$CLIENT_NAME/g" {} \;
        find "$CLIENT_DIR" -name "*.bak" -delete
    fi

    echo -e "${GREEN}  OK${NC} Template '$TEMPLATE' clonado"
    echo -e "${CYAN}  ->${NC} Recuerda completar los placeholders {{...}} en:"
    echo -e "       $CLIENT_DIR/brand-context/voice/voice-profile.md"
    echo -e "       $CLIENT_DIR/brand-context/positioning/positioning.md"
    echo -e "       $CLIENT_DIR/brand-context/icp/icp.md"
    echo -e "       $CLIENT_DIR/context/user.md"
else
    # Modo vacío: solo .gitkeep en cada subcarpeta
    for d in brand-context/voice brand-context/positioning brand-context/icp brand-context/assets context projects projects/briefs; do
        touch "$CLIENT_DIR/$d/.gitkeep"
    done
    echo -e "${GREEN}  OK${NC} Estructura vacía creada"
    echo -e "${CYAN}  ->${NC} Configura el cliente con:"
    echo -e "       cd clients/$CLIENT_NAME && claude"
    echo -e "       Y ejecuta: /start-here (lanzará marketing-brand-voice si no hay voice profile)"
fi

# Step 3: Optional client-specific CLAUDE.md (override del raíz)
cat > "$CLIENT_DIR/CLAUDE.md" <<EOF
# CLAUDE.md — Cliente $CLIENT_NAME

> Este archivo añade overrides específicos para este cliente.
> El CLAUDE.md raíz del repo se sigue aplicando; este se merge encima.

## Cliente
- Nombre: $CLIENT_NAME
- Template base: ${TEMPLATE:-vacio}
- Creado: $(date -u +%Y-%m-%d)

## Reglas específicas para este cliente

(Añade aquí cualquier regla que se aplique SOLO a este cliente)

- Voice principal: leer brand-context/voice/voice-profile.md
- ICP a respetar: leer brand-context/icp/icp.md
- Positioning: leer brand-context/positioning/positioning.md

## Skills prioritarias para este cliente

(Si tienes skills custom para este cliente, lístalas aquí)

## Notas operativas

(Cualquier cosa que el operador deba recordar al trabajar aquí)
EOF

echo -e "${GREEN}  OK${NC} CLAUDE.md del cliente creado"

# Done
echo ""
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD}  Cliente '$CLIENT_NAME' creado correctamente${NC}"
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo ""
echo -e "  ${BOLD}Estructura:${NC}"
echo -e "  $CLIENT_DIR/"
echo -e "  ├── CLAUDE.md (overrides cliente)"
echo -e "  ├── brand-context/"
echo -e "  │   ├── voice/voice-profile.md"
echo -e "  │   ├── positioning/positioning.md"
echo -e "  │   ├── icp/icp.md"
echo -e "  │   └── assets/"
echo -e "  ├── context/"
echo -e "  │   ├── soul.md"
echo -e "  │   └── user.md"
echo -e "  └── projects/"
echo ""
echo -e "  ${BOLD}Siguiente paso:${NC}"
echo -e "  ${CYAN}cd clients/$CLIENT_NAME && claude${NC}"
echo -e "  Y ejecuta ${CYAN}/start-here${NC} para arrancar la sesión con este cliente"
echo ""
