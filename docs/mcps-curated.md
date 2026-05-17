# MCPs curados para iAmasters OS

> Lista validada de Model Context Protocol servers úteis para operadores IA.
> Cada entrada inclui: para que serve, quando usar, instalação, risco de tokens, alternativas.
>
> Última revisão: 2026-05-07

## Como usar

```
/install-mcp <name>
```

Ou manualmente: copia a config para `.mcp.json` e preenche variáveis de ambiente em `.env`.

---

## ⭐ Top 5 recomendados (instalar sempre)

### 1. context7 · Docs vivos para LLMs

**Para que**: quando constróis com um framework/lib (Next.js, Supabase, Tailwind, etc.), o Context7 injeta a documentação oficial atualizada no contexto. Evita que o Claude alucine APIs obsoletas.

**Quando ativar**: em qualquer sessão onde escrevas código com frameworks.

**Risco de tokens**: médio-alto se usares em CADA prompt. Melhor: invocá-lo explicitamente com "usa context7 para [tema]".

**Plano**: grátis, não requer API key.

**Config**:
```json
"context7": {
  "command": "npx",
  "args": ["-y", "@upstash/context7-mcp"],
  "env": {}
}
```

**Variáveis**: nenhuma.

---

### 2. github · Operações git e repos

**Para que**: ler issues, PRs, ficheiros de qualquer repo público ou teu. Criar/comentar issues, mergear PRs.

**Quando ativar**: se trabalhas com vários repos e queres que o Claude possa atuar sobre eles sem `gh` CLI.

**Risco de tokens**: baixo. Só invoca tools quando pedes.

**Plano**: grátis (Personal Access Token).

**Config**:
```json
"github": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_TOKEN"
  }
}
```

**Variáveis**: `GITHUB_TOKEN` (PAT com scopes: repo, read:user).

**Alternativa**: usar `gh` CLI desde Bash diretamente. Mais simples se só precisas de comandos pontuais.

---

### 3. supabase · A tua base de dados

**Para que**: queries SQL, gestão de tabelas, RLS, edge functions, storage. Operador do projeto Supabase a partir do Claude.

**Quando ativar**: se tens apps no Supabase (self-hosted ou cloud) e constróis com Claude Code.

**Risco de tokens**: baixo se configurares RLS corretamente.

**Plano**: grátis (OSS) + plano Supabase do teu projeto.

**Config**:
```json
"supabase": {
  "command": "npx",
  "args": ["-y", "@supabase/mcp-server-supabase@latest", "--project-ref=$SUPABASE_PROJECT_REF"],
  "env": {
    "SUPABASE_ACCESS_TOKEN": "$SUPABASE_ACCESS_TOKEN"
  }
}
```

**Variáveis**:
- `SUPABASE_PROJECT_REF` — o ref do projeto (no URL do dashboard)
- `SUPABASE_ACCESS_TOKEN` — token de acesso desde Account → Access Tokens

**⚠️ Importante**: usa READ-ONLY token para começar. Só eleva permissões quando confiares no fluxo.

---

### 4. notion · Se trabalhas no Notion

**Para que**: ler páginas, criar bases de dados, mover páginas, criar comentários. Se o teu wiki/CRM/sistema de tarefas está no Notion.

**Quando ativar**: se usas o Notion como home-base operativo.

**Risco de tokens**: médio (o Notion devolve estruturas grandes).

**Plano**: grátis até certo uso (Notion Connect API).

**Config**:
```json
"notion": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-notion"],
  "env": {
    "NOTION_API_KEY": "$NOTION_API_KEY"
  }
}
```

**Variáveis**: `NOTION_API_KEY` (Internal Integration Token desde notion.so/my-integrations).

**⚠️ Importante**: só dá acesso às páginas que a integration partilhar. Não dá acesso a todo o workspace por defeito.

---

### 5. firecrawl · Scraping de sites

**Para que**: fazer scraping de sites com bot blockers (melhor que WebFetch nativo). Usado por `tool-firecrawl-scraper` e outras skills.

**Quando ativar**: se fazes pesquisa competitiva, brand-voice extraction, ou qualquer scraping.

**Risco de tokens**: baixo (devolve só conteúdo principal).

**Plano**: 500 créditos free one-time. Hobby $16/mo, 3000 créditos.

**Config**: este MCP NÃO se invoca como MCP server do Claude Code, mas como API direta desde skills. Não vai em `.mcp.json`. Configuração só em `.env`:

```bash
FIRECRAWL_API_KEY=fc-xxxxx
```

---

## 🔧 Úteis para casos específicos

### linear · Gestão de projetos

**Para que**: se usas o Linear para issue tracking em vez do GitHub Issues.
**Plano**: grátis até certo uso.
**Config**: `@modelcontextprotocol/server-linear`

### gmail · Leitura de emails

**Para que**: ler/procurar emails, criar drafts. NÃO enviar (isso requer user explicit ok).
**Plano**: grátis com Google Workspace.
**Config**: requer OAuth setup mais complexo.
**Risco**: alto se deres write permissions. Mantém READ-ONLY até confiar.

### slack · Mensagens internas

**Para que**: ler canais, criar posts, threads. Útil para equipas pequenas.
**Plano**: grátis.
**Config**: `@modelcontextprotocol/server-slack`
**⚠️**: mesma regra que email — read-only até confiar.

### filesystem · Acesso ao sistema de ficheiros local

**Para que**: explorar pastas fora do repo atual de forma controlada.
**Quando ativar**: só se precisares que o Claude vá para outra pasta sem abrir nova sessão.
**Config**: `@modelcontextprotocol/server-filesystem` com paths whitelisted.
**⚠️**: risco de segurança. Whitelist específica obrigatória.

---

## ⚠️ MCPs a evitar (em produção)

### Qualquer MCP que dê write a redes sociais sem gates

LinkedIn, Twitter, Instagram, Facebook auto-post: **alto risco de fuga de identidade**. Melhor: skill que prepara o draft e operador faz post manualmente.

### MCPs que não documentam claramente os seus scopes

Se a documentação não especifica que permissões pede e o que faz, não instalar.

### MCPs custom de developers desconhecidos

`/install-mcp custom <url>` só se confiares no dev ou validares o código manualmente.

---

## Pattern para a tua própria curated list de MCPs

Se trabalhas com clientes que têm stacks específicos, mantém o teu próprio `mcps-curated.md` por cliente em `clients/<nome>/docs/mcps-curated.md`.

Estrutura recomendada por entrada:
1. Nome + tagline
2. Para que serve (1-2 frases)
3. Quando ativar (caso de uso)
4. Risco de tokens (baixo/médio/alto)
5. Plano / custo
6. Config (`.mcp.json` snippet)
7. Variáveis (`.env`)
8. ⚠️ Notas de segurança se aplicável

---

## Token budget consideration

Cada MCP server ativo no `.mcp.json` adiciona contexto ao system prompt ao iniciar Claude Code (as descrições das suas tools). Mais MCPs = mais tokens base.

**Regra prática**: 5-7 MCPs ativos máximo. Se precisares mais, considera comentar os que não usas frequentemente.

**Pro tip**: ter um `.mcp.json` por cliente (em `clients/<nome>/.mcp.json` se o Claude Code suportar) ou mudar `.mcp.json` antes de cada sessão conforme necessidade.

---

## Como adicionar novos MCPs a esta lista

Para incluir um MCP na curated list (PR ao repo):

1. Testar o MCP em produção mínimo 2 semanas
2. Documentar:
   - Casos onde acrescenta valor real
   - Casos onde NÃO acrescenta (ou é contraproducente)
   - Riscos identificados
3. Submit PR com a entrada nova seguindo o formato do top 5

As contribuições devem vir com experiência real, não "instalei e parece OK".
