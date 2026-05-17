---
name: cognito
description: Sistema Operativo de Pensamento de Luis Pitik. Orquestra 7 modos cognitivos (divergente, verificador, devil's advocate, consolidador, executor, estratega, auditor) segundo 5 fases de projeto (discovery, planning, execution, review, shipping). Esta skill vive vendored em `vendor/cognito/` (intacta) e instalada globalmente em `~/.claude/skills/cognito/` pelo installer. ATIVAR SEMPRE que a conversa envolva decisões com trade-offs, mudanças de abordagem, análise profunda, mudanças de fase explícitas, ou deteção de âncora. Coexiste com Sinapsis sem conflito.
version: 1.0.0
---

# cognito (vendored wrapper)

> **Origem**: [github.com/Luispitik/cognito](https://github.com/Luispitik/cognito) por Luis Pitik.
> **Vendored em**: `vendor/cognito/` (mantida intacta — sem modificações).
> **Instalada globalmente**: `~/.claude/skills/cognito/` (a copia o `install.sh` se não existir).

## O que é

Cognito é um sistema operativo cognitivo independente que orquestra 7 modos de pensamento segundo 5 fases de projeto. iAmasters OS vendora-a **intacta** porque é um produto separado do Luis com o seu próprio versionamento, testes e documentação.

## Como se carrega

A skill REAL vive em `~/.claude/skills/cognito/SKILL.md` (instalação global de Sinapsis-style). O installer copia-a a partir de `vendor/cognito/` na primeira vez.

**Quando Claude Code ativa a skill `cognito`, lê `~/.claude/skills/cognito/SKILL.md`** — não este ficheiro. Este wrapper só existe para:

1. Documentar que a skill está disponível no OS
2. Manter o padrão de "uma pasta por skill em `.claude/skills/_meta/`"
3. Permitir que `find-skills` e `health-check` a detetem no inventário

## Modos cognito (resumo)

Para detalhe completo, ver `~/.claude/skills/cognito/SKILL.md` ou `vendor/cognito/SKILL.md`.

- **Divergente** — explora alternativas, evita convergência prematura
- **Verificador** — verifica pressupostos, valida dados
- **Devil's advocate** — ataca o plano para descobrir buracos
- **Consolidador** — sintetiza, junta fios
- **Executor** — converte plano em passos acionáveis
- **Estratega** — visão a longo prazo, encaixe no sistema maior
- **Auditor** — revisão crítica final antes de fechar

## Modos segundo fase

- **Discovery**: divergente + verificador
- **Planning**: estratega + devil's advocate
- **Execution**: executor + verificador
- **Review**: auditor + consolidador
- **Shipping**: executor + auditor

## Modo guiado vs completo

iAmasters OS adiciona UMA camada sobre cognito: durante o onboarding, `meta-onboarding-wizard` pergunta se queres modo **guiado** (4 modos essenciais auto-escolhidos por contexto) ou **completo** (os 7 modos × 5 fases = 35 combinações disponíveis para escolher à mão).

A preferência guarda-se em `~/.claude/skills/_operator-state.json` como `cognitoMode: "guiado" | "completo"`.

Podes mudar a qualquer momento: `/cognito-mode <guiado|completo>` (se o comando estiver disponível) ou editando à mão o operator-state.

## Skills que chama

Cognito pode invocar skills que detetam modos auto-triggered. Não as nomeamos aqui porque vivem no seu próprio sistema.

## Edge cases

- **Cognito não instalada globalmente**: o installer copia-a a partir de `vendor/cognito/`. Se falhar, executa à mão:
  ```bash
  cp -r vendor/cognito ~/.claude/skills/cognito
  ```
- **Conflito com Sinapsis**: NÃO há. Ambas as skills coexistem com scopes distintos (Sinapsis = memória, cognito = raciocínio).
- **Modo guiado mas utilizador quer ver opções**: aceitar override por turno com `/modo <nome>`.

## Crédito

Skill da autoria de **Luis Pitik** ([github.com/Luispitik](https://github.com/Luispitik)). iAmasters OS usa-a com respeito pelo padrão "vendoring intacto" + atribuição completa. Ver `vendor/cognito/LICENSE` e `vendor/cognito/AUTHORS.md`.
