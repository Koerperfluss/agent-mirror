---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/sascha-local-infra-ports.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: sascha-local-infra-ports
description: Lokale Dienste/Ports auf Saschas Mac (Stand 16.09.2026) — OmniRoute
  20128, Ollama 11434, LOKI 8010, Cline Code.app
metadata:
  node_type: memory
  type: project
  originSessionId: sess_159400f5-1d61-449d-8946-c82e51db2f07
---

Live-Stand vom 16.09.2026 (per lsof/ps verifiziert):

- **OmniRoute v16.3.1** auf `localhost:20128` (node, permanent via LaunchAgent) — Gateway für GLM-Modelle
- **Ollama** auf `127.0.0.1:11434` (Brew-Instanz)
- **LOKI Kernel Port 8010**: war DOWN (nicht laufend)
- **Docker**: keine laufenden Container; `MCP_DOCKER` in `~/.mcp.json` startet per `docker mcp gateway run --profile ai_coding` (stdio)
- **Cline**: standalone **Cline Code.app** (`/Applications/Cline Code.app`), NICHT die VS-Code-Extension — Prozesse `cline-app` + `code-sidecar` (einer mit `--cline-hub-daemon`, lauscht `127.0.0.1:25463`); Standard-Cline-Settings-Pfad unter VS Code globalStorage existiert nicht; App-Logs unter `~/Library/Application Support/Cline Code/logs` nicht gefunden
- Z.AI-MCPs (web-search-prime, zread) als streamableHttp in `~/.mcp.json`; OmniRoute `/v1/models` ohne Key → AUTH_002 (normal, kein Fehler)
- Nebenbei lief `next start -p 3300` (Dev-Server, PID ~99734)

**Update 18.09.2026 (curl-Verifikation):** OmniRoute **20128** ✅ (HTTP 307) · **neuer Python-Dienst auf 8077** ✅ (HTTP 200, deutschsprachige Seite) · **neuer Python-Dienst auf 8055** ✅ (HTTP 404 am Root, lauscht) · LOKI 8010 ⛔ aus · Open-WebUI 8080 ⛔ aus · eBay-Callback 8078 ⛔ aus (nur bei Nutzung) · 5173/3000 aus.

**Browser-Inventar 18.09. (ps/ls verifiziert):** Google Chrome 153.0.8010.37 (Haupt) + Agent-Chrome 153.0.8010.52 (:9222, eigenes Profil) · **Comet.app** (Perplexity-Browser, Chromium 152.0.7977.197, läuft oft dauerhaft) · Safari + Safari Technology Preview. Cache-NUKE-Tool für alle: `~/.agents/tools/browser-cache-nuke-all.sh` (siehe [[chrome-agent-browser-fix]]). Wöchentliche Auto-Vorsorge: `~/.agents/tools/browser-cache-auto-clean.sh` via LaunchAgent `com.sascha.browser-cache-auto-clean` (So 04:30, überspringt wenn Browser offen), Log `~/.agents/logs/browser-cache-clean.log`.

**Why:** Port-/Prozess-Wissen ist bei jedem Health-Check und Fehler wie [[cline-code-app-hub-1006-diagnosis]] die erste Anlaufstelle.

**How to apply:** Vor Diagnosen diese Checkliste nutzen; Stand bei Änderungen hier aktualisieren (PIDs/„läuft seit" sind flüchtig, Ports sind stabil).
