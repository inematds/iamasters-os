# `_install-state.json` — schema e contrato

> State machine persistente que garante que o iAmasters OS se instala completo, por fases, sem "instalações fantasma".
>
> Vive em `~/.claude/skills/_install-state.json`. É escrito por vários componentes, lido por outros tantos. Este documento é o contrato.

## Porque existe

Antes (v0.5.x): a instalação era um script bash de um único disparo + um wizard conversacional. Se algo falhasse a meio (Python no Windows, compressão de contexto, utilizador que se cansava), o sistema não sabia que fase tinha realmente completado. Resultado: o agente reportava "tudo instalado" quando só tinha criado ficheiros vazios.

Desde a v0.6: cada fase de instalação tem um estado persistente verificável. Um hook `SessionStart` lê este estado e bloqueia respostas ao utilizador até que a instalação esteja completa. A instalação é **reentrante**: se se partir, `/install --resume` continua desde a última fase bem-sucedida.

## Localização

```
~/.claude/skills/_install-state.json
```

Cria-o o `scripts/install.sh` ao arrancar. Vários componentes escrevem-no ao longo do fluxo. O hook `_install-gate.sh` lê-o antes de cada sessão.

## Fases

| # | Fase | `required` | Escreve | Validação de "done" |
|---|---|---|---|---|
| 1 | `prereqs` | sim | `install.sh` | git ≥2.0 + claude code + node ≥18 |
| 2 | `sinapsis-engine` | sim | `install.sh` | operator-state.json válido + hooks executáveis + ≥1 skill real |
| 3 | `context-files` | sim | `meta-onboarding-wizard` | 4 ficheiros criados em `context/` com conteúdo real |
| 4 | `operator-state` | sim | `meta-onboarding-wizard` | `needsOnboarding: false` + campos mínimos |
| 5 | `welcome-completed` | sim | `welcome-quick-win` | 1 deliverable em `projects/welcome/` |
| 6 | `deep-dive-completed` | não (deferrable) | `meta-deep-dive` | 22 dimensões cobertas em context/ |

**Regra:** a instalação considera-se completa quando todas as fases `required: true` estão em `done`. A fase 6 é deferrable — o sistema funciona sem ela, só te conhece mais superficialmente.

## Estados por fase

| Estado | Significado |
|---|---|
| `pending` | Não iniciada ainda |
| `in-progress` | Iniciada, não completada (pode ter checkpoint parcial) |
| `done` | Completada e validada externamente (não por declaração do agente) |
| `failed` | Tentada e falhou (com detalhe em `errors[]`) |
| `skipped` | Saltada por decisão explícita do utilizador (só válido em fases com `deferrable: true`) |

## Validação de "done" — não confia no agente

Cada fase tem uma validação que NÃO consiste em "o agente diz que o fez". São checks mecânicos:

**Fase 2 (`sinapsis-engine`)**:
```bash
# O validador verifica TUDO isto:
[ -f ~/.claude/skills/_operator-state.json ] && \
  jq empty ~/.claude/skills/_operator-state.json && \
  [ -x ~/.claude/skills/_passive-activator.sh ] && \
  [ -x ~/.claude/skills/_session-learner.sh ] && \
  [ -f ~/.claude/skills/_catalog.json ] && \
  jq empty ~/.claude/skills/_catalog.json && \
  [ "$(find ~/.claude/skills -name SKILL.md -maxdepth 3 | wc -l)" -gt 0 ]
```

Se algum falhar, a fase fica `failed` com detalhe em `errors[]`. O hook `SessionStart` deteta e guia recuperação.

**Fase 3 (`context-files`)**:
- Os 4 ficheiros existem
- Cada um tem ≥100 caracteres de conteúdo (não é template vazio)
- O ficheiro `me.md` tem `## Nome` com valor real

**Fase 4 (`operator-state`)**:
- `_operator-state.json` parseable
- `needsOnboarding: false`
- `operator.name` não é null nem vazio
- `operator.language` está set

**Fase 5 (`welcome-completed`)**:
- Existe `projects/welcome/<data>-*/` com pelo menos um ficheiro

## Quem escreve o quê (contrato)

**`install.sh`** (ao executar `bash scripts/install.sh`):
1. Cria o ficheiro se não existir (a partir de `scripts/_install-state.template.json`)
2. Define `repoPath`, `startedAt`
3. Após validar prereqs → `phases.prereqs.status = "done"`
4. Após instalar Sinapsis e validar profundo → `phases.sinapsis-engine.status = "done"` com checksum
5. Se algum falhar → `failed` com detalhe em `errors[]` e `exit 1`

**`meta-onboarding-wizard`** (skill):
- Depois da **fase 1 interna** (identidade+localização capturadas): escreve `context/me.md` e marca `filesCreated += ["context/me.md"]`
- Depois da **fase 2 interna** (negócio): escreve `context/work.md` e marca progresso
- Idem fase 3 e 4
- Ao terminar as 4: `phases.context-files.status = "done"` + `phases.operator-state.status = "done"`
- Se o utilizador abandona a meio: marca `pausedBy: "user"`, `pausedAtPhase: <fase atual>`, deixa `status: "in-progress"` com o `filesCreated` parcial

**`welcome-quick-win`** (skill):
- Após gerar o deliverable: `phases.welcome-completed.status = "done"` + `deliverablePath`

**`meta-deep-dive`** (skill):
- Após cobrir as 22 dimensões: `phases.deep-dive-completed.status = "done"`
- Se o utilizador adia explicitamente: `status = "skipped"`

## Quem lê o quê

**Hook `_install-gate.sh`** (SessionStart, executa antes do modelo ver a primeira mensagem):
- Lê o state
- Se alguma fase `required: true` não está em `done`, injeta `additionalContext` ao modelo:
  ```
  [INSTALL GATE] iAmasters OS installation incomplete: <N>/5 required phases done.
  Current phase: <currentPhase> (<status>).
  Before responding to the user, you MUST run /install --resume.
  Do not engage with other requests until installation is complete.
  ```

**Comando `/install`** e `/install --resume`:
- Lê state
- Se tudo `done`: diz "já instalado, não faço nada" e aborta
- Se há fase em progresso: continua onde ficou
- Se há fase falhada: mostra o erro + sugere fix

**Comando `/install-status`**:
- Lê state e mostra dashboard:
  ```
  📦 iAmasters OS · Installation status

  ✅ prereqs · done · 2026-05-15 10:00
  ✅ sinapsis-engine · done · checksum sha256:abc...
  🟡 context-files · in-progress · 1/4 files
  ⏳ operator-state · pending
  ⏳ welcome-completed · pending
  ⏭️  deep-dive-completed · deferrable

  Próximo passo: executa /install --resume
  ```

**Skill `health-check`** (`/doctor`):
- Lê state como fonte da verdade sobre o que está instalado
- Se tudo está `done` mas há ficheiros em falta no disco → drift detetado
- Se state diz `pending` mas ficheiros existem → re-validação profunda + atualizar state

**Skill `meta-start-here`**:
- Lê state ao início
- Se incompleto: deriva para `/install --resume` (redundância com o hook, caso o hook falhe)

## Edge cases

**Utilizador reinstala de zero**:
- Se `~/.claude/skills/_install-state.json` já existir e todas as fases estão `done`:
  - `install.sh` pergunta: reinstalar? (`--force-reinstall` flag ou prompt interativo)
  - Se sim: faz backup do state atual para `_install-state.<timestamp>.json` e arranca fresco

**Utilizador abre Claude Code num repo iamasters-os diferente do que instalou**:
- O state tem `repoPath`. Se não coincide com o atual:
  - O hook mostra: "Mudaste de repo iAmasters OS. O anterior estava em X. É intencional? (`/install` para reconfigurar)"

**Compressão de contexto a meio do wizard**:
- O state tem o detalhe do progresso parcial. A nova sessão:
  1. Lê state
  2. Deteta `currentPhase: "context-files"` com `filesCreated: ["me.md"]`
  3. O hook injeta: "Estavas em context-files, já tens me.md, faltam-te work.md/current-priorities.md/goals.md. Retoma com /install --resume"

**Instalação corrupta** (ficheiros eliminados manualmente após state `done`):
- `health-check` deteta drift (state diz done, ficheiros faltam)
- Marca a fase como `failed` com motivo e propõe re-executar

## Versionamento do schema

`schemaVersion: 1` (v0.6.0). Se no futuro o contrato mudar, sobe-se `schemaVersion` e `install.sh` migra estados antigos para o novo formato (função `migrate_state_v1_to_v2()`).

## Exemplo completo de state (instalação a meias)

```json
{
  "version": "0.6.0",
  "schemaVersion": 1,
  "repoPath": "/home/user/iamasters-os",
  "startedAt": "2026-05-15T10:00:00Z",
  "lastUpdatedAt": "2026-05-15T10:08:42Z",
  "currentPhase": "context-files",
  "completedPhases": ["prereqs", "sinapsis-engine"],
  "phases": {
    "prereqs": {
      "status": "done",
      "required": true,
      "validatedAt": "2026-05-15T10:00:30Z",
      "checks": {
        "git": "2.43.0",
        "node": "v20.10.0",
        "python": "Python 3.11.7",
        "claude_code": "env-detected"
      },
      "warnings": [],
      "owner": "install.sh"
    },
    "sinapsis-engine": {
      "status": "done",
      "required": true,
      "validatedAt": "2026-05-15T10:01:15Z",
      "validation": {
        "operator_state_json_valid": true,
        "catalog_json_valid": true,
        "hooks_executable": true,
        "skills_count": 23
      },
      "checksum": "sha256:9a8b7c6d5e4f...",
      "owner": "install.sh"
    },
    "context-files": {
      "status": "in-progress",
      "required": true,
      "startedAt": "2026-05-15T10:05:12Z",
      "filesCreated": ["context/me.md"],
      "filesPending": [
        "context/work.md",
        "context/current-priorities.md",
        "context/goals.md"
      ],
      "owner": "meta-onboarding-wizard"
    },
    "operator-state": {
      "status": "pending",
      "required": true,
      "validatedAt": null,
      "fields": {},
      "owner": "meta-onboarding-wizard"
    },
    "welcome-completed": {
      "status": "pending",
      "required": true,
      "deliverablePath": null,
      "owner": "welcome-quick-win"
    },
    "deep-dive-completed": {
      "status": "pending",
      "required": false,
      "deferrable": true,
      "owner": "meta-deep-dive"
    }
  },
  "pausedBy": "user",
  "pausedAt": "2026-05-15T10:08:42Z",
  "pausedAtPhase": "context-files",
  "errors": []
}
```

Leitura: o utilizador começou a instalação, terminou prereqs e Sinapsis, abriu Claude Code, o wizard arrancou context-files, escreveu `me.md`, o utilizador disse "para, volto depois". Na próxima sessão, o hook lê isto e força `/install --resume` que retoma desde `work.md`.
