---
name: atlassian-mcp-mystery-tab
description: Unerwarteter Atlassian-OAuth-Login-Tab (mcp.atlassian.com) — GELÖST:
 Quelle ist Antigravity language_server (respawnt mcp-remote); wirksamer Sofort-Fix =
 Antigravity beenden; Dauer-Fix nur über Antigravity-UI
metadata:
  node_type: memory
  type: project
  originSessionId: sess_16f82fae-2f37-43eb-af25-e2e10796996e
---

30.08.2026: Sascha pastete einen OAuth-Tab `https://mcp.atlassian.com/v1/authorize?…redirect_uri=http://localhost:5598/oauth/callback` (PKCE, scopes openid/email/profile) mit „was ist das?". Ursache: laufender Prozess `node …/.npm/_npx/…/mcp-remote https://mcp.atlassian.com/v1/sse` (Atlassians offizieller Remote-MCP für Jira/Confluence, Callback-Listener auf 127.0.0.1:5598). In KEINER Haupt-Config registriert (geprüft: ~/.claude.json, ~/.claude/settings.json, ~/.zcode/cli/config.json, ~/.gemini/settings.json, ~/.codex/config.toml) — vermutlich über eine Tool-UI/Plugin-Marktplatz hinzugefügt. Kein nachweislicher Jira/Confluence-Nutz bei Sascha.

**Why:** Unerwartete Login-Tabs ohne Kontext verunsichern Sascha — er will wissen, ob Gefahr droht und woher es kommt; einordnen statt raten.

**How to apply:** Rezept bei unerwartetem OAuth-Tab: 1) redirect-Port aus der URL → `lsof -nP -iTCP:<port> -sTCP:LISTEN` → PID → `ps -p <pid> -o command=` (liefert Client + Ziel-Server). 2) Domain bewerten (echt/legitim vs. Phishing-Verdacht). 3) Kurzantwort mit 2 Optionen: Tab schließen + `kill <pid>` ODER einloggen, falls das Abo gewollt ist. Verwandt: [[omniroute-verkabelung]] (gleiche localhost-Tool-Welt).

GELÖST 30.08. (später, gleiche Session): Registrierungsort = **Antigravity**. Parent-Prozess-Kette: `/Applications/Antigravity.app/.../language_server` → `npm exec mcp-remote https://mcp.atlassian.com/v1/sse` — der Atlassian Rovo MCP wurde mal in Antigravity aktiviert. Liegt NICHT in `~/.gemini/antigravity/mcp/` (nur Google-/Chrome-/GitHub-Server dort) → interne Verwaltung, **nur über Antigravity-UI (Einstellungen → MCP/Tools → Atlassian Rovo entfernen)** endgültig löschbar. Prozesse stoppen temporaär: `pkill -f mcp.atlassian.com` — kehren bei jedem Antigravity-Start zurück, bis UI-Entfernung. Zusatz-Diagnose-Schritt wenn PID wechselt/wiederkommt: `ps -o ppid= -p <pid>` → Parent identifizieren (liefert den schuldigen Client).
