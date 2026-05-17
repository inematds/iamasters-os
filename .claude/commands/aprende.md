---
description: Tour interativo de 5 dias que te ensina a usar o iAmasters OS desde zero. Idempotente — retoma onde paraste.
---

# /aprende — Tour de 5 dias pelo iAmasters OS

Tutorial passo-a-passo para alunos que começam de zero. Cada dia são 5-10 minutos. Idempotente: se saltares um dia, retoma onde ficaste.

## Process

### Passo 1 · Detetar progresso

Ler `context/learn-progress.json`. Se não existe:

```json
{
  "started_at": "<data hoje>",
  "current_day": 1,
  "completed_days": [],
  "last_seen": "<data hoje>"
}
```

Se existe, mostrar:
```
Tour de 5 dias — iAmasters OS

Dia 1 ✅ completado
Dia 2 ✅ completado
Dia 3 ◀ próximo (estás aqui)
Dia 4 ⏳ pendente
Dia 5 ⏳ pendente

Continuamos com o Dia 3?
```

### Passo 2 · Executar o dia correspondente

Cada dia segue o padrão:
1. **Conceito** (2-3 min leitura)
2. **Demo em direto** (o Claude faz, o aluno vê)
3. **A tua vez** (o aluno faz algo guiado)
4. **Fecho** do dia + prévia do próximo

Ao fechar o dia, marcar em `learn-progress.json` e propor:
- *"Continuamos com o dia seguinte agora ou deixamos para amanhã?"*

---

## Dia 1 — O que é uma skill e como o Claude as ativa sozinho

### Conceito

Uma **skill** é uma pasta `.claude/skills/<categoria>/<nome>/` com um `SKILL.md` que tem um `description:`. O Claude lê TODOS os `description:` ao iniciar a sessão e, conforme o que escreveres, ativa automaticamente a skill que encaixa. Tu não a chamas — ela encontra-te.

**Exemplo real**: neste repo tens `marketing-copywriting`. Se escreveres *"escreve-me um email frio para um CTO de fintech"*, o Claude ativa essa skill sozinho. Não precisas dizer "usa a skill de copywriting".

### Demo em direto

O Claude mostra:
1. Lista de todas as skills atuais por categoria (lê `.claude/skills/`)
2. Para uma skill (ex. `marketing-copywriting`), abre o SKILL.md e mostra o `description:` que o Claude usa para decidir quando a ativar
3. Faz uma demo: gera 3 versões de post LinkedIn sobre um tema qualquer, **a apontar em que momento a skill foi ativada e porquê**

### A tua vez

Pede ao aluno: *"Pede-me algo concreto. Eu digo-te que skill ativei e porquê."* Três rondas. Se a skill não ativou a correta, o aluno aprende a refinar a pergunta.

### Fecho dia 1

> Hoje aprendeste: as skills vivem em `.claude/skills/`, o Claude ativa-as sozinho a ler o `description:`. Amanhã: brand context — a peça que faz com que o sistema escreva na TUA voz, não numa genérica.

---

## Dia 2 — Brand context: voz, ICP, posicionamento

### Conceito

**Brand context** é a informação que faz os teus outputs soarem a TI, não a IA genérica. Três peças:

- `voice/voice-profile.md` — A tua voz: como escreves, que palavras usas, o que evitas, 3 registos (A formal / B divulgativo / C próximo)
- `icp/icp.md` — O teu cliente ideal: dores, linguagem que usa, triggers de compra
- `positioning/positioning.md` — O teu ângulo: porque te escolhem a ti e não a outro

Todas as skills `marketing-*` leem estes ficheiros antes de gerar. Sem isto, o output é genérico.

### Demo em direto

O Claude:
1. Abre `brand-context/voice/voice-profile.md` (se existe — se não, sugere gerá-lo)
2. Gera um post LinkedIn primeiro **sem** voice profile, depois **com** voice profile
3. O aluno vê a diferença lado a lado

### A tua vez

Se o aluno ainda não tem voice profile:
- Lançar a skill `marketing-brand-voice` para gerar o dele (15-20 min)
- Ou, se tem pressa: preencher manualmente um mini-template com 5 frases típicas dele

### Fecho dia 2

> Hoje aprendeste: o sistema escreve na tua voz porque lê o brand-context. Amanhã: multi-cliente — como o mesmo OS serve vários clientes sem misturar contextos.

---

## Dia 3 — Multi-cliente: adicionar o teu primeiro cliente

### Conceito

Se trabalhas com vários clientes (ou és operador para vários negócios), cada um tem o seu brand context próprio. `clients/<nome>/` é uma cópia leve do OS dedicada a esse cliente.

Comando: `/add-client`. Pergunta nome, vertical (freelance, agência, formador, consultoria B2B…) e clona o template correspondente.

### Demo em direto

O Claude:
1. Lista os 4 templates de cliente em `clients/_templates/`
2. Executa `/add-client` com um cliente fictício ("Acme Marketing, agência")
3. Mostra a estrutura que se criou

### A tua vez

Se o aluno tem clientes reais:
- Criar um real com `/add-client`
- Configurar o brand-context dele (pode saltar e fazê-lo depois)

Se não tem clientes:
- Criar um fictício para praticar e depois apagá-lo

### Fecho dia 3

> Hoje aprendeste: cada cliente vive na sua própria pasta sem misturar. Amanhã: como adicionar skills e MCPs novos ao sistema.

---

## Dia 4 — Catálogo: adicionar skills e MCPs novos

### Conceito

O iAmasters OS vem com **22 skills core** pré-instaladas, mas o ecossistema Claude tem centenas mais. Há três formas de adicionar coisas:

1. **Plugins oficiais da Anthropic** (docx, xlsx, pdf, pptx, etc.) — instalam-se via marketplace, NÃO se copiam para o repo (a licença é source-available).
2. **Skills de terceiros com MIT/Apache** — `/install-skill <github-url>` vendoriza-as aqui.
3. **MCP servers** — `/install-mcp <nome>` liga-os (n8n-mcp, github, notion, supabase…).

### Demo em direto

O Claude:
1. **Plugins Anthropic**: mostra como executar `/plugin install anthropic-skills` desde o Claude Code para adicionar `docx`, `xlsx`, `pdf`, `pptx`. Resultado: o aluno pode pedir *"lê-me este PDF"* e funciona.
2. **Skill de terceiros**: exemplo com `/install-skill https://github.com/<owner>/<skill>` desde `docs/skills-recommended.md`.
3. **MCP**: exemplo com `/install-mcp n8n-mcp` para ativar a skill `automation-n8n-builder` que já tens no repo.

### A tua vez

Pede ao aluno que instale pelo menos:
- Os plugins Anthropic (docx, xlsx, pdf, pptx) — são universais, toda a gente precisa
- Um MCP que faça sentido para a stack dele (sugerir em função do que vimos no dia 2-3)

### Fecho dia 4

> Hoje aprendeste: o OS cresce contigo. Amanhã, o dia final: fluxo end-to-end real, de reunião a proposta enviada.

---

## Dia 5 — Fluxo end-to-end: de reunião a proposta

### Conceito

Hoje juntas tudo o que aprendeste. Caso real: tiveste uma reunião com um cliente novo, tens a transcrição, e precisas entregar uma proposta nessa mesma tarde.

Fluxo:
1. **Notas de reunião** → skill `marketing-content-repurposing` ou equivalente lê o transcript e extrai acordos, pendentes e dores do cliente
2. **Investigação do cliente** → `strategy-web-research` enriquece com dados públicos (site, LinkedIn, BORME se Espanha…)
3. **Proposta** → composição com brand context + voice profile + ICP do cliente
4. **Email follow-up** → `marketing-email-sequence` redige o envio inicial
5. **Visualização partilhável** → `tool-visual-explainer` gera o HTML que podes enviar por WhatsApp

### Demo em direto

O Claude executa o fluxo com um caso fictício (transcrição de reunião sintética, cliente B2B) e gera os 5 artefactos.

### A tua vez

O aluno traz **um caso real dele** (transcrição de reunião, brief de um cliente, o que for) e reproduz o fluxo. O Claude ajuda-o a identificar que skill se aplica em cada passo.

### Fecho dia 5

> Tour completado. Agora sabes:
> - Como vivem as skills e como se ativam sozinhas
> - Como o brand context te dá output na tua voz
> - Como servir vários clientes sem misturar
> - Como crescer o sistema com plugins, skills e MCPs
> - Como encadear skills num fluxo real
>
> Próximo passo: usa-o em produção esta semana com um cliente real. Se algo não encaixar, executa `/doctor` ou pergunta na comunidade. Se construíres uma skill que te funcione, propõe-na ao catálogo (ver `docs/skills-recommended.md`).

---

## Edge cases

- **O aluno salta do dia 1 para o dia 3 direto**: avisar que está a saltar peças, deixá-lo decidir se segue.
- **O aluno já tem voice profile gerado**: saltar dia 2 demo, ir direto ao dia 3.
- **O aluno trabalha sozinho e não tem clientes**: dia 3 pode saltar-se ou executar-se com cliente fictício.
- **O aluno não quer instalar plugins Anthropic**: respeitar, indicar o que perde (skills office), seguir.

## Fecho

Quando se completa o dia 5, marcar `learn-progress.json`:
```json
{
  "completed_days": [1,2,3,4,5],
  "completed_at": "<data>"
}
```

E avisar o aluno: *"Tour completado. `/aprende` volta a estar disponível quando quiseres rever um dia concreto: `/aprende dia-2`."*
