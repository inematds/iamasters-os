# AI Tells — padrões detetáveis de escrita de IA

> Lista mantida pela comunidade. Se detetares um novo padrão em sessão, faz append aqui e propõe-no no wrap-up.

## Padrões léxicos (palavras e frases)

### Verbos sobreusados
- leverage / aprovechar
- delve into / adentrarse en
- navigate / navegar
- foster / fomentar
- streamline / optimizar
- unlock / desbloquear
- empower / empoderar
- transform / transformar (cuando se usa para todo)
- elevate / elevar
- harness / aprovechar (variante de leverage)

### Substantivos abstratos
- tapestry
- realm
- landscape (cuando es metafórico)
- ecosystem (cuando se aplica a todo)
- paradigm
- synergy / sinergia
- holistic approach
- value proposition (sobreusado)

### Adjetivos vazios
- robust / robusto
- seamless / sin fisuras
- comprehensive / completo
- innovative / innovador (cuando no aplica)
- cutting-edge / vanguardista
- state-of-the-art
- world-class
- best-in-class

### Advérbios infladores
- incredibly / increíblemente
- remarkably / notablemente
- surprisingly / sorprendentemente
- arguably / posiblemente
- indeed / ciertamente
- ultimately / en última instancia

### Frases-muleta
- "In today's fast-paced world..."
- "In the realm of..."
- "At the end of the day..."
- "It's worth noting that..."
- "It's important to note that..."
- "Needless to say..."
- "When it comes to..."
- "The fact of the matter is..."
- "In conclusion..."
- "To summarize..."
- "Moving forward..."

### Em castelhano
- "En el mundo actual..."
- "En el mundo de..."
- "Al final del día..."
- "Cabe destacar que..."
- "Es importante señalar que..."
- "Por no mencionar..."
- "Cuando se trata de..."
- "La realidad es que..."
- "En conclusión..."
- "En resumen..."
- "De cara al futuro..."

## Padrões estruturais

### Abuso de em-dash (—)
ChatGPT/Claude usam em-dash em vez de:
- vírgulas
- pontos
- parênteses
- dois-pontos

**Regra**: máx. 1 em-dash a cada 200 palavras. Mais = IA.

### Regra de 3 abusada
"X, Y, and Z" repetido parágrafo após parágrafo.

Humanos variam: 2 pontos, 4 pontos, listas não paralelas.

### Negação-afirmação
"It's not X, it's Y. It's not A, it's B."
"No se trata de X, se trata de Y."

Repetir essa estrutura 3+ vezes no mesmo bloco = IA.

### Frases todas iguais
- Mesmo comprimento (todas com 20-25 palavras)
- Mesmo arranque (todas pronomes, todas verbo)
- Mesmo ritmo (sujeito + verbo + complemento, sem variação)

### Bullet points hipersimétricos
Todos os bullets:
- começam com verbo
- têm exatamente 3 palavras de noun phrase
- terminam em ponto sem variação

### Conclusões óbvias
"In conclusion, AI is changing the world."
"En resumen, la IA está transformando todo."

Humanos fecham com anedota, pergunta ou chamada concreta.

## Padrões de tom

### Otimismo unilateral
Tudo "transforma", "revoluciona", "empodera". Sem contras, riscos, limitações.

### Hedging excessivo
"Could potentially be considered as one of the possible..."
"Quizás podría ser considerado como una opción..."

3+ hedges numa frase = IA insegura.

### Sem opinião pessoal
Frases na passiva, sem "eu", "acho", "vi", "enganei-me".

Humanos metem "eu" a cada 100-150 palavras pelo menos.

### Sem números concretos
"Many companies", "muchos", "varios", "algunos".

Humanos: "47 clientes", "23%", "três vezes em março".

## Padrões de formato

### Triplo emoji
🚀 ao início + 💡 ao meio + ✨ ao fim = IA por defeito.

Humanos: 0 emojis ou 1 emoji intencional.

### Hashtags excessivas
\#AI #MachineLearning #Innovation #FutureTech #Revolution = IA sem filtro.

Humanos: 0-3 hashtags relevantes.

### Listas com bullet point sempre que há 2+ itens
"Hay dos opciones:
- Opción A
- Opción B"

vs. humano:
"Hay dos opciones: A o B."

### Headings a cada 3 frases
Subtítulos forçados que não acrescentam hierarquia real.

## Padrões específicos do Claude

### "I'd be happy to..."
"Me encantaría ayudarte con..."

Quando aparece em outputs entregáveis ao cliente final = IA pura (é resposta de chat, não conteúdo).

### "Let me know if you need..."
"Déjame saber si necesitas..."

Estrutura de chat metida em blog/email onde não devia.

### "Here's a breakdown..."
"Aquí tienes un desglose..."

Conector típico do Claude entre secções.

## Padrões específicos do GPT

### "It's a great question!"
"¡Es una gran pregunta!"

Validação do utilizador no conteúdo.

### "Certainly!"
"¡Por supuesto!"

Affirming token no início do output.

## Como adicionar novos padrões

Se detetares um padrão de IA não listado:

1. Documenta 3+ exemplos onde aparece
2. Verifica que é predominantemente IA (não aparece em escrita humana frequente)
3. Faz append na categoria apropriada com peso de penalty
4. No wrap-up, propõe commit: "feat(humanizer): detect <padrão>"

## Pesos por categoria (para scoring)

| Categoria | Penalty por match |
|---|---:|
| Verbos/substantivos sobreusados | -0.5 |
| Adjetivos vazios | -0.5 |
| Advérbios infladores | -0.3 |
| Frases-muleta | -1.0 |
| Abuso de em-dash | -1.0 (a partir do 2.º match) |
| Regra de 3 abusada | -1.5 (se 3+ parágrafos seguidos) |
| Negação-afirmação | -1.5 (se 3+ vezes) |
| Triplo emoji | -2.0 |
| Hashtags excessivas (5+) | -1.0 |
| Conclusão óbvia | -1.0 |
