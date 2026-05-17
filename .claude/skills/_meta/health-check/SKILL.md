---
name: health-check
description: Diagnóstico do iAmasters OS com VALIDAÇÃO PROFUNDA. v0.6 - não só verifica que existam ficheiros, mas que sejam válidos e funcionais (JSON parseável, hooks executáveis, conteúdo real >100 chars, etc.). Cruza com ~/.claude/skills/_install-state.json para detetar drift (state diz `done` mas ficheiros faltam, ou ao contrário). Devolve relatório 🟢🟡🔴 com ações concretas. Suporta auto-fix limitado. Invoca-se via /doctor ou quando outra skill deteta inconsistência.
---

# health-check

> **Mudança crítica v0.6**: já não validas "o ficheiro existe". Validas que o ficheiro seja **funcionalmente correto**: JSON parseável, conteúdo real, hooks executáveis, contadores razoáveis.
>
> A fonte de verdade sobre o que deveria estar instalado é `~/.claude/skills/_install-state.json`. Se diz que `sinapsis-engine` está `done` mas a validação profunda falha, isso é **drift** e há que reportar (e opcionalmente arranjar).

## Quando é invocada

- Utilizador executa `/doctor`
- `meta-start-here` deteta inconsistência ao arrancar sessão
- Após `update.sh` para verificar a atualização
- Utilizador reporta "algo não funciona" sem saber o quê
- (NOVA) `/install` pós-fase invoca para validar antes de marcar `done`

## Process

### Passo 0 · Ler fonte de verdade

Lê `~/.claude/skills/_install-state.json` com a tool `Read`. Se NÃO existir:
- Reporta 🔴 instalação não iniciada
- Indica ao utilizador para executar `bash scripts/install.sh`
- Para.

Guarda em memória mental:
- Que fases o state diz que estão `done`
- Lista de `completedPhases`
- Erros recentes em `errors[]`

### Passo 1 · Verificação ambiente (validação profunda)

| Check | Validação REAL | Severidade se falha |
|---|---|---|
| Claude Code CLI / app | `which claude` ou env var `CLAUDECODE` / `CLAUDE_DESKTOP` ou `~/Applications/Claude.app` | 🔴 se nada detetado |
| Repo raiz correto | `CLAUDE.md` + `.claude/` + `vendor/sinapsis/` em `pwd` | 🔴 se faltar algum |
| Git inicializado | `.git/` existe | 🟡 |
| `.env` válido | Existe E não tem linhas obviamente partidas (sem sintaxe tipo `KEY:value`) | 🟡 |
| Node.js ≥18 | `node --version` parseável, major ≥18 | 🔴 (Sinapsis hooks requerem-no) |
| Python 3 disponível | `python3 --version` ou `py -3 --version` ou `python --version` com Python 3 | 🟡 |

Usa a tool `Bash` para os `which`/`--version`.

### Passo 2 · Verificação Sinapsis (validação PROFUNDA)

Esta secção é a que evita "instalações fantasma". Não te fies que o ficheiro existe — valida-o:

| Check | Validação real | Severidade |
|---|---|---|
| `_operator-state.json` parseável | `node -e "JSON.parse(require('fs').readFileSync('~/.claude/skills/_operator-state.json'))"` não falha | 🔴 |
| `_operator-state.json` tem campos mínimos | `.operator.name` e `.operator.language` não são null/empty | 🟡 (sem isto o wizard não terminou) |
| `_catalog.json` parseável | mesmo | 🟡 |
| Hooks executáveis (5 hooks) | `_passive-activator.sh`, `_instinct-activator.sh`, `_session-learner.sh`, `_project-context.sh`, `_eod-gather.sh` existem E têm permissão `+x` | 🔴 se falhar ≥2, 🟡 se falhar 1 |
| ≥1 SKILL.md instalado | `find ~/.claude/skills -maxdepth 3 -name SKILL.md` devolve ≥1 resultado | 🔴 |
| Hooks registados em settings.json | `~/.claude/settings.json` parseável E contém a secção `hooks.PreToolUse` com referências a `_passive-activator.sh` | 🟡 |
| Install-gate registado | `~/.claude/settings.json` contém `hooks.SessionStart` com referência a `_install-gate.sh` | 🟡 |
| **DRIFT check** | Se `_install-state.json.phases.sinapsis-engine.status == "done"` E algum dos anteriores falha → **DRIFT** | 🔴 com flag "STATE DRIFT" |

Para os checks de hooks executáveis, usa Bash:
```bash
for h in _passive-activator.sh _instinct-activator.sh _session-learner.sh _project-context.sh _eod-gather.sh; do
  [ -x "$HOME/.claude/skills/$h" ] && echo "OK $h" || echo "FAIL $h"
done
```

### Passo 3 · Verificação camada OS — brand-context

| Check | Validação | Severidade |
|---|---|---|
| `brand-context/` existe | sim | 🔴 |
| `voice/voice-profile.md` | Existe + >100 chars | 🟡 (skill: `marketing-brand-voice`) |
| `voice/samples.md` | Existe + >100 chars | 🟡 |
| Registos A/B/C | Os 3 ficheiros existem | 🟡 |
| `positioning/positioning.md` | Existe + >100 chars | 🟡 |
| `icp/icp.md` | Existe + >100 chars | 🟡 |

### Passo 4 · Verificação camada OS — context sectorizado (com drift check)

Para CADA um dos 4 ficheiros críticos:

| Check | Validação | Severidade |
|---|---|---|
| `context/me.md` | Existe + >100 chars + contém `## Nombre` com valor real | 🟡 se vazio (skill: `meta-onboarding-wizard`) |
| `context/work.md` | Existe + >100 chars + contém `## Qué hago` | 🟡 |
| `context/current-priorities.md` | Existe + >100 chars + tem pelo menos uma prioridade listada | 🟡 |
| `context/goals.md` | Existe + >100 chars | 🟡 |
| `context/team.md` | Existe (pode estar vazio se trabalha sozinho) | 🟢 |
| `context/decisions-log.md` | Existe com header canónico | 🟡 auto-fix |
| `context/learnings.md` | Existe | 🟢 auto-fix |
| `context/soul.md` | Existe + >100 chars | 🟡 |

**DRIFT check para context-files**:
- Se `state.phases.context-files.status == "done"` MAS algum dos 4 ficheiros críticos não existir ou tiver <100 chars → reporta 🔴 **STATE DRIFT** + propõe fix:
  > "O state diz que `context-files` está `done` mas `<ficheiro>` está vazio/inexistente. Isto indica uma marca falsa. Vou reverter o state para `in-progress` e reativar o wizard. Continuo?"

### Passo 5 · Verificação skills curadas

Lista skills mínimas (v0.6 Camada 1):

```
.claude/skills/_meta/meta-skill-creator/SKILL.md
.claude/skills/_meta/meta-onboarding-wizard/SKILL.md
.claude/skills/_meta/meta-deep-dive/SKILL.md
.claude/skills/_meta/meta-start-here/SKILL.md
.claude/skills/_meta/meta-wrap-up/SKILL.md
.claude/skills/_meta/welcome-quick-win/SKILL.md
.claude/skills/_meta/six-hats/SKILL.md
.claude/skills/_meta/decisions-log/SKILL.md
.claude/skills/_meta/health-check/SKILL.md
.claude/skills/_meta/find-skills/SKILL.md
.claude/skills/marketing/marketing-brand-voice/SKILL.md
.claude/skills/marketing/marketing-positioning/SKILL.md
.claude/skills/marketing/marketing-icp/SKILL.md
.claude/skills/marketing/marketing-copywriting/SKILL.md
.claude/skills/marketing/marketing-content-repurposing/SKILL.md
.claude/skills/marketing/marketing-email-sequence/SKILL.md
.claude/skills/automation/automation-n8n-to-claude/SKILL.md
.claude/skills/automation/automation-n8n-builder/SKILL.md
.claude/skills/strategy/strategy-web-research/SKILL.md
.claude/skills/tools/tool-firecrawl-scraper/SKILL.md
.claude/skills/tools/tool-humanizer/SKILL.md
.claude/skills/tools/tool-output-verifier/SKILL.md
.claude/skills/visualization/tool-visual-explainer/SKILL.md
```

Por cada faltante: 🟡 com sugestão "executa `bash scripts/update.sh` para sincronizar".

### Passo 6 · Verificação settings

| Check | Validação | Severidade |
|---|---|---|
| `.claude/settings.json` do repo parseável | JSON válido | 🔴 |
| `~/.claude/settings.json` global parseável | JSON válido | 🔴 |
| Permissions seguras (repo) | Sem `Bash(*)` nem similares perigosos em `permissions.allow` | 🟡 |
| Sem secrets em settings | Não há strings que pareçam API keys (procura `sk-`, `fc-`, `pk_`) | 🔴 |

### Passo 7 · Verificação API keys (opcionais, em `.env`)

| Check | Validação | Severidade |
|---|---|---|
| `FIRECRAWL_API_KEY` | Set + começa por `fc-` + ≥20 chars | 🟡 (sem isto, scraping manual) |
| Outras keys mencionadas em `.env.example` | Set se estão documentadas | 🟢 (informativo) |

### Passo 8 · Compilar relatório

Gera relatório estruturado:

```
# 🩺 iAmasters OS · Health Check v0.6

📅 <fecha y hora>
📂 Repo: <ruta absoluta>
👤 Operador: <nombre desde operator-state o "(sin nombre)">
🎯 Versión OS: <leer de CHANGELOG.md primera línea>

## Resumen

🟢 OK: <N> componentes
🟡 AVISO: <N> componentes
🔴 ERROR: <N> componentes

State machine: <X>/5 required phases done · <currentPhase>

## State Drift detectado
<si hay drift, listarlo aquí. Si no, omitir esta sección>

## Detalle

### Entorno
🟢 Claude Code detectado
🟢 Node v20.10.0
🟡 Python no detectado

### Sinapsis (validación profunda)
🟢 _operator-state.json parseable + campos mínimos
🟢 _catalog.json parseable
🟢 5/5 hooks ejecutables
🟢 23 SKILL.md instaladas
🟢 Hooks Sinapsis registrados en settings.json
🟢 Install-gate registrado en settings.json
🟢 No hay drift

### Capa OS — Brand Context
🟡 voice-profile.md vacío
   → Acción: ejecuta `marketing-brand-voice` (10 min)

### Capa OS — Context sectorizado
🟢 me.md (456 chars · nombre: Angel)
🟢 work.md (812 chars)
🟢 current-priorities.md (234 chars · 3 prioridades)
🟢 goals.md (180 chars)

### Skills curadas
🟢 23/23 skills core presentes

### Settings
🟢 Repo settings.json válido
🟢 Global settings.json válido
🟢 Sin secretos hardcoded

### API keys
🟡 FIRECRAWL_API_KEY no encontrada

## Próximas acciones (orden por impacto)

1. <acción 1>
2. <acción 2>
3. <acción 3>
```

### Passo 9 · Auto-fix limitado

Só oferece auto-fix para problemas reversíveis e seguros:

```
Detecté <N> problemas con fix automático:
  • Crear context/decisions-log.md con header (si falta)
  • Crear context/learnings.md con header (si falta)
  • Re-aplicar chmod +x a hooks Sinapsis (si no son ejecutables)
  • Re-registrar _install-gate.sh en ~/.claude/settings.json (si fue removido)

¿Aplico los fixes? (s/n)
```

Se disser "s", aplica-os um a um mostrando o que faz cada um.

**Fix de DRIFT** é ESPECIAL — requer confirmação explícita extra:
```
🚨 STATE DRIFT detectado en fase "<X>".
El state dice "done" pero la validación profunda falla.

Quiero revertir el state a "in-progress" para que el sistema fuerce
re-ejecutar la fase. Esto NO borra archivos — solo cambia el flag.

¿Confirmas? (escribe "sí, revertir")
```

Se responder literal "sí, revertir": reverte o state. Se disser qualquer outra coisa: NÃO toques em nada.

### Passo 10 · Fecho

- Se tudo 🟢: mostra projetos abertos (`projects/briefs/*/brief.md` com `status: active`) e propõe continuar
- Se houver 🟡: plano de ação priorizado
- Se houver 🔴 ou DRIFT: bloqueante, sugere fix antes de continuar
- Append a `context/learnings.md` SÓ se descobriste algo recorrente (não por cada execução)

## Outputs

- Relatório no chat (Passo 8)
- Opcional: HTML partilhável via `tool-visual-explainer` se >5 🟡
- (Se auto-fix aplicado) ficheiros criados/permissões modificadas

## Edge cases

- **Repo aberto mas não é iamasters-os**: deteta ausência de `vendor/sinapsis/` → "não estás num repo iamasters-os, este check não aplica"
- **State file não existe**: reporta como 🔴 fundamental, sugere `bash scripts/install.sh`
- **State file corrompido** (JSON inválido): reporta 🔴, sugere `bash scripts/install.sh --force-reinstall`
- **Drift em múltiplas fases simultaneamente**: lista cada uma com o seu detalhe, oferece reverter todas com UM só confirmador
- **Cliente ativo em `clients/<X>/`**: validar também o seu sub-context

## Auto-fixes disponíveis (resumo)

| Fix | Sem perguntar | Requer "sí" | Requer "sí, revertir" |
|---|---|---|---|
| Criar decisions-log.md / learnings.md vazio | — | ✓ | — |
| chmod +x a hooks | — | ✓ | — |
| Re-registar install-gate hook | — | ✓ | — |
| Reverter state drift | — | — | ✓ |
| Criar `.env` a partir de `.env.example` | — | ✓ | — |
| Qualquer fix de instalação Sinapsis | (delegar a `bash scripts/install.sh --resume`) | | |

## Notas operativas

- NÃO recolhes dados pessoais nem mudas configuração de comportamento
- Output **rápido de ler** — utilizador deve perceber em 30s o estado geral
- 🟡 NÃO bloqueia uso, 🔴 SIM bloqueia uso, **DRIFT** é 🔴 com tratamento especial
- Se reportar >8 🟡 considera gerar HTML partilhável
