# Context

Camada dinâmica que evolui com o uso do OS. Aqui vive tudo o que muda com o tempo: identidade do operador, decisões tomadas, lições aprendidas.

## Ficheiros

- `soul.md` — personalidade do agente (como responde, boundaries). Estática, editas tu.
- `user.md` — perfil do operador no repo (preferências, stack do dia a dia). Preenche-se no onboarding e vai crescendo.
- `learnings.md` — feedback consolidado por skill, em formato human-readable.
- `daily-memory/<YYYY-MM-DD>.md` — sessões do dia com goal/done/pending/decisions.

## Diferença com o Sinapsis

O Sinapsis (em `~/.claude/skills/_*.json`) guarda o contexto **global do operador** que se aplica a todos os projetos.

Este `context/` guarda o contexto **específico do repo iAmasters OS** que só se aplica aqui (decisões que tomaste sobre a tua marca, learnings de skills próprias, etc.).

## Privacidade

`user.md`, `daily-memory/` estão no `.gitignore`. Só `soul.md`, `learnings.md` (genérico) e este README vão para o git.
