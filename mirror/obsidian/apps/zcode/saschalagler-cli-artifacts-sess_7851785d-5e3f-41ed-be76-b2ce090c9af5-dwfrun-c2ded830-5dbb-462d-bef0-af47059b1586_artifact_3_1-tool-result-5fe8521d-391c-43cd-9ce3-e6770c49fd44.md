---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_7851785d-5e3f-41ed-be76-b2ce090c9af5/dwfrun-c2ded830-5dbb-462d-bef0-af47059b1586_artifact_3_1-tool-result-5fe8521d-391c-43cd-9ce3-e6770c49fd44.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

# ADHS Legal Ops Cockpit — Prüf- und Reparaturbericht

## Ergebnis
Cockpit repariert: 13 Änderungen. Automatik-Test Endstand: GRÜN — alle Links und Buttons maschinell geprüft. Ordner-Name endet auf einem echten Leerzeichen (/Users/saschalagler/Desktop/id austria neu ) — genau daran sind alle bisherigen Links gescheitert; alle PDF-Links sind jetzt URL-kodiert und gegen die Disk geprüft. Das Cockpit öffnet nichts von selbst: Gmail und PDFs starten nur auf deinen Klick.

## Die 7 Karten — belegte Fakten aus den Originaldokumenten
| Karte | Fall | Az | Betrag | Datum | Beweis | belegt |
|---|---|---|---|---|---|---|
| K1 | Kfz ME-450GA | MES1-K-264/274 |  | 22. September 2026 | RS_%20Lagler%20Sascha,%203382%20Loosdorf,%20Sebastianistra%C3%9Fe%2015(5).pdf | ✅ |
| K2 | BH Melk Strafen | MES2-V-25 33409/6 | € 3.565,30 | 23. September 2026 | Mahnung_ME_MES2-V-2533409_6.pdf | ✅ |
| K3 | Exekution GV Hinum | 141 002 E 2940/26 b | 159,00 EUR | 29.09.2026 | 141_002_E_2940-26_b-Note.pdf | ✅ |
| K4 | Grawe/SDSP | 141 002 E 2866/26 w | EUR 594,90 s.A. | 28. September 2026 | Gmail - 2 E 2866_26w (Ihr Zeichen 5261604) – Ratenzahlungsangebot, Unpfändbarkeit § 291a EO & Antrag BG Melk – Sascha Lagler.pdf | ✅ |
| K5 | SVS | VSNR 3692 210597 | 76,86 € | 22.09.2026 | H0020260923121033.pdf | ✅ |
| K6 | Grover |  |  |  | — | ❌ |
| K7 | Inkasso coeo & PAIR Finance |  |  |  | — | ❌ |

## Reparaturen
- Pfad-Korrektur: Die HTML lag nicht am Desktop-Root, sondern in '/Users/saschalagler/Desktop/id austria neu /00_ADHS_LEGAL_OPS_COCKPIT.html' (ls-Beweis) — dort repariert; zusätzlich auch eine Kopie an den im Auftrag genannten Desktop-Root-Pfad gelegt, da dort keine Datei existierte.
- Backup zuerst: cp nach '/Users/saschalagler/Desktop/00_ADHS_LEGAL_OPS_COCKPIT.html.bak-2026-10-01', SHA a506bdb9… identisch mit Original verifiziert.
- Grover-PDF erstellt (vor dem HTML): GROVER_HARDSHIP_STUNDUNGSANTRAG.typ aus der MD gesetzt, typst 0.15.1 compile OK, DIN A4 2 Seiten (pdfinfo), Signatur rechtsbündig über Linie mit 'Sascha Lagler (eigenhändig)' (pdftotext-Beweis), kopiert BOTH nach Fallakten_September_2026 UND 'id austria neu '.
- 7 Karten statt 6: task-view-1 bis task-view-7, tab-btn 1-7, totalTasks=7, check-task 1-7, 'Fall X von 7' auf jeder Karte (Mängel 1 + 7 behoben; Python-Check: 7/7/7/7).
- Karte 7 NEU: Inkasso coeo & PAIR Finance mit Empfängern aus den Fallakten-MDs übernommen (coeo: info@coeo-inkasso.de, cc service@coeo-inkasso.at; PAIR: service@pairfinance.com, cc forderung@pairfinance.com — wirklich in den MDs vorhanden, nichts erfunden), 2 separate 1-Klick-Gmail-Buttons; offen auf der Karte vermerkt: kein Beweisdokument hinterlegt.
- RIS-Links + wörtlicher Wortlaut: Rechts-Beweisköpfe (details-Elemente) mit Norm, Kurzform, RIS-Link und Original-Wortlaut für § 57 Abs. 2 AVG (K1), § 54b Abs. 1a/3 VStG (K2) und § 291a EO (K3, K4, K7) exakt aus der gelieferten JSON-Liste; 5 ris.bka.gv.at-Verweise im HTML (vorher 0).
- Alle 13 Datei-Links als href='file:///Users/saschalagler/Desktop/id%20austria%20neu%20/…' URL-kodiert (inkl. %20 am Ordnerende); Python-Verifikation: 13/13 dekodierten Pfade existieren real — inkl. RS-Bescheid mit doppelkodierten %2520/%25C3%259F im Dateinamen und Gmail-SDSP-PDF mit En-Dash/%C3%BC/%C2%A7/%26.
- Beweis-anzeigen-Links ergänzt: K1 RS-Bescheid, K2 AMS-Bescheid + Mahnung MES2-V-2533409/6, K3 GV-Note 2940/26b, K4 Gmail-SDSP-Ratenplan, K5 SVS-Zahlungserinnerung H0020260923121033; K6 und K7 sagen offen 'Kein Beweisdokument hinterlegt'.
- Karte 4 (Grawe/SDSP) umgebaut zur ERLEDIGT-Überwachungskarte: KEIN Sende-Button (wie gefordert), Erinnerung an 1. Rate 60 € am 15.10.2026 + eVB abwarten, Beweis-Link auf den Gmail-SDSP-Ratenplan.
- Raten-Daten exakt wie in den Original-PDFs übernommen: K2 Sammelantrag 35 €/Monat erste Fälligkeit 15.11.2026; K3 3 × 53 € ab 15.11.2026 mit IBAN AT22 6000 0101 1019 5295; K5 38,43 € am 15.10. + 38,43 € am 15.11.2026 (Empfänger auf svs@svs.at korrigiert, war kontakt@svs.at mit falschen Terminen 15.11./15.12.); K4 Grawe 60 € ab 15.10.2026.
- Gmail-1-Klick-Buttons jetzt klickgebaut über openGmail() mit encodeURIComponent (K1, K2, K3, K5, K6 mit cc support+hilfe@grover.com, K7 coeo + PAIR) statt handkodierter URLs; window.open ausschließlich im Klick-Handler (grep-Beweis: 1 realer Aufruf + 1 Kommentar), DOMContentLoaded-Init zeigt nur Status + Karte 1 — keine Auto-Aktion beim Laden.
- Fortschritt: localStorage (adhs_task_1-7), Fortschrittsbalken, Erledigt-Haken je Karte, Zähler 'X von 7' konsistent; Pfeiltasten-Navigation links/rechts (in Eingabefeldern deaktiviert); Altlast 'Aufgabe X von 5' komplett entfernt (0 Treffer).
- Verifikation: node --check auf das extrahierte Inline-JS (13.157 Bytes) — JS-SYNTAX OK; alle 3 Kopien per shasum identisch (9b1ffec8…).

## Automatik-Test (Endstand)
- 12 PDF-Links: alle Pfade existieren auf der Disk
- localStorage vorhanden
- Pfeiltasten-Navigation vorhanden
- 12 referenzierte PDFs: alle vorhanden

## Rechtsgrundlagen (RIS statt Judicario — das Judicario-MCP antwortet derzeit „Unbekanntes Tool“)
- **§ 57 Abs. 2 AVG** — Sascha Lagler kann gegen einen Bescheid der BH Melk binnen zwei Wochen bei der erlassenden Behörde Vorstellung erheben; aufschiebende Wirkung hat die Vorstellung nur, wenn sie gegen die Vorschreibung einer Geldleistung gerichtet ist. — [RIS](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10005768&Paragraf=57), Wortlaut abgerufen (Automatik-Linktest: HTTP 200)
- **§ 54b Abs. 1a und Abs. 3 VStG** — Bei einer Verwaltungsstrafe von BG Melk kann Sascha Lagler wegen seiner wirtschaftlichen Notlage (Beweis: Notstandshilfe 31,83 €/Tag) auf Antrag Aufschub oder Ratenzahlung verlangen, was die Strafvollstreckung aufschiebt; die Mahnung kostet zusätzlich 5 Euro Kostenbeitrag. — [RIS](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10005770&Paragraf=54b), Wortlaut abgerufen (Automatik-Linktest: HTTP 200)
- **§ 291a EO** — Für Sascha Lagler ist bei einer Forderungsexekution die Notstandshilfe (31,83 €/Tag) als Existenzminimum geschützt: Bei täglicher Leistung gilt der 30. Teil des Ausgleichszulagenrichtsatzes als unpfändbarer Grundbetrag, solange die Berechnungsgrundlage diesen nicht übersteigt. — [RIS](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=10001700&Paragraf=291a), Wortlaut abgerufen (Automatik-Linktest: HTTP 200)

## Nicht geprüft
- Karten 6 (Grover) und 7 (Inkasso): keine Beweisdokumente im Akten-Ordner — Empfänger und Forderungen müssen aus dem Gmail verifiziert werden
- Gmail-Anmeldung und tatsächlicher Versand wurden nicht getestet (nur Link-Form) — nichts wurde gesendet
- Native Legal Ops App (GUI) nicht getestet; ihr Backend auf Port 7070 lief während der Prüfung

## Unabhängiger Blick
**Ergebnis: Bericht ist im Kern belegt, hat aber 3 offene Inkonsistenzen, 6 unbelegte Behauptungen und 4 Lücken.**

## 1. Unklare Stellen
1. **"13 Änderungen"** — Zählerbasis unklar: Die Reparatur-Liste hat ~13 Bullets, aber keiner ist nummeriert; nicht nachprüfbar, was die 13 sind.
2. **12 vs. 13 PDF-Links** — Reparatur-Sektion sagt "alle 13 Datei-Links", Automatik-Test sagt "12 PDF-Links". Widerspruch, nicht aufgeklärt.
3. **Zwei verschiedene SHAs** — Backup: `a506bdb9…`, Kopien: `9b1ffec8…`. Vermutlich Original-vor-Reparatur vs. repariert, aber der Bericht erklärt es nicht.
4. **"3 Kopien"** — es werden nur 2 Orte genannt (Desktop-Root + `id austria neu `). Wo ist die dritte?
5. **"Mängel 1 + 7 behoben"** — Mängelliste wird referenziert, aber nicht gezeigt; Leser kann nicht prüfen, was Mängel 1 und 7 waren.
6. **"EUR 594,90 s.A."** (K4) — Abkürzung unklar (sicher anzunehmen: "sonstige Angaben"?), wird nicht erklärt.

## 2. Behauptungen ohne Beleg im Text
1. **"genau daran sind alle bisherigen Links gescheitert"** — Kausalbehauptung über frühere Fehlversuche; kein Fehl-Log, kein Vorher-Nachher-Beweis.
2. **"HTTP 200" bei allen 3 RIS-Links** — nur behauptet, kein curl-Output zitiert.
3. **Judicario antwortet "Unbekanntes Tool"** — keine Fehlerausgabe zitiert.
4. **Empfänger K7 "wirklich in den MDs vorhanden, nichts erfunden"** — kein MD-Dateipfad, kein Zitat.
5. **Notstandshilfe 31,83 €/Tag** — als Beweis in den Rechtsgrundlagen benutzt, aber nirgends belegt (welches Dokument?).
6. **"alle Buttons maschinell geprüft"** (Ergebnis-Zeile) — der Bericht selbst sagt unten, Gmail-Buttons nur auf Link-Form geprüft, nichts geklickt. "GRÜN — alle Links und Buttons" überzieht damit den tatsächlichen Test.

## 3. Was fehlt
1. **Kanonische Datei** — jetzt existieren 2 (bzw. 3?) aktive Kopien; der Bericht sagt nicht, welche künftig die maßgebliche ist (Änderungs-/Sync-Konflikt-Risiko).
2. **Browser-Render-Test** — nur `node --check` auf JS-Syntax; ob das HTML überhaupt lädt und die Karten darstellen, wurde nicht geprüft.
3. **Karten 6 + 7 Inhalte** — Betrag, Az, Fristen komplett leer; die Gmail-Verifikation ist nur angekündigt, nicht geliefert.
4. **Roh-Beweise** — Python-/grep-Ergebnisse werden nur zusammengefasst ("13/13", "0 Treffer"), keine Befehle + Outputs — damit ist "GRÜN" aus dem Bericht allein nicht reproduzierbar.
