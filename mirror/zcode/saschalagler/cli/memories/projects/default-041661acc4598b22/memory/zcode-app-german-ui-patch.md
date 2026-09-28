---
name: zcode-app-german-ui-patch
description: "ZCode-UI Deutsch 13.09. PAUSIERT (wartet auf „weiter übersetzen"): echte Strings in out/renderer/assets/IntlProvider-Db46X9QF.js (react-intl); EN-Dict m=Zeichen-Offsets 252479–583376, 5066 Paare — Extraktions-Artefakte unter /tmp/zcode_i18n/ SEIT 21.09. WEG (tmp flüchtig) → Recovery aus alter Session sess_adac…be06c60c0f (13.09.) oder Re-Extraktion (~10 Min); bei „weiter übersetzen": Artefakte nach ~/.agents/ persistieren, de_parts bauen, m-Dict patchen, repacken, codesign"
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Status 13.09.2026 abends: AKTIVE Baustelle** (Nutzer-Befehl: „die app auf deutsch stellen nativ am mac kein web"). Bisher NICHTS an der App gepatcht — App-Binary unangetastet, nur gelesen.

## Korrigierte i18n-Fakten (wichtige Falschspur bereinigt!)
- **`i18n/langEN.js`+`langZH.js` war eine FALSCHSPUR** (grepte node_modules-Artefakte). Die ECHTEN UI-Strings: **`out/renderer/assets/IntlProvider-Db46X9QF.js`** (660 KB / 586.404 Zeichen, react-intl) — asar entpackt unter `/tmp/zcode_asar` (flüchtig!).
- Struktur (exakt vermessen): ZH-Dict `p` = `{` bei Offset 709, `}` bei 252475 (backtick-bewusst gescannt). Direkt danach **`,m={`** = EN-Dict: **START 252479, END 583376**; dahinter folgt `},h=n(),g={"zh-CN":p,"en-US":m}` (Beweis: m = EN-Dict, g = Locale-Map). **Offsets = Zeichen (UTF-8-dekodiert), NICHT Bytes!**
- **5066 Paare** in m (identisch zu p, nur 8 Key-Differenzen), Keys wie `settings.locale.system`, Werte in Backticks. App-Locale-Setting existiert nativ: „System default / 中文简体 / English" — **Deutsch fehlt** → Patch = deutsche Values ins EN-Dict `m` (App auf English/Default stellen).
- App: /Applications/ZCode.app, dev.zcode.app, v0.16.5, Electron.

## Extraktions-Artefakte (fertig)
- `/tmp/zcode_i18n/en_strings.json` (411 KB, 5066 Einträge `[{"k","v"}]`, validiert, 0 doppelte Keys)
- `/tmp/zcode_i18n/extract.py` (Scanner + Parser + Gates) · `/tmp/zcode_i18n/en_region.txt` (START/END)
- **Lücke:** 9 Keys mit Werten in doppelten Anführungszeichen statt Backticks (u. a. `bots.setup.guide.*`, `settings.skills.diagnostics.code.*`) nicht extrahiert — beim Patchen nachliefern oder unberührt lassen.

## Offene Schritte (bei „weiter übersetzen")
0. **⚠️ RECOVERY ERST (21.09. bestätigt):** Die Extraktions-Artefakte unter `/tmp/zcode_i18n/` (en_strings.json, extract.py, en_region.txt) sind **WEG** — /tmp ist flüchtig, Abschließer-Sweep 21.09. fand sie nicht (find/mdfind über Desktop, ~/.zcode, ~/.agents, /tmp, ~/loki-ki). **Der einzige Ort der Fakten:** alte Session `sess_adac…be06c60c0f` vom 13.09. → Re-Extraktion aus dem Session-Archiv (`~/.zcode/cli/log/archive/` bzw. Rollouts) ODER Neuintegration (~10 Min, Offsets im Kopf: ZH 709–252475, EN **252479–583376**, 5066 Paare, Zeichen-Offsets!). Lesson: Extraktions-Artefakte nie nach /tmp — ab jetzt nach `~/.agents/` persistieren.
1. Übersetzung in 3 Slices (0–1699 / 1700–3399 / 3400–5065) via implementer-Subagents → `de_part1..3.json` (PERSISTENT ablegen!); Gates: Anzahl, Key-Reihenfolge identisch, `{placeholder}`-Parität Ziel 0 Verstöße, json.tool valid. (2 Wellen durch Nutzer-Interrupts abgebrochen.)
2. m-Dict-Region (252479–583376) durch DE-Dict ersetzen (Backtick-Escapes beachten), asar repacken. Achtung: andere Sessions haben seit 13.09. config.json verändert (17 MCP-Server, 4 SessionStart-Hooks) — betrifft asar nicht, aber Neustart beendet laufende dwf-Workflows → nur in einer Sascha-Session ohne aktive Workflows.
3. **Backup `app.asar.orig`** + `codesign --force --deep -s -` (macOS-27-Beta-AMFI, siehe [[macos-27-beta-status]]) + Re-Patch-Skript gegen App-Updates.
4. ZCode-Neustart + Textbeleg als Beweis. Lücke: 9 Keys mit Double-Quote-Werten (u. a. `bots.setup.guide.*`) beim Patchen nachliefern oder unberührt lassen.
