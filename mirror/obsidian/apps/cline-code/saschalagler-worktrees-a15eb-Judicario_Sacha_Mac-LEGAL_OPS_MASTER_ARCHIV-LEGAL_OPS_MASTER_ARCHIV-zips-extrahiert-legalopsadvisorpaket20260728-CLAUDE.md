---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legalopsadvisorpaket20260728/CLAUDE.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# ⚖️ Legal Ops Advisor — Projekt-Gehirn (Single Source of Truth)

> Wird bei JEDER Claude-Session in diesem Ordner automatisch geladen. Aktuell halten. Kein Wiederholen nötig.

## Was das ist
Österr. KI-Rechtsassistent. EINE Codebasis, zwei Betriebsarten (`BACKEND_MODE=local|auto|cloud`):
- ONLINE = Demo für Kooperationspartner. Cloud Run (Frankfurt) + Firebase. Modell IMMER Gemini 2.5 Flash. NIE persönliche Daten.
- OFFLINE = privat, nur Mac. `desktop_app.py` (:7070) + Ollama. Echte private RAG.

## 🚨 Datenschutz (HART)
- Online-Container: `legal_knowledge_demo.db` (leer) via Dockerfile; `.gcloudignore` schließt echte `legal_knowledge.db` vom Upload aus. Online `/db_stats` MUSS 0/0 sein.
- `prompts/legal_ops_omni.txt` ist namensfrei ("für den Mandanten"). Fallakten bleiben lokal.

## Modellwahl (BENCHMARKED 2026-07-22, „Frist Bescheidbeschwerde VwG" = 4 Wochen §7 Abs4 VwGVG)
- Gemini 2.5 Flash = finale Rechtsantwort (einziges korrekt). gemma4:12b-it-qat = lokaler Default (bestes lokal, QAT ~2× schneller).
- qwen2.5-coder:14b / phi3:mini NICHT für Recht (halluzinieren Gesetze). Genauigkeit kommt aus RAG-Grounding, nicht Modell.

## Schlüssel
- `app.py`: `call_llm()`=lokal-first (Ollama `/api/chat` + `think:false`!) + Gemini-Fallback. „Multi-Agent"=ZTeam-Persona-Merging (4 Personas). `.agents/`=Dev-Scratch, NICHT App.
- `ris_ingest.py`: RIS-Judikatur (VwGH/OGH, OGD-API, `--suchworte`) → nur LOKALE DB. `enterprise_rag.py`/`indexer.py`=FTS5.
- Live: backend legal-ops-backend-709873485696.europe-west3.run.app · web gen-lang-client-0285074833.web.app · Projekt gen-lang-client-0285074833 (min-instances=1=Dauerkosten).


## Module & Protokoll
> Deploy-Befehle (UI vs. Backend) stehen jetzt im Skill `legal-ops-deploy` — wird automatisch geladen, wenn eine Deployment-Aufgabe ansteht.
- **MODULE_A (Volljurist):** Zivil-, Straf-, Vertrags-, Arbeitsrecht & DSGVO.
- **MODULE_B (Steuerberater):** Wirtschaftliche Optimierung, Abgabenrecht & Risikominimierung.
- **MODULE_C (Notar):** Formvorschriften, Gesellschaftsrecht & Erbrecht.
- **MODULE_D (Strategic Advisor):** Taktische Verhandlung, operative Compliance & absolute Effizienz.
- **MODULE_E (E-Government-Spezialist):** svsGO, FinanzOnline, JustizOnline, ID Austria, USP, MeinAMS (inkl. Schritt-für-Schritt Klickpfaden).
- **Strict CoVe Protocol:** Stoppt bei unklaren Fakten sofort mit `"DATENLAGE UNKLAR"` und stellt gezielte Rückfragen.

## Arbeitsweise (WICHTIG)
Deutsch. Ehrlich, NIE fabrizieren (Gemini erfand vorher 1000 Fragen/95%/Vertex — alles verifizieren). ponytail (minimal) + grill-me (Beweise statt Meinung). Ein Ding sauber zu Ende, nicht sprawlen. Spend-Limit → keine großen Agenten-Fleets.

## Offen
- RIS-Grounding ausbauen (~180 Entsch., konkurriert mit 2070 Business-Docs) → mehr Volumen ODER getrennte Rechts-DB.
- **Müll weg (~373 MB): `LegalOpsAdvisor 2.app`/`3.app` (stale, 3.app läuft=qwen-Bug), `__pycache__`, alte Prompt-Versionen (`LEGAL-OPS-OMNI-ARCHITECT*.md/.txt`, `M4 rechts architect.txt`, `unified_legal_architect.md`).** Aktueller Code: `.venv/bin/python desktop_app.py`.
- BH-Melk-Fall offen. Versand-Paket: `~/legal-ops-collection.zip`. Memory: `~/.claude/projects/-Users-saschalagler/memory/legal-ops-advisor.md`.
