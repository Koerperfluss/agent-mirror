# Cline Global Configuration

## Session Start Protocol

Bei jedem Session-Start:

1. **Skill Auto-Discovery**: Lies alle Skills aus `~/.cline/skills/` — jede Verzeichnis/Symlink mit `SKILL.md` ist ein verfügbarer Skill. Verwende den Skill automatisch wenn die Task danach verlangt.
2. **MCP Health Check**: Prüfe ob MCP-Server erreichbar sind (chrome-devtools, claude-mem, filesystem, MCP_DOCKER, sequential-thinking). Bei Fehlern: dem Nutzer melden, nicht blockieren.
3. **Workflow Awareness**: Lies `~/.cline/workflows/STATUS.md` für aktuellen System-Status.

## Verfügbare Skills (98 total)

### Meta & Management
- `/managing-skills` — Skill-Management (install, find, update, list)
- `/claude-automation-recommender` — Analysiert Codebase für Automations
- `/projects` — Projekt-Orchestration Hub (Kanban, Session Resume)
- `/ponytail` — YAGNI-Ladder: Ist diese Aufgabe nötig? Scoping Gate.

### Agent Development & Team
- `/parallel-feature-development` — Parallele Feature-Entwicklung mit File-Ownership
- `/cline-sdk` — SDK für Custom Cline Agents
- `/caveman` — Kompressions- & Review-Tool (aus Gemini Extensions)
- `/to-tickets` — Spez → Sub-Tasks mit Blocking-Edges
- `/code-review` — Two-Axis Review (Standards + Spec)

### Knowledge & Memory
- `/obsidian-second-brain` — Claude als Vault-Librarian
- `/obsidian-vault` — Obsidian Vault Integration
- `/second-brain` — Vault Setup Wizard
- `/agentmemory-rest-api` — REST API Memory (localhost:3111)

### Frontend & Design
- `/frontend-design` — Anti-AI-Slop Design (Cline-offiziell)
- `/ui-ux-pro-max` — Advanced UI/UX Engineering
- `/minimalist-ui` — Clean Minimal Interfaces
- `/shadcn-ui` — React Component Library
- `/d3-visualization` — Interactive Data Visualization
- `/data-report` — Dashboard & Reporting
- `/web-design-guidelines` — Web Design Standards

### Development
- `/backend-development` — API Design & RESTful Patterns
- `/fullstack-developer` (via shubhamsaboo) — Vollständiger Web-Stack
- `/ios-swift-development` — Swift/SwiftUI iOS Development
- `/developing-ios-apps` — XcodeGen & SPM
- `/vercel-cli-with-tokens` — Vercel Deployment
- `/deploy-to-vercel` — Vercel Deploy Workflow

### Gemini & AI Integration
- `/gemini-api` — Google Gemini API
- `/gemini-api-dev` — Gemini API Development
- `/gemini-live-api-dev` — Gemini Live API (Realtime Voice/Video)
- `/gemini-interactions-api` — Gemini Stateful Interactions
- `/gemini-omni-flash-api` — Gemini Omni Flash

### Quality & Process
- `/grill-me` — One-question-at-a-time Validation
- `/grilling` — Stateful Grilling Sessions
- `/grill-with-docs` — Documentation-Grilling
- `/brainstorming` — Strukturierte Ideengenerierung
- `/tdd` — Test-Driven Development
- `/qa` — Quality Assurance
- `/diagnosing-bugs` — Bug Diagnosis
- `/prototype` — Rapid Prototyping

### Writing & Communication
- `/writing-guidelines` — Schreibstandards
- `/writing-beats` — Narrative Struktur
- `/writing-fragments` — Fragment-basiertes Schreiben
- `/writing-great-skills` — Skill-Authoring
- `/edit-article` — Artikel-Bearbeitung
- `/teach` — Lern-Sessions

### Architecture & Refactoring
- `/codebase-design` — Architektur-Vokabular & Design
- `/improve-codebase-architecture` — Architektur-Review
- `/domain-modeling` — Domain-Driven Design
- `/ubiquitous-language` — Shared Language
- `/setup-ts-deep-modules` — TypeScript Module Setup
- `/resolving-merge-conflicts` — Merge-Konflikt-Lösung

### Workflow & Orchestration
- `/loop-me` — Loop-basierte Automatisierung
- `/wayfinder` — Navigation durch Codebase
- `/research` — Recherchieren & Analysieren
- `/triage` — Task-Priorisierung
- `/implement` — Feature-Implementierung
- `/request-refactor-plan` — Refactor-Plan Anfrage

## Hooks (Kanban-Integration)

Alle Cline-Aktivitäten werden automatisch an Kanban gesendet:
- **Stop** → `to_review`
- **SubagentStop** → `activity`
- **PreToolUse** → `activity`
- **PostToolUse** → `to_in_progress`
- **UserPromptSubmit** → `to_in_progress`

## MCP-Server

Aktiv konfiguriert in `~/.cline/data/settings/cline_mcp_settings.json`:
- `chrome-devtools` — Browser Automation
- `claude-mem` — Persistent Memory (claude-mem Plugin)
- `filesystem` — Full Filesystem Access (`/Users/saschalagler`)
- `MCP_DOCKER` — Docker Gateway (`ai_coding` Profile)
- `sequential-thinking` — Advanced Reasoning
- `loki-legal-ops-mcp` — LOKI Legal Operations
- `gemini-api-docs-mcp` — Gemini API Docs (⚠️ 429 Rate Limit)
- `paper` — Paper Desktop (⚠️ Connection Failed)

## Multi-Agent Ökosystem

Cline ist Teil eines größeren Agenten-Netzwerks:
- **Hermes** (`~/.hermes/`) — Self-improving Agent mit TTS/STT
- **Antigravity** (`~/.config/antigravity/`) — MCP Orchestrator
- **Gemini CLI** (`~/.gemini/`) — Google AI mit Extensions (caveman, ponytail)
- **Claude Code** (`~/.claude/`) — Anthropic Agent
- **Cursor** (`~/.cursor/`) — IDE-Agent
- **Codex** (`~/.codex/`) — OpenAI Agent

Alle teilen das Skill-Repository: `~/.agents/skills/` (81 Skills)

<!-- STANDARD-SKILLS:START -->
## STANDARD-SKILLS — gelten in JEDE Session, in JEDEM Harness

### A. Immer aktiv — Output-Stil (ohne Skill-Aufruf, direkt befolgt)
1. **caveman-Regeln:** Ultra-kompakt. Keine Floskeln, keine Begrüßung, keine Verabschiedung. Rohe Tabellen, kurze Bullets, Code-Snippets. Fakten, null Spekulation.
2. **i-have-adhd-Regeln:** Wichtigstes Ergebnis in Zeile 1 (BLUF/Action first). Nummerierte Schritte (1-2-3). Kernbegriffe und Pfade **fett**. Kurze Tabellen statt Fließtext. Sofort nutzbare Kopiervorlagen. Keine Jargon-Nutzung ohne Erklärung.
3. **Sequential Thinking:** MCP-Tool `sequentialthinking` bei JEDER Anfrage aufrufen — auch bei simplen Fragen (min. 1–3 Denkschritte); komplexe Aufgaben vollständig strukturiert (Schritt → Revision → Hypothese → Verifikation). Stehende Nutzer-Regel vom 30.08.2026.
4. **Automatik + Ehrlichkeit (12.09.2026, Nutzer-Pflicht):** (a) Ergebnisse SELBST verifizieren — Befehl ausführen, Dateipfad als Beweis nennen; „erledigt" ohne Beweis-Pfad ist verboten. (b) Jedes Fachwort beim 1. Auftreten in 1 kurzen Satz erklären (Glossar: `~/.agents/UBIQUITOUS_LANGUAGE.md`). (c) Nie App-UI behaupten: Wayfinder-Maps, Todos, Memory = Dateien im Finder (`~/.agents/.wayfinder/`, `~/.zcode/cli/memories/`), die ZCode-App zeigt sie nicht an — so sagen, nicht anders. (d) Antwortformat: Zeile 1 = Ergebnis in einfachen Sätzen, dann max. 3 Schritte/Tabelle. (e) Reparaturen automatisch ausführen (mit Backup), den Nutzer nur bei Deploy/Löschen/Überschreiben fragen.
5. **Auto-Team-Dispatch (Sascha 16.09.2026, EISENREGEL):** Jede Nutzer-Nachfrage löst automatisch Agenten-Arbeit aus: analysieren → Agents per Verteilungs-Formel zuweisen → parallel arbeiten lassen (max. 3) → Ergebnisse bewerten und mergen. Keine Rückfrage, keine reine Mono-Antwort, wenn Agents sinnvoll beitragen können. Browser-Steuerung bleibt Main-Agent-vorbehalten.

### B. Routing — bei passendem Kontext IMMER den Skill nutzen (ohne Rückfrage)
| Aufgabe | Skill |
|---|---|
| Ökosystem-Orientierung | loki-memory-sync (Quellen-Tabelle) + loki-os-health |
| Status/Health-Check der Systeme | loki-os-health |
| Projekt-Onboarding / Repo-Infra | projects (Action 2.5 Repo-Infra) |
| Wissens-Sync über Plattformen | loki-memory-sync |
| Aufgabenverteilung auf Agenten | skill-aware-task-distribution |
| Lisa-Fall: Nachricht an Lisa/Sabine, Muster-Check, Krise, „lies die letzten Nachrichten" | **lisa-therapeut** (Stand 07.09.2026) |
| Entscheidungen (`/decide`) | memory-enhanced-decision-making |
| Feature-/Planungs-Verhör | grilling (Modi: Kern / BATCH / LOOP) |
| Bug | diagnosing-bugs |
| Implementierung | tdd |
| Coden (simpelster Weg) | ponytail |
| Architektur-Rückfrage | ask-matt |
| Sicherheitsaudit / App-Pentest (nur eigene Apps) | strix-pentesting |
| Langzeitgedächtnis / Kontext über Sessions | cognee-memory |
| Doku/Lookup aktueller APIs | find-docs (CLI + MCP-Modus) |
| Gratis-Modelle / KI-Fallback-Check | `omni-check` (Terminal-Alias) |
| Build-Wunsch („baue/erstelle/mach mir X") | **loki-dev** Modus BUILD (Director, Zero-Question) |
| Projekt onboarden / neu anlegen / ÜBERNEHMEN (Memory-Sweep→Stand→Plan) / fertig machen / testen | **loki-dev** Modi INIT/TAKEOVER/FINISH (ehem. deve/glm-init = konsolidiert) |
| UI-/UX-Test (Web/Desktop, erschöpfend) | ui-ux-tester (chrome-devtools/computer-use + Vision) |
| GROSSES Projekt / Arbeit >1 Session | **loki-dev** Modus MAP → wayfinder (Map ch Artieren/abarbeiten; Konfig-Landkarte: ~/.agents/WAYFINDER-GLM.md) |
| Terminal-KI-Frage ohne Modell-Wahl | `omniroute chat` (Gateway **localhost:20128**, permanent via LaunchAgent) |

**⚠️ Orchestrierungs-Gate (PFLICHT bei jedem loki-dev-Start):** Sequential-Thinking-Zerlegung → TodoWrite sofort → PLAN-Tabelle im Chat (Stufe|Agent|Skill|Modell|~Tokens|~Zeit|Dep) → PLAN.md im Projekt. Der Plan ist LEBEND: nach jeder Stufe Status aktualisieren.
**Parallelität:** bedarfsberechnet aus Task-Graph (unabhängige Tasks = Parallelitätsgrad); Budget-Default 3 gleichzeitig (Quota-Schutz ZAI-Caps/16-GB-Mac), mehr mit 1-Zeilen-Begründung.

**Verteilungs-Formel (skill-aware-task-distribution):** `score = skill_match*0.4 + performance_history*0.3 + availability*0.2 + platform_fit*0.1` — höchster Score gewinnt.

### C. Memory-basiertes Tool-Calling
- Vor der Skill-Wahl: **`~/.agents/skill-routing.md`** konsultieren (erlernte Task→Skill-Zuordnungen).
- Nach einer **bewährten** neuen Zuordnung: sie dort eintragen — Memory entscheidet künftig, welcher Skill gerufen wird.
- Security: strix-pentesting nur auf **eigene** Apps/Infrastruktur.

### D. GLM-Pro-Betrieb (ab 01.09.2026 — automatisch beachten, nie fragen)
1. **Modell-Routing:** Standard = **glm-first** (Flash-first, ⅓ Kosten). Schweres (Architektur, Multi-File-Refactor, Security, Plan-Modus) = **glm-plan** (5.3-first). Beide via OmniRoute localhost:20128 mit Auto-Fallback auf tagesaktuelle Free-Modelle.
2. **Peak/Off-Peak:** Peak = Mo–Fr 08–12 Uhr MEZ (50% Aufschlag). Batch-Jobs (Scans, Test-Gen, Doku, große Refactors) automatisch auf ab 12 Uhr MEZ legen ODER sofort auf Flash ausweichen — Entscheidung dokumentieren, nicht nachfragen.
3. **MCP-Kosten:** Z.AI-MCP-Calls = 1,2 Credits/Call (Vision/web-search/zread) — gezielt, nicht spielerisch.
4. **Session-Disziplin:** 1 Task = 1 Session. Context komprimieren lassen, keine Monster-Sessions.
5. **Quota tot (429)?** Nicht stoppen: OmniRoute rutscht automatisch; beim User melden nur, wenn ALLES tot (omni-health).
6. **Aufwand vor Start:** Bei Tasks >30 Min geschätzte Dauer + Credit-Risiko in 1 Zeile nennen, dann los.

<!-- STANDARD-SKILLS:END -->
