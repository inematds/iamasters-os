---
description: Instala uma skill desde URL de GitHub com validação local prévia. Anti-inflação: verifica estrutura antes de globalizar.
---

# /install-skill

Instala uma skill externa desde GitHub no repo local com validação prévia de estrutura.

## Uso

```
/install-skill <github-url>
/install-skill <nome-skill-opcional>
```

Exemplos:
- `/install-skill https://github.com/scrapes/skills/humanizer`
- `/install-skill https://github.com/anthropics/skills/copywriting`
- `/install-skill cognito` (atalho para skill local em `_optional/`)

## Modo "atalho opcional" (sem URL)

Se o argumento NÃO é URL mas um nome simples (ex. `cognito`):

1. Procurar a skill em `.claude/skills/_meta/_optional/<nome>/`.
2. Se existe:
   - Mover para `.claude/skills/_meta/<nome>/`
   - Atualizar CLAUDE.md skills registry (secção `_meta/` +1, `_optional/` -1)
   - Mensagem: *"Skill `<nome>` ativada. Reinicia o Claude Code para que carregue."*
3. Se NÃO existe → erro: *"Não há skill opcional `<nome>`. Skills disponíveis em `_optional/`: <lista>."*

Para desativar uma skill (movê-la de volta para `_optional/`): editar manualmente ou pedir ao operador.

## Process

### Passo 1 · Validar URL
- É URL de GitHub válida?
- Aponta para uma pasta ou ficheiro `SKILL.md`?

### Passo 2 · Descarregar para temporário

Executa `bash scripts/validate-skill.sh <url>`. O script:
1. Cria pasta temporária em `/tmp/iamasters-os-skill-validate-<hash>/`
2. Clona a URL completa ou usa `git archive` para descarregar só a subpasta
3. Lista ficheiros descarregados

### Passo 3 · Validar estrutura

O script valida:

**Obrigatório**:
- `SKILL.md` existe na raiz da skill
- YAML frontmatter presente (linhas 1-3 com `---`)
- Campo `name` presente e kebab-case
- Campo `description` presente, ≥50 chars, ≤500 chars
- `description` contém pelo menos um verbo de intenção (cria, gera, analisa, extrai, etc.)

**Recomendado** (warnings, não bloqueiam):
- Pasta `references/` presente se SKILL.md > 2500 caracteres
- `examples.md` presente em references se houver
- Skill não contém `eval()` ou execução de código sem sandbox
- Não há paths `/etc/`, `~/`, paths absolutos suspeitos
- Não há credenciais hardcoded (regex API keys, tokens)

**Bloqueantes** (rejeição automática):
- Não há SKILL.md
- YAML frontmatter mal formado
- description < 30 chars (insuficiente)
- description duplica nome de skill já instalada localmente
- Scripts `.sh` com `rm -rf /` ou similares destrutivos sem justificação

### Passo 4 · Mostrar resultado ao operador

```markdown
## Validação de skill

**URL**: https://github.com/scrapes/skills/humanizer
**Skill**: tool-humanizer (atenção: já tens uma skill local com esse nome!)
**Tamanho**: SKILL.md 2.1KB, references 4.5KB, scripts 0KB

### Validações
- ✅ SKILL.md presente
- ✅ YAML frontmatter correto
- ✅ description 187 chars (no intervalo)
- ⚠️ Conflito: já existe `.claude/skills/tools/tool-humanizer/`
- ✅ Sem código executável perigoso
- ✅ Sem credenciais hardcoded

### Ação a tomar

[1] Cancelar
[2] Substituir a tua local (com backup automático)
[3] Instalar como tool-humanizer-v2 (renomear)
[4] Ver diff vs a tua versão local
```

### Passo 5 · Instalação local

Se o operador aceita:
1. Se existe local: backup em `.backup/<timestamp>/.claude/skills/...`
2. Copiar para `.claude/skills/<categoria>/<nome>/`
3. Se a categoria é ambígua, perguntar ao operador onde categorizar (`_meta` / `marketing` / `tools` / etc.)
4. Atualizar `synapsis/skills-catalog.json` com nova entrada
5. Atualizar `CLAUDE.md` skills registry

### Passo 6 · Teste de ativação

Após instalar:
- Reiniciar o Claude Code (Ctrl+C × 2 + claude)
- Testar prompt que deveria ativar a skill (baseado na description)
- Se ativa corretamente: confirmar instalação
- Se não ativa: oferecer (a) editar description, (b) renomear, (c) desinstalar

### Passo 7 · Fecho

- Mostrar ao operador o que se instalou e onde
- Sugerir executar `/wrap-up` para que a mudança fique registada
- Append em `context/learnings.md` se a skill traz valor diferencial:
  ```
  ## install-skill
  - YYYY-MM-DD: instalada <skill> de <url>. Útil para <caso>.
  ```

## Edge cases

- **Repo privado no GitHub**: pedir ao operador token ou que a torne pública temporariamente
- **Skill duplica funcionalidade de uma local**: avisar e deixar o operador decidir se fundir ou manter ambas
- **Skill com dependências** (outra skill não instalada): avisar e perguntar se instalar dependências também
- **Skill huge** (>50KB): warning sobre token consumption — sugerir ler SKILL.md primeiro

## Implementação

Este comando chama `bash scripts/validate-skill.sh <url>` que faz todo o trabalho.
