# Showcase — O que o iAmasters OS consegue gerar

Esta pasta contém **4 outputs reais gerados pelo sistema** com dados sintéticos. Servem como referência visual de que tipo de resultados podes esperar antes de gerar os teus.

## Caso unificado

Todos os outputs partilham um caso de uso fictício para que se entenda a coerência do sistema quando trabalha com brand context próprio:

> **Marta Sánchez** — Consultora IA independente para PMEs.
> Trabalha com **Logística do Norte SL** (transporte e distribuição, 80 colaboradores, Aragão).
> Brief: ajudá-los a automatizar a gestão de guias de transporte e o seguimento de incidências.

## Os 4 outputs

| # | Output | Skill que o gerou |
|---|---|---|
| 01 | Post LinkedIn a anunciar o projeto | `marketing-copywriting` + `tool-visual-explainer` |
| 02 | Sequência de 5 emails de boas-vindas para novos leads | `marketing-email-sequence` |
| 03 | Resumo executivo de reunião de kick-off | `tool-visual-explainer` (input: transcrição) |
| 04 | Proposta comercial premium (HTML branded) | `marketing-copywriting` + `tool-visual-explainer` |

## Como lê-los

Cada output tem o seu `preview.html` — abre-o no browser. Os HTMLs são **autocontidos** (sem dependências externas, sem JS), pelo que podem ser enviados por WhatsApp/Telegram/email e veem-se iguais.

## Remover este showcase

Se quiseres limpar antes de começar a trabalhar a sério:

```bash
rm -rf projects/_showcase/
```

Não afeta nada do sistema. É puramente material de referência.
