# KAPITEL 06 — Empirie, Schnelligkeit & Eval-Matrix

**Prüfdatum:** 28.07.2026 · **Lead-Audit** (mit DB-Inspektion + eval_results.csv)

---

## 6.1 Peters-Eval-Framework (real: 36, nicht 100 Szenarien) ⚠️

**Behauptung:** „100-Szenarien Quality Matrix (Peters Eval Framework)"

**Befund:** Die Datei `APP/eval_results.csv` existiert und enthält **36 bewertete Szenarien** (+ Header-Zeile). Die Diskrepanz 36 vs. 100 ist ehrlich zu dokumentieren:
- `run_eval.py` ist vorhanden (Framework-Code) — die 100 sind ein Ziel, nicht der Ist-Stand
- Die CSV enthält 7 Frage-Typen (Fakten/Vergleich/Synthese/Anwendung/Definition/Mechanismus/Ranking) — die Behauptung "für 7 Retrieval-Typen" stimmt ALSO ✅

| Metrik | Wert |
|---|---|
| Szenarien total | 36 (von behaupteten 100) ⚠️ |
| Frage-Typen | 7 ✅ |
| PASSED-Quote | ~100% der bewerteten Zeilen |
| Norm getroffen? | ~75% JA, ~25% NEIN (ehrlich dokumentiert!) |
| Themenbereiche | Zivilrecht, Verwaltungsrecht, Sozialrecht, Steuerrecht, VwGH |
| Schwierigkeitsgrad-Verteilung | 1–5 (alle Stufen vertreten) |

✅ **Ehrlicher Pluspunkt:** Die Spalte „Norm getroffen? NEIN" beweist, dass das Eval-Framework nicht geschönt wird — es dokumentiert eigene Fehlschläge transparent. Das ist methodisch vorbildlich.

---

## 6.2 Latenz / Schnelligkeit (aus eval_results.csv)

**Auszug aus realen Messungen (36 Szenarien):**

| Metrik | Wert |
|---|---|
| Latenz-Bereich | 7.4s – 7.8s (sehr konsistent) |
| Mittelwert | ~7.5s |
| Dies umfasst | RAG-Suche (FTS5) + LLM-Inferenz + Output-Generierung |

⚠️ **Einordnung:** Die 7.5s sind der **Cloud-Betrieb** (Gemini-Fallback ist im Ist-Zustand aktiv, da lokales Modell fehlt — siehe Kapitel 02, Befund 2.4 Ebene 2). Der Vergleichsdossier-Hinweis „~70s pro Anfrage" im lokalen Ollama-Modus (mit `phi3:mini`) ist realistisch für Apple-NPU-Inferenz auf einem MacBook. Lokal = langsamer, aber datenschutzkonform; Cloud = schnell, aber Daten verlassen das Gerät. **Der Mandant bestätigt: aktuell läuft ein verschlüsselter Server-Fallback.**

---

## 6.3 Geschwindigkeits-Vergleich (alle Systeme)

| System | Betriebsmodus | Latenz | Quelle |
|---|---|---|---|
| Legal Ops Advisor (Cloud-Fallback) | Gemini-2.5-flash | ~7.5s | eval_results.csv (36 Messungen) |
| Legal Ops Advisor (lokal, phi3:mini) | Apple NPU / Ollama | ~70s | Mandanten-Angabe (Vergleichsdossier) |
| Judicario | Anthropic Claude (Cloud) | wie Claude (typisch 5–15s) | abhängig von Claude-Serverlast |
| Chipsi | Cloud (OpenLaw Gateway) | nicht messbar (🔶) | kein Zugang |

⚠️ Der Geschwindigkeitsvergleich ist fair: Cloud-Systeme sind schneller, lokale Inferenz langsamer aber datenschutzkonform. Dies ist kein Qualitätsurteil, sondern ein Trade-off.

---

## 6.4 Datenbank-Performance (FTS5)

**DB-Inspektion (empirie-tester):**

| Metrik | Wert |
|---|---|
| Chunk-Anzahl | 264 (aus 22 Dateien) |
| Chunk-Ø-Größe | 1.136 Zeichen |
| FTS5-Funktionstest: "Behinderung" | 1 Treffer, <1s |
| FTS5-Funktionstest: "Existenzminimum" | 1 Treffer, <1s |

✅ Die SQLite-FTS5-Volltextsuche funktioniert und ist bei 264 Chunks praktisch instantan.
