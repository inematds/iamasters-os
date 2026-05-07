# Template · Operador IA Freelance

> Para operadores que sirven a múltiples clientes desde su laptop, sin equipo grande.

## Para quién es este template

- Eres tú solo (o equipo de 1-2)
- Atiendes 3-10 clientes a la vez
- Tu producto: implementación + mantenimiento de IA en sus procesos
- Quieres profesionalizar entregables sin crear estructura corporate

## Qué viene preconfigurado

- **Voice profile**: tono profesional pero personal (B+ con toques de C)
- **Positioning**: especialista IA aplicada a pymes, anti-vendehumos
- **ICP**: pymes de 5-30 personas con dolor concreto
- **Skills favoritas**: marketing-copywriting, marketing-content-repurposing, tool-output-verifier
- **Estructura proyectos**: orientado a entregables por cliente

## Qué adaptar al clonar a un cliente real

- Nombre del cliente y datos legales
- ICP específico de ese cliente (su mercado, no el tuyo)
- Voice profile del cliente (lo extraes con marketing-brand-voice)
- Positioning del cliente (no el tuyo)

## Estructura

```
freelance-ia/
├── README.md                         # Este archivo
├── brand-context/
│   ├── voice/
│   │   ├── voice-profile.template.md # Tono base
│   │   ├── register-a-formal.template.md
│   │   ├── register-b-divulgativo.template.md
│   │   └── register-c-cercano.template.md
│   ├── positioning/
│   │   └── positioning.template.md
│   └── icp/
│       └── icp.template.md
├── context/
│   ├── soul.md                       # Personalidad del agente para servicio
│   └── user.template.md              # Plantilla del operador-en-cliente
└── projects/                         # Vacío, se rellena en uso
```

## Cómo usar

```bash
bash scripts/add-client.sh acme-corp freelance-ia
```

Esto clona este template a `clients/acme-corp/` y deja al operador rellenar campos específicos.
