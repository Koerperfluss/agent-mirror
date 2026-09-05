---
name: sequential-thinking-always
description: Stehende Regel — mcp sequentialthinking bei JEDER Anfrage aufrufen,
  auch bei simplen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_ec864b92-2403-44f6-8057-fd71047cea94
---

Sascha hat am 30.08.2026 entschieden: Das MCP-Tool `mcp__sequential-thinking__sequentialthinking` ist bei **JEDER Anfrage** aufzurufen — auch bei simplen Fragen (dort min. 1–3 Denkschritte), komplexe Aufgaben vollständig strukturiert.

**Why:** Ohne Tool wurde strukturiertes Denken inkonsistent angewendet (sein Vorwurf: „du planst diese Stufen nicht bei jeder Anfrage wie geplant"). Auslöser war ein Instagram-Post über „Sequential Thinking MCP" — er will das erzwungene, sichtbare Stufendenken immer. Er sagte auch: „pack alles ins Memory, mir egal wohin, hauptsache es geht."

**How to apply:** Erster Tool-Call pro Anfrage, vor Recherche/Antwort. Vollständig verankert (30.08.2026, verifiziert):
- Kanonisch: `~/.agents/STANDARD-SKILLS.md` Sektion A Punkt 3 + Zeile in `~/.agents/skill-routing.md`
- Sync auf alle 5 Harnesses via `~/.agents/tools/sync-standard-skills.sh` (Cline CLAUDE.md, Gemini GEMINI.md, Hermes SOUL.md; ZCode/Claude via projects.py-Hook — Hook-Test bestanden)
- Sichtbarer Skill: `~/.agents/skills/sequential-thinking/SKILL.md` + Symlink `~/.zcode/skills/sequential-thinking` (er konnte das Tool vorher nie „finden", weil es kein Skill war)
- Memory: ZCode-Memory + `## User-Präferenzen` in `~/.claude/projects/-Users-saschalagler/memory/MEMORY.md`
