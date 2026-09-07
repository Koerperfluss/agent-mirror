---
app: cline-code
quelle: "saschalagler/workflows/STATUS.md"
stand: 2026-09-07
tags: [spiegel, cline-code]
---

# STATUS — LOKI.OS / Cline-Setup

> Letzte Aktualisierung: 2026-09-07 ~21:00 MESZ (Session "test")

## Heute gefixt (07.09.2026)

| # | Problem | Ursache | Fix | Status |
|---|---|---|---|---|
| 1 | Drag&Drop → "The object can not be found here." | DOM `NotFoundError` im WKWebView-Frontend; WebView-Cache (16.08.) älter als App-Update 0.0.23 (03.09.) → Frontend/Backend-Mismatch | WebKit- + Caches-Ordner als `.bak-20260907` zur Seite gelegt; App-Neustart steht aus | ⏳ TEST NÖTIG |
| 2 | "Desktop backend transport closed" (roter Banner) | Folgefehler von #1: pending IPC-Invokes werden rejected (`rejectPending`), Transport reconnects |同 #1 — Cache-Reset + Neustart | ⏳ TEST NÖTIG |
| 3 | chrome-devtools MCP kaputt | `transport`-Block zeigte auf `server-filesystem` statt chrome-devtools-mcp | Block bereinigt, `disabled:false` | ✅ |
| 4 | zai-vision Platzhalter-API-Key | `YOUR_ZAI_API_KEY` nie ersetzt | Echter Key + `disabled:true` (Duplikat zu zai-mcp-server) | ✅ |
| 5 | Rules veraltet (Stand 30.07.) | `loki-os.md` stale | Komplett refresh: 14 MCP-Server, Skill-Routing, Changelog, Fixes | ✅ |
| 6 | Backups | — | `cline_mcp_settings.json.backup-20260907_204505-vor-fix`, `loki-os.md.backup-20260907_204539-vor-refresh`, WebKit/Caches `.bak-20260907` | ✅ |

## Offene Punkte

1. **App-Neustart durch Nutzer** (Cmd+Q → neu öffnen) → dann Drop testen. Cache wird frisch gebaut.
2. Falls Drop danach IMMER noch failt: Bug in desktop-v0.0.23 (latest, kein Update verfügbar) → Workaround: Paperclip-Button statt Drag&Drop; GitHub-Issue bei cline/cline eröffnen.
3. **Multi-Skill-@-Mention**: Cline-Code-App kann nur 1 Skill pro Mention (UI-Design v0.0.23). Workaround: mehrere `/skills` hintereinander im Prompt. ZCode kann es nativ.
4. **Cline-Credits für web_search: -$0.09** — built-in Web-Search tot; Alternativen: `web-search-prime` MCP (Z.AI, 1,2 Credits/Call) oder `fetch_web_content` (gratis, GitHub-API etc.).
5. `hub-daemon.log` = 183 MB, `hooks.jsonl` = 63 MB → bei Gelegenheit rotieren (NICHT ohne GO löschen).

## Verifizierter Werkzeug-Zugang (21:00)

Shell ✅ · read_files ✅ · Sidecar :25463 ✅ · Network 200 ✅ · Docker 29.7.2 ✅ · Ollama :11434 (3 Modelle) ✅ · OmniRoute :20128 (Auth) ✅ · Python 3.14.7 ✅ · Node 26.8.1 ✅ · chrome-devtools-mcp läuft (PID 80134) ✅ · ZCode ❌ nicht installiert

## TCC-Stand (Audit 25.08.2026, tcc_audit_user.txt)

bot.cline.app: Desktop=2, Documents=2, Downloads=2, AppleEvents=2, FileProviderDomain=2, MediaLibrary=2, AppData=5 → erlaubt. Kein RemovableVolume/AllFiles-Eintrag (nur interne Volumes vorhanden).
