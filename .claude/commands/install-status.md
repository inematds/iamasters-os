---
description: Dashboard do estado de instalação iAmasters OS. Lê ~/.claude/skills/_install-state.json e mostra que fases estão done, in-progress, failed ou pending. Só leitura — não modifica nada. Útil quando o utilizador duvida que a instalação esteja bem ou quer saber porque algo não funciona.
---

# /install-status

Mostra o estado atual da instalação. Read-only.

## Process

### Passo 1 · Ler state

Lê `~/.claude/skills/_install-state.json`. Se não existe:
> "iAmasters OS não está instalado neste sistema. Executa desde o terminal:
>
> ```bash
> bash scripts/install.sh
> ```"

Para.

### Passo 2 · Mostrar dashboard

Formato exato:

```
📦 iAmasters OS · Installation status

Repo:        <repoPath>
Started:     <startedAt>
Last update: <lastUpdatedAt>
Schema:      v<schemaVersion>

Fases:
  <icon> prereqs            · <status>  <detail>
  <icon> sinapsis-engine    · <status>  <detail>
  <icon> context-files      · <status>  <detail>
  <icon> operator-state     · <status>  <detail>
  <icon> welcome-completed  · <status>  <detail>
  <icon> deep-dive-completed · <status>  <detail>  [opcional]

Required progress: <X>/5 done
```

Ícones por estado:
- `done` → ✅
- `in-progress` → 🟡
- `failed` → ❌
- `pending` → ⏳
- `skipped` → ⏭️

Detalhes por fase:
- `prereqs`: mostra `checks` (versões detetadas)
- `sinapsis-engine`: mostra `validation.skills_count` e os primeiros 12 chars do checksum se houver
- `context-files`: mostra `filesCreated.length`/4 + lista breve se houver menos de 4
- `operator-state`: mostra se há nome e nível técnico capturados
- `welcome-completed`: mostra `deliverablePath` se houver
- `deep-dive-completed`: mostra `(opcional, não bloqueante)`

### Passo 3 · Mostrar erros recentes

Se `errors[]` tem conteúdo, lista os últimos 3:
```
⚠️  Últimos erros:
  - [<phase>] <message>  (<at>)
```

### Passo 4 · Ação recomendada

No fim, uma linha com o que fazer agora:

- Se tudo `done` (5/5): "Tudo em ordem. Executa `/start-here` para começar o dia."
- Se há alguma `in-progress`: "Continua com `/install --resume`."
- Se há `failed`: "Resolve o erro e depois executa `bash scripts/install.sh --resume`."
- Se há só `pending` depois de `prereqs/sinapsis-engine` done: "Continua o onboarding com `/install`."
- Se só `deep-dive-completed` fica: "As 5 fases obrigatórias estão feitas. Opcional: `/deep-dive` para aprofundar."

### Passo 5 · Se o utilizador pede HTML partilhável

Se diz "faz-me em HTML" ou "partilha-me", invoca `tool-visual-explainer` com o dashboard acima.

## O que NÃO fazes

- ❌ Modificar o state file
- ❌ Executar `install.sh`
- ❌ Invocar wizard nem outras skills
- ❌ Tomar ações — só informas
