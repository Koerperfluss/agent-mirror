---
name: zoetrope-live-view
description: Zoetrope (zoe) + zcode2zoe.py 30.09. GELÖST — ZCode-Sessions
  voll in zoe sichtbar (0→924 Tool-Calls bewiesen); jede Agent-Session eigene
  rollout-Datei; Grenze = Subagent-Knoten im EINEN Graph
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

Zoetrope (Session-Live-Flowgraph, Sascha: „alles sehen, wer welcher Agent wo was macht") — Stand 30.09.2026 Nacht, GELÖST:

- **zoe** (brew furkankly/tap v0.2.0, Binary `zoe`, per `brew link` aktiviert) liest Claude-Code-/Codex-Transkripte voll (Agenten, Tools, Queues).
- **`~/zcode2zoe.py` (v2) GEBAUT+BEWIESEN:** konvertiert ZCode-Rollout (`~/.zcode/cli/rollout/model-io-sess_*.jsonl` = Request/Response-Paare mit monoton wachsender History pro Zeile; response hat text/toolCalls[{id,name,input}], user-content = Block-Liste) → Claude-Transkript-JSONL nach `~/.claude/projects/zcode-converted/`. Beweis: 0→**924 Tool-Calls** sichtbar; Workflow-Actor einzeln: 68.
- **ZCode schreibt JEDE Agent-Session als eigene Datei:** `model-io-sess_dwf-<runId>-actor_N_M.jsonl` (Workflow-Subagenten, auch laufende!) + `model-io-sess_subagent_agent_<id>.jsonl` (Task-Subagenten). Agent-Finalberichte nur in `~/.zcode/cli/agents/<parent-sess>/<agentId>/output.txt` (kein Event-Log).
- **Grenze:** Subagent-Knoten im EINEN zoe-Graph noch nicht (zoe-Parser kennt isSidechain/SubagentMeta/agent_path — exakte Sidechain-Semantik ohne Source nicht repliziert; v2 merged 28 Sub-Dateien, zoe zeigt trotzdem 1 Agent). Workaround: Actor-Dateien einzeln konvertieren.
- Bedienung: `python3 ~/zcode2zoe.py <model-io-file>` dann `zoe <output> [--follow]`; Filter im Konverter: system-reminder/task-notification-Texte werden übersprungen.
- **`~/zoe-live` (bash, gebaut+getestet 30.09. Nacht) — EIN Befehl für alles:** `zoe-live cline` = neueste **Cline/Claude-Session NATIV** (kein Konverter; Saschas Abo-Output liegt im Claude-Format — bewiesen: 120 Tool-Calls sofort sichtbar) · `zoe-live` = ZCode-Haupt-Session konvertiert+live · `zoe-live runs` = neuesten Workflow-Run, alle Actor-Dateien konvertieren (getestet am Zotero-Run d0840988: 3 Subagents 22/29/33 Tool-Calls) · `zoe-live <datei>` = beliebig.
- **Sascha-Feedback (wichtig):** „was soll der Konverter, wenn ich in Cline arbeite — für was gab es das Abo?" → Cline zuerst/nativ nennen, ZCode-Konverter nur als Ergänzung für die ZCode-Workflows framen; Abo-Kosten sind ihm ein Thema.
- ZCode-Workflows (dwfrun) selbst sieht zoe nicht → ZCode-App Automations/Run-Pane (Phasen-Graph + Board) bleibt die Live-Übersicht dafür.

Verwandt: [[zcode-workflow-bedienung]], [[session-quellen-wo-finden]], [[koerperfluss-edu-foerderpilot-fertig]]
