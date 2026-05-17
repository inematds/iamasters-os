---
name: marketing-content-repurposing
description: Converte uma peça fonte (vídeo YouTube, podcast, transcript de reunião, blog longo) em 5-8 peças multiplataforma a respeitar brand voice. Output pacote com LinkedIn post + X thread + email newsletter + Instagram caption + clips ideas + headlines blog. Invoca marketing-copywriting por cada peça e tool-output-verifier como gate.
---

# marketing-content-repurposing

## Quando é invocada

- Utilizador diz: "repurpose este vídeo", "tira conteúdo deste podcast", "do último Café Camaleónico, tira-me X peças"
- Após uma aula / talk / vídeo longo, automatizar a distribuição
- Skill `strategy-trending-research` sugere-a quando deteta um tema valioso do operador para amplificar

## Process

### Passo 1 · Identificar fonte

Tipos suportados v0.2:
- **Vídeo YouTube** (URL) → invoca `tool-youtube-transcript` (skill futura) ou pede ao utilizador o transcript
- **Áudio local** (MP3/WAV) → não suportado v0.2, pedir transcript manual
- **Transcript colado no chat** (texto)
- **Blog post extenso** (URL ou colado) → invoca `tool-firecrawl-scraper`
- **Reunião / call** (transcript Zoom/Fathom)

Pergunta ao operador:
- Que fonte?
- Que plataformas queres priorizar?
- Que frequência? (1 pacote completo / spread em 2 semanas)

### Passo 2 · Análise da fonte

Ler transcript completo (se > 50K tokens, usar subagent para ler em chunks).

Extrair:
- **3-5 ideias core** (as que têm mais substância)
- **Citações memoráveis** (frases que se sustentam sozinhas)
- **Stats / números** (dados concretos mencionados)
- **Story hooks** (anedotas que se podem extrair)
- **Counterintuitive points** (pontos que contradizem o consenso)
- **Action items** (conselhos acionáveis)

Saída intermédia (não se entrega):
```markdown
## Análise de fonte

### Ideias core
1. ...
2. ...

### Citações memoráveis
- "..." (timecode se vídeo)

### Stats
- "47% das empresas..." (timecode)

### Story hooks
- "Quando estava com o cliente X..."

### Counterintuitive points
- "O oposto do que diz o consenso é: ..."

### Action items
- ...
```

### Passo 3 · Mapear para plataformas

Cada ideia → plataforma(s) que melhor encaixam:

| Ideia | LinkedIn | X thread | Newsletter | Instagram | Reel/Short | Blog post |
|---|:-:|:-:|:-:|:-:|:-:|:-:|
| Ideia 1 (insight contraintuitivo) | ✅ | ✅ | ✅ | | ✅ | |
| Ideia 2 (story pessoal) | ✅ | | ✅ | ✅ | ✅ | |
| Ideia 3 (stats) | ✅ | ✅ | | ✅ | | |
| Ideia 4 (action item) | | | ✅ | ✅ | | ✅ |
| Ideia 5 (citação) | ✅ | ✅ | | ✅ | ✅ | |

### Passo 4 · Gerar peças

Para cada plataforma, invocar `marketing-copywriting`:

```
marketing-copywriting:
  brief: "[Ideia core mapeada]"
  platform: "linkedin"
  purpose: "thought-leadership"
  source-context: "[Resumo 1-line da fonte]"
```

Repetir para LinkedIn post, X thread, Newsletter, Instagram caption, Reel hook + script breve, Blog headline + outline.

### Passo 5 · Validar coerência entre peças

As peças não devem ser idênticas (é repurposing, não duplicação):
- LinkedIn: storytelling completo, 1500 chars
- X thread: stats + counter-intuitive, 5-7 tweets
- Newsletter: action items + insight, 300 words
- Instagram: citação + visual, 200 chars caption
- Reel: hook 5s + payoff visual, 30s script
- Blog: deep-dive de 1 ideia, headline + outline 5 H2

Comprovar que cada peça:
- Passa o gate (`tool-output-verifier`)
- Não repete estrutura idêntica das outras
- Aporta UM ângulo distinto do mesmo tema

### Passo 6 · Gerar pacote entregável

```
projects/marketing-content-repurposing/<YYYY-MM-DD>-<slug-fonte>/
├── source-analysis.md          # análise passo 2
├── platform-map.md             # mapeamento passo 3
├── linkedin-post.md            # variação final + 2 alternativas
├── x-thread.md                 # tweets numerados
├── newsletter-section.md       # secção pronta a inserir
├── instagram-caption.md        # com sugestões de visual
├── reel-script.md              # hook 5s + script 30s
├── blog-outline.md             # headline + 5 H2 + intro
├── content-calendar.md         # proposta do que publicar quando
└── metadata.json               # source, scores, datas
```

`content-calendar.md` proposta:
- Dia 1: LinkedIn post (engagement primeiro impulso)
- Dia 2: X thread (reforça)
- Dia 3: Instagram caption (visual do tema)
- Dia 4: Reel (fecha ciclo redes)
- Dia 5: Newsletter (consolidação + email list)
- Dia 7+: Blog post completo

### Passo 7 · Cierre

- Mostrar pacote ao operador com preview
- Pedir confirmação de quais publicar (ou ajustes)
- Append em `context/learnings.md` sob `## marketing-content-repurposing`
- Se a fonte foi particularmente rica → sugerir guardar referência para reutilizar mais adiante

## Outputs

Pacote completo em `projects/marketing-content-repurposing/<data>-<slug>/` com 8-10 ficheiros.

## Skills que chama

- `tool-firecrawl-scraper` (se fonte for URL)
- `tool-youtube-transcript` (se fonte for YouTube — skill futura, manual entretanto)
- `marketing-copywriting` (uma invocação por plataforma)
- `tool-output-verifier` (transitivo via copywriting)

## Edge cases

- **Fonte muito curta** (<500 words): repurpose tem pouco material. Gerar 2-3 peças no máximo, não forçar 8.
- **Fonte sem substância** (conversa genérica sem insights): avisar o operador "esta fonte não dá para repurpose, sugestão: grava algo mais concreto".
- **Idioma da fonte ≠ idioma dos outputs**: traduzir + adaptar ao voice profile no idioma destino. Avisar do custo qualidade.
- **Fonte com info confidencial** (cliente, dados sensíveis): fazer uma passagem de sanitização antes de gerar peças. Pedir confirmação ao operador.
- **Operador pede só 1 plataforma**: não é repurposing, derivar a `marketing-copywriting` diretamente.

## Examples

Ver `references/examples.md` para 2 casos:
1. Repurpose vídeo YouTube de 25 min sobre Claude Code → 8 peças
2. Repurpose transcript reunião cliente sobre case study → 5 peças com sanitização
