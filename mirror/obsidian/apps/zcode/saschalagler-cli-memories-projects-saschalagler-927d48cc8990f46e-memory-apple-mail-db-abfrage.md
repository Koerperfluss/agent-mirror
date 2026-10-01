---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/apple-mail-db-abfrage.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

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
- Bewiesener Realfall (01.10., Google-for-Startups-Verlauf): 24.03. Jose Alberto Pérez Rego josealbertop@google.com (via TP Barcelona) — Credits-Antrag 23.03. steckte im Start-Tier 2.000 $, er bot höheres Tier an + 4 Eligibility-Fragen → Sascha antwortete vollständig 27.03./01.04. → **SEITDEM STILLE** (keine Tier-Zuordnung) · 25.06. Rossignolo (xWF Business Developer) Termin-Angebot unbeantwortet · 04.09. Support-Bot **Case #00303154** (5-Werktage-Versprechen gebrochen) · Saschas 23.09.-Follow-up war LEER (nur „." — faktisch inhaltslos!). googleforstartups-noreply-Mails sind Newsletter, KEINE Antworten — nicht verwechseln.
- **Mail-Verlauf-Doku als Quelle (01.10. bewiesen):** Sascha wirft Mail-PDF-Exporte (Gmail-Druckansicht als PDF) einfach in den Chat — die komplette Case-Historie lässt sich daraus rekonstruieren; IMMER nach derartigen Anhängen fragen-prüfen, ob der bestehende Fall-Thread (Case-Nummer!, Absender-Account, „reply to this message first"-Klausel) die richtige Antwort-Strategie bestimmt.
- **Sender-Falle (01.10.):** `make new outgoing message` nimmt Mail.app-Standard-Account (war koerperfuss@icloud.com — FALSCH für einen Fall, der auf sascha.lagler@koerperfluss.at läuft!). Fix: `set sender of newMsg to "..."` nach Erstellung (settable). Alte falsch offene Fenster schließen: `close (every outgoing message whose subject contains "X") saving no`. AppleScript-Kontrollfluss: der sender-set gehört in try (Account kann fehlen).
- **Case-Recap-Pattern:** Follow-up-Mail muss Historie rekapitulieren (Antragsdatum → Fragen → Antworten-Datum → Stille seit…) + konkrete Fragen stellen (Status? Was fehlt? Call?) — nicht nur „kurzes Follow-up" (Sascha-Vorwurf „ist das eine sinnvolle Email?" beim ersten Entwurf berechtigt).
- **ÜBERSEHENE THREAD-Mails (01.10. Korrektur):** Ein Mail-DB-Scan nach Absender-LIKE übersieht Antworten aus ZWEIT-Adressen desselben Google-Teams: Jose Alberto schrieb 02.04./07.04. von **josealbertop@xwf.google.com** (xWF = Teleperformance-Zweitadresse, parallel zu josealbertop@google.com!) — meine früheren `%google%`-Scans listeten sie trotzdem nicht prominent. **Bei Case-Rekonstruktion IMMER alle Adressvarianten des Teams abfragen** (`xwf.google.com OR google.com`) und den Komplett-Thread von Sascha als PDFs anfordern (er liefert sie) — der 02.04.-Mail-Inhalt (Website-Bedingungen + Spending-Timeline + „dann buche ich den Territory-Manager") war DER offen gebliebene Punkt, nicht Google-Stille.
- **Accounts-Check per AppleScript (zuverlässiger als atplist-Files):** `osascript -e 'tell application "Mail" to get email addresses of every account'` → Saschas 3 Absender: koerperfuss@icloud.com (iCloud-Standard!), sascha.lagler@koerperfluss.at (Case-Account), startup@koerperfluss.at. atplist via plutil lief leer — AppleScript ist der verlässliche Weg.
- **KORREKTUR (01.10. ~09:45, Mail-DB-Beweis — ältere Einträge hier sind FALSCH):** Apple Mail hat DOCH das Gmail-Konto koerperfluss@gmail.com (IMAP-Account `E501B849-…`, Ordner `imap://E501B849-…/Archive|Drafts|Sent%20Messages` in mailboxes-Tabelle). Saschas „natürlich nicht" bezog sich auf die Frage, OB ER ÜBER MAIL ARBEITET — nicht ob das Konto existiert. .eml-Dateien öffnen in Mail problemlos als lesbare Nachricht mit Anhang (SVS-.eml live gezeigt). **Aber: er sendet darüber NICHT** — .eml-Doppelklick importiert die Mail nur (landet im Ordner **Archive** statt als Entwurf/Send-Fenster zu erscheinen); sein tatsächlicher Sendeweg bleibt Gmail-Web-Compose-Links + PDFs reinziehen.
- **Gesendet-Check-Rezept (01.10. bewiesen):** `SELECT s.subject, mb.url, datetime(m.date_sent+978307200,'unixepoch','localtime') FROM messages m JOIN subjects s ON m.subject=s.ROWID JOIN mailboxes mb ON m.mailbox=mb.ROWID WHERE …` — `mb.url LIKE '%Sent%'` ist der verlässliche Sent-Test; importierte/geöffnete .eml stehen nur unter `/Archive`. DB vor Abfrage nach /tmp kopieren (inkl. -wal). Datum zeigt 2057 (bekanntes Offset-Artefakt, hier über date_sent statt date_received).
- **Send-Status der 5 Rechtsfall-Mails (01.10. ~09:45 bewiesen):** KEINE gesendet — Sent-Ordner enthält nur alte Google-Case-Mails (letzte 01:56 = Case #00303154); Strafen-.eml nur in Archive (Bauzeit 08:20), die anderen 4 fehlen komplett in der DB. Bei „sind die gesendet?" IMMER Sent-Ordner per DB prüfen, nie Screenshots glauben (geöffnete .eml sieht wie gesendet aus: To/Anhang/Timestamp sichtbar).

Verwandt: [[koerperfluss-edu-foerderpilot-fertig]] (GfS-Mail-Verlauf dort), [[chrome-agent-browser-fix]].
