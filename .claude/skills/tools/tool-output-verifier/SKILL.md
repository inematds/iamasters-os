---
name: tool-output-verifier
description: Quality gate antes de entregar outputs ao cliente. Faz 4 checks (humanizer score, brand voice match, length per platform, factuality flags) e devolve score 0-10 com sugestões específicas. As skills marketing-* e operations-* invocam-na automaticamente como último passo. Passa ou bloqueia.
---

# tool-output-verifier

## Quando se invoca

- Skills marketing-copywriting, marketing-blog-writer, marketing-email-sequence, etc. invocam-na no seu último passo (gate obrigatório)
- O utilizador cola um texto e diz "verifica isto antes de o mandar"
- Manualmente: `/verify <path>` (slash command se for criado em versão futura)

## Process

### Passo 1 · Receber input + contexto

Input mínimo:
```json
{
  "text": "...",
  "platform": "linkedin|x|blog|email|whatsapp|landing|...",
  "purpose": "post|email-cliente|email-nurture|landing-section|..."
}
```

### Passo 2 · Check 1 · Humanizer

Invoca `tool-humanizer` em pipeline-mode.
- Threshold por plataforma:
  - linkedin/blog: humanizer ≥ 7
  - email cliente premium: humanizer ≥ 8
  - email nurture / WhatsApp comunidade: humanizer ≥ 6
  - landing page (copy comercial): humanizer ≥ 8

### Passo 3 · Check 2 · Brand Voice match

Lê `brand-context/voice/voice-profile.md` e os registers (`register-a-formal.md`, `register-b-divulgativo.md`, `register-c-cercano.md`).

Deteta o registo apropriado conforme `platform + purpose`:
- email cliente premium → A (formal)
- proposta comercial → A (formal)
- LinkedIn → B (divulgativo)
- blog → B (divulgativo)
- X/Twitter → B (divulgativo, mais curto)
- email nurture → B com um toque próximo
- WhatsApp comunidade → C (próximo)
- comentários redes → C (próximo)

Compara o texto vs registo esperado:
- Vocabulário coincide? (palavras do registo presentes vs proibidas)
- Tom coincide? (formal vs próximo)
- Comprimento de frases coincide? (formal frases longas, próximo curtas)

Score 0-10 sobre brand-voice match. Threshold: ≥ 7.

### Passo 4 · Check 3 · Length per platform

Revê limites de plataforma:

| Plataforma | Mínimo | Máximo | Ideal |
|---|---:|---:|---:|
| Twitter/X (post) | 100 chars | 280 chars | 200-260 |
| Twitter/X (thread tweet) | 100 chars | 280 chars | 220-270 |
| LinkedIn (post) | 600 chars | 3000 chars | 1200-1800 |
| LinkedIn (article) | 800 words | 2000 words | 1200-1500 |
| Blog post | 800 words | 2500 words | 1200-1800 |
| Instagram caption | 100 chars | 2200 chars | 300-700 |
| Email subject | 30 chars | 60 chars | 40-50 |
| Email body | 50 words | 600 words | 150-300 |
| WhatsApp comunidade | 50 chars | 1500 chars | 200-500 |
| Landing hero | 5 words | 12 words | 7-9 |
| Landing CTA | 2 words | 5 words | 2-3 |

Score baseado em estar dentro do intervalo ideal, aceitável ou fora.

### Passo 5 · Check 4 · Factuality flags

Detetar afirmações que requerem verificação humana:
- Estatísticas com números concretos ("47%", "tripled in 2025")
- Citações atribuídas a pessoas ou empresas
- Claims de concorrentes ou produtos
- Números de telefone, emails, URLs específicos

Por cada flag: marcar mas NÃO bloquear (o operador decide). Anotar no report.

### Passo 6 · Score combinado

```
total_score = (humanizer_score * 0.4) + (brand_voice_score * 0.4) + (length_score * 0.2)
factuality_flags = [list]
```

**Decisão final:**
- `total_score ≥ 8 AND humanizer ≥ threshold AND brand_voice ≥ 7` → ✅ passa o gate
- Se falhar qualquer threshold → ❌ não passa, sugestões para corrigir
- `factuality_flags` são sempre reportadas, não bloqueiam automaticamente

### Passo 7 · Output

```markdown
## Output Verification Report

**Overall**: 7.8 / 10 → ❌ NÃO PASSA (humanizer 6.5 < 7)

### Checks
- ✅ Length: dentro do intervalo ideal (1450 chars em LinkedIn post, ideal 1200-1800)
- ❌ Humanizer: 6.5 / 10 (3 em-dashes, "leverage" usado 2 vezes)
- ✅ Brand voice: 8.5 / 10 (registo B divulgativo correto)
- ⚠️ Factuality: 2 flags
  - "47% de melhoria em produtividade" (linha 12) — verificar fonte
  - "segundo a Gartner 2025" (linha 18) — confirmar citação

### Sugestões para subir humanizer
1. Substituir em-dashes por vírgulas ou pontos
2. Trocar "leverage" por "usar" ou "aplicar" nas linhas 4 e 9
3. Reescrever linha 7 ("Não é só X, mas também Y")

### Reescrevemos? (sim/não)
Se disseres sim, invoca tool-humanizer com max-rewrites:1.
```

### Passo 8 · Pipeline-mode (quando outra skill chama)

Se `score-only: true`, devolver só:
```json
{
  "passes_gate": false,
  "score": 7.8,
  "humanizer": 6.5,
  "brand_voice": 8.5,
  "length": 9.0,
  "factuality_flags": [...],
  "blocking_reason": "humanizer below threshold (6.5 < 7)"
}
```

A skill caller decide:
- Tentar de novo com tool-humanizer
- Aceitar o score se não for bloqueante
- Devolver ao utilizador com warning

### Passo 9 · Fecho

- Append a `context/learnings.md` se detetaste:
  - Padrão de falha recorrente numa skill ("marketing-copywriting falha sempre humanizer em email")
  - Configuração de threshold inadequada para uma plataforma

## Outputs

**Standalone**:
- `projects/tool-output-verifier/<data>-<titulo>/report.md`

**Pipeline**: JSON para o caller.

## Skills que chama

- `tool-humanizer` (sempre, passo 2)

## Edge cases

- **Não há brand-voice configurada**: skip Check 2, baixar peso para 30% humanizer + 30% brand-voice (que devolve 5 por defeito) + 40% length. Marcar warning.
- **Plataforma desconhecida**: usar defaults (humanizer ≥ 7, length flexível). Pedir ao utilizador para clarificar plataforma.
- **Texto multi-idioma**: validar cada idioma em separado, dar score médio.
- **Threshold conflicting com purpose**: ex. email "pessoal a um amigo" não requer humanizer 8. Pedir ao utilizador para confirmar purpose se humanizer falhar por threshold.

## Examples

Ver `references/examples.md` para casos completos.

## Knowledge

- `references/platform-limits.md` — tabela mantida de limites por plataforma
- `references/examples.md` — casos passa / falha / borderline
