# Platform limits — referência mantida

## Texto

| Plataforma | Mínimo | Máximo | Ideal | Notas |
|---|---:|---:|---:|---|
| **Twitter/X post único** | 100 chars | 280 chars | 200-260 | Cap duro 280 |
| **X article** | 500 words | 4000 words | 800-1500 | Long-form pago |
| **LinkedIn post pessoal** | 600 chars | 3000 chars | 1200-1800 | "See more" corta a ~210 chars |
| **LinkedIn post empresa** | 600 chars | 3000 chars | 700-1200 | Empresa mais curto que pessoal |
| **LinkedIn article** | 800 words | 2000 words | 1200-1500 | Long-form |
| **LinkedIn newsletter** | 500 words | 1500 words | 800-1200 | Cap suave 4000 chars |
| **Instagram caption** | 100 chars | 2200 chars | 300-700 | "Mais" aparece após 125 chars |
| **Instagram bio** | 0 chars | 150 chars | 100-130 | Cap duro 150 |
| **Facebook post** | 100 chars | 5000 chars | 200-400 | Engagement cai muito > 250 |
| **TikTok caption** | 50 chars | 2200 chars | 100-300 | Mais hashtags ~5 max |
| **YouTube description** | 100 chars | 5000 chars | 1000-2000 | SEO por keywords primeiro |
| **YouTube title** | 30 chars | 100 chars | 50-70 | Cap duro 100 |
| **Email subject** | 30 chars | 60 chars | 40-50 | Telemóvel corta a ~35-40 |
| **Email preview** | 30 chars | 100 chars | 50-90 | Aparece junto ao subject |
| **Email body** | 50 words | 600 words | 150-300 | Newsletters mais longas OK |
| **WhatsApp post** | 30 chars | 1500 chars | 200-500 | "Ver mais" após 150 chars |
| **Slack message** | 30 chars | 4000 chars | 100-300 | Threads para mais longo |
| **Discord message** | 30 chars | 2000 chars | 100-300 | Cap duro 2000 |
| **Blog post padrão** | 800 words | 2500 words | 1200-1800 | SEO sweet spot |
| **Blog pillar page** | 2000 words | 5000 words | 3000-4000 | Long-form SEO |

## Landing pages (componentes)

| Componente | Mínimo | Máximo | Ideal |
|---|---:|---:|---:|
| Hero headline | 5 words | 12 words | 7-9 |
| Hero subheadline | 10 words | 30 words | 15-25 |
| CTA primário | 2 words | 5 words | 2-3 |
| CTA secundário | 2 words | 6 words | 3-4 |
| Feature title | 2 words | 7 words | 3-5 |
| Feature description | 10 words | 40 words | 20-30 |
| Testimonial | 20 words | 100 words | 30-60 |
| FAQ pergunta | 5 words | 15 words | 7-12 |
| FAQ resposta | 30 words | 150 words | 50-100 |

## Anúncios

| Plataforma + tipo | Headline | Body | Notas |
|---|---:|---:|---|
| Google Ads search headline | 30 chars | - | Cap duro |
| Google Ads search description | - | 90 chars | Cap duro |
| Meta Ads primary text | - | 125 chars (preview) / 1500 max | Corta a 125 |
| Meta Ads headline | 27 chars (preview) / 40 max | - | Mobile corta a 27 |
| Meta Ads description | - | 30 chars | Opcional |
| LinkedIn Sponsored Content | - | 600 chars (preview 150) | - |
| TikTok Ads | 100 chars | - | - |

## Visual

| Asset | Aspect ratio | Tamanho |
|---|---|---|
| Instagram post | 1:1 | 1080x1080 |
| Instagram reel/story | 9:16 | 1080x1920 |
| Twitter/X image | 16:9 | 1200x675 |
| LinkedIn post image | 1.91:1 | 1200x627 |
| LinkedIn cover pessoal | 4:1 | 1584x396 |
| YouTube thumbnail | 16:9 | 1280x720 |
| TikTok | 9:16 | 1080x1920 |

## Como atualizar

Quando uma plataforma alterar os seus limites, edita esta tabela e faz commit:
```
docs(platform-limits): update LinkedIn post max 3000→3500 (2026-MM-DD)
```

Verifica em fontes oficiais antes de alterar:
- Twitter/X: https://help.twitter.com
- LinkedIn: https://help.linkedin.com
- Meta: https://developers.facebook.com/docs
- Google Ads: https://support.google.com/google-ads
