# Referência de Tipos de Email

Guia abrangente para emails de lifecycle e de campanha. Usa isto como checklist de auditoria e referência de implementação.

## Conteúdos
- Emails de Onboarding (série de novos utilizadores, série de novos clientes, lembrete de passo crítico de onboarding, convite de novo utilizador)
- Emails de Retenção (upgrade para pago, upgrade para plano superior, pedir avaliação, oferecer suporte de forma proativa, relatório de utilização do produto, inquérito NPS, programa de referrals)
- Emails de Billing (mudar para anual, recuperação de pagamento falhado, inquérito de cancelamento, lembrete de renovação próxima)
- Emails de Utilização (resumo diário/semanal/mensal, notificações de eventos-chave ou milestones)
- Emails de Win-Back (trials expirados, clientes cancelados)
- Emails de Campanha (roundup mensal/newsletter, promoções sazonais, atualizações de produto, roundup de notícias da indústria, atualização de preços)
- Checklist de Auditoria de Email (onboarding, retenção, billing, utilização, win-back, campanhas)

## Emails de Onboarding

### Série de Novos Utilizadores
**Trigger**: Utilizador faz signup (gratuito ou trial)
**Objetivo**: Ativar o utilizador, levar ao momento "aha"
**Sequência típica**: 5-7 emails ao longo de 14 dias

- Email 1: Boas-vindas + um único passo seguinte (imediato)
- Email 2: Quick win / como começar (dia 1)
- Email 3: Destaque de funcionalidade-chave (dia 3)
- Email 4: História de sucesso / prova social (dia 5)
- Email 5: Check-in + oferta de ajuda (dia 7)
- Email 6: Dica avançada (dia 10)
- Email 7: Prompt de upgrade ou próximo milestone (dia 14)

**Métricas-chave**: Taxa de ativação, adoção de funcionalidades

---

### Série de Novos Clientes
**Trigger**: Utilizador converte para pago
**Objetivo**: Reforçar a decisão de compra, impulsionar a adoção, reduzir churn precoce
**Sequência típica**: 3-5 emails ao longo de 14 dias

- Email 1: Obrigado + o que vem a seguir (imediato)
- Email 2: Obter valor total — checklist de setup (dia 2)
- Email 3: Dicas pro para funcionalidades pagas (dia 5)
- Email 4: História de sucesso de cliente parecido (dia 7)
- Email 5: Check-in + apresentar recursos de suporte (dia 14)

**Ponto-chave**: Diferente da série de novos utilizadores — estes já se comprometeram. Foco em reforço e expansão, não em conversão.

---

### Lembrete de Passo Crítico de Onboarding
**Trigger**: Utilizador não completou passo crítico de setup após X tempo
**Objetivo**: Empurrar a conclusão de uma ação de alto valor
**Formato**: Email único ou mini-sequência de 2-3 emails

**Exemplos de triggers**:
- Não ligou a integração após 48 horas
- Não convidou membro da equipa após 3 dias
- Não completou o perfil após 24 horas

**Abordagem de copy**:
- Recorda o que começou
- Explica porque é que este passo importa
- Facilita (link direto para completar)
- Oferece ajuda se estiver preso

---

### Convite de Novo Utilizador
**Trigger**: Utilizador existente convida um colega de equipa
**Objetivo**: Ativar o utilizador convidado
**Destinatário**: A pessoa que está a ser convidada

- Email 1: Foste convidado (imediato)
- Email 2: Lembrete se não aceitou (dia 2)
- Email 3: Lembrete final (dia 5)

**Abordagem de copy**:
- Personaliza com o nome de quem convida
- Explica a que se está a juntar
- CTA único para aceitar o convite
- Prova social opcional

---

## Emails de Retenção

### Upgrade para Pago
**Trigger**: Utilizador gratuito mostra engagement, ou trial a acabar
**Objetivo**: Converter de gratuito para pago
**Sequência típica**: 3-5 emails

**Opções de trigger**:
- Baseado em tempo (trial dia 10, 12, 14)
- Baseado em comportamento (atingiu limite de utilização, usou funcionalidade premium)
- Baseado em engagement (utilizador gratuito muito ativo)

**Estrutura da sequência**:
- Resumo de valor: O que conseguiu até agora
- Comparação de funcionalidades: O que está a perder
- Prova social: Quem mais fez upgrade
- Urgência: Trial a acabar, oferta limitada
- Final: Última oportunidade + caminho fácil

---

### Upgrade para Plano Superior
**Trigger**: Utilizador a aproximar-se dos limites do plano ou a usar funcionalidades disponíveis no tier superior
**Objetivo**: Upsell para o próximo tier
**Formato**: Email único ou sequência de 2-3 emails

**Exemplos de trigger**:
- 80% do limite de seats atingido
- 90% do limite de armazenamento/utilização
- Tentou usar uma funcionalidade do tier superior
- Padrões de comportamento de power user

**Abordagem de copy**:
- Reconhece o crescimento (enquadramento positivo)
- Mostra o que o próximo tier desbloqueia
- Quantifica valor vs. custo
- Caminho de upgrade fácil

---

### Pedir Avaliação
**Trigger**: Milestone do cliente (30/60/90 dias, conquista importante, resolução de suporte)
**Objetivo**: Gerar prova social em G2, Capterra, app stores
**Formato**: Email único

**Melhor timing**:
- Após interação positiva de suporte
- Após alcançar resultado mensurável
- Após renovação
- NÃO após problemas de billing ou bugs

**Abordagem de copy**:
- Agradece por ser cliente
- Menciona valor/milestone específico se possível
- Explica porque é que as avaliações importam (ajudam outros a decidir)
- Link direto para a plataforma de avaliação
- Mantém curto — isto é um pedido

---

### Oferecer Suporte de Forma Proativa
**Trigger**: Sinais de dificuldade (queda na utilização, ações falhadas, encontros com erros)
**Objetivo**: Salvar utilizador em risco, melhorar experiência
**Formato**: Email único

**Exemplos de trigger**:
- Utilização caiu significativamente semana sobre semana
- Várias tentativas falhadas de uma ação
- Consultou docs de ajuda repetidamente
- Preso no mesmo passo de onboarding

**Abordagem de copy**:
- Tom de preocupação genuína
- Específico: "Reparei que..." (se os dados permitirem)
- Oferece ajuda direta (não apenas um link para docs)
- Pessoal, vindo do suporte ou CSM
- Sem pitch comercial — pura ajuda

---

### Relatório de Utilização do Produto
**Trigger**: Baseado em tempo (semanal, mensal, trimestral)
**Objetivo**: Demonstrar valor, impulsionar engagement, reduzir churn
**Formato**: Email único, recorrente

**O que incluir**:
- Resumo de métricas-chave/atividade
- Comparação com o período anterior
- Conquistas/milestones
- Sugestões de melhoria
- CTA leve para explorar mais

**Exemplos**:
- "Poupaste X horas este mês"
- "A tua equipa completou X projetos"
- "Estás no top X% de utilizadores"

**Ponto-chave**: Fá-los sentir-se bem e recorda-lhes do valor entregue.

---

### Inquérito NPS
**Trigger**: Baseado em tempo (trimestral) ou baseado em evento (pós-milestone)
**Objetivo**: Medir satisfação, identificar promoters e detractors
**Formato**: Email único

**Boas práticas**:
- Mantém simples: apenas a pergunta NPS inicialmente
- Formulário de follow-up para o "porquê" com base no score
- Sender pessoal (CEO, fundador, CSM)
- Diz-lhes como vais usar o feedback

**Follow-up com base no score**:
- Promoters (9-10): Agradece + pede avaliação/referral
- Passives (7-8): Pergunta o que tornaria num 10
- Detractors (0-6): Outreach pessoal para perceber problemas

---

### Programa de Referrals
**Trigger**: Milestone do cliente, score NPS de promoter, ou campanha
**Objetivo**: Gerar referrals
**Formato**: Email único ou lembretes periódicos

**Bom timing**:
- Após resposta positiva ao NPS
- Após o cliente atingir resultado
- Após renovação
- Campanhas sazonais

**Abordagem de copy**:
- Recorda do sucesso
- Explica a oferta de referral claramente
- Facilita a partilha (link único)
- Mostra o que ganha ele E o referido

---

## Emails de Billing

### Mudar para Anual
**Trigger**: Subscritor mensal na altura de renovação ou campanha
**Objetivo**: Converter mensal para anual (melhorar LTV, reduzir churn)
**Formato**: Email único ou sequência de 2 emails

**Proposta de valor**:
- Calcula a poupança exata
- Benefícios adicionais (se houver)
- Mensagem de fixar o preço atual
- Switch fácil em um clique

**Melhor timing**:
- Perto da data de renovação mensal
- Final de ano / ano novo
- Após 3-6 meses de lealdade
- Anúncio de aumento de preço (fixar a tarifa antiga)

---

### Recuperação de Pagamento Falhado
**Trigger**: Pagamento falha
**Objetivo**: Recuperar receita, reter cliente
**Sequência típica**: 3-4 emails ao longo de 7-14 dias

**Estrutura da sequência**:
- Email 1 (Dia 0): Aviso amigável, link para atualizar pagamento
- Email 2 (Dia 3): Lembrete, o serviço pode ser interrompido
- Email 3 (Dia 7): Urgente, a conta será suspensa
- Email 4 (Dia 10-14): Aviso final, o que vão perder

**Abordagem de copy**:
- Assume que é um acidente (cartão expirado, etc.)
- Claro, direto, sem culpa
- CTA único para atualizar pagamento
- Explica o que acontece se não for resolvido

**Métricas-chave**: Taxa de recuperação, tempo até recuperação

---

### Inquérito de Cancelamento
**Trigger**: Utilizador cancela subscrição
**Objetivo**: Aprender porquê, oportunidade de salvar
**Formato**: Email único (imediato)

**Opções**:
- Inquérito in-app no cancelamento (maior taxa de conclusão)
- Email de follow-up se saltarem o in-app
- Outreach pessoal para contas de alto valor

**Perguntas a fazer**:
- Razão principal do cancelamento
- O que poderíamos ter feito melhor
- Algo mudaria a tua decisão
- Podemos ajudar com a transição

**Oportunidade de winback**: Com base na razão, oferece uma alternativa específica (desconto, pausa, downgrade, formação).

---

### Lembrete de Renovação Próxima
**Trigger**: X dias antes da renovação (típico: 14 ou 30 dias)
**Objetivo**: Sem cobranças surpresa, oportunidade de expandir
**Formato**: Email único

**O que incluir**:
- Data e montante da renovação
- O que está incluído na renovação
- Como atualizar pagamento/plano
- Alterações a preços/funcionalidades (se houver)
- Opcional: Oportunidade de upsell

**Obrigatório para**: Subscrições anuais, contratos de alto valor

---

## Emails de Utilização

### Resumo Diário/Semanal/Mensal
**Trigger**: Baseado em tempo
**Objetivo**: Impulsionar engagement, demonstrar valor
**Formato**: Email único, recorrente

**Conteúdo por frequência**:
- **Diário**: Notificações, stats rápidas (para produtos de alto engagement)
- **Semanal**: Resumo de atividade, destaques, sugestões
- **Mensal**: Relatório abrangente, conquistas, ROI se calculável

**Estrutura**:
- Métricas-chave de relance
- Conquistas notáveis
- Detalhe de atividade
- Sugestões / o que experimentar a seguir
- CTA para aprofundar

**Personalização**: Tem de ser relevante para a utilização real. Relatórios vazios são piores do que não ter relatório.

---

### Notificações de Eventos-Chave ou Milestones
**Trigger**: Conquista ou evento específico
**Objetivo**: Celebrar, impulsionar engagement contínuo
**Formato**: Email único por evento

**Exemplos de milestone**:
- Primeira [ação] completada
- 10º/100º [item] criado
- Objetivo atingido
- Milestone de colaboração de equipa
- Streak de utilização

**Abordagem de copy**:
- Tom de celebração
- Conquista específica
- Contexto (comparado com outros, comparado com antes)
- O que vem a seguir / próximo milestone

---

## Emails de Win-Back

### Trials Expirados
**Trigger**: Trial terminou sem conversão
**Objetivo**: Converter ou reengajar
**Sequência típica**: 3-4 emails ao longo de 30 dias

**Estrutura da sequência**:
- Email 1 (Dia 1 pós-expiração): Trial terminou, eis o que estás a perder
- Email 2 (Dia 7): O que te impediu? (recolhe feedback)
- Email 3 (Dia 14): Oferta de incentivo (desconto, trial estendido)
- Email 4 (Dia 30): Último contacto, a porta está aberta

**Segmentação**: Abordagem diferente conforme o nível de engagement no trial:
- Alto engagement: Foco em remover fricção para converter
- Baixo engagement: Oferece um recomeço, mais ajuda de onboarding
- Sem engagement: Pergunta o que aconteceu, oferece demo/call

---

### Clientes Cancelados
**Trigger**: Tempo após cancelamento (30, 60, 90 dias)
**Objetivo**: Recuperar clientes que fizeram churn
**Sequência típica**: 2-3 emails ao longo de 90 dias

**Estrutura da sequência**:
- Email 1 (Dia 30): O que há de novo desde que saíste
- Email 2 (Dia 60): Resolvemos [razão comum]
- Email 3 (Dia 90): Oferta especial para voltar

**Abordagem de copy**:
- Sem culpa, sem desespero
- Atualizações e melhorias genuínas
- Personaliza com base na razão do cancelamento, se conhecida
- Facilita o regresso

**Ponto-chave**: É mais provável que voltem se a razão tiver sido resolvida.

---

## Emails de Campanha

### Roundup Mensal / Newsletter
**Trigger**: Baseado em tempo (mensal)
**Objetivo**: Engagement, presença de marca, distribuição de conteúdo
**Formato**: Email único, recorrente

**Mix de conteúdo**:
- Atualizações e dicas de produto
- Histórias de clientes
- Conteúdo educativo
- Notícias da empresa
- Insights da indústria

**Boas práticas**:
- Dia/hora de envio consistente
- Formato fácil de scanear
- Mix de tipos de conteúdo
- Um CTA primário em foco
- Unsubscribes são ok — mantêm a lista saudável

---

### Promoções Sazonais
**Trigger**: Eventos de calendário (Black Friday, Ano Novo, etc.)
**Objetivo**: Impulsionar conversões com oferta oportuna
**Formato**: Rajada de campanha (2-4 emails)

**Oportunidades comuns**:
- Ano Novo (recomeço, planeamento anual)
- Fim de ano fiscal (gasto de orçamento)
- Black Friday / Cyber Monday
- Épocas específicas da indústria
- Regresso às aulas / ao trabalho

**Estrutura da sequência**:
- Anúncio: Revelar a oferta
- Lembrete: A meio da promoção
- Última oportunidade: Horas finais

---

### Atualizações de Produto
**Trigger**: Lançamento de nova funcionalidade
**Objetivo**: Adoção, engagement, demonstrar momentum
**Formato**: Email único por lançamento principal

**O que incluir**:
- O que há de novo (claro e simples)
- Porque importa (benefício, não apenas funcionalidade)
- Como usar (link direto)
- Quem pediu (reconhecimento da comunidade)

**Segmentação**: Considera segmentar com base na relevância:
- Utilizadores que mais beneficiam
- Utilizadores que pediram a funcionalidade
- Power users primeiro (sensação de beta)

---

### Roundup de Notícias da Indústria
**Trigger**: Baseado em tempo (semanal ou mensal)
**Objetivo**: Thought leadership, engagement, valor de marca
**Formato**: Newsletter curada

**Conteúdo**:
- Notícias e links curados
- A tua opinião / comentário
- O que significa para os leitores
- Como o teu produto ajuda

**Melhor para**: Produtos B2B onde os clientes se preocupam com tendências da indústria.

---

### Atualização de Preços
**Trigger**: Anúncio de mudança de preço
**Objetivo**: Comunicação transparente, minimizar churn
**Formato**: Email único (ou sequência para mudanças grandes)

**Timeline**:
- Anunciar 30-60 dias antes da mudança
- Lembrete 14 dias antes
- Aviso final 7 dias antes

**Abordagem de copy**:
- Claro, direto, transparente
- Explica o porquê (valor entregue, custos aumentaram)
- Grandfather se possível (fixar tarifa antiga)
- Dá opções (compromisso anual, downgrade)

**Importante**: Honestidade e aviso antecipado constroem confiança mesmo quando o preço aumenta.

---

## Checklist de Auditoria de Email

Usa isto para auditar o teu programa de email atual:

### Onboarding
- [ ] Série de novos utilizadores
- [ ] Série de novos clientes
- [ ] Lembretes de passos críticos de onboarding
- [ ] Sequência de convite de novo utilizador

### Retenção
- [ ] Sequência de upgrade para pago
- [ ] Triggers de upgrade para plano superior
- [ ] Pedir avaliação (com timing adequado)
- [ ] Outreach proativo de suporte
- [ ] Relatórios de utilização do produto
- [ ] Inquérito NPS
- [ ] Emails do programa de referrals

### Billing
- [ ] Campanha de mudança para anual
- [ ] Sequência de recuperação de pagamento falhado
- [ ] Inquérito de cancelamento
- [ ] Lembretes de renovação próxima

### Utilização
- [ ] Resumos diários/semanais/mensais
- [ ] Notificações de eventos-chave
- [ ] Celebrações de milestone

### Win-Back
- [ ] Sequência de trial expirado
- [ ] Sequência de cliente cancelado

### Campanhas
- [ ] Roundup mensal / newsletter
- [ ] Calendário de promoções sazonais
- [ ] Anúncios de atualizações de produto
- [ ] Comunicações de atualização de preços
