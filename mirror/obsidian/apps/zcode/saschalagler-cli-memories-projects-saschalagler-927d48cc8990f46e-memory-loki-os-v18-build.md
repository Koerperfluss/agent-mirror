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

**AGENT-DISPATCH-PROBLEM (Screenshot 21.09. 15:28):** 3 direkte Chat-Dispatches „Agent was cancelled" + früher 1× „Not Found" (subagent_type reviewer). Diagnose: (a) Cancelled = Mid-Turn-Interrupt — Sascha tippte /workflow während die Agenten liefen; KEIN Config-Schaden. (b) Not Found = reviewer läuft auf qwen3.8-max via ClinePass-UUID (3a11f548-…), vermutlich tote Route. **Beweis:** dieselben 3 Kundschafter liefen im Workflow fehlerfrei. **Regel: Langlebige Agenten-Teams über CreateWorkflow fahren; direkte Agent-Dispatches nie mit neuen Nutzer-Nachrichten kollidieren lassen.** Diagnose-Run `dwfrun-5df3ba28` (Config-Auditor + Spurenleser + 3 Live-Sonden + Konfig-Heiler mit Backups + python-Gates auf config.json/model-Felder) lief parallel.

**DATEI-BERG-AUFRÄUMUNG — Run `dwfrun-32a721cc`** (Script: `.zcode/workflow-drafts/LOKI-Datei-Berg-austristen--Konsolidierung--Entwicklungs-Kanon.dwf.ts`, 21.09. gestartet): Saschas Auftrag „miste aus, sortiere, lösche Duplikate, lies die Entwicklung, bau was offen ist (v18-Run deckt Bauen ab)". 7 Agenten/5 Phasen: 2 Zonen-Scouts (Desktop-Zonen: alrround voice, CODEX_PAKET, coworkspace-„Local AI"-Monster · Rest: Downloads/WhatsApp, Home-Root) → Archivar (Kanon-Plan) → Umzügler (**nur mv, NIE rm**, Ziel `~/Desktop/Coworkspace_Ich/_LOKI_KONSOLIDIERUNG_2026-09-21/` mit manifest_kanon.txt + ARCHIV_INVENTAR.md, Kanon-Gate als bash-Code) → Historiker (liest AGENTIC_OS_WISSEN + DEEP-DIVE-PDF + AIOS-4-Level-Plan + CODEX-Handout → Soll/Lücken) → Doku-Baumeister (MASTER_INDEX.md im CODEX_PAKET, Obsidian „Entwicklungslinie & Lücken", SESSION_CONTEXT-Append). **Geschützte Zonen:** ~/loki-ki (laufend), Google Drive (Sync), Mirror, CODEX_PAKET + alrround voice (Kanon-Quellen); Müll nur gemeldet — Löschen = Sascha-GO. **Stand beim Start: 3 Workflows parallel aktiv** (v18-Bau Phase 2/6 gesund · Agent-Diagnose · Aufräumung); Ergebnisse kommen asynchron per Completion-Notification — bei Wiederaufnahme ALLE drei Run-IDs checken (GetWorkflowRun/ListWorkflowRuns).

Verwandt: [[loki-second-brain]], [[loki-os-harness-sollstand]], [[sascha-arbeitsregeln-hart]], [[sascha-vollzug-keine-zwischenfragen]]
