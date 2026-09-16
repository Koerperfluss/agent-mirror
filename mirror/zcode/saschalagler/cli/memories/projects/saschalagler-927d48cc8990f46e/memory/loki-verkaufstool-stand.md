---
name: loki-verkaufstool-stand
description: LOKI Verkaufstool (eBay+willhaben) — Repo ~/loki-verkaufstool (Port
  8077), korrigierte 7-Objekt-Struktur in „moo ebay/VERKAUF", blockiert auf
  eBay-Approval + Gemini-Key
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
- **Blocker:** eBay-Developer-Approval läuft (Mail wartet, typ. 1–48 h) → danach Sandbox-Keys in ~/.zshenv (EBAY_APP_ID/EBAY_CERT_ID), A3/A4 scharf schalten. GEMINI_API_KEY in ~/.zshenv gültig, aber Tageslimit — Reset ~09:00 MEZ. Google-Login im Automations-Browser wird blockiert („nicht sicher") — Keys nur via Saschas eigenem Browser holen.
- Unterricht aus der Session: Foto-Erkennung mit **eigenem/native Vision (Read-Tool) machen, keine Credits**; Label-/Typenschild-Fotos sind der Identitäts-Beweis, nicht die Frontansicht.

Verwandt: [[sascha-local-infra-ports]], [[cline-code-app-hub-1006-diagnosis]]
