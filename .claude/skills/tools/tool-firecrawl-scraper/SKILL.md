---
name: tool-firecrawl-scraper
description: Wrapper de Firecrawl API para fazer scraping a páginas web sem bot blockers. Usado por marketing-brand-voice (extrair voice samples + assets), strategy-competitor-monitor (analisar concorrentes), e outras skills que precisem de conteúdo público de URLs. Degradação graceful se não houver API key.
---

# tool-firecrawl-scraper

## Quando se invoca

- `marketing-brand-voice` chama-a para fazer scraping a web/LinkedIn/YouTube do operador
- `strategy-competitor-monitor` chama-a para analisar concorrentes
- Utilizador explicitamente: "faz scraping a esta URL", "tira o texto desta web"

## Process

### Passo 1 · Verificar API key

Lê `.env` (variável `FIRECRAWL_API_KEY`).

- **Se existir** → usar Firecrawl API (https://api.firecrawl.dev/v1/scrape)
- **Se não existir** → degradar para fetch nativo (built-in WebFetch tool de Claude Code) e avisar:
  > "Sem Firecrawl API key. Algumas webs com bot-blockers não poderão ser scraped. Para o ativar, regista-te em https://www.firecrawl.dev (500 créditos grátis) e adiciona FIRECRAWL_API_KEY em .env"

### Passo 2 · Validar input

Input:
```json
{
  "urls": ["https://...", "https://..."],
  "format": "markdown|text|html",
  "extract_assets": true|false,
  "max_depth": 1
}
```

Validações:
- URLs são válidas (regex http(s))
- Não são URLs de ficheiro grande (.zip, .pdf > 50MB)
- Não são URLs de serviços bloqueados por TOS (linkedin.com requer session, etc.)

### Passo 3 · Fazer scraping com Firecrawl

Para cada URL:

```bash
curl -X POST https://api.firecrawl.dev/v1/scrape \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "<URL>",
    "formats": ["markdown", "html"],
    "onlyMainContent": true
  }'
```

Capturar:
- `data.markdown` — texto principal limpo
- `data.html` — HTML completo (se extract_assets: true)
- `data.metadata` — title, description, og:image, etc.

### Passo 4 · Extração de assets visuais (se extract_assets: true)

Do HTML, extrair:
- Logos: `<img>` com classes/alt que contenham "logo", "brand", ou `<link rel="icon">`
- Cores primárias: parse CSS ou extrair de imagens hero (proximidade a brand)
- Fontes: parse CSS `font-family`
- Imagens hero: primeiro `<img>` grande em `<header>` ou `<section class="hero">`

### Passo 5 · Output

**Modo standalone**:
```
projects/tool-firecrawl-scraper/<data>-<dominio>/
├── content.md          # markdown principal
├── metadata.json       # title, description, OG
├── assets/             # se extract_assets
│   ├── logo.<ext>
│   └── hero.<ext>
└── colors.json         # paleta detetada
```

**Modo pipeline**: JSON com tudo o anterior.

### Passo 6 · Fecho

- Se o Firecrawl devolver erro 402 (sem créditos) → avisar o utilizador
- Se erro 429 (rate limit) → tentar de novo após delay 5s, máx 3 vezes
- Se erro 500+ → fallback para WebFetch nativo
- Append em `context/learnings.md` se descobrires URL pattern que falha consistentemente

## Outputs

**Standalone**: ficheiros descritos no Passo 5
**Pipeline**: JSON para o caller

## Skills que chama

Nenhuma. É tool primitiva.

## Edge cases

- **URL devolve 401/403 (login required)**: marcar como não-scrapável. Avisar o utilizador para copiar/colar conteúdo manualmente.
- **JS-heavy SPA com pouco conteúdo server-side**: o Firecrawl lida com isto, mas se falhar, o fallback não funciona. Avisar.
- **YouTube URL**: o Firecrawl não extrai transcripts. Derivar para `tool-youtube-transcript` (skill futura).
- **PDF URL**: passar para `tool-pdf-extractor` (skill futura).
- **Páginas com paywall**: detetar (HTTP 200 mas conteúdo < 100 chars do expected). Marcar e reportar.

## Configuração Firecrawl recomendada

Em `.env`:
```
FIRECRAWL_API_KEY=fc-xxxxx
FIRECRAWL_TIMEOUT=30000      # ms (30s)
FIRECRAWL_MAX_RETRIES=3
```

Plano recomendado: **Free tier (500 créditos one-time)** ou **Hobby ($16/mo, 3000 créditos/mo)**. Para uso intensivo, **Standard ($83/mo)**.

## Examples

```bash
# Operador quer fazer scraping à sua web para brand voice
Input: { "urls": ["https://minhaempresa.com"], "format": "markdown", "extract_assets": true }

# Output:
# projects/tool-firecrawl-scraper/2026-05-07-minhaempresa-com/
#   content.md (4500 words extracted)
#   metadata.json (title, og:image)
#   assets/logo.svg, hero.jpg
#   colors.json ({primary: "#ff6b35", secondary: "#2c3e50"})
```
