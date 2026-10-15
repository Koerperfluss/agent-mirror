---
name: dynamic-workflow-topologie-2026-10-15
description: 15.10. dynamischer Workflow dwfrun-542bffb6 COMPLETED
  (Workflow-Topologie planen) — 4-Subagenten-Kette, Dashboard auf Platte,
  2 verified Findings (Verify-Checks trivial-sicher) + Lessons zu
  Skill-Tool-Params und ZCode Free-Modell-Fallback-Garbage
metadata:
  node_type: memory
  type: project
  originSessionId: sess_20f1e63e-080e-468a-8f20-86ccadee7966
---

**15.10.2026 — Workflow „Workflow-Topologie planen" FERTIG (dwfrun-542bffb6 COMPLETED):**
- Run-ID: `dwfrun-542bffb6-306d-4969-afba-128165b4a83b`, kompilierte clean, lief im Hintergrund durch
- Beweis: `~/.zcode/workspace/default/out/topologie-workflow.html` (13.468 Bytes, per `ls` geprüft) + Inventar-Tabelle 7/7 Skills existieren
- Ergebnis: Rollen-Landkarte, Plan mit 5 Slices, kalt geprüft = „verwendbar" mit 3 Verify-Fixes; **OFFEN auf GO: Slices wirklich ausführen** (Nutzer noch nicht gefragt/geantwortet)
- 2 verified Findings (vom unabhängigen Kalt-Prüfer, der Checks selbst ausführte): (1) Slice-3 zirkulär — Verify verlangt 5 PASS-Zeilen in out/verify.jsonl, läuft aber VOR Slice 4/5, besteht trivialsicher; Fix = Vollständigkeits-Check NACH Slice 5. (2) Slice-2-Verify beweist nichts — leeres plan.json bestand den Check (exit 0); Fix = Mindestzahl-Slices-Pflicht.
- Script: `.zcode/workflow-drafts/Workflow-Topologie-planen.dwf.ts` (Revision → Edit + AmendWorkflow mit `path`)
- Auftrag: aus 7 Skill-Anweisungen (caveman, loki-os-standard, workflow-run, wayfinder, gsd-core, executing-plans, visualize) Topologie + Slice-Plan + HTML-Visualisierung bauen

**Topologie (4 Subagenten, lineare Kette):** deterministisches `world.run("test", ["-f", …])`-Inventar → Landkarten-Zeichner (wayfinder/gsd-core) → Slice-Planer → Unabhängiger Prüfer (fresh eyes, OHNE Vorgeschichte, 1 Revisions-Loop falls `usable=false`) → Dashboard-Bauer (`out/topologie-workflow.html`, primary artifact) + 1 Repair-Agent im catch. Deliverable-Report mit verified/notCovered; workflow-run entfällt bewusst (Workspace ist kein Git-Repo).

**Lessons:**
1. **Skill-Tool akzeptiert NUR `skill` + `args`** — zwei Fehlversuche mit `skillaction`/`plan` bzw. `question` → InputValidationError. Für dynamic-workflows: `Skill(skill:"dynamic-workflows")` lädt den kompletten Authoring-Contract (§16 Facade: agent/ask/phase/report/artifact/world.run/hole).
2. **ZCode Free-Modell-Fallback produziert Müll:** Session fiel auf `liquid/lfm-2.5-2.6b:free` → `nemotron-3.5-lightning:free` und lieferte Nonsense-JSON („Dolce"-Payload statt Antwort). Nur Rückkehr auf GLM-5.3-Flash stellte die Arbeit wieder her — bei kaputter Session zuerst aktives Modell prüfen, nicht neu anfangen.
3. dynamic-workflows-Fassade erlaubt Subagents keine Absolut-Pfade (bestätigt [[plugin-skill-inventar-dwfrun-2026-10-09]]), `world.run` schon → Datei-Existenzchecks außerhalb des Workspace laufen als `world.run("test",["-f",pfad])`.
