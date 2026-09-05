# KAPITEL 01 — Prüfvorgabe & Methodik (Scheinecker v1.4 Transfer)

**Datum:** 28.07.2026 · **Lead-Redaktion**
**Basis:** Frank Scheinecker Zwischenbericht v1.4 (22.07.2026) — `quellen/Scheinecker_v1.4_Zwischenbericht.txt`

---

## 1.1 Persönliche Vorbemerkung (im Stil Scheineckers)

Dieses allumfassende Prüfarchiv überträgt die Methodik des Scheinecker-Praxistests auf einen erweiterten Gegenstand: die systematische Gegenüberstellung des Legal Ops Advisor (eigenentwickelte Mac-App) mit den Konkurrenzprodukten Judicario (OpenLaw MCP) und Chipsi (OpenLaw SaaS). Der Bericht versteht sich als konstruktiver, evidenzbasierter Beitrag — er würdigt Stärken aller Seiten, dokumentiert konkrete Befunde aus Code-Audit und empirischen Tests und zeigt Verbesserungspotenziale.

---

## 1.2 Übertragene Scheinecker-Methodik

| Scheinecker-Element | Übertragung auf dieses Audit |
|---|---|
| **3-Modi-Logik:** Neutraler / Anwaltlicher / Kritischer Modus | Angewandt: neutraler Code-Audit (✅/⚠️/❌) + anwaltliche Leitthese („lokales Modell strukturell voraus") + kritische Gegenprüfung (E-Gov ist offen, 36 nicht 100 Szenarien) |
| **Bewertungstabelle:** Prüfbereich / Ergebnis / Kurzbegründung | In jedem Kapitel als Dimensionstabelle |
| **Festgestellte Auffälligkeit:** eigene Rubrik für ehrliche Befunde | Kapitel 02 (Modell-Diskrepanz), 03 (Agenten nur Prompt-Rollenspiel), 05 (DB enthält nur persönliche Akten) |
| **15 Arbeitsbefehle:** Scheinecker-Matrix | Kapitel 04 vollständig abgebildet (Judicario 7/15 ✅) |
| **Abschlusskontrolle Schriftsätze:** Ist Ziel erkennbar? Stehen stärkste Argumente vorne? | Angewandt als Meta-Prüfung jedes Kapitels |
| **Faire Konkurrenzwürdigung** | Kapitel 08b: 6 Judicario-Stärken ehrlich benannt; Kapitel 09: Gesamtwertung mit Stärken aller Seiten |

---

## 1.3 Bewertungsskala

| Symbol | Bedeutung |
|---|---|
| ✅ | Verifiziert (Code-Zeile, Datei-Beleg, oder Live-Test) |
| ⚠️ | Teilweise verifiziert / Plausibel / Mit Anmerkung |
| ❌ | Widerlegt / Nicht vorhanden |
| 🔶 | Behauptet (kein Beleg einsehbar — Code oder Zugang fehlt) |

---

## 1.4 Quellenübersicht

| Quelle | Pfad/Status |
|---|---|
| Scheinecker v1.4 Zwischenbericht | `quellen/Scheinecker_v1.4_Zwischenbericht.txt` ✅ |
| Legal Ops Advisor Code | `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/` ✅ |
| Judicario Installationspaket | `/Users/saschalagler/Downloads/Judicario_Sacha_Mac/` ✅ |
| RAG-Datenbank (SQLite) | `/Users/saschalagler/.legal-ops-advisor/legal_knowledge.db` ✅ |
| eval_results.csv (Eval-Framework) | `APP/eval_results.csv` (36 Szenarien) ✅ |
| RIS OGD API v2.6 | `https://data.bka.gv.at/ris/api/v2.6/Bundesrecht` ✅ (live) |
| Judicario Gateway | `https://gateway.openlaw.cc/mcp/at/` ✅ (HTTP 401/Auth) |
| Chipsi SaaS | `https://chipsi.openlaw.cc` ✅ (Login-Seite live) |

---

## 1.5 Anwaltliche Leitthese (vom Mandanten, /anwalt-Modus)

> „Judicario und Chipsi haben GAR KEIN lokales Modell. Schon der Entwicklungsstand lokaler Inferenz ist strukturell voraus, weil eine Cloud-Architektur den Offline-RAO-§9-Datenschutz NIE erreichen kann. Die eigene LLM-Entwicklung (Thomas Team), der verschlüsselte Server-Fallback und das selbstlernende Hintergrund-Hirn sind echte Differenzierungsmerkmale — auch wenn sie teilweise noch in Entwicklung sind. Einzig die E-Government-Agentik (ID Austria, FinanzOnline) ist das verbleibende offene Entwicklungsthema."

⚠️ **Anmerkung des Auditors:** Jede Behauptung dieser Leitthese wird in den folgenden Kapiteln gegen Code geprüft. Die Fairness-Regel verlangt, dass auch die Stärken der Konkurrenz ehrlich gewürdigt werden (Kapitel 08b/09).
