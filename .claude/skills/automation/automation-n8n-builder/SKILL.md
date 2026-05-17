---
name: automation-n8n-builder
description: Cria, valida e faz deploy de workflows de n8n a partir do Claude Code usando o MCP n8n-mcp. Usa-a quando o utilizador disser "cria um workflow em n8n", "monta um n8n que faça X", "converte esta ideia em automação", "desenha um fluxo n8n", ou descrever uma sequência de passos automatizáveis (receber webhook → processar → enviar para Slack, scheduler diário que lê de Google Sheets, etc.). Ativável também com frases como "automação", "n8n", "workflow", "trigger". NÃO uses esta skill para migrar workflows existentes de n8n para Claude — para isso usa automation-n8n-to-claude.
author: IA Masters Academy
version: 1.0.0
tags: [n8n, mcp, automacao, workflow, builder, claude-code]
---

# automation-n8n-builder — Construtor de workflows n8n a partir do Claude

> Esta skill converte uma descrição em linguagem natural ("quero que quando chegar um lead por formulário o meta em Sheets e avise por Slack") num workflow n8n funcional, validado e em deploy.

---

## Pré-requisitos

1. **MCP `n8n-mcp` instalado e configurado** em `.mcp.json` do repo ou em `~/.claude/.mcp.json`.
   Se não o tiver, sugerir ao utilizador: `/install-mcp n8n-mcp`.
2. **Acesso a uma instância n8n** (self-hosted ou cloud) com API key na variável de ambiente `N8N_API_KEY` e `N8N_BASE_URL`.
3. **Permissões**: o MCP requer que o operador possa criar/editar/fazer deploy de workflows.

Se faltar qualquer um dos três, a skill explica ao utilizador o que falta antes de continuar.

---

## Fluxo de trabalho

### Passo 1 · Perceber o caso de uso

Antes de tocar no n8n, fazer 3-5 perguntas para clarificar:

- Qual é o **trigger**? (webhook, schedule, evento de app, manual…)
- Que **fontes de dados** intervêm? (Google Sheets, Notion, base de dados, API…)
- Que **transformações** são necessárias? (filtrar, enriquecer, formatar…)
- Qual é o **destino**? (Slack, email, Notion, outra app…)
- Há **tratamento de erros** necessário? (reintentos, notificações de falha…)

Se a ideia for vaga, propor 2-3 versões concretas e deixar o utilizador escolher.

### Passo 2 · Design visual do fluxo

Antes de pedir nada ao MCP, mostrar ao utilizador um **diagrama em texto** do workflow proposto:

```
[Webhook: form-submission]
    ↓
[Filter: se email contiver @empresa.com]
    ↓
[Sheets: append row com {nome, email, fonte, data}]
    ↓
[Slack: notify #leads com "Novo lead: {nome}"]
    ↓
[Error branch: se Slack falhar, email para admin]
```

Pedir confirmação ao utilizador antes de construir.

### Passo 3 · Construir via MCP

Usar as ferramentas do MCP `n8n-mcp`:

- `search_nodes` para encontrar nodes relevantes
- `get_node` para inspecionar parâmetros de um node concreto
- `n8n_create_workflow` para criar o workflow vazio
- `n8n_update_partial_workflow` para adicionar nodes um a um com as suas ligações
- `n8n_validate_workflow` para verificar que o grafo é válido

Construir o workflow incrementalmente, não de uma vez. Após cada node adicionado, mostrar progresso ao utilizador.

### Passo 4 · Validar antes de fazer deploy

Executar `n8n_validate_workflow` e rever:

- Todos os nodes têm credenciais atribuídas (ou aviso se faltarem)
- As ligações entre nodes são coerentes
- As expressions (`{{$json.field}}`) referenciam campos que existem
- O trigger está configurado corretamente

Se houver erros → mostrá-los ao utilizador, propor fixes, não fazer deploy ainda.

### Passo 5 · Teste em modo prova

Antes de ativar:

- `n8n_test_workflow` com um payload de exemplo
- Mostrar ao utilizador o resultado de cada node
- Se algum node falhar, propor fix ou ajustar o design

### Passo 6 · Ativar e entregar

Uma vez validado:

- Ativar o workflow (`active: true`)
- Devolver ao utilizador:
  - URL do workflow no n8n
  - Resumo do que faz e quando dispara
  - Como monitorizar as execuções (`n8n_executions`)
  - Sugestão de melhorias futuras (logs, alertas, etc.)

---

## Padrões comuns

### Padrão 1 — Webhook → Processar → Notificar

Para captação de leads, formulários, integrações de CRM ligeiras.

Nodes-chave: `Webhook` (trigger) → `Code` / `Set` (transformar) → `Slack` / `Email` (notificar) → `Respond to Webhook` (200 OK).

### Padrão 2 — Schedule → Ler → Reportar

Para relatórios diários/semanais, lembretes, backups.

Nodes-chave: `Schedule Trigger` → `HTTP Request` / `Database` (ler dados) → `Code` (formatar) → `Slack` / `Email` (entregar).

### Padrão 3 — Evento de app → Enriquecer → Persistir

Para manter bases de dados em sync, enriquecer leads com dados externos.

Nodes-chave: `Trigger de app` (Notion, Airtable, etc.) → `HTTP Request` (Clearbit, BORME, etc.) → `Set` (compor) → `Sheets` / `Postgres` (escrever).

### Padrão 4 — Multi-canal com fallback

Para mensagens críticas que NÃO podem falhar.

Nodes-chave: `IF` (ramo principal) → `Try` (canal A: Slack) → `On error` (canal B: email) → `On error` (canal C: WhatsApp).

---

## Coordenação com outras skills

- **Se o utilizador já tem um workflow no n8n e quer migrar para Claude** → usar `automation-n8n-to-claude` em vez desta.
- **Se o utilizador descreve a automação em termos de marketing** (envios massivos, sequências) → recomendar primeiro `marketing-email-sequence` para desenhar a sequência, depois esta skill para a construir no n8n.
- **Se a automação requer scraping** → combinar com `tool-firecrawl-scraper` antes de a meter no n8n (pode fazer sentido fazer tudo em Claude em vez de n8n).

---

## Quando NÃO usar n8n

Antes de construir o workflow, avaliar honestamente se **n8n é a ferramenta adequada**. Casos em que convém colocar alternativa:

- **O utilizador quer "uma skill que faça X todos os dias"** → melhor um cron job + skill Claude direta (mais simples, não requer infra n8n).
- **O fluxo é 100% texto** (resumir, reescrever, traduzir) → o Claude fá-lo de forma nativa, não precisa de orquestrador.
- **O utilizador só quer ligar 2 SaaS conhecidos** (Sheets ↔ Slack) → Zapier ou Make podem ser mais rápidos de configurar.

Dizer honestamente *"isto pode-se montar em n8n, mas recomendaria X porque…"* faz parte do trabalho da skill. Não empurrar n8n por inércia.

---

## Output esperado

Ao fechar:

- Workflow n8n com deploy e ativo
- Documentação mínima do workflow em `projects/automations/<data>-<nome>/README.md` com:
  - Diagrama do fluxo
  - Trigger e schedule (se aplicar)
  - Credenciais que requer
  - Como o testar
  - Como monitorizar
