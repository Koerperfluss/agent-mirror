---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/_ARCHIV/SPRACHASSISTENT_ARCHITEKTUR.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# SPRACHASSISTENT — ARCHITEKTUR (24/7-intelligenter Transkriptions-Assistent)
## Für Thomas · basierend auf Marktanalyse + Prüf-Audit 2 · Stand: 04.08.2026

> **KORREKTUR (04.08.2026):** Chipsi HAT bereits ein Langzeit-Gedächtnis (Fakten/Entscheidungen/Stil, lokal OKF).
> **Das Problem:** SafeTalk (Transkription) ist NICHT mit Fehlerprüfung gekoppelt; das Gedächtnis ist passiv.
> **Das Ziel:** KOPPELN — SafeTalk → Langzeit-Gedächtnis → Judicario-Verifikation. Nie unterbrechen;
> nur bei belegtem Fehler oder wenn gefragt melden; auf Anfrage assistieren.
> Alle Optionen: `ASSISTENT_OPTIONEN.md` · Fragen an Thomas: `QA_SACHA_THOMAS.md` · Audit: `AUDIT_2_TIEFENANALYSE.md`.

---

## 1. Leitprinzipien (fixiert durch dich)

1. **Nie zwischenfunken** — der Assistent unterbricht ein Gespräch NIEMALS aktiv.
2. **Nur melden bei Fehler oder wenn gefragt** — sonst still.
3. **Second Brain** — merkt sich über Sitzungen hinweg (Themen, Termine, offene Punkte).
4. **Hat die Logik von Judicario/Chipsi** — versteht das Gesprochene rechtlich/kontextuell,
   um Fehler zu erkennen.
5. **Assistiert auf Anfrage** — kann Fragen beantworten und weiterhelfen.
6. **Datenschutz** — Audio/Aussagen bleiben lokal (RAO § 9 / DSGVO) wo möglich.

---

## 2. Baustein-Entscheidung aus der Marktanalyse

| Baustein | Empfehlung | Quelle (Analyse) |
|---|---|---|
| **STT (Sprache→Text)** | Lokal: `whisper.cpp` / `faster-whisper` (offline, Datenschutz) | § 9 · Edge-Lösungen |
| **Echtzeit-Streaming** | `faster-whisper` + Whisper-Streaming (VAD, Chunking) | § 9 |
| **Second Brain (Memory)** | Selbstgebaute Gedächtnis-Schicht (Themen/Termine/offene Punkte), Obsidian-artig | Fireflies/Otter „perfect memory“-Vorbild |
| **Rechts-/Fehler-Pruef** | Judicario-MCP (verbatim Gesetz, Urteile) — nur bei Bedarf | § Judicario |
| **Interrupt-Verhalten** | **Kein** aktives Unterbrechen; dezente Markierung + Report | Leitprinzip |

**Wichtig:** Weder Fireflies noch Otter noch SoundHound haben ein **juristisches Fehler-Prüf-Brain** für Ö-Recht — genau das ist dein / Thomas' Alleinstellungsmerkmal.

---

## 3. Architektur (einfach, 3 Schichten)

```
┌────────────────────────────────────────────────────────────────┐
│  SCHICHT 1 · ERFASSUNG (lokal)                                 │
│  Audio → faster-whisper (lokal) → Live-Transkript + Zeitstempel │
└────────────────────────────────────────────────────────────────┘
                     ↓ Text-Stream
┌────────────────────────────────────────────────────────────────┐
│  SCHICHT 2 · VERSTEHEN + MERKEN (Second Brain)                 │
│  • NER/LLM extrahiert: Thema, Termine (-frequenz/-länge),      │
│    Entscheidungen, ACTION-Punkte, OFFENE FRAGEN/Unklarheiten   │
│  • Memory-DB (Projekte, Personen, offene Punkte) → persistiert │
└────────────────────────────────────────────────────────────────┘
                     ↓ erkannte Aussagen
┌────────────────────────────────────────────────────────────────┐
│  SCHICHT 3 · PRÜFEN + MELDEN (diskret)                         │
│  • Prüfkopf: Betrag/Norm/Frist/Logik/Verfahren                  │
│  • bei Bedarf → Judicario-MCP zur Verifikation (verbatim)      │
│  • MELDEREGEL:                                                 │
│    - Fehler erkannt  → dezente Markierung + Report (kein Ruf)  │
│    - gefragt         → voll assistieren                        │
│    - sonst           → STILL                                   │
└────────────────────────────────────────────────────────────────┘
```
---

## 4. Was das Second Brain sich merkt (je Sitzung)

| Typ | Beispiel | Warum |
|---|---|---|
| **Thema** | „Finanzierung besprochen“ | Kontext nächstes Mal |
| **Termine** | „Fr 14:00 Gerichtstermin 17.09“ | Frequenz/Länge erkennen |
| **Terminfrequenz/-länge** | Treffen alle 2 Wochen, Länge 45 Min | Muster erkennen |
| **Entscheidungen** | „Wir wählen § 26 VwGG-Weg“ | Verfolgbarkeit |
| **ACTION-Punkte** | „Mandant schickt IBAN“ | offene Aufgaben |
| **Unklarheiten** | „Anwalt war unsicher bei Frist“ | Fehler-Verfolgung |

---

## 5. Melde-Logik (das Wichtigste)

```
Aussage im Transkript
   │
   ├─ ist ein FAKT-Check relevant? (Betrag/Norm/Frist/Aussage)
   │      │ Prüfkopf → Judicario verbatim
   │      ├─ stimmt  → NOTHING (still, keine Meldung)
   │      └─ fehlt/weicht → ⚠ dezente Markierung + gespeichert für Report
   │
   ├─ ist eine UNKLARHEIT? (Termin/Logik/Verfahren)
   │      └─ ⚠ speichern, im Post-Report auflisten
   │
   └─ wurde GEFRAGT?  → antworten + assistieren (voll)
```

**Kein Beleg → kein Hinweis.** Nur belegte Diskrepanzen werden markiert.

---

## 6. ENTSCHIEDUNG: Welches Sprachmodell — und warum (getroffen, nicht offen)

### 6.1 Die Wahl (STT / Transkriptions-Engine)
**Primär:** `faster-whisper` (Lokal, CTranslate2, bis 4× schneller, INT8/FP16) **plus Whisper-Streaming/VAD**.
**Cloud-Fallback (nur bei Bedarf):** AssemblyAI (beste Deutsch-Akkuratheit, Diarization) oder Deepgram Nova-3 (meetings-optimiert).

**Warum dieses Modell?**
| Grund | Detail |
|---|---|
| Datenschutz (dein Kern) | Audio/Protokoll bleibt lokal → RAO § 9 / DSGVO-konform |
| 0 € Laufkosten | keine Minuten-Abos (im Gegensatz zu Cloud-Marktführern) |
| Echtzeit möglich | Whisper-Streaming + Silero-VAD für Live-Transkript |
| Kompatibel | läuft auf deinem Mac / M-Serie, in Chipsi integrierbar |
| Qualität reicht für Juristisch | 8-bit Quantisierung, klare Diktion in Sitzungen ausreichend |

**Warum NICHT nur Cloud (OpenAI Realtime / Gemini Live / SoundHound)?**
→ Cloud = Daten raus + Minutenkosten + Abhängigkeit. Für kanzlei-/mandantensensible Transkription ungeeignet. Cloud wird nur als **optionaler Qualitäts-Fallback** zugeschaltet.

### 6.2 Wie einbauen (konkret)
```
[Audio von Chipsi-Meeting]
   │
   ├─ faster-whisper (lokal) ──► Live-Transkript + Zeitstempel + Sprecher
   │        │
   │        ▼
   ├─ Solo-NER/LLM (lokal) ──► Second-Brain extrahieren (Thema/Termine/ACTION/Unklarheiten)
   │        │
   │        ▼
   ├─ Prüfkopf (bei Fakt-Aussagen) ──► Judicario-MCP (verbatim) ──► Diff → dezent melden
   │
   └─ „Gefragt?“ ──► antworten + assistieren (auch Cloud-Fallback erlaubt)
```
- Die lokale Röhre (faster-whisper) steckt **in Chipsi als Engine-Schicht** — ersetzt die „dumme“ Transkription.
- Das Second-Brain + Prüfkopf ist die **Hirn-Schicht** — neuer, eigener Baustein (kein Marktführer bietet das juristische Brain).
- Kein aktives Unterbrechen; nur dezent markieren + Report.

---

## 7. MVP-Umfang (was wir zuerst bauen)

- [ ] **M1** — Lokale Transkription (faster-whisper + Whisper-Streaming) → Live-Text
- [ ] **M2** — Second-Brain-Datei pro Sitzung (Themen/Termine/ACTION/Unklarheiten)
- [ ] **M3** — Prüfkopf gegen Judicario (verbatim) bei Fakt-Aussagen
- [ ] **M4** — Melde-Report nach Sitzung (dezent, kein Unterbrechen)
- [ ] **M5** — „Frage mich“-Assistenz (auf Anfrage antworten)
- [ ] **M6** — Optionaler Cloud-Fallback (AssemblyAI) bei Qualitäts-Anforderung

---

## 8. Nächste Schritte
1. Konsolidiertes Master-Dokument (Verkauf + an Thomas) — vereint Audit 2 + Architektur + Marktanalyse

