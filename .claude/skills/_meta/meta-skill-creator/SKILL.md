---
name: meta-skill-creator
description: Cria skills novas para o iAmasters OS seguindo o padrão canónico. Usa-o quando o utilizador pedir "cria uma skill que...", "preciso de uma skill para...", ou quando detetares no wrap-up que um padrão repetido deve passar a skill. Gera SKILL.md com YAML frontmatter, references/ com knowledge separado, scripts/ se exigir execução, e regista a skill no catálogo. Inspirado em anthropic-skills:skill-creator mas adaptado ao padrão iAmasters OS.
---

# meta-skill-creator

## Quando é invocada

- Utilizador diz: "cria uma skill", "preciso de uma skill para X", "faz uma skill que..."
- Wrap-up deteta um padrão que se repetiu em 3+ sessões e propõe graduar a skill
- Outra skill deteta um sub-processo reutilizável e sugere extraí-lo

## Contrato de qualidade

Uma skill iAmasters OS BEM feita cumpre SEMPRE:

1. **YAML frontmatter completo e específico** — `name` (kebab-case com prefixo de categoria), `description` que contém quando se invoca e o que faz numa frase ≥50 caracteres
2. **Progressive disclosure** — o SKILL.md NÃO contém todo o conhecimento; references/ guarda o que é extenso
3. **Passos numerados e testáveis** — cada passo deve ser verificável
4. **Skill collaboration explícita** — se invoca outras skills, nomeia-as e explica quando
5. **Output verifier gate** se gera conteúdo entregável ao utilizador/cliente
6. **Learnings hook** — no fim do processo, regista o aprendido em `context/learnings.md`
7. **Idioma**: SKILL.md em português, code/JSON em inglês

## Process — passos para criar uma skill

### Passo 1 · Recolher requisitos

Pergunta ao utilizador (usa AskUserQuestion se Claude Code estiver disponível):

1. **Nome e categoria**: em que categoria entra? (`marketing`, `operations`, `strategy`, `tools`, `visualization`, `_meta`). Gera nome kebab-case com prefixo: `marketing-blog-writer`, `tool-pdf-extractor`, `_meta/meta-X`.
2. **Quando é invocada**: 1-2 frases. O que dirá o utilizador para a ativar? Há outra skill que a chama?
3. **O que faz exatamente**: 3-5 pontos do processo passo a passo.
4. **Inputs**: do que precisa? Argumentos, ficheiros, MCPs, brand-context, outras skills.
5. **Outputs**: o que produz? Ficheiro em `projects/<skill>/<data>-<titulo>/`, edit em ficheiros existentes, mensagem ao utilizador.
6. **Skills que chama**: apoia-se noutras? (`tool-humanizer`, `tool-output-verifier`, etc.)
7. **Precisa de scripts?**: Python ou bash para tarefas pesadas? Se sim, o que faz cada script?

### Passo 2 · Validar o nome e descrição

A descrição deve passar 3 testes:

- **Teste de ativação**: um Claude Code que só lê a descrição saberia quando a usar? Deve conter verbos de intenção do utilizador ("cria", "analisa", "extrai", "gera").
- **Teste de comprimento**: 50–500 chars. Se menos, é ambígua. Se mais, está inflada.
- **Teste de unicidade**: lê `synapsis/skills-catalog.json`. Se houver outra skill com descrição parecida, há risco de canibalização (Claude não saberá qual escolher). Diferencia-as ou funde-as.

Se algum teste falhar, refina com o utilizador antes de continuar.

### Passo 3 · Gerar a estrutura de pastas

```
.claude/skills/<categoria>/<nome>/
├── SKILL.md                    # Processo principal (este padrão)
├── references/                 # Knowledge separado
│   ├── examples.md             # 2-3 exemplos de uso real
│   ├── checklist.md            # (opcional) Validações
│   └── (outros docs conforme skill)
└── scripts/                    # (opcional) Se requer executáveis
    └── <nome>.py               # ou .sh
```

NÃO cries `references/` nem `scripts/` se a skill não precisar deles. Mantém o mínimo.

### Passo 4 · Escrever o SKILL.md seguindo o template

Lê `references/skill-template.md` (incluído nesta skill) e usa-o de base. Estrutura obrigatória:

```markdown
---
name: <prefixo-categoria>-<nome>
description: <quando se invoca + o que faz, 50-500 chars>
---

# <nome humano da skill>

## Quando é invocada
- (3-5 bullets de padrões de invocação do utilizador ou de outras skills)

## Process
### Passo 1 · <verbo>
(o que fazer, ferramentas a usar, ficheiros a tocar)

### Passo 2 · <verbo>
...

### Passo N · Fecho e aprendizagem
- Se geraste output: invoca `tool-output-verifier` antes de entregar
- Append em `context/learnings.md` sob `## <skill-name>` com a lição se a sessão ensinou algo
- Se a skill modifica algum ficheiro do repo, propõe commit no wrap-up

## Outputs
- Ficheiros gerados em `projects/<skill>/<YYYY-MM-DD>-<titulo>/`
- Lista exacta do que gera (file_a.md, file_b.json, etc)

## Skills que chama
- (lista de skills invocadas com quando e porquê)

## Edge cases
- O que fazer se X falhar
- O que fazer se o utilizador não der Y

## Examples
Ver `references/examples.md` para 2-3 exemplos completos.
```

### Passo 5 · Gerar references/

**`references/examples.md`** (sempre): 2-3 exemplos completos de invocação + output esperado. Sem estes exemplos a skill não consegue distinguir bem os casos.

**`references/checklist.md`** (se houver validação QA): passos de checklist para validar o output antes de fechar.

**`references/<outros>.md`** (se houver knowledge extenso): templates, frameworks, listas. Só são carregados quando o SKILL.md os referencia a partir de um passo concreto.

### Passo 6 · Gerar scripts/ se aplicável

Só se a skill tiver tarefas que NÃO deveria resolver Claude (web scraping pesado, OCR, transcrição, formato batch, etc.).

Cada script:
- Documentação no cabeçalho (o que faz, args, exemplo de uso)
- `set -e` para bash, `try/except` para python
- Outputs previsíveis (stdout JSON ou ficheiro em path conhecido)
- Sem secrets hardcoded (lê de `.env`)

### Passo 7 · Registar a skill

1. Adiciona entrada em `synapsis/skills-catalog.json` (estrutura: `{id, name, category, description, status:"active", tokens_estimate, created}`).
2. Mede `tokens_estimate` aproximadamente: `chars(SKILL.md) / 4`.
3. Se a skill colabora com outras, adiciona em `references` das outras a menção cruzada.
4. Append em `CLAUDE.md` raiz, secção "Skills registry", entrada nova.

### Passo 8 · Teste mínimo

Antes de declarar a skill terminada:

1. Fecha Claude Code (Ctrl+C × 2) e volta a abrir.
2. Pergunta algo que devia ativar a skill ("cria X" segundo invocation patterns).
3. Verifica que Claude a escolhe e segue passo a passo sem saltar fases.
4. Se não se ativar: refina a descrição (Passo 2).
5. Se ativar mas fizer coisas mal: refina os passos do processo.

### Passo 9 · Fecho e aprendizagem

- Append em `context/learnings.md` em `## meta-skill-creator`:
  - Data + resumo 1-line: "criada skill X — próxima vez recordar que Y"
- Se esta é a 3ª+ vez que crias uma skill semelhante, propõe ao utilizador criar uma **meta-skill** ou **template** para acelerar (graduar o padrão).

## Outputs

- Pasta `.claude/skills/<categoria>/<nome>/` com SKILL.md + references/ (+ scripts/ opcional)
- Entrada em `synapsis/skills-catalog.json`
- Entrada em `CLAUDE.md` raiz (skills registry)
- Append em `context/learnings.md`

## Skills que chama

- **`tool-output-verifier`** — ao validar o SKILL.md gerado antes de declará-lo final (verifica formato YAML, comprimento da descrição, presença de Process, etc.)

## Edge cases

- **Se o utilizador descrever uma skill demasiado genérica** ("uma skill que escreva bem"): pede concretude. Para que plataforma? Que tom? Output onde?
- **Se já existir uma skill parecida**: mostra ambas as descrições, oferece (a) ampliar a existente, (b) diferenciar a nova, (c) cancelar.
- **Se a skill proposta for demasiado pequena** (1 passo): pode ser melhor um slash command. Sugere comando em `.claude/commands/<nome>.md`.
- **Se não houver categoria óbvia**: propõe criar nova categoria só se for ter 3+ skills. Se for só 1, encaixa-a onde melhor encaixar.

## Examples

Ver `references/examples.md` para 3 exemplos:
1. Criar `marketing-blog-writer` (skill complexa com references)
2. Criar `tool-pdf-summarizer` (skill que usa script Python)
3. Criar `_meta/meta-changelog-bumper` (skill simples sem references)

## Template canónico

Ver `references/skill-template.md` para copiar-colar o esqueleto base.
