# Skills recomendadas — Camada 2 (on-demand)

As **18 skills core** que vêm pré-instaladas com o iAmasters OS estão no README. Este documento lista as **skills opcionais** que podes adicionar quando precisares com `/install-skill <github-url>`.

> **Filosofia**: max 30 skills, não 1000. Inflar o catálogo paralisa o membro novo. Esta lista é **curada e opinativa** — só skills validadas em produção ≥2 semanas. Não é exaustiva nem inclusiva.

> Última revisão: 2026-05-08 (v0.4.3)

---

## Como instalar uma skill desta lista

```
# Dentro do Claude Code no teu repo iAmasters OS:
/install-skill https://github.com/<owner>/<skill-repo>
```

O comando:
1. Clona a skill para `.claude/skills/<categoria>/<nome>/` localmente
2. Valida estrutura (SKILL.md presente, YAML frontmatter, descrição ≥50 chars)
3. Pergunta-te se queres globalizá-la para `~/.claude/skills/` (skill partilhada entre repos)

---

## Marketing — texto e campanhas

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `copywriting` | Copy de landing pages e emails com humanizer gate e validação de não-fabricação | ⭐ Fácil |
| `copy-editing` | Edita e melhora copy existente, proofreading, sweep de clareza | ⭐ Fácil |
| `content-strategy` | Plano de conteúdo (o que escrever, frequência, distribuição) | ⭐⭐ Média |
| `email-sequence` | Drip campaigns, sequências de boas-vindas, lifecycle, abandoned cart | ⭐⭐ Média |
| `email-marketing-bible` | Knowledge base de email marketing (908 fontes, 4.798 insights) | ⭐ Fácil |
| `social-content` | LinkedIn, X/Twitter, Instagram, TikTok, Facebook | ⭐ Fácil |
| `ad-creative` | Variações de copy de ads (headlines, descriptions, primary text) | ⭐⭐ Média |
| `launch-strategy` | Plano de lançamento de produto, feature, beta, ProductHunt | ⭐⭐⭐ Avançada |
| `paid-ads` | Google Ads, Meta, LinkedIn, X — campanhas, ROAS, CPA | ⭐⭐⭐ Avançada |
| `cold-email` | B2B prospecting emails com follow-ups | ⭐⭐ Média |

## CRO — conversão

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `page-cro` | Otimizar homepage, landing, pricing, feature pages | ⭐⭐ Média |
| `form-cro` | Formulários contacto/lead/demo (NÃO signup) | ⭐⭐ Média |
| `signup-flow-cro` | Otimização registration / signup / trial activation | ⭐⭐⭐ Avançada |
| `popup-cro` | Modais, exit-intent, banners, slide-ins | ⭐⭐ Média |
| `paywall-upgrade-cro` | Paywalls, upgrade screens, upsells, feature gates | ⭐⭐⭐ Avançada |
| `onboarding-cro` | Ativação post-signup, time-to-value | ⭐⭐⭐ Avançada |
| `ab-test-setup` | Desenhar e implementar A/B tests | ⭐⭐ Média |

## SEO

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `seo-audit` | Audit técnico SEO completo | ⭐⭐ Média |
| `ai-seo` | AEO/GEO/LLMO — otimizar para citações de LLMs | ⭐⭐ Média |
| `schema-markup` | JSON-LD, structured data, rich snippets | ⭐⭐⭐ Avançada |
| `programmatic-seo` | Páginas SEO à escala com templates + dados | ⭐⭐⭐ Avançada |

## Estratégia e produto

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `pricing-strategy` | Decisões de preço, packaging, freemium, free trial | ⭐⭐ Média |
| `referral-program` | Programas de referidos, afiliados, viral loops | ⭐⭐ Média |
| `product-marketing-context` | Documento de positioning, ICP, foundational context | ⭐⭐ Média |
| `marketing-ideas` | Geração de ideias de marketing e growth | ⭐ Fácil |
| `marketing-psychology` | Aplicar princípios psicológicos a marketing | ⭐⭐ Média |
| `churn-prevention` | Cancellation flows, save offers, recovery | ⭐⭐⭐ Avançada |
| `revops` | Lead lifecycle, marketing-to-sales handoff, scoring | ⭐⭐⭐ Avançada |
| `sales-enablement` | Pitch decks, one-pagers, objection handling | ⭐⭐ Média |
| `running-marketing-campaigns` | Plano completo end-to-end de campanhas | ⭐⭐⭐ Avançada |

## Analítica e crescimento

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `analytics-tracking` | GA4, conversion tracking, UTMs, event tracking | ⭐⭐ Média |
| `saas-revenue-growth-metrics` | ARPU, MRR, ARR, churn, NRR, expansion, cohorts | ⭐⭐ Média |
| `competitive-ads-extractor` | Extrair ads de concorrentes (Facebook/LinkedIn ad library) | ⭐⭐ Média |
| `competitor-alternatives` | Páginas comparativas "X vs Y" para SEO + sales | ⭐⭐ Média |
| `free-tool-strategy` | Free tools como growth driver | ⭐⭐⭐ Avançada |

## Operações (do plugin externo `operations:*`)

Estas skills vêm do plugin `operations:*` da suite do Cowork. Disponíveis se tiveres o plugin instalado:

- `operations:process-optimization` — analisar e melhorar processos
- `operations:runbook` — criar runbooks operacionais
- `operations:status-report` — reports com KPIs, riscos, action items
- `operations:risk-assessment` — identificar e mitigar riscos
- `operations:capacity-plan` — planeamento de capacidade
- `operations:vendor-review` — avaliação de fornecedores
- `operations:change-request` — pedidos de mudança com análise de impacto
- `operations:compliance-tracking` — tracking compliance + audit prep
- `operations:process-doc` — documentação de processos (RACI, SOPs)

## Tooling e ficheiros (oficiais Anthropic)

| Skill | Para que | Dificuldade |
|---|---|:-:|
| `anthropic-skills:docx` | Criar, ler, editar Word docs | ⭐ Fácil |
| `anthropic-skills:xlsx` | Manipular spreadsheets (xlsx, xlsm, csv, tsv) | ⭐ Fácil |
| `anthropic-skills:pptx` | Criar e editar apresentações | ⭐ Fácil |
| `anthropic-skills:pdf` | Ler, combinar, dividir, marcar PDFs | ⭐ Fácil |

> As 4 skills de gestão de ficheiros office vêm oficialmente da Anthropic. Recomendação: instalar SEMPRE que o operador trabalha com clientes que enviam Excel/Word/PDF/PPT (maioria).

## Para setores específicos

Se a lista de skills não cobre o teu vertical, vê se há template mais específico:

- **Médicos / Dental**: combinar `web-legal-audit` para RGPD + template para clínicas
- **Imobiliárias**: combinar `programmatic-seo` + skills de local SEO
- **B2B SaaS**: combinar `revops` + `saas-revenue-growth-metrics` + `pricing-strategy`
- **E-commerce**: combinar `paywall-upgrade-cro` + `email-sequence` + `analytics-tracking`
- **Educação / Formação online**: combinar `email-sequence` (cohorts) + `launch-strategy` (cada lançamento) + `churn-prevention` (retenção)

---

## Alternativa lean: claude-code-second-brain

Se **preferes começar mais minimal** (sem clonar todo o iAmasters OS), existe uma alternativa mais leve do mesmo autor do Sinapsis:

> 🧠 **[claude-code-second-brain](https://github.com/Luispitik/claude-code-second-brain)** por [Luis Pitik](https://github.com/Luispitik)
>
> Colas um prompt no Claude Code → entrevista-te por secções → gera um sistema de ficheiros persistente: CLAUDE.md master + `context/me.md, work.md, team.md, current-priorities.md, goals.md` + `decisions-log.md`. **É a versão lean** do que o iAmasters OS faz.

### Quando escolher um ou outro

| Caso | Melhor opção |
|---|---|
| Queres começar minimal, sem skills curadas | **second-brain** |
| Queres skills marketing/CRO/SEO já instaladas | **iamasters-os** |
| Trabalhas com múltiplos clientes com brand context distinto | **iamasters-os** (templates verticais) |
| Só precisas memória persistente | **second-brain** |
| Queres comunidade + atualizações curadas | **iamasters-os** |
| És muito técnico e queres rodar o teu próprio sistema | **second-brain** + as tuas skills próprias |

O iAmasters OS adota o padrão de "context setorizado + decisions-log" do second-brain com crédito explícito. São produtos irmãos do mesmo autor (Luis), não concorrência.

---

## Como propor uma skill nova ao catálogo

Se criaste ou encontraste uma skill que achas que merece estar neste catálogo:

1. Garante que cumpre os critérios:
   - Serve a ≥3 avatares iAmasters
   - Output útil sem contexto prévio do operador
   - Não depende de integrações privadas (Skool, Wixin, etc.)
   - Não depende de informação confidencial
   - Validada em produção ≥2 semanas

2. Abre uma issue ou PR em [`iamasters-academy/iamasters-os`](https://github.com/iamasters-academy/iamasters-os) com:
   - Link à skill
   - 1-2 exemplos de uso real
   - Categoria sugerida
   - Porque encaixa na Camada 2

3. O maintainer (Angel) revê. As que passam adicionam-se ao catálogo na próxima release.

## Como retirar uma skill do catálogo

Se uma skill se torna obsoleta, deprecated, ou o autor a abandona, abre uma issue. As skills neste catálogo renovam-se trimestralmente.
