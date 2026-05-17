---
name: decisions-log
description: Mantém um diário append-only de decisões importantes do operador, com formato fixo (data · decisão · raciocínio · contexto). Usa-o quando o utilizador tomar uma decisão estratégica que quererá recordar mais à frente, ou quando outra skill (six-hats, marketing-positioning, pricing-strategy) fechar com uma conclusão decidida. O log vive em `context/decisions-log.md` e o Claude lê-o ao arrancar cada sessão para não se contradizer com decisões anteriores.
---

# decisions-log

> **Crédito**: este padrão está inspirado diretamente em [`Luispitik/claude-code-second-brain`](https://github.com/Luispitik/claude-code-second-brain) de Luis Pitik (mesmo autor de Sinapsis). O conceito de "decision journal append-only que o Claude lê para manter coerência entre sessões" é dele. Mantemos o formato exato e referenciamos o repo original.

## Quando é invocada

- Utilizador diz: "regista esta decisão", "quero lembrar-me disto", "anota que decidimos X"
- Outra skill fecha com uma decisão clara e propõe gravá-la (six-hats, pricing-strategy, marketing-positioning, etc.)
- Fecho de sessão (`/wrap-up`) deteta uma decisão tomada que não foi registada e propõe gravá-la
- Utilizador pergunta: "o que decidimos sobre Y?" → a skill procura no log

## Por que importa

Claude Code (mesmo com Sinapsis) pode contradizer-se entre sessões se uma decisão antiga não lhe for lembrada. O operador também esquece — e pior, *muda de opinião sem se aperceber*. Um log append-only força a:
1. Tornar as decisões explícitas no momento em que se tomam
2. Ter o "porquê" registado (não só o "o quê")
3. Comparar a versão atual com o decidido antes (quando alguém sugere mudar)
4. Gerar um track record honesto do operador ao longo do tempo

## Formato canónico

Cada entrada em `context/decisions-log.md` segue exatamente esta estrutura:

```markdown
## YYYY-MM-DD · <título curto, ≤60 chars>

**Decisão**: <1 frase clara com o quê>

**Raciocínio**: <2-4 frases com o porquê — inclui os dados ou
sinais que levaram à decisão, não só "porque sim">

**Contexto**: <1-2 frases com a situação mais ampla que explica
porque esta decisão fazia sentido neste momento. Crucial para
reavaliar amanhã.>

**Quando reconsiderar**: <critério concreto que faria rever a
decisão — evento, métrica, data. NÃO "se correr mal".>

---
```

## Process

### Passo 1 · Detetar que há decisão

Uma decisão qualifica para o log se cumprir PELO MENOS 2 de:
- **É não trivial** — afeta o negócio, um cliente, o posicionamento, a equipa, ou o tempo do operador em >2h/semana
- **Tem reversibilidade limitada** — custaria tempo/dinheiro/relações revertê-la
- **Vai influenciar futuras conversas com o Claude** — o sistema devia mantê-la coerente

Se a "decisão" for operativa pequena (que cor usar, que hora de reunião, que ficheiro nomear), NÃO vai para o log. Para isso há tarefas e notas, não decisions journal.

### Passo 2 · Ler o log existente

Antes de adicionar, lê `context/decisions-log.md` completo (ou se for muito longo, as últimas 20 entradas) para:
- Detetar se esta decisão **contradiz** uma anterior — então há que registar a inversão, não só adicionar
- Detetar se esta decisão **complementa** uma anterior — referenciar a entrada anterior com `(refina <YYYY-MM-DD · título>)`
- Verificar que o formato canónico se mantém consistente

### Passo 3 · Confirmar com o utilizador os 4 campos

Pergunta por ordem:

```
1. Título curto (≤60 chars):
2. Decisão em 1 frase:
3. Raciocínio (os dados/sinais que te levaram aqui):
4. Quando devíamos reconsiderar esta decisão (que evento ou métrica):
```

Se o utilizador for lacónico ou não quiser escrever, propõe tu um draft baseado na conversa que acabaram de ter. Pede-lhe "ok" ou ajustes.

O **Contexto** redige-lo tu a partir do estado do operator-state + o que tenhas observado na conversa. NÃO o perguntes — seria pedir ao utilizador para explicar o óbvio.

### Passo 4 · Append no log

Edita `context/decisions-log.md` adicionando a nova entrada NO FIM do ficheiro, seguindo o formato canónico exato.

**Nunca edites entradas existentes.** Se uma decisão for invertida, escreve nova entrada com título tipo "Invertemos decisão de YYYY-MM-DD: agora fazemos X" e referência explícita.

### Passo 5 · Confirmar e propor seguinte

Após o append, mostra ao utilizador:

```
✅ Registada: <título da decisão>

Total de decisões gravadas: <N>
Tempo desde a última decisão: <X dias>

Há outra decisão de hoje que devíamos gravar?
```

### Passo 6 · Fecho

- Se a decisão gravada **inverter** uma anterior, propõe no wrap-up atualizar `~/.claude/skills/_operator-state.json` para que a operação diária reflita a nova direção
- Se esta for a 5ª, 10ª ou 25ª decisão gravada, celebra brevemente — o log torna-se útil exponencialmente com cada nova entrada

## Leitura do log ao arrancar sessão

`meta-start-here` e `meta-onboarding-wizard` devem ler as últimas 5 entradas do log ao arrancar e mencioná-las se forem relevantes para a conversa que começa.

Exemplo de mensagem ao arrancar:

```
Lembretes do decisions-log:
- (há 3 dias) Decidiste pausar lançamentos em julho e centrares-te no produto.
  Continua a ser o plano ou mudamos?
- (há 12 dias) Decidiste subir preços anuais para €497.
  Já o aplicaste ou fica pendente?
```

## Outputs

- Append em `context/decisions-log.md`
- Opcional: update em `~/.claude/skills/_operator-state.json` se a decisão muda o estado atual do operador

## Skills que chama

Nenhuma diretamente. Esta skill é invocada **por** outras (six-hats, pricing-strategy, marketing-positioning, etc.) quando essas fecham com decisão.

## Edge cases

- **Log vazio (primeira vez)**: adicionar um header ao ficheiro:
  ```markdown
  # Decisions log

  Diário append-only de decisões do operador.
  Padrão inspirado em [claude-code-second-brain](https://github.com/Luispitik/claude-code-second-brain) de Luis Pitik.

  ---
  ```
  Depois adiciona a primeira entrada normal.

- **Decisão muito emocional / impulsiva**: pergunta ao utilizador "queres dormir 24h sobre isto antes de gravar? As decisões impulsivas no log vão confundir-te mais à frente." Se insistir, regista-a com tag `[impulsiva]` no título.

- **Decisões contraditórias dentro da mesma sessão**: se o utilizador decide A, depois diz B, regista como entrada única "Mudança de opinião durante sessão: primeiro A, agora B" com raciocínio do porquê mudou.

- **Decisão sobre cliente concreto vs decisão pessoal**: se for de cliente, vai para o log do cliente (`clients/<nome>/context/decisions-log.md`). Se for pessoal/operador, para a raiz. Em caso de dúvida, raiz.

- **Decisão que requer comunicação à equipa**: depois de a gravar, propõe ao utilizador redigir o comunicado à equipa (via `marketing-copywriting` ou draft direto).

## Examples

### Exemplo de entrada bem formada

```markdown
## 2026-05-08 · Pausar sprint v0.5.0 até validar v0.4.3

**Decisão**: pausar o sprint planeado de adicionar 7 skills novas ao iamasters-os (v0.5.0) até ter lançado v0.4.3 com os fixes de plug-and-play e validado em uso real.

**Raciocínio**: a sessão de planning aplicando 6 chapéus mostrou que o problema central não é catálogo (12 → 19 skills) mas sim fricção de onboarding. Adicionar mais skills sobre um onboarding partido multiplica fricção. Além disso, a lição de ontem à noite com o cockpit (RUBRIC) reforça: validar contra uso real antes de continuar a construir.

**Contexto**: iamasters-os v0.4.2 publicado no GitHub com 12 skills + atribuição completa mas sem ter sido instalado ainda por nenhum membro da iAmasters Academy. Sprint v0.5.0 estava previsto imediatamente. v0.4.3 introduz: refactor README+AGENTS para auto-instalação URL conversacional, /doctor, welcome-quick-win, six-hats, decisions-log, sectorização context/, vídeos Loom 60s.

**Quando reconsiderar**: se após release v0.4.3 + envio ao Luis para feedback, validação com 5+ membros mostrar que o catálogo de 18 skills está bem mas faltam skills específicas concretas. Então v0.5.0 com essas, não as 7 originalmente planeadas às cegas.

---
```

### Exemplo de inversão de decisão

```markdown
## 2026-06-10 · Invertemos decisão 2026-04-15: volta o Free Trial 7 dias

**Decisão**: reativar o Free Trial de 7 dias para iAmasters, eliminado a 6-abril-2026.

**Raciocínio**: após 2 meses sem trial, os dados mostram que o funil "lançamento de 6 em 6 semanas" tem gap entre lançamentos onde não entra ninguém. Trial 7 dias preenchia esse gap. CAC trial €54 com conversão de 32.6% continua a ser o melhor modelo numérico que temos.

**Contexto**: decisão 2026-04-15 eliminou trial pensando que o modelo "comunidade fechada + lançamentos" era suficiente. Após 60 dias: MRR baixou de €45K para €42K. A previsão de "trial canibaliza lançamentos" não se confirma com os dados.

**Quando reconsiderar**: se após 60 dias com trial reativado, MRR não recuperar trajetória para €50K, então o problema não era o trial — investigar outra hipótese.

---
```

## Notas operativas

- **Nunca apagues entradas do log**, nem as edites a posteriori. O log é histórico imutável. Se algo mudar, NOVA entrada.
- **Uma sessão NÃO deve gerar mais de 3 entradas**. Se for mais, provavelmente estás a registar ruído. Pergunta-te quais são não triviais.
- **As entradas mais úteis são as que doem registar** — as que admites um erro, mudas de opinião, ou decides algo que vai contra o teu instinto. Essas é que o log ajuda a respeitar.
- **O log é só do operador**, não de cada cliente. Para clientes há um decisions-log dentro de `clients/<nome>/context/`.
