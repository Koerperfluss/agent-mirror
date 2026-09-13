---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/zcode-app-german-ui-patch.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
name: zcode-app-german-ui-patch
description: "ZCode-UI Deutsch 13.09. AKTIV: echte Strings NICHT in langEN.js sondern in out/renderer/assets/IntlProvider-Db46X9QF.js (react-intl); EN-Dict m=Offset 252479–583376, 5066 Paare extrahiert nach /tmp/zcode_i18n/; Übersetzung 2× abgebrochen — bei „weiter übersetzen": de_parts bauen, m-Dict patchen, repacken, codesign"
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
1. Übersetzung in 3 Slices (0–1699 / 1700–3399 / 3400–5065) via implementer-Subagents → `/tmp/zcode_i18n/de_part1..3.json`; Gates: Anzahl, Key-Reihenfolge identisch, `{placeholder}`-Parität Ziel 0 Verstöße, json.tool valid. (2 Wellen bereits durch Nutzer-Interrupts abgebrochen.)
2. m-Dict-Region (252479–583376) durch DE-Dict ersetzen (Backtick-Escapes ` \` ` beachten), asar repacken.
3. **Backup `app.asar.orig`** + `codesign --force --deep -s -` (macOS-27-Beta-AMFI, siehe [[macos-27-beta-status]]) + Re-Patch-Skript gegen App-Updates.
4. ZCode-Neustart + Textbeleg als Beweis.
