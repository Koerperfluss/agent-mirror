---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/kapitel/03_agenten_orchester_userflow.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# KAPITEL 03 — Agenten, Orchester & Userflow

**Prüfdatum:** 28.07.2026 · **Lead-Audit** (mit Team-Befunden aus 02/04)
**Bewertungsskala:** ✅ verifiziert (Code) · ⚠️ teilweise · ❌ widerlegt · 🔶 behauptet

---

## 3.1 Das 6-Sub-Agenten-System (Prompt-Ebene, keine eigene Infrastruktur) ⚠️

**Behauptung (Marketing):** „6 KI-Experten (Richter, Anwalt, Notar, Steuerberater, E-Gov, Strategist)" arbeiten im System.

**Befund (Code):** Die sechs Agenten existieren **ausschließlich als Prompt-Konstrukt** in `prompts/legal_ops_omni.txt`. Es gibt keine getrennten Prozesse, keine Sub-Agent-Orchestrierung im Code — es ist EIN Omni-Prompt, der sechs Rollen simultan simuliert:

| Agent | Rolle (Prompt-Zeile) | Beleg |
|---|---|---|
| AGENT_01 | Richter & Instanzen-Spezialist (ZPO/StPO/AVG/VwGVG/BAO/IO), Instanzenzug Zivil/Straf/Verwaltung/EU | `legal_ops_omni.txt` Z. 12–17 |
| AGENT_02 | Volljurist & Zivilrechtler (ABGB/UGB/KSchG/StGB/DSGVO/GewO/ArbVG/MRG/WEG/UrhG/AI Act) | `legal_ops_omni.txt` Z. 18–19 |
| AGENT_03 | Steuerberater & Wirtschaftsprüfer (EStG/KStG/UStG/BAO/FinStrG/UmgrStG/GebG/BewG) | `legal_ops_omni.txt` Z. 21–22 |
| AGENT_04 | Notar & Gesellschaftsrechtler (GmbHG/FlexKapGG/AktG/PSG/Erbrecht/Grundbuch/Firmenbuch) | `legal_ops_omni.txt` Z. 24–25 |
| AGENT_05 | E-Government- & Digital-Spezialist (FinanzOnline/JustizOnline/svsGO/MeinAMS/USP/ID Austria/BRZ/ERV/Ediktsdatei) | `legal_ops_omni.txt` Z. 27–28 |
| AGENT_06 | Strategic & Litigation Advisor (Taktik/Restrukturierung/Exekutionsabwehr/Schadensminimierung) | `legal_ops_omni.txt` Z. 30–31 |

⚠️ **Ehrliche Einordnung:** Das ist ein **Single-Prompt-Rollenspiel**, keine Multi-Agent-Architektur. Der Prompt ist professionell detailliert (jeder Agent mit spezifischen Normen/Portalen) und das Zero-Assumption-Paradigma + der 4-Phasen-Loop strukturieren die Ausgabe — aber es simuliert Agenten, es orchestriert keine.

---

## 3.2 Das .agents/-Orchester (im Code, nicht in der App) 🔶

Die App enthält einen `APP/.agents/`-Ordner mit Sub-Ordnern:

| Verzeichnis | Inhalt | Status |
|---|---|---|
| `.agents/orchestrator/` | handoff.md (Orchestrierungsdoku) | ⚠️ Doku/Protokoll, kein laufender Code |
| `.agents/explorer_m1_2/` | BRIEFING.md, analysis_ams.md, progress.md | ⚠️ Protokoll eines realen Agenten-Testlaufs (AMS-Fall) |
| `.agents/explorer_m1_3/` | BRIEFING.md, analysis_oegk.md | ⚠️ Protokoll (ÖGK-Fall) |
| `.agents/worker_m2/` | BRIEFING.md, progress.md | ⚠️ Protokoll |
| `.agents/reviewer_m3_1/` | BRIEFING.md, progress.md | ⚠️ Protokoll |
| `.agents/challenger_m3_2/` | BRIEFING.md, progress.md | ⚠️ Protokoll |
| `.agents/victory_auditor/` | BRIEFING.md, progress.md | ⚠️ Protokoll |
| `.agents/sub_orch_implementation/` | ORIGINAL_REQUEST.md | ⚠️ Spezifikation |
| `.agents/teamwork_preview_*/` | BRIEFING, progress, handoff, Python-Skripte, JSON-Results | ⚠️ Agenten-Team-Testläufe (empirische Tests) |

🔶 **Feststellung:** Der `.agents/`-Ordner dokumentiert **manuelle/externe Agenten-Testläufe** (wahrscheinlich via Cline/Cursor/Claude-Team-Features), NICHT einen in die App integrierten Multi-Agent-Orchestrator. Die `run_full_empirical.py` und `test_message_key.py` in `teamwork_preview_challenger_m3_1/` belegen, dass hier echte Tests gelaufen sind — aber extern, nicht als App-Feature.

---

## 3.3 Die 4 Personas (tatsächliches Prompt-System) ✅

Im Gegensatz zur Marketing-Behauptung hat die App **4, nicht 6 Personas**:

| Persona | Datei | Funktion |
|---|---|---|
| Legal-Ops-Omni-Architect v7.0 | `prompts/legal_ops_omni.txt` | Allzweck (enthält die 6 Sub-Agenten als Rollen) |
| GdB-Analyst | `prompts/gdb_analyst.txt` | Grad-der-Behinderung-Analyse |
| VwGH-Researcher | `prompts/vwgh_researcher.txt` | Verwaltungsgerichtshof-Recherche |
| Compliance | `prompts/compliance.txt` | Compliance-Prüfung |

✅ **Auto-Routing via Keywords:** `app.py` Z. 170–175 + 449–485: Keywords in der Frage routen automatisch zur passenden Persona (z.B. "GdB" → gdb_analyst, "VwGH" → vwgh_researcher). Dieses Routing ist **code-belegt und funktional** — eine echte Leistung.

---

## 3.4 Userflow / Chat-Flow (✅ Code-belegt)

Der tatsächliche Query-Flow (`app.py`):

1. **Eingang:** `/query` POST (user_message + persona + mode + context_files)
2. **RAM-Check:** `get_free_ram_mb()` vor Inferenz, HTTP 503 bei Unterschreitung (`app.py:454-460`)
3. **Auto-Persona-Routing:** Keyword-Matching → Persona-Auswahl (`app.py:170-175`)
4. **Kontext-Bau:** SQLite FTS5 RAG-Suche (Kontext-Chunks) + RIS-OGD-Live-Lookup (optionale Verbatim-Injektion) + DDGS-Websuche
5. **Inferenz:** `call_llm()` → auto-Modus: zuerst Ollama lokal (timeout 180s), bei Fehler Gemini-Cloud-Fallback; local-Modus: niemals Cloud; cloud-Modus: nur Gemini
6. **Output:** BLUF ⚡ERGEBNIS + Prüfprotokoll + Masterplan-Tabelle + Exekution

⚠️ **Anmerkung zum E-Government-Userflow:** Der Prompt (`legal_ops_omni.txt` Z. 28, 43) beschreibt „PORTAL-ROUTING: Exaktes E-Government-Portal + genauer Klickpfad" — das ist Textberatung, keine automatisierte Browser-Steuerung. Chrome-DevTools-MCP-Agentik (wie im Marketing behauptet) ist **nicht im Code oder in den Teamwork-Testläufen belegt**. 🔶

---

## 3.5 Agenten-Übersicht (alle drei Systeme)

| Dimension | Legal Ops Advisor | Judicario | Chipsi |
|---|---|---|---|
| Multi-Agent | ⚠️ 6 Sub-Rollen im Omni-Prompt + externes .agents/-Testorchester | ❌ kein Agentensystem (reiner Recherche-Connector) | 🔶 unbekannt |
| Personas | ✅ 4, mit Keyword-Auto-Routing (code-belegt) | ❌ keine Personas (ein Chat-Prompt pro Command) | 🔶 |
| Orchester | ⚠️ .agents/-Protokolle externer Testläufe | ❌ | 🔶 |
| Userflow | ✅ 6-Schritt-Flow code-belegt (RAM-Check→Routing→RAG→RIS→LLM→Output) | ⚠️ abhängig von Claudes eigenem Flow | 🔶 |
| E-Gov-Agentik | ❌ im Code: Textberatung ("PORTAL-ROUTING"), keine Browser-Automation | ❌ nicht vorhanden | ❌ |
