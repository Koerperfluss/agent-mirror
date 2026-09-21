---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/zcode-workflow-bedienung.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: zcode-workflow-bedienung
description: Wo Sascha /workflow findet und Runs verfolgt (ZCode-UI) —
  Chat-Feld/Command-Palette, Automations-Ansicht, Live-Boards im Run-Pane;
  Historie per Agentenfrage
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_2879174a-220a-46e8-be58-79d65929bc01
---

ZCode-Workflow-Bedienung für Sascha (gefragt 21.09.2026 „wo ist /workflow"):

- **Starten:** `/workflow` + Auftrag direkt ins ZCode-Chat-Feld tippen ODER Command-Palette öffnen und „workflow" suchen (ruft den dynamic-workflows-Skill auf — dann baut der Agent das Subagenten-Team-Skript und CreateWorkflow startet nach Freigabe).
- **Laufende/finished Runs sehen:** ZCode-Seitenleiste → **Automations/Workflows**; während des Laufs erscheinen Live-Baustellen-Boards + Bericht-Karten direkt im Run-Pane.
- **Historie:** Frage den Agenten („zeig Workflow-Historie") → `ListWorkflowRuns` listet alle Runs des Projekts mit Status.
- Merksatz aus der Diagnose: Direkte Chat-Agenten sterben bei Turn-Interrupt (neue Nachricht mid-Turn), **Workflows laufen unabhängig weiter** — schwere Aufträge bevorzugt als Workflow.

Verwandt: [[loki-os-v18-endprodukt]], [[sascha-arbeitsregeln-hart]]
