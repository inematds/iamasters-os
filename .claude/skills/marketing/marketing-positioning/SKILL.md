---
name: marketing-positioning
description: Constrói ou refina o posicionamento do operador. Analisa concorrentes (com tool-firecrawl-scraper), identifica buraco de mercado, propõe 3-5 ângulos de posicionamento e deixa o operador escolher. Output para brand-context/positioning/positioning.md. É invocada após brand-voice ou quando o operador sente que a mensagem não diferencia.
---

# marketing-positioning

## Quando é invocada

- Após `marketing-brand-voice` no fluxo de onboarding
- Operador diz: "não diferencio bem", "todos dizem o mesmo que eu", "ajuda-me a posicionar-me"
- Mudança de mercado ou lançamento de produto novo

## Process

### Passo 1 · Recolher inputs

Se NÃO existir `brand-context/positioning/positioning.md`:
- Modo: construção do zero

Se existir mas o operador pediu refiná-lo:
- Ler o atual e modo: refinamento

Pergunta ao operador (4-5 perguntas):

1. **Que problema resolves?** (1 frase, claro)
2. **Para quem exatamente?** (perfil do cliente, não "todos")
3. **Que alternativas têm já?** (outras soluções, agências, produtos, DIY)
4. **O que fazes tu diferente?** (sem "é que somos os melhores")
5. **Qual é o teu unfair advantage?** (algo que só tu ou poucos têm)

### Passo 2 · Investigar concorrentes (opcional)

Pergunta: "Tens 3-5 concorrentes cujas webs possamos analisar?"

Se sim:
- Invoca `tool-firecrawl-scraper` com as URLs
- Extrair o positioning declarado deles: hero headline, sub-headline, "for who" sections
- Analisar padrões repetidos (ex. "todos dizem 'a solução tudo-em-um'")

Se não:
- Saltar para o Passo 3 com a info que tens do operador

### Passo 3 · Análise do buraco

Construir matriz de positioning:

```
                Generic                    Specialized
                |                          |
Tech-heavy  ----+--------------------------+----
                |                          |
                | (concorrente A)          |
                |                          |
Human-heavy ----+--------------------------+----
                |                          |
                | (concorrente B)          | (TU)
                |                          |
```

Identificar: onde é que estão todos? onde há buraco? onde podes tu estar coerentemente com a tua voice + advantage?

### Passo 4 · Gerar 3-5 ângulos

Para cada ângulo:

**Estrutura do ângulo**:
- **Headline statement** (1 frase): "Para [ICP], [a tua marca] é [categoria] que [diferencial], ao contrário de [concorrente genérico]."
- **Porque é que este ângulo funciona**: (2-3 razões baseadas em análise)
- **Riscos deste ângulo**: (o que te encerra, que clientes perdes)
- **Evidência**: o que do operador apoia este ângulo? (a sua experiência, as suas skills, os seus casos)

Exemplo de ângulos para um operador IA freelancer:

**Ângulo 1 — Anti-vende-banha prático**:
> "Para empresários de PME que já provaram IA e se queimaram, sou o operador que monta sistemas que aterram a sério, sem demos espetaculares e com métricas reais de poupança."

**Ângulo 2 — IA + processos, não IA solta**:
> "Para contabilístico/agência que automatiza tarefas mas não processos completos, sou quem entra dentro da operativa e monta agentes que substituem o estagiário que não têm."

**Ângulo 3 — A voz portuguesa do Claude Code**:
> "Para operadores lusófonos que aprendem Claude Code em inglês e se perdem, sou o primeiro recurso completo em português com casos reais de comunidade."

### Passo 5 · Recomendação + decisão do operador

Mostrar os 3-5 ângulos ao operador com análise. Recomendar 1 ou 2 com justificação clara.

Perguntar: "Com qual ficas? Ou queres misturar dois?"

Se o operador não decidir: oferecer fazer um mini teste (escrever 1 LinkedIn post em cada ângulo e ver qual lhe sai mais natural / encaixa melhor com a voz).

### Passo 6 · Gerar `positioning.md`

```markdown
# Positioning — [Marca]

> Gerado: YYYY-MM-DD
> Última revisão: YYYY-MM-DD

## Statement principal

> Para [ICP], [marca] é [categoria] que [diferencial], ao contrário de [alternativa].

## Para quem (ICP numa frase)

[ICP statement compacto. A definição completa está em brand-context/icp/icp.md]

## Categoria

[Em que casa mental queres que te metam: ex. "operador IA freelance especialista em contabilísticos" e não "consultoria de IA"]

## Diferencial

[2-3 coisas concretas, verificáveis, que te distinguem]

1. ...
2. ...
3.

## Alternativas que o teu cliente considera

| Alternativa | Porque não funciona para ele |
|---|---|
| Agência grande de IA | Demasiado cara, demos sem aterrar, não percebe o setor dele |
| Estagiário com ChatGPT | Não escala, não integra com as apps dele, não garante qualidade |
| DIY (fazemos nós) | Sem tempo, sem expertise, não há quem o mantenha |

## O teu unfair advantage

[O que só tu ou muito poucos têm. Pode ser experiência, network, asset, capacidade técnica + comercial juntas, idioma, vertical específico]

## Mensagem em 3 comprimentos

### Long (LinkedIn about, web hero, proposta)
[2-3 frases com o statement + advantage + porquê confiar]

### Mid (X bio, email signature, intro de podcast)
[1 frase com o statement compacto]

### Short (tagline, slug)
["[Categoria] para [ICP-chave]"]

## Riscos do posicionamento escolhido

- Que clientes potenciais perdes com este ângulo? (válido, focalizar tem custo)
- O que acontece se o teu mercado mudar? (plano B)
- O que te encerra?

## Quando rever

- Cada 6 meses (revisão de rotina)
- Quando aparecer concorrente novo que copie o teu ângulo
- Quando o teu mercado se mexer (M&A, regulação, nova tecnologia)
- Quando sentires que a mensagem não ressoa (engagement cai sem causa)
```

### Passo 7 · Cierre

- Guardar `brand-context/positioning/positioning.md`
- Append em `context/learnings.md`:
  ```
  ## marketing-positioning
  - YYYY-MM-DD: ângulo escolhido X. Riscos identificados: Y.
  ```
- Sugerir ao operador re-rever `brand-context/icp/icp.md` (se não encaixar com o novo positioning, há desalinhamento)
- Sugerir atualizar bio/about no LinkedIn/web com a mensagem nos seus 3 comprimentos (não fazer automático — isso é comunicação externa)

## Outputs

- `brand-context/positioning/positioning.md`
- Append a `context/learnings.md`

## Skills que chama

- `tool-firecrawl-scraper` (opcional, passo 2)

## Edge cases

- **Operador não se quer "encerrar"**: explicar que não se posicionar é posicionar-se mal. Se insistir, gerar positioning mais amplo com disclaimer "low differentiation, expect higher CAC".
- **Mercado super saturado**: o ângulo viável costuma ser hyper-niche. Forçar concretar o ICP a um sub-vertical específico.
- **Operador é tech bom mas comm mau**: o positioning correto pode ser "white-label tech para agências", não servir a clientes finais.
- **Operador só é bom numa vertical**: positioning vertical-first ("Operador IA para clínicas dentárias") é legítimo e costuma converter melhor que horizontal.

## Examples

Ver `references/examples.md` para 3 casos completos.
