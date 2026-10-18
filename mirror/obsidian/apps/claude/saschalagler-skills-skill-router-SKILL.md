---
app: claude
quelle: "saschalagler/skills/skill-router/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: skill-router
description: >
  Wählt automatisch die richtige(n) Engineering-Skill(s) für eine Aufgabe aus.
  Bei jedem Build-/Code-/Feature-Wunsch aktivieren: "baue X", "erstelle X",
  "mach mir X", Feature, Ticket, Bugfix, Refactoring, Review vor Commit,
  UI/Design, Deploy. Mappt das Signal auf 1-3 passende Teil-Skills
  (Matt-Pocock-Suite, Design-Gruppe, Vercel-, Gemini-, Claude-Suite)
  statt alle zu laden.
---
# Skill-Router — automatische Auswahl der passenden Engineering-Skills

Regel: **1 Signal → 1–3 Skills, nie mehr.** Erst diese Tabelle prüfen, dann
nur die getroffenen Skills laden (Kontext-Budget). Bei mehrdeutigem Wunsch
zuerst `to-questionnaire` vorschalten, dann routen.

## Dispatcher-Tabelle

| Signal | Route (Reihenfolge = Ausführungsreihenfolge) |
|---|---|
| „baue/erstelle/mach mir X" (neues Feature/App) | design-an-interface → prototype → loki-dev Modus BUILD (Director) |
| Anforderung unklar / viele offene Fragen | to-questionnaire, danach neu routen |
| Spec/Ticket gewünscht | to-spec → to-tickets → triage |
| Ticket umsetzen | loki-dev Modus BUILD (+ tdd bei Test-Disziplin) |
| Vor git commit | code-review + qa |
| Bug | diagnosing-bugs (+ karpathy-guidelines als Qualitätsmaßstab) |
| UI bauen / Design | frontend-design-hub (Ästhetik → Kern · App-Motion/Animationen → Motion · Editorial-Minimalismus → Minimalismus), shadcn-ui (inkl. UX-Pattern-Lookup); Stylecheck → web-design-guidelines; Test → ui-ux-tester |
| Daten/Diagramme | d3-visualization; CSV/Excel→HTML-Report → frontend-design-hub (Daten-Reports) |
| Refactoring/Architektur | request-refactor-plan, improve-codebase-architecture, codebase-design; TS-Struktur → setup-ts-deep-modules |
| Begriffe/Domain unklar | domain-modeling, ubiquitous-language |
| Deploy Vercel | deploy-to-vercel (+ vercel-cli-with-tokens bei Token-Auth) |
| React/Next-Performance & Muster | vercel-react-best-practices, vercel-react-view-transitions, vercel-composition-patterns, vercel-optimize |
| Gemini/GCloud-Entwicklung | gemini-api, gemini-api-dev, gemini-interactions-api, gemini-omni-flash-api; Live/Voice → gemini-live-api-dev; Antigravity → google-antigravity-sdk; "Jules" → jules-meta-agent (Rolle übernehmen, Google-Abo) |
| Obsidian Vault (lesen/schreiben/sync) | obsidian-second-brain (Living-Wiki, Vault: ~/Documents/Obsidian Vault); Sync → loki-memory-sync / ~/.agents/tools/obsidian-sync.sh |
| OmniRoute-Gateway start/stop/status | cli-serve (+ omni-resilience bei Health-Fragen) |
| Claude-Code-Integration | claude-automation-recommender (Setup-Empfehlungen), claude-handoff (Übergabe), git-guardrails-claude-code |
| Skill kaputt / Setup | skill-repair (Google-Manifest), setup-matt-pocock-skills (Repo-Setup), setup-pre-commit, migrate-to-shoehorn, scaffold-exercises |
| Lernen/Erklären | teach |
| Repo onboarding | projects (Action 2.5 Repo-Infra) |

## Kombination mit LOKI-Workflows (AGENTS.md)

- Workflow 05 („baue X" → loki-dev Modus BUILD): Router liefert die Vor-Skills
  (design-an-interface, prototype); loki-dev bleibt der Director (ehem. glm-build, konsolidiert 08.09.2026).
- Workflow 06 („projekt übernehmen" → loki-dev TAKEOVER): Router wird NICHT vorgeschaltet;
  loki-dev macht den Memory-Sweep selbst.
- Parallel-Arbeit: max 3 Skills/Subagenten gleichzeitig (AGENTS.md-Regel).

## Nach dem Einsatz

Gewählte Route im Antwortkopf nennen (1 Zeile: „Route: A → B → C"), damit
nachvollziehbar bleibt, warum welche Skills geladen wurden.
