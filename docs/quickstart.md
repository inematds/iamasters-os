# Quickstart — primeiros 30 minutos com o iAmasters OS

> Para alguém que clonou o repo, executou `bash scripts/install.sh` e abriu o Claude Code no repo.

## Minuto 0-5 · Onboarding

O Claude Code lança-te o wizard automaticamente. 7 perguntas:

1. Avatar (single business / freelance / agência / formador)
2. Nível técnico (zero / intermédio / avançado)
3. Domínio principal (marketing / operations / strategy / dev / misto)
4. Stack atual (multi-select)
5. Idioma de outputs cliente (se aplicável)
6. Firecrawl API key (opcional mas recomendado)
7. Identidade básica (nome, email, site/LinkedIn)

Output: `~/.claude/skills/_operator-state.json` e `context/user.md` preenchidos.

## Minuto 5-15 · Brand voice (opcional mas recomendado)

Se disseste sim ao brand voice:

- Cola os teus URLs públicos (site, LinkedIn, YouTube, blog)
- Firecrawl scraping → extrai voice samples
- O Claude analisa padrões da tua voz
- Gera `brand-context/voice/voice-profile.md` + 3 registos (A/B/C)
- Gera `brand-context/positioning/positioning.md` e `brand-context/icp/icp.md`

Output: a tua marca fica "instalada" no OS. Qualquer skill marketing-* usá-la-á automaticamente.

## Minuto 15-25 · Primeira tarefa real

Pede algo concreto. Exemplos:

```
"Escreve 3 versões de post LinkedIn sobre <tema>"
→ O Claude usa marketing-copywriting com o teu voice profile

"Faz repurpose desta aula do Café Camaleónico para redes"
→ marketing-content-repurposing

"Gera um HTML partilhável a explicar esta decisão"
→ tool-visual-explainer
```

## Minuto 25-30 · Wrap-up

Antes de fechar:

```
/wrap-up
```

O Claude:
- Gera daily summary em `synapsis/daily-summaries/<TODAY>.md`
- Atualiza skills registry se adicionaste alguma
- Propõe git commit (aceita ou rejeita)
- Diz-te o que começar amanhã ao voltar

## Próximos dias

Quando voltares a abrir o Claude Code no repo:

```
/start-here
```

Recapitula-te o de ontem + propõe tarefa do dia. A memória persiste — acabou o "explica-me a tua stack outra vez".

## Comandos básicos

| Comando | O que faz |
|---|---|
| `/start-here` | Ritual de início (resumo + proposta) |
| `/wrap-up` | Fecho de sessão + commit |
| `/add-client` | Criar cliente novo (multi-cliente) |
| `/system-status` | Dashboard Sinapsis (engine) |
| `/evolve` | Promover instincts aprendidos a permanentes |
| `/eod` | End of day multi-projeto (Sinapsis) |
| `/dashboard-sinapsis` | Visualização da aprendizagem do sistema |

## Quando NÃO usar o OS

- Editar o código da tua app → abre o Claude Code na pasta da app, não neste repo
- Sessão exploratória que não queres sujar memória → modo vanilla noutra pasta
- Tarefa ultracurta (<2 min) → mais fricção que valor

## Próxima leitura

- `docs/multi-client-guide.md` (em v0.3.0) — fluxo completo de servir N clientes
- `docs/skill-creation-guide.md` — criar as tuas próprias skills seguindo o padrão
- `docs/synapsis-overview.md` — entender o que o engine de memória faz
