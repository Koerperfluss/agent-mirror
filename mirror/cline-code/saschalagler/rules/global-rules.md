# Cline Global Rules

## Rule 1: Skill Auto-Discovery

Cline MUSS bei Session-Start alle Skills aus `~/.cline/skills/` scannen.
Jedes Verzeichnis/Symlink das eine `SKILL.md` enthält ist ein verfügbarer Skill.
Skills werden automatisch aktiviert wenn die aktuelle Task ihren use-case trifft.
Kein manueller `/skill` Aufruf nötig — Cline erkennt den Kontext selbst.

## Rule 2: Context Preservation

Bevor eine Session endet:
- Speichere wichtige Entscheidungen und Fortschritt in der relevanten Projekt-Datei
- Aktualisiere `~/.cline/workflows/STATUS.md` bei Statusänderungen
- Hinterlasse Hinweise für die nächste Session (was offen ist, was als nächstes)

## Rule 3: Multi-Agent Awareness

Cline ist NICHT allein. Bei komplexen Tasks:
- Prüfe ob ein anderer Agent (Hermes, Gemini, Claude Code) besser geeignet ist
- Nutze Memory-Layer (claude-mem, agentmemory) für persistentes Wissen
- Teile Ergebnisse über `~/.agents/skills/` mit anderen Agenten

## Rule 4: MCP Fallback

Wenn ein MCP-Server nicht erreichbar ist:
- Meldung an Nutzer, aber Session NICHT abbrechen
- Alternative Tools verwenden wenn möglich
- automatischen Retry nach 60 Sekunden versuchen

## Rule 5: Project Safety

- NIEMALS ohne Bestätigung löschen wenn es Projekt-Code betrifft
- IMMER Backup vor massiven Refactors (git commit oder Dateikopie)
- ~/.cline/rules/ überschreibt project-level .clinerules bei Konflikten
