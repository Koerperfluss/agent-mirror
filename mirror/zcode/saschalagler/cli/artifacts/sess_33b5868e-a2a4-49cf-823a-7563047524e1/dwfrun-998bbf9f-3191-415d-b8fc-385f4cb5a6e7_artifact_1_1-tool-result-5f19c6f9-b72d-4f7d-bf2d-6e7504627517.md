# FFG-Paket-Korrekturen (01.10.2026, Nacht-Durchgang)

## Antrag (_BUILD/antrag_master.typ)

- Quelltext prüfte ich per rglob-Grep (NFD-sicher) zeilenweise: Alle 5 Audit-Korrekturen waren bereits im typ vorhanden (Vorher-Aktor, typ-mtime 2026-10-01 04:32:24) — ich bestätigte sie, baute selbst neu (typst compile, EXIT 0) und verifizierte per pypdf. (1) Zeichnungsblock: Label jetzt '*Projektteam (Information):*' (typ:422) statt 'Rechtsverbindliche Zeichnung des Antragstellers...'; Grid auf (1fr,) = EINE Zeichnungslinie 'Sascha Lagler — Projektleitung & Clinical Lead (Zeichnungsberechtigter im eCall: Sascha Lagler als Einzelperson, unbeschränkte Zeichnungsbefugnis)' (typ:425-431); der 3-Spalten-Grid 40/35/25 % ist entfernt. (2) Anlagenliste: Slot 03 = CV_Lagler_Sascha_1seitig.pdf + CV_Fischer_Peter_1seitig.pdf (typ:411-412), Slot 05 = 'Frischer Kapitalnachweis (Platzhalter — wird von Sascha Lagler vor Einreichung gelegt)' (typ:415), Slot 06 = '06_Erklaerung_V4.pdf (Platzhalter — unterschriebene Fassung folgt)' (typ:416) — die '(unterschrieben)'-Behauptung ist weg; 10_CV_Leon_Karnen_FINAL.pdf, KapitalnachweisLAglerSascha.pdf, saschakonto.pdf kommen im typ nicht mehr vor. (3) MDR: typ:142 (Badgetext) und typ:182 (Callout) tragen exakt 'rein didaktische Zweckbestimmung — kein Medizinprodukt-Einsatz im geförderten Umfang (MDR-Abgrenzung dokumentiert, Kap. 1.1)'; '100 % MDR-Frei'/'MDR-Freiheit' nicht mehr im typ. (4) 'Mauerhart'/'Lisa': 0 Treffer in typ und beiden PDFs — keine Ersetzung nötig. (5) typst 0.15.1 verfügbar; ich kompilierte nach SLOT_01_Antrag/00_ANTRAG_V4_DESIGN.pdf (EXIT 0, 323.843 B, byte-identisch zum Vor-Rebuild = deterministisch) und führte die pypdf-Verifikation selbst aus: 10 Seiten, 'Projektteam (Information)' enthalten, '40 % Gesellschafter' und 'Rechtsverbindliche Zeichnung des Antragstellers' nicht enthalten. Alt-PDF liegt als Sicherung in _ARCHIV_KORRIGIERTE/ (2026-09-21, 323.626 B, unberührt).
- Geändert: /Users/saschalagler/Desktop/Coworkspace_Ich/Körperfluss EDU/FÖRDERUNG/FFG_ReSubmission_PAKET_68209806/FINAL_entpackt/UPLOAD_eCall_SLOTS_2026-09-18/SLOT_01_Antrag/00_ANTRAG_V4_DESIGN.pdf, /Users/saschalagler/Desktop/Coworkspace_Ich/Körperfluss EDU/FÖRDERUNG/FFG_ReSubmission_PAKET_68209806/_BUILD/antrag_master.typ, /Users/saschalagler/Desktop/Coworkspace_Ich/Körperfluss EDU/FÖRDERUNG/FFG_ReSubmission_PAKET_68209806/_ARCHIV_KORRIGIERTE/00_ANTRAG_V4_DESIGN.pdf (Alt-Sicherung, bereits vorhanden — von mir nicht verändert)
- Beweis: pypdf AKTUELL (SLOT_01): Seiten=10, ENTHAELT 'Projektteam (Information)'=True, '40 % Gesellschafter'=False, 'Rechtsverbindliche Zeichnung des Antragstellers'=False. pypdf ARCHIV (Vor-Zustand): '40 % Gesellschafter'=True, 'Rechtsverbindliche Zeichnung des Antragstellers'=True, '10_CV_Leon_Karnen_FINAL.pdf'/'KapitalnachweisLAglerSascha.pdf'/'saschakonto.pdf'/'100 % MDR-Frei'=True. Befehl: typst compile <typ> <SLOT_01/00_ANTRAG_V4_DESIGN.pdf> -> EXIT:0, STDERR leer, PDF size 323843. nach: antrag_master.typ:422 '[*Projektteam (Information):*]', typ:429 '[*Sascha Lagler* \ Projektleitung & Clinical Lead \ (Zeichnungsberechtigter im eCall: Sascha Lagler als Einzelperson, unbeschränkte Zeichnungsbefugnis)]', typ:415 'Frischer Kapitalnachweis (Platzhalter — wird von Sascha Lagler vor Einreichung gelegt)', typ:416 '06_Erklaerung_V4.pdf (Platzhalter — unterschriebene Fassung folgt)', typ:142 'rein didaktische Zweckbestimmung — kein Medizinprodukt-Einsatz im geförderten Umfang (MDR-Abgrenzung dokumentiert, Kap. 1.1)'. Vor (Archiv-PDF enthielt): Label 'Rechtsverbindliche Zeichnung des Antragstellers', Anlagen 10_CV_Leon_Karnen_FINAL.pdf/KapitalnachweisLAglerSascha.pdf/saschakonto.pdf, '100 % MDR-Frei' — alles pypdf-belegt im Alt-PDF. Hinweis: Die Beweisquelle 02_eCall_Kopiervorlage_V4.md ist nicht auffindbar (Paket enthält nur 5 Dateien: 00_SUBMIT_CHECKLISTE_01-10.txt, SLOT_01-PDF, STUDIEN_RECHERCHE, Archiv-PDF, antrag_master.typ; Desktop-weite rglob-Suche nach '02_eCall_Kopiervorlage*' = 0 Treffer) — die Zeichnungsbefugnis konnte nicht an der Primärquelle verifiziert werden, der typ-Text zitiert die im Ask angegebene Formulierung wörtlich.

## Paket-Konsistenz

- 3 von 4 Teilen erledigt/beantwortet, 1 Teil nicht ausführbar (Zieldatei existiert nicht am erwarteten Ort — offen gemeldet statt plausible Annahme). (1) UMBENENNUNG NICHT AUSGEFÜHRT: UPLOAD_eCall_SLOTS_2026-09-30_FINAL.zip liegt NICHT im Paket/unter FÖRDERUNG (rglob '*.zip' unter FÖRDERUNG = 0 Treffer). Die einzigen On-Disk-Kopien sind 2 identische WhatsApp-Container-Dateien (tmp/documents, je 1.965.740 B, mtime 30.09.2026 11:33, cmp+md5 identisch) — App-interner Speicher außerhalb des Paket-Scope, NICHT angefasst. Fabrizierter Leon-CV im Zip belegt: unzip -l zeigt 10_CV_Leon_Karnen_FINAL.pdf (61.325 B, 30.09. 11:24). (2) MANIFEST.md existierte auf Disk NICHT (FÖRDERUNG-weit 0 Treffer) — nur IM STALE-Zip. Neu angelegt am Auftragspfad FINAL_entpackt/UPLOAD_eCall_SLOTS_2026-09-18/MANIFEST.md mit den korrigierten Slot-Zeilen 03 (nur Lagler+Fischer, Leons CV ausstehend, Zipexemplar war fabriziert) und 05 (leer, nur Platzhalter-README, alte Belege im Archiv) + Provenienz-Abschnitt, der Disk-Realität und Auftrags-Fakten sauber trennt. Nichts gelöscht, nichts überschrieben (assert target.exists()==False vor Schreiben). (3) Checkliste NICHT geändert, weil Zieltext bereits exakt vorhanden: 00_SUBMIT_CHECKLISTE_01-10.txt Zeile 21 (nicht ~15) enthält wortgetreu 'Slots 01/02/04 einreichfertig; 03 wartet auf Leons CV; 05 wartet auf George-Beleg; 06 wartet auf 3 Unterschriften.' (+Anhang LOI). Zeile 15 ist der GO-ZIP-Punkt. (4) BUSINESSPLAN_HARMONISIERUNG_2026-10-01.md EXISTIERT (mtime 01.10.2026 03:54, 50 Zeilen) → nicht geschrieben. Alle 4 Korrekturen als Kopiervorlage enthalten: Z.24–26 Lisa Mauerhart→Leon Karnen, Z.29–31 36→12 Monate, Z.34–36 39.240→38.000 € + 32.700→33.940 €, Z.39–41 60→50 €/h; PDF-only-Vermerk Z.3/Z.48 ('KEINE bearbeitbare Quelle ... NICHTS geändert' + Neubau-Checkliste).
- Beweis: (1) Suche: python3 pathlib.rglob unter FÖRDERUNG — Muster 'UPLOAD_eCall_SLOTS*' → nur der entpackte Ordner .../FINAL_entpackt/UPLOAD_eCall_SLOTS_2026-09-18; Muster '*.zip' → leer; MANIFEST.md → leer. ZIP nur in WhatsApp-Containern (md5 beider Kopien = ab1aba10fe0132d66b3d29d2132ff681, cmp exit 0). Leon-CV im ZIP belegt: unzip -l → 'UPLOAD_eCall_SLOTS_2026-09-18/SLOT_03_CVs/10_CV_Leon_Karnen_FINAL.pdf 61325 09-30-2026 11:24'. (2) VOR = STALE-Zip-MANIFEST.md Zeile 11: '| **03** | SLOT_03_CVs/ | ...10_CV_Leon_Karnen_FINAL.pdf | ... | ✅ Fertig (Lagler 900 h ... Karnen 160 h QA/Barrierefreiheit) |' und Zeile 13: '| **05** | SLOT_05_Kapitalnachweis/ | KapitalnachweisLAglerSascha.pdf ... | ✅ Fertig (38.000 € Bar-Eigenmittel ...) |'. NACH = neue Datei, Rücklesen Zeile 11: '⏳ **CVs: nur Lagler + Fischer drin, Leons CV ausstehend.** Die 10_CV_Leon_Karnen_FINAL.pdf im STALE-Zip war fabriziert — nicht verwenden, nicht hochladen.' und Zeile 13: '⏳ **Leer — nur Platzhalter-README; alte Belege im Archiv.** Wartet auf George-Finanzbericht (≥ 38.000 €, Giro+Sparkonto).'. (3) Rücklesen 00_SUBMIT_CHECKLISTE_01-10.txt: 'Datei hat 21 Zeilen; Zeile 15 lautet: "[ ] 3. ZCode \"GO ZIP\" -> ZIP neu bauen + Prueflauf."' und '21| Slots 01/02/04 einreichfertig; 03 wartet auf Leons CV; 05 wartet auf George-Beleg; 06 wartet auf 3 Unterschriften. LOI geloest (AP-5-Deklaration).' (4) Read-Output BUSINESSPLAN_HARMONISIERUNG_2026-10-01.md Zeilen 24–26, 29–31, 34–36, 39–41, 3, 48 (alle 4 Korrekturen + PDF-only-Vermerk vorhanden). NFD-Nachweis: PARENT name codepoints = ['0x46','0x4f','0x308','0x44',...] (O + kombinierender Umlaut); alle Pfade aus rglob abgeleitet — getippter Umlaut im Heredoc schlug einmal fehl (FileNotFoundError, rerun mit rglob-Pfad exit 0).

## PDF-Reparaturen

- Alle 3 Ziel-PDFs sind intakt und pypdf-verifiziert (open + Seitenzahl nach je Datei, Exit 0): (1) vollfunktion/public/Körperfluss_ Businessplan Cashflow.pdf = byte-identisch (sha256 30420c29edd4eed5…) zur intakten Quelle Koerperfluss-3D-Upgrade/dist/…Cashflow.pdf, pypdf OK 18 Seiten; (2) vollfunktion/public/Strategisches Update- Inklusions-Funding Körperfluss Edu.pdf = byte-identisch (sha256 a912ccdbb2b445d0…) zur Quelle Koerperfluss-3D-Upgrade/public/…, pypdf OK 2 Seiten; (3) Koerperfluss-3D-Upgrade/Körperfluss_ Businessplan Cashflow - Google Docs.pdf = byte-identisch (sha256 9130760bd67981eb…) zur Quelle FÖRDERUNG/(aktuell) FFG BUSINESSPLAN + CASHFLOW/(0) Businessplan fertig/…Cashflow.pdf, pypdf OK 18 Seiten. WICHTIG — ehrlicher Befund: Die 3 PDFs waren bei meiner Übernahme bereits repariert (eine frühere Session hatte den geforderten Ablauf schon ausgeführt). Beweis: alle 3 Ziele waren vor meinem Eingriff schon byte-identisch zu den intakten Quellen, und die korrupten Originale liegen bereits als .korrupt.bak gesichert — Datei1: …Cashflow.pdf.korrupt.bak (821.661 B, exakt die im Auftrag genannte Größe), Datei2: …Strategisches….pdf.korrupt.bak (315.982 B), Datei3: …Google Docs.pdf.korrupt.bak (1.020.157 B, exakt die im Auftrag genannte Größe); alle 3 Backups starten mit 8× NULL-Bytes und werfen bei pypdf 'PdfStreamError: Stream has ended unexpectedly' (= der beschriebene Korruptionstyp, als Beweis konserviert). Mein ausgeführter Ablauf: pypdf-Vor-Check je Ziel (OK), shutil.copy2 der intakten Quelle an den Zielort (idempotent, byte-identisch), pypdf-Nach-Check (OK, 18/2/18 Seiten). Der mv-Schritt wurde bewusst NICHT wiederholt: die echten .korrupt.bak-Korrupt-Backups existieren bereits — ein erneutes mv hätte sie mit den jetzt intakten Dateien überschrieben (destruktiv, Backup-Verlust); ihre Aufgabe ('Ziel-Original sichern') ist erfüllt. Slot-PDFs (FINAL_entpackt/UPLOAD_eCall_SLOTS_2026-09-18/SLOT_01_Antrag/00_ANTRAG_V4_DESIGN.pdf, 323.843 B, sha fb1cb5a020b66c34…) wurden nur gelesen, nie verändert. PFADFALLE beachtet: 'FÖRDERUNG'/'Körperfluss EDU' auf Disk in NFD (Codepoints 0x4f+0x308 bzw. 0x6f+0x308, bewiesen per hex(ord())) — alle Pfade ausschließlich via pathlib.rglob aus echten Disk-Ergebnissen abgeleitet, keine getippten Umlaut-Pfade.
- Beweis: Befehl: python3-Heredoc mit pathlib.rglob + shutil.copy2 + pypdf (PdfReader). Output je Datei — Datei1: 'VOR: pypdf open OK, 18 Seiten, 821661 B, sha256=30420c29edd4eed5… / COPY2: 821661 B geschrieben / NACH: pypdf open OK, 18 Seiten … sha256=30420c29edd4eed5… / CHECK: Ziel==Quelle (sha256): True'. Datei2: 'VOR/NACH: pypdf open OK, 2 Seiten, 315982 B, sha256=a912ccdbb2b445d0… / Ziel==Quelle: True'. Datei3: 'VOR/NACH: pypdf open OK, 18 Seiten, 528301 B, sha256=9130760bd67981eb… / Ziel==Quelle: True'. Korrupt-Nachweis (.korrupt.bak-Inventur): 4 Dateien, alle 'pypdf FAIL PdfStreamError: Stream has ended unexpectedly', head=b'\x00\x00\x00\x00\x00\x00\x00\x00', u.a. '…Google Docs.pdf.korrupt.bak 1020157 B sha=6a2e1c422b4d…'. mv-Abbruch-Beweis: erste Ausführung stoppte mit 'AssertionError: ABBRUCH: …Cashflow.pdf.korrupt.bak existiert bereits!' (keine Datei bewegt). Gesamter zweiter Lauf: Exit 0.

## Unabhängige Verifikation

## Verifikations-Bericht FFG-Paket 68209806 — **3 von 4 Checks PASS, 1 Check TEILWEISE (ZIP-Lage abweichend vom Soll)**

**Gesamtergebnis:** Antrags-PDF und Quelltexte sind sauber (0× Mauerhart, 0× „40 % Gesellschafter", „Projektteam (Information)" vorhanden); alle vorhandenen Slot-PDFs intakt; die 3 reparierten PDFs öffnen alle — aber das alte FINAL-Zip liegt noch **2× unumbenannt im WhatsApp-Container** und die erwartete `_ARCHIV_FINAL_ZIP_STALE_2026-09-30.zip` **existiert nirgends**. Wichtiger Vorbehalt: Im Hauptpaket existiert nur **SLOT_01** — Slots 02–06 sind laut MANIFEST bewusst noch nicht befüllt (GO-ZIP steht aus).

---

### Check 1 — Slot-PDFs (pypdf): ✅ PASS (mit Kontext)
**Befund:** `FINAL_entpackt/UPLOAD_eCall_SLOTS_2026-09-18/` enthält **nur 1 PDF** (SLOT_01), nicht mehrere Slots. Das belegt `MANIFEST.md` ausdrücklich: „*enthält aktuell nur SLOT_01_Antrag/00_ANTRAG_V4_DESIGN.pdf — die Ordner der Slots 02–06 … existieren noch nicht auf Disk und werden beim ‚GO ZIP'-Neubau … befüllt*".

**Beweis** (`pypdf 6.17.0`, rglob über alle `*.pdf` im Slot-Ordner):
```
ANZAHL Slot-PDFs: 1
OK   10 Seiten | erste-24-Zeichen: 'F F G  B A S I S P R O G' | SLOT_01_Antrag/00_ANTRAG_V4_DESIGN.pdf
ERGEBNIS Check1: 1 OK / 0 FEHLER von 1 Slot-PDF(s)
```

### Check 2 — Grep-Checks (Antrags-PDF + alle .typ/.md): ✅ PASS
Geprüft: SLOT-PDF (neu/gesichert, 04:51), ARCHIV-PDF (09-21, zum Vergleich), `antrag_master.typ`, `MANIFEST.md`, `STUDIEN_RECHERCHE_2026-09-30.md` — Suche **case-insensitive** (= strenger als gefordert).

| Muster | SLOT-PDF | ARCHIV-PDF | antrag_master.typ | .md-Dateien |
|---|---|---|---|---|
| `Mauerhart` / `Lisa Mauerhart` (gefordert 0) | **0 / 0** | 0 / 0 | 0 / 0 | 0 / 0 |
| `40 % Gesellschafter` (gefordert 0 im Antrags-PDF) | **0** ✅ | 1 ⚠️ Vorher-Beweis | 0 | 0 |
| `Projektteam (Information)` (gefordert ≥1) | **1** ✅ | 0 | 1 ✅ | 0 |

**Beweise (Ausüge):**
```
--- SLOT-PDF (04:51) (25,189 Zeichen) ---
  FAIL: 'Mauerhart' -> 0 Treffer   |  FAIL: 'Lisa Mauerhart' -> 0 Treffer
  CHECK: '40 % Gesellschafter' -> 0 Treffer
  NEED: 'Projektteam (Information)' -> 1 Treffer
      [24947] …Projektteam (Information): ⏎ Sascha Lagler ⏎ Projektleitung & Clinical Lead…
--- ARCHIV-PDF (09-21) ---
  CHECK: '40 % Gesellschafter' -> 1 Treffer
      [24864] …Geschäftsführer & Clinical Lead ⏎ (40 % Gesellschafter) ⏎ Peter Fischer…
MAUERHART-FAILS GESAMT (ohne Filter): 0
```
**Zu den Ausnahmen:** Sie sind **leer/vakant** — die Kopiervorlage-Personalkosten-Maske (`_OPTIONAL_eCall_Textfelder/02_eCall_Kopiervorlage_V4.pdf`, laut Checkliste Schritt 4) und etwaige READMEs mit GESPERRT-Warnung existieren **nicht auf Disk** (Paket enthält nur die 5 o. g. Dateien), deshalb kann dort kein Treffer stehen. Der 0-Treffer-Befund ist damit absolut, nicht „absolut außer zwei freigestellten Dateien". Bonus: Der 1 Treffer im **Archiv**-PDF belegt die Korrektur Vorher(09-21)→Nachher(04:51).

### Check 3 — ZIP-Lage: ⚠️ TEILWEISE (Paket sauber, Soll-Archivname fehlt, 2 Restkopien im WhatsApp-Container)
| Teilbefund | Ergebnis | Beweis |
|---|---|---|
| FÖRDERUNG-Baum ohne ZIPs | ✅ | `rglob('*.zip')` → leer; auch `_ARCHIV_…ZIP_STALE_…` → kein Treffer |
| `UPLOAD_eCall_SLOTS_2026-09-30_FINAL.zip` im Paket/Desktop/Downloads | ✅ 0 Treffer | `rglob` über FÖRDERUNG + Desktop/Downloads → `[]` |
| Erwartete `_ARCHIV_FINAL_ZIP_STALE_2026-09-30.zip` | ❌ **existiert nirgends** | `mdfind -name '_ARCHIV_FINAL_ZIP_STALE'` → leer |
| Alte-Namen-Kopien systemweit | ⚠️ **2× im WhatsApp-Container** | `mdfind` → `~/Library/Containers/net.whatsapp.WhatsApp/Data/tmp/documents/{08AE…,69F7…}/UPLOAD_eCall_SLOTS_2026-09-30_FINAL.zip`, je 1.965.740 B, **SHA-256 identisch:** `b9732ce7bc2d…459083b` |

Einordnung: `MANIFEST.md` (neu angelegt 01.10.) dokumentiert genau das: das STALE-Zip liege „*nicht im Paket, sondern nur als 2 identische Kopien im WhatsApp-Container … Das STALE-Zip ist ARCHIV/VERWARF … darf NICHT hochgeladen werden*". Die Umbenennung in `_ARCHIV_FINAL_ZIP_STALE_2026-09-30.zip` wurde also **nicht ausgeführt** — stattdessen Archiv-Etikett per MANIFEST. Wer den Buchstaben des Auftrags will (umbenannte Archiv-Kopie), muss die 2 Container-Kopien noch umbenennen/umziehen.

### Check 4 — 3 reparierte PDFs (pypdf): ✅ PASS, mit Fußnote
Lage: Die `.korrupt.bak`-Leichen liegen **nicht im FFG-Paket**, sondern im 3D-Upgrade-Projekt (Ordner `aktuell-3d-upgrade-(vollfunktion)-körperfluss---evidenz-für-therapie-&-ausbildung`). Alle 3 Zielpfade (ohne .bak) geöffnet:

```
Körperfluss_ Businessplan Cashflow - Google Docs.pdf: 18 Seiten, alle lesbar=True, pypdf-Warnungen=0   (BAK 1.020.157 B)
public/Körperfluss_ Businessplan Cashflow.pdf:        18 Seiten, alle lesbar=True, pypdf-Warnungen=24  (BAK 821.661 B)
public/Strategisches Update- Inklusions-Funding …pdf:  2 Seiten, alle lesbar=True, pypdf-Warnungen=15  (BAK 315.982 B)
warn: 'Error -3 while decompressing data: incorrect header check' / 'incorrect startxref pointer(1)' / 'parsing for Object Streams'
```
Fußnote (ehrlich): Datei 1 ist warnings-frei; Dateien 2+3 öffnen **ohne Exception**, Text auf **jeder** Seite extrahierbar, aber pypdf meldet dabei 24×/15× Reparatur-/Decompression-Warnungen — Restmängel, die der tolerante Lesemodus schluckt. „Intakt im strengen Sinn" gilt nur für Datei 1.

---

**Offene Risiken für den Submit:** (1) GO-ZIP noch nicht gebaut — Slots 02–06 existieren auf Disk nicht; (2) altes STALE-Zip liegt 2× unumbenannt im WhatsApp-Container (Verwechslungsgefahr beim Hochladen); (3) gewünschte `_ARCHIV_FINAL_ZIP_STALE`-Datei fehlt. Nicht geprüft, weil nicht existent: antrag_master.pdf in `_BUILD` (nur .typ vorhanden — das kompilierte PDF liegt als SLOT_01/`00_ANTRAG_V4_DESIGN.pdf` vor).

## Was von Menschen kommen muss

- ① Leons ECHTER CV → SLOT_03 ② George-Kapitalnachweis → SLOT_05 ③ 06_Erklaerung drucken + 3× unterschreiben → SLOT_06 ④ dann 'GO ZIP'.