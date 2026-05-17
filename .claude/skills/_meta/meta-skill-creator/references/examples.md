# Exemplos completos de skill creation

## Exemplo 1 · Skill complexa com references — `marketing-blog-writer`

**Situação**: o utilizador quer uma skill que gere posts de blog SEO-otimizados a partir de uma ideia + o brand context.

### Conversa

**Utilizador**: "Cria uma skill que escreva blogs SEO a partir de um título"

**Claude (meta-skill-creator)**:
- Categoria sugerida: `marketing` → nome `marketing-blog-writer`
- Descrição candidata: "Gera posts de blog SEO-otimizados de 1200-1800 palavras a partir de um título ou ideia, usando brand-voice do operador, com keywords detetadas, hook narrativo, CTA no final, e meta description. Invoca tool-output-verifier antes de entregar."
- Passa os 3 testes (ativação / comprimento 240 chars / única).
- Que skills colabora com? `tool-output-verifier` (gate), opcional `tool-firecrawl-scraper` (se pedir para investigar concorrentes).
- Scripts? Não. Tudo Claude.

### Estrutura gerada

```
.claude/skills/marketing/marketing-blog-writer/
├── SKILL.md
└── references/
    ├── examples.md           (2-3 blog posts de exemplo)
    ├── seo-checklist.md      (hierarquia H1/H2, density, alt-text)
    └── hook-frameworks.md    (5 padrões de hook narrativo)
```

### SKILL.md resultante (resumo)

```markdown
---
name: marketing-blog-writer
description: Gera posts de blog SEO-otimizados de 1200-1800 palavras a partir de título ou ideia. Usa brand-voice do operador, deteta keywords, aplica hook narrativo, CTA no fim, meta description. Invoca tool-output-verifier antes de entregar.
---

# Marketing Blog Writer

## Quando é invocada
- Utilizador diz: "escreve um blog sobre X", "preciso de um post de blog SEO"
- Skill marketing-content-repurposing chama-a depois de processar transcript de YouTube

## Process
### Passo 1 · Validar inputs
- Título ou ideia: obrigatório
- Audiência: ler brand-context/icp/icp.md se não se especificar
- Tom: ler brand-context/voice/voice-profile.md

### Passo 2 · Investigar keywords
- Se firecrawl disponível → invoca tool-firecrawl-scraper em 3 concorrentes top
- Se não → keywords manuais baseadas em brand-context/positioning

### Passo 3 · Gerar outline
- Hook (ver references/hook-frameworks.md)
- 3-5 H2 com H3 aninhados segundo hierarquia SEO
- CTA contextual ao ICP

### Passo 4 · Redigir
- Aplicar voice-profile (registo B divulgativo por defeito, ajustável)
- 1200-1800 words
- Inserir keywords naturalmente

### Passo 5 · Verificar
- invoca tool-output-verifier com focus: blog-seo
- Se score < 7/10, rever e retentar passo 4

### Passo 6 · Fecho
- Output para projects/marketing-blog-writer/YYYY-MM-DD-<slug>/
- Gera: post.md + meta.md (title-tag, meta-description, OG image suggestion)
- Append learnings se houver aprendizagem

## Outputs
- projects/marketing-blog-writer/<data>-<slug>/post.md
- projects/marketing-blog-writer/<data>-<slug>/meta.md

## Skills que chama
- tool-output-verifier (gate obrigatório)
- tool-firecrawl-scraper (opcional, no passo 2)

## Edge cases
- Se não houver brand-voice → usar registo B "neutro divulgativo" + warning ao utilizador
- Se firecrawl não responder → continuar sem investigação competitiva, marcar em meta.md

## Examples
Ver references/examples.md
```

---

## Exemplo 2 · Skill com script Python — `tool-pdf-summarizer`

**Situação**: precisas de resumir PDFs longos (200+ páginas) sem gastar contexto.

**Decisão-chave**: extração do PDF com script (rápido, não consome tokens), resumo com Claude (qualidade).

### Estrutura

```
.claude/skills/tools/tool-pdf-summarizer/
├── SKILL.md
├── scripts/
│   └── extract.py            # PyPDF2: PDF → texto plano
└── references/
    └── examples.md
```

### Fluxo

1. Utilizador pede para resumir PDF
2. SKILL.md executa `bash` → `python3 scripts/extract.py <pdf-path>` → devolve texto em stdout ou ficheiro temporário
3. Claude lê o texto extraído (em blocos se for longo, usando subagent se passar dos 50K tokens)
4. Gera resumo estruturado
5. Cleanup do temporário
6. Output para `projects/tool-pdf-summarizer/YYYY-MM-DD-<nome>/resumo.md`

### Porquê script e não tudo Claude

- PDFs de 200 páginas = ~50K tokens só para ler
- Script Python com PyPDF2 faz o mesmo em <2 segundos sem tokens
- Claude só processa o texto extraído (pode usar subagent para chunks)

---

## Exemplo 3 · Skill simples sem references — `_meta/meta-changelog-bumper`

**Situação**: cada vez que fechas um release, é preciso atualizar o CHANGELOG.md com os commits desde a versão anterior. É repetitivo e mecânico.

### Decisão

- Skill ou slash command? → Slash command (`/bump-changelog`) seria mais rápido se só fizesse 1 coisa.
- Mas queremos que seja invocada a partir de outras skills (release flow), por isso **skill simples sem references**.

### Estrutura

```
.claude/skills/_meta/meta-changelog-bumper/
└── SKILL.md
```

Sem references/ porque não há knowledge a separar. SKILL.md ~600 chars no total.

### SKILL.md

```markdown
---
name: meta-changelog-bumper
description: Atualiza CHANGELOG.md com os commits desde a última tag de versão. Deteta alterações por categoria (Added/Changed/Fixed/Removed) usando keywords de conventional commits. Invocada por release skill ou manualmente.
---

# meta-changelog-bumper

## Quando é invocada
- Utilizador diz: "atualiza o changelog"
- Skill de release chama-a depois de criar nova tag

## Process
### Passo 1 · Detetar última versão
- bash: git describe --tags --abbrev=0
- Se não houver tags: começar desde primeiro commit

### Passo 2 · Listar commits desde essa tag
- bash: git log <last-tag>..HEAD --oneline

### Passo 3 · Classificar
- feat: → Added
- fix: → Fixed
- refactor:/style:/perf: → Changed
- BREAKING CHANGE: ou !: → marcar como ⚠️
- removed:/deprecated: → Removed

### Passo 4 · Gerar entrada
- Inserir no início de CHANGELOG.md depois da secção [Unreleased]
- Formato Keep a Changelog 1.1.0
- Data do dia

### Passo 5 · Fecho
- Mostrar diff ao utilizador antes de guardar
- Pedir aprovação
- Sem commit automático (fá-lo a release skill)

## Outputs
- Edit a CHANGELOG.md

## Edge cases
- Se não houver commits desde última tag: avisar e não editar
- Se houver BREAKING CHANGE: adicionar warning visível

## Examples
- Chamada: "atualiza o changelog"
- Output esperado: ## v0.2.0 - 2026-05-07 com secções Added/Changed/Fixed
```

---

## Lições destes 3 exemplos

| Aspeto | marketing-blog-writer | tool-pdf-summarizer | meta-changelog-bumper |
|---|---|---|---|
| Tamanho SKILL.md | 1500 tokens | 700 tokens | 400 tokens |
| references/ | Sim (3 ficheiros) | Sim (1 ficheiro) | Não |
| scripts/ | Não | Sim (Python) | Não |
| Chama outras skills | 2 | 0 | 0 |
| Tipo | Complexa | Híbrida (script+LLM) | Simples |
| Melhor como slash command? | Não, requer processo longo | Não | Possivelmente sim, mas queremos invocá-la a partir de outras |

**Conclusão**: a complexidade da skill ajusta-se à tarefa. Não inches nem reduzas — escala com o problema.
