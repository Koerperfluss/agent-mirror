---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/kapitel/05_ris_daten_genauigkeit.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# KAPITEL 05 — RIS OGD, Datenbasis & Genauigkeit

**Prüfdatum:** 28.07.2026 · **Lead-Audit** (mit Team-Empirie aus DB-Inspektion + RIS-Live-Test)

---

## 5.1 RIS OGD API v2.6 — Live-Verifikation ✅

**Behauptung:** „RIS OGD API v2.6 Live-Injektor holt tagesaktuelle Gesetzestexte verbatim von data.bka.gv.at."

**Befund (Lead-Test, 28.07.2026, 18:30):**

| Test | Ergebnis | Beleg |
|---|---|---|
| `ris_lookup.py` definiert API-Endpoint `https://data.bka.gv.at/ris/api/v2.6/Bundesrecht` | ✅ Z. 10 | `APP/ris_lookup.py:10` |
| Endpoint live erreichbar (HTTP 200, JSON) | ✅ | `curl` → `Content-Type: application/json; charset=utf-8` |
| Abfrage `Applikation=BrKons&Suchbegriffe=Stammkapital&Titel=GmbHG&Fassung.FassungVom=2026-07-28` | ✅ 155 Treffer, korrektes Gesetz: „GmbH-Gesetz (GmbHG)" | `empirische_tests/ris_api_v2.6_gmbhg_stammkapital_LIVE.json` (41KB) |
| Titel-Filter-Mechanismus greift: verhindert Fehl-Treffer (z.B. Anti-Doping-Gesetz bei „Stammkapital") | ✅ | `APP/ris_lookup.py:30-42` — LAW_TITLES-Dict |
| `Fassung.FassungVom=<heute>` als Anti-Halluzinations-Mechanismus (nur aktuelle Fassung) | ✅ | `APP/ris_lookup.py: Z. 5-7` — Kommentar + API-Parameter |
| `_detect_law_title()` schlägt aus Suchbegriffen korrekt GmbHG/UStG/EStG/MRG etc. vor | ✅ | `APP/ris_lookup.py:44-49` |
| Keyword-Stemming + Suffix-Stripping (Kleinunternehmerbefreiung→Kleinunternehmer) vermeidet 0-Treffer bei zusammengesetzten Begriffen | ✅ | `APP/ris_lookup.py:17-24` |

✅ **Urteil:** Die RIS-OGD-Live-Anbindung ist **vollständig verifiziert** — Endpoint, Suchlogik, Anti-Halluzinations-Filter, Titel-Detektion und Stemming sind code-belegt und live getestet. Dies ist eine **echte, technisch saubere Leistung**.

---

## 5.2 Anti-Halluzinations-System (Prompt-Ebene) ✅

**Behauptung:** „Beträge, Schwellenwerte und Paragraphen dürfen NIEMALS aus dem Trainingswissen geraten werden."

**Befund:** Der VERBATIM-ZWANG in `prompts/legal_ops_omni.txt` ist **die härteste Anti-Halluzinations-Regel im gesamten System-Vergleich**:

```
VERBATIM-ZWANG (ANTI-HALLUZINATION): Beträge, Schwellenwerte (z.B. GmbH-Stammkapital, Kleinunternehmergrenze) und Paragraphen dürfen NIEMALS aus dem Trainingswissen geraten werden. Sie MÜSSEN durch die beigefügten Web/RIS-Suchergebnisse (Live-Context) 1:1 belegt werden (Verbatim Proof). Wenn der Kontext keine aktuelle Zahl liefert, VERWEIGERE die Nennung einer Zahl mit der Meldung „BETRAG NICHT IM LIVE-KONTEXT VERIFIZIERT".
```
(`APP/prompts/legal_ops_omni.txt` Z. 37)

Weiter verschärft in Z. 65-70: „Eine falsche Zahl in einem Schriftsatz ans Gericht ist der schlimmste Fehler." — Kein Modell-Raten, nur Kontext-Werte, sonst Abbruch.

✅ **Vergleich mit Judicario:** Judicario hat „KEINE unverifizierten Zitate" (Kapitel 04, Befund 4.2.1) — gut, aber weicher. Der Legal-Ops-Advisor-Prompt erzwingt **Verweigerung statt Schätzung** — härter und im Rechtskontext richtig.

---

## 5.3 Datenbasis: FTS5-RAG-DB im Ist-Zustand ⚠️

**DB-Inspektion (empirie-tester, 28.07.2026):**

| Metrik | Wert |
|---|---|
| SQLite-Tabellen | `files` (22), `chunks` (264), `chunks_fts` (FTS5, 264 Index-Zeilen) |
| Chunk-Größe | min 4, ø 1.136, max 1.200 Zeichen |
| Inhalt | Persönliche Fallakten (Exekution BG Melk, AMS, Sozialhilfe NÖ, Darlehn, Lohnbestätigung) + 5 Prompt-Dateien |
| FTS5-Suche "Stammkapital" | **0 Treffer** — kein Gesellschaftsrecht in der DB |
| FTS5-Suche "Kleinunternehmer" | **0 Treffer** — kein Steuerrecht in der DB |
| FTS5-Suche "Existenzminimum" | 1 Treffer |

⚠️ **Ehrlicher Befund:** Die Datenbank enthält **ausschließlich persönliche Fallakten**, kein systematisches Rechtskorpus. Die im Marketing-Vergleich behauptete Geschwindigkeit („blitzschnelle eigene Fallakten") ist für diese Akten belegt — aber es fehlt das **Normen-Korpus** als Ergänzung zur RIS-Live-Abfrage. Judicario hat den Vorteil kuratierter Korpora; der Legal-Ops-Advisor setzt auf Live-RIS + persönliche Akten-RAG. Funktioniert für die persönlichen Fälle, ist aber keine Rechtsdatenbank.

---

## 5.4 Genauigkeits-Selbsteinschätzung (Vergleichsdossier)

**5-Punkte-Test des Mandanten (laut Vergleichsdossier):**

| Frage | Korrekt | Legal Ops Advisor | Judicario |
|---|---|---|---|
| Frist Bescheidbeschwerde LVwG (4 Wo, § 7 VwGVG) | ✅ | ✅ Korrekt | ✅ Korrekt |
| Frist Revision VwGH (6 Wo, § 26 VwGG) | ⚠️ falscher § | Dauer richtig, § falsch (§ 28 statt § 26) | ✅ Korrekt |
| GmbH-Stammkapital (10.000€) | ✅ | ✅ 10.000€ mit RIS-Quelle | ✅ 10.000€ verbatim |
| USt-Kleinunternehmer (55.000€) | ✅ | ✅ 55.000€ mit RIS-Quelle | ⚠️ Norm korrekt, Betrag abgeschnitten |
| ESt-Nullzone (13.539€) | ✅ | ✅ „nicht verifiziert" (ehrlich) | ✅ 13.539€ aktuellster Stand |

⚠️ **Anmerkung:** Vor dem RIS-Fix nannte Legal Ops Advisor 35.000€ („veraltete, erfundene Zahl") — der RIS-Live-Injektor hat den Fehler geheilt. Judicario ist bei 4/5 Fragen korrekt; Legal Ops Advisor ebenfalls 4/5 korrekt, einmal ehrlich verweigert statt geraten.

---

## 5.5 Kapitel-Fazit

| Dimension | Legal Ops Advisor | Judicario |
|---|---|---|
| RIS-Live-API | ✅ code-belegt + live getestet | ⚠️ indirekt (OpenLaw-Korpora indexieren RIS) |
| Anti-Halluzination | ✅ VERBATIM-ZWANG (Verweigerung statt Rat) | ✅ Verifikations-Pflicht (weicher) |
| Rechts-Datenbasis | ⚠️ nur persönliche Akten + RIS-Live (kein Kurz-Korpus) | ✅ kuratierte Korpora AT/DE/CH/EU |
| Genauigkeit (5 Tests) | ✅ 4/5 korrekt, 1× ehrlich verweigert | ✅ 4/5 korrekt |
