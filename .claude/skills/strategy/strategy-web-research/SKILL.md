---
name: strategy-web-research
description: Pesquisa em múltiplas fontes web, sintetiza descobertas e produz relatórios de research com citações usando subagentes delegados. Usa quando o utilizador pedir para investigar um tópico online, pesquisar na web, procurar algo, encontrar informação atual, comparar opções ou produzir um relatório de research.
---

# Skill de Web Research

## Processo de Research

### Passo 1: Criar e Guardar o Plano de Research

Antes de delegar a subagentes, DEVES:

1. **Criar uma pasta de research** - Organiza todos os ficheiros de research numa pasta dedicada relativa ao diretório de trabalho atual:
   ```
   mkdir research_[nome_topico]
   ```
   Isto mantém os ficheiros organizados e evita desordem no diretório de trabalho.

2. **Analisar a pergunta de research** - Decompõe-na em subtópicos distintos e sem sobreposição

3. **Escrever um ficheiro de plano de research** - Usa a tool `write_file` para criar `research_[nome_topico]/research_plan.md` contendo:
   - A pergunta principal de research
   - 2-5 subtópicos específicos a investigar
   - Informação esperada de cada subtópico
   - Como os resultados serão sintetizados

**Diretrizes de Planeamento:**
- **Fact-finding simples**: 1-2 subtópicos
- **Análise comparativa**: 1 subtópico por elemento de comparação (máx 3)
- **Investigações complexas**: 3-5 subtópicos

### Passo 2: Delegar a Subagentes de Research

Para cada subtópico no teu plano:

1. **Usa a tool `task`** para lançar um subagente de research com:
   - Pergunta de research clara e específica (sem acrónimos)
   - Instruções para escrever as descobertas num ficheiro: `research_[nome_topico]/findings_[subtopico].md`
   - Budget: 3-5 pesquisas web no máximo

2. **Correr até 3 subagentes em paralelo** para um research eficiente

**Template de Instruções para Subagente:**
```
Pesquisa [TÓPICO ESPECÍFICO]. Usa a tool web_search para reunir informação.
Após completar o teu research, usa write_file para guardar as descobertas em research_[nome_topico]/findings_[subtopico].md.
Inclui factos-chave, citações relevantes e URLs das fontes.
Usa 3-5 pesquisas web no máximo.
```

### Passo 3: Sintetizar Descobertas

Depois de todos os subagentes completarem:

1. **Reviar os ficheiros de descobertas** que foram guardados localmente:
   - Primeiro corre `list_files research_[nome_topico]` para ver que ficheiros foram criados
   - Depois usa `read_file` com os **paths dos ficheiros** (ex.: `research_[nome_topico]/findings_*.md`)
   - **Importante**: Usa `read_file` apenas para ficheiros LOCAIS, não para URLs

2. **Sintetizar a informação** - Cria uma resposta abrangente que:
   - Responda diretamente à pergunta original
   - Integre insights de todos os subtópicos
   - Cite fontes específicas com URLs (a partir dos ficheiros de descobertas)
   - Identifique quaisquer lacunas ou limitações

3. **Escrever o relatório final** (opcional) - Usa `write_file` para criar `research_[nome_topico]/research_report.md` se for pedido

**Nota**: Se precisares de obter informação adicional de URLs, usa a tool `fetch_url`, não `read_file`.

## Boas Práticas

- **Planear antes de delegar** - Escreve sempre o research_plan.md primeiro
- **Subtópicos claros** - Garante que cada subagente tem um âmbito distinto e sem sobreposição
- **Comunicação baseada em ficheiros** - Faz com que os subagentes guardem as descobertas em ficheiros, não que as devolvam diretamente
- **Síntese sistemática** - Lê todos os ficheiros de descobertas antes de criar a resposta final
- **Parar de forma apropriada** - Não faças research a mais; 3-5 pesquisas por subtópico costuma chegar
