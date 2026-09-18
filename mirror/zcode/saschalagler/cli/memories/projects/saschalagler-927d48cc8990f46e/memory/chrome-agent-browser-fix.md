---
name: chrome-agent-browser-fix
description: Chrome-136-Regel — Remote-Debugging-Port ignoriert im
  Standard-Profil; ZCode/Cline brauchen dedizierten Agent-Browser mit eigenem
  user-data-dir
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5ee29b3e-cfe1-414a-8c01-02ec99f260a6
---

Stand 18.09.2026 — **AUSGEFÜHRT + VERIFIZIERT**: Agent-Chrome läuft auf `http://127.0.0.1:9222` (curl-Beweis: Chrome/153.0.8010.52) mit **persistentem** Profil `~/.zcode/chrome-agent-profile` (Login bleibt! Sascha hasst Neu-Einloggen — deshalb KEIN isoliertes Wegwerf-Profil).

**Konfig geändert:**
- `~/.mcp.json` ist ein **Symlink** auf `~/.cline/data/settings/cline_mcp_settings.json` — eine Änderung wirkt auf ZCode UND Cline.
- chrome-devtools-MCP: `--browserUrl=http://127.0.0.1:9222` · claude-mem: 13.18.0 → **13.24.23**.
- **30 doppelte** alte claude-mem-13.18.0-Server gekillt (jede Session hatte einen gestartet, keiner wurde beendet).
- `~/.zshenv`: `CHROME_PATH` + `CHROME_DEVTOOLS_URL`.
- Setup-Doc: `~/.agents/CHROME_AGENT_SETUP.md` · Backup: `~/.mcp.json.bak-20260918`.

**Root-Cause-Regel:** Chrome 136+ ignoriert `--remote-debugging-port` im Standard-User-Data-Dir → Agents bauten Wegwerf-Chromes ohne Cookies → ständiges Neu-Einloggen + Cache-Lock. Fix = feste Adresse + persistentes Profil.

**Flags (Chrome 153):** `#local-network-access-check` → Disabled (blockiert sonst localhost: LOKI 8010, OmniRoute 20128, Open-WebUI 8080) · `#devtools-protocol-monitor` → Enabled · `#use-persistent-cache-for-code-cache` → Disabled bei Render-Problemen. Port 9222 nur auf 127.0.0.1 (LAN-RCE-Risiko).

**Nachtrag 18.09. (Saschas echtes Problem „Websites zeigen alten Stand"):** Root-Cause = Service-Worker-Cache im Haupt-Profil: `~/Library/Application Support/Google/Chrome/Default/Service Worker/` — 5,8 MB ScriptCache, 177 Worker (überlebt „Cache löschen" in den Einstellungen!). Plus HTTP-Cache 21 MB + Code-Cache 12 MB in `~/Library/Caches/Google/Chrome/Default`. Fix-Script: **`~/.agents/tools/chrome-cache-nuke.sh`** (beendet Chrome, löscht alle 4 Schichten, startet Haupt+Agent neu) — Ausführung nur mit GO. Zweiter Live-Fund: ohne `--remote-allow-origins='*'` blockiert Chrome WebSocket-CDP mit 403 — Flag ist im Agent-Launch PFLICHT.
