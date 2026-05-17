---
name: meta-deep-dive
description: Segunda fase do onboarding após `meta-onboarding-wizard`. NÃO é um formulário — é uma entrevista conversacional adaptativa que aprofunda 22-25 dimensões residuais sobre a pessoa (ritmos, motivadores, comunicação), o negócio (saúde financeira, diferencial, fricções), a equipa (dinâmica, delegação, clientes top/tóxicos) e o foco (decisões pendentes, metas a 3 anos, medos, métricas, definição de sucesso). Aplica regras de aprofundamento e técnicas conversacionais — nunca lista plana de perguntas. Cobre com branching condicional (se trabalha sozinho, salta o bloco equipa). Termina quando todas as dimensões aplicáveis têm dado sólido. Idempotente — retoma onde ficou.
---

# meta-deep-dive

> Segunda fase do onboarding. Aprofunda o operador. O sistema já funciona após o wizard inicial, mas conhece-te superficialmente. Isto é o que converte outputs "decentes" em outputs que parecem teus de verdade.

## Quando é invocada

- Utilizador executa `/deep-dive` explicitamente
- `meta-start-here` sugere executá-la se `operator-state.deepDiveCompleted === false` e passaram >12h desde o wizard inicial
- Utilizador retoma um deep-dive a meio (`operator-state.deepDiveProgress` indica dimensões cobertas)

NÃO se invoca:
- Se `operator-state.needsOnboarding === true` → primeiro lançar `meta-onboarding-wizard`
- Se `operator-state.deepDiveCompleted === true` e não há pedido explícito

## Filosofia

A mesma que o wizard inicial: **não é um formulário, é conversa adaptativa**. As perguntas decides-las em cada turno conforme a resposta anterior. O que está fixo são as **dimensões a cobrir** e as **regras de aprofundamento**.

A diferença em relação ao wizard inicial: aqui aprofundas em áreas que requerem **honestidade e reflexão**, não só factuais. O operador pode sentir-se exposto. O teu tom é de **entrevistador profissional**, não de coach motivacional.

## As 22-25 dimensões a cobrir

Lê [`references/dimensiones-deep.md`](references/dimensiones-deep.md) para o detalhe completo de cada uma com que informação deve ficar capturada.

| # | Dimensão | Bloco | Ficheiro destino |
|:--|---|---|---|
| 1 | Horário produtivo | A · Pessoa | `context/me.md` |
| 2 | Interrupções principais | A · Pessoa | `context/me.md` |
| 3 | Contexto vital relevante | A · Pessoa | `context/me.md` |
| 4 | Motivadores profundos | A · Pessoa | `context/me.md` |
| 5 | Drenadores | A · Pessoa | `context/me.md` |
| 6 | Estilo preferido de comunicação com IA | A · Pessoa | `context/soul.md` |
| 7 | Palavras/tons proibidos | A · Pessoa | `context/soul.md` |
| 8 | Saúde financeira (faixa de faturação) | B · Negócio | `context/work.md` |
| 9 | Margem aproximada | B · Negócio | `context/work.md` |
| 10 | Ticket médio | B · Negócio | `context/work.md` |
| 11 | Diferencial real (não genérico) | B · Negócio | `context/work.md` |
| 12 | Side projects / negócios paralelos | B · Negócio | `context/work.md` |
| 13 | Fricções do modelo | B · Negócio | `context/work.md` |
| 14 | Tamanho equipa (gate condicional) | C · Equipa | `context/team.md` |
| 15 | Papéis + dinâmica da equipa | C · Equipa · se aplicável | `context/team.md` |
| 16 | Comunicação interna | C · Equipa · se aplicável | `context/team.md` |
| 17 | Delegação (o que sim/o que não) | C · Equipa · se aplicável | `context/team.md` |
| 18 | Clientes top (3-5 nomes + faturação aprox) | C · Equipa · sempre | `context/team.md` |
| 19 | Clientes problemáticos | C · Equipa · sempre | `context/team.md` |
| 20 | Decisão pendente | D · Foco | `context/current-priorities.md` |
| 21 | Meta 3 anos profissional | D · Foco | `context/goals.md` |
| 22 | Meta 3 anos vital (não profissional) | D · Foco | `context/goals.md` |
| 23 | Medo profissional | D · Foco | `context/goals.md` |
| 24 | Métrica semanal de seguimento | D · Foco | `context/goals.md` |
| 25 | Definição pessoal de sucesso | D · Foco | `context/goals.md` |

**Definição de "done"**: cada dimensão aplicável tem pelo menos 1 dado sólido (não genérico, não "não sei" sem justificação, não resposta evasiva).

**Tempo objetivo**: 25-30 minutos. Se demorar mais, algo vai mal com o aprofundamento.

## Regras de aprofundamento (mesmas que o wizard)

Lê [`references/tecnicas-conversacionales.md`](references/tecnicas-conversacionales.md) para o repertório completo.

Resumo:
- Resposta curta/abstrata → 1 follow-up com técnica (exemplo concreto, 5 whys leve, inversão, espelho, ancoragem temporal).
- Máximo 2 níveis de profundidade por dimensão.
- Resposta rica → salta para a dimensão seguinte.
- Utilizador mostra fadiga → acelera ou propõe parar.

## Anti-formulário (proibido)

As mesmas regras que o wizard inicial. Lê [`references/tecnicas-conversacionales.md`](references/tecnicas-conversacionales.md) secção "O que NÃO é técnica conversacional".

Especialmente importante no deep-dive (porque há dimensões emocionais):
- ❌ "Que interessante", "boa resposta" → soa a coach mau.
- ❌ Tom terapêutico ("como te faz sentir?") — não és o terapeuta dele.
- ❌ Juízo implícito se o utilizador admite algo (cliente tóxico, medo, contradição).
- ❌ Anunciar blocos ou numerar dimensões ao utilizador.

## Process

### Passo 1 · Abertura

Verifica `operator-state.deepDiveProgress`:
- Se NÃO existir (primeira vez): abertura completa.
- Se EXISTIR: retoma com abertura curta indicando onde ficou.

**Abertura completa** (primeira vez):

```
Vamos ao deep-dive.

O da outra vez foi o mínimo para arrancar. Isto aprofunda
outras 20-25 áreas que mudam muito os outputs do sistema:
como trabalhas, como ganhas a vida, a tua equipa se a tiveres,
as tuas metas a 3 anos, os teus medos profissionais.

Demora ~25 minutos. É honesto — algumas perguntas são
incómodas. Se não quiseres responder a alguma, diz e salto. Se
quiseres parar a meio, também — da próxima vez retomamos
onde estiveres.

Pronto? Começamos por como trabalhas tu, antes de entrarmos no
negócio.
```

**Abertura retomando** (segunda+ sessão):

```
Voltamos ao deep-dive. Da última vez ficámos em
<última dimensão coberta>. Faltam ~<N> dimensões (~<min> min).

Se quiseres pausar outra vez, diz quando quiseres. Continuamos?
```

### Passo 2 · Entrevista adaptativa

Percorre as dimensões aplicáveis por esta ordem (NÃO o anuncies):

**Bloco A · Pessoa profunda** (dimensões 1-7)
- 1 Horário produtivo → "Em que horário do dia rendes melhor? Manhã, tarde, noite, mix?"
- 2 Interrupções → "O que te interrompe mais no dia a dia? Clientes, equipa, família, distrações próprias?"
- 3 Contexto vital → "Há algo no teu contexto vital neste momento que o sistema deva ter em conta? Filhos pequenos, saúde, mudança de casa, viagens... o que afete a tua energia. Se não quiseres, também vale 'não aplica'."
- 4 Motivadores → "Para além do dinheiro, o que te motiva profissionalmente? Sê concreto se conseguires."
- 5 Drenadores → "Que tipo de tarefas te drenam ao ponto de as evitares?"
- 6 Estilo IA → "Como preferes que a IA te fale? Direta sem rodeios, conversacional, formal, com humor..."
- 7 Palavras proibidas → "3-5 palavras, frases ou tons que NUNCA deveria usar em outputs teus? Corporate-speak, modismos que detestas, o que for."

**Bloco B · Negócio profundo** (dimensões 8-13)
- 8 Saúde financeira → "Quanto faturas aproximadamente ao mês? Um intervalo está bem. Isto muda muito o que o sistema te pode recomendar, por isso pergunto."
- 9 Margem → "Margem bruta aproximada? Baixa, média, alta."
- 10 Ticket médio → "Qual é o teu ticket médio por cliente ou por venda?"
- 11 Diferencial real → "Em que és realmente diferente da tua concorrência? Não genérico — algo concreto que levarias para o pitch comercial."
- 12 Side projects → "Tens negócios secundários ou projetos paralelos? Mesmo que sejam side projects sem revenue."
- 13 Fricções → "Que parte do teu modelo gostarias de mudar mas ainda não mudaste? Porquê?"

**Bloco C · Equipa e clientes** (dimensões 14-19)
- 14 Tamanho equipa → "Quantas pessoas há no teu dia a dia? Tu sozinho / 1-3 / 4-10 / mais de 10."
- **Se "sozinho"**: salta dimensões 15-17. Passa direto a 18-19.
- **Se tiver equipa**: dimensões 15-17.
  - 15 Papéis → "Passa-me as pessoas chave. Para cada uma: nome, o que faz, em que é forte, onde falha. Sem filtros."
  - 16 Comunicação → "Como comunicam? Slack, WhatsApp, reuniões semanais, async..."
  - 17 Delegação → "Que partes do negócio estão delegadas hoje e o que te recusas a delegar? Porque te custa?"
- 18 Clientes top → "Os teus 3-5 clientes/projetos mais importantes neste momento? Nome + faturação aproximada."
- 19 Clientes problemáticos → "Há clientes tóxicos ou problemáticos que aguentas por dinheiro? Honestidade."

**Bloco D · Foco profundo** (dimensões 20-25)
- 20 Decisão pendente → "Que decisão importante tens pendente de tomar neste momento?"
- 21 Meta 3 anos pro → "Olha-te daqui a 3 anos. O que imaginas profissionalmente? Sem pressão."
- 22 Meta 3 anos vital → "Mesma pergunta mas pessoal/vital. Família, saúde, lifestyle, o que não é trabalho."
- 23 Medo profissional → "Qual é o teu maior medo profissional neste momento?"
- 24 Métrica semanal → "Que métrica olhas semanalmente para saber se vais bem?"
- 25 Definição de sucesso → "Como defines sucesso pessoal nos próximos 12 meses, para além dos KPIs?"

Para cada resposta, aplica as **regras de aprofundamento** e as **técnicas conversacionais**. Respeita os **anti-padrões**.

### Passo 3 · Checkpoints a cada 7 dimensões

Após dimensões 7, 13, 19 — checkpoint curto:

```
Fizeste <bloco>. Faltam <N> dimensões, ~<min> min.

Continuamos ou deixamos por aqui e amanhã retomamos?
```

Se disser "seguimos" → continua.
Se disser "para" → guarda progresso, fecha com abertura retomável.

### Passo 4 · Escrita de ficheiros

Só quando termina (ou quando para a meio), escreve os ficheiros sectorizados.

**Importante**: o deep-dive **completa** os ficheiros sectorizados existentes, **não os substitui**. Lê o ficheiro atual, adiciona as secções novas conforme `references/dimensiones-deep.md`, preserva o que o wizard inicial deixou.

Ficheiros afetados:
- `context/me.md` — secções de horário, interrupções, contexto vital, motivadores, drenadores
- `context/soul.md` — secção "Como me falas tu" + "Palavras proibidas"
- `context/work.md` — secções financeiras, diferencial, side projects, fricções
- `context/team.md` — estrutura, papéis, comunicação, delegação, clientes top/tóxicos
- `context/current-priorities.md` — secção "Decisões abertas"
- `context/goals.md` — meta 3 anos pro/vital, medo, métrica, definição sucesso

### Passo 5 · Fecho

Se completou 100%:

```
Deep-dive completo.

O sistema agora conhece-te profundamente. Os outputs vão sair
com a tua voz, o teu critério e o teu contexto real — não genéricos.

Atualizei:
  ✓ context/me.md — ritmos, motivadores, contexto vital
  ✓ context/soul.md — como te falo e palavras que evito
  ✓ context/work.md — saúde financeira, diferencial, fricções
  <se aplicar> ✓ context/team.md — equipa, comunicação, delegação
  ✓ context/team.md — clientes top e problemáticos
  ✓ context/current-priorities.md — decisão pendente
  ✓ context/goals.md — metas 3 anos, medo, métricas, sucesso

A partir daqui: usa-o. Se em algum momento as respostas não
soarem a ti, executa `/deep-dive refine` e refinamos o que
desafinar.
```

Marca `operator-state.deepDiveCompleted: true`.

Se ficou a meio:

```
Pausa registada. Tens <N> de 25 dimensões cobertas.

Quando quiseres retomar:  /deep-dive

Vou sugerir-te também a partir de /start-here até o fechares.
```

Guarda `operator-state.deepDiveProgress: <N>` e `deepDiveLastDimension: <id>`.

### Passo 6 · Append ao daily summary

Em `~/.claude/skills/_daily-summaries/<TODAY>.md`:

```
## Deep-dive · sessão <N>
- Dimensões cobertas hoje: <lista>
- Estado: <completo | parcial>
- Ficheiros atualizados: <lista>
```

NÃO appends em `context/learnings.md` (isto não é feedback de skill).

## Outputs

- `context/me.md` ampliado
- `context/soul.md` com estilo pessoal do operador
- `context/work.md` ampliado com dados financeiros e diferencial
- `context/team.md` preenchido (ou consolidado se trabalha sozinho)
- `context/current-priorities.md` com decisão pendente
- `context/goals.md` ampliado com metas 3 anos, medo, métricas, sucesso
- `operator-state.deepDiveCompleted: true` (se completo)
- `operator-state.deepDiveProgress: <N>` (se parcial)

## Edge cases

- **Utilizador abandona a meio de um follow-up**: guarda até à última dimensão fechada. NÃO marca a dimensão em curso como capturada se só tiver a primeira tentativa fraca.
- **Utilizador nível técnico zero, assustado por dimensões financeiras (8-10)**: oferece-lhe intervalos em vez de cifras exatas: "Se te incomoda o número exato, dá-me um intervalo: baixo / médio / alto, serve igual."
- **Utilizador não tem equipa mas menciona colaboradores externos** (freelancers, contratistas): captura-os em `team.md` com nota "Equipa externa / colaboradores".
- **Utilizador admite cliente tóxico mas pede para não o anotar por nome**: respeita. Anota "<Cliente tipo X — tóxico por motivo Y>" sem nome concreto.
- **Utilizador contradição entre dimensões** (ex. diz motivador = liberdade, drenador = cliente que dá liberdade): não debates. Aponta ambas e deixa o utilizador refletir depois lendo `me.md`.
- **Utilizador completa deep-dive demasiado rápido (<10 min)**: provavelmente respondeu por cima. Fecha o wizard, mas anota no daily summary "deep-dive express — refinar em sessão futura".

## Skills relacionadas para chamar depois

Se o operador mencionar no deep-dive um problema concreto, sugere skill ao fechar:

- Confusão com ICP → `marketing-icp`
- Falta de clareza no voice profile → `marketing-brand-voice`
- Decisão pendente complexa → `six-hats`
- Bottleneck operacional → `marketing-content-repurposing` ou automation skills

NÃO executes as skills automaticamente. Só sugere no fim.

## Comando associado

O comando `/deep-dive` invoca esta skill. Ver `.claude/commands/deep-dive.md`.
