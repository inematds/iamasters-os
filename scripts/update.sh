#!/bin/bash
# ============================================================
#  iAmasters OS — update.sh
#  Actualiza el repo desde upstream con conflict resolution
#  - Skills propias del operador NO se sobrescriben
#  - Brand context, context, projects NUNCA se tocan
#  - Sinapsis vendored se actualiza si hay nueva versión upstream
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/.backup/$(date +%Y%m%d_%H%M%S)"

echo ""
echo -e "${PURPLE}${BOLD}============================================================${NC}"
echo -e "${PURPLE}${BOLD}  iAmasters OS — Update${NC}"
echo -e "${PURPLE}${BOLD}============================================================${NC}"
echo ""

cd "$REPO_ROOT"

# ── Step 1: Check git state ──
echo -e "${BLUE}[1/6]${NC} Verificando estado del repo..."

if [ ! -d ".git" ]; then
    echo -e "${RED}  ERROR${NC} Este directorio no es un git repo"
    exit 1
fi

# Detect uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "${YELLOW}  ! Tienes cambios sin commitear${NC}"
    echo -e "${YELLOW}    Recomendación: commitea o stash antes de update${NC}"
    read -p "  ¿Continuar de todas formas? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Update cancelado."
        exit 0
    fi
fi

CURRENT_BRANCH=$(git branch --show-current)
echo -e "${GREEN}  OK${NC} Branch actual: $CURRENT_BRANCH"

# ── Step 2: Backup ──
echo -e "${BLUE}[2/6]${NC} Creando backup..."

mkdir -p "$BACKUP_DIR"
# Backup user data (skills propias añadidas, brand-context, context, projects, clients, .env)
for d in ".claude/skills" "brand-context" "context" "projects" "clients" ".env" ".claude/settings.json"; do
    if [ -e "$REPO_ROOT/$d" ]; then
        # Use cp -R to preserve structure
        target_parent=$(dirname "$BACKUP_DIR/$d")
        mkdir -p "$target_parent"
        cp -R "$REPO_ROOT/$d" "$BACKUP_DIR/$d" 2>/dev/null || true
    fi
done

echo -e "${GREEN}  OK${NC} Backup en: ${BACKUP_DIR/$REPO_ROOT/.}/"

# ── Step 3: Detect remote ──
echo -e "${BLUE}[3/6]${NC} Comprobando remote..."

if ! git remote get-url origin &> /dev/null; then
    echo -e "${YELLOW}  ! No hay remote 'origin' configurado${NC}"
    echo -e "${YELLOW}    Para activar updates futuros:${NC}"
    echo -e "${YELLOW}    git remote add origin <url>${NC}"
    echo
    echo "Update local-only completado (no hay upstream)."
    exit 0
fi

REMOTE_URL=$(git remote get-url origin)
echo -e "${GREEN}  OK${NC} Remote: $REMOTE_URL"

# ── Step 4: Fetch upstream changes ──
echo -e "${BLUE}[4/6]${NC} Fetching upstream..."

git fetch origin "$CURRENT_BRANCH" 2>&1 | tail -3 || {
    echo -e "${RED}  ERROR${NC} Fetch falló. Comprueba conexión y permisos."
    exit 1
}

# Check if already up-to-date
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$CURRENT_BRANCH" 2>/dev/null || echo "")

if [ -z "$REMOTE" ]; then
    echo -e "${YELLOW}  ! Branch '$CURRENT_BRANCH' no existe en origin${NC}"
    echo "Update local-only completado."
    exit 0
fi

if [ "$LOCAL" = "$REMOTE" ]; then
    echo -e "${GREEN}  OK${NC} Ya estás al día. Nada nuevo upstream."
    echo
    echo "Update completado (sin cambios)."
    exit 0
fi

echo -e "${CYAN}  ->${NC} Hay cambios upstream. Analizando..."

# ── Step 5: Categorize changes ──
echo -e "${BLUE}[5/6]${NC} Clasificando cambios..."

CHANGED_FILES=$(git diff --name-only HEAD..origin/"$CURRENT_BRANCH")

# Categorize
SAFE_TO_UPDATE=()
USER_DATA_CONFLICT=()
SKILLS_NEW=()
SKILLS_MODIFIED=()

while IFS= read -r file; do
    case "$file" in
        # NEVER touch user data — siempre keep local
        brand-context/*|context/*|projects/*|clients/*|.env)
            USER_DATA_CONFLICT+=("$file")
            ;;
        # Skills: detect new vs modified
        .claude/skills/*)
            if [ -f "$REPO_ROOT/$file" ]; then
                SKILLS_MODIFIED+=("$file")
            else
                SKILLS_NEW+=("$file")
            fi
            ;;
        # Sinapsis vendored: safe to update (es upstream del repo de Luis)
        vendor/sinapsis/*)
            SAFE_TO_UPDATE+=("$file")
            ;;
        # System files: safe to update
        *)
            SAFE_TO_UPDATE+=("$file")
            ;;
    esac
done <<< "$CHANGED_FILES"

echo
echo -e "${BOLD}Resumen de cambios:${NC}"
echo -e "  ${GREEN}Safe to update${NC}: ${#SAFE_TO_UPDATE[@]} archivos (system, vendor)"
echo -e "  ${CYAN}Skills nuevas${NC}: ${#SKILLS_NEW[@]} archivos"
echo -e "  ${YELLOW}Skills modificadas${NC}: ${#SKILLS_MODIFIED[@]} archivos (potencial conflicto)"
echo -e "  ${RED}User data${NC}: ${#USER_DATA_CONFLICT[@]} archivos (NUNCA se tocan, ignoramos upstream)"
echo

# ── Step 6: Apply updates ──
echo -e "${BLUE}[6/6]${NC} Aplicando updates..."

# Strategy:
# - SAFE_TO_UPDATE: pull directo (con git checkout origin/branch -- file)
# - SKILLS_NEW: pull (no había local, no hay conflicto)
# - SKILLS_MODIFIED: preguntar al operador caso por caso
# - USER_DATA_CONFLICT: skip (mantener local)

# Apply safe updates
for file in "${SAFE_TO_UPDATE[@]}" "${SKILLS_NEW[@]}"; do
    git checkout "origin/$CURRENT_BRANCH" -- "$file" 2>/dev/null || true
done

if [ ${#SAFE_TO_UPDATE[@]} -gt 0 ] || [ ${#SKILLS_NEW[@]} -gt 0 ]; then
    UPDATED=$((${#SAFE_TO_UPDATE[@]} + ${#SKILLS_NEW[@]}))
    echo -e "${GREEN}  OK${NC} $UPDATED archivos actualizados (safe + new skills)"
fi

# Handle skill conflicts case-by-case
if [ ${#SKILLS_MODIFIED[@]} -gt 0 ]; then
    echo
    echo -e "${YELLOW}Conflictos en skills modificadas localmente:${NC}"
    echo
    for file in "${SKILLS_MODIFIED[@]}"; do
        echo -e "${BOLD}$file${NC}"
        echo "  [k] Keep local (mantener tu versión)"
        echo "  [u] Use upstream (aceptar cambio del repo)"
        echo "  [d] Diff (ver diferencia)"
        echo "  [s] Skip (decidir después)"
        read -p "  Acción: " -n 1 -r action
        echo
        case "$action" in
            u|U)
                git checkout "origin/$CURRENT_BRANCH" -- "$file"
                echo -e "  ${CYAN}->${NC} upstream aplicado"
                ;;
            d|D)
                git diff HEAD..origin/"$CURRENT_BRANCH" -- "$file" | head -30
                echo "  (diff truncado a 30 líneas)"
                read -p "  Acción tras ver diff (k/u/s): " -n 1 -r action2
                echo
                if [[ "$action2" =~ ^[uU]$ ]]; then
                    git checkout "origin/$CURRENT_BRANCH" -- "$file"
                    echo -e "  ${CYAN}->${NC} upstream aplicado"
                else
                    echo -e "  ${CYAN}->${NC} local mantenido"
                fi
                ;;
            *)
                echo -e "  ${CYAN}->${NC} local mantenido"
                ;;
        esac
    done
fi

# Skip user data (always keep local — that's the contract)
if [ ${#USER_DATA_CONFLICT[@]} -gt 0 ]; then
    echo -e "${CYAN}  ->${NC} ${#USER_DATA_CONFLICT[@]} archivos de user data ignorados (siempre keep local)"
fi

# ── Done ──
echo
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD}  Update completado${NC}"
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo
echo -e "  ${BOLD}Backup guardado en:${NC} ${BACKUP_DIR/$REPO_ROOT/.}/"
echo -e "  ${BOLD}Si algo va mal:${NC}"
echo -e "  cp -r ${BACKUP_DIR/$REPO_ROOT/.}/<carpeta> ./<carpeta>"
echo
echo -e "  ${BOLD}Recomendado:${NC}"
echo -e "  - Revisar ${CYAN}git status${NC} y ${CYAN}git diff HEAD${NC}"
echo -e "  - Probar ${CYAN}claude${NC} en el repo y verificar que todo funciona"
echo -e "  - Si todo OK: ${CYAN}git add . && git commit -m 'chore: update from upstream'${NC}"
echo
