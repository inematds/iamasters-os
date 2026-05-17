# Instalação do iAmasters OS

## Prerequisitos

- **Claude Code CLI** instalado e autenticado com plano Pro ou Max → https://claude.ai/code
- **Node.js 18+** → https://nodejs.org
- **Python 3.9+** → https://python.org (para hooks Sinapsis)
- **Git** → https://git-scm.com

## Instalação rápida

```bash
git clone <url-repo> iamasters-os
cd iamasters-os
bash scripts/install.sh
```

O instalador:

1. Verifica prerequisitos
2. Deteta se o Sinapsis está instalado em `~/.claude/`. Se não → instala desde `vendor/sinapsis/`
3. Configura hooks do Sinapsis em `~/.claude/settings.json` (4 PreToolUse + 1 PostToolUse + 1 Stop + 1 PreCompact)
4. Inicializa a camada OS dentro do repo: cria `context/soul.md`, `context/user.md`, `context/learnings.md` com templates
5. Instala o hook local do OS: `scripts/skill-change-detector.sh`

Tempo total: ~30 segundos.

## Primeiro arranque

```bash
cd iamasters-os
claude
```

A primeira vez, o Claude Code:

1. Lê o `CLAUDE.md` raiz do repo
2. Deteta que é primeiro arranque (operator-state vazio)
3. Invoca automaticamente a skill `meta-onboarding-wizard`
4. Pergunta-te avatar/nível/domínio/stack em 7 perguntas (~3 min)
5. Configura defaults inteligentes
6. Propõe-te fazer o brand-voice setup (~5-10 min com o teu site/LinkedIn)

Depois disto, já podes trabalhar normalmente.

## Verificação

Para confirmar que tudo está bem:

```bash
ls ~/.claude/skills/         # Sinapsis instalado: devias ver _catalog.json, etc.
ls -la                        # Repo: CLAUDE.md, .claude/, brand-context/, etc.
```

Dentro do Claude Code:

```
/system-status     # dashboard Sinapsis (engine)
/start-here        # ritual de início do OS
```

## Troubleshooting

### "Sinapsis não se instalou corretamente"
- Verifica que `vendor/sinapsis/` existe e não está vazio
- Executa manualmente: `cd vendor/sinapsis && bash install.sh`

### "Claude Code não encontrado"
- Garante que `claude` está no teu `$PATH`
- Reinstalar: https://claude.ai/code

### "Permission denied" em scripts
- `chmod +x scripts/*.sh`

### Onboarding não se lança ao abrir o Claude Code
- Verifica `~/.claude/skills/_operator-state.json` — se tiver `needsOnboarding: true` e mesmo assim não se lança, lê o CLAUDE.md raiz para verificar que a secção "MANDATORY first action" está intacta.

## Update para versão nova

```bash
cd iamasters-os
git pull
bash scripts/update.sh    # (em v0.3.0+)
```

O `update.sh` trata conflitos quando upstream e local modificaram os mesmos ficheiros. Verás detalhado na v0.3.0.

## Desinstalação

```bash
# Backup primeiro
cp -r ~/.claude ~/.claude.backup

# Eliminar Sinapsis (opcional - podes estar a usar noutros repos)
rm -rf ~/.claude/skills/_*
rm -rf ~/.claude/skills/sinapsis-*
rm -rf ~/.claude/skills/skill-router

# Eliminar o repo (cuidado: apaga brand-context e projects!)
# Melhor: simplesmente não o uses mais
rm -rf iamasters-os
```
