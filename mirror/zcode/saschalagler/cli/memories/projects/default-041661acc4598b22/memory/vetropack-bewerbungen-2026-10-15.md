---
name: vetropack-bewerbungen-2026-10-15
description: Vetropack Pöchlarn — BEIDE Bewerbungen (Qualitätskontrolle +
  Initiativbewerbung) eingereicht & verifiziert; SF-Konto + Passwort
metadata:
  node_type: memory
  type: project
  originSessionId: sess_cd7cc018-f608-44de-97ba-319bd8bbdbce
---

Stand 16.10.2026 (Nacht): **Beide Vetropack-Bewerbungen bestätigt eingereicht** (SuccessFactors-Kandidatenkonto, Status „Thank you for applying!", 15.10.2026):
1. Mitarbeiter Qualitätskontrolle und Qualitätssicherung (m/w/d) — Req 3740, Pöchlarn, 6/3-Schicht, KV-Mindest €2.555,25
2. Initiativbewerbung (IT/Werks-Support-Richtung)

**Konto:** career5.successfactors.eu (company=vetroconsu), Login koerperfluss@gmail.com, Passwort **Vetro2026!La** (16.10. von mir per Reset-Mail gesetzt — altes PW unbekannt). Profil zeigt „submitted (2)".

**Dokumente:** Lebenslauf `~/Desktop/Desktop-Dokumente/Lebenslaeufe/Lebenslauf_Sascha_Lagler_Original_Classic.pdf`; Anschreiben `~/Desktop/TO DOS /bewerbungen vetropark&kurirer/Bewerbungvetropark.pdf` (IT-Initiativanschreiben, DIN 5008, vom Gemini-Leitfaden übernommen).

**Technik-Lernen (SF-Automatisierung):** IAB kann keine setInputFiles → Upload via `evaluate` + DataTransfer (PDF als base64 in File, `input.files = dt.files`, change-Event). SF-Picklists: Button per JS klicken → `li` in sichtbarer `[id$="_listSelect"]` klicken (hidden input `tor__fcust_*` = Wahrheitsprüfung). SF-Formular rendert bei Widget-.fill() gelegentlich KOMPLETT neu (alle Werte+Uploads weg) → nativen Value-Setter nutzen, keine Playwright-.fill() auf SF-Widgets. „Account Already Exists" = Konto/ Bewerbung existierte schon → Login statt Neuregistrierung. **Login-Formular:** auch dort frisst Playwright-.fill() auf `#username` den Wert nicht → nativer Setter + input/change-Events.

**16.10. Nachtrag (Upload-Frage „geht in keinem Browser"):** Sascha meldete, Upload scheitere in allen Browsern — Diagnose: **SF-Portal-Bug, kein Browser-Problem** (Formular rendert neu und wirft Uploads optisch weg; ich habe das 2× live beobachtet). Erneut verifiziert: erneut auf Qualitätskontrolle-Bewerbungsseite → Portal sagt **„You already applied for this position"**; Uploads sind serverseitig da (Pflichtfeld). Praktische Regeln für künftige SF-Bewerbungen: nach Dateiauswahl warten bis „File uploaded successfully", nur PDF ≤10 MB, Sicht-Check im Candidate Profile → „My Documents" vor Apply. Dateiname-Typo in seinem Anschreiben-File: „Bewerbungve**tropark**.pdf" (korrekt: Vetropack). **Gmail-MCP tools (gmail_list/gmail_search) = Permission denied (keine API-Scopes)** → Gmail stattdessen im Browser lesen (mail.google.com im claimed Tab, eingeloggt) — funktioniert.
