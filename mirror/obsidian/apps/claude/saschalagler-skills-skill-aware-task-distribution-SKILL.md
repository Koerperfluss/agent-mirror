---
app: claude
quelle: "saschalagler/skills/skill-aware-task-distribution/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: skill-aware-task-distribution
description: Verteilt Aufgaben an den optimalen Agenten (direkt vs. Subagent vs. Kanban-Task) basierend auf Aufgabentyp. Aktivieren bei "verteile die Aufgabe", "task create", "welcher Agent", oder mehrteiligen Aufgaben.
---

# Skill-Aware Task Distribution — AUSFÜHRBAR (an reale Fähigkeiten angepasst)

## Reale Ausführungsoptionen auf diesem System

| Option | Wann | Wie |
|---|---|---|
| **Direkt selbst** | Default: < 5 Schritte oder kontextabhängig | Einfach ausführen |
| **Subagent (spawn_agent)** | Unabhängige Lese/Analyse-Tasks parallel | `spawn_agent` — ACHTUNG: Team-Teammates (team_spawn_teammate) brauchen gültige Cline-Auth; bei 401 → direkt selbst ausführen, nicht aufgeben |
| **Kanban-Task** | Aufgaben, die über die Session hinaus leben | `kanban task create --title ... --prompt ... --agent-id cline` (Server: `kanban --no-open --port 3484`) |

## Ablauf

1. **Klassifizieren:** Typ (Research/Code/DevOps/Doku), Größe (S/M/L), Abhängigkeiten.
2. **Verteilen:** S+klar → direkt · M/L+unabhängig → max 3 Subagenten parallel · persistiert → Kanban.
3. **Checkpoint:** Tabelle Task → Agent → Begründung → Dauer zeigen. Bei "Execute" loslegen.
4. **Nie:** An fiktive Agenten (Hermes/Gemini als Prozesse) verteilen — die laufen nicht als Dienste auf diesem System.
