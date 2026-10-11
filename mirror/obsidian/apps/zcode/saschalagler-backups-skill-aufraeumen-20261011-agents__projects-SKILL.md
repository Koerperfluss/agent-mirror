---
app: zcode
quelle: "saschalagler/backups/skill-aufraeumen-20261011/agents__projects/SKILL.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: projects
description: >
  Project orchestration hub. Scans Cline sessions + Kanban board, clusters
  conversations into projects, shows a terminal dashboard, lets you pick or
  create a project, starts Kanban tasks, and auto-generates plans + agent
  teams. Use when the user says "projects", "dashboard", "übersicht",
  "projekte", "was läuft", "kanban starten", or wants to start multi-agent work.
disable-model-invocation: true
---

# /projects — Project Orchestration Hub

Single entry point for all project work. Run at session start to see where
things stand and decide what to do next.

---

## Step 1 — Ensure Kanban is running

```bash
curl -s -m 2 http://127.0.0.1:3484/api/health >/dev/null 2>&1 || nohup kanban --no-open > /tmp/kanban.log 2>&1 &
sleep 2
curl -s http://127.0.0.1:3484/api/health >/dev/null 2>&1 || { echo "Kanban startet nicht — siehe /tmp/kanban.log"; exit 1; }
```

## Step 2 — Render the dashboard

```bash
python3 ~/.claude/skills/projects/scan.py
```

`scan.py` is the single source of truth: it scans all Kanban workspaces,
clusters Cline sessions into projects by keyword, and renders the terminal
dashboard. Do NOT duplicate its work inline.

## Step 3 — Offer the menu

```
Was willst du tun?
  1  Projekt fortsetzen (Session resume + Kanban task starten)
  2  Neues Projekt anlegen
  3  Neue Aufgabe in bestehendem Projekt
  4  Kanban im Browser öffnen
  5  Multi-Agent Work starten
```

Wait for the user to pick a number.

---

## Action 1 — Projekt fortsetzen

Ask: "Welches Projekt? (Nummer aus der Tabelle)"

1. Find the most recent session for that project (scan.py output has it).
2. Find any Kanban task linked to that project (keyword in title from board).
3. Present:

```
Projekt: <name>
Letzte Session: <id> (<date>) — "first prompt..."
Kanban Task: <task-id> <title> — <column>

Resume: cline resume --id <session-id>
Task starten: kanban task start --task-id <id> --project-path /Users/saschalagler
```

Ask: "Session resumen, Task starten, oder beides?" Execute if confirmed.

## Action 2 — Neues Projekt anlegen

### 2.1 Brainstorming + Grilling

Ask: "Was ist das Projekt? (1-2 Sätze)"

Run `/brainstorming` to sharpen the idea into a concept statement, then
`/grilling` to validate it. One question at a time, with recommended
answers. Stop when the user confirms shared understanding.

### 2.2 Ponytail gate

Run `/ponytail`. The ponytail skill applies the YAGNI ladder — don't
restate it here. Just invoke it and respect its verdict.

### 2.3 Obsidian vault entry

Create a project note:

```bash
cat > "/Users/saschalagler/Documents/Obsidian Vault/Projects/<slug>.md" << 'EOF'
---
type: project
date: <today>
tags: [project, <slug>]
ai-first: true
status: active
---
# <Project Name>
## For future Claude
<concept statement from brainstorming>
## Sessions
- (none yet)
## Kanban Tasks
- (none yet)
EOF
```

### 2.4 Kanban task

```bash
kanban task create \
  --title "<project>: <one-line task>" \
  --prompt "<full prompt from brainstorming>" \
  --project-path /Users/saschalagler \
  --agent-id cline
```

## Action 3 — Neue Aufgabe in bestehendem Projekt

1. Ask: "Welches Projekt? (Nummer)"
2. Ask: "Was ist die Aufgabe? (1-2 Sätze)"
3. Quick grilling — 2-3 questions max.
4. Run `/ponytail` — does this need to be a separate task?
5. Create:

```bash
kanban task create --title "<project>: <task>" --prompt "..." --project-path /Users/saschalagler --agent-id cline
```

6. Link dependencies if any: `kanban task link --task-id <new> --linked-task-id <existing> --project-path /Users/saschalagler`
7. Ask: "Multi-Agent Work starten?" — if yes, Action 5.

## Action 5 — Multi-Agent Work

1. Identify the task (Kanban task ID or description). Create if needed (Action 3).
2. Run `/to-tickets` to decompose into sub-tasks with blocking edges.
3. Create each sub-task as a Kanban task + link dependencies.
4. For each unblocked sub-task, spawn an agent:

```
spawn_agent(systemPrompt: "<role-specific prompt>", task: "<sub-task prompt + context>")
```

5. For dependent tasks, wait for the blocker to finish before spawning the next.
6. When all agents finish, run `/code-review` on the combined diff.
7. Update the Obsidian project note with a run summary.

## Action 2.5 — Repo-Infra (portiert 2026-09-08, Quelle: automated-project-onboarding — archiviert)
Bei „neues Projekt": (1) AGENTS.md anlegen, `.clinerules` als Symlink darauf. (2) SESSION_CONTEXT.md-Skelett. (3) MCP-Check gegen `~/.mcp.json`. (4) `kanban task create` für offene Punkte. (5) Audit-Regel F-2: NIEMALS das Home-Verzeichnis als Git-Root.
