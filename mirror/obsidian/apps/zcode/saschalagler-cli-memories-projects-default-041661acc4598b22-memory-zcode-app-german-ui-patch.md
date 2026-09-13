---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/zcode-app-german-ui-patch.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
name: zcode-app-german-ui-patch
description: ZCode-App-UI Deutsch — i18n-Fakten (nur langEN.js/langZH.js in app.asar)
  + Patch-Rezept (EN-Slot ersetzen, codesign, Re-Patch nach Updates); 13.09. auf
  Nutzer-Stopp PAUSIERT, nichts gepatcht
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Status 13.09.2026: PAUSIERT auf Nutzer-STOPP** (er lenkte auf native Automations um; der Deutsch-Wunsch bleibt bestehen, „DU SOLLST DIE GANZE APP DAS INTERFACE DIE UI DEUTSCH MACHEN").

**Verifizierte i18n-Fakten (App: /Applications/ZCode.app, Bundle dev.zcode.app, v0.16.5):**
- Electron-App, UI-Strings in `Contents/Resources/app.asar`.
- i18n-System vorhanden: `i18n/langEN.js` + `i18n/langZH.js` (im asar-Header per grep sichtbar), API-Fragmente `i18n.setLanguage`, `i18n.addTranslation`, `i18n.addTranslation`-Prompt-Funktion.
- **Deutsch existiert NICHT** — nur EN + ZH. `Resources/config/default.json` kennt nur zh-CN/en-US community URLs.
- `config.json` (User) hat KEIN language/locale-Setting.

**Patch-Rezept (ausgearbeitet, noch nicht ausgeführt):**
1. `npx --yes @electron/asar extract` → /tmp (getestet, funktioniert; Struktur: node_modules/, out/, package.json).
2. `langEN.js` analysieren → Keys behalten (EN), Values durch deutsche Übersetzung ersetzen (= Deutsch im EN-Slot, keine Sprach-Registrierung nötig).
3. asar repacken + **Backup `app.asar.orig`** + `codesign --force --deep -s -` (Neu-Signierung Pflicht, sonst Gatekeeper; Achtung macOS-27-Beta-AMFI, siehe [[macos-27-beta-status]]).
4. Re-Patch-Skript (z. B. `~/.agents/tools/zcode_german_patch.sh`) — App-Updates überschreiben den Patch.
5. ZCode-Neustart + Textbeleg als Beweis.

**Risiko:** Auto-Update macht Patch zunichte → Re-Patch-Skript ist Teil des Designs.
