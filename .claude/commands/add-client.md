---
description: Cria cliente novo desde template vertical ou vazio. Multi-cliente do OS.
---

# /add-client

Cria um novo cliente em `clients/<nome>/` com o seu próprio brand-context, context e projects.

## Process

1. Pergunta o nome do cliente (kebab-case): ex. `acme-corp`
2. Pergunta o vertical (se quiseres template):
   - `freelance-ia` — operador IA solo
   - `agencia-marketing` — agência pequena
   - `formador-online` — coach/educador
   - `consultoria-b2b` — consultor B2B
   - `vacio` — começar de zero
3. Executa: `bash scripts/add-client.sh <nome> <vertical>`
4. Output: estrutura criada em `clients/<nome>/`

## Notas

- O cliente herda o `CLAUDE.md` raiz do repo (aplica-se a todos por defeito)
- Podes adicionar `clients/<nome>/CLAUDE.md` com overrides específicos
- As skills copiam-se da raiz para o cliente; não se herdam, mas sincronizam-se com `bash scripts/update.sh`
- `cd clients/<nome> && claude` para trabalhar dentro do workspace do cliente

## Implementação

> Na v0.1.0 este comando é um wrapper para `bash scripts/add-client.sh`.
> Na v0.3.0 integra-se com templates preenchidos dos 4 verticais.

```
bash scripts/add-client.sh
```

Se `scripts/add-client.sh` ainda não existe, cria-o com template mínimo (só cria estrutura de pastas + `.gitkeep`).
