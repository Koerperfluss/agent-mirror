---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-v18-build.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: loki-os-v18-build
description: LOKI.OS v18-Vollbau (21.09.2026) per动态 Workflow — Run dwfrun-5d491f4f baut
  das GANZE Agentic OS als SwiftUI-Endprodukt frisch in ~/loki-ki/macos-app-v18/
  (v17-Originale unberührt); плюс Agent-Dispatch-Diagnose-Run dwfrun-5df3ba28.
  Kern-Lektion: Workflow-Lane zuverlässig, direkte Chat-Dispatches sterben bei Turn-Interrupt.
metadata:
  type: project
---

LOKI.OS v18 — VOLL-ÜBERNAHME PER WORKFLOW (21.09.2026):

**Auftrag (Scope-Korrektur):** Sascha: „DES GANZE AGENTIC OS - LOKI.os" (nicht nur Brain) — übernehmen, durchleuchten, alles Offene bauen, neues UI, Verbindungen, modernes Routing, Mermaid-Illus → „übersichtliches nutzbares schönes funktionales Endprojekt" mit Planung/Verteilung/Testung. Ausgelöst per **/workflow** → CreateWorkflow verpflichtend.

**Run `dwfrun-5d491f4f`** (Script: `.zcode/workflow-drafts/LOKI.OS-v18--Voll-Übernahme-zum-Endprodukt.dwf.ts`): 11 Agenten, 6 Phasen — 3 Kundschafter (App v17/Kernel/Kanon) → Architekt (Skelett+PLAN.md+build.sh in **~/loki-ki/macos-app-v18/**) → 3 Bau-Worker parallel mit getrennter Datei-Hoheit (UI-Bauer: Sidebar-App mit Dashboard/Brain-Live-Suche/Heute/interaktive Karte/Loki-fragen · Verbindungs-Bauer: Connections.swift zu Daemon :8078, brain.py, brain.db read-only, Kernel :8010, OmniRoute · Doku-Bauer: ARCHITEKTUR.md mit ≥3 Mermaid-Diagrammen auch in Obsidian-Vault) → Build-Gate als Code (bash build.sh, 3 Reparatur-Runden) → QA + Reviewer parallel → Abschluss-Artefakt. Status beim Check: Phase 2/6, Kundschafter 1,6M/800k/614k Tokens ✅, 0 Fehler. **Design-Entscheidung:** natives Premium-Design (Indigo→Violett, SF Symbols) statt Higgsfield-API (keine Keys).

**AGENT-DISPATCH-PROBLEM (Screenshot 21.09. 15:28) — DIAGNOSE FERTIG (dwfrun-5df3ba28, Bericht-Artefakt „Agent-Diagnose"):** 3/3 Live-Sonden grün = Lane intakt. (a) 3× „Agent was cancelled" = **SIGTERM-App-Neustart-Kill 15:25:41** (`child-process-gone reason:killed exitCode:15`, pid 73438, geplanter Neustart — exakt beim Mid-Turn-/workflow-Interrupt); Config unschuldig (parst `OK 17`, keine leeren Hook-Matcher). (b) „Not Found" (20.09. 23:40) = **reviewer auf qwen/qwen3.8-max via ClinePass** — TerminalStreamChunkError nach 494 ms (model-io-sess_subagent_agent_0d8e4862-….jsonl); Route registriert (provider_config.json providerRules[2]), Live-Erreichbarkeit ungetestet; Modell bewusst NICHT geändert (Saschas Wahl — bei erneutem Not Found auf GLM umstellen). (c) Verstärker: 273× „event delivery skipped credentials-unavailable" + „ZCode Agent runtime is not running" 13:02 + „glm binary path: not found" nach Neustart (`~/.zcode/v2/logs/2026-09-21.log`; Host-Logs liegen nur dort — `~/.zcode/cli/logs` existiert nicht). **Automatisch repariert mit Backups (.bak):** 7/9 leere Description-Platzhalter `">"` durch echte deutsche Beschreibungen ersetzt (Zeile 3 je Datei), `thoughtLevel: enabled → high` (gate-enforcer-test.md:6); Gates grün: Config-JSON-Exit-0 + alle 9 haben `model:`. **Regel bleibt: Langlebige Teams via CreateWorkflow; direkte Dispatches nie mit neuen Nutzer-Nachrichten kollidieren lassen.**

**DATEI-BERG-AUFRÄUMUNG — Run `dwfrun-32a721cc`** (Script: `.zcode/workflow-drafts/LOKI-Datei-Berg-austristen--Konsolidierung--Entwicklungs-Kanon.dwf.ts`, 21.09. gestartet): Saschas Auftrag „miste aus, sortiere, lösche Duplikate, lies die Entwicklung, bau was offen ist (v18-Run deckt Bauen ab)". 7 Agenten/5 Phasen: 2 Zonen-Scouts (Desktop-Zonen: alrround voice, CODEX_PAKET, coworkspace-„Local AI"-Monster · Rest: Downloads/WhatsApp, Home-Root) → Archivar (Kanon-Plan) → Umzügler (**nur mv, NIE rm**, Ziel `~/Desktop/Coworkspace_Ich/_LOKI_KONSOLIDIERUNG_2026-09-21/` mit manifest_kanon.txt + ARCHIV_INVENTAR.md, Kanon-Gate als bash-Code) → Historiker (liest AGENTIC_OS_WISSEN + DEEP-DIVE-PDF + AIOS-4-Level-Plan + CODEX-Handout → Soll/Lücken) → Doku-Baumeister (MASTER_INDEX.md im CODEX_PAKET, Obsidian „Entwicklungslinie & Lücken", SESSION_CONTEXT-Append). **Geschützte Zonen:** ~/loki-ki (laufend), Google Drive (Sync), Mirror, CODEX_PAKET + alrround voice (Kanon-Quellen); Müll nur gemeldet — Löschen = Sascha-GO. **Stand beim Start: 3 Workflows parallel aktiv** (v18-Bau Phase 2/6 gesund · Agent-Diagnose · Aufräumung); Ergebnisse kommen asynchron per Completion-Notification — bei Wiederaufnahme ALLE drei Run-IDs checken (GetWorkflowRun/ListWorkflowRuns).

Verwandt: [[loki-second-brain]], [[loki-os-harness-sollstand]], [[sascha-arbeitsregeln-hart]], [[sascha-vollzug-keine-zwischenfragen]]
