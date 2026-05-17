---
description: Orquestrador de instalação iAmasters OS. Lê o state machine e continua desde a fase pendente. Reentrante — pode-se executar todas as vezes que for preciso sem risco. Aceitas argumentos `--resume` (default) e `--force-reinstall` (requer confirmação explícita do utilizador).
---

# /install

Coordenas a instalação por fases do iAmasters OS. A fonte da verdade é `~/.claude/skills/_install-state.json` — TU não decides o que há a fazer, o state machine é que decide.

## Process

### Passo 1 · Ler state

Lê `~/.claude/skills/_install-state.json` com a tool `Read`. Se NÃO existe:

- Indica ao utilizador:
  > "O installer técnico ainda não correu. Preciso que abras o terminal e executes:
  >
  > ```bash
  > bash scripts/install.sh
  > ```
  >
  > Quando terminar, volta aqui e diz `/install` outra vez."
- **NÃO crias o state file tu**. Só o `scripts/install.sh` o cria.
- Para aqui.

### Passo 2 · Avaliar progresso

Do state file, identifica:
- `completedPhases` (as que já estão `done`)
- A primeira fase com `required: true` e `status != "done"` (essa é a que toca)
- Se todas as fases required estão `done` → instalação completa

### Passo 3 · Atuar conforme a fase pendente

#### Caso A: tudo `done`
Mensagem:
> "O iAmasters OS já está completamente instalado. Se quiseres reinstalar de zero, diz `/install --force-reinstall` (avisar-te-ei antes de fazer nada destrutivo)."

Sugere executar `/start-here` para arrancar o fluxo normal de trabalho.

#### Caso B: fase `prereqs` ou `sinapsis-engine` pendente/failed
Estas fases têm de ser executadas por `bash scripts/install.sh` desde o terminal — TU NÃO podes executá-las desde o Claude Code.

Mensagem:
> "Faltam fases técnicas que requerem executar o installer desde o terminal. Abre o teu terminal neste repo e executa:
>
> ```bash
> bash scripts/install.sh --resume
> ```
>
> Isto retoma desde a fase pendente: `<nome-fase>`."

Se a fase está `failed`, lê `errors[]` do state file e mostra ao utilizador o último erro para que o possa resolver:
> "A última tentativa falhou com: `<mensagem>`. Assim que arranjares, executa o comando acima."

**Para aqui. NÃO tentes executar bash de dentro do Claude Code para isto.**

#### Caso C: fase `context-files` ou `operator-state` pendente/in-progress
Isto é onboarding conversacional. Tu executa-lo diretamente.

1. Lê `phases.context-files.filesCreated` do state para saber o que já está feito.
2. Invoca a skill `meta-onboarding-wizard` (lê `.claude/skills/_meta/meta-onboarding-wizard/SKILL.md` e segue o Process ao pé da letra).
3. A skill encarrega-se de retomar desde a sub-fase correta, commitar cada ficheiro e atualizar o state.

#### Caso D: fase `welcome-completed` pendente
Invoca `welcome-quick-win` (skill em `.claude/skills/_meta/welcome-quick-win/SKILL.md`). Essa skill gera o primeiro entregável e marca a fase como `done`.

#### Caso E: só fica `deep-dive-completed` pendente (deferrable)
Mensagem:
> "As 5 fases obrigatórias estão feitas. O único pendente é `meta-deep-dive` (opcional — aprofunda o teu perfil mas não é bloqueante). Quando quiseres fazê-lo: `/deep-dive`."

Sugere `/start-here` para arrancar trabalho normal.

### Passo 4 · Flag --force-reinstall

Se o utilizador passou `--force-reinstall` no comando:
1. **Confirma explicitamente**: "Isto vai fazer backup do estado atual e reiniciar a instalação de zero. Significa que terás de voltar a responder o onboarding. Continuo? (s/n)"
2. Se "s": indica que execute desde o terminal `bash scripts/install.sh --force-reinstall`.
3. NÃO faças nada destrutivo sem a confirmação.

### Passo 5 · Se o utilizador quer parar

Se a qualquer momento disser "para", "deixa", "não quero seguir":
1. Se estava no wizard, o wizard já tem o edge case definido (marca `pausedBy: user` e persiste).
2. Mensagem breve: "Está bem. Quando voltares, `/install --resume` retoma daqui. O que já fizemos fica guardado."
3. NÃO insistas.

## O que NÃO fazes nunca

- ❌ Criar ficheiros em `~/.claude/skills/` manualmente para simular instalação
- ❌ Marcar fases como `done` se os ficheiros não existem realmente
- ❌ Dizer "tudo instalado" se o state não o confirma
- ❌ Saltar fases por consideração própria
- ❌ Mudar o state diretamente (só via as skills que o possuem: install.sh, wizard, welcome-quick-win)

## Outputs

- Conversa que guia o utilizador
- (Indiretamente) atualizações ao state file via as skills que invocas
- Ao fechar: mostrar o dashboard com `/install-status` ou equivalente
