---
name: skill-routing
description: Memory-basiertes Tool-Calling — erlernte Task→Skill-Zuordnungen; vor Skill-Wahl konsultieren, bewährte Mappings ergänzen.
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Skill-Routing läuft über die kanonische Datei `~/.agents/skill-routing.md` (alle Harnesses). Standard-Regeln (caveman + i-have-adhd Output-Stil, Routing-Tabelle, Verteilungs-Formel `skill_match*0.4 + history*0.3 + availability*0.2 + platform_fit*0.1`) stehen in `~/.agents/STANDARD-SKILLS.md` und werden über den projects.py-Hook in jede Session injiziert.

**Why:** Sascha will, dass Memory entscheidet, welcher Skill gerufen wird — nicht Rückfragen. Die Zuordnungen sollen mit der Nutzung wachsen.

**How to apply:** Vor der Skill-Wahl die Tabelle in `~/.agents/skill-routing.md` prüfen; nach bewährtem Einsatz neue Zeile eintragen. Skill-Sync über alle Harnesses: `~/.agents/tools/sync-standard-skills.sh`.

Bewährt im ZCode-Harness (getestet 22.08.2026): `superpowers:subagent-driven-development` läuft sauber (Implementer→Reviewer→Fix-Loop→Re-Review); ohne Git-Repo die Worktree/Commit-Schritte durch eine Ledger-Datei ersetzen. `i-have-adhd`-Output-Regeln (BLUF, Nummern, Tabellen, fett) in jeder Antwort anwenden.

---

**Stand 31.08.2026 — Vollständig deployed in allen 5 Harnesses:**

| Harness | Skills | Injection Mechanism |
|---|---|---|
| ZCode | 114 (symlinks) | `projects.py --hook` + `~/.zcode/cli/config.json` (mcp.servers=14) |
| Cline | 113 | `~/.cline/CLAUDE.md` (Marker-Block) + `cline_mcp_settings.json` (schlanke MCPs) |
| Antigravity | 46 | `~/.gemini/GEMINI.md` (Marker-Block) |
| Hermes (Ollama) | 122 | `~/.hermes/SOUL.md` (Marker-Block, wirkt next message) |
| Claude Code | 114 | `projects.py --hook` (geteilt mit ZCode) |
| Gemini CLI | 29+ | `~/.gemini/config/skills/` |

**Neue/aktualisierte kanonische Assets:**

- `~/.agents/STANDARD-SKILLS.md` — caveman + i-have-adhd always-on + Routing-Tabelle (16 Einträge)
- `~/.agents/tools/sync-standard-skills.sh` — idempotenter Sync in CLAUDE.md/GEMINI.md/SOUL.md
- `~/.agents/skill-routing.md` — erlernte Task→Skill Mappings (Tabelle mit 12 Einträgen)
- `~/.agents/tools/obsidian-sync.sh` + Skill `obsidian-vault-sync` — bidirektional Vault ↔ Cline Memory
- `~/.agents/skills/loki-memory-sync/` — Master-Skill, erfasst alle 8 Layer (Skills, Tools, Agents, Workflows, MCP, Plugins, Rules, Vault)
- **Skillshare v0.20.26** (Homebrew) — Source: `~/.agents/skills`, 9 Targets, `skillshare sync --all`

**Fixes applied 31.08.:**

- 4-skill drift behoben: `lokiomnidevteam-plan/execute`, `_sources` → `.zcode/skills`; `find-docs` → `.agents/skills`
- Cline Code: 5 schwere MCPs deaktiviert (firebase, firestore, gcs, graphos-tools, MCP_DOCKER) → Kontext ~50% kleiner
- Mimosa Security Scan läuft (jobId: scan-job-mthov0jy-587b7c0dabd85ee9, Phase: audit)

**Nächste Skills, die Memory lernen sollte:**
- `loki-memory-sync status/diff/sync/learn` — zentrale Steuerung
- `obsidian-vault-sync` — automatischer Vault-Sync
- `skillshare` — Sync-Befehl für alle Harnesses