---
name: zcode-projektgruppen-mechanik
description: Wie ZCode die Chat-/Projektliste links speichert (SQLite), wie man
  Chats importiert (Claude/Cline) und warum Änderungen erst nach App-Neustart
  erscheinen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

ZCode-Desktop (dev.zcode.app) Chat-/Gruppenliste — Mechanik geklärt & genutzt 06.09.2026:

**Speicherorte**
- Task-Index: `~/.zcode/v2/tasks-index.sqlite` — Tabellen `tasks` (alle Chats), `task_groups` (Gruppen), `task_group_members` (Zuordnung, UNIQUE(workspace_key,task_id) = Move-Semantik), `task_group_view_node_orders` (REIHENFOLGE — ohne group-Zeile hier erscheint die Gruppe NICHT!)
- Session-Inhalte: `~/.zcode/v2/sessions/<sha256(workspacePath)[:12]>/<task_id>.json` (meta + messages)
- Workspace-Picker: `recentProjects` in `~/.zcode/v2/setting.json`

**Verhalten**
- Der Renderer cached die Gruppenliste im Speicher: externe SQL-Änderungen erscheinen erst nach App-NEUSTART (⌘Q). Cmd+R/View-Toggle laden die Liste NICHT neu. SQL-Writes überleben Renderer-Reloads.
- „Project"-Ansicht gruppiert automatisch nach workspace_path; „Group"-Ansicht nach task_groups.

**Chat-Import (Migration-Muster)**
- Claude: ZCode importiert selbst → task_id `claude-import-<24hex>`, migration_source `claudeCode`, traceId = Claude-sessionId, Quelle `~/.claude/projects/*/*.jsonl`. 06.09.: alle 79 Sessions importiert (Stand 31.08.-Import).
- Cline: `~/.cline/data/db/sessions.db` (session_id, prompt=Titel, workspace_root, messages_path→`<id>.messages.json`). Importer: `~/.zcode/v2/import-chats-loki.py` (259 Chats, source `clineCode`). Worktree-Pfade: GANZEN Pfad auf Projektnamen mappen, nicht nur Base (Base = Home!).

**Sicherung**
- Backup-Dump: `~/.zcode/v2/projekt-gruppen-backup.sql`; Restore: `~/Desktop/ZCODE-PROJEKTE-WIEDERHERSTELLEN.command` (nur bei geschlossenem ZCode). Backups: tasks-index.sqlite.bak-20260906-projects, setting.json.bak-20260906-projects.

**Gruppen-Layout (06.09. gesetzt):** LOKI.OS/Agent OS · atlas · Legal Ops + Loki Voice · Körperfluss 3D · TODO App · Förder-Landschaft · Paraletts 3D-Hub · Barbulls Website · Research & Verwaltung · ARCHIV — Altlasten.

Verwandt: [[loki-project-map]]
