---
description: Instala MCP server em .mcp.json do projeto desde a lista curada ou URL custom. Configura permissões e env vars.
---

# /install-mcp

Instala um MCP server (Model Context Protocol) neste projeto.

## Uso

### Modo 1 · Desde lista curada (recomendado)
```
/install-mcp <name>
```

Exemplos:
- `/install-mcp context7`
- `/install-mcp supabase`
- `/install-mcp github`

Lista completa: ver `docs/mcps-curated.md`.

### Modo 2 · MCP custom desde URL
```
/install-mcp custom <github-url>
```

## Process

### Passo 1 · Validar input

Se o nome está na lista curada (`docs/mcps-curated.md`):
- Carregar a configuração recomendada
- Verificar prerequisitos (env vars necessárias, plano API)

Se é URL custom:
- Avisar o utilizador sobre risco (não validado pela iAmasters)
- Pedir confirmação
- Inspecionar repo para detetar package.json ou setup.json do MCP

### Passo 2 · Verificar `.mcp.json`

```bash
cat .mcp.json 2>/dev/null
```

Se não existe → criar novo
Se existe → ler para detetar conflitos (mesmo MCP já instalado)

### Passo 3 · Configurar entrada

Estrutura típica de `.mcp.json`:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {}
    },
    "supabase": {
      "command": "npx",
      "args": ["-y", "@supabase/mcp-server-supabase@latest", "--project-ref=$SUPABASE_PROJECT_REF"],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "$SUPABASE_ACCESS_TOKEN"
      }
    }
  }
}
```

### Passo 4 · Verificar variáveis de ambiente

Se o MCP requer `$VARS`:
- Verificar `.env` (sem commitar)
- Se faltam vars → perguntar ao operador ou derivar para o doc do MCP

### Passo 5 · Permissões

Alguns MCPs requerem permissões extra em `.claude/settings.json`. Verificar:
- Precisa acesso ao sistema de ficheiros? → adicionar `Read` patterns
- Faz API calls de saída? → rever deny list do Bash

### Passo 6 · Test

Após instalar:
- Reiniciar o Claude Code (Ctrl+C × 2 + claude)
- Testar o MCP com prompt simples ("usa o MCP de [nome] para...")
- Se ativa corretamente: confirmar
- Se não: rever logs e derivar para os docs do MCP

### Passo 7 · Documentar

- Append em `context/learnings.md` debaixo de `## install-mcp`:
  ```
  - YYYY-MM-DD: instalado MCP <name> para <caso>
  ```
- Atualizar `CLAUDE.md` a mencionar MCP ativo (secção "Apps externas ligadas")

## Edge cases

- **MCP requer instalação global de um pacote npm**: avisar o operador, dar comando `npm install -g`, NÃO executar automaticamente
- **MCP muda a API**: a lista curada atualiza-se com o repo. `git pull` para latest config
- **MCP custom não validado**: marcar em `.mcp.json` com comentário `_unverified: true`
- **MCP causa loop infinito ou timeout**: removê-lo de `.mcp.json` e reportar issue

## Implementação

Este comando é interpretativo. Lê `docs/mcps-curated.md` e aplica a configuração recomendada do MCP escolhido. Se não está na lista curada, deriva para o instalador genérico com warnings.
