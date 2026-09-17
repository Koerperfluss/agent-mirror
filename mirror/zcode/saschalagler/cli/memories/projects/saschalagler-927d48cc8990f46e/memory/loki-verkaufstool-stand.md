---
name: loki-verkaufstool-stand
description: LOKI Verkaufstool (eBay+willhaben) — Repo ~/loki-verkaufstool (Port 8077),
  7-Objekt-VERKAUF + LIVE-MARKT-ANALYSE (641 € Ziel, +107 € via echte eBay-Anzeigen);
  eBay-Dev-Konto "fritzlphantom" (bahldorfa@gmail.com!) — Keys nur via Portal-Login (Passwort=user-only);
  Gemini-Credits aufgebraucht; nie Saschas echten Chrome fernsteuern (Workday-Incident)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_415f90b8-06e6-414b-8ea5-c4c65864b581
---

LOKI Verkaufstool (eBay + willhaben, Stand 16.09. ~10:45):

- **Tool/Repo:** `~/loki-verkaufstool/` — FastAPI + Gemini-Vision + Preis-Pipeline + willhaben-Playwright (Stop vor Publish) + eBay Inventory/Browse-API. Start: `scripts/start.sh` → Port 8077. Git final `39c8361`; Review PASS.
- **Foto-Ordner:** Originale `~/Desktop/TO DOS /moo ebay/` (17 Fotos); Verkaufspakete `…/moo ebay/VERKAUF/` — 7 Objekt-Ordner, je fotos/ + eBay-Anzeige.md + willhaben-Anzeige.txt + PREIS.md + **UEBERSICHT.md** (Master-Tabelle).
- **LIVE-MARKT-ANALYSE 16.09. (Sascha-Download „die Titel analysieren" = echte Marktpreise, keine Schätzungen):** via zai-MCP `web_search_prime` (ebay.de/ebay.com-Anzeigen als Beweise). Ergebnis Zielsumme **641 €** (vorher 534 €): 01 Web-IO 219 € VB (Konkurrent eBay.de identisch 200 € gebraucht, Nachfolger 258 €) · 02 LOGO! 24R 49 € ⬆ (exakt-Modell $59.99+$71.91) · 03 LOGO! DM8 45 € ✓ · 04 S7-200 CPU 224 55 € ✓ · 05 MOXA E2210 **129 €** ⬆⬆ (NEU 517 €, gebraucht ~135 €) · 06 Nook 25 € ⬆ · 07 HMI-Konvolut **119 €** ⬆⬆ (Siemens-HMI-Vergleich: TP170A 80/TP177A 135/TP177B 290 € — größter Hebel: Typenschild-Foto → Einzelpreise!). Alle PREIS.md + 14 Vorlagen synchronisiert (grep-verifiziert).
- **Foto-Korrektur 16.09. (Label-Beweis):** „S7-1200 1214C" war falsch = **S7-200 CPU 224** (6ES7 214-1BD23-0XB0, IMG_0912+0913 ein Objekt). 3 „MOXA E1210/E1242"-Fotos = alle **ein** ioLogik E2210 (SN TAAF0312146S5). Sascha sagte „6 Objekte" — Foto-Beweis 7; offen: LOGO! 24R+DM8 als Set? Auf „LOGO zusammen"/„7 lassen" warten.
- **🔑 eBay-Dev-Konto gefunden (16.09., aus PDF per Vision-OCR):** Username **„fritzlphantom"**, registriert auf **bahldorfa@gmail.com** (NICHT koerperfluss@gmail.com — deshalb fanden alle Suchen nichts!). Freigeschaltet seit 14.09. Keys stehen NICHT in der Mail → developer.ebay.com/my/keys hinter Portal-Login. **Login-Fenster liegt vorbereitet im 9223-CDP-Browser, Username „fritzlphantom" eingetragen** — Sascha muss nur Passwort tippen + „drin" sagen; dann Keys → ~/.zshenv → OAuth-Verifizierung + Listings scharf.
- **eBay-Portal-Restroute:** `developer.ebay.com/my/keys?return_to` → „SORRY"-Fehler; direkt `developer.ebay.com/signin` öffnen, „Sign In"-Link klicken, Formular: Username/Password-Felder. agent-browser-Syntax: `agent-browser type @e27 "text"` (Selektor ZUERST).
- **Gemini-Key 16.09. endgültig:** GÜLTIG, aber **„prepayment credits depleted"** (429) = Guthaben aufgebraucht, KEIN Tageslimit-Reset — passt zu GCP-Billing-Überfälligkeit (Projekt 015D43, 24,08 €). Cron-Automatik (automation-8958fdfe) wieder GELÖSCHT. Vision-Aufgabe ohnehin abgeschlossen (native Vision). Modell: `gemini-2.5-flash` (2.0-flash = 404 für diesen Key).
- **Gmail-Zugriff: ALLE Automatik-Wege zu:** google-workspace-MCP gmail_* → Permission denied; AutoClaw-mcporter → Gateway offline; MCP-Automations-Chrome → Google blockt („nicht sicher"); Apple Mail → kein Gmail-Account, keine eBay-Mails (auch Junk/Trash/Archive geprüft).
- **⚠️ Computer-Use-Lektion:** SASCHAS ECHTEN CHROME NICHT PER TASTATUR FERNSTEUERN — Eingaben landeten im Workday-Bewerbungs-Tab (CGM, Schritt 2/7, nichts submitted). Nur CDP-Browser 9223 oder Element-Klicks.
- **PDF/Chat-Parse-Workaround (16.09.):** Chat-PDF-Input crasht (Provider-Fehler 1210, GLM-5.3-Flash). Route: `qlmanage -t -s 1600 -o /tmp file.pdf` → PNG → zai-MCP `extract_text_from_screenshot` mit **CDN-URL** (lokaler Pfad timeout). pdftotext bringt bei Bild-PDFs nichts.
- **CDP-Restroute:** `agent-browser`-CLI (`/opt/homebrew/bin/agent-browser`); Bewerbungs-Chrome (Profil `~/.cache/bewerbung-browser`) mit CDP **Port 9223** — dort zeigt Google das NORMALE Login-Formular. Verwaister chrome-devtools-mcp-Chrome blockiert MCP-Start → kill derPid löst es.
- **Markt-Recherche-Routen:** eBay-Sold-Listings (LH_Sold) hinter Login/„Einloggen"-Wall — NICHT ohne Account holbar; eBay-Suche im CDP-Browser → „Something went wrong"-Bot-Wall. **Funktioniert:** `web_search_prime` (Query mit „ebay preis EUR") + webReader nur ohne Sonderzeichen-URL-Fehler. eBay.de-Preise erscheinen auch über ebay.com-Ergebnisse.
- **GEMINI-KONSOLIDIERUNG 16.09. (Gemini-Chat 0842b0259a5c15a2 übernommen):** Objekt 07 = **Beijer/Mitsubishi E1011** HMI (Type 0740-074, 6.5" TFT, Schutzfolie drauf) — Konvolut-Ordner umbenannt in `07_Beijer_Mitsubishi_E1011_HMI`, **einzeln 299 € VB** (Markt 250–450+ €, Serie abgekündigt). Weitere Korrekturen: 03 DM8 45→**69 €** (NEU/OVP-Aufschlag), 04 S7-200 55→**89 €** (Legacy 75–114 €). **Finale Zielsumme 885 €** (534 Schätzung → 641 Live → 885 final). Alle 14 Vorlagen + UEBERSICHT.md sync (grep-verifiziert: 219/49/69/89/129/25/299 EUR).
- Offen: (1) Saschas Passwort-Tipp im vorbereiteten Login-Fenster → Keys → A3/A4 scharf. (2) LOGO-Set-Entscheidung. (3) E1011 wirklich fabrikneu/unbenutzt? → dann 990–1290 € statt 299 € (Gemini-NEU-Szenario).
- Unterricht: Foto-Erkennung mit native Vision (Read-Tool, 0 Credits); Typenschild-Foto = Identitäts-Beweis.

Verwandt: [[sascha-local-infra-ports]], [[cline-code-app-hub-1006-diagnosis]]
