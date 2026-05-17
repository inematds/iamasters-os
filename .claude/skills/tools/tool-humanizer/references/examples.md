# Exemplos tool-humanizer

## Exemplo 1 · LinkedIn post

### Input (score 4.0)

> 🚀 In today's fast-paced world, AI is fundamentally transforming how businesses operate.
>
> It's not just about automation — it's about empowering teams to leverage cutting-edge technology and unlock unprecedented value.
>
> Here are 3 ways to navigate this shift:
>
> 1. **Embrace innovation** — adopt new tools that streamline workflows
> 2. **Foster collaboration** — break down silos across departments
> 3. **Elevate your team** — invest in continuous learning and upskilling
>
> Remember: it's not the technology, it's the mindset.
>
> What's your take? Drop a comment below! 💡✨ #AI #Innovation #FutureOfWork #Transformation #Leadership

### Análise

| Detector | Hits | Penalty |
|---|---:|---:|
| Frase-muleta "in today's fast-paced world" | 1 | -1.0 |
| Verbo sobreusado "leverage", "empower", "unlock", "streamline", "elevate", "navigate", "foster" | 7 | -3.5 |
| Abuso de em-dash | 3 | -2.0 |
| Regra de 3 abusada | 2 (lista + fecho) | -1.5 |
| Negação-afirmação "it's not X, it's Y" | 2 | -1.0 |
| Triplo emoji | 1 (🚀💡✨) | -2.0 |
| Hashtags excessivas | 5 | -1.0 |
| Conclusão óbvia | 1 ("Remember...") | -1.0 |

**Score: 0/10** (clamp). Output: completamente IA.

### Versão humanizada

> Llevo 3 años montando IA en empresas y he visto patrón claro:
>
> Las que se obsesionan con la herramienta, fracasan.
> Las que se obsesionan con el problema, ganan.
>
> Lo que hace que un proyecto IA aterrice no es Claude, n8n o ChatGPT. Es alguien dentro de la empresa que conozca el dolor real y empuje desde dentro.
>
> Sin esa persona, ninguna herramienta sobrevive 6 meses.
>
> Lo que sí cambió en mis últimos 5 proyectos: dedicar 2 semanas a pelear el "qué automatizamos" antes de tocar "con qué". Nadie quiere hacerlo, pero ahorra meses después.
>
> ¿Tú cómo decides qué automatizar primero?

### Principais alterações

- Eliminado emoji no início
- "In today's fast-paced world" → contexto pessoal específico ("Llevo 3 años...")
- Verbos abstratos → verbos concretos ("aterrice", "pelear", "ahorra")
- Em-dashes → pontos
- Regra de 3 → estrutura de contraste com 2 pontos
- Negação-afirmação reduzida a 1 (continua a ser retórica útil quando não se abusa)
- Triplo emoji → 0 emojis
- Hashtags → 0
- "Remember: ..." → pergunta aberta no fim
- Adicionados números concretos ("3 años", "5 proyectos", "2 semanas", "6 meses")

**Score pós-rewrite: 9.0/10** ✓

---

## Exemplo 2 · Email de proposta a cliente

### Input (score 5.5)

> Estimado Juan,
>
> Espero que este email te encuentre bien. Me complace presentarte una propuesta integral diseñada para transformar tus procesos operativos y desbloquear todo el potencial de tu equipo.
>
> Como hemos discutido, en el mundo actual de la transformación digital, es fundamental aprovechar las herramientas de IA de vanguardia para optimizar workflows, fomentar la colaboración y elevar la productividad de manera holística.
>
> Nuestra propuesta abarca 3 pilares fundamentales:
>
> - **Implementación robusta** — desplegamos una solución sin fisuras
> - **Capacitación integral** — formamos a tu equipo de manera comprehensiva
> - **Soporte continuo** — acompañamos en cada paso del journey
>
> Quedo a tu disposición para resolver cualquier duda.
>
> Un saludo cordial,
> [Nombre]

### Análise

| Detector | Hits | Penalty |
|---|---:|---:|
| Frase-muleta "espero que este email te encuentre bien" | 1 | -1.0 |
| "Me complace presentarte" / "Me complace" | 1 | -0.5 |
| Frase-muleta "en el mundo actual" | 1 | -1.0 |
| Verbo sobreusado: aprovechar, optimizar, fomentar, elevar, transformar, desbloquear | 6 | -3.0 |
| Adjetivos vazios: integral (x3), holístico, robusto, sin fisuras, comprehensiva, continuo, vanguardia | 9 | -4.5 |
| Em-dash | 3 | -2.0 |
| Regra de 3 (3 pilares) | 1 | -0.5 |

**Score: 0/10** (slop muito típico de proposta).

### Versão humanizada

> Hola Juan,
>
> Tras nuestra reunión del martes, he aterrizado la propuesta. Te la resumo en lo que importa:
>
> **Qué te entrego**
> 1. Implementación del sistema de IA para tu proceso de admisión (4 semanas)
> 2. Formación a tu equipo de 5 personas (2 sesiones de 2h)
> 3. Soporte de 30 días post-go-live (Slack + 1 llamada semanal)
>
> **Qué no incluye** (para que no haya sorpresas):
> - Migración de datos antiguos (presupuesto aparte si lo necesitas)
> - Integración con tu CRM actual (lo evaluamos en semana 2)
>
> **Inversión**: 8.500€ + IVA. Pagable 50% al inicio + 50% al go-live.
>
> Si te encaja, te paso el contrato esta semana. Si tienes dudas, responde a este email o llámame al 600 123 456.
>
> Un abrazo,
> [Nombre]

### Principais alterações

- Saudação formal vazia → direta, contextualizada ("tras nuestra reunión del martes")
- Linguagem abstrata → entregáveis concretos com tempos
- Adicionado "qué no incluye" (humano honesto, não o faria IA por defeito)
- Investimento e forma de pagamento explícitos (não "ROI demonstrado e proposta competitiva")
- Fecho com opções reais ("contrato esta semana" ou "responde / llámame al X")
- Sem frases-muleta de fecho formal ("quedo a tu disposición")

**Score pós-rewrite: 9.5/10** ✓

---

## Exemplo 3 · Blog post intro

### Input (score 6.0)

> ## How AI is Reshaping the Modern Workplace
>
> In today's rapidly evolving digital landscape, organizations are increasingly recognizing the transformative power of artificial intelligence. As we navigate this paradigm shift, it's becoming crystal clear that AI is not merely a buzzword — it's a fundamental force that's reshaping how we work, collaborate, and innovate.
>
> In this post, we'll delve into 3 key areas where AI is making significant impact:

### Análise

| Detector | Hits | Penalty |
|---|---:|---:|
| Frase-muleta "in today's rapidly evolving" | 1 | -1.0 |
| Frase-muleta "delve into" | 1 | -1.0 |
| Adjetivos vazios: transformative, evolving, modern | 3 | -1.5 |
| Verbos sobreusados: navigate, reshape | 2 | -1.0 |
| Negação-afirmação "not merely a buzzword" | 1 | -0.5 |

**Score: 5/10**.

### Versão humanizada

> ## Cómo está cambiando el trabajo con IA (3 patrones que veo en clientes reales)
>
> Llevo 18 meses implementando IA en pequeñas empresas españolas: gestorías, agencias, consultoras de 5-30 personas.
>
> No vengo a contarte que la IA es revolucionaria. Vengo a contarte qué funciona y qué no, basado en 23 proyectos que vi de cerca.
>
> Lo que sí está cambiando: 3 patrones concretos que se repiten.
>
> 1. ...

### Principais alterações

- Headline genérico → headline com número e promessa específica
- "In today's evolving landscape" → contexto pessoal ("18 meses... 23 proyectos")
- Promessa abstrata → promessa específica (o que funciona e o que não)
- Eliminada a frase "not merely a buzzword"
- Tom autoral estabelecido na frase 1 ("llevo, vi, vengo")

**Score pós-rewrite: 9.0/10** ✓

---

## Notas para o detector

- Em espanhol, "delve into" não aparece mas sim "profundizar en", "adentrarse en"
- "Holístico" é um tell castelhano sem equivalente direto em inglês (o termo existe mas a IA sobreusa-o só em espanhol)
- "Aprovechar el potencial" = literal de "leverage potential" — um dos mais óbvios
- Os emojis 🚀💡✨🔥 no início ou fim são tells fortes no LinkedIn ES
