# Brand Context

Camada estática da marca do operador. Preenche-se durante o onboarding (skill `marketing-brand-voice`).

## Estrutura

- `voice/voice-profile.md` — descrição da voz (tom, vocabulário, no-go)
- `voice/samples.md` — frases representativas extraídas
- `voice/register-a-formal.md` — registo formal (email cliente premium)
- `voice/register-b-divulgativo.md` — registo divulgativo (LinkedIn, blog)
- `voice/register-c-cercano.md` — registo próximo (WhatsApp, comunidade)
- `positioning/positioning.md` — ângulo, mercado, diferencial
- `icp/icp.md` — perfil cliente ideal: dor, linguagem, buying triggers
- `assets/` — logos, cores, fontes (auto-extraído por Firecrawl se disponível)

## Quando se atualiza

- No onboarding inicial → gera tudo de zero com interview + Firecrawl
- Quando muda o teu posicionamento → re-executa `marketing-positioning`
- Quando refinas voice após feedback → edita `voice-profile.md` diretamente ou re-executa `marketing-brand-voice` com flag `refine: true`

## Importante

Esta pasta está no `.gitignore` por defeito (os ficheiros preenchidos são privados do operador). Os ficheiros `.gitkeep` e este README são commitados.
