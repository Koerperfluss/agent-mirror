---
name: obsidian-second-brain
description: "Obsidian-Vault als Second Brain — Skill installiert, Vault-Pfad, Setup-Stand"
metadata: 
  node_type: memory
  type: project
  originSessionId: 44670b3a-1b9f-4632-88e5-98536269cff0
---

Skill `obsidian-second-brain` (eugeniughelbur) installiert am 2026-07-10:
- Skill: `~/.claude/skills/obsidian-second-brain/` (Git-Clone, 44 Slash-Commands in `~/.claude/commands/`)
- Vault: `/Users/saschalagler/Documents/Obsidian Vault` (einziges Vault, via `OBSIDIAN_VAULT_PATH` in `~/.claude/settings.json`)
- SessionStart-Hook injiziert `_CLAUDE.md` aus dem Vault
- Background-Agent ist OPT-IN (aus); MCP-Server nicht eingerichtet (in Claude Code unnötig)
- Nächster Schritt nach Neustart: `/obsidian-init` erzeugt `_CLAUDE.md` im Vault

Am selben Tag installiert: Plugin `claude-mem` v13.10.2 (thedotmack) — Installer-Bug: `npm install --allow-scripts` schlägt mit EALLOWSCRIPTS fehl; Fix war manuelles `npm install --omit=dev --legacy-peer-deps` in `~/.claude/plugins/marketplaces/thedotmack`. Worker läuft (status: ready). Außerdem Skill `rc-code-review` (aus ZIP, umbenannt wegen Kollision mit eingebautem /code-review).
