# Template canónico para SKILL.md

> Copia este ficheiro como ponto de partida quando criares uma skill nova.
> Substitui os `{{placeholders}}` e apaga as secções que não se apliquem.

```markdown
---
name: {{prefixo-categoria}}-{{nome-kebab}}
description: {{Quando se invoca, o que faz. 50-500 chars. Verbos de intenção: cria, gera, analisa, extrai, audita...}}
---

# {{Nome humano da skill}}

## Quando é invocada
- {{Padrão 1: o que diz o utilizador}}
- {{Padrão 2: skill X chama-a depois de fazer Y}}
- {{Padrão 3: hook deteta Z e propõe esta skill}}

## Process

### Passo 1 · {{Verbo}}
{{O que fazer, que tools/ficheiros tocar, o que validar}}

- **Tool**: Read / Edit / Write / Bash / Skill (se invoca outra)
- **Inputs esperados**: {{o que precisa}}
- **Validação**: {{como saber que o passo correu bem}}

### Passo 2 · {{Verbo}}
{{...}}

### Passo N · Fecho

- Se geraste output entregável → invoca `tool-output-verifier` com `score-only: true`
- Se a sessão ensinou algo novo → append em `context/learnings.md`:
  ```
  ## {{nome-skill}}
  - YYYY-MM-DD: {{lição 1-line}}
  ```
- Se modificaste skills/ do repo → propõe commit no próximo `/wrap-up`

## Outputs

- {{Ficheiro 1 em projects/.../...}}
- {{Edit em ficheiro existente}}
- {{Mensagem ao utilizador com resumo}}

## Skills que chama (se aplicável)

- **`{{outra-skill}}`** — para {{quê}}, no passo {{N}}

## Edge cases

- {{Se X faltar → o quê}}
- {{Se Y falhar → fallback para Z}}

## Examples

Ver `references/examples.md` para casos completos.
```

## Regras não-negociáveis

1. **YAML frontmatter no início**, sem linha em branco antes de `---`.
2. **Description numa única linha** dentro do YAML (não multi-linha com `>`).
3. **Steps numerados e verbos no imperativo** ("Criar...", "Validar...", não "Criarás...").
4. **Sem código pesado no SKILL.md** — os snippets longos vão para `references/` ou `scripts/`.
5. **Idioma português** no SKILL.md, **inglês em code/JSON/commits**.
6. **Sem informação privada** do operador — os exemplos usam placeholders genéricos ("Empresa Demo SL", "cliente@ejemplo.com").

## Antipadrões que NÃO deves repetir

| Antipadrão | Porque é mau | Como corrigir |
|---|---|---|
| Description vaga ("Cria conteúdo") | Não ativa corretamente, canibalismo entre skills | Verbo + o quê + quando: "Cria posts de LinkedIn de 200 chars com hook + CTA usando brand voice" |
| Todo o conhecimento no SKILL.md | Bloat de contexto quando se carrega | Mover knowledge para `references/<topic>.md` e referenciá-los nos steps |
| Sem examples | O Claude alucina casos | Mínimo 2 exemplos completos em `references/examples.md` |
| Passos sem verificação | Quebra em silêncio | Cada passo com critério "como sei que correu bem" |
| Skill que faz 5 coisas distintas | Ambígua, difícil de manter | Dividir em 5 skills + 1 orquestradora se necessário |
| Sem hook de learnings | As skills não aprendem | Append em `context/learnings.md` no fecho |

## Token budget recomendado

- SKILL.md: 800-2500 tokens (~3000-10000 chars)
- references/ por ficheiro: 300-1500 tokens
- Se passares dos 2500 tokens no SKILL.md, move secções para references/.
