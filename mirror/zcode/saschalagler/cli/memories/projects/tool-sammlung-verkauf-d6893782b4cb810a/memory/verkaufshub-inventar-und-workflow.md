---
name: verkaufshub-inventar-und-workflow
description: Verkaufshub-Stand (12 echt/52 ghost, tools-v2-Schema) + erweiterter
  Analyse-Workflow dwfrun-1fa50c64 (8 Subagenten, TODO+Sammlung+Vermarktung)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ae843b4f-7d6d-4039-bedc-8a6e6619ff44
---

Stand 2026-10-10 (Projekt TOOL-SAMMLUNG-VERKAUF):

- **Repo-Pfad hat LEERZEICHEN am Ende des Ordners**: `/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /TOOL-SAMMLUNG-VERKAUF` — "PRIVATE PORJEKTE " mit trailing space, beim Quoten beachten.
- **tools-v2.json**: 64 Einträge; `dev_status`-Werte: `echt` (11) + `echt-repo` (1) = **12 echt**, `GHOST-PFAD-EXISTIERT-NICHT` (49) + `ghost-404-repo` (3) = **52 ghost**. Feld liegt top-level, nicht verschachtelt.
- **verkaufs hub** (`/Users/saschalagler/Claude/Projects/TOOL SAMMLUNG VERKAUF/vibe-sales-suite/verkaufs hub/`): **13** ai_studio_code-Dateien existieren (nicht 14 — Command-Zählung falsch); bekannte Dubletten: (6)=(7) 2537 B, (8)=(10) 3173 B.
- **Workflow (amendiert)**: aktiv `dwfrun-1fa50c64-4e43-4909-bdda-8ddaf49fc4a0` (Vorläufer dwfrun-6586af54 superseded), Script `.zcode/workflow-drafts/Verkaufshub-Analyse-13-ai_studio-Dateien--Inventar-Audit.dwf.ts`. Topologie 8 Subagenten: Welle 1 parallel Datei-Extraktor + Real-Tool-Analyst → Welle 2 parallel Kandidaten-Auditor + Markt-Preis-Analyst + **Voll-Sammler** (Zonen-Scan Coworkspace_Ich/Desktop/Documents/loki-ki/agent-os/antigravity-sdk vs. tools-v2, max 15 Funde) → Handoff-Schreiber (`HANDOFF-ANALYSE-2026-10-10.md`) → **TODO-Schreiber** (`TODO-ZIELE-2026-10-10.md`, primary-Artifact; liest PLAN/PROJECT/STATUS/DASHBOARD-ANALYSE/INVENTAR-VOLL; Inhalt: Ziele/umgesetzt/offen/Roadmap bis verkaufsfertig/Vermarktung WAS-WO-WIE-WANN) → Lückenleser prüft BEIDE Dateien (max 1 Fix-Runde). Gate: `world.run("python3", ["pipeline/runner.py","status"])`.
- **Gelernt für ZCode-Workflows hier:** (a) `subagent_model` NICHT setzen → Session-Modell (GLM-5.3-Flash); Vorgänger-Fehler: Spawn auf GLM-5.3-Highspeed → abgelehnt ("subscription plan does not include access"). (b) `AmendWorkflow` auf laufendem Run klappt: Vorgänger gestoppt+superseded, fertige Welle-1-Arbeit (~1M Tokens) per Cache importiert, nichts neu bezahlt — Erweiterungs-Anfragen des Nutzers mitten im Run → amendieren, nicht neu starten.
- **Nutzerwunsch "11 subagents übernehmen alles"**: 11er-Evaluations-Cluster lebt in `pipeline/agents.py` (A1–A11) via `runner.py`; der Workflow ist das Analyse-Team darüber. Offen: klären, welche Rollen (Analyse/Suche/Verwaltung/Vermarktung) für vollautonomes Hub fehlen.
- Stopp-Regeln des Projekts: kein Gumroad-Upload ohne Nutzer-Review, kein Deploy, kein git push, Inventar-JSON nur analysieren.
