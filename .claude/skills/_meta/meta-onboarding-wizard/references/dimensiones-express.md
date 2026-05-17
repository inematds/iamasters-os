# Dimensões · Express (8 críticas)

Esta é a "definição de done" do wizard inicial. Cada dimensão deve ficar capturada com **dado sólido** (não genérica, não "ainda não", não vazia).

---

## Bloco A · Persona

### 1. Identidade básica

**O que tem de ficar capturado:**
- Nome do operador (como prefere ser chamado)
- Frase profissional autodefinida (1 linha, nas suas palavras)

**Exemplo de dado sólido:**
> "Marta Sánchez. Consultora de IA para PME de serviços — automatizo processos sem que a equipa tenha de aprender a programar."

**Sinais de resposta fraca que pedem aprofundamento:**
- "Sou empreendedor" (em quê?)
- "Trabalho com IA" (a fazer o quê com IA?)
- "Ajudo as pessoas" (a quem e com quê?)

### 2. Localização + idioma

**O que tem de ficar capturado:**
- Cidade + país (para timezone e referências culturais)
- Idioma principal de trabalho (inferido se não for dito)

**Exemplo de dado sólido:**
> "Lisboa, Portugal. Trabalho em português principalmente, alguns clientes em inglês."

---

## Bloco B · Negócio

### 3. Negócio principal

**O que tem de ficar capturado:**
- Nome do negócio (se tiver)
- O que faz concretamente (serviço ou produto que vende)
- Vertical / sector se se aplicar

**Exemplo de dado sólido:**
> "Sintaxis Lab. Implemento sistemas de OCR + automação em empresas de logística, transporte e distribuição. Projeto típico: 8 semanas, 14-25K€."

**Sinais de resposta fraca:**
- "Consultoria" (de que tipo?)
- "Vendo formação" (sobre que tema?)
- "É complicado de explicar" (= precisa de aprofundamento com exemplo concreto)

### 4. Modelo de receita

**O que tem de ficar capturado:**
- Como entra o dinheiro (serviços / produtos / subscrições / mix)
- Se tiver várias fontes, distribuição aproximada (não exata)

**Exemplo de dado sólido:**
> "80% projetos pontuais de implementação. 20% manutenção mensal recorrente. Zero formação por agora."

### 5. Cliente ideal

**O que tem de ficar capturado:**
- Sector, dimensão, momento em que chegam
- Algum traço diferenciador (não genérico)

**Exemplo de dado sólido:**
> "Diretor de PME, 50-200 colaboradores, sector tradicional (transporte, distribuição, indústria). Chega quando algum processo manual lhe está a custar horas extra à equipa ou erros caros."

**Sinais de resposta fraca:**
- "Qualquer empresa" (não)
- "B2B" (não é um ICP)
- "Gente que quer automatizar" (que tipo de gente?)

### 6. Stack diário

**O que tem de ficar capturado:**
- As 4-6 ferramentas que usa todos os dias (não a lista exaustiva)
- Menção especial se usa Claude/IA, n8n, CRM concreto

**Exemplo de dado sólido:**
> "Google Workspace, Notion, Cal.com, Stripe, n8n, Claude Code, GitHub."

---

## Bloco D · Foco

### 7. Foco do mês (prioridades)

**O que tem de ficar capturado:**
- 1-3 prioridades concretas do mês em curso
- Se tiver gargalo claro, captura-o também

**Exemplo de dado sólido:**
> "Maio 2026: (1) Fechar projeto com Logística do Norte. (2) Lançar página de serviços renovada. (3) Procurar perfil técnico júnior para apoio. Gargalo: faço todas as propostas comerciais eu, não escalo."

**Sinais de resposta fraca:**
- "Crescer" (em que métrica?)
- "Mais clientes" (quantos? de que tipo?)
- "O do costume" (= não há foco real, vale a pena aprofundar 1 vez)

### 8. Objetivo a 12 meses

**O que tem de ficar capturado:**
- Objetivo concreto a 12 meses (revenue, produto, equipa, o que for)
- Idealmente com número ou marco verificável

**Exemplo de dado sólido:**
> "12 meses: faturar 180K€ (vs 120K atuais), contratar 1 perfil técnico, largar 50% da operativa comercial."

**Sinais de resposta fraca:**
- "Que corra bem" (não é objetivo)
- "Crescer muito" (quanto é muito?)
- "Verei quando chegar" (ok, aí tens a primeira dimensão a aprofundar em deep-dive)

---

## Templates de output

Estes são os headers canónicos para os ficheiros sectorizados. O wizard escreve o conteúdo derivado da conversa lá dentro.

### `context/me.md`

```markdown
# Me · <Nombre>

## Identidad
- **Nombre**: <nombre>
- **Ubicación**: <ciudad, país>
- **Timezone**: <calculado>
- **Idioma principal**: <castellano | inglés | otro>
- **Idioma con clientes**: <si distinto>

## Cómo me describo profesionalmente
> <frase autodefinida del operador>

## Cómo quiero que Claude me hable
(Se profundiza en deep-dive · Bloque A.9 / A.10)

---
*Última actualización: <fecha>*
```

### `context/work.md`

```markdown
# Work · <Negocio>

## Qué hago
> <descripción del negocio principal>

## Cómo gano dinero
<bullets si hay varios streams>

## Cliente ideal (ICP inicial)
> <descripción>
> 
> *Se refinará con `marketing-icp` y `meta-deep-dive` (Bloque B.8)*

## Stack actual
<lista o tabla>

## Negocios / proyectos paralelos
(se profundiza en deep-dive · Bloque B.9)

---
*Última actualización: <fecha>*
```

### `context/current-priorities.md`

```markdown
# Current priorities

> Este ficheiro muda mensalmente. Edita-o quando o teu foco mudar.

## Foco do mês (<mês ano>)

1. <prioridade 1>
2. <prioridade 2>
3. <prioridad 3>

## Cuello de botella actual

> <respuesta si la dio · si no, "(por capturar en deep-dive)">

## Decisiones abiertas

(se profundiza con `decisions-log` y `meta-deep-dive` D.3)

---
*Última actualización: <fecha>*
```

### `context/goals.md`

```markdown
# Goals

## Objetivo 12 meses

> <objetivo capturado>

## Meta a 3 años

(se profundiza en deep-dive · Bloque D.4)

## Meta personal a 3 años (no profesional)

(se profundiza en deep-dive · Bloque D.5)

## Métrica que miras semanalmente

(se profundiza en deep-dive · Bloque D.7)

## Definición personal de éxito

(se profundiza en deep-dive · Bloque D.8)

---
*Última actualización: <fecha>*
```
