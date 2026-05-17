---
description: Health check do iAmasters OS. Verifica ambiente, Sinapsis, brand-context, agent-context, skills, settings e propõe fixes para tudo o que esteja partido. Executa a skill `health-check` e devolve um relatório 🟢🟡🔴 com ações concretas.
---

Executa a skill `_meta/health-check` seguindo todos os passos ao detalhe.

Ao terminar, apresenta os resultados ao utilizador no formato:

```
🟢 OK — <componente>
🟡 AVISO — <componente> · <motivo> · ação sugerida
🔴 ERRO — <componente> · <motivo> · ação concreta para arranjar
```

Se houver erros 🔴, propõe ao utilizador executar o fix automático quando existir. Se o fix requer comando, mostra-o e pede confirmação antes de o correr.

Se tudo está 🟢, lembra ao utilizador que projetos tem abertos em `projects/briefs/*/brief.md` com `status: active` e propõe continuar com um.
