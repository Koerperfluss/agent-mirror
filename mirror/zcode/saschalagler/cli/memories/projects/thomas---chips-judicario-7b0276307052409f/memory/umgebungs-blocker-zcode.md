---
name: umgebungs-blocker-zcode
description: ZCode-Umgebungsblocker (Stand 22.09.2026) — Agent-Start ohne
  Reasoning-Level schlägt fehl, Gmail-MCP permission denied, mcporter nicht
  installiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5b46926c-ea38-4d93-833c-ef981b842fd5
---

Blocker in dieser ZCode-Umgebung, am 22.09.2026 getestet:

1. **Subagent-Start schlägt fehl**: Agent-Aufruf (z. B. `cavecrew-investigator`) bricht ab mit „Cannot start subagent: No reasoning level selected" (`account:zai-individual-coding-plan/GLM-5.3-Flash`). **Workaround:** Untersuchungs-/Task-Schritte direkt selbst mit Bash ausführen statt Subagent zu dispatchen.
2. **Gmail-MCP** (`mcp__google-workspace__gmail_search`): „Permission denied" — fehlende API-Scopes.
3. **Claude Desktop: „MCP MCP_DOCKER: Server disconnected"** = Docker Desktop lief nicht (Log `~/Library/Logs/Claude/mcp-server-MCP_DOCKER.log`: „Docker Desktop is not running"). Config selbst ist korrekt (`docker mcp gateway run --profile ai_coding` in `~/Library/Application Support/Claude/claude_desktop_config.json`). **Fix:** `open -a Docker` (22.09. getestet → Daemon 29.8.0 OK), danach Claude Desktop einmal neu starten, damit der MCP-Prozess neu startet.
4. **mcporter** ist nicht installiert (nicht im PATH, nicht in `/opt/homebrew/lib/node_modules/`); Config existiert zwar unter `/Users/saschalagler/config/mcporter.json`, aber ohne Binary unbrauchbar. → Autoclaw-Gmail-Tools via mcporter sind aktuell kein Fallback.
5. **chrome-devtools-MCP + laufender Automation-Chrome**: Wenn eine Instanz mit Profil `~/.cache/chrome-devtools-mcp/chrome-profile` schon läuft, schlägt `list_pages` fehl („browser is already running … use --isolated"). Erkennen am Fenster-Banner „Chrome wird von automatisierter Testsoftware gesteuert" — dieser Chrome ist NICHT Saschas echter Chrome (anderes Profil, keine Sessions, Google-Login wird dort von Google abgelehnt). Erst Banner prüfen, bevor man per Computer-Use tippt.

**Why:** Spart wiederholte Fehlversuche in künftigen Sessions.
**How to apply:** Keine Subagenten planen, solange Reasoning-Level ungesetzt; E-Mail-Lesen nur, wenn Gmail-MCP-Scopes gefixt sind.

Verwandt: [[chipsi-judicario-stand-2026-09-22]]
