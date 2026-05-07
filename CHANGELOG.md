# Changelog

Todos los cambios notables a iAmasters OS se documentan aquí.

Formato basado en [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### En construcción
- v0.4.0: `/install-skill <github-url>` con validación + `/install-mcp` + lista curada

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
