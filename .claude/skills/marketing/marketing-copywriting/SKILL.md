---
name: marketing-copywriting
description: Gera copy para uma plataforma específica (LinkedIn post, X thread, email, landing section, ad) usando brand-voice e registers A/B/C automaticamente. Passa por tool-output-verifier obrigatoriamente antes de entregar. Devolve 1-3 variações para que o operador escolha. A skill estrela do módulo marketing.
---

# marketing-copywriting

## Quando é invocada

- Utilizador diz: "escreve um post de LinkedIn sobre X", "redige um email para Y", "preciso de copy de landing"
- Outra skill (`marketing-content-repurposing`) chama-a depois de processar conteúdo fonte
- `marketing-email-sequence` usa-a para cada email do flow

## Process

### Passo 1 · Validar inputs e detetar plataforma

Inputs requeridos:
- **Tema ou brief** (o que queres comunicar)
- **Plataforma** (LinkedIn, X, blog, email, landing, etc.)
- **Purpose** (post de awareness, lead gen, lembrete, oferta...)

Se faltar plataforma → perguntar
Se faltar purpose → perguntar (muda o tom)
Se faltar tema → perguntar concreto

### Passo 2 · Carregar contexto

Ler:
1. `brand-context/voice/voice-profile.md` — voz do operador
2. Registo apropriado conforme plataforma:
   - email a cliente premium / proposta → `register-a-formal.md`
   - LinkedIn / blog / X / video script → `register-b-divulgativo.md`
   - WhatsApp / DM / comentário → `register-c-cercano.md`
3. `brand-context/positioning/positioning.md` — diferencial a comunicar
4. `brand-context/icp/icp.md` — quem vai ler (linguagem, dor, buying triggers)

Se faltar brand-context → avisar o operador e propor executar `marketing-brand-voice` antes (ou continuar com disclaimer "no-brand-voice mode").

### Passo 3 · Estrutura por plataforma

Aplicar template de plataforma:

#### LinkedIn post
```
[Hook 1-2 linhas — afirmação contundente ou pergunta direta]

[Contexto pessoal — "Há X meses que..." / "Vi...". Aporta credibilidade]

[Insight principal — a lição ou o insight. 1-2 parágrafos]

[Detalhe concreto — números, exemplos, gotchas]

[Cierre — pergunta aberta ou chamada para algo concreto]
```

Comprimento objetivo: 1200-1800 chars (verificável com `tool-output-verifier`).

#### X / Twitter thread
```
1/ [Hook forte. Promise specific outcome ou reveal counterintuitive]

2/ [Setup do problema ou context]

3-N/ [Cada tweet aporta UM ponto, max 240 chars]

Last/ [Cierre com CTA suave: "What's your take?" / "Save for later"]
```

Cada tweet ~220-260 chars.

#### Email cliente (registo A)
```
Assunto: [Específico, não genérico]

[Saudação calorosa mas formal conforme relação]

[Contexto imediato — "Após a nossa reunião de...", "Como te mencionei..."]

[Corpo — sem rodeios. 3 parágrafos no máximo]

[Cierre com próximo passo concreto]

[Assinatura]
```

#### Landing hero
- Headline: 7-9 palavras, claim diferencial do positioning
- Subheadline: 15-25 palavras, especificar para quem e o quê
- CTA primary: 2-3 palavras, verbo de ação
- CTA secondary: 3-5 palavras, "ver demo / ver casos"

### Passo 4 · Gerar 2-3 variações

Por defeito, gerar 3 variações (com etiquetas de ângulo):

**Variação 1 — Storytelling**: arranca com anedota pessoal/cliente
**Variação 2 — Insight contraintuitivo**: arranca com algo que o leitor não espera
**Variação 3 — Problema → solução**: arranca a descrever a dor do ICP

Cada variação:
- Aplica o voice-profile + register correto
- Respeita comprimento de plataforma
- Inclui números concretos quando possível
- Tem hook claro e cierre intencional

### Passo 5 · Passar pelo gate (obrigatório)

Para CADA variação, invoca `tool-output-verifier` em pipeline-mode:

```json
{
  "text": "<variação>",
  "platform": "linkedin",
  "purpose": "post"
}
```

Se alguma variação falhar o gate (`passes_gate: false`):
- Se humanizer < threshold → tentar UMA vez com tool-humanizer em rewrite mode
- Se brand-voice < 7 → reescrever a aplicar o voice-profile mais estritamente
- Se length out of range → ajustar comprimento
- Se após 1 retry continuar a falhar → marcar variação com ⚠️ e deixar o operador decidir

### Passo 6 · Output

```markdown
## 3 variações para LinkedIn post · "Tema X"

### Variação 1 · Storytelling — score 9.0/10 ✅
[Texto]

**Hook**: anedota pessoal
**Estrutura**: setup → revelação → lição
**CTA**: pergunta aberta sobre experiência do leitor

---

### Variação 2 · Insight contraintuitivo — score 8.5/10 ✅
[Texto]

**Hook**: afirmação que surpreende
**Estrutura**: claim → evidência → matiz
**CTA**: convite a discordar

---

### Variação 3 · Problema/solução — score 7.5/10 ⚠️ humanizer 6.8 (1 retry usado)
[Texto]

**Notas**: Continua a ter 2 em-dashes. Sugestão: rever manualmente antes de publicar.

---

Com qual ficas? Ou queres que misture 2?
```

### Passo 7 · Iteração com feedback

Se o operador pedir ajustes:
- "Mais curto" → reduz 30%
- "Mais próximo" → muda para registo C parcialmente
- "Muda o hook" → gera 2 hooks alternativos
- "Não me convence o cierre" → 3 cierres alternativos

Aplicar e voltar a verificar (Passo 5).

### Passo 8 · Cierre

- Guardar versão final do operador em `projects/marketing-copywriting/<YYYY-MM-DD>-<slug>/post.md`
- Se o operador pediu alterações significativas → append em `context/learnings.md` sob `## marketing-copywriting`
- Se detetaste um padrão novo no feedback → propor no wrap-up atualizar voice-profile ou registers

## Outputs

- `projects/marketing-copywriting/<data>-<slug>/`:
  - `post.md` — versão final
  - `variations.md` — todas as variações geradas
  - `metadata.json` — plataforma, purpose, scores

## Skills que chama

- `tool-output-verifier` (obrigatório, passo 5)
- `tool-humanizer` (transitivo via output-verifier, ou direto em rewrite)

## Edge cases

- **Sem brand-voice configurado**: warning + modo "neutro divulgativo" + sugerir executar `marketing-brand-voice` antes.
- **Plataforma não na lista**: usar template genérico + avisar.
- **Operador pede algo contra positioning** (ex. atacar segmento que é ICP): perguntar se tem a certeza, se disser que sim, gerar mas flagar.
- **Tema sensível** (política, religião, etc.): gerar mas avisar que as plataformas podem afetar visibilidade.
- **Output requerido em idioma distinto do voice-profile**: marcar low-confidence; recomendar rever manualmente.

## Examples

Ver `references/examples.md` para casos LinkedIn, X thread, email, landing hero.
