---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/TEAM_BRIEFING.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# TEAM-BRIEFING — Allumfassendes Prüfarchiv (Legal Ops Advisor vs Judicario vs Chipsi)

## MISSION
Übertrage die Prüfmethodik des Scheinecker v1.4 Zwischenberichts (faire, evidenzbasierte,
3-Modi-Wertung) auf eine NEUE, allumfassende Gegenüberstellung: **Legal Ops Advisor (eigene Mac-App)
vs. Judicario (OpenLaw MCP) vs. Chipsi (OpenLaw SaaS)**. Audit auf GLEICHEM Level, faire Wertung,
ähnliche Fallhärte. Ergebnis: gestyltes Prüfarchiv (HTML Master-Report in Brand-Farben + Logo).

## ANWALTICHE LEITTHESE (vom Mandanten, /anwalt-Modus)
"Judicario/Chipsi haben GAR KEIN lokales Modell — schon der Entwicklungsstand lokaler Inferenz ist
strukturell voraus, weil eine Cloud-Architektur Offline/RAO-§9-Datenschutz NIE erreichen kann.
Aber: jede Stärke muss am CODE bewiesen werden, nicht behauptet."

## BEWERTUNGSSKALA (verbindlich)
✅ verifiziert (Code/Datei/Test-Beleg) · ⚠️ teilweise/plausibel · ❌ widerlegt · 🔶 behauptet (unbelegt)
Fairness-Regel: Stärken der Konkurrenz ehrlich würdigen (Judicario-Recherchebreite, Chipsi-Polish).

## QUELLEN (alle lokal lesbar)
- SCHEINECKER-VORGABE (Methodik): quellen/Scheinecker_v1.4_Zwischenbericht.txt
  (3-Modi: Neutral/Anwaltlich/Kritisch; 15 Arbeitsbefehle; Abschlusskontrolle; faire Tabelle)
- EIGENE APP (Code-Ground-Truth): /Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/
  app.py, desktop_app.py, indexer.py, enterprise_rag.py, ris_lookup.py, ris_ingest.py,
  run_eval.py, eval_results.csv, prompts/ (legal_ops_omni.txt=6 AGENT_01..06, gdb_analyst,
  vwgh_researcher, compliance), index.html, PROJECT.md, CLAUDE.md, .agents/ (Orchester)
- APP-DB (RAG): /Users/saschalagler/.legal-ops-advisor/legal_knowledge.db (FTS5)
- KONKURRENZ (Judicario-Paket): /Users/saschalagler/Downloads/Judicario_Sacha_Mac/
  judicario/.mcp.json (6 http-Connectoren), .claude-plugin/plugin.json (enterprise, 100k credits),
  judicario/commands/ (8 Commands), Connectoren_URLs.txt, CLI-Installer (8 Module: +insurance,+steuer-de)
- DESIGN: assets/DESIGN_TOKENS.md (Farben #2563EB/#059669, EB Garamond/Lato), assets/legal-ops-logo.png

## BEREITS VERIFIZIERT (von Lead, als Startpunkt — NICHT neu behaupten, nur bestätigen/erweitern)
1. Judicario = Cloud-only (Anthropic, Pro/Team/Max nötig), 8 Commands, kein Kanzlei-PDF, kein E-Gov,
   kein Eval-Framework. Command-Gap: 7 von 15 Scheinecker-Befehlen vorhanden; fehlen /anwalt,
   /argumente, /widerlegung, /gegenprüfung, /frist, /strategie, /risiko, /cockpit → anwaltlicher +
   kritischer Modus als Commands NICHT vorhanden (belegt Scheineckers "zu zurückhaltend"-Diagnose).
2. Judicario Config-Drift: CLI=8 Module, .mcp.json/Web=6 (insurance/steuer-de nur CLI).
3. Judicario Key im Klartext in 4 Dateien (Sicherheitsbefund, redigiert behandeln).
4. RIS ist erreichbar (data.bka.gv.at→data.gv.at; ris.bka.gv.at HTTP 200). ris_lookup.py nutzt
   API https://data.bka.gv.at/ris/api/v2.6/Bundesrecht mit FassungVom=<heute> (Anti-Halluzination).
5. Legal Ops Advisor: FastAPI:7070 + PyWebView, SQLite FTS5 RAG, Ollama lokal (gemma4:12b-it-qat)
   + Gemini-2.5-flash-Fallback, BACKEND_MODE auto/local/cloud, DDGS-Websuche, RAM-Check.
6. eval_results.csv: 36 Szenarien real, Latenz ~7.4-7.8s, Spalte "Norm getroffen?" JA/NEIN (ehrlich!).

## ZU PRÜFENDE DIMENSIONEN (jede als Kapitel)
Architektur & Modelle · Lokale Inferenz/Offline · Agenten & Sub-Agenten · Orchester (.agents) ·
Userflow/Chat-Flow · Skills/Prompts (3-Modi/15 Commands) · Extensions/MCP-Tools · RIS/Daten-Live ·
Genauigkeit (Halluzination) · Schnelligkeit/Latenz · Eval-Framework · Kommunikation/Output-Protokoll ·
Kosten · Datenschutz/RAO-§9 · E-Government-Agentik · Sicherheit.

## DELIVERABLE-STRUKTUR (Prüfarchiv)
kapitel/01..09 als Markdown (siehe Aufgaben), dann 00_MASTER_REPORT.html (gestylt, Brand, A4-print).
empirische_tests/ für Test-Rohdaten + Analysen.
