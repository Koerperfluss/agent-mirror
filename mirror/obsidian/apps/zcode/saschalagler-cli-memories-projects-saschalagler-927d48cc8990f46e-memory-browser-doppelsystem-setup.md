---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/browser-doppelsystem-setup.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

---
name: browser-doppelsystem-setup
description: 02.10. Browser-Ersatz aufgebaut — Doppel-System Zen (Fokus) +
  BrowserOS neo (Agent-Motor), MCP live an :9000/mcp, ZCode angebunden
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d0a56c40-be0f-4eda-b4d6-af76432d4f52
---

02.10.2026 — Saschas Browser-Ersatz-Projekt (Doppel-Browser-System nach seinem ADHS-Plan-PDF):

- **Zen Browser** installiert: `/Applications/Zen.app` (brew cask `zen`) — Fokus-Browser für Sascha, Workspaces/Compact Mode von ihm einzurichten.
- **BrowserOS 0.50.5** installiert: `/Applications/BrowserOS.app` (brew cask `browseros`) + **BrowserOS neo** 0.50.5 von Sascha selbst via `browseros-ai/tap` (Terminal-Log 01:19). Agent-Motor.
- **MCP-Server LIVE bewiesen** (POST initialize + tools/list): `http://localhost:9000/mcp` UND `:9200/mcp` — serverInfo `browseros_mcp` v0.0.165, **24 Tools** (tabs, navigate, snapshot, act, screenshot, evaluate, pdf, connector_mcp_servers für 45+ Apps …). GUI-Toggle NICHT nötig; Docs-Port 9239 = nur Beispiel. Weitere Ports: 9100 (leer), 9001.
- **ZCode angebunden**: `~/.mcp.json` → `mcpServers.browseros = {transport: {type: streamableHttp, url: http://localhost:9000/mcp}}` (22 Server, Backup `~/.mcp.json.bak-20261002`). Lädt nach ZCode-Neustart.
- **Gologin** 4.18.3 installiert (`/Applications/Gologin.app`, Anti-Detect, braucht Sascha-Login) — für Anti-Bot-Fälle (eBay etc.).
- GLM BYOK in BrowserOS: Settings → AI & Agents → „Add OpenAI Compatible" (z.ai = OpenAI-kompatibel) — **Sascha muss Key selbst eintragen** (kein Key-Fishing).

**Why:** Sascha wollte „Browser-Ersatz" gearbeitet haben, nicht Vergleiche; sein PDF definiert Zen=Fokus, BrowserOS=Agent-Hintergrundmotor via MCP.

**How to apply:** Browser-Automation für Agenten → BrowserOS-MCP (:9000/mcp) statt nur Chrome-9222; bei „Browser"-Fragen beide Apps + Ports prüfen (`lsof -nP -iTCP -sTCP:LISTEN | grep -i browseros`). ⚠️ Ports 9000/9001/9200 lauschen auf `*:` (LAN-exponiert, gleiche Klasse wie Kernel-8010-Fall) — Fix noch offen. Verwandt: [[sascha-local-infra-ports]], [[chrome-agent-browser-fix]].
