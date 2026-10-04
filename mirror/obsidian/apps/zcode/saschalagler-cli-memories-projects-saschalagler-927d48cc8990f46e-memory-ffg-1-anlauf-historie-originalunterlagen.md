---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/ffg-1-anlauf-historie-originalunterlagen.md"
stand: 2026-10-04
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

Verwandt: [[koerperfluss-edu-foerderpilot-fertig]], [[ffg-1-anlauf-historie-originalunterlagen]]
