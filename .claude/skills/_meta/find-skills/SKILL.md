---
name: find-skills
description: Ajuda os utilizadores a descobrir e instalar agent skills quando fazem perguntas como "como faço X", "encontra uma skill para X", "há uma skill que possa...", ou demonstram interesse em estender capacidades. Esta skill deve ser usada quando o utilizador procura funcionalidade que possa existir como skill instalável.
---

# Find Skills

Esta skill ajuda-te a descobrir e instalar skills do ecossistema open agent skills.

## Quando usar esta skill

Usa esta skill quando o utilizador:

- Pergunta "como faço X" onde X pode ser uma tarefa comum com uma skill existente
- Diz "encontra uma skill para X" ou "há uma skill para X"
- Pergunta "consegues fazer X" onde X é uma capacidade especializada
- Demonstra interesse em estender capacidades do agente
- Quer pesquisar ferramentas, templates ou workflows
- Menciona que gostaria de ter ajuda com um domínio específico (design, testing, deployment, etc.)

## O que é o Skills CLI?

O Skills CLI (`npx skills`) é o package manager do ecossistema open agent skills. Skills são pacotes modulares que estendem capacidades do agente com conhecimento especializado, workflows e ferramentas.

**Comandos chave:**

- `npx skills find [query]` - Pesquisar skills interativamente ou por keyword
- `npx skills add <package>` - Instalar uma skill a partir do GitHub ou outras fontes
- `npx skills check` - Verificar atualizações de skills
- `npx skills update` - Atualizar todas as skills instaladas

**Explora skills em:** https://skills.sh/

## Como ajudar utilizadores a encontrar skills

### Passo 1 · Perceber o que precisam

Quando um utilizador pede ajuda com algo, identifica:

1. O domínio (ex: React, testing, design, deployment)
2. A tarefa específica (ex: escrever testes, criar animações, rever PRs)
3. Se é uma tarefa comum o suficiente para uma skill provavelmente existir

### Passo 2 · Pesquisar skills

Executa o comando find com uma query relevante:

```bash
npx skills find [query]
```

Por exemplo:

- Utilizador pergunta "como torno a minha app React mais rápida?" → `npx skills find react performance`
- Utilizador pergunta "podes ajudar-me com reviews de PR?" → `npx skills find pr review`
- Utilizador pergunta "preciso de criar um changelog" → `npx skills find changelog`

O comando devolve resultados como:

```
Install with npx skills add <owner/repo@skill>

vercel-labs/agent-skills@vercel-react-best-practices
└ https://skills.sh/vercel-labs/agent-skills/vercel-react-best-practices
```

### Passo 3 · Apresentar opções ao utilizador

Quando encontras skills relevantes, apresenta-as ao utilizador com:

1. O nome da skill e o que faz
2. O comando de instalação que podem executar
3. Um link para saber mais em skills.sh

Exemplo de resposta:

```
Encontrei uma skill que pode ajudar! A skill "vercel-react-best-practices" fornece
guidelines de otimização de performance React e Next.js da Vercel Engineering.

Para instalar:
npx skills add vercel-labs/agent-skills@vercel-react-best-practices

Saber mais: https://skills.sh/vercel-labs/agent-skills/vercel-react-best-practices
```

### Passo 4 · Oferecer instalação

Se o utilizador quiser prosseguir, podes instalar a skill por ele:

```bash
npx skills add <owner/repo@skill> -g -y
```

A flag `-g` instala globalmente (user-level) e `-y` salta prompts de confirmação.

## Categorias comuns de skills

Ao pesquisar, considera estas categorias comuns:

| Categoria       | Exemplos de queries                      |
| --------------- | ---------------------------------------- |
| Web Development | react, nextjs, typescript, css, tailwind |
| Testing         | testing, jest, playwright, e2e           |
| DevOps          | deploy, docker, kubernetes, ci-cd        |
| Documentation   | docs, readme, changelog, api-docs        |
| Code Quality    | review, lint, refactor, best-practices   |
| Design          | ui, ux, design-system, accessibility     |
| Productivity    | workflow, automation, git                |

## Dicas para pesquisas eficazes

1. **Usa keywords específicas**: "react testing" é melhor do que só "testing"
2. **Tenta termos alternativos**: Se "deploy" não funcionar, tenta "deployment" ou "ci-cd"
3. **Verifica fontes populares**: Muitas skills vêm de `vercel-labs/agent-skills` ou `ComposioHQ/awesome-claude-skills`

## Quando não se encontram skills

Se não existirem skills relevantes:

1. Reconhece que não foi encontrada nenhuma skill existente
2. Oferece ajudar com a tarefa diretamente usando as tuas capacidades gerais
3. Sugere que o utilizador pode criar a sua própria skill com `npx skills init`

Exemplo:

```
Pesquisei skills relacionadas com "xyz" mas não encontrei correspondências.
Ainda assim posso ajudar-te com esta tarefa diretamente! Queres que avance?

Se isto é algo que fazes muitas vezes, podias criar a tua própria skill:
npx skills init my-xyz-skill
```
