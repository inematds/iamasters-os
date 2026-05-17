---
name: tool-humanizer
description: Deteta e elimina padrões de escrita AI em qualquer texto. Devolve score 0-10 (10 = totalmente humano) e reescrita com sugestões específicas. Usado como gate pelas skills marketing-* antes de entregar conteúdo. Invocável sozinho ou em pipeline-mode dentro de outra skill.
---

# tool-humanizer

## Quando se invoca

- Qualquer skill marketing-* a chama no fim como quality gate
- O utilizador cola um texto e diz "humaniza isto", "tira o tom AI", "soa demasiado a ChatGPT"
- `tool-output-verifier` inclui-a como um dos seus checks

## Process

### Passo 1 · Receber input

**Modo standalone**:
- Texto colado no chat ou path para ficheiro `.md` / `.txt`

**Modo pipeline** (invocada a partir de outra skill):
```
{
  "text": "...",
  "context": "linkedin-post|blog|email|whatsapp|...",
  "score-only": true|false,
  "max-rewrites": 1
}
```

### Passo 2 · Análise de padrões AI

Lê `references/ai-tells.md` e aplica os detetores:

**Detetores estruturais** (-1 cada um):
- Em-dashes (—) em vez de vírgula ou parênteses
- Listas de 3 elementos sempre (regra de 3 abusada)
- "It's not just X, it's Y" (estrutura típica GPT)
- Triple emoji no início ou fim
- Fechos com "in conclusion", "to summarize", "moving forward"

**Detetores léxicos** (-0.5 cada um):
- "Leverage", "delve into", "navigate", "tapestry", "robust", "seamless", "synergy"
- "In today's fast-paced world", "in the realm of", "at the end of the day"
- "It's worth noting that", "it's important to note", "needless to say"
- Advérbios excessivos ("incredibly", "remarkably", "surprisingly")

**Detetores de padrão** (-1.5 cada um):
- 3+ frases consecutivas a começar igual
- Parágrafo monotemático com frases todas de comprimento parecido (>20 palavras cada uma)
- Negação-afirmação encadeada: "não é X, é Y. Não é Z, é W"
- Bullet point com a mesma estrutura sintática em todo o bloco

### Passo 3 · Score

```
score = 10 - sum(penalties)
score = max(0, score)
```

Interpretação:
- 9-10 → soa humano, OK entregar
- 7-8 → aceitável mas há tells; sugerir 2-3 alterações
- 5-6 → claramente AI; reescrever parcialmente
- 0-4 → AI slop completo; reescrever desde zero

### Passo 4 · Reescrita (se score < 7)

Aplicar regras por ordem:

1. **Eliminar muletas léxicas** — substituir por sinónimos específicos do contexto
2. **Quebrar a regra de 3** — se houver 3 elementos paralelos, deixar 2 ou 4
3. **Variar arranques de frase** — alternar pronome, verbo, conector
4. **Substituir em-dashes** por pontos, vírgulas ou parênteses conforme fluência
5. **Aterrar abstrações** — frases tipo "navigate complexity" → "tomar decisões quando há 5 opções contraditórias"
6. **Quebrar monotonia rítmica** — alternar frases curtas (5-10 palavras) com longas (20+)
7. **Preservar a voz do operador** — ler `brand-context/voice/voice-profile.md` se existir; usar registo apropriado conforme `context` do input

### Passo 5 · Validação pós-rewrite

Re-passar o detetor. Se após 1 rewrite continuar < 7:
- Devolver com flag `needs_human_pass: true`
- Não voltar a reescrever automaticamente (risco de piorar / alucinar)

### Passo 6 · Output

**Modo standalone**:
```markdown
## Score: 6.5/10

### Padrões AI detetados
- 3 em-dashes em 4 frases (-3)
- "leverage" usado 2 vezes (-1)
- Lista de 3 abusada em 2 parágrafos (-2)

### Versão humanizada
<texto reescrito>

### Alterações principais
- "Leverage AI" → "Usar IA"
- Em-dashes → vírgulas e pontos
- Lista de 3 → 2 pontos diretos
```

**Modo pipeline** (devolvido à skill que chamou):
```json
{
  "score": 6.5,
  "passes_gate": false,
  "rewritten_text": "...",
  "issues": ["em-dash overuse", "leverage twice", "rule-of-three abuse"],
  "needs_human_pass": false
}
```

### Passo 7 · Fecho

- Se foi invocação standalone: mostrar comparativo ao utilizador
- Se foi pipeline: devolver ao caller, não escrever mais nada
- Append a `context/learnings.md` se detetaste um padrão AI novo não documentado em `ai-tells.md` (propor expandir o detetor)

## Outputs

**Standalone**: ficheiro em `projects/tool-humanizer/<data>-<titulo>/{original.md, humanized.md, report.md}`

**Pipeline**: JSON para o caller, sem ficheiros físicos.

## Skills que chama

Nenhuma. É uma tool primitiva (não orquestra nada).

## Edge cases

- **Texto muito curto (<20 palavras)**: score automático 8 (não há o suficiente para julgar). Não reescrever.
- **Idioma que não seja português ou inglês**: degradar para checks estruturais apenas (em-dashes, comprimento, listas). O léxico AI é language-specific.
- **Operador não tem brand-voice configurada**: usar registo neutro divulgativo (B genérico). Marcar no output: "Sem voice profile carregado, o resultado pode não encaixar 100% com a tua voz".
- **Texto poético ou criativo**: as regras de "AI slop" não se aplicam igual; perguntar ao utilizador se quer fazer skip ao humanizer.

## Examples

Ver `references/examples.md` para 3 casos: LinkedIn post, email cliente, blog post.

## Knowledge

- `references/ai-tells.md` — listagem completa de padrões AI detetáveis (mantida)
- `references/examples.md` — 3 casos completos antes/depois com scoring
