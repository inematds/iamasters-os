---
description: Lança a entrevista profunda de 22-25 dimensões que termina de configurar o contexto do operador. Idempotente — retoma onde ficou da última vez.
---

# /deep-dive

Lança a skill `meta-deep-dive`, que aprofunda o contexto do operador em 22-25 áreas que o wizard inicial não cobriu: ritmos pessoais, saúde financeira do negócio, equipa, decisões pendentes, metas a 3 anos, medos, métricas e definição pessoal de sucesso.

## Quando executar

- Depois de instalar o iAmasters OS (o wizard inicial recomenda-te)
- Quando o sistema te avisar em `/start-here` que está pendente
- Quando os outputs do sistema começarem a sentir-se genéricos e quiseres aprofundar
- Após uma mudança importante no teu negócio ou vida pessoal (relançar refresca o contexto)

## Como funciona

- Demora ~25-30 minutos
- É conversacional, não formulário — as perguntas adaptam-se às tuas respostas
- Idempotente — se a pausares, retomas onde ficaste
- Branching condicional — se trabalhas sozinho, o bloco equipa reduz-se a 2 perguntas

## Process

1. Se `~/.claude/skills/_operator-state.json` tem `needsOnboarding: true` → **não executar**. Avisa o utilizador: *"Primeiro passamos pelo onboarding inicial. Executa o que o Claude te disse ao instalar."*
2. Se `deepDiveCompleted: true` e o utilizador não pediu explicitamente para refinar → **avisa**: *"Já completaste o deep-dive. Se queres refinar respostas concretas, diz-me quais."*
3. Se `deepDiveProgress` existe (pausa anterior) → invoca `meta-deep-dive` em modo retomar.
4. Em qualquer outro caso → invoca `meta-deep-dive` em modo arranque.

## Output

Ao terminar, os ficheiros `context/me.md`, `soul.md`, `work.md`, `team.md`, `current-priorities.md`, `goals.md` ficam ampliados com secções novas. `operator-state.deepDiveCompleted: true`.
