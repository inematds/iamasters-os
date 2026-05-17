#!/bin/bash
# ============================================================
#  iAmasters OS — Installer v0.6 (state-machine, reentrant)
#  Sistema operativo agêntico para operadores de IA
#  https://github.com/iamasters-academy/iamasters-os
# ============================================================
#
# Mudanças vs v0.5:
#   • State machine persistente em ~/.claude/skills/_install-state.json
#   • Validação profunda do Sinapsis (não só "o ficheiro existe")
#   • Deteção Python multi-plataforma (python3 / py -3 / python)
#   • Modo --resume: continua desde a última fase bem-sucedida
#   • Modo --force-reinstall: backup do state e arranque limpo
#   • Se uma fase falha, fica `failed` no state (sem aborto silencioso)
#
# Flags:
#   --resume            Continua desde a última fase não completada
#   --force-reinstall   Backup do state atual e arranque de zero
#   --skip-sinapsis     (debug) Salta a instalação do Sinapsis
#
# Saída estruturada (parseable):
#   [OK]    <fase>            — completada
#   [SKIP]  <fase> · <motivo> — já estava ou não se aplica
#   [WARN]  <fase> · <motivo> — segue com limitação
#   [ERROR] <fase> · <motivo> — bloqueante, fica no state como failed
#
# Idempotente e reentrante.
# ============================================================

set -e

# ── Output helpers ──
ok()    { echo "[OK]    $*"; }
skip()  { echo "[SKIP]  $*"; }
warn()  { echo "[WARN]  $*"; }
err()   { echo "[ERROR] $*" >&2; }
info()  { echo ">>      $*"; }
title() { echo ""; echo "── $* ──"; }

# ── Paths ──
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SINAPSIS_VENDOR="$REPO_ROOT/vendor/sinapsis"
CLAUDE_HOME="$HOME/.claude"
SKILLS_DIR="$CLAUDE_HOME/skills"
STATE_FILE="$SKILLS_DIR/_install-state.json"
STATE_TEMPLATE="$SCRIPT_DIR/_install-state.template.json"

# ── Flags ──
RESUME=false
FORCE_REINSTALL=false
SKIP_SINAPSIS=false
for arg in "$@"; do
    case "$arg" in
        --resume)          RESUME=true ;;
        --force-reinstall) FORCE_REINSTALL=true ;;
        --skip-sinapsis)   SKIP_SINAPSIS=true ;;
        *) ;;
    esac
done

echo ""
echo "============================================================"
echo "  iAmasters OS — Installer v0.6.0"
echo "  Repo: $REPO_ROOT"
echo "============================================================"
echo ""

# ── JSON helpers (usamos node, que o Sinapsis já requer) ──
# Se node não está, os reemplazos usam python3 (que quase toda a gente tem).

JSON_RUNTIME=""
detect_json_runtime() {
    if command -v node >/dev/null 2>&1; then
        JSON_RUNTIME="node"
    elif command -v python3 >/dev/null 2>&1; then
        JSON_RUNTIME="python3"
    elif command -v python >/dev/null 2>&1 && python --version 2>&1 | grep -q "Python 3"; then
        JSON_RUNTIME="python"
    else
        return 1
    fi
}

json_validate() {
    # $1 = path to JSON file
    case "$JSON_RUNTIME" in
        node)
            node -e "JSON.parse(require('fs').readFileSync('$1','utf8'))" 2>/dev/null
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "import json; json.load(open('$1'))" 2>/dev/null
            ;;
    esac
}

json_set_phase() {
    # $1 = phase name, $2 = field (status|validatedAt|...), $3 = value (must be valid JSON literal)
    local phase="$1"
    local field="$2"
    local value="$3"

    case "$JSON_RUNTIME" in
        node)
            node -e "
                const fs = require('fs');
                const f = '$STATE_FILE';
                const s = JSON.parse(fs.readFileSync(f, 'utf8'));
                if (!s.phases['$phase']) s.phases['$phase'] = {};
                s.phases['$phase']['$field'] = $value;
                s.lastUpdatedAt = new Date().toISOString();
                fs.writeFileSync(f, JSON.stringify(s, null, 2));
            "
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json, datetime
f = '$STATE_FILE'
s = json.load(open(f))
s['phases'].setdefault('$phase', {})
s['phases']['$phase']['$field'] = $value
s['lastUpdatedAt'] = datetime.datetime.utcnow().isoformat() + 'Z'
json.dump(s, open(f, 'w'), indent=2)
"
            ;;
    esac
}

json_set_root() {
    # $1 = field, $2 = JSON value
    case "$JSON_RUNTIME" in
        node)
            node -e "
                const fs = require('fs');
                const f = '$STATE_FILE';
                const s = JSON.parse(fs.readFileSync(f, 'utf8'));
                s['$1'] = $2;
                s.lastUpdatedAt = new Date().toISOString();
                fs.writeFileSync(f, JSON.stringify(s, null, 2));
            "
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json, datetime
f = '$STATE_FILE'
s = json.load(open(f))
s['$1'] = $2
s['lastUpdatedAt'] = datetime.datetime.utcnow().isoformat() + 'Z'
json.dump(s, open(f, 'w'), indent=2)
"
            ;;
    esac
}

json_get_phase_status() {
    # $1 = phase name; echoes "pending" / "in-progress" / "done" / "failed" / "skipped"
    case "$JSON_RUNTIME" in
        node)
            node -e "
                const s = JSON.parse(require('fs').readFileSync('$STATE_FILE','utf8'));
                console.log(s.phases['$1'] && s.phases['$1'].status || 'pending');
            "
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json
s = json.load(open('$STATE_FILE'))
print(s['phases'].get('$1', {}).get('status', 'pending'))
"
            ;;
    esac
}

json_push_error() {
    # $1 = phase, $2 = message
    case "$JSON_RUNTIME" in
        node)
            node -e "
                const fs = require('fs');
                const f = '$STATE_FILE';
                const s = JSON.parse(fs.readFileSync(f, 'utf8'));
                s.errors.push({ phase: '$1', message: \`$2\`, at: new Date().toISOString() });
                s.lastUpdatedAt = new Date().toISOString();
                fs.writeFileSync(f, JSON.stringify(s, null, 2));
            "
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json, datetime
f = '$STATE_FILE'
s = json.load(open(f))
s['errors'].append({'phase': '$1', 'message': '''$2''', 'at': datetime.datetime.utcnow().isoformat() + 'Z'})
s['lastUpdatedAt'] = datetime.datetime.utcnow().isoformat() + 'Z'
json.dump(s, open(f, 'w'), indent=2)
"
            ;;
    esac
}

mark_phase_done() {
    # $1 = phase name
    json_set_phase "$1" "status" '"done"'
    json_set_phase "$1" "validatedAt" "\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""

    # Append to completedPhases array
    case "$JSON_RUNTIME" in
        node)
            node -e "
                const fs = require('fs');
                const f = '$STATE_FILE';
                const s = JSON.parse(fs.readFileSync(f, 'utf8'));
                if (!s.completedPhases.includes('$1')) s.completedPhases.push('$1');
                fs.writeFileSync(f, JSON.stringify(s, null, 2));
            "
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json
f = '$STATE_FILE'
s = json.load(open(f))
if '$1' not in s['completedPhases']:
    s['completedPhases'].append('$1')
json.dump(s, open(f, 'w'), indent=2)
"
            ;;
    esac
}

mark_phase_failed() {
    # $1 = phase, $2 = reason
    json_set_phase "$1" "status" '"failed"'
    json_push_error "$1" "$2"
    err "$1 · $2"
    err "Estado registado em $STATE_FILE — executa 'bash scripts/install.sh --resume' depois de arranjar"
    exit 1
}

# ── State machine init ──
init_state() {
    mkdir -p "$SKILLS_DIR"

    if $FORCE_REINSTALL && [ -f "$STATE_FILE" ]; then
        local backup="$STATE_FILE.$(date -u +%Y%m%dT%H%M%SZ).bak"
        cp "$STATE_FILE" "$backup"
        warn "State anterior salvaguardado em $backup"
        rm -f "$STATE_FILE"
    fi

    if [ ! -f "$STATE_FILE" ]; then
        if [ ! -f "$STATE_TEMPLATE" ]; then
            err "Template $STATE_TEMPLATE não encontrado · repo corrupto, volta a clonar"
            exit 1
        fi
        cp "$STATE_TEMPLATE" "$STATE_FILE"
        json_set_root "repoPath" "\"$REPO_ROOT\""
        json_set_root "startedAt" "\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\""
        ok "State machine inicializado: $STATE_FILE"
    else
        # Validar que seja JSON parseable
        if ! json_validate "$STATE_FILE"; then
            err "State file corrupto · executa com --force-reinstall para reiniciar"
            exit 1
        fi
        if $RESUME; then
            ok "State machine carregado (modo --resume)"
        else
            skip "State machine já existe (idempotente — usa --resume para continuar ou --force-reinstall para reiniciar)"
        fi
    fi
}

# ── Phase 1: prereqs ──
phase_prereqs() {
    local current_status
    current_status=$(json_get_phase_status "prereqs")
    if [ "$current_status" = "done" ] && ! $FORCE_REINSTALL; then
        skip "prereqs · já validados (status=done)"
        return 0
    fi

    title "[1/2] A validar prerequisitos"
    json_set_phase "prereqs" "status" '"in-progress"'

    local checks="{}"
    local has_blocker=false

    # OS detection
    local os_type="unknown"
    case "$(uname -s)" in
        Darwin*)  os_type="macos" ;;
        Linux*)   os_type="linux" ;;
        MINGW*|MSYS*|CYGWIN*) os_type="windows-bash" ;;
    esac
    ok "OS: $os_type ($(uname -m))"
    if [ "$os_type" = "windows-bash" ]; then
        warn "Windows + Git Bash detetado — WSL recomendado para melhor experiência"
    fi

    # Git (required)
    if ! command -v git >/dev/null 2>&1; then
        mark_phase_failed "prereqs" "Git não encontrado · instala-o em https://git-scm.com"
    fi
    local git_ver
    git_ver=$(git --version | awk '{print $3}')
    ok "git: $git_ver"

    # Node.js (required for Sinapsis hooks + JSON helpers)
    if ! command -v node >/dev/null 2>&1; then
        mark_phase_failed "prereqs" "Node.js não encontrado · é obrigatório (os hooks Sinapsis precisam dele). Instala desde https://nodejs.org (≥18)"
    fi
    local node_ver
    node_ver=$(node --version | sed 's/v//')
    local node_major
    node_major=$(echo "$node_ver" | cut -d. -f1)
    if [ "$node_major" -lt 18 ]; then
        mark_phase_failed "prereqs" "Node.js v$node_ver é antigo · requer-se ≥18"
    fi
    ok "node: v$node_ver"

    # Python 3 (optional but recommended) — deteção multi-plataforma
    local python_cmd=""
    for candidate in python3 "py -3" python python3.11 python3.12 python3.10; do
        if command -v $(echo "$candidate" | awk '{print $1}') >/dev/null 2>&1; then
            if $candidate --version 2>&1 | grep -qE "Python 3\.(9|10|11|12|13)"; then
                python_cmd="$candidate"
                break
            fi
        fi
    done
    # Casos especiais Windows (paths absolutos comuns)
    if [ -z "$python_cmd" ] && [ "$os_type" = "windows-bash" ]; then
        for win_path in "/c/Python311/python.exe" "/c/Python312/python.exe" "/c/Python310/python.exe"; do
            if [ -x "$win_path" ]; then
                python_cmd="$win_path"
                break
            fi
        done
    fi
    if [ -z "$python_cmd" ]; then
        warn "Python 3 não encontrado · os hooks de observação do Sinapsis ficarão desativados"
        warn "  Para os ativar: instala Python ≥3.9 desde https://python.org (NÃO Microsoft Store)"
    else
        local py_ver
        py_ver=$($python_cmd --version 2>&1 | awk '{print $2}')
        ok "python: $python_cmd ($py_ver)"
    fi

    # Claude Code detection (não bloqueia, só informa)
    if command -v claude >/dev/null 2>&1; then
        ok "Claude CLI no PATH"
    elif [ -d "/Applications/Claude.app" ] || [ -d "$HOME/Applications/Claude.app" ]; then
        ok "Claude Desktop (macOS app)"
    elif [ -n "$CLAUDE_DESKTOP" ] || [ -n "$CLAUDECODE" ]; then
        ok "Variáveis Claude Code detetadas"
    else
        warn "Claude Code/Desktop não detetado no PATH · se o tens instalado, ignora"
    fi

    # Persistir checks no state
    local checks_json
    checks_json=$(cat <<EOF
{
  "os": "$os_type",
  "git": "$git_ver",
  "node": "v$node_ver",
  "python": "${python_cmd:-not-found}"
}
EOF
)
    json_set_phase "prereqs" "checks" "$checks_json"
    mark_phase_done "prereqs"
}

# ── Phase 2: sinapsis-engine ──
validate_sinapsis_deep() {
    # Validação PROFUNDA: não só "existe o ficheiro", mas que seja funcional.
    # Devolve 0 se tudo OK, 1 se falta algo. Imprime detalhe.
    local issues=0

    [ -f "$SKILLS_DIR/_operator-state.json" ] || { warn "  validação: falta _operator-state.json"; issues=$((issues+1)); }
    [ -f "$SKILLS_DIR/_catalog.json" ] || { warn "  validação: falta _catalog.json"; issues=$((issues+1)); }

    if [ -f "$SKILLS_DIR/_operator-state.json" ]; then
        if ! json_validate "$SKILLS_DIR/_operator-state.json"; then
            warn "  validação: _operator-state.json não é JSON parseable"
            issues=$((issues+1))
        fi
    fi
    if [ -f "$SKILLS_DIR/_catalog.json" ]; then
        if ! json_validate "$SKILLS_DIR/_catalog.json"; then
            warn "  validação: _catalog.json não é JSON parseable"
            issues=$((issues+1))
        fi
    fi

    # Hooks executáveis (os que o Sinapsis instala)
    for hook in _passive-activator.sh _instinct-activator.sh _session-learner.sh; do
        if [ ! -f "$SKILLS_DIR/$hook" ]; then
            warn "  validação: falta hook $hook"
            issues=$((issues+1))
        elif [ ! -x "$SKILLS_DIR/$hook" ]; then
            warn "  validação: hook $hook não é executável"
            issues=$((issues+1))
        fi
    done

    # ≥1 skill real instalada (SKILL.md, não ficheiros vazios)
    local skill_count
    skill_count=$(find "$SKILLS_DIR" -maxdepth 3 -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$skill_count" -lt 1 ]; then
        warn "  validação: não foi encontrada nenhuma SKILL.md em $SKILLS_DIR"
        issues=$((issues+1))
    fi

    # settings.json com secção hooks (sinal de que o Sinapsis registou os hooks)
    if [ -f "$CLAUDE_HOME/settings.json" ]; then
        if ! grep -q '"hooks"' "$CLAUDE_HOME/settings.json"; then
            warn "  validação: ~/.claude/settings.json existe mas não tem secção 'hooks'"
            issues=$((issues+1))
        fi
    else
        warn "  validação: ~/.claude/settings.json não existe"
        issues=$((issues+1))
    fi

    return $issues
}

phase_sinapsis_engine() {
    local current_status
    current_status=$(json_get_phase_status "sinapsis-engine")
    if [ "$current_status" = "done" ] && ! $FORCE_REINSTALL; then
        # Mesmo assim re-validamos para detetar drift (alguém apagou ficheiros manualmente)
        if validate_sinapsis_deep >/dev/null 2>&1; then
            skip "sinapsis-engine · já instalado e validado (status=done)"
            return 0
        else
            warn "sinapsis-engine · marcado done mas validação profunda falha · a reinstalar"
            json_set_phase "sinapsis-engine" "status" '"in-progress"'
        fi
    fi

    title "[2/2] A instalar Sinapsis engine"
    json_set_phase "sinapsis-engine" "status" '"in-progress"'

    if $SKIP_SINAPSIS; then
        warn "sinapsis-engine · saltado por --skip-sinapsis (só debug)"
        return 0
    fi

    if [ ! -d "$SINAPSIS_VENDOR" ]; then
        mark_phase_failed "sinapsis-engine" "vendor/sinapsis/ não encontrado · repo incompleto, volta a clonar"
    fi
    if [ ! -f "$SINAPSIS_VENDOR/install.sh" ]; then
        mark_phase_failed "sinapsis-engine" "vendor/sinapsis/install.sh não encontrado · volta a clonar o repo"
    fi

    # Verificar se já está instalado a sério (validação profunda, não só existência)
    info "A verificar se o Sinapsis já está operativo..."
    if validate_sinapsis_deep >/dev/null 2>&1; then
        ok "Sinapsis já está operativo (validação profunda passa)"
        compute_and_store_checksum
        mark_phase_done "sinapsis-engine"
        return 0
    fi

    # Não está, ou está incompleto. Executar o installer vendorizado.
    info "A executar vendor/sinapsis/install.sh..."
    local prev_dir="$PWD"
    cd "$SINAPSIS_VENDOR"
    if ! bash install.sh; then
        cd "$prev_dir"
        mark_phase_failed "sinapsis-engine" "vendor/sinapsis/install.sh devolveu erro · revê o output acima"
    fi
    cd "$prev_dir"

    # Validação PÓS-instalação (isto é o que evita "instalações fantasma")
    info "A validar instalação do Sinapsis (validação profunda)..."
    if ! validate_sinapsis_deep; then
        mark_phase_failed "sinapsis-engine" "Sinapsis executou-se mas a validação profunda falha · ver warnings acima"
    fi

    compute_and_store_checksum
    mark_phase_done "sinapsis-engine"
    ok "Sinapsis instalado e validado"
}

compute_and_store_checksum() {
    # Hash dos ficheiros chave do Sinapsis para detetar drift posterior
    local files_hash
    if command -v shasum >/dev/null 2>&1; then
        files_hash=$(find "$SKILLS_DIR" -maxdepth 1 -type f -name "_*.json" -o -name "_*.sh" 2>/dev/null | sort | xargs shasum -a 256 2>/dev/null | shasum -a 256 | awk '{print $1}')
    elif command -v sha256sum >/dev/null 2>&1; then
        files_hash=$(find "$SKILLS_DIR" -maxdepth 1 -type f -name "_*.json" -o -name "_*.sh" 2>/dev/null | sort | xargs sha256sum 2>/dev/null | sha256sum | awk '{print $1}')
    else
        files_hash="sha-tool-not-found"
    fi
    local validation_json
    validation_json=$(cat <<EOF
{
  "operator_state_json_valid": true,
  "catalog_json_valid": true,
  "hooks_executable": true,
  "skills_count": $(find "$SKILLS_DIR" -maxdepth 3 -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
}
EOF
)
    json_set_phase "sinapsis-engine" "validation" "$validation_json"
    json_set_phase "sinapsis-engine" "checksum" "\"sha256:$files_hash\""
}

# ── OS layer setup (não é uma fase do state, são ficheiros do repo) ──
setup_os_layer() {
    title "A configurar camada OS do repo (ficheiros locais)"

    mkdir -p "$REPO_ROOT/projects" "$REPO_ROOT/projects/briefs" "$REPO_ROOT/projects/welcome"
    mkdir -p "$REPO_ROOT/context"
    mkdir -p "$REPO_ROOT/brand-context/voice" "$REPO_ROOT/brand-context/positioning" "$REPO_ROOT/brand-context/icp" "$REPO_ROOT/brand-context/assets"

    for empty_dir in "projects/briefs" "projects/welcome" "brand-context/voice" "brand-context/positioning" "brand-context/icp" "brand-context/assets"; do
        [ ! -f "$REPO_ROOT/$empty_dir/.gitkeep" ] && touch "$REPO_ROOT/$empty_dir/.gitkeep" || true
    done
    ok "Diretórios de projeto criados"

    # Soul.md
    if [ ! -f "$REPO_ROOT/context/soul.md" ]; then
        cat > "$REPO_ROOT/context/soul.md" <<'EOF'
# Soul · personalidade do agente

> Como respondes ao utilizador. Isto é estático (muda pouco).

## Tom
- Direto, sem rodeios
- Caloroso mas não efusivo
- 2-3 opções máx com recomendação, não listas exaustivas

## Idioma
- Português sempre com o operador
- Outputs cliente no idioma configurado em `me.md`

## O que NÃO fazes
- Vender humo
- Inflar palavras vazias
- Executar ações destrutivas sem confirmar

---
*Última atualização: instalação inicial · este ficheiro modificas-lo tu ao teu gosto*
EOF
        ok "context/soul.md criado"
    fi

    if [ ! -f "$REPO_ROOT/context/decisions-log.md" ]; then
        cat > "$REPO_ROOT/context/decisions-log.md" <<'EOF'
# Decisions log

Diário append-only de decisões do operador.
Padrão inspirado em [claude-code-second-brain](https://github.com/Luispitik/claude-code-second-brain) do Luis Pitik.

---
EOF
        ok "context/decisions-log.md criado"
    fi

    if [ ! -f "$REPO_ROOT/context/learnings.md" ]; then
        cat > "$REPO_ROOT/context/learnings.md" <<'EOF'
# Learnings

Feedback consolidado de skills, append-only.

---
EOF
        ok "context/learnings.md criado"
    fi

    if [ ! -f "$REPO_ROOT/.env" ] && [ -f "$REPO_ROOT/.env.example" ]; then
        cp "$REPO_ROOT/.env.example" "$REPO_ROOT/.env"
        ok ".env criado a partir de .env.example"
    fi

    # Instalar hook _install-gate.sh em SKILLS_DIR (é o gate de SessionStart)
    if [ -f "$SCRIPT_DIR/_install-gate.sh" ]; then
        cp "$SCRIPT_DIR/_install-gate.sh" "$SKILLS_DIR/_install-gate.sh"
        chmod +x "$SKILLS_DIR/_install-gate.sh"
        ok "_install-gate.sh instalado em $SKILLS_DIR (hook SessionStart)"
        register_session_start_hook
    else
        warn "_install-gate.sh não encontrado em scripts/ · o gate de bloqueio não funcionará"
    fi
}

# Regista o hook SessionStart em ~/.claude/settings.json sem pisar o que o Sinapsis ou
# outros plugins tenham registado. Idempotente: se já está, não duplica.
register_session_start_hook() {
    local settings="$CLAUDE_HOME/settings.json"
    if [ ! -f "$settings" ]; then
        warn "  ~/.claude/settings.json ainda não existe · o Sinapsis devia tê-lo criado"
        return 0
    fi

    node <<NODE_EOF
const fs = require('fs');
const settingsPath = '$settings';
try {
  const s = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
  if (!s.hooks) s.hooks = {};
  if (!Array.isArray(s.hooks.SessionStart)) s.hooks.SessionStart = [];

  // Detetar se o install-gate já está registado (idempotência)
  const alreadyRegistered = s.hooks.SessionStart.some(group =>
    Array.isArray(group.hooks) && group.hooks.some(h =>
      typeof h.command === 'string' && h.command.includes('_install-gate.sh')
    )
  );

  if (alreadyRegistered) {
    console.log('[SKIP] SessionStart hook já registado em settings.json');
    process.exit(0);
  }

  s.hooks.SessionStart.push({
    hooks: [
      {
        _comment: 'iAmasters OS install gate: bloqueia sessões se _install-state.json não completo',
        type: 'command',
        command: 'bash ~/.claude/skills/_install-gate.sh',
        timeout: 5
      }
    ]
  });

  fs.writeFileSync(settingsPath, JSON.stringify(s, null, 2));
  console.log('[OK] SessionStart hook registado em ~/.claude/settings.json');
} catch (e) {
  console.error('[WARN] Não consegui modificar settings.json: ' + e.message);
  process.exit(0);
}
NODE_EOF
}

# ── Migration helper: deteta instalação v0.5.x existente e preenche state retroativamente ──
migrate_v05_existing() {
    # Se os ficheiros de context/ já existem e têm conteúdo real, marca context-files done.
    # Útil para utilizadores que atualizam de v0.5.x para v0.6 sem ter de refazer o onboarding.

    local migrated_files="[]"
    for f in "context/me.md" "context/work.md" "context/current-priorities.md" "context/goals.md"; do
        if [ -f "$REPO_ROOT/$f" ]; then
            local size
            size=$(wc -c < "$REPO_ROOT/$f" | tr -d ' ')
            if [ "$size" -gt 100 ]; then
                case "$JSON_RUNTIME" in
                    node)
                        migrated_files=$(node -e "
                            const arr = $migrated_files;
                            arr.push('$f');
                            process.stdout.write(JSON.stringify(arr));
                        ")
                        ;;
                    python3|python)
                        migrated_files=$("$JSON_RUNTIME" -c "
import json
arr = $migrated_files
arr.append('$f')
print(json.dumps(arr))
")
                        ;;
                esac
            fi
        fi
    done

    # Se temos os 4 ficheiros → marcamos context-files done
    local count
    case "$JSON_RUNTIME" in
        node)    count=$(node -e "process.stdout.write(String($migrated_files.length))") ;;
        python3|python) count=$("$JSON_RUNTIME" -c "print(len($migrated_files))") ;;
    esac

    if [ "$count" = "4" ]; then
        local current_cf_status
        current_cf_status=$(json_get_phase_status "context-files")
        if [ "$current_cf_status" != "done" ]; then
            json_set_phase "context-files" "filesCreated" "$migrated_files"
            json_set_phase "context-files" "filesPending" "[]"
            mark_phase_done "context-files"
            ok "Migrado v0.5→v0.6: context-files marcado como done (4 ficheiros pré-existentes com conteúdo real)"
        fi
    fi

    # Se o _operator-state.json tem needsOnboarding: false, marcamos operator-state done
    if [ -f "$SKILLS_DIR/_operator-state.json" ]; then
        local needs_onboarding
        case "$JSON_RUNTIME" in
            node)
                needs_onboarding=$(node -e "
                    try {
                        const s = JSON.parse(require('fs').readFileSync('$SKILLS_DIR/_operator-state.json','utf8'));
                        process.stdout.write(String(s.needsOnboarding === false));
                    } catch (e) { process.stdout.write('false'); }
                ")
                ;;
            python3|python)
                needs_onboarding=$("$JSON_RUNTIME" -c "
import json
try:
    s = json.load(open('$SKILLS_DIR/_operator-state.json'))
    print(str(s.get('needsOnboarding') == False).lower())
except: print('false')
")
                ;;
        esac
        if [ "$needs_onboarding" = "true" ]; then
            local current_os_status
            current_os_status=$(json_get_phase_status "operator-state")
            if [ "$current_os_status" != "done" ]; then
                mark_phase_done "operator-state"
                ok "Migrado v0.5→v0.6: operator-state marcado como done (needsOnboarding: false detetado)"
            fi
        fi
    fi

    # Se projects/welcome/ tem algo, assumimos que welcome-quick-win se fez numa sessão anterior
    if [ -d "$REPO_ROOT/projects/welcome" ] && [ -n "$(find "$REPO_ROOT/projects/welcome" -type f ! -name '.gitkeep' 2>/dev/null | head -1)" ]; then
        local current_wc_status
        current_wc_status=$(json_get_phase_status "welcome-completed")
        if [ "$current_wc_status" != "done" ]; then
            mark_phase_done "welcome-completed"
            ok "Migrado v0.5→v0.6: welcome-completed marcado como done (deliverable pré-existente)"
        fi
    fi
}

# ── Main flow ──
main() {
    if ! detect_json_runtime; then
        err "Preciso de node, python3 ou python (Python 3) para gerir o state machine"
        err "Instala um: https://nodejs.org ou https://python.org"
        exit 1
    fi
    info "JSON runtime: $JSON_RUNTIME"

    init_state

    phase_prereqs
    phase_sinapsis_engine
    setup_os_layer

    # Migração automática para utilizadores v0.5.x com instalação prévia
    migrate_v05_existing

    # As fases 3-5 (context-files, operator-state, welcome-completed) são feitas
    # pelo wizard DENTRO do Claude Code, não por este script. O gate verifica-as.

    echo ""
    echo "============================================================"
    echo "  ✓ Fases técnicas completadas (prereqs + sinapsis-engine + camada OS)"
    echo "============================================================"
    echo ""
    echo "  Estado atual:"
    case "$JSON_RUNTIME" in
        node)
            node -e "
const s = JSON.parse(require('fs').readFileSync('$STATE_FILE','utf8'));
for (const [k, v] of Object.entries(s.phases)) {
  const icon = v.status === 'done' ? '✅' : v.status === 'failed' ? '❌' : v.status === 'in-progress' ? '🟡' : '⏳';
  console.log('   ' + icon + ' ' + k + ' · ' + v.status);
}
" 2>/dev/null || true
            ;;
        python3|python)
            "$JSON_RUNTIME" -c "
import json
s = json.load(open('$STATE_FILE'))
icons = {'done':'OK','failed':'ERR','in-progress':'WIP','pending':'...','skipped':'SKIP'}
for k, v in s['phases'].items():
    print('   [' + icons.get(v.get('status','pending'),'?') + '] ' + k + ' . ' + v.get('status','pending'))
" 2>/dev/null || true
            ;;
    esac
    echo ""
    echo "  Próximo passo:"
    echo "    1. Abre o Claude Code neste repo: $REPO_ROOT"
    echo "    2. O hook SessionStart vai detetar que faltam fases 3-5 (onboarding)"
    echo "    3. Segue as instruções do agente — executa /install se ele pedir"
    echo ""
    echo "  Se algo falhar, executa:    bash scripts/install.sh --resume"
    echo "  Para reinstalar de zero:    bash scripts/install.sh --force-reinstall"
    echo ""
    echo "  State machine em:    $STATE_FILE"
    echo "  Inspeciona-o com:    cat $STATE_FILE"
    echo ""
    exit 0
}

main "$@"
