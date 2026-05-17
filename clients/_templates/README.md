# Templates de cliente vertical

> Na v0.1.0 os templates estão vazios (só .gitkeep). Preenchem-se na v0.3.0.

## Verticais planeados

1. **freelance-ia** — operador IA solo, serve múltiplos clientes a partir do seu portátil
2. **agencia-marketing** — agência pequena 2-10 pessoas, especializada em marketing/conteúdo
3. **formador-online** — coach ou educador que vende cursos/comunidade
4. **consultoria-b2b** — consultor B2B (estratégia, ops, transformação)

## O que cada template traz

```
clients/_templates/<vertical>/
├── brand-context/
│   ├── voice/voice-profile.md          # Tom típico do vertical
│   ├── positioning/positioning.md      # Ângulos comuns
│   └── icp/icp.md                      # Cliente ideal do vertical
├── context/
│   ├── soul.md                         # Personalidade ajustada
│   └── user.md                         # Template com campos típicos
└── projects/
    └── (vazio)
```

## Como se usa

```bash
bash scripts/add-client.sh <nome-cliente> <vertical>
```

Isto clona o template do vertical selecionado para `clients/<nome-cliente>/` e deixa o operador preencher o específico (nome do cliente, site, etc.).

## Contribuir verticais novos

1. Criar `clients/_templates/<nome-vertical>/`
2. Seguir a estrutura padrão
3. Pull request com a justificação do vertical (que tipo de operador precisa dele)
