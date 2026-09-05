---
name: agent-os
description: "LOKI Agent OS unter ~/agent-os — Single-Prompt Multi-Agenten-Dev-Stack (R1–R5), Entry `./loki \"Ziel\"`, Engines claude→gemini→ollama"
metadata: 
  node_type: memory
  type: project
  originSessionId: a4650e39-722a-499b-a256-55f77124b545
---

**LOKI Agent OS** (erstellt 2026-07-05): Vollautonomer Multi-Agenten-Entwickler-Stack unter `~/agent-os/`, setzt die Anforderungen R1–R5 aus dem Antigravity-Entwurf v17.0 um.

- **Entry (R1):** `~/agent-os/loki "Ziel" --workdir PFAD [--yes] [--dry-run]` — Alias-Empfehlung: `alias loki="$HOME/agent-os/loki"`
- **Discovery (R2):** `agentos/discovery.py` scannt SSD → `state/capabilities_map.json` (563 Skills, 20 Personas, MCP-Server, 22 Projekte); Cache 24 h
- **Routing (R3):** 6 Domänen vom Wochenkalender-Whiteboard: development→P-01, edu-atlas→P-03, koerperfluss→P-06, legal-ops→P-04, datenbank-archiv→W-03, strategie→P-02
- **Slicer (R4):** AST für Python, Regex für JS/TS/Swift/Go
- **Self-Healing (R5):** max. 3 Korrekturschleifen mit Compiler-Feedback (`ast.parse`, `node --check`, `bash -n`)
- **Engines:** headless `claude -p` (bevorzugt) → `gemini -p` → `ollama run`; `~/.env.loki` wird geladen; `CLAUDECODE` env wird für Nested-Calls entfernt
- **Audit:** `<workdir>/.agents/auditor_m5/run-*.json` + Spiegel `~/agent-os/state/audit/`
- **Sicherheit:** `.bak`-Backups vor Überschreiben, Pfad-Ausbruch (`..`) blockiert, CLI-Gate ohne `--yes`
- E2E verifiziert (hello.py-Test, 36 s Gesamtlauf). Python: `/opt/homebrew/bin/python3` (3.14.6), nur Stdlib.
- **Hardware-Korrektur (User, 03.07.):** M4 mit **16 GB** UMA, 10 Cores — NICHT 128 GB (alte GEMINI.md v15.1 ist falsch). Konsequenz: keine 70B-Ollama-Pulls; Gemma4-12B mit KV-Cache 4096 ist das Limit. User nutzt AI-Studio-Premium-Account.
- **Parallel-Agent Antigravity/Gemini** editiert dieselben Dateien (28.06.+07.07.: 39 Files, u. a. LOKI_MASTER.py Fallback-Kette Gemini→LiteRT→Ollama, VisualCanvas interaktiv). Vor Edits an loki-ki IMMER frisch lesen — Stand kann sich außerhalb der Session ändern. Bridge-Endpoints + AGENT-OS-Knoten haben 07/08.07. überlebt (verifiziert).
- `.env.loki`-Fix (08.07.): Symlink `~/loki-ki/.env.loki → ~/.env.loki` (BOOT suchte falschen Pfad → „5 Keys fehlen").
- Konsolidierte Gesamtübersicht: `~/LOKI_MASTER_STATUS.md` (Live-Ports, 16 Projekte, Aufgaben-Matrix, Ziele).

**Frontend-Integration (2026-07-05):** LOKI-Kernel `~/loki-ki/LOKI_MASTER.py` (FastAPI Port 8010, v15.3.0) hat jetzt die Agent-OS-Bridge: `GET /loki/capabilities`, `POST /loki/capabilities/rescan`, `POST /loki/agentos/run` (sync-def → Threadpool). Dashboard `~/loki-ki/dashboard-app` (React 19 + Vite): VisualCanvas.tsx hat den lila **AGENT OS**-Knoten (unter dem Kernel, lädt Katalog live). Build lief erst nach Reparatur vorbestehender Fehler: MessageBubble.tsx (Regex mit literalen Newlines), fehlende `src/types/loki.ts` + `src/services/lokiAgentService.ts` (neu erstellt, 13 Agenten P-01–P-07/W-01–W-04/user/system), AgentCard.tsx (tote Imports), vite.config.ts (`@ts-expect-error` für vitest-`test`-Key). Kernel-venv: `~/loki-ki/.venv_new/bin/python`. macOS-App `LOKI_OS.app` lädt `localhost:8010/dashboard?embed=true`. E2E: Dashboard-API-Run erzeugte Datei + 8 Audit-Events.

**Why:** Sascha wollte nach endlosen Entwurfs-Loops im Antigravity/Gemini-Chat ein tatsächlich lauffähiges System („durch Eingabe was will ich und abfahrt").
**How to apply:** Bei Erweiterungen (Dashboard, Cron, n8n-Anbindung) auf diesen Stack aufbauen statt neu anzufangen; verwandt: [[koerperfluss-app]], Personas liegen in `~/loki-ki/agents/` und `~/Desktop/Local AI /loki-ki/personas/`.
