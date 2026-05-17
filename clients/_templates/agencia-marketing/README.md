# Template · Agência de Marketing

> Para agências pequenas (2-10 pessoas) que servem múltiplos clientes com serviços de marketing/conteúdo.

## Para quem é este template

- Equipa de 2-10 pessoas
- Vertical: marketing, conteúdo, social media, paid ads
- Atendem 5-30 clientes em simultâneo
- Precisam padronizar entregáveis e voice por cliente
- Vendem tempo de equipa + produção mensal recorrente

## O que vem pré-configurado

- **Voice profile**: profissional criativo, equilíbrio formal-próximo (B com A para premium)
- **Positioning**: agência especialista (não full-service) com foco vertical ou serviço
- **ICP**: PMEs/scaleups com MRR já estabelecido a buscar crescer
- **Estrutura projetos**: orientada a entregáveis mensais recorrentes (content calendar, ad creatives, reports)
- **Workflow**: separação clara entre work-on-account (cliente) vs work-on-firm (agência própria)

## Diferença com freelance-ia

| Aspeto | freelance-ia | agencia-marketing |
|---|---|---|
| Quem decide | Founder solo | Account manager ou sócio |
| Tipo de output | Implementação técnica IA | Conteúdo + estratégia + reports |
| Cliente principal | PMEs com dor concreta | PMEs/scaleups com marketing budget |
| Frequência entrega | Por projeto | Mensal recorrente |
| Voice | A tua voice (operador) | Cada cliente tem a sua voice |

## Adaptações específicas

- Pasta `monthly-reports/` para reports recorrentes por cliente
- Pasta `content-calendar/` com template mensal editável
- Skill priority: `marketing-content-repurposing` + `marketing-copywriting` (muito output volume)

## Estrutura

```
agencia-marketing/
├── README.md
├── brand-context/
│   ├── voice/voice-profile.template.md
│   ├── positioning/positioning.template.md
│   └── icp/icp.template.md
├── context/
│   ├── soul.md                       # Personalidade agência-style
│   └── user.template.md
└── (subpastas criadas ao instalar)
```

## Como usar

```bash
bash scripts/add-client.sh acme-coffee agencia-marketing
```
