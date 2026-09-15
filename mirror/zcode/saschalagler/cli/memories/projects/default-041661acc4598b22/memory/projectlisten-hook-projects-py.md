---
name: projectlisten-hook-projects-py
description: Wie die stehende Projektliste beim Session-Start funktioniert
  (~/.claude/tools/projects.py liest MEMORY.md "Weitere Projekte") + Chat-Store-
  Statistik aller Tools (ZCode 344, Cline 259, Claude 105 importiert) — 16.09.
  aktualisiert
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

**Die Projektliste („Oder ein neues Projekt erstellen?") im SessionStart-Hook** kommt aus `~/.claude/tools/projects.py --hook` (in `~/.zcode/cli/config.json` als SessionStart-Hook registriert).

Mechanik (16.09. durch Code-Lektüre geklärt):
- Quelldatei: `~/.claude/projects/-Users-saschalagler/memory/MEMORY.md`, Abschnitt `## Weitere Projekte` (Format `- [Titel](datei.md) — Hook-Text`)
- Aktivitäts-Datum: claude-mem.db-Volltextsuche ODER mtime der verlinkten Memory-Datei (ZCode-Sessions fließen nicht ein — Datum = Memory-mtime)
- Ändern = MEMORY.md bearbeiten (dort auch verlinkte .md-Dateien anlegen, sonst tote Links). 16.09. aktualisiert: GCP-Zeile neu + 4 neue Projekte (Vinyl-Scanner, SBP Patrick-Doc, Antigravity Physio-Assistent, iOS/WebDev-Stack 2026) + 4 Memory-Dateien angelegt.
- ⚠️ **Mimosa-Hook blockiert Bash-Schreibzugriffe auf Dateien** („Bash 直接写源码/安全配置会绕过 Write/Edit 安全扫描") → IMMER Edit/Write-Tool nutzen, auch für JSON/MD; Bash cp-Backups funktionieren je nach Pfad teils auch nicht.

**Chat-Store-Landkarte (16.09. gezählt):**
| Store | Ort | Umfang |
|---|---|---|
| ZCode Sessions | `~/.zcode/cli/db/db.sqlite` Tabelle `session` (project_id, title, time_created) | 344 Sessions |
| Importierte Chats | `~/.zcode/v2/sessions/*/cline-*.json` + `claude-import-*.json` | 259 Cline + 105 Claude |
| ZCode-App-Gruppen | `~/.zcode/v2/tasks-index.sqlite` (wirkt erst nach ⌘Q) | s. [[zcode-projektgruppen-mechanik]] |
| Antigravity | `~/Library/Application Support/Antigravity{, IDE}/User/globalStorage/state.vscdb`, Key `google.geminicodeassist` (Chat-Store, ~450 KB); `chat.ChatSessionStore.index` war leer | 2 Installationen |
| Cline-Originale | VS-Code globalStorage tasks | leer (alles im ZCode-Import) |

Verwandt: [[active-projects-focus]], [[gcloud-billing-fall-2026-09-15]].
