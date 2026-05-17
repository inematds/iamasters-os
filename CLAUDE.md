# iAmasters OS — CLAUDE.md (project root)

> Sistema operativo agéntico para operadores de IA.
> Sinapsis v4.5 (engine) + capa OS (brand context, agent context, skills curadas, multi-cliente).

---

## ⛔ INSTALLATION GATE — LER ANTES DE TUDO

Antes de responderes à primeira mensagem do utilizador neste repo, **tens** de verificar se a instalação está completa.

**Fonte de verdade**: `~/.claude/skills/_install-state.json` (state machine persistente, v0.6+).

**Verificação obrigatória** (por esta ordem):

1. **O state file existe?**
   - Se NÃO existir → a instalação técnica nunca correu. Indica ao utilizador:
     > "iAmasters OS não está instalado. Preciso que executes a partir do terminal: `bash scripts/install.sh`. Quando terminar, volta aqui."
   - NÃO cries ficheiros à mão para simular instalação. NÃO marques nada como instalado.

2. **Se existir, todas as fases `required: true` estão em `status: "done"`?**
   - Se NÃO → a instalação está incompleta. Invoca o comando `/install` (ou o wizard diretamente, conforme a fase pendente).
   - **NÃO respondas a outros pedidos do utilizador até fechar a instalação.**

3. **O hook SessionStart (`_install-gate.sh`) já injeta este aviso automaticamente quando aplica.** Esta secção é o teu *backup* caso o hook falhe, não a fonte principal.

**O que NUNCA fazes durante uma instalação incompleta**:
- ❌ Reportar "tudo instalado" quando o state diz o contrário
- ❌ Criar ficheiros `.json` ou `.md` à mão para "completar" fases
- ❌ Marcar fases como `done` sem que a validação profunda o confirme
- ❌ Avançar para tarefas do utilizador se ficarem fases `required` por completar

**Se o utilizador disser "para" / "já não quero continuar":**
- Marca `pausedBy: "user"` no state com a fase atual
- Despede-te: "Quando voltares, `/install --resume` retoma a partir daqui. O que está guardado, está guardado."
- NÃO insistas. NÃO reportes a instalação como completa.

**Se duvidares do estado**: executa `/install-status` para ver o dashboard sem tocar em nada.

---

## Session Entry — EXECUTE ON FIRST MESSAGE OF EVERY SESSION

(Uma vez que o INSTALLATION GATE acima tenha passado.)

### Paths absolutos (relativos a este repo)
- **Skills do OS**: `.claude/skills/`
- **Commands do OS**: `.claude/commands/`
- **Brand context**: `brand-context/` (voice, positioning, ICP, assets)
- **Agent context sectorizado**: `context/` (me.md, work.md, team.md, current-priorities.md, goals.md, decisions-log.md, learnings.md, soul.md)
- **Projetos**: `projects/` (`projects/briefs/<nome>/`, `projects/welcome/`, `projects/six-hats/`, `projects/visual/`)
- **Clientes**: `clients/<nome>/` (com `clients/_templates/` para novos)
- **Docs operativos**: `docs/`
- **Scripts do installer**: `scripts/install.sh`, `scripts/_install-gate.sh`, `scripts/_install-state.template.json`
- **Vendored**: `vendor/sinapsis/` (engine), `vendor/cognito/` (Sistema Operativo de Pensamento de Luis Pitik)

### Paths Sinapsis (engine global do operador)
- **Skills root global**: `~/.claude/skills/` (Sinapsis instalado por install.sh)
- **Operator state**: `~/.claude/skills/_operator-state.json`
- **Install state (v0.6+)**: `~/.claude/skills/_install-state.json` ← fonte de verdade da instalação
- **Install gate hook**: `~/.claude/skills/_install-gate.sh` (SessionStart hook)
- **Instincts**: `~/.claude/skills/_instincts-index.json`
- **Daily summaries**: `~/.claude/skills/_daily-summaries/`
- **Catalog**: `~/.claude/skills/_catalog.json`

### MANDATORY first action (post-gate)

Uma vez confirmado que a instalação está completa, antes de responder à primeira mensagem do utilizador:

1. Lê `~/.claude/skills/_operator-state.json` (Sinapsis: perfil do operador, decisões, lições).
2. Lê os 5 ficheiros sectorizados de `context/` se existirem: `me.md`, `work.md`, `team.md`, `current-priorities.md`, `goals.md`.
3. Lê `context/decisions-log.md` (últimas 5 entradas) para manter coerência.
4. Lê qualquer plano ativo em `.claude/plans/` se a pasta existir (planos em curso de sessões anteriores).
5. Lê `synapsis/daily-summaries/<TODAY>.md` ou `<YESTERDAY>.md` (continuidade diária).

### Session continuity (operativa diária)

Quando tudo está configurado e a instalação está completa:
1. Daily summary de ontem (Sinapsis)
2. `context/learnings.md` (feedback consolidado de skills)
3. Projetos abertos em `projects/briefs/*/brief.md` com `status: active`
4. Cumprimenta com: "Ontem deixaste X. Continuas com Y ou mudas?"

---

## Sobre o sistema

### Sinapsis (engine de memória)
Sinapsis é o sistema que faz com que o Claude Code aprenda contigo. Vive instalado em `~/.claude/` (não neste repo). O repo trá-lo vendored em `vendor/sinapsis/` para instalação.

Sinapsis dá-te:
- **Operator state**: a tua identidade, stack, decisões — persiste em TODOS os projetos
- **Instincts**: padrões aprendidos que se injetam automaticamente quando aplicam
- **Passive rules**: guardrails técnicos (segurança, qualidade, workflow)
- **Skills on-demand**: só carrega as relevantes (~2.800 tokens vs ~25.000)
- **Dream cycle**: limpeza periódica de memória
- **Dashboard** (`/dashboard-sinapsis`): métricas reais

Comandos Sinapsis instalados global:
- `/system-status` · `/evolve` · `/instinct-status` · `/passive-status` · `/eod` · `/dream` · `/analyze-session`

### Capa OS (este repo)
O que este repo acrescenta por cima do Sinapsis:

**Brand Context (`brand-context/`)** — estática:
- Voice profile + 3 registos (A formal / B divulgativo / C próximo)
- Positioning, ICP, brand assets

**Agent Context (`context/`)** — dinâmica:
- `soul.md` — personalidade do agente (como respondes)
- `me.md`, `work.md`, `team.md`, `current-priorities.md`, `goals.md`
- `learnings.md`, `decisions-log.md`

**Skills curadas (`.claude/skills/`)** — 23 skills core (ver registry abaixo).

**Níveis de projeto**:
1. **Single task** — pergunta direta. Output para `projects/<skill-name>/<data>-<titulo>/`.
2. **Planned project** — scoping conversation. Output para `projects/briefs/<nome>/`.
3. **GSD project** — multi-fase. `.planning/` no cliente ou na raiz.

**Multi-cliente**:
- `clients/<nome>/` com o seu próprio brand-context, context, projects
- Templates em `clients/_templates/` para 4 verticais

---

## Skills registry (v0.6.0)

Capa 1 = 23 skills core + 1 opcional.

### `_meta/` — sistema (10)

| Skill | Descrição curta |
|---|---|
| `meta-skill-creator` | Cria skills novas |
| `meta-onboarding-wizard` | Entrevista express por **4 sub-fases com commits incrementais** (v0.6) |
| `meta-deep-dive` | Entrevista profunda (22-25 dimensões) — opcional |
| `meta-start-here` | Ritual diário de início |
| `meta-wrap-up` | Ritual diário de fecho |
| `welcome-quick-win` | Primeiro entregável em 5 min |
| `six-hats` | Método 6 chapéus |
| `decisions-log` | Diário append-only de decisões |
| `health-check` | Diagnóstico do OS com **validação profunda e deteção de drift** (v0.6) |
| `find-skills` | Descobribilidade por intent |

### `_meta/_optional/` (1)

| Skill | Como ativar |
|---|---|
| `cognito` | `/install-skill cognito` |

### `marketing/` (6)

| Skill | Descrição |
|---|---|
| `marketing-brand-voice` | Voice profile + 3 registos |
| `marketing-positioning` | Posicionamento competitivo |
| `marketing-icp` | Cliente ideal |
| `marketing-copywriting` | Copy com humanizer gate |
| `marketing-content-repurposing` | Distribuição multiplataforma |
| `marketing-email-sequence` | Sequências de email |

### `automation/` (2)

| Skill | Descrição |
|---|---|
| `automation-n8n-to-claude` | Migra workflows n8n para o ecossistema Claude |
| `automation-n8n-builder` | Cria workflows n8n via MCP `n8n-mcp` |

### `strategy/` (1)

| Skill | Descrição |
|---|---|
| `strategy-web-research` | Research com subagentes |

### `tools/` (3)

| Skill | Descrição |
|---|---|
| `tool-firecrawl-scraper` | Wrapper Firecrawl |
| `tool-humanizer` | Tira padrões AI-tell |
| `tool-output-verifier` | Gate de qualidade |

### `visualization/` (1)

| Skill | Descrição |
|---|---|
| `tool-visual-explainer` | HTML autocontido partilhável |

### Plugins Anthropic (instalação via marketplace)

| Skill | Como ativar |
|---|---|
| `docx`, `xlsx`, `pdf`, `pptx` | `/plugin install anthropic-skills` |

### Slash commands

`/install` · `/install-status` · `/start-here` · `/wrap-up` · `/doctor` · `/add-client` · `/install-skill` · `/install-mcp` · `/aprende` · `/deep-dive`

Os dois primeiros (`/install`, `/install-status`) são novos em v0.6 e são a **única via oficial** para gerir a instalação a partir de dentro do Claude Code.

### Capa 2 — on-demand library

Ver [`docs/skills-recommended.md`](docs/skills-recommended.md) para skills opcionais instaláveis via `/install-skill <github-url>`.

---

## Níveis de projeto — heartbeat

Ao iniciar cada sessão (post-gate), verifica `projects/briefs/*/brief.md`:
- Se houver `status: active`, lembra-lhe o que ficou em aberto.
- Se houver um `.planning/` na raiz ou no cliente, indica que há um GSD em curso.
- Se terminou algo (`status: done`), pergunta se arquivamos.

---

## Como registar skills novas (auto)

Quando se adiciona uma skill nova em `.claude/skills/<categoria>/<nome>/`:
- `/start-here` deteta-a e regista no catalog
- `/wrap-up` atualiza o registry deste CLAUDE.md
- O comando `/install-skill <github-url>` valida-a antes de a adicionar

---

## Permissões (lembrete)

`.claude/settings.json` vem com permissões seguras por defeito:
- ✅ Read files, dev server, git operations, edit files dentro do repo
- ❌ Install packages globalmente, delete files, ler `.env`

Se precisares de mais permissões: `claude --dangerously-skip-permissions` (pontual) ou edita `settings.json`.

---

## Idioma

- **Operativa com o utilizador**: Português por defeito
- **Comentários técnicos em código**: inglês
- **Commits**: conventional commits em inglês
- **Outputs entregáveis ao cliente**: idioma do cliente (detetar em brand-context)

---

## Convenções do repo

- Pastas em kebab-case (`brand-context`, `clients`, `projects`)
- Ficheiros markdown em kebab-case
- Skills em kebab-case com prefixo de categoria: `marketing-brand-voice`, `tool-humanizer`, etc.
- Outputs por data: `YYYY-MM-DD-titulo-curto/`
- Variáveis de ambiente em `.env`

---

## Quando NÃO usar o OS

Casos em que é melhor abrir o Claude Code noutro lado:
- Editar o código da tua própria app
- Bug pontual sem necessidade de brand context
- Sessão exploratória que não queres que suje a tua memory

Para casos em que sim:
- Criar conteúdo (LinkedIn, X, blog, email, video script)
- Trabalhar com um cliente (entras em `clients/<nome>/`)
- Análise estratégica
- Gerar deliverables com voice consistente

---

## Suporte e comunidade

- Issues: https://github.com/iamasters-academy/iamasters-os/issues
- Sinapsis upstream: https://github.com/Luispitik/sinapsis
- Schema doc do install gate: [`docs/install-state-schema.md`](docs/install-state-schema.md)
