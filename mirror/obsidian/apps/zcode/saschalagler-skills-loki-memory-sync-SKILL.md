---
app: zcode
quelle: "saschalagler/skills/loki-memory-sync/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: loki-memory-sync
description: Zentraler Memory-Layer: erfasst alle Skills, Tools, Agents, MCP-Server, Plugins, Workflows aus allen Harnesses (ZCode, Cline, Antigravity, Hermes, Gemini, Claude) in eine einheitliche, durchsuchbare Memory-Struktur. Läuft automatisch via skillshare sync + Hooks.
---
# LOKI Memory Sync — Master-Skill

**Ziel:** Jede Session, jedes Tool, jeder Agent hat Zugriff auf den *kompletten* Wissensstand: welche Skills existieren, welche MCP-Server laufen, welche Workflows definiert sind, welche Agenten-Pools aktiv sind.

## Quellen (kanonisch)

| Layer | Pfad | Inhalt |
|---|---|---|
| **Skills Master** | `~/.agents/skills/` | 113 Skills (alle Harnesses spiegeln via Symlinks) |
| **Agents** | `~/.agents/agents/` | Subagent-Definitionen (ZCode/Claude) |
| **Workflows** | `~/.cline/workflows/` | 6 Workflows (00-05) → auch als Skills |
| **MCP Config** | `~/.zcode/cli/config.json` + `~/.cline/data/settings/cline_mcp_settings.json` | 14 / 15 Server |
| **Plugins** | `~/.zcode/cli/config.json` → `plugins.enabledPlugins` | 16 aktiv |
| **Standard Rules** | `~/.agents/STANDARD-SKILLS.md` | caveman + i-have-adhd always-on + Routing-Tabelle |
| **Routing Memory** | `~/.agents/skill-routing.md` | Erlernte Task→Skill Mappings |
| **Obsidian Vault** | `$OBSIDIAN_VAULT_PATH` | _CLAUDE.md, Session-Notes, Vault-Skills |

## Automatische Aktualisierung

1. **skillshare sync** (alle 5 min via cron oder manuell) → spiegelt `~/.agents/skills` → alle Harnesses
2. **projects.py Hook** (SessionStart) → lädt STANDARD-SKILLS + skill-routing.md in Kontext
3. **Vault-Sync-Script** `~/.agents/tools/obsidian-sync.sh` → Vault ↔ Cline Memory bidirektional (ehem. obsidian-vault-sync, konsolidiert)
4. **ZCode Memory** → `~/.zcode/cli/memories/.../skill-routing.md` + MEMORY.md Index
5. **Hermes Memory** → `~/.hermes/memories/MEMORY.md` (§-Format)

## Nutzung

- **Explizit:** Skill `loki-memory-sync` laden → vollständiger Statusreport
- **Implicit:** Jeder Session-Start → Hook injiziert Standard-Rules + Routing
- **Query:** `grep` in `~/.agents/skill-routing.md` für erlernte Mappings
- **Update:** Neue Skill/Tool/Agent → in `~/.agents/skills` ablegen → `skillshare sync`

## Memory-Schema (für Agenten lesbar)

```
loki-memory/
├── skills/           # Index aller Skills (Name, Beschreibung, Harness-Verfügbarkeit)
├── tools/            # MCP-Server, CLI-Tools, APIs
├── agents/           # Subagent-Definitionen, Capability-Matrix
├── workflows/        # Cline 00-05 + Custom
├── plugins/          # ZCode Plugins + Status
├── routing/          # skill-routing.md (erlernte Task→Skill)
├── standard/         # STANDARD-SKILLS.md (always-on rules)
└── vault/            # Obsidian Sync Status + Notizen
```

## Befehle

| Befehl | Wirkung |
|---|---|
| `loki-memory-sync status` | Kompletter Statusreport (alle Layer) |
| `loki-memory-sync diff` | Drift zwischen Harnesses anzeigen |
| `loki-memory-sync sync` | skillshare sync + obsidian-sync + hook-reload |
| `loki-memory-sync learn "task → skill"` | Eintrag in skill-routing.md hinzufügen |

## Integration

- **ZCode:** `~/.zcode/skills/loki-memory-sync` (Symlink) + SessionStart Hook
- **Cline:** `~/.cline/skills/loki-memory-sync` + CLAUDE.md Marker
- **Antigravity:** `~/.gemini/skills/loki-memory-sync` + GEMINI.md Marker
- **Hermes:** `~/.hermes/skills/loki-memory-sync` + SOUL.md Marker
- **Gemini CLI:** `~/.gemini/config/skills/loki-memory-sync`
- **Claude:** `~/.claude/skills/loki-memory-sync` + projects.py Hook

## Sicherheit

- skillshare audit blockiert CRITICAL vor Sync
- Private Keys/API-Keys **niemals** in Skills/Memory ablegen (nur Env/Config)
- Strix-pentesting nur auf eigene Apps

## Portierte Residuen (2026-09-08, Quellen: obsidian-vault-sync, cross-platform-knowledge-sync — archiviert)
- Vault-Sync-Befehl: `~/.agents/tools/obsidian-sync.sh` (Vault: `~/Documents/Obsidian Vault` ↔ Cline Memory ↔ .agents/skills, idempotent).
- Session-Wissen Write-Targets: `~/LOKI_SESSION_CONTEXT.md` (Handoff), `~/loki-ki/docs/` (Audits/Doku), Vault-Inbox. Frontmatter-Template: `type`, `date`, `project` (YAML).

## Knowledge-Sync-Ablauf (vollständig portiert 11.09.2026 aus cross-platform-knowledge-sync)

1. **Detektieren:** Was ist High-Value-Wissen? (Troubleshooting-Lösung, Architektur-Entscheidung, Config-Pattern)
2. **Deduplizieren:** Vor jedem Write Ziel-Datei lesen — existiert das Wissen schon? (Grep auf Stichworte)
3. **Schreiben:** **Max. 3 Ziele pro Erkenntnis.** Wichtige Lösungen zusätzlich in claude-mem — prüfen, ob die Observation erfasst wurde.
4. **Konflikte:** Doku vs. Realität → **Realität gewinnt**, Doku korrigieren, Nutzer informieren.
5. **Bericht:** Tabelle was → wohin → warum.
