# Template · Agencia de Marketing

> Para agencias pequeñas (2-10 personas) que sirven a múltiples clientes con servicios de marketing/contenido.

## Para quién es este template

- Equipo de 2-10 personas
- Vertical: marketing, contenido, social media, paid ads
- Atendéis 5-30 clientes simultáneamente
- Necesitáis estandarizar entregables y voice por cliente
- Vendéis tiempo de equipo + producción mensual recurrente

## Qué viene preconfigurado

- **Voice profile**: profesional creativo, equilibrio formal-cercano (B con A para premium)
- **Positioning**: agencia especialista (no full-service) con foco vertical o servicio
- **ICP**: pymes/scaleups con MRR ya establecido buscando crecer
- **Estructura proyectos**: orientada a entregables mensuales recurrentes (content calendar, ad creatives, reports)
- **Workflow**: separación clara entre work-on-account (cliente) vs work-on-firm (agencia propia)

## Diferencia con freelance-ia

| Aspecto | freelance-ia | agencia-marketing |
|---|---|---|
| Quien decide | Founder solo | Account manager o socio |
| Tipo de output | Implementación técnica IA | Contenido + estrategia + reports |
| Cliente principal | Pymes con dolor concreto | Pymes/scaleups con marketing budget |
| Frecuencia entrega | Por proyecto | Mensual recurrente |
| Voice | Tu voice (operador) | Cada cliente tiene su voice |

## Adaptaciones específicas

- Carpeta `monthly-reports/` para reports recurrentes por cliente
- Carpeta `content-calendar/` con plantilla mensual editable
- Skill priority: `marketing-content-repurposing` + `marketing-copywriting` (mucho output volumen)

## Estructura

```
agencia-marketing/
├── README.md
├── brand-context/
│   ├── voice/voice-profile.template.md
│   ├── positioning/positioning.template.md
│   └── icp/icp.template.md
├── context/
│   ├── soul.md                       # Personalidad agencia-style
│   └── user.template.md
└── (subcarpetas creadas al instalar)
```

## Cómo usar

```bash
bash scripts/add-client.sh acme-coffee agencia-marketing
```
