---
name: tool-visual-explainer
description: Gera páginas HTML autocontidas e bonitas que explicam visualmente sistemas, código, planos, dados ou análises. Usa-o quando precisares de partilhar um output complexo (diagrama, comparativo, recap de projeto, plan review, tabela longa) ou quando outra skill (welcome-quick-win, six-hats, marketing-positioning) feche com material que o utilizador vai querer partilhar por WhatsApp/Skool/email. Output: HTML5 sem dependências externas, mobile-first, paleta sóbria com acento laranja iAmasters.
---

# tool-visual-explainer

> Inspirado na skill `visual-explainer` da suite Anthropic + comunidade. Adaptada ao padrão iAmasters OS com paleta e branding do repo.

## Quando se invoca

- Outra skill fecha com uma análise ou entregável que o utilizador vai querer partilhar
- O utilizador pede "faz-me um HTML disto", "põe isto bonito para partilhar", "exporta isto"
- O utilizador vai apresentar o output a outra pessoa (cliente, sócio, conselheiro, comunidade)
- Tabelas longas (4+ linhas, 3+ colunas) — melhor em HTML do que ASCII

NÃO se invoca:
- Para outputs internos que só o Claude lê (seria gasto inútil)
- Quando o utilizador já está numa ferramenta visual (Notion, Figma, etc.)
- Para outputs <200 palavras onde markdown plano chega

## Process

### Passo 1 · Receber input

A skill recebe (de outra skill ou do utilizador diretamente):

- **Título** do documento
- **Blocos de conteúdo**: cada bloco tem tipo (`hero`, `text`, `table`, `list`, `quote`, `metric-card`, `image`, `code`, `cta`)
- **Metadados opcionais**: data, autor, versão, branding sim/não
- **Destino do ficheiro**: path relativo ao repo (default `projects/visual/<YYYY-MM-DD>-<titulo>.html`)

Se a skill for invocada a partir de outra (ex. `welcome-quick-win`), esses campos vêm pré-preenchidos.

Se a invocar o utilizador diretamente, pergunta o mínimo:

```
O que queres converter em HTML partilhável?
  • Cola o conteúdo (markdown serve)
  • Ou diz-me que ficheiro/conversa processamos
```

### Passo 2 · Validar conteúdo

Antes de gerar:

- Sem código JS embutido — o HTML deve funcionar em qualquer viewer (WhatsApp, email, Telegram que NÃO executam JS)
- Sem dependências CDN externas — tudo inline (CSS embutido, fontes system)
- Sem imagens hospedadas em URL externa exceto se o utilizador o pedir explicitamente — preferir SVG inline ou emojis Unicode
- Verificar que nenhum bloco tem conteúdo > 5KB (se houver um texto enorme, sugerir resumi-lo)

### Passo 3 · Gerar HTML

Usa este esqueleto base. É deliberadamente simples — não compitas com websites, **prioriza legibilidade e portabilidade**.

```html
<!DOCTYPE html>
<html lang="pt">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ title }}</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      line-height: 1.6;
      color: #1a1a1a;
      background: #fafafa;
      padding: 24px 16px;
    }
    .container {
      max-width: 720px;
      margin: 0 auto;
      background: white;
      border-radius: 12px;
      padding: 32px 24px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    }
    .hero {
      border-bottom: 2px solid #ff8c42;
      padding-bottom: 16px;
      margin-bottom: 24px;
    }
    .hero h1 { font-size: 28px; color: #1a1a1a; margin-bottom: 8px; }
    .hero .meta { color: #666; font-size: 14px; }
    h2 {
      font-size: 20px;
      color: #1a1a1a;
      margin-top: 32px;
      margin-bottom: 12px;
      border-left: 4px solid #ff8c42;
      padding-left: 12px;
    }
    h3 { font-size: 16px; margin-top: 20px; margin-bottom: 8px; color: #333; }
    p { margin-bottom: 12px; }
    ul, ol { padding-left: 24px; margin-bottom: 16px; }
    li { margin-bottom: 6px; }
    blockquote {
      border-left: 4px solid #b794f4;
      background: #faf5ff;
      padding: 12px 16px;
      margin: 16px 0;
      border-radius: 4px;
      color: #4a4a4a;
      font-style: italic;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin: 16px 0;
      font-size: 14px;
    }
    th, td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #e0e0e0; }
    th { background: #f5f5f5; font-weight: 600; color: #333; }
    tr:hover { background: #fafafa; }
    .metric-card {
      background: #fff7ed;
      border: 1px solid #fed7aa;
      border-radius: 8px;
      padding: 16px;
      margin: 12px 0;
    }
    .metric-card .label { font-size: 13px; color: #666; }
    .metric-card .value { font-size: 24px; font-weight: bold; color: #ff8c42; }
    pre, code {
      font-family: "SF Mono", Monaco, Consolas, monospace;
      background: #f5f5f5;
      padding: 2px 6px;
      border-radius: 3px;
      font-size: 13px;
    }
    pre { padding: 12px; overflow-x: auto; }
    .cta {
      background: linear-gradient(135deg, #ff8c42, #ffa66f);
      color: white;
      padding: 16px 20px;
      border-radius: 8px;
      margin: 20px 0;
      text-align: center;
      font-weight: 600;
    }
    .cta a { color: white; text-decoration: underline; }
    footer {
      margin-top: 32px;
      padding-top: 16px;
      border-top: 1px solid #e0e0e0;
      color: #888;
      font-size: 12px;
      text-align: center;
    }
    @media (max-width: 640px) {
      body { padding: 12px 8px; }
      .container { padding: 20px 16px; border-radius: 8px; }
      .hero h1 { font-size: 22px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <header class="hero">
      <h1>{{ title }}</h1>
      <div class="meta">{{ subtitle }} · {{ date }}</div>
    </header>

    <!-- Renderiza cada bloco conforme o seu tipo -->
    {{ blocks }}

    <footer>
      Gerado por iAmasters OS · <a href="https://iamastersacademy.com">iamastersacademy.com</a>
    </footer>
  </div>
</body>
</html>
```

### Passo 4 · Renderizar blocos

Para cada bloco do input, usa estes templates:

| Tipo | HTML |
|---|---|
| `text` | `<h2>{title}</h2><p>{body}</p>` |
| `list` | `<h2>{title}</h2><ul>{items as <li>}</ul>` (ou `<ol>` se for numerada) |
| `table` | `<h2>{title}</h2><table>{thead + tbody}</table>` |
| `quote` | `<blockquote>{body}</blockquote>` |
| `metric-card` | `<div class="metric-card"><div class="label">{label}</div><div class="value">{value}</div></div>` |
| `code` | `<h2>{title}</h2><pre><code>{body}</code></pre>` |
| `cta` | `<div class="cta">{body}</div>` |
| `image` | `<img src="{src}" alt="{alt}" style="max-width:100%;border-radius:6px;">` (preferir SVG inline) |

### Passo 5 · Guardar e reportar

Guarda no path indicado (default `projects/visual/<YYYY-MM-DD>-<titulo>.html`).

Mensagem para o utilizador:

```
✓ HTML gerado: projects/visual/<ficheiro>.html

Tamanho: <X KB>

Para partilhar:
  • Duplo-clique para abrir no browser e verificar
  • Anexar a WhatsApp/Telegram/email funciona direto
  • Se o subires para um servidor web, vai sem tocar (HTML+CSS inline)
```

### Passo 6 · Fecho e aprendizagem

Se o utilizador reportar que o HTML ficou mal (cores, layout, elementos partidos), append em `context/learnings.md` sob `## tool-visual-explainer`:

```
- <data>: feedback do utilizador sobre [aspeto]. Próxima vez: [ajuste].
```

## Outputs

- Ficheiro HTML autocontido em `projects/visual/<YYYY-MM-DD>-<titulo>.html` (ou path indicado)
- Mensagem para o utilizador com tamanho + instruções de partilha

## Skills que chama

Nenhuma diretamente. Esta skill é **invocada por** outras (`welcome-quick-win`, `six-hats`, `marketing-positioning`, `marketing-content-repurposing`, etc.) quando essas precisam de um output partilhável.

## Edge cases

- **Conteúdo > 100KB**: dividir em múltiplos HTMLs (um por secção) ou sugerir resumo.
- **Tabela com >20 linhas**: adicionar scroll horizontal + considerar paginação visual.
- **Idioma do conteúdo diferente de português**: respeita o idioma do input. O framework HTML (footer, meta) mantém-se em português exceto se for feito override.
- **Utilizador quer paleta diferente do laranja iAmasters**: aceitar override no input (`brand_color: "#XYZ"`). Default mantém paleta do OS.
- **HTML para email**: muitos clientes de email partem estilos. Se o destino for email, simplificar (poucas cores, sem gradient no CTA, tipografia standard) e avisar o utilizador.

## Notas de design

- **Mobile-first**: o HTML é mais visto em móveis (partilhado por WhatsApp) do que em desktop. Testar legibilidade em ecrã 360px de largura.
- **Sem JS**: as aplicações de mensagens NÃO executam JS. Se precisares de interatividade (toggle, accordion), usa `<details>` e `<summary>` (HTML semântico, funciona sem JS).
- **Paleta iAmasters**: laranja `#ff8c42` (acento principal), roxo `#b794f4` (citações/secundário), cinzento `#fafafa` (fundo). Coerente com os badges do README.
- **Sem tracking**: não embutir Google Analytics nem similares. O HTML é do utilizador.
