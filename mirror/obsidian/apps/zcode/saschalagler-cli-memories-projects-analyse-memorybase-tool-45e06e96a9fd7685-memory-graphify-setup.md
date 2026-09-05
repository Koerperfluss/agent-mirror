---
app: zcode
quelle: "saschalagler/cli/memories/projects/analyse-memorybase-tool-45e06e96a9fd7685/memory/graphify-setup.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: graphify-setup
description: Graphify-Installation — PyPI-Paket heißt graphifyy (doppel-y),
  Skill liegt kanonisch in ~/.claude/skills/graphify, ZCode-Sichtbarkeit über
  Symlink-Kette
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_055615ab-ce73-42ee-8e97-3f339e12abb6
---

Graphify (Codebase → Knowledge Graph, [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify)) ist am 2026-08-23 installiert:

- **CLI:** `uv tool install "graphifyy[mcp]"` — PyPI-Name **graphifyy** (doppeltes y!), Executables `graphify` + `graphify-mcp` in `~/.local/bin`
- **Skill-Kanonik:** `graphify install` pflegt den Skill selbst nach `~/.claude/skills/graphify/` — NICHT verschieben, sonst brechen Updates
- **ZCode-Sichtbarkeit:** Symlink-Kette `~/.zcode/skills/graphify -> ../../.agents/skills/graphify -> ~/.claude/skills/graphify`
- **Nutzung:** `/graphify .` im Projekt → erzeugt `graphify-out/` (graph.html, GRAPH_REPORT.md, graph.json); MCP-Server optional: `python -m graphify.serve graphify-out/graph.json`
- **Side-Effect:** `graphify install` hat `~/.claude/CLAUDE.md` erstellt (Always-on-Hinweise)
- Updates: `uv tool upgrade graphifyy`, dann `graphify install` erneut laufen lassen

Gleicher Session-Kontext: sequential-thinking-MCP war bereits persistent in `~/.zcode/cli/config.json` (npx @modelcontextprotocol/server-sequential-thinking), verifiziert funktionierend. Skill-Reparatur-Standard: kanonisch `~/.agents/skills/`, Symlink in `~/.zcode/skills/` (siehe auch [[skill-symlink-muster]]).
