---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/zcode-sidebar-tasks-db-reparatur.md"
stand: 2026-10-12
tags: [spiegel, zcode]
---

---
name: zcode-sidebar-tasks-db-reparatur
description: ZCode-Sidebar-Liste = ~/.zcode/v2/tasks-index.sqlite; App-Bug
  „Session fehlt in History" ist reparierbar (Backup→INSERT), Rohdaten liegen
  immer in ~/.zcode/cli/rollout/
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_718ad065-3831-4520-a058-2fbc5d33e01c
---

**12.10.2026, live repariert:** Saschas 2 Atlas-Sessions (Workspace `~/Desktop/Coworkspace_Ich/atlas + pliability`) fehlten komplett in der Sidebar — App hat die Task-Registrierung nie in die DB geschrieben (Bug, tritt bei diesem Workspace auf; andere Sessions wurden indexiert). Datenverlust war keiner.

**Kartei der ZCode-App:**
- Sidebar-Liste = `~/.zcode/v2/tasks-index.sqlite` (Tables: `tasks`, `task_groups`, `task_group_members`; Sidebar gruppiert via task_group_members, „Project"-Toggle = chronologisch nach Workspace).
- Roh-Transcripts = `~/.zcode/cli/rollout/model-io-sess_<id>.jsonl` (eine Zeile pro Request, Assistant-Antworten stehen in den Folge-Requests; `grep -m1 'Primary working directory'` liefert den cwd der Session).
- task_id = sess_-ID; workspace_key = workspace_path (für `/` = `/`); task_status: running/completed/idle.

**Rezept bei „meine Session ist weg":** 1) rollout-Dateien von heute finden (`ls -lt`) und mit tasks-DB abgleichen (`sqlite3 'file:...?mode=ro' "SELECT task_id FROM tasks WHERE task_id IN (…)"`). 2) DB+wal+shm nach `~/.zcode/backups/` kopieren. 3) Zeile in `tasks` + `task_group_members` (z. B. Gruppe „atlas" `task-group-5e11bdfe-3412-433b-8914-a25d6bbcbb08`, sort_order max+100) per Parameter-Binding-INSERT nachziehen, meta_json nach Vorlage einer funktionierenden Zeile. 4) Verify per SELECT. 5) App-Neustart nötig — Sidebar liest beim Start neu (App nicht killen, laufender Chat stirbt mit). 6) Zusätzlich Konversation als Markdown extrahieren (Beweis für Sascha): `~/Desktop/ATLAS-SESSIONS-GERETTET/`, Backups `~/.zcode/backups/tasks-index-20261012-1650/`.

Sascha will **keine Gruppen-Liste**, sondern eine normale chronologische Verlaufsliste („chat nach chat hintereinander", neueste oben) — Project-Toggle nutzen; Gruppenansicht empfindet er als broken. Verwandt: [[sascha-wut-fehlerpaste]].
