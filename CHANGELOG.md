# Changelog

Todos los cambios notables a iAmasters OS se documentan aquí.

Formato basado en [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Próximas versiones (en backlog)
- v0.5.0: skills `marketing-ugc-script`, `marketing-email-sequence`, `operations-meeting-notes`, `operations-task-priority`, `strategy-trending-research`, `tool-youtube-transcript`, `viz-excalidraw-diagram`
- v0.6.0: dashboard del OS (pendiente decidir si se integra con dashboard Sinapsis)
- v1.0.0: release pública estable

---

## v0.4.2 — Migración a org iamasters-academy + datos finales (2026-05-07)

### Changed
- **Repo migrado**: `angelapaia/iamasters-os` → `iamasters-academy/iamasters-os`
  - Nueva URL: https://github.com/iamasters-academy/iamasters-os
  - GitHub mantiene redirects automáticos del URL anterior
- **Atribución corregida** en todos los archivos del repo:
  - "iAmasters Academy" → "IA Masters Academy" (3 palabras separadas, según logo oficial)
  - Email gmail → `aaparicio@iamastersacademy.com` (corporativo)
  - Copyright `2026` → `2025-2026` (incluye año fundación academia)
  - Añadida entidad legal: AASC Associates (a brand of)
  - Añadido LinkedIn: linkedin.com/in/angel-aparicio92/
  - Añadido GitHub Org link: @iamasters-academy
- **Logo añadido**: `assets/logo.png` (2.4 MB, 1536×1024 PNG RGBA transparente). Mostrado en header del README, header del HTML team-presentation y footer del HTML.
- **README header rediseñado**: logo centrado + título + subtitle + 5 badges centrados.
- **LICENSE** ampliada con sección "Trademark notice" (marcas de AASC Associates).
- **CITATION.cff** version bumpeada a 0.4.2 con URLs actualizadas a la org nueva.

### Added
- **`assets/logo.png`** — logo oficial IA Masters Academy
- **Sweep global** automatizado para reemplazar referencias antiguas en todos los .md, .html, .cff, .json, .sh del repo

### Brand assets central
El logo y futuros assets viven en
`Empresa/01-IA Masters/07-Equipo/brand-assets/iamasters-academy-logo.png`
como fuente única de verdad. Cada repo nuevo lo copia desde ahí siguiendo el
checklist `captacion-shared/07-Equipo/repo-attribution-checklist.md`.

---

## v0.4.1 — Atribución y propiedad (2026-05-07)

### Added
- **LICENSE actualizado** con copyright "© 2026 Angel Aparicio · IA Masters Academy" + sección Authorship & Maintenance + bloque Vendored components clarificando licencia Sinapsis + bloque How to cite
- **README badges** (5): version, license, sinapsis-engine, maintained-by-angel-aparicio, by-iamasters-academy
- **README sección "Sobre el proyecto"** con tabla de autoría + cómo citar + nota de marca + code ownership
- **`.github/CODEOWNERS`** con `* @angelapaia` global + paths específicos
- **`CITATION.cff`** formato académico con datos completos + preferred-citation + referencia a Sinapsis vendored
- **GitHub repo metadata** actualizado: description con atribución, homepage a comunidad iAmasters, 7 topics (claude-code, agentic-os, sinapsis, ai-operator, skills-on-demand, iamasters, castellano)
- **Footer team-presentation.html** con copyright, links propios, nota de marcas

Aplica las 6 capas estándar de atribución documentadas en el repo
compartido del equipo (`captacion-shared/07-Equipo/repo-attribution-checklist.md`).

---

## v0.4.0 — Marketplace local + MCPs curados (2026-05-07)

### Added
- **`/install-skill <github-url>`** comando para instalar skills externas con validación previa:
  - Descarga a `/tmp/iamasters-os-skill-validate-<hash>/`
  - Valida estructura (SKILL.md, YAML frontmatter, name kebab-case, description 50-500 chars)
  - Detecta verbos de intención en description (afecta activación)
  - Comprueba scripts por patrones peligrosos (rm -rf /, eval, dd if=, mkfs, etc.)
  - Detecta credenciales hardcoded (regex API keys, tokens)
  - Comprueba conflicto con skills locales del mismo nombre
  - Output: report con OK/WARN/ERROR + recomendaciones de instalación
- **`/install-mcp <name>`** comando para instalar MCP servers:
  - Lista curada en `docs/mcps-curated.md` (top 5 + 5 útiles + warnings)
  - Configura `.mcp.json` con templates probados
  - Mode custom para URLs no curadas (con warnings)
- **`scripts/validate-skill.sh`** ejecuta toda la validación
- **`docs/mcps-curated.md`** lista mantenida de 10 MCPs útiles para operadores IA:
  - ⭐ Top 5: context7, github, supabase, notion, firecrawl
  - 🔧 Útiles: linear, gmail (read-only), slack, filesystem
  - ⚠️ MCPs a evitar (write redes sociales sin gates, scopes opacos)
  - Patrón de token budget (5-7 MCPs activos máximo)
- **`docs/skills-recommended.md`** lista de skills externas validadas:
  - Anthropic core: skill-creator, visual-explainer, pdf, docx, xlsx
  - Marketing: content-strategy, social-content, email-marketing-bible, ad-creative
  - Operations: marketing-psychology, product-management, saas-revenue-growth-metrics
  - Tech: nextjs-*, vercel-deployment, tailwind-design-system, web-security-audit
  - ⚠️ Skills a evitar (sin description clara, duplicadas, "todo en uno")
- **`docs/multi-client-guide.md`** guía operativa multi-cliente:
  - Cuándo usar / no usar
  - Estructura herencia CLAUDE.md
  - Skills custom por cliente vs skills globales del repo
  - Best practices de seguridad: separación de info entre clientes
  - Troubleshooting típico

### Decisiones de diseño
- Validate-skill.sh siempre crea TMP dir y NO elimina automáticamente (operador puede inspeccionar manualmente)
- Hardcoded secrets detection usa regex permissivo (puede haber falsos positivos, mejor warning que false-negative)
- MCP install no toca .mcp.json sin confirmación explícita del operador
- Curated lists son opinionated: solo skills/MCPs con experiencia real >2 semanas

---

## v0.3.0 — Multi-cliente + scripts de gestión (2026-05-07)

### Added
- **4 templates verticales completos** en `clients/_templates/`:
  - `freelance-ia/` — operador IA solo, ticket 5-50K€/proyecto
  - `agencia-marketing/` — pequeña agencia, MRR recurrente
  - `formador-online/` — coach/educador, ticket 200-2000€
  - `consultoria-b2b/` — high-ticket 30-300K€/engagement
- Cada template incluye: README específico + voice-profile + positioning + ICP + soul + user (template) — 6 archivos × 4 templates = 24 archivos
- **`scripts/add-client.sh`** — crea cliente nuevo desde template o vacío:
  - Valida nombre kebab-case
  - Clona template + reemplaza placeholders `{{CLIENT_NAME}}`
  - Genera `clients/<nombre>/CLAUDE.md` con overrides específicos
  - Output: estructura completa lista para configurar
- **`scripts/update.sh`** — actualiza repo desde upstream con conflict resolution:
  - 4 escenarios manejados: nada cambia / upstream actualiza / local modificó / conflicto
  - Backup automático en `.backup/<timestamp>/` antes de tocar nada
  - User data (brand-context, context, projects, clients, .env) NUNCA se sobrescribe
  - Skills locales modificadas: prompt caso por caso (keep / use upstream / diff / skip)
  - Vendor sinapsis + system files: safe to update

### Notas operativas
- Heredancia CLAUDE.md: el del cliente añade overrides al del raíz, no lo sustituye
- Skills se copian al cliente (no se heredan automáticamente); se sincronizan con `update.sh`
- El operador puede crear skills custom dentro de `clients/<nombre>/.claude/skills/` que sólo aplican a ese cliente

---

## v0.2.0 — Skills marketing core (2026-05-07)

### Added
- **8 skills nuevas** siguiendo patrón canónico del meta-skill-creator:
  - `tool-humanizer` — detector + reescritor anti-AI con `references/ai-tells.md`
  - `tool-output-verifier` — gate 4-checks (humanizer + brand-voice + length + factuality)
  - `tool-firecrawl-scraper` — wrapper Firecrawl con degradación graceful
  - `marketing-brand-voice` — voice profile + 3 registros A/B/C (formal/divulgativo/cercano)
  - `marketing-positioning` — análisis competidores + 3-5 ángulos + recomendación
  - `marketing-icp` — perfil cliente ideal completo con buying triggers + lenguaje + anti-ICP
  - `marketing-copywriting` — generador con voice + register auto + 2-3 variaciones por output
  - `marketing-content-repurposing` — 1 fuente → 5-8 piezas multiplataforma con calendar
- **Patrón de skill collaboration** documentado: copywriting → output-verifier → humanizer
- **Plataform limits reference** mantenido con 30+ plataformas

### Decisiones de diseño
- Todas las skills marketing-* invocan tool-output-verifier obligatoriamente como gate
- Humanizer score thresholds varían por plataforma (email premium ≥8, WhatsApp ≥6)
- Brand voice se compone de 3 registros separados, no 1 generic
- Firecrawl es opcional: si falta API key, fallback a WebFetch con warning

---

## v0.1.0 — esqueleto + Sinapsis (2026-05-07)

**Objetivo**: repo clonable que instale Sinapsis y deje preparada la capa OS para construir encima.

### Added
- Estructura completa de carpetas
- Sinapsis v4.5 vendored en `vendor/sinapsis/`
- `install.sh` que delega a Sinapsis y luego inicializa capa OS
- README, CLAUDE.md, AGENTS.md, LICENSE, .gitignore, .env.example
- Meta-skills v0: `meta-skill-creator`, `meta-onboarding-wizard`, `meta-start-here`, `meta-wrap-up`
- Plantillas vacías de brand-context y context

---

## Versionado de Sinapsis vendored

| iAmasters OS | Sinapsis vendored |
|---|---|
| v0.1.0 | v4.5.0 |

Cuando Sinapsis publique nueva versión upstream, se actualiza vendor con un commit dedicado.
