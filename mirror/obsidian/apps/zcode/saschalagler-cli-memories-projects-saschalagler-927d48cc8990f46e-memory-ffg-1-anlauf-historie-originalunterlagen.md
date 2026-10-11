---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/ffg-1-anlauf-historie-originalunterlagen.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: ffg-1-anlauf-historie-originalunterlagen
description: Komplette 1-Anlauf-Historie FFG 68209806 aus Original-Unterlagen
  (Ordner Desktop/ffg - 1 antrag + businessplan+nachtrag+2version) —
  Projekt.Start 0€, Ablehnungsgründe wörtlich, Nachreichungs-Chronik,
  Chat-Aufzeichnungs-Pfade
metadata:
  node_type: memory
  type: project
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

# FFG 1. ANLAUF — KOMPLETTE HISTORIE aus Original-Unterlagen (gelesen 05.10.2026)

Quelle: `/Users/saschalagler/Desktop/ffg - 1 antrag + businessplan+nachtrag+2version/` (25 Dateien). Extrakte: `/tmp/ffg1_original_auszuege.json`.

## Chronologie (jede Zeile aus Original-PDF belegt)

| Datum | Ereignis | Quelle |
|---|---|---|
| 15.09.2025 | **Projekt.Start 66244243 (FO999933816): BEDINGTE Förderzusage 6.000 €** (60 % von 10.000 €, Endbericht bis 13.03.2026) | Vertrag 66244243 |
| 18.12.2025 08:03 | **Vollantrag Kleinprojekt 68209806 eingereicht** (Lagler Sascha, Prinzlstraße 7/2 3390 Melk, 130.800/58.860/45 %, Start 01.01.2026, 12 Monate, Team Fischer/Lagler/**Mauerhart**) | ecall-Print 19 S. |
| 08.04.2026 | FFG-Projektbesprechung Termin bestätigt (Sabine Hahn, Zoom 13.04.) | ff-call.pdf |
| 14.04.2026 | **Jessica Macek fordert wirtschaftliche Nachreichung** (Businessplan + Cashflow) bis **27.04.2026** | wirtschaftliche Nachreichnung FFG.pdf |
| 27.04.2026 | Businessplan & Cashflow geliefert (18 S., April-Version) | Beweis_Businessplan_Cashflow.pdf |
| 21.05.2026 | **ABLEHNUNG** (FO999938346-0004): ① Neuheitsgehalt/Mehrwert wenig belastbar (Features/Zielgruppen) ② Qualität der Lösungsansätze nur teils nachvollziehbar (Sprachmodelle, QS der selbst erstellten Wissensdokumente) ③ Schwierigkeit des Vorhabens unterdurchschnittlich | Ablehnungsschreiben 3 S. |
| 27.05.2026 | **Saschas sachliche Rückfrage an Predrag Jovanovic**: „Unsicherheit bezüglich Aktenstand" — eine **18-seitige Nachreichung** war am 27.04. nach Einladung von Frau Macek übermittelt worden (Aktenstand-Problem!) | ffgantwort-nachriechung.pdf |
| 22.06./01.07.2026 | **Feedbackgespräch** mit FFG (Elisabeth Gruber, Zoom 01.07. 09:30; Bots verboten) | Nachricht drucken.pdf |
| 08.07.2026 | **Projekt.Start-Kostenanerkennung: „Es steht Ihnen KEINE Förderung zu"** — Ausführungsqualität des geplanten F&E-Projekts nicht ausreichend → 0 € statt 6.000 € (10.800 € Kosten anerkannt) | FO999933816-0004 |
| 29.03.2026 | (davor) Produktbeschreibung FHLINZ 9 S. (Peter+Sascha) | Koerperfluss-Beschreibung-FHLINZ.pdf |
| Aug 2026 | Dossier V5.0 FINAL 69 S. (Quelle der „246"-Zahl, „100 % MDR-FREI", Cap-Table Option B) | Gesamt-Dossier PDF |

## Ablehnungsgründe wörtlich (Kern für 2. Anlauf)
1. „Neuheitsgehalt und Mehrwert … wegen der **wenig belastbaren Angaben bezüglich Features und künftiger Zielgruppen** nur unterdurchschnittlich"
2. „Qualität der Lösungsansätze … **technische und fachliche Angaben (Sprachmodelle, fachliche Qualitätssicherung der selbst erstellten Wissensdokumente) nur zum Teil nachvollziehbar**"
3. „Die **Schwierigkeit des Vorhabens** wurde nur unterdurchschnittlich [eingestuft]"

→ Antwort im 2. Anlauf: messbare KPIs (Z1–Z5), 15-Parameter-Safety-Guard als QS-Antwort, xLSTM als Schwierigkeits-Nachweis, verständliche Sprache.

## Korrekturen zu meinem bisherigen Bild
- Es gab ZWEI Förder-Entscheidungen: Kleinprojekt-**Ablehnung** (21.05.) UND Projekt.Start-**0 €** (08.07.) — beide negativ, beide dokumentiert.
- Die Nachreichung war FFG-ADMINISTRATIV angeordnet (Macek), kein freiwilliger Move; es gab FFG-Zoom-Gespräche (13.04., 01.07.) — Hinweis: FFG kennt Sascha persönlich, Betreuerin Jovanovic.
- Original-Kapitel-PDFs des Vollantrags existieren (z. B. „1.3 Entwicklungsinhalte" 3 S.) — 2.-Anlauf-Struktur folgt demselben Zielformat.

## WO ALLE CHAT-AUFZEICHNUNGEN/AGENT-LOGS LIEGEN (Pfade)
- **ZCode-User-Nachrichten aller Sessions:** `~/.zcode/cli/rollout/model-io-sess_*.jsonl`
- **Tool-Outputs/Logs je Session:** `~/.zcode/cli/exec/sess_*/`
- **deja (alle Harnesses, indexiert):** `deja` CLI + MCP-Tool deja (700+ Sessions)
- **claude-mem:** MCP-Tools search/timeline/get_observations
- **Workflow-Journale:** `GetWorkflowRun`/`ListWorkflowRuns` (Run-IDs im KANON-PROTOKOLL)
- **Antigravity-Chats:** `.db`/`.pbtxt` in den Projektordnern (PILOT.AI/.antigravity/ 25 MB, 3d-Upgrade 63 MB, lesbar)
- **Sachstand-SSOT:** `FÖDERUNG/FFG_ReSubmission_PAKET_68209806/KANON_PROTOKOLL_FFG_2026-10-05.md` + `BEWEISKETTE_2026-10-04.md` + `Desktop/HANDOUT_FFG_SITZUNG_2026-10-05.md`

## FFG-NOTARY + PITCHDECK + EINGEREICHTER VOLLANTRAG = STRUKTUR-QUELLEN (Sascha-Korrektur 05.10.: „WAR DAS PITCHDECK, NICHT DEIN AUFBAU")

- **`/Users/saschalagler/Desktop/ffg-notary/`** = Saschas FFG-Notary-Cockpit v2.5 (April 2026): README + `Aufbau vorgabe/` (aws/FFG-Businessplan-Leitfaden-Strukturierung 4 S. + Businessplan-PDF + STRUKTUR-PNG) + `master - ff antrag projekt/` mit **1) BASIS FFG ANTRAG BASISPROGRAMM KLEINPROJEKT.pdf** (19 S., eingereichter eCall-Print 18.12.2025 08:03) + **1b) Körperfluss…pdf (24 S. = der EINGEREICHTE Vollantrag)** + 1c) 1.3-Kapitel + 1d) Finanz-PNG; `output/` = 7 Businessplan-Kapitel-MDs (01_Executive…07_SWOT); `agents/` = Investigator/Auditor/Redakteur-Python (LM-Studio lokal).
- **Kanonisches FFG-Zielformat (TOC des 1b-Vollantrags):** 1. Projektbeschreibung (1.1 Projektziele · 1.2 Neuheit gegenüber dem Stand der Technik · 1.3 Entwicklungsinhalte, Herausforderungen und Lösungsvorschläge · 1.4 Nutzen [1.4.1 Zielgruppen/1.4.2 Mehrwert/1.4.3 USP] · 1.5 Nachhaltige Wirkung [Ökologie/Soziales/Ökonomie]) → 2. Finanzierung und Folgekosten → 3. Ökonomisches Potenzial und Verwertung (3.1 Marktchancen · 3.2 Geschäftsmodell [Erlösmodell/Vertriebskonzept]) → 4. Volkswirtschaftliche Aspekte (4.1 Wirtschaftsstandort · 4.2 Soziale Aspekte).
- **Pitchdeck** (`drive-download-20261004T233636Z-1-001/pitch deck .pdf`, 5 S.): „KÖRPERFLUSS – Adaptive KI für Therapie, Training und Lehre"; Intake→Mindmap-Engine (prüfbarer JSON-Output); B2C 99 €/39 €/79 €-Abo, B2B 199 €/Seat; TAM ~15 Mio., LTV:CAC > 3×; Teamrollen-Matrix M0–M12. (Im V6-Antrag bewusst NUR die Antrag-konsistenten Zahlen verwendet — Campus-Lizenz 3.000 € + 12,50 €/Student.)

## V6-FINALSTAND (05.10.2026, ~01:47 — Vollzug, Details auch in [[koerperfluss-edu-foerderpilot-fertig]] §V6-REBUILD)

- **Neuer Antrag** `antrag_v6_ffg_zielformat.typ` → `00_ANTRAG_V6_DESIGN.pdf` (14 S., md5 00b338c50096): exaktes 1b-Zielformat + KPIs Z1–Z5; kompiliert und pypdf-verifiziert (alle Kapitel OK, Alt-Dreck 0×: „Sascha Lagler, BSc", „BSc Physiotherapie (IMC", „Bankbestätigung", LOI-Datei, „Head of QA & Accessibility", „FlexCo (i. Gr.)").
- **Sascha ist KEIN fertiger BSc** (Sascha: „ICH BIN KEIN FERTIGER MBSC") — Wahrheit aus seinem Versandfertig-CV 2026: „Physiotherapie-Studium IMC FH Krems (2021–2023, 62 ECTS, derzeit unterbrochen)" + OptimaMed/SeneCura geriatrische Praxis; neues `CV_Lagler_Sascha_1seitig.pdf` (e8d79dc75122) nur aus diesen Fakten gebaut.
- **Peter-CV** Original aus `~/Downloads/WhatsApp/UPLOAD_eCall_SLOTS_2026-09-18/SLOT_03_CVs/` (md5 172ad268ccf4, BSc BSc JKU + MSc AI in Ausbildung) — Slot-03-Lücke geschlossen; Leon-CV fa239b49fb60 bleibt.
- **LOI-Entscheid:** `LOI_Pilotpartner_Kneipp.pdf` war unsignierte Selbst-Vorlage (110 KB, „Dr. Kneip"-Schreibweise!) → aus ZIP+Antrag raus; im Antrag nur M5.2-Plan-Text.
- **Disk-Zwischenfall:** `FINAL_entpackt/` des 1. Pakets wurde abgeräumt (nur frischer SLOT_03 blieb) — gerettet über Zweit-Kopie **`FFG_ReSubmission_PAKET_68209806 2/`** (alle Slot-PDFs md5-verifiziert zurückkopiert).
- **Finales ZIP:** `UPLOAD_eCall_SLOTS_V6_2026-10-05.zip` (661.436 B, **md5 7880cb2a5e000b0194a46171346417dd**, 7 PDFs/5 Slots, 3 CVs) + **`EINREICH_LISTE_V6_2026-10-05.md`** im Paketordner (Slot-Tabelle, kopierbare Verify-Befehle, 7 eCall-Schritte; Maske-Startdatum-Empfehlung **01.01.2027** — 01.01.2026 liegt in der Vergangenheit).
- Technik-Falle neu: typst interpretiert `@` in Markup als Label (`koerperfluss@gmail.com` → `#("koerperfluss@gmail.com")` escapen); zsh spawnete zeitweise ENOENT (System-Glitch) → Desktop-Commander-`start_process` als Ersatz-Shell funktioniert.

Verwandt: [[koerperfluss-edu-foerderpilot-fertig]], [[ffg-1-anlauf-historie-originalunterlagen]]


## ERGAENZUNG (10.10.): Original-24S-VOLLANTRAG + eCall-Formular ausgelesen (Quelle: ffg-notary/master '1b' + '1) BASIS FFG ANTRAG…' PDFs)
Die ORIGINAL-Inhalte des eingereichten Vollantrags (24 S., Version, die abgelehnt wurde) — GOLD zum Wiederverwenden:
- **Basisinformation (eCall-Formular):** Melk, Start 01.01.2026 (inzwischen vorbei -> 01.01.2027), KMU-Kleinunternehmen, Org.-Beschreibung: Sascha Clinical Lead **51 %**, Peter CTO **48 %**, **Lisa Mauerhart Design & UX 1 %** (Original-Team hatte LISA, Anlauf-2 hat LEON stattdessen)
- **Original 1.1-Problemframing (stark, mit 7 Quellen [1]-[7]):** MSE (Muskel-Skelett-Erkrankungen) laut Global-Burden-of-Disease = fuehrende Ursache Years-Lived-with-Disability; EU-Fachkraeftemangel; IPE (interprofessionelle Ausbildung) wirkt belegt, aber heterogen implementiert; PT-Ausbildung hat konzeptionelle Luecken ohne skalierbare digitale Lehrwerkzeuge
- **Original Z1-Z5 KPI-Tabelle (Format stark):** Z1 MVP-Stack 0 kritische Blocker · Z2 >=80 % fachl. Korrektheit (Review), Akzeptanz >=70 % Likert · Z3 100 % Compliance-Filter aktiv, 0 Vorkommnisse · Z4 TRL7-Pilot extern ODER interner Pilot (30-50 Personen), Uptime >=99 % · Z5 IPE +15 % (prae/post). Nicht-Ziele-Liste (Marketing, Medizinprodukt, Markteintritt). Frascati: experimentelle Entwicklung
- **Original Wettbewerbstabelle 1.2.1 (direkte Antwort auf 'Neuheitsgehalt wenig belastbar'):** Ada Health (MDR IIa Triage) · Infermedica (Triage-API) · Symptoma (Symptomchecker) · Physitrack (Telehealth/UEbungen) — KEINE adressiert PT-Ausbildung mit dialogischer KI; Koerperfluss = neue Kategorie EdTech×Health-AI, MDR-frei. Eigene Foerderung/Lizenzen 1.500-3.000 EUR/Jahr (BP), Markt 300 DACH-Ausbildungsstaetten (World Physiotherapy 7,46/5Mio EU, DE 15,62/5Mio)
- **Original 1.3:** 4 Entwicklungsstraenge (Architektur+Datenmodell / Dialoglogik+Slots / MDR-Compliance-Filter / Integration+Validierung), Technische Probleme 1-4 (Halluzination, Synchronisation, regulatorische Grenzbegriffe, didaktische Wirksamkeit), Herausforderungen 1-4; **xLSTM dort nur als OPTION zitiert [20] (Beck arXiv 2405.04517)** — Peters Idee kam also aus diesem Original-Antrag
- **Original 1.5 SDG-Zahlen (mit Quellen [21]-[23]):** 250-300 kg Papier/Standort/Jahr erspart; Remote-Lehre -50 % verkehrs-CO2; Lernerfolg +15-20 %; IPE +15 %; >=40 % weibliche Lernende; 500k EUR/Jahr Umsatz mittelfristig; Exportquote >50 %
- **Original ARBEITSPLAN (Monate konkret):** AP2 Architektur Jan-Feb (M2.1 Architekturprototyp 28.02.2026) · AP3 Dialoglogik Maerz-Apr (M3.1 Slot-Test >=80 % 30.04.) · AP4 Compliance Apr-Jun (M4.1 MDR-Filter 30.06.) · AP5 Integration Jul-Aug (M5.1 TRL7-Nachweis 31.08.2026)
- **Original Finanzplanung V0.4 (eCall-Print):** Personalkosten-Tabelle Fischer 280 h je AP2-5 (1.120), Lagler 180 h je AP1-5 (900), MAUERHART Lisa 40 h je AP2-5 (160, 9.600 EUR), 2.180 h gesamt, 50 EUR/h +20 % GKZ — Stunden-Verteilung = heute identisch mit V13, nur Lisa->Leon getauscht
- **Qubitec-Spreadsheet (97cd73):** aeltere Kalkulation mit Lisa, Restfinanzierungs-Zeilen; historisch
- **Weitere Original-Pfade:** GoogleDrive Altbestand 'Projekt Koerperfluss/Altbestand bis 10.05.2026/2) FFG Kleinprojekt/' (KapitalnachweisLAglerSascha.pdf, Loi-kneipp.pdf, Finanzplanung .numbers/.gsheet, C1+Projektvorbereitung_Deutsch.pdf); Desktop/KICK OFF/pitch + CVs-1Seitig; ffg-notary/input (3a Vollantrag, 3b KMU-RL, DEFENSIV-MATRIX docx, WAW/Linz/OXYDATA)
- **ACTIONABLE fuer V14 (falls Sascha will):** Wettbewerbs-Tabelle + MSE/IPE-Problemframing + SDG-Belegzahlen aus dem Original in V13 mergen (alle schon FFG-bekannt = legitim, staerken 'Neuheitsgehalt' und 'Nutzen' mit echten Quellen)


## V14 (11.10., 00:39) — Original-Gold ist DRIN
- **01_VOLLANTRAG V14: 16 S., md5 020cc905e548** — aus Original uebernommen: Wettbewerbstabelle Ada/Infermedica/Symptoma/Physitrack (1.4, nach USP), KPI-Haertung (Z1: 3 Fallsimulationen Fach-Review · Z4: 0 unbelegte Therapieempfehlungen · Z5: >=70 % Likert 4-5 + Verfuegbarkeit >=99 % — Originale Z2/Z3/Z4-Formalstil), MSE/GBD-Satz in 1.1 (qualitativ, keine Zahl)
- V13 archiviert: _ANLAUF2_INTERNE/_VERSIONEN/01_VOLLANTRAG_V13_f458c5afd42b.pdf
- ZIP: UPLOAD_eCall_SLOTS_V14_FINAL_2026-10-11.zip md5 a95c33a10d07 (9 PDFs) — V13-ZIP 92403651de3e abgeloest
- SHA256SUMS (9 PDFs), 00_LIES_MICH + 08_GESAMT_AUDIT auf V14/md5 020cc905e548 aktualisiert; 06_KOSTEN unveraendert korrekt (zitiert keine Antrags-md5)
- NICHT uebernommen aus Original: Lisa Mauerhart (Team bleibt Fischer/Lagler/Karner), Ursprungs-KPI-Z1 'MVP-Stack 0 Blocker' + Z5 'IPE +15 %' (V13s xLSTM-Ziele sind die eigentliche Neuheits-Antwort), SDG-Zahlen 250-300kg/-50%CO2/+15-20% (Register-Belege fehlen = 60-EUR-Regel)
- Ursprungs-PDF liegt im Einreich-Ordner LIVE offen (Preview)
- Regex-Falle: naive `60\s*EUR` matcht FALSE-POSITIVE in „…600 EUR"-Beträgen (9.600, 1.600 …) — immer `\b60\s*EUR` (Word-Boundary); gleiche Falle bei `Global Burden`-Check (Bindestrich-Kompositum „Global-Burden-of-Disease" matcht mit Leerzeichen nicht)
- pypdf-Seitenzahl kann von erwarteter Zahl abweichen (V13 14 S. → V14 16 S. nach Tabelle+Ergänzungen — ok, FFG hat keine harte Seitenlimit für die Projektbeschreibung; Original hatte 24 S.)
- Saschas letzte Nachricht vor V14 = Paste der ORIGINAL-Dokumente OHNE Begleittext → impliziter Auftrag „Original gegen aktuelle Fassung abgleichen + Gold mergen" — bei solchen textlosen Pasten den impliziten Abgleich vollziehen statt nachfragen (Vollzug-Regel)


## V14-FINALE (11.10., 02:30) — Visual-Judge-Loop komplett
- **V14 FINAL: 15 S. (nicht 16!), md5 b80f561a3b7a** — Visual-Judge (pdf:visual-judge, 7 Runden): R1 14/16 → Fixes → **15/15 PASS** (keine verwaisten Überschriften/Split-Boxen; 18-Tools-Tabelle mit repeat-header)
- Design-Fixes (in antrag.typ, alle bewiesen): Kernumfang-Tabelle + Schicht-Tabelle + Callout `breakable:false`; 3 erzwungene `#pagebreak()` in 1.3 entfernt (Plattform/LTI/Arbeitsplan fließen); `#v(0.NNfr)`-Spacer in Blöcken = FALLE (fr dehnt im Block aus → Tabellen springen ans Seitenende; immer fixe `#v(6pt)`); Hypothesen-Seite gefüllt mit Benchmark-Methodik-Tabelle (Methodik, keine neuen Zahlen)
- ZIP V14-FINAL: md5 07086aa735e1 (9 PDFs) — ersetzt a95c33a10d07
- **STEHENDE REGEL von Sascha (11.10.):** Am Ende IMMER visual-judge (/iris) über die fertige Datei laufen lassen und ihm die geprüfte Datei zeigen (Pfad + Verdict). Render-PNGs → pdf:visual-judge-Subagent → Verdicts abarbeiten → Repair-Loop bis PASS.


## V14b FINAL (11.10.) — Gemini-Kritik geprueft, valide Teile gefixt
- **01_VOLLANTRAG V14b: 15 S., md5 93c132fe9b85** · **04_MARKT: md5 a056698de299** · ZIP d5e636e01458 (9 PDFs) · visual-judge Runde 8: 4/4 PASS (S.1/5/6/7)
- FIXIERT (Geminis valide Punkte): '0 % Halluzination' 2x + 'Vollständige Halluzinationsfreiheit' -> deterministische Halluzinationsminimierung; 'garantiert absolute Datensouveränität (100 % DSGVO)' -> datensouverän, DSGVO-konform; 'Partner Thomas' aus Beilage 04 raus (Antrag war schon generisch — Inkonsistenz!)
- GEMINI-HALTUNG: er hatte eine AELTERE Fassung (zitierte Thomas im Vollantrag — dort seit V11 0x). Seine Formalia (150k/45 %/20 % GKZ/50-Punkte-Schwelle) decken sich mit unserem Stand. Sein LOI-Basisschluss war doppelboedig: erst 'Blocker', am Ende seines Chats selbst: 'LOI laut Leitfaden NICHT Pflicht, Einreichen ohne ist förderrechtlich gedeckt — dann Beilage 04 bereinigen'
- BEWUSST NICHT geaendert (Sascha-Linie, dokumentiert): 'keine Zusagen'-Hinweis + Muster-LOI + AP-5-Nachreichen (Thomas-Joker-Strategie), SVS 33.940 'beantragt' mit Luecken-Erklärung, B2C-Marktmodell 33,3 Mio (transparente Rechenprobe in 04)
- OFFENE Sascha-Risiken (gemeldet): SVS könnte wegfallen -> Lücke 33.940 (steht im Antrag selbst); Kapitalnachweis 27.11.2025 veraltet -> frischer Auszug; Leon-Rolle 'Chemiker prüft Medizin-Evidenz' -> optional schärfen auf DoE/QA-Audits
- Backups: _VERSIONEN/01_VOLLANTRAG_V14a_15S_b80f561a3b7a.pdf + /tmp/antrag.typ.bak_v14a
