---
app: zcode
quelle: "saschalagler/cli/memories/projects/omni-router-scannfallback-f9dafe8ed965c304/memory/loki-assistent.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: loki-assistent
description: LOKI Assistent (assi) — lokale Version des persönlichen Assistenten
  unter ~/loki-assistent, implementiert die 6 Antigravity-Workflows 00-05
metadata:
  node_type: memory
  type: project
  originSessionId: sess_fea88d05-e278-4c57-90bf-e7e85a6eb5e2
---

Am 2026-08-20 gebaut: `~/loki-assistent/` mit CLI `assi` (Alias in ~/.zshrc Zeile ~198, LaunchAgent `com.sascha.assi.daily` täglich 08:00 → `data/brief_latest.txt`). Befehle: `assi status` (Health: OmniRoute 20128, LOKI 8010, Ollama 11434, Kanban 3484, AgentMemory 3111, Disk, omni-check-Bericht-Alter), `assi remember/recall/recent` (JSONL-Memory `data/memory/memory.jsonl`), `assi project <pfad>` (schreibt PROJECT.md), `assi task <text>` (Keyword-Routing zu: agent-os `loki`, omni-check, omniroute chat, scan.py, Claude Code). Module standalone in `lib/`.

**Why:** Saschas 6 Workflow-Docs (00 Ecosystem-Overview … 05 Memory-Decisions) existierten nur in der Antigravity-Session-DB (`~/.gemini/antigravity/conversations/9fce3c9e-…db`, 11.08.2026) und waren nie implementiert. Er wollte sie als lokale, auf ihn optimierte Assistant-Version.

**How to apply:** `assi` ist der Einstiegspunkt für Status/Fragen/Routing. Erweiterungen in `lib/` als standalone Module + Dispatcher-Mapping in `assi`. Verwandt: [[omniroute-gateway-setup]]. Ecosystem-Kontext: loki-ki (Kernel) + agent-os (R1-R5-Dev-Stack).
