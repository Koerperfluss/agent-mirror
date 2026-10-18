---
app: zcode
quelle: "saschalagler/skills/skillshare-sync/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: skillshare-sync
description: Sync Skills über alle AI-CLI-Tools (Claude Code, Codex, Cursor, OpenCode, OpenClaw u. v. m.) mit einem Befehl — zentrale Bibliothek + Symlinks, MCP-Sync, Security-Audit, Web-Dashboard. Quelle github.com/runkids/skillshare (CLI installiert: brew).
---

# Skillshare Sync

Quelle: github.com/runkids/skillshare (Go-CLI, ~2.5k Sterne). CLI installiert: `skillshare` (brew, v0.21.3).

## Konzept

Eine zentrale Skill-Bibliothek (z. B. `~/.config/skillshare/`) wird per **Symlink** in alle AI-Tool-Konfig-Ordner gespiegelt — ein Update überall wirksam. Plus: MCP-Sync, Plugin-Management, Prompt-Injection-Security-Audit, Web-Dashboard, projekt-scoped Skills via `.skillshare/`.

## Kernbefehle

| Befehl | Wirkung |
|---|---|
| `skillshare init` | Bibliothek + Targets initialisieren (erster Lauf, schreibt Konfigs) |
| `skillshare sync --all` | Alle Skills in alle registrierten Tools spiegeln |
| `skillshare sync mcp --dry-run` | MCP-Konfig-Sync vorher ansehen |
| `skillshare target claude --mode copy` | Target mit Copy statt Symlink |
| `skillshare ui` | Web-Dashboard öffnen |

## Ersteinrichtung (einmalig, mit Sascha-GO weil Konfigs geschrieben werden)

1. `skillshare init` — fragt nach den Tool-Ordner-Pfaden (z. B. `~/.claude/skills`, `~/.agents/skills`).
2. `skillshare sync --all` — Bestand verteilen.
3. Danach: neue Skills nur noch in die zentrale Bibliothek → `skillshare sync --all` → überall da.

## Sicherheit

- Vor dem Sync fremder Skills: Injection-Audit (`skillshare` bringt Security-Check mit) — SKILL.md-Inhalt lesen, verdächtige Befehle ablehnen.
- `--dry-run` zuerst bei jedem neuen Target.
