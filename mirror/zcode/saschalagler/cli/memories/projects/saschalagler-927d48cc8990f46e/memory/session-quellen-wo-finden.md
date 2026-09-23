---
name: session-quellen-wo-finden
description: Wo ZCode-Session-Inhalte wirklich liegen — Log-Datei ist nur
  Telemetrie; User-Nachrichten/Ergebnisse stecken in Rollout-Transkripten und
  artifacts-Ordnern
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_20d78311-c154-4e1c-b35d-40b553625483
---

Beim Suchen von Session-Inhalten (23.09. gelernt):

- `~/.zcode/cli/log/zcode-YYYY-MM-DD.jsonl` = **Runtime-/Telemetrie-Log** (model.request, tool.call, MCP-Connects) — enthält KEINE User-Nachrichtentexte und keine Ergebnisberichte.
- User-Nachrichten + Assistant-Antworten liegen in **`~/.zcode/cli/rollout/model-io-sess_*.jsonl`** (können riesig sein, z. B. 1,3–1,4 GB) — Themen per grep auf User-Zeilen extrahieren.
- Tool-Result-Reste pro Session: **`~/.zcode/cli/artifacts/sess_*/`**.
- `.zcode-session`-Dateien wie vom Nutzer genannt existieren oft NICHT als Datei — dann sind nur artifacts/ + Rollout-Transkript vorhanden (z. B. PETER JUDICARIO-Ordner enthielt nur .build-Reste und Workflow-Artefakte, keine Fachinhalte).
- Für Handoff-Kapseln einfacher: ReadSessionContext (strategy=handoff) mit der sess-ID nutzen.

Verwandt: [[deja-vu-install]]
