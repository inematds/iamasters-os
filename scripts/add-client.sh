#!/bin/bash
# ============================================================
#  iAmasters OS — add-client.sh
#  Cria cliente novo em clients/<nome>/ a partir de um template vertical
#  Uso: bash scripts/add-client.sh <nome-cliente> [vertical]
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
    echo -e "${RED}ERROR${NC} Falta o nome do cliente"
    echo ""
    echo "Uso: bash scripts/add-client.sh <nome-cliente> [vertical]"
    echo ""
    echo "Verticais disponíveis:"
    if [ -d "$TEMPLATES_DIR" ]; then
        for t in "$TEMPLATES_DIR"/*/; do
            tname=$(basename "$t")
            [ "$tname" = "_templates" ] && continue
            echo "  - $tname"
        done
    fi
    echo "  - vacio (sem template, estrutura mínima)"
    echo ""
    echo "Exemplo: bash scripts/add-client.sh acme-corp freelance-ia"
    exit 1
fi

# Sanitize client name (kebab-case only)
if [[ ! "$CLIENT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    echo -e "${RED}ERROR${NC} Nome do cliente só permite [a-z0-9-]"
    echo "       Converte espaços para hífenes: 'Acme Corp' → 'acme-corp'"
    exit 1
fi

CLIENT_DIR="$CLIENTS_DIR/$CLIENT_NAME"

# Check if client already exists
if [ -d "$CLIENT_DIR" ]; then
    echo -e "${RED}ERROR${NC} O cliente '$CLIENT_NAME' já existe em $CLIENT_DIR"
    exit 1
fi

# Resolve template
if [ -z "$TEMPLATE" ] || [ "$TEMPLATE" = "vacio" ]; then
    USE_TEMPLATE=false
    echo -e "${CYAN}Modo:${NC} estrutura vazia (sem template)"
else
    TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE"
    if [ ! -d "$TEMPLATE_DIR" ]; then
        echo -e "${RED}ERROR${NC} Template '$TEMPLATE' não existe em $TEMPLATES_DIR"
        echo ""
        echo "Verticais disponíveis:"
        for t in "$TEMPLATES_DIR"/*/; do
            tname=$(basename "$t")
            [ "$tname" = "_templates" ] && continue
            echo "  - $tname"
        done
        exit 1
    fi
    USE_TEMPLATE=true
    echo -e "${CYAN}Modo:${NC} clonar do template '$TEMPLATE'"
fi

echo ""
echo -e "${BLUE}A criar cliente '$CLIENT_NAME'...${NC}"

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
    echo -e "${CYAN}  ->${NC} Lembra-te de preencher os placeholders {{...}} em:"
    echo -e "       $CLIENT_DIR/brand-context/voice/voice-profile.md"
    echo -e "       $CLIENT_DIR/brand-context/positioning/positioning.md"
    echo -e "       $CLIENT_DIR/brand-context/icp/icp.md"
    echo -e "       $CLIENT_DIR/context/user.md"
else
    # Modo vazio: só .gitkeep em cada subpasta
    for d in brand-context/voice brand-context/positioning brand-context/icp brand-context/assets context projects projects/briefs; do
        touch "$CLIENT_DIR/$d/.gitkeep"
    done
    echo -e "${GREEN}  OK${NC} Estrutura vazia criada"
    echo -e "${CYAN}  ->${NC} Configura o cliente com:"
    echo -e "       cd clients/$CLIENT_NAME && claude"
    echo -e "       E executa: /start-here (lança marketing-brand-voice se não houver voice profile)"
fi

# Step 3: Optional client-specific CLAUDE.md (override do raiz)
cat > "$CLIENT_DIR/CLAUDE.md" <<EOF
# CLAUDE.md — Cliente $CLIENT_NAME

> Este ficheiro adiciona overrides específicos para este cliente.
> O CLAUDE.md raiz do repo continua a aplicar-se; este faz merge por cima.

## Cliente
- Nome: $CLIENT_NAME
- Template base: ${TEMPLATE:-vacio}
- Criado: $(date -u +%Y-%m-%d)

## Regras específicas para este cliente

(Adiciona aqui qualquer regra que se aplique SÓ a este cliente)

- Voice principal: ler brand-context/voice/voice-profile.md
- ICP a respeitar: ler brand-context/icp/icp.md
- Positioning: ler brand-context/positioning/positioning.md

## Skills prioritárias para este cliente

(Se tens skills custom para este cliente, lista-as aqui)

## Notas operativas

(Qualquer coisa que o operador deva lembrar ao trabalhar aqui)
EOF

echo -e "${GREEN}  OK${NC} CLAUDE.md do cliente criado"

# Done
echo ""
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD}  Cliente '$CLIENT_NAME' criado com sucesso${NC}"
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo ""
echo -e "  ${BOLD}Estrutura:${NC}"
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
echo -e "  ${BOLD}Próximo passo:${NC}"
echo -e "  ${CYAN}cd clients/$CLIENT_NAME && claude${NC}"
echo -e "  E executa ${CYAN}/start-here${NC} para arrancar a sessão com este cliente"
echo ""
