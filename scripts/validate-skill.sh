#!/bin/bash
# ============================================================
#  iAmasters OS — validate-skill.sh
#  Descarrega e valida uma skill desde GitHub antes de a instalar
#  Uso: bash scripts/validate-skill.sh <github-url>
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

URL="${1:-}"

if [ -z "$URL" ]; then
    echo -e "${RED}ERROR${NC} Falta URL do GitHub"
    echo "Uso: bash scripts/validate-skill.sh <github-url>"
    echo "Exemplo: bash scripts/validate-skill.sh https://github.com/user/repo/tree/main/skills/my-skill"
    exit 1
fi

# Generate temp dir
HASH=$(echo "$URL" | shasum | cut -c1-12)
TMP_DIR="/tmp/iamasters-os-skill-validate-$HASH"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo ""
echo -e "${BLUE}[1/5]${NC} A descarregar skill do GitHub..."

# Parse GitHub URL: https://github.com/user/repo/tree/branch/path/to/skill
# Or: https://github.com/user/repo
# Strategy: git clone + cd ao subpath
GH_REGEX='https://github.com/([^/]+)/([^/]+)(/tree/([^/]+)(/(.*))?)?'
if [[ "$URL" =~ $GH_REGEX ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    BRANCH="${BASH_REMATCH[4]:-main}"
    SUBPATH="${BASH_REMATCH[6]:-}"
    GIT_URL="https://github.com/$OWNER/$REPO_NAME.git"
    echo -e "${CYAN}  Repo:${NC} $OWNER/$REPO_NAME @ $BRANCH"
    [ -n "$SUBPATH" ] && echo -e "${CYAN}  Subpath:${NC} $SUBPATH"
else
    echo -e "${RED}  ERROR${NC} URL não parece de GitHub válida"
    exit 1
fi

# Shallow clone
git clone --depth 1 --branch "$BRANCH" "$GIT_URL" "$TMP_DIR/repo" 2>&1 | tail -3

# Resolve skill path
if [ -n "$SUBPATH" ]; then
    SKILL_PATH="$TMP_DIR/repo/$SUBPATH"
else
    SKILL_PATH="$TMP_DIR/repo"
fi

if [ ! -d "$SKILL_PATH" ]; then
    echo -e "${RED}  ERROR${NC} Subpath não existe: $SUBPATH"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo -e "${GREEN}  OK${NC} Skill descarregada em $SKILL_PATH"

# ── Step 2: Check structure ──
echo -e "${BLUE}[2/5]${NC} A validar estrutura..."

ERRORS=()
WARNINGS=()
OK_CHECKS=()

# Find SKILL.md
SKILL_MD=""
if [ -f "$SKILL_PATH/SKILL.md" ]; then
    SKILL_MD="$SKILL_PATH/SKILL.md"
elif [ -f "$SKILL_PATH/skill.md" ]; then
    SKILL_MD="$SKILL_PATH/skill.md"
else
    ERRORS+=("Não foi encontrado SKILL.md na raiz da skill")
fi

if [ -n "$SKILL_MD" ]; then
    OK_CHECKS+=("SKILL.md presente")

    # Check YAML frontmatter
    if head -n 1 "$SKILL_MD" | grep -q '^---$'; then
        OK_CHECKS+=("YAML frontmatter inicia corretamente")
    else
        ERRORS+=("YAML frontmatter não inicia com --- na linha 1")
    fi

    # Extract name and description from frontmatter
    SKILL_NAME=$(awk '/^name:/{print $2}' "$SKILL_MD" | head -n 1)
    SKILL_DESC=$(awk '/^description:/{ $1=""; print substr($0,2) }' "$SKILL_MD" | head -n 1)

    # Validate name
    if [ -z "$SKILL_NAME" ]; then
        ERRORS+=("Campo 'name' ausente ou vazio")
    elif [[ ! "$SKILL_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
        ERRORS+=("Campo 'name' tem de ser kebab-case ([a-z][a-z0-9-]*): '$SKILL_NAME'")
    else
        OK_CHECKS+=("name='$SKILL_NAME' é kebab-case válido")
    fi

    # Validate description
    DESC_LEN=${#SKILL_DESC}
    if [ "$DESC_LEN" -lt 30 ]; then
        ERRORS+=("'description' demasiado curta ($DESC_LEN chars, mínimo 30)")
    elif [ "$DESC_LEN" -lt 50 ]; then
        WARNINGS+=("'description' curta ($DESC_LEN chars). Recomendado 50-500. Pode afetar ativação.")
    elif [ "$DESC_LEN" -gt 500 ]; then
        WARNINGS+=("'description' longa ($DESC_LEN chars). Recomendado 50-500. Pode inflar contexto do system prompt.")
    else
        OK_CHECKS+=("description $DESC_LEN chars (no intervalo)")
    fi

    # Check verbs of intention
    if echo "$SKILL_DESC" | grep -qiE '\b(cria|gera|analisa|extrai|escreve|audita|valida|deteta|resume|traduz|procura|investiga|monitoriza|constrói|formata|crea|genera|analiza|extrae|escribe|create|generate|analyze|extract|write|validate|detect|build)\b'; then
        OK_CHECKS+=("description contém verbo de intenção")
    else
        WARNINGS+=("description não parece ter verbo de intenção claro. Pode afetar ativação.")
    fi

    # Check skill size
    SKILL_MD_SIZE=$(wc -c < "$SKILL_MD")
    if [ "$SKILL_MD_SIZE" -gt 10000 ]; then
        WARNINGS+=("SKILL.md grande ($SKILL_MD_SIZE chars > 10000). Considera mover knowledge para references/")
    fi

    # Check references/ exists if SKILL.md large
    if [ "$SKILL_MD_SIZE" -gt 5000 ] && [ ! -d "$SKILL_PATH/references" ]; then
        WARNINGS+=("SKILL.md médio-grande sem pasta references/. Bom padrão é separar knowledge")
    fi
fi

# Check scripts for safety
DANGEROUS_PATTERNS=()
if find "$SKILL_PATH" -name "*.sh" -o -name "*.py" 2>/dev/null | grep -q .; then
    while IFS= read -r script; do
        if grep -qE 'rm -rf /|rm -rf ~|sudo rm|>\s*/dev/sda|dd if=|mkfs\.|wget [^|]*\| sh|curl [^|]*\| sh|eval\s*\(\s*\$' "$script"; then
            DANGEROUS_PATTERNS+=("$(basename "$script")")
        fi
    done < <(find "$SKILL_PATH" -name "*.sh" -o -name "*.py" 2>/dev/null)
fi

if [ ${#DANGEROUS_PATTERNS[@]} -gt 0 ]; then
    ERRORS+=("Scripts com padrões perigosos: ${DANGEROUS_PATTERNS[*]}")
else
    OK_CHECKS+=("Não há scripts com padrões destrutivos óbvios")
fi

# Check for hardcoded secrets
SECRET_FILES=()
while IFS= read -r f; do
    if grep -qE '(api[_-]?key|secret|token|password)\s*=\s*["'"'"'][a-zA-Z0-9_-]{20,}' "$f" 2>/dev/null; then
        SECRET_FILES+=("$(basename "$f")")
    fi
done < <(find "$SKILL_PATH" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.py" -o -name "*.json" \))

if [ ${#SECRET_FILES[@]} -gt 0 ]; then
    WARNINGS+=("Possíveis credenciais hardcoded em: ${SECRET_FILES[*]}")
else
    OK_CHECKS+=("Sem credenciais hardcoded detetadas")
fi

# ── Step 3: Check conflict with local skills ──
echo -e "${BLUE}[3/5]${NC} A verificar conflitos com skills locais..."

CONFLICT=false
if [ -n "$SKILL_NAME" ]; then
    # Search recursively in .claude/skills/
    EXISTING=$(find "$REPO_ROOT/.claude/skills" -type d -name "$SKILL_NAME" 2>/dev/null | head -n 1)
    if [ -n "$EXISTING" ]; then
        CONFLICT=true
        WARNINGS+=("Já existe skill local com nome '$SKILL_NAME' em: ${EXISTING/$REPO_ROOT/}")
    else
        OK_CHECKS+=("Sem conflito de nome com skills locais")
    fi
fi

# ── Step 4: Report ──
echo -e "${BLUE}[4/5]${NC} Relatório de validação..."
echo

echo -e "${BOLD}Skill:${NC} ${SKILL_NAME:-?}"
echo -e "${BOLD}Description:${NC} ${SKILL_DESC:-?}"
echo
echo -e "${BOLD}URL:${NC} $URL"
echo -e "${BOLD}Tamanho SKILL.md:${NC} ${SKILL_MD_SIZE:-?} chars"
echo

if [ ${#OK_CHECKS[@]} -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓ OK ($((${#OK_CHECKS[@]})))${NC}"
    for c in "${OK_CHECKS[@]}"; do
        echo -e "  ${GREEN}✓${NC} $c"
    done
    echo
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}${BOLD}⚠ WARNINGS ($((${#WARNINGS[@]})))${NC}"
    for w in "${WARNINGS[@]}"; do
        echo -e "  ${YELLOW}⚠${NC} $w"
    done
    echo
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}${BOLD}✗ ERRORS ($((${#ERRORS[@]})))${NC}"
    for e in "${ERRORS[@]}"; do
        echo -e "  ${RED}✗${NC} $e"
    done
    echo
fi

# ── Step 5: Verdict + next steps ──
echo -e "${BLUE}[5/5]${NC} Veredicto"

if [ ${#ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}${BOLD}NÃO PASSA${NC} - Erros bloqueantes detetados."
    echo "  A skill NÃO deve instalar-se até corrigir os erros."
    echo
    echo -e "Skill descarregada em: ${CYAN}$SKILL_PATH${NC}"
    echo "  Inspeciona-a manualmente se quiseres."
    rm -rf "$TMP_DIR" 2>/dev/null || true
    exit 1
elif [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}${BOLD}PASSA COM WARNINGS${NC}"
    echo "  A skill pode instalar-se mas revê os warnings."
else
    echo -e "${GREEN}${BOLD}PASSA LIMPO${NC}"
    echo "  A skill cumpre todos os checks."
fi

echo
echo -e "${BOLD}Para instalar (se decidires fazê-lo):${NC}"
if $CONFLICT; then
    echo -e "  ${YELLOW}Há conflito de nome. Decide:${NC}"
    echo -e "  1) Substituir local: ${CYAN}cp -r $SKILL_PATH .claude/skills/<categoria>/$SKILL_NAME/${NC}"
    echo -e "     (faz backup primeiro!)"
    echo -e "  2) Instalar com nome diferente: edita SKILL.md frontmatter 'name:' e depois copia"
else
    echo -e "  ${CYAN}cp -r $SKILL_PATH .claude/skills/<categoria>/$SKILL_NAME/${NC}"
    echo -e "  Onde <categoria> é: _meta, marketing, operations, strategy, tools, visualization"
fi
echo
echo -e "${BOLD}Após instalar:${NC}"
echo -e "  1) Atualizar synapsis/skills-catalog.json com nova entrada"
echo -e "  2) Reinicia o Claude Code (Ctrl+C × 2 + claude)"
echo -e "  3) Testa ativação com prompt típico da skill"
echo -e "  4) Executa /wrap-up para registar a mudança"
echo
echo "Skill descarregada em: $SKILL_PATH (não se elimina automaticamente)"
