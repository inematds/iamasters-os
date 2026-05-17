#!/bin/bash
# ============================================================
#  iAmasters OS — check-translation.sh
#  Verifica qualidade da tradução PT-PT e integridade estrutural.
#  Exit 0 = OK · Exit 1 = falhas detetadas.
#
#  Uso:    bash scripts/check-translation.sh
#  CI:     adicionar a .github/workflows/
#  Hook:   ln -s ../../scripts/check-translation.sh .git/hooks/pre-commit
# ============================================================

set +e  # queremos correr tudo e somar falhas
cd "$(dirname "$0")/.."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

FAIL=0
PASS=0

ok()   { echo -e "${GREEN}✓${NC} $*"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}✗${NC} $*"; FAIL=$((FAIL+1)); }
warn() { echo -e "${YELLOW}!${NC} $*"; }

echo ""
echo -e "${BOLD}iAmasters OS — Translation quality check${NC}"
echo "════════════════════════════════════════════"

# ── A. Resíduos de espanhol (lista negra de palavras só-ES) ──
echo ""
echo -e "${BOLD}A. ES residue${NC}"
ES_HITS=$(grep -rIn --exclude-dir={vendor,.git,node_modules,projects,.backup,clients} \
    --exclude="check-translation.sh" --exclude="translation-style.md" --exclude="CHANGELOG.md" \
    -E "\b(según|cualquier|aunque|cuándo|cuáles|nombre del|fecha del|razón\b|sesión\b|debes\b|deberías\b|tienes\b|carpeta\b|archivo\b|usuario\b|también|todavía|necesita|cualquiera|aquí está)\b" \
    . 2>/dev/null \
    | grep -vE "(tool-humanizer/references/(examples|ai-tells)|ORIGIN\.md.*Repositorio|Sistema cognito)" || true)
if [ -n "$ES_HITS" ]; then
    fail "ES residue detetado:"
    echo "$ES_HITS" | head -10
    [ $(echo "$ES_HITS" | wc -l) -gt 10 ] && echo "  ... e mais $(($(echo "$ES_HITS" | wc -l) - 10)) ocorrências"
else
    ok "sem resíduos ES (excluindo humanizer samples)"
fi

# ── B. CLAUDE.md gate string preservada ──
echo ""
echo -e "${BOLD}B. CLAUDE.md gate integrity${NC}"
GATE_COUNT=$(grep -c "iAmasters OS" CLAUDE.md 2>/dev/null || echo 0)
if [ "$GATE_COUNT" -ge 2 ]; then
    ok "literal 'iAmasters OS' presente ($GATE_COUNT × em CLAUDE.md)"
else
    fail "CLAUDE.md tem menos de 2 ocorrências de 'iAmasters OS' — _install-gate.sh:30 vai partir"
fi

# ── C. YAML frontmatter de todas as SKILL.md ──
echo ""
echo -e "${BOLD}C. SKILL.md frontmatter${NC}"
INVALID_SKILLS=()
for f in $(find .claude/skills -name SKILL.md); do
    head -5 "$f" | grep -qE "^name: [a-z][a-z0-9-]*$" || INVALID_SKILLS+=("$f")
done
if [ ${#INVALID_SKILLS[@]} -eq 0 ]; then
    ok "$(find .claude/skills -name SKILL.md | wc -l) SKILL.md com name: kebab-case válido"
else
    fail "SKILL.md com name: inválido ou ausente:"
    printf '    %s\n' "${INVALID_SKILLS[@]}"
fi

# ── D. Bash syntax dos scripts ──
echo ""
echo -e "${BOLD}D. Bash syntax${NC}"
BAD_SCRIPTS=()
for f in scripts/*.sh; do
    bash -n "$f" 2>/dev/null || BAD_SCRIPTS+=("$f")
done
if [ ${#BAD_SCRIPTS[@]} -eq 0 ]; then
    ok "todos os scripts em scripts/ com sintaxe válida"
else
    fail "scripts com erro de sintaxe:"
    printf '    %s\n' "${BAD_SCRIPTS[@]}"
fi

# ── E. JSON template parseable ──
echo ""
echo -e "${BOLD}E. JSON templates${NC}"
if command -v node >/dev/null 2>&1; then
    if node -e "JSON.parse(require('fs').readFileSync('scripts/_install-state.template.json','utf8'))" 2>/dev/null; then
        ok "_install-state.template.json parseable"
    else
        fail "_install-state.template.json não é JSON válido"
    fi
else
    warn "node não disponível, salta validação JSON"
fi

# ── F. Placeholders preservados nos templates de cliente ──
echo ""
echo -e "${BOLD}F. Client template placeholders${NC}"
PLACEHOLDER_COUNT=$(grep -rh -o "{{[^}]*}}" clients/_templates/ 2>/dev/null | sort -u | wc -l)
if [ "$PLACEHOLDER_COUNT" -gt 10 ]; then
    ok "$PLACEHOLDER_COUNT placeholders únicos {{...}} preservados em templates"
else
    fail "menos de 10 placeholders em clients/_templates/ — algo foi traduzido por engano?"
fi

# ── G. Skills mencionadas em CLAUDE.md existem ──
echo ""
echo -e "${BOLD}G. Skills cross-reference${NC}"
MISSING_SKILLS=()
for skill in meta-onboarding-wizard welcome-quick-win meta-deep-dive marketing-brand-voice marketing-copywriting tool-output-verifier health-check; do
    found=$(find .claude/skills -type d -name "$skill" 2>/dev/null | wc -l)
    [ "$found" -eq 0 ] && MISSING_SKILLS+=("$skill")
done
if [ ${#MISSING_SKILLS[@]} -eq 0 ]; then
    ok "todas as skills core referenciadas existem"
else
    fail "skills core mencionadas em CLAUDE.md mas em falta no filesystem:"
    printf '    %s\n' "${MISSING_SKILLS[@]}"
fi

# ── H. Variantes BR a evitar (qualidade PT-PT) ──
echo ""
echo -e "${BOLD}H. PT-PT vocabulary check (evitar BR)${NC}"
BR_HITS=$(grep -rIn --exclude-dir={vendor,.git,node_modules,projects,.backup,clients} \
    --exclude="check-translation.sh" --exclude="translation-style.md" --exclude="CHANGELOG.md" \
    -E "\b(arquivo\b|você\b|tela\b|celular\b|aquivo\b)\b" . 2>/dev/null \
    | grep -vE "(\"arquivo\"|'arquivo'|/archive/|arquivar|pronome|(eu/nós)|primeira pessoa|segunda pessoa)" || true)
if [ -z "$BR_HITS" ]; then
    ok "sem variantes BR óbvias detetadas"
else
    warn "possíveis variantes BR encontradas (revê):"
    echo "$BR_HITS" | head -5
fi

# ── Resumo ──
echo ""
echo "════════════════════════════════════════════"
if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ PASS${NC} · $PASS checks OK"
    exit 0
else
    echo -e "${RED}${BOLD}✗ FAIL${NC} · $FAIL erros · $PASS checks OK"
    echo ""
    echo "Corrige os erros acima e volta a correr."
    exit 1
fi
