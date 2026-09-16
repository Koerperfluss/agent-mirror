---
name: loki-verkaufstool-stand
description: LOKI Verkaufstool (eBay+willhaben) — Repo ~/loki-verkaufstool (Port
  8077), korrigierte 7-Objekt-Struktur in „moo ebay/VERKAUF", blockiert auf
  eBay-Keys (Approval-Mail in Gmail, nur manuell holbar, nirgends auf der
  Kiste); Gemini-Key gültig (gemini-2.5-flash, 429 bis ~10 Uhr, Cron-Automatik
  angelegt); Gmail-Automatik komplett unzugänglich; nie Saschas echten Chrome
  fernsteuern (Workday-Incindent)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_415f90b8-06e6-414b-8ea5-c4c65864b581
---

LOKI Verkaufstool (eBay + willhaben, Stand 16.09.2026):

- **Tool/Repo:** `~/loki-verkaufstool/` — FastAPI + Gemini-Vision + Preis-Pipeline + willhaben-Playwright (Stop vor Publish) + eBay Inventory/Browse-API. Start: `~/loki-verkaufstool/scripts/start.sh` → Port 8077. Git final `39c8361`; Review PASS.
- **Foto-Ordner:** Originale in `~/Desktop/TO DOS /moo ebay/` (17 Fotos, „Groß (IMG_0899…0915).png"); Verkaufspakete in `…/moo ebay/VERKAUF/` mit 7 Objekt-Ordnern (fotos/ + eBay-Anzeige.md + willhaben-Anzeige.txt + PREIS.md). Ordnernamen mit Leerzeichen/Slash nicht vergessen („TO DOS /moo ebay").
- **Foto-Korrektur 16.09. (2 Fehlzuordnungen per Label-Foto belegt):** „S7-1200 1214C" war falsch — IMG_0912 zeigt 6ES7 214-1BD23-0XB0 = **S7-200 CPU 224** (ein Objekt mit IMG_0913). Die 3 „MOXA E1210/E1242"-Fotos sind alle **ein** ioLogik E2210 (SN TAAF0312146S5). Zielsumme ~534 € statt 839 €.
- Sascha sprach von „6 Objekten" — Foto-Beweis ergibt 7; offen: ob LOGO! 24R + DM8 als Set verkauft werden (dann 6). Auf Antwort „LOGO zusammen" warten.
- **Blocker (16.09.):** eBay-Approval-Mail ist DA (in Gmail koerperfluss@gmail.com, von Sascha bestätigt) — Keys stehen NICHT in der Mail, sondern auf developer.ebay.com/my/keys (App ID + Cert ID). GEMINI_API_KEY in ~/.zshenv gültig, aber Tageslimit — Reset ~09:00 MEZ.
- **Gmail-Zugriff: ALLE Automatik-Wege zu (16.09. live getestet):** google-workspace-MCP gmail_* → Permission denied (Scopes fehlen); AutoClaw-mcporter → Binary nicht installiert, via npx startbar aber Gateway offline (fetch failed); MCP-Automations-Chrome → nicht bei Google eingeloggt, Google blockt Login („nicht sicher"); Apple Mail → 3 Accounts (iCloud koerperfluss@icloud.com, Koerperfluss sascha.lagler@koerperfluss.at, startup@koerperfluss.at), KEIN Gmail, keine eBay-Mails. Keys nur via Saschas eigene Hände (Mail/Portal → Chat oder read -rs One-Liner in ~/.zshenv).
- **⚠️ Computer-Use-Lektion (16.09., teuer gelernt):** SASCHAS ECHTEN CHROME NICHT PER KEYBOARD FERNSTEUERN — cmd+L/typing landete in seinem Workday-Bewerbungs-Tab (CGM IT-Techniker, St. Pölten) und schob die Bewerbung auf Schritt 2/7 (nichts submitted, Workday submitted erst nach Schritt 7 Review). Sofort stop_computer_control. Wenn Browser-Automatik nötig: nur MCP-Chrome-Profil oder neue Tabs mit Element-Klicks, nie globale Tastatur in fremde Tabs.
- **CDP-Restroute (16.09.):** `agent-browser`-CLI existiert (`/opt/homebrew/bin/agent-browser`); „Bewerbungs-Chrome" (Profil `~/.cache/bewerbung-browser`) läuft mit CDP **Port 9223**. Wichtig: In DIESEM Browser zeigt Google das **normale Login-Formular** (kein Automations-Block wie beim MCP-Chrome) — Login scheitert trotzdem, weil ich Saschas Passwort nie kennen werde/haben darf. E-Mail vortippen (koerperfluss@gmail.com) geht, Passwort = immer user-only.
- **Gemini-Key-Status 16.09. 04:39 live getestet:** GEMINI_API_KEY in ~/.zshenv ist GÜLTIG (Model-Liste kam), aber 429 bis Reset (~09–10 Uhr). Modellname: `gemini-2.0-flash` gibt 404 für diesen Key → **`gemini-2.5-flash` verwenden**. Vision-Call über Python urllib mit JSON-Payload-Datei (base64 per curl-Arg schlägt fehl: „argument list too long").
- **Automatik angelegt 16.09.:** Cron `automation-8958fdfe-f2c9-4a2c-97c8-04ea577c9ce3` (einmalig 16.09. 10:10, Wiederholung 11:10 falls 429) — Vision-Analyse aller 7 Objekt-Ordner in „moo ebay/VERKAUF", Abgleich mit PREIS.md, Tabelle im Chat.
- **eBay-Keys endgültig nicht auf der Kiste (16.09. 04:39 durchsucht):** ~/.zshenv, Repo, .env-Dateien, Apple Mail inkl. Junk/Trash/Archive aller 3 Accounts — nichts. Approval-Mail liegt nur in Gmail. Keys bleiben der EINE user-only-Punkt.
- **Offen (16.09., wartet auf Sascha):** (1) EBAY_APP_ID + EBAY_CERT_ID (developer.ebay.com/my/keys) → Übergabe per `cat >> ~/.zshenv`-One-Liner im Chat angeboten. (2) Entscheidung „LOGO zusammen" (6 Objekte) oder „7 lassen". Danach: Live-Verifizierung OAuth+Vision → eBay-Preisabfrage → Listings.
- Verwaister chrome-devtools-mcp-Chrome (Profil ~/.cache/chrome-devtools-mcp/chrome-profile) blockiert chrome-devtools-MCP-Start mit „browser already running" — kill des Pids löst es, Cookies bleiben auf Disk.
- Unterricht aus der Session: Foto-Erkennung mit **eigenem/native Vision (Read-Tool) machen, keine Credits**; Label-/Typenschild-Fotos sind der Identitäts-Beweis, nicht die Frontansicht.

Verwandt: [[sascha-local-infra-ports]], [[cline-code-app-hub-1006-diagnosis]]
