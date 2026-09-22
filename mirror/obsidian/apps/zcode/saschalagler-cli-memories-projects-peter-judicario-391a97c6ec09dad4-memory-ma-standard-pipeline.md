---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/ma-standard-pipeline.md"
stand: 2026-09-22
tags: [spiegel, zcode]
---

---
name: ma-standard-pipeline
description: MA-Standard-Workflow GLOBAL GESPEICHERT (21.09., Finale) — Auto-Routing über die ECHTE Subagent-Installation (Router wählt aus 25 Typen 2-4 aus + ordnet 32 MCP + 258 Skills zu); AUTO-MA-Regel steht in ~/.zcode/AGENTS.md §5 = läuft in JEDERM neuen Chat; IMMER (auch Mini-Fragen, Sascha „ja")
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

**Saschas Ziel (21.09., mehrfach eskaliert):** Eine **generische Multi-Agent-Pipeline**, die bei **JEDER Anfrage automatisch, jedes Mal in EINEM Lauf** durchläuft — „die Arbeit geht auf 1x, nicht in 1000 Etappen. Das ist dein Ziel seit Wochen. When to use: IMMER." KEINE Trigger-Wörter („ich schreib nicht mal …"), kein GO.

**Why:** Er sah den abgeschlossenen Workflow „Thomas-Codex-Analyse" (7 Agents, 9/9 Steps, 8.570.900 Tokens) und fragte, wie er DAS wieder triggert und warum ich nicht IMMER so arbeite. ZCode-Hürde: Workflows starten nur auf expliziten Wunsch — die eigentliche Bremse, nicht fehlende Skills.

**FINALE Version (21.09., nach 2 Sascha-Korrekturen):** Global gespeichert: `~/.zcode/workflows/MA-Standard.dwf.ts`.
1. Sascha lehnte 7-Agenten-Version ab: „SO VIEL DU BRAUCHST NICHT 2 oder 3".
2. Dann lehnte er die feste 3er-Besetzung ab: „KEINE 3 SONDERauswahl autorouting aus allen 20" und „wenn du nichtmal die pipeline verstehst" + Paste der ECHTEN Installations-Liste (25 Subagents, 38 Plugins/258 Skills, 32 MCP-Server, 25 Commands).
3. **Finale Architektur:** Phase 1 **Router** (kennt die 25 echten Subagent-Typen: general-purpose, Explore, cavecrew-builder/-investigator/-reviewer, code-architect/explorer/reviewer, implementer, qa-tester, config-auditor, gate-enforcer-test, reviewer, visual-judge×4, agent-sdk-verifier-py/-ts, adlc-*) wählt **2-4 passendste** + ordnet MCP-Server (web-search-prime, zai-Vision, context7, claude-mem/deja, loki-legal-ops, chrome-devtools/playwright …) und relevante der **258 Skills** zu. Phase 2 gewählte laufen **parallel** (anonyme Agents im Fan-out — berechnete Namen killen den Run). Phase 3 **Synthese** (Botschaft/Empfehlung/fertiger Text/offenFuerSascha). Phase 4 **1 Kritischer Leser** + ggf. 1 Ueberarbeiter. Phase 5 Bericht-Artifact. Args: `auftrag` (required) + `material` (json {typ, pfad}).
4. **AUTO-MA-Regel steht in `~/.zcode/AGENTS.md` §5** (nicht nur Projekt-Memory!) = lädt in JEDERM neuen Chat/JEDREM Projekt. Grund: Sascha meldete „in neuem chat passiert nichts vom routing" — die Regel lag vorher nur im Projekt-Memory. **IMMER = auch Mini-Fragen** (auf immer/bei-Arbeit-Frage antwortete er „ja"; früher explizit: „bei jeder anfrage immer jedes mal durchlaufen lassen").
5. Compile-Fixes beim Speichern (wiederkehrend): deutsche Anführungszeichen mit geradem Schluss-" zerbrechen TS-Strings („…" vermeiden oder ‚…' nutzen) + Subagent-Namen im Run eindeutig (2. Verfasser = „Ueberarbeiter").

**How to apply:** Bei JEDER substanzhaltigen Anfrage (neue Sessions: AGENTS.md §5 befiehlt es): CreateWorkflow `saved: { name: "MA-Standard", args: { auftrag, material } }` — ohne Rückfrage. Pfade aus Nachricht/Kontext selbst extrahieren.

**Commands (25):** Sascha: **alle behalten** — Grund: die 7 eigenen (/feierabend /init /kanban /projects /standardskill /systemproof /todo) „sollten standardmäßig vor und bei jeder Anfrage durchlaufen" (→ ggf. in MA-Standard integrieren, noch offen).

**Offene Punkte (Stand 22.09.):** rtrvr.ai-MCP braucht Saschas API-Key (rtrvr.ai/cloud, Doku rtrvr.ai/docs/mcp) → dann Eintrag in `~/.mcp.json` · CaskHub gefunden = alielsokary/CaskHub, `brew install --cask caskhub` (0.7.0, macOS 15+) · Tappie/empiricapp NICHT auffindbar · Remindian bereits installiert (/Applications/Remindian.app) · paseo-App-Install + LokiVoice-/Applications-Binary-Ersatz + Gateway-Key 401 = GO/Key-Pflicht · Bericht Thomas-Codex wartet auf GO · **EnvCheck-Resume-Run dwfrun-102156ed ABGESCHLOSSEN** (14/15 Checks grün; rot: ffmpeg-filter-libass fehlt, PingFang-Pfad-Check; 4 Punkte selbst erledigt — Details [[envcheck-blocker-routing-2109]]) · **Blocker-Routing-Run dwfrun-a40a481e gestartet** (22.09., nach Sascha-Wut „was für scheiss 13 blocker"): Skill-Router klassifiziert die 14 Punkte gegen den Ist-Zustand (ls/pgrep/brew list), führt Jetzt-machbare sofort aus (AutoClaw-Mirrors, CaskHub), Mermaid-Übersicht als Artifact — Ergebnis stand bei letztem Update noch aus.
- **google-workspace MCP calendar_admin = Permission denied (Scopes)** → funktionierender Fallback: osascript Calendar.app (Event „Logbuch 2026-09-21" 18:00-18:15, ID FE7FF702-A256-458F-8313-9FFE51ACA1B5). Logbuch-Datei `~/.agents/memory/logbuch/<date>.md` existiert ggf. schon (Morgen-Brief) → nur APPEND, „## ✍️ Meine Notizen"-Sektion nie anfassen (einmal versehentlich ersetzt → sofort wiederhergestellt).

Siehe [[sascha-output-standard]], [[codex-paket-skills-konvertierung]], [[lokivoice-v10-stand-presentation]].
