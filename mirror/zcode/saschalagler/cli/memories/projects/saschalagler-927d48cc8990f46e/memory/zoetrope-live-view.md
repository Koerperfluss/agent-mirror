---
name: zoetrope-live-view
description: Zoetrope (zoe) 30.09. einsatzbereit gebrochen —
  Claude-Code-Sessions voll visualisierbar, ZCode-Format NICHT (0 Tool-Calls);
  Binary hieß zoe + war ungelinkt
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

Zoetrope (Session-Live-Flowgraph, Sascha wollte „alles sehen, wer welcher Agent wo was macht") — Stand 30.09.2026:

- **Installiert** via brew (furkankly/tap, v0.2.0), Binary heißt **`zoe`** (nicht `zoetrope`!) und war **ungelinkt** → 30.09. per `brew link zoetrope` aktiviert. Nutzen: `zoe` (live im Projektordner folgen), `zoe <file.jsonl|--id|dir>`, `zoe inspect <file>` (headless), `--provider claude|codex`.
- **Claude-Code-Sessions: voll funktional** — Agenten, Tool-Calls, Queues live/replay (Test: 120 Tool-Calls sichtbar). Codex-Format auch unterstützt.
- **ZCode-Sessions: NICHT wirklich lesbar** — `zoe` öffnet `~/.zcode/cli/rollout/model-io-sess_*.jsonl`, zeigt aber nur 1 Agent / 0 Tool-Calls (Format wird nicht geparst). ZCode-Arbeit live sehen → stattdessen ZCode-App → Automations/Run-Pane (Phasen-Graph + Live-Board).
- **Offen angeboten:** Konverter-Ticket ZCode-JSONL → Claude-Format (Sascha muss GO geben).

Verwandt: [[zcode-workflow-bedienung]], [[session-quellen-wo-finden]]
