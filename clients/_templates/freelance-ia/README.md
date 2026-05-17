# Template · Operador IA Freelance

> Para operadores que servem múltiplos clientes a partir do seu portátil, sem equipa grande.

## Para quem é este template

- És tu sozinho (ou equipa de 1-2)
- Atendes 3-10 clientes ao mesmo tempo
- O teu produto: implementação + manutenção de IA nos processos deles
- Queres profissionalizar entregáveis sem criar estrutura corporate

## O que vem pré-configurado

- **Voice profile**: tom profissional mas pessoal (B+ com toques de C)
- **Positioning**: especialista IA aplicada a PMEs, anti-vendehumos
- **ICP**: PMEs de 5-30 pessoas com dor concreta
- **Skills favoritas**: marketing-copywriting, marketing-content-repurposing, tool-output-verifier
- **Estrutura projetos**: orientado a entregáveis por cliente

## O que adaptar ao clonar para um cliente real

- Nome do cliente e dados legais
- ICP específico desse cliente (o mercado dele, não o teu)
- Voice profile do cliente (extrais com marketing-brand-voice)
- Positioning do cliente (não o teu)

## Estrutura

```
freelance-ia/
├── README.md                         # Este ficheiro
├── brand-context/
│   ├── voice/
│   │   ├── voice-profile.template.md # Tom base
│   │   ├── register-a-formal.template.md
│   │   ├── register-b-divulgativo.template.md
│   │   └── register-c-cercano.template.md
│   ├── positioning/
│   │   └── positioning.template.md
│   └── icp/
│       └── icp.template.md
├── context/
│   ├── soul.md                       # Personalidade do agente para serviço
│   └── user.template.md              # Template do operador-no-cliente
└── projects/                         # Vazio, preenche-se no uso
```

## Como usar

```bash
bash scripts/add-client.sh acme-corp freelance-ia
```

Isto clona este template para `clients/acme-corp/` e deixa o operador preencher os campos específicos.
