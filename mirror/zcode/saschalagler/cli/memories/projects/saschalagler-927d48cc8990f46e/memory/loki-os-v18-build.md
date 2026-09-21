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

Verwandt: [[loki-second-brain]], [[loki-os-harness-sollstand]], [[sascha-arbeitsregeln-hart]], [[sascha-vollzug-keine-zwischenfragen]]
