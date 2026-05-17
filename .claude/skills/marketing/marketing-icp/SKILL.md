---
name: marketing-icp
description: Define o Ideal Customer Profile em detalhe: dor exata, linguagem que usa, buying triggers, anti-ICP. Combina interview com análise de concorrentes (que clientes têm) e de testemunhos reais do operador. Output para brand-context/icp/icp.md. É invocada depois de positioning ou quando o operador não sabe a quem vender.
---

# marketing-icp

## Quando é invocada

- Depois de `marketing-positioning` (positioning sem ICP claro = fumo)
- Operador diz: "não sei a quem vender", "o meu cliente atual não é ideal"
- Antes de qualquer campanha paid (sem ICP não segmentas)
- Quando vais escrever copy de landing/email e precisas de precisão

## Process

### Passo 1 · Recolher inputs

Lê `brand-context/positioning/positioning.md` (se existir).

Pergunta ao operador (6 perguntas):

1. **Tens 3-5 clientes atuais ou passados que sejam "bons"?** (clientes que pagaram sem regatear, recomendaram, repetiram). Dá-me nome, setor, dimensão e porque é que os consideras bons.

2. **Tens 1-3 clientes que sejam "maus"?** (que se queixaram muito, não pagaram, fizeram churn em 30 dias, te sugaram tempo). Dá-me nome, setor e porque é que falharam.

3. **Como é que os bons te encontraram?** (Instagram, recomendação, pesquisa, evento, frio...)

4. **Que dor concreta tinham quando te contactaram?** (não "queriam mais eficiência" mas "estavam a perder 20h/semana em X")

5. **Que objeção tiveram antes de comprar?** (preço, risco, "já tentei antes", confiança, timing)

6. **O que é que os teus melhores clientes querem que NÃO lhes dás?** (limites do teu serviço atual)

### Passo 2 · Análise de padrões

Cruzar as respostas:

**Padrões positivos** (o que têm em comum os bons clientes):
- Setor / indústria
- Dimensão (revenue, headcount)
- Maturidade digital
- Quem decide (rol do comprador)
- Como te encontraram (canal de aquisição que se repete)
- Dor partilhada (não genérica)
- Linguagem que usam ao descrever o problema

**Padrões negativos** (o que têm os maus):
- Procuram algo distinto do que ofereces?
- Não têm a dor a sério (deveriam tê-la segundo vendor)?
- Esperam magia / sem trabalhar?
- Não têm budget real?
- Tomam decisões por comité / muito lento?

### Passo 3 · Construir ICP detalhado

```markdown
# ICP — [Marca]

> Gerado: YYYY-MM-DD

## Demográfico / Firmográfico

- **Setor**: [específico, ex. "contabilísticos e gabinetes fiscais com 3-15 colaboradores"]
- **Dimensão**: [revenue range, ex. "150K-1.5M EUR/ano"]
- **Headcount**: [intervalo, ex. "2-15 pessoas"]
- **Geografia**: [Portugal + Espanha + LATAM, ou mais específico]
- **Maturidade digital**: [baixo / médio / alto. Mais útil se for específico: "já usam algum SaaS, não são anti-tech, mas não têm IT in-house"]

## Quem decide

- **Rol do comprador**: [Founder / CEO / Office Manager / IT / ...]
- **Quem veta**: [se há aprovação de sócio ou partner]
- **Tempo médio de decisão**: [2 semanas / 2 meses / 6 meses]

## Dor concreta (na SUA linguagem, não na tua)

> "Citação textual de como o descrevem quando te ligam"

Sintomas observáveis (não abstratos):
- "Perdem X horas/semana em Y"
- "Têm N pessoas a fazer tarefas que um agente podia fazer"
- "Os clientes esperam respostas de 2 dias, agora demoram 5"

Custo real da dor (€):
- Perda direta: [tempo faturável perdido]
- Custo de oportunidade: [projetos não atendidos]
- Custo reputacional: [clientes que fazem churn por mau serviço]

## Buying triggers

Que evento os faz passar de "devíamos fazer algo" a "preciso de falar com alguém JÁ"?

- Perdem cliente importante por falta de capacidade
- Colaborador-chave pede aumento ou vai-se embora
- Cliente top diz-lhes "ou automatizam ou eu vou-me"
- Lançam produto/serviço novo e a equipa não escala
- Auditoria / regulação nova (RGPD, IA Act, etc.)

## Linguagem que usam

Palavras DO seu mundo (usa-as no teu copy):
- ...

Palavras proibidas (não as usam, não as percebem, desconfiam delas):
- "agéntico", "agente conversacional", "LLM", "RAG"
- "stack", "deploy", "API", "webhook" (a menos que sejam técnicos)

## Objeções típicas + resposta

| Objeção | Resposta breve |
|---|---|
| "É muito caro" | Custo vs ROI: a dor custa X€/mês, isto amortiza-se em N meses |
| "Já tentámos com [outro]" | Pergunta o que falhou. Provavelmente falhou sem a tua abordagem. |
| "Não temos tempo para o implementar" | Por isso o teu serviço inclui implementação, não é "deixo-te a ferramenta" |
| "E se a IA falhar?" | Mostrar controlo humano, validação antes de ações, opção de off |
| "Não sei se servirá para o nosso caso" | Pré-análise gratuita de 30 min para confirmar fit |

## Canais onde estão

Onde é que consome conteúdo / procura soluções?

- LinkedIn: ativo? que grupos segue?
- YouTube: que canais do setor?
- Newsletter / podcasts do setor
- Eventos: quais frequenta
- Pesquisa Google: keywords que prova ("automatizar [o seu setor]", "poupar tempo [a sua tarefa]")

## Anti-ICP

Cliente que parece bom mas NÃO deves aceitar:
- Sintoma 1
- Sintoma 2
- Sintoma 3

Razões para dizer NÃO:
- ...

## Customer Journey

1. **Awareness**: como é que ficam a saber que isto existe? (LinkedIn de Angel, recomendação, evento)
2. **Consideration**: o que procuram / leem para avaliar? (case studies, demos, conversa)
3. **Decision**: o que fecha o deal? (chamada com caso real semelhante, prova gratuita acotada, contrato curto inicial)
4. **Onboarding**: como arranca o projeto?
5. **Expansion**: que upsells aceitam depois?

## Validação

Frases para validar este ICP na próxima chamada:
- "Perdes à volta de [X horas/semana] em [Y tarefa]?"
- "Se pudesses ter [Z resolvido] pouparias [N€/mês]?"
- "Já tentaste antes com [tipo de solução]? O que falhou?"

Se a pessoa responder "não" ou "mais ou menos" a 2+ perguntas → não é ICP, é prospect morno.

## Quando rever este ICP

- Cada 3 meses com dados novos (10+ clientes novos)
- Quando mudares o positioning
- Quando entrares em vertical novo
- Quando observares drift (fechas a clientes muito diferentes do descrito)
```

### Passo 4 · Validação cruzada

Pergunta ao operador:
- "Olha para a secção 'Linguagem que usam'. Reconheces estas palavras das tuas chamadas?"
- "Olha para 'Buying triggers'. Qual destes viste em pelo menos 2 clientes?"
- "Olha para 'Anti-ICP'. Há algum sintoma que não tenha incluído e devesse?"

Refinar até o operador dizer "sim, é exatamente assim".

### Passo 5 · Cierre

- Guardar `brand-context/icp/icp.md`
- Append em `context/learnings.md`
- Sugerir atualizar copy de landing / email sequences / bio com a linguagem do ICP detetada

## Outputs

- `brand-context/icp/icp.md`
- Append a `context/learnings.md`

## Skills que chama

Nenhuma. É introspetiva + análise de dados do operador.

(Opcional: se o operador mencionar muitos clientes, podia chamar `tool-firecrawl-scraper` para enriquecer dados de cada cliente a partir das suas webs).

## Edge cases

- **Operador ainda não tem clientes (pre-revenue)**: ICP é hipotético. Marcar `confidence: low` e planear validação com 5 entrevistas a prospects em 30 dias.
- **Operador tem 100+ clientes muito variados**: segmentar em 2-3 ICPs distintos em vez de forçar 1.
- **Cliente "bom" não corresponde ao perfil do positioning**: investigar porquê. Pode ser que o positioning esteja mal ou que o cliente seja outlier.

## Examples

Ver `references/examples.md` para 2 ICPs completos:
1. Operador IA freelance serviço a contabilísticos portugueses
2. Agência de marketing especializada em formadores online
