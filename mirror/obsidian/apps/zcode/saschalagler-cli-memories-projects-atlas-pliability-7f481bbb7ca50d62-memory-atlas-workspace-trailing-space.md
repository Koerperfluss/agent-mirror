---
app: zcode
quelle: "saschalagler/cli/memories/projects/atlas-pliability-7f481bbb7ca50d62/memory/atlas-workspace-trailing-space.md"
stand: 2026-10-12
tags: [spiegel, zcode]
---

---
name: atlas-workspace-trailing-space
description: Der echte Workspace-Ordner heißt „atlas + pliability " MIT
  Leerzeichen am Ende — Pfad ohne Leerzeichen existiert nicht
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a348175d-0af0-40df-bd42-9b7f174f5aa0
---

Der ATLAS-Workspace liegt unter `/Users/saschalagler/Desktop/Coworkspace_Ich/atlas + pliability ` — **mit trailing space** nach „pliability". Der Pfad OHNE das Leerzeichen existiert nicht. Die ZCode-Session selbst ist aber auf dem Phantom-Pfad (ohne Leerzeichen) verankert — darum schlagen ZCode-Workspace-Picker und Sandbox-`files.glob` fehl (EvalWorkflowSnippet findet 0 Dateien).

**App-Repo:** `<workspace>/ATLAS_MASTER/app` (atlas-v5 v5.0.0, React 19 + Vite 7 + Capacitor 8, Firebase atlas-v5.web.app, Git-Branch master).
**Verkaufshub:** `/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /TOOL-SAMMLUNG-VERKAUF/` (auch mit trailing space nach „PORJEKTE").

**How to apply:** Bei Datei-Zugriff IMMER den Pfad mit trailing space und in Anführungszeichen nutzen; Shell-`cd`/`git -C` mit quoted path. Rename auf `atlas-pliability` ist geplant, braucht aber User-GO (bricht laufende Sessions). Verwandt: [[shell-enoent-in-atlas-sessions]], [[session-context-isolation-confusion]].
