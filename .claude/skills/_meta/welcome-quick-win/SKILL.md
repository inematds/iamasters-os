---
name: welcome-quick-win
description: Gera o primeiro entregável do utilizador em 5 minutos após o onboarding. Pede o seu URL público (LinkedIn / web), executa análise de posicionamento, produz 3 hooks LinkedIn e plano de 3 ações para a semana, tudo empacotado em HTML autocontido e partilhável. Invoca-se automaticamente no fim do onboarding wizard ou à mão via `/welcome`. É a skill que entrega o "primeiro wow" do OS.
---

# welcome-quick-win

## Quando é invocada

- Automaticamente ao terminar `meta-onboarding-wizard` (se a flag `welcomeCompleted: false` em `~/.claude/skills/_operator-state.json`)
- À mão quando o utilizador executa o slash command `/welcome`
- Quando o utilizador pede explicitamente: "dá-me o meu primeiro entregável", "testa o sistema", "faz uma primeira tarefa de exemplo"

## Por que importa

Esta é a skill que converte "acabei de instalar o sistema" em "tenho algo concreto no ecrã, bonito, que se pode partilhar". É o momento crítico de adoção — o avatar não técnico decide aqui se o sistema lhe serve ou se o abandona. **O teu trabalho é entregar valor real em 5 minutos sem fricção.**

## Process

### Passo 1 · Pedir o URL público

Mensagem exata ao utilizador (português, direto, caloroso):

```
Vamos fazer o teu primeiro entregável. Preciso de um URL público teu
onde se veja o que fazes profissionalmente. Pode ser:

• O teu LinkedIn (https://linkedin.com/in/o-teu-perfil)
• A tua web pessoal ou do teu negócio
• Um link para o teu portfolio, About me, ou página de serviços

Cola-me UM URL.
```

Se o utilizador responder "não tenho nada público":

- Pede-lhe um parágrafo: "Conta-me em 3-5 frases o que fazes, para quem, e qual é o teu diferencial."
- Salta para o Passo 3 com esse texto como input direto.

### Passo 2 · Extrair conteúdo do URL

Invoca `tool-firecrawl-scraper` com o URL recebido.

**Se falhar** (sem API key, domínio bloqueado, timeout):
- Reporta ao utilizador: "Não consegui ler o teu URL automaticamente."
- Pede-lhe que cole à mão: "Copia 2-3 parágrafos chave da tua página (About, serviços, descrição)."
- Continua com esse texto como input.

**Se tiver sucesso**: extrai:
- Título / headline / hero text
- Secção "About" ou equivalente
- Serviços ou produtos
- Tom geral (formal / próximo / divulgativo)

Guarda o conteúdo scraped na variável temporária `scraped_content` para os passos seguintes.

### Passo 3 · Análise de posicionamento

Invoca `marketing-positioning` com `scraped_content` como input.

Espera que te devolva pelo menos:
- **Quem és** (1 frase)
- **Para quem trabalhas** (ICP em 1 frase)
- **Que problema resolves** (1 frase)
- **Porquê tu vs outros** (diferencial em 1-2 frases)
- **Score de clareza de posicionamento** (1-10) com 1-2 oportunidades de melhoria

Se `marketing-positioning` falhar ou devolver algo incompleto, gera tu próprio uma análise de posicionamento básica seguindo essa estrutura, baseado em `scraped_content`.

### Passo 4 · Gerar 3 hooks LinkedIn

Baseado na análise de posicionamento + `scraped_content`, gera 3 hooks de post LinkedIn que o utilizador podia publicar esta semana.

Cada hook deve:
- **Começar com frase curta** (≤12 palavras) que pare o scroll
- **Ligar a uma dor do ICP** (não "eu eu eu")
- **Ter um POV claro** (opinião, não descrição genérica)
- **Estar em português natural**, sem AI-tells (em-dashes estranhos, "navegar", "abraçar", "desbloquear")
- Comprimento máximo do hook: 2 linhas (não o post completo, só o gancho)

Se existir `brand-context/voice/voice-profile.md` carrega-o e aplica o tom. Se não existir, usa registo divulgativo neutro e avisa o utilizador que poderá personalizar depois com `marketing-brand-voice`.

### Passo 5 · Plano da semana — 3 ações concretas

Gera 3 ações específicas que o utilizador pode fazer esta semana baseadas no que viste na análise. Formato:

| # | Acción | Tiempo | Output esperado |
|---:|---|---|---|
| 1 | (verbo + qué hacer) | (15 min / 30 min / 1h / 2h) | (qué tendrá al terminar) |
| 2 | ... | ... | ... |
| 3 | ... | ... | ... |

As ações devem ser:
- **Executáveis sem contratar ninguém** (o utilizador fá-las sozinho)
- **Com output verificável** (não "refletir sobre X")
- **Ligadas ao diagnóstico de posicionamento** (atacam as oportunidades detetadas)

### Passo 6 · Empacotar tudo em HTML autocontido

Se a skill `tool-visual-explainer` estiver disponível no repo, invoca-a com um brief do conteúdo. Se não, gera HTML inline seguindo este esqueleto:

- HTML5 válido, uma só página, sem dependências externas (sem CDN)
- CSS embebido em `<style>` — sem JS (partilhável por WhatsApp)
- Tipografia: system stack (`-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`)
- Paleta sóbria: branco/cinza muito claro de fundo, preto/cinza escuro texto, 1 cor de destaque (laranja `#ff8c42` que é a paleta iAmasters Academy)
- Estrutura visual:
  1. Hero com título "O teu primeiro entregável · iAmasters OS" + data
  2. Bloco "O teu posicionamento neste momento" com a análise
  3. Bloco "3 hooks LinkedIn para esta semana"
  4. Bloco "Plano dos próximos 7 dias" (a tabela)
  5. Footer pequeno: "Gerado por iAmasters OS · [iamastersacademy.com](https://iamastersacademy.com)"

O HTML deve ver-se **bonito no telemóvel** (max-width responsive, padding generoso) porque é provável que se partilhe por WhatsApp.

Guarda em: `projects/welcome/<YYYY-MM-DD>-tu-primer-entregable.html`

### Passo 7 · Mensagem final ao utilizador

Após guardar o ficheiro, mostra ao utilizador:

```
🎉 O teu primeiro entregável está pronto:
projects/welcome/<YYYY-MM-DD>-tu-primer-entregable.html

Abre-o no teu navegador. É totalmente partilhável — cola-o no
WhatsApp ou na comunidade iAmasters Skool se gostaste.

O que fazemos agora?

  1. Configurar o teu Brand Voice completo (10 min mais, recomendado)
  2. Executar outra skill (sugiro `marketing-copywriting`)
  3. Fechar sessão por hoje com `/wrap-up`
```

Espera resposta do utilizador antes de fazer mais nada.

### Passo 8 · Marcar como completado e aprender

1. Edita `~/.claude/skills/_operator-state.json` e põe `welcomeCompleted: true` (para que não se volte a disparar automaticamente).
2. Append em `context/learnings.md` em `## welcome-quick-win`:
   ```
   - <data>: completado para <nome do utilizador>. URL usado: <url>.
     Score posicionamento inicial: <X>/10.
   ```
3. Se a skill detetou algo notável (URL muito técnico, ICP pouco definido, tom incoerente), propõe no wrap-up um projeto seguinte que ataque essa falha.

## Outputs

- `projects/welcome/<YYYY-MM-DD>-tu-primer-entregable.html` — entregável partilhável
- Update em `~/.claude/skills/_operator-state.json` (`welcomeCompleted: true`)
- Append em `context/learnings.md`

## Skills que chama

- **`tool-firecrawl-scraper`** — para extrair conteúdo do URL público (Passo 2)
- **`marketing-positioning`** — para a análise de posicionamento (Passo 3)
- **`tool-visual-explainer`** (se disponível) — para empacotar HTML (Passo 6); fallback HTML inline
- **`tool-output-verifier`** (opcional) — para verificar a quality do HTML antes de entregar; se não se detetar AI-slop em hooks LinkedIn, omitir

## Edge cases

- **Sem URL público**: pedir parágrafo descritivo, saltar Passo 2.
- **Firecrawl sem API key ou falha**: pedir ao utilizador que cole conteúdo à mão.
- **LinkedIn rejeita scraping (robots.txt ou redirecionamento para login)**: pedir export manual do perfil ou parágrafo descritivo.
- **`marketing-positioning` não disponível**: fazer análise tu próprio seguindo a estrutura do Passo 3.
- **`tool-visual-explainer` não instalado**: gerar HTML inline (esqueleto do Passo 6).
- **Sem `brand-context/voice/voice-profile.md`**: usar registo divulgativo neutro + aviso ao utilizador.
- **Utilizador demora muito a responder ao Passo 1 (>2 min sem resposta)**: NÃO insistir, esperar.
- **Plan Anthropic Free**: provável que a skill esgote contexto. Detetar antes e avisar: "Esta skill funciona melhor com Pro/Max. Continuas ou deixamos?"

## Examples

Ver `references/examples.md` para 2 exemplos completos:
1. Utilizador freelancer com LinkedIn público (caso ideal)
2. Utilizador empresário sem web própria (fallback parágrafo descritivo)

## Notas de design

- Esta skill é **o momento da verdade** do OS. Se falhar, o utilizador abandona. Por isso tem fallbacks em cada passo.
- O HTML output é deliberadamente partilhável (sem JS, mobile-first) — converte o output pessoal em objeto social que circula pela comunidade.
- Não se invoca `tool-output-verifier` por defeito para não adicionar tempo ao primeiro wow; se o utilizador pedir depois, sim.
- Se o utilizador tiver Brand Voice já configurado, os hooks LinkedIn são gerados na sua voz; se não, em voz neutra com aviso.
