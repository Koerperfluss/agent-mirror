---
name: apple-mail-db-abfrage
description: Lokale Apple-Mail-Antwort-Prüfung ohne API — sqlite3 auf Mail V10
  Envelope Index (Epoch-Offset!), Gmail-API verweigert Scopes
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

Apple Mail lokal per SQLite lesen (Sascha-Wunsch „prüf meine Mail lokal am Mac", 01.10.2026 bewiesen):

- DB: `~/Library/Mail/V10/MailData/Envelope Index` (V4 gibt es nicht mehr; immutable öffnen: `sqlite3 "file:...?immutable=1"`)
- **Apple-Epoch: `datetime(m.date_received+978307200,'unixepoch','localtime')`** (ohne Offset zeigt es ~2057 — erst 31 Jahre abziehen!)
- Joins: `addresses s ON m.sender=s.ROWID` (Absender `s.address`), `subjects sub ON m.subject=sub.ROWID` (Betreff-Text — `m.subject` selbst ist nur ID/Zahl!)
- Bewiesene Abfragen: Absender `LIKE '%googleforstartups%'`, Betreff `LIKE '%örperfluss%'`, Datum-Filter `m.date_received > strftime('%s','2026-09-20') - 978307200`
- Gmail-MCP (`google-workspace gmail_search`) schlägt fehl: „Permission denied" (Scopes nicht gewährt) — Mail-DB ist der zuverlässige lokale Weg.
- Grenze: Bodies liegen extern — für Betreff/Absender/Datum reicht der Envelope Index.
- **Senden statt Suchen (01.10. bewiesen):** gmail_send MCP = ebenfalls „Permission denied". Sauberer Weg: **Apple-Mail-Entwurf per osascript vorbereitet öffnen** (Agent schreibt Text, Sascha klickt nur Senden) — REZEPT: (1) AppleScript als **.applescript-Datei** schreiben (Inline-Heredoc scheitert an Quoting: „syntax error: „" erwartet, Unbekanntes Token" — € / Anführungszeichen im heredoc), (2) `osascript datei.applescript` → `make new outgoing message with properties {subject:..., content:..., visible:true}` + `make new to recipient`/`cc recipient` + `activate` → Mail-Fenster öffnet sich fertig adressiert in seinem Account (dort hat er am 23.09. selbst gesendet), einmalig macOS-Automation-Berechtigung bestätigen.
- Bewiesener Realfall (01.10., Google-for-Startups-Verlauf): 25.06. echter Google-Mitarbeiter-Kontakt **rossignolo@xwf.google.com** („Körperfluss - Google Cloud") · 04.09. Antwort von cloud-startup-support-bot@google.com · eigene gesendete Mail 23.09. von sascha.lagler@koerperfluss.at · **seit 23.09. keine persönliche Antwort** (nur Newsletter googleforstartups-noreply). googleforstartups-noreply-Mails sind Newsletter, KEINE Antworten — nicht verwechseln.

Verwandt: [[koerperfluss-edu-foerderpilot-fertig]] (GfS-Mail-Verlauf dort), [[chrome-agent-browser-fix]].
