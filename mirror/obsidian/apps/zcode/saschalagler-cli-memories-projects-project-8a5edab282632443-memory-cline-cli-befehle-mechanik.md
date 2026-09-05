---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/cline-cli-befehle-mechanik.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: cline-cli-befehle-mechanik
description: Cline CLI lädt Slash-Commands aus ~/.cline/workflows/*.md und
  Regeln aus ~/.clinerules — NICHT aus ~/.cline/skills/. Symlinks dorthin sind
  für die CLI wirkungslos.
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Cline CLI (Terminal) hat KEIN Skill-Ordner-Konzept wie ZCode/Claude. Echte Mechanismen (01.09. per User-Screenshot + Fix bewiesen):

| Zweck | Ort | Status 01.09. |
|---|---|---|
| **Slash-Commands** (/05 …) | `~/.cline/workflows/*.md` (seine /00–/04 = die 5 Workflow-Dateien) | 05-glm-build, 06-deve, 07-wayfinder angelegt |
| **Globale Regeln** | `~/.clinerules` (LOKI.OS 93 Zeilen) | +GLM-Pro-Betrieb angehängt = 102 Zeilen |
| **Modell-Default** | `~/.cline/data/settings/providers.json` (lastUsedProvider=openai-compatible/glm-first) | griff sofort, Screenshot-Beweis (Modell glm-first sichtbar) |
| **MCPs** | `~/.cline/data/settings/cline_mcp_settings.json` | geteilt App+CLI |
| `~/.cline/skills/` Symlinks | von CLI ignoriert | nur für andere Harnesses sinnvoll |

**Warum:** „Implementiert in Cline CLI"-Behauptung per Skills-Symlink war falsch — Befehle erschienen nicht im `/`-Menü. App+CLI teilen `~/.cline/data/` (Providers/MCPs), aber Commands/Regeln brauchen die zwei Spezialorte.

**Takeover-Modus (01.09., ergänzt nach „er soll die gesamte SSD durchsuchen"):** Workflow 06 (deve) hat jetzt TAKEOVER-Zweig, Trigger „übernimm das projekt" (in .clinerules + STANDARD-SKILLS geroutet). Phase 0 = **VOLL-SSD-SCAN via `mdfind`** (ganze Platte, read-only: Projektname+Slug+Aliase+Bundle-IDs → Cluster: Projektordner inkl. Zweitkopien/Alt-Versionen, Agent-Daten ~/.cline ~/.zcode ~/.claude ~/.gemini ~/.antigravity ~/.hermes ~/agent-os ~/loki-ki, Docs/Desktop/Downloads/Obsidian; kanonischer Pfad aus Projektliste gewinnt, Zweitkopien im Brief melden) → Phase 1 Memory-Sweep über Cluster + claude-mem + LOKI_SESSION_CONTEXT + WAYFINDER-GLM → Phase 2 Stand (Tests WIRKLICH starten) → Phase 3 STATE.md (Stand+Blocker+Quellen-Index, Unverifiziertes als „unbestätigt" markieren) → Phase 4 Plan: groß=wayfinder-Map, klein=glm-build-Todos. Beispiel-Projekt: Atlas — kanonisch `~/Desktop/Coworkspace_Ich/atlas + pliability /Atlas Cali Plan` (Alter Desktop-Pfad tot, siehe [[atlas-standort-korrigiert]]; Zweitkopie `~/cali-coach-atlas-final`).

**~/.clinerules ist ein SYMLINK auf `/Users/saschalagler/AGENTS.md`** (05.09. gelernt): Das Edit-Tool verweigert Schreibzugriff über den Symlink-Path („Refusing to write through symlink") — Regeln immer via `/Users/saschalagler/AGENTS.md` lesen+editieren. Seit 05.09. enthält AGENTS.md zusätzlich: Team-Pflicht für Scan/Index/Ingest-Tasks (todo-sync + max 3 Parallel-Subagenten, max 2 GO-Gates) und **Ticket-Abschluss-/Session-Start-Pflicht** gegen Subagenten-Amnesie (nach jedem Ticket: tsc → git commit → STATUS.md; vor jeder Planung: STATUS.md + git log lesen, nie existierende Arbeit vorschlagen — Details [[omniroute-verkabelung]]).

**How to apply:** In Cline CLI etwas verfügbar machen → Workflow-.md in `~/.cline/workflows/` schreiben; Verhalten regeln → `~/.clinerules` anhängen (nie `data/settings/rules/` als einzigem Ort vertrauen). Nachweis immer über sein `/`-Menü, nicht über Datei-Existenz. Siehe [[glm-trigger-befehle]], [[omniroute-verkabelung]].
