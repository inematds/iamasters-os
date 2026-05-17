# AGENTS.md — Instruções para agentes IA

> Este ficheiro lês TU (um agente IA) quando alguém te passa o URL deste repo ou quando abres o repo pela primeira vez. Define o teu workflow para instalar e arrancar o iAmasters OS de forma plug-and-play.

---

## 🤖 Se és Claude Code e recebes o prompt URL canónico

**Prompt típico do utilizador:**

> "Instala o iAmasters OS desde https://github.com/iamasters-academy/iamasters-os e guia-me no setup"

Variantes que também deves reconhecer:
- "Instala o OS da iAmasters"
- "Configura o meu sistema com iAmasters OS"
- "Quero usar o iAmasters OS"
- Qualquer URL do repo `iamasters-academy/iamasters-os`

### O teu workflow exato (não improvises)

#### Passo 1 · Confirma intent e prerequisitos (30s)

Antes de tocar em nada, confirma com o utilizador em português (sempre português):

```
Vou instalar o iAmasters OS no teu sistema. O processo:

1. Clonar o repo em ~/iamasters-os/ (~5 segundos)
2. Executar o instalador (~30 segundos)
3. Lançar o onboarding wizard (~10 minutos contigo)
4. Gerar-te o teu primeiro entregável (~5 minutos)

Total: ~15-20 minutos. Começamos?

⚠️ Antes de seguir, confirma que tens:
- Anthropic Pro ou Max (Free não chega para uso real, ver docs/anthropic-plans.md)
- Git instalado (já deve estar em macOS / Windows com Desktop)
- ~50MB livres no disco
```

Espera confirmação afirmativa ("sim", "vamos", "ok", "adiante") antes de continuar.

#### Passo 2 · Clone

```bash
cd ~ && git clone https://github.com/iamasters-academy/iamasters-os.git
cd ~/iamasters-os
```

Se a pasta já existir, pergunta ao utilizador:
- "Já tens `~/iamasters-os/`. Atualizo (`git pull`), reinicio limpo (backup + clone fresh) ou uso o que está?"

#### Passo 3 · Install

```bash
bash scripts/install.sh
```

O script `install.sh` é idempotente e devolve saída estruturada. Faz parse:
- ✅ O que fez: `[OK] <componente>`
- ⚠️ Avisos: `[WARN] <componente> — <motivo>`
- ❌ Erros: `[ERROR] <componente> — <motivo>`

Se houver erros, NÃO sigas para o passo 4. Diagnostica com `/doctor` (instala-se junto com o OS) e reporta ao utilizador em português o que falha e como arranjar.

#### Passo 4 · Onboarding wizard

Uma vez `install.sh` termina com sucesso, lança o fluxo de configuração:

1. Lê `~/.claude/skills/_operator-state.json` para confirmar que o Sinapsis se instalou
2. Invoca a skill `meta-onboarding-wizard` (em `.claude/skills/_meta/meta-onboarding-wizard/SKILL.md`)
3. Segue exatamente os passos dela — entrevista o utilizador por secções (não tudo de uma vez)
4. Preenche os ficheiros `context/me.md`, `context/work.md`, `context/team.md`, `context/current-priorities.md`, `context/goals.md`

#### Passo 5 · Welcome quick-win (PRIMEIRO WOW garantido)

Após o onboarding, invoca a skill `welcome-quick-win` (em `.claude/skills/_meta/welcome-quick-win/SKILL.md`).

Esta skill:
- Pede ao utilizador o URL público dele (LinkedIn / site pessoal / site do negócio)
- Executa `marketing-positioning` com esse URL
- Gera HTML autocontido com análise de posicionamento + 3 hooks LinkedIn + plano semana
- Guarda em `projects/welcome/<data>-o-teu-primeiro-entregavel.html`
- Abre o HTML no browser (ou sugere ao utilizador que o abra)

Mensagem final ao utilizador:

```
🎉 O teu primeiro entregável está pronto.

Abre-o no browser. É totalmente partilhável — cola-o no
WhatsApp ou na comunidade iAmasters Skool se gostaste.

O que queres fazer agora?
1. Configurar o teu Brand Voice completo (10 min mais)
2. Executar outra skill (sugiro copywriting)
3. Fechar sessão por hoje
```

### Regras durante a instalação

- **Idioma**: português sempre, sem exceções
- **Tom**: direto, caloroso, sem rodeios. NÃO uses emojis em excesso (1-2 por mensagem máximo)
- **Permissões**: o utilizador provavelmente abrirá o Claude Desktop com "omitir permissões" ativado na primeira tentativa — aproveita mas NÃO executes ações destrutivas (rm -rf, git reset --hard, etc.) sem confirmar
- **Se o utilizador não for o Angel**: SEMPRE perguntar antes de tocar em ficheiros fora de `~/iamasters-os/`. O Sinapsis vive em `~/.claude/` — só o `install.sh` lhe toca
- **Se algo falhar**: para imediatamente, executa `/doctor`, reporta em português. Nunca sigas para o passo seguinte com erro em aberto

---

## 🛠️ Se és Claude Code e abres o repo desde o filesystem

(O utilizador já tem o repo, abre o Claude Code dentro da pasta.)

1. Lê o `CLAUDE.md` (entry point principal)
2. Segue as instruções de "Session Entry — EXECUTE ON FIRST MESSAGE OF EVERY SESSION"
3. Se `~/.claude/skills/_operator-state.json` não existir → onboarding wizard
4. Se existir mas `context/me.md` não existir → `meta-start-here`
5. Se tudo configurado → ritual normal `/start-here`

---

## 🔌 Se NÃO és Claude Code (Codex, Cursor, outros)

Este repo está otimizado para Claude Code, mas as skills são markdown standard e outros agentes podem usá-las.

### Limitações conhecidas

1. **Não executes os hooks do Sinapsis** — estão em `~/.claude/settings.json` e são específicos do Claude Code
2. **Podes usar as skills** que vivem em `.claude/skills/<categoria>/<nome>/SKILL.md` — são markdown standard
3. **Podes ler brand-context e context** — são markdown plain
4. **Skills format**: cada skill tem `SKILL.md` com YAML frontmatter (name, description) seguido de instruções
5. **Comandos**: vivem em `.claude/commands/<nome>.md` e são slash commands do Claude Code; outros agentes podem lê-los como referência

### Como invocar uma skill genericamente

1. Lê `.claude/skills/<categoria>/<nome>/SKILL.md`
2. Segue as instruções do bloco "Process" ou "Steps"
3. Se a skill referenciar ficheiros em `references/`, lê-os só quando os passos pedirem
4. Se a skill referenciar outra skill (skill-to-skill), invoca essa skill e depois continua

### Compatibilidade testada

- ✅ **Claude Code** (ambiente principal, todos os hooks Sinapsis ativos)
- 🟡 **Codex (OpenAI)** — skills funcionam, hooks Sinapsis não se aplicam
- 🟡 **Cursor** — skills funcionam como prompts, não há integração direta
- ❌ **Antigravity / Other** — não testado

---

## Variáveis chave (qualquer agente)

- **Idioma operativo**: português
- **Estilo de resposta**: direto, sem rodeios, 2-3 opções máx com recomendação
- **Validação humana**: sempre antes de ações destrutivas
- **Segredos**: nunca commitar `.env`, credentials, API keys

## Estrutura mínima do repo (não partir)

```
.claude/skills/<categoria>/<nome>/SKILL.md     ← skills curadas
.claude/commands/<nome>.md                      ← slash commands
brand-context/voice/voice-profile.md            ← Brand Voice do operador
brand-context/positioning/positioning.md
brand-context/icp/icp.md
context/me.md                                   ← perfil pessoal
context/work.md                                 ← negócio, serviços, receita
context/team.md                                 ← equipa e comunicação
context/current-priorities.md                   ← foco atual (muda com frequência)
context/goals.md                                ← objetivos trimestrais
context/decisions-log.md                        ← decisões append-only
context/learnings.md                            ← feedback de skills
projects/briefs/<nome>/brief.md                 ← planned projects
clients/<nome>/{brand-context,context,projects} ← multi-cliente
vendor/sinapsis/                                ← Sinapsis vendorizado, não tocar
```

## Para suporte cross-tool mais profundo

Abre uma issue em https://github.com/iamasters-academy/iamasters-os/issues
