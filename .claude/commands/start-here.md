---
description: Ritual de início de sessão iAmasters OS. Carrega contexto, recapitula pendentes, propõe tarefa do dia.
---

# /start-here

Invoca a skill `meta-start-here` que vive em `.claude/skills/_meta/meta-start-here/SKILL.md`.

## O que faz

1. Lê operator-state global (Sinapsis) e user.md (repo)
2. Verifica se há daily summary de ontem em `synapsis/daily-summaries/`
3. Lista projetos abertos em `projects/briefs/`
4. Saúda com resumo + proposta de tarefa para hoje

Se é primeiro arranque (não há operator-state ou user.md vazio), automaticamente deriva para `meta-onboarding-wizard`.

## Comando

Carrega e invoca a skill `meta-start-here`. Segue o processo do SKILL.md passo a passo.
