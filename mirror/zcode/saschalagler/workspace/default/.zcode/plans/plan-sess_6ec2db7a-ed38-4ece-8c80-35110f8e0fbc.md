# Plan: AutoClaw-Agent (LOKI-GLM) + Workflow/Skill-Räumung

**Aufwand:** A ≈ 30–45 min · B ≈ 10 min · 1 Nutzer-Aktion (Dialog-Klick)

## A) AutoClaw-Agent erstellen — „full-stack-builder" als Universal-Builder

**A0 — Deine 1 Aktion:** Im offenen Dialog (Screenshot) auf **Create** klicken. AutoClaw legt damit `~/.openclaw-autoclaw/agents/full-stack-builder/` + Config-Eintrag app-kontrolliert an (sicherer als manuelles JSON-Editen — in `openclaw.json` liegt ein JWT, den wir nicht anfassen).

Danach führe ich aus:

**A1 — Workspace-Dateien füllen** (`…/agents/full-stack-builder/workspace/`, Backup vorher):
- `IDENTITY.md` (Schema `agent-profile/v1`): Name, Rolle Universal-Builder, Focus = deine gewählten Areas (Coding, UI/UX Front/Backend, Product, Data, Design, DevOps, Research, Marketing-Analyse), Style = caveman + ADHD
- `AGENTS.md`: kompakter LOKI-Vertrag — glm-build-Ablauf (1 Satz → Plan → Bau → Test → Doku), deve-Takeover als Sekundärmodus, wayfinder nur bei Riesenprojekten, Stop-Regeln (Deploy/Löschen/git push/>5000 Credits), ADHS-Output (Zeile 1 = Ergebnis, Tabellen, max 3 Schritte), 1 Task = 1 Session
- `SOUL.md` + `MEMORY/USER/TOOLS/HEARTBEAT.md`: von der auto-coder-Vorlage ableiten

**A2 — Kern-Skills installieren:** ~9 Skills nach `~/.openclaw-autoclaw/skills/` kopieren (glm-build, deve, wayfinder, ui-ux-tester, skill-aware-task-distribution, multi-agent-status-check, automated-project-onboarding, ponytail, grill-me) und in `skills.entries` der openclaw.json aktivieren — Limit `maxSkillsPromptChars: 30000` beachten, nur JSON-Check mit jq/python, JWT unberührt. Danach AutoClaw-Neustart (deine bekannte Falle: Config greift erst nach Neustart).

**A3 — Modell + Test:** Modell `zai/zai_auto` wie deine anderen Agenten (Default glm-5.3-flash = deine Flash-first-Kostenlogik, 0 Setup). Live-Test: 1 Chat „baue mir X" → prüfen, dass Regeln greifen und Antwort kommt. OmniRoute (localhost:20128, erreichbar aber 401) nur als spätere Option — separater Schritt, wenn A grün ist.

## B) Räumung 01–07 (Fakten-Befund: Nummern sind Cline-Workflows, keine Skills)

| # | Aktion | Warum |
|---|---|---|
| B1 | `~/.cline/workflows/05-memory-enhanced-decision-making.md` löschen | Nummer 05 doppelt (05-glm-build bleibt, darauf zeigen deine Regeln); Skill `memory-enhanced-decision-making` existiert in allen 5 Harnesses, Routing ruft ihn schon |
| B2 | `STATUS.md` + `installed-skills-complete.txt` nach `~/.cline/docs/` verschieben | Keine Workflows,clutter im Workflow-Ordner |
| B3 | Skill `ui-ux-tester` nach `~/.hermes/skills/` spiegeln | Einzige echte Lücke (sonst überall identisch) |
| B4 | 4er-Drift angleichen: `lokiomnidevteam-plan/-execute` + `_sources` → `~/.zcode/skills/`, `find-docs` → `~/.agents/skills/` | Audit-Drift vom 31.08. schließen |
| B5 | Workflows 00–04, 05-glm-build, 06–08 unangetastet | AGENTS.md referenziert 04/05/06/07 — Routing nutzt nur unnummerierte Skill-Namen |

**Verifikation:** ls/diff-Checks nach B, Frontmatter-Validierung, 1 Live-Testchat in AutoClaw nach A2/A3 — erst dann „fertig". Backups vor jedem Schreibvorgang; einzige Löschung = B1 (explizit im Plan, GO = Plan-Freigabe).