# Translation style — PT-PT

Guia de estilo para tradução e contribuições ao iAmasters OS em português europeu.

> Vive este guia, não as regras. Quando em dúvida: lê o vocabulário canónico abaixo, depois `bash scripts/check-translation.sh` para validar.

---

## Vocabulário canónico (PT-PT, não BR)

| Usa | NÃO uses (BR/ES) |
|---|---|
| ficheiro | arquivo, archivo |
| pasta | carpeta, diretório (exceto contexto técnico) |
| ecrã | tela, pantalla |
| à mão | manualmente (quando aplica), a mano |
| telemóvel | celular, móvil |
| utilizador | usuário, usuario |
| deteta, deteção | detecta, detección |
| **tu** (informal) | você, vos |
| PME | PYME, pyme |
| encomenda | pedido (quando se refere a order/purchase) |
| guia de transporte | albarán |
| contabilista | contador, gestoría |
| receita | ingresos, ingreso (revenue) |
| equipa | equipo |
| projeto, ativo, exato | projecto, activo, exacto (antes do AO90) |

## Verbos comuns

- "Faz / Executa / Verifica / Corrige" (imperativo informal, 2ª pessoa singular)
- "Quando o utilizador disser" / "Se o ficheiro existir" — futuro do conjuntivo

## Idioma de operação

- **Operativa com o utilizador**: português sempre
- **Comentários técnicos em código**: inglês (convenção dev)
- **Commits**: conventional commits em inglês
- **Outputs entregues a clientes**: idioma do cliente (deteta em `brand-context/`)

---

## NUNCA traduzir

São strings load-bearing: traduzi-las parte o sistema.

### YAML frontmatter
- `name:` em `SKILL.md` — kebab-case, identificador usado por código.
- `description:` — **traduz sim** (é texto livre que o agente lê).

### JSON keys e enums
- Chaves: `status`, `phases`, `pausedBy`, `needsOnboarding`, `filesCreated`, `pausedAtPhase`, `validatedAt`, `checksum`, `errors`, `completedPhases`, `currentPhase`, `repoPath`, `schemaVersion`.
- Valores enum: `"done"`, `"failed"`, `"in-progress"`, `"pending"`, `"skipped"`, `"user"` (em `pausedBy: "user"`).

### Slugs e paths
- Nomes de pastas: `_meta`, `marketing`, `automation`, `strategy`, `tools`, `visualization`, `_optional`, `brand-context`, `clients`, `vendor`.
- Nomes de skills: `meta-onboarding-wizard`, `health-check`, `marketing-brand-voice`, etc.
- Slash commands: `/install`, `/doctor`, `/start-here`, `/wrap-up`, `/aprende`, etc.
- Paths: `~/.claude/skills/`, `vendor/sinapsis/`, `scripts/install.sh`.

### String literal `iAmasters OS`
- `_install-gate.sh:30` faz `grep -q "iAmasters OS" CLAUDE.md` para detetar o repo. Alterar = parte o gate.

### Placeholders `{{...}}` e `<...>`
- Qualquer texto entre chaves duplas ou angle brackets. São substituídos por código (sed, wizard).
- Exemplos: `{{CLIENT_NAME}}`, `{{NOMBRE_FORMADOR}}`, `<data>`, `<nome do utilizador>`.

### Padrões de detecção do humanizer
- `.claude/skills/tools/tool-humanizer/references/ai-tells.md` — lista de padrões ES/EN que o detector procura.
- `.claude/skills/tools/tool-humanizer/references/examples.md` — amostras de copy ES que o humanizer recebe e reescreve.
- Traduzi-los muda a função da skill.

### Labels estruturados de output
- `[OK]`, `[SKIP]`, `[WARN]`, `[ERROR]`, `[INSTALL GATE]` em scripts.

---

## Termos técnicos mantidos em inglês

A convenção do projeto é manter o jargão dev/agêntico em inglês:

```
skill, hook, frontmatter, gate, state machine, wizard, brand voice,
copy, copywriting, drip, nurture, lifecycle, launch, win-back,
fallback, scraper, humanizer, verifier, repurposing, explainer,
output, input, prompt, register, spectrum, workflow, pipeline,
LinkedIn, WhatsApp, MCP, ICP, CTA, MRR, ROAS, CAC, NRR, LTV
```

Termos OS/marca:
```
iAmasters OS, Sinapsis, Claude Code, Anthropic, Firecrawl, n8n
```

---

## Quando uma frase mistura ES e PT (no input)

A maioria das skills foi traduzida ao mesmo tempo que ficavam compatíveis com clientes PT. Se encontras uma frase híbrida ES/PT (ex: "el utilizador") foi um descuido — traduz tudo para PT.

## Quando o ficheiro inteiro era inglês

Alguns ficheiros (`marketing-email-sequence` references, `find-skills`) eram originalmente em inglês. Decisão: **traduzir para PT** por coerência com o resto. Se vais adicionar uma skill de terceiros nova:
- Se a skill é genérica (`docx`, `pdf`): mantém EN (é universal).
- Se a skill vai ser usada por operadores PT: traduz para PT.

---

## Workflow de tradução para skills/contribuições novas

1. **Escreve direto em PT** se possível.
2. Se vendoreas skill externa em ES/EN:
   - Cria `ORIGIN.md` na pasta da skill com versão original + licença.
   - Traduz `SKILL.md` e `references/*.md` seguindo este guia.
   - Não toques o `name:` do frontmatter — usa-o no rename à convenção iAmasters (`<categoria>-<nome>`).
3. **Corre `bash scripts/check-translation.sh`** antes de commit.
4. Se o check falhar: fixa, corre outra vez.

## Pre-commit hook (opcional)

Para bloquear commits com regressão de tradução:

```bash
ln -s ../../scripts/check-translation.sh .git/hooks/pre-commit
chmod +x scripts/check-translation.sh
```

---

## Exceções documentadas (não tocar)

Estas são as exceções que o `check-translation.sh` já ignora — não as "corrijas":

1. `tool-humanizer/references/examples.md` — samples de copy ES para humanizar.
2. `tool-humanizer/references/ai-tells.md` — padrões ES/EN que o detetor procura.
3. `vendor/` — código upstream (Sinapsis, cognito), não tocar.
4. `projects/` — outputs do utilizador, privados.
5. `clients/<nome>/` (exceto `_templates/`) — dados do cliente, podem ter qualquer idioma.

## Em caso de dúvida

- Lê o ficheiro `CLAUDE.md` raiz (também serve como exemplo canónico de PT-PT do projeto).
- Pergunta na comunidade (issues no GitHub).
