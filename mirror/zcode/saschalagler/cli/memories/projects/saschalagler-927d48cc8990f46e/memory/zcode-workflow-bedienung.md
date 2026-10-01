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
- **Gotcha 01.10.: Draft-Pfad folgt dem CWD.** CreateWorkflow legt `.zcode/workflow-drafts/<name>.dwf.ts` RELATIV zum aktuellen Arbeitsverzeichnis ab — nach einem persistierten `cd` (z. B. typst-Compile im Projektordner) landete der Draft in `<Projektordner>/.zcode/workflow-drafts/` statt `~/.zcode/…`, und Edit sagte „File does not exist". Vor Edit/Amend: CWD prüfen oder per `find` lokalisieren; nach `cd` in Bash-Kommandos zurückwechseln.
- **Gate-Robustheit (01.10., md5-Gate-Silent-Fail):** world.run-Gate-Skripte müssen jede Datei-öffnen mit exists-Check absichern — eine Ausnahme = leere stdout = irreführendes „keine Ausgabe"; und Pfade-Konstanten, die in Builder-Ask UND Gate interpoliert werden, müssen einmal stimmen (Trailing-Space-Ordner: immer `$D/$file`-Muster). Der §14-Eskalations-Loop funktioniert hervorragend: der Bau-Subagent diagnostizierte meinen Skript-Bug per Eskalation exakt → AmendWorkflow-Fix → GRÜN.

Verwandt: [[loki-os-v18-endprodukt]], [[sascha-arbeitsregeln-hart]]
