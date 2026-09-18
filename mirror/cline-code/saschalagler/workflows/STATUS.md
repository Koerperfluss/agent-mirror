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

# STATUS — 2026-09-07

## Behoben: Cline CLI 'zsh: killed' unter macOS 27
- Ursache: macOS 27 AMFI killt linker-signed Ad-hoc-Binaries bei Page-in ('no CMS blob', cs_invalid_page). Cline-postinstall legt bin/.cline als Hardlink an -> Validierung schlägt fehl.
- Fix: Update auf cline@3.0.61 + Hardlink durch Kopie ersetzt + codesign --force --sign - (Skript: ~/fix-cline-macos27.sh — nach jedem npm-Update erneut ausführen!)
- Backup des alten Binaries: /tmp/cline-binary-backup-3.0.60
- Offen: Desktop-App-Fehler 'Desktop backend transport closed' + 'Unauthorized: re-authenticate' -> Neuanmeldung im Cline-Account nötig (App + CLI).

# STATUS — 2026-09-18: FFG 68209806 (Körperfluss Edu) Neueinreichung fix fertig — S1–S5 PASS, UPLOAD_eCall_SLOTS_2026-09-18/ + PLAN.md im Paket. HITL: eCall-Portal (B1/B6/C), Unterschriften (B7), Leons CV-Daten (B4b), SMS-Versand (B5). Mauerhart-CV = Alt-Leiche (Nutzer-Entscheid), ungelöscht in NACHWEISE/.

# STATUS — 2026-09-18 (2): FFG 68209806 Design-Build abgeschlossen (9/9 PDFs Braun/Gold, Bündel refreshed, Backups in _ALT/). QA-Verifikation: 0 Alt-Referenzen, MD↔PDF-Integrität belegt, visuelle Checks PASS. HITL unverändert (B1/B2/B4b/B5/B6/B7/C). EOF
echo '--- Doku-Updates fertig ---' && tail -3 PLAN.md | head -1 && ls -la UPLOAD_eCall_SLOTS_2026-09-18/MANIFEST.md

# STATUS — 2026-09-18 (2): FFG-PDF Design-Refresh fertig — PDF_DESIGN_BAUEN.sh, 9 PDFs Braun/Gold + Signatur-Grids + Multiset-Proof 100 %, Upload-Bündel refreshed. Route skill-router: loki-dev (kein dedizierter PDF-Skill).

# STATUS — 2026-09-18 (3): FFG 68209806 „Neueinreichung“ aus allen Einreichungsdokumenten entfernt (11/11 PDFs = 0 Treffer, Kernzahlen intakt, Bündel refreshed). 8 Kritikpunkte verankert (Investigator-Belege). Offen (Nutzer): K6-Didaktik-Rolle, K7-Zahlenspanne, HITL (CV/Unterschriften/eCall).

## 2026-09-18 QA (qa-tester): FFG-Paket 68209806 End-Abnahme nach Sprach-Fix
- Ergebnis: 6/6 PASS, GESAMTVERDICT: PASS (einreichbereit)
- Neueinreichung=0 in allen 11 Root-PDFs; Einreichung/Einreichfassung sauber; Kernzahlen 3x/3x/3x (00) + eCall korrekt; K2/K3/K5/K8-Verankerung belegt; Bündel-Sync md5 identisch (7/7 Paare); Alt-Referenzen=0 (00/05/06)
- Hinweis: SLOT_03/04/05 enthalten Bündel-exklusive Nachweise (CV Fischer/Lagler, LOI, Kapitalnachweis) ohne Root-PDF-Gegenstück — strukturell korrekt
