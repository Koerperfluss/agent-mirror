---
app: zcode
quelle: "saschalagler/skills/obsidian-second-brain/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: obsidian-second-brain
description: >
  Operate any Obsidian vault as a living, self-rewriting second brain (LLM Wiki pattern:
  sources rewrite pages, contradictions reconcile, scheduled agents maintain the vault).
  Use whenever the user asks to read, write, update, search, or manage their Obsidian
  vault - saving notes, daily entries, kanban boards, dev logs, people notes, decisions.
  Also triggers for bootstrapping a new vault, vault health checks, or scheduled vault
  maintenance. Full workflow details in the skill body.
---

# Obsidian Second Brain — KERN (Detail: references/full-manual.md)


# Obsidian Second Brain

> Claude operates your Obsidian vault as a self-rewriting knowledge base. An evolution of [Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): sources rewrite existing pages instead of just appending, contradictions reconcile automatically, and scheduled agents maintain the vault while you sleep.
> Everything worth remembering gets saved. Every update propagates everywhere it belongs.

---

## Quick Start

### 0. Choose vault access method (in order of preference)

Try these methods in order. Use the first one available:

**Method 0 - SessionStart hook (if configured):**
If `hooks/load_vault_context.py` is wired as a SessionStart hook in `~/.claude/settings.json`, `_CLAUDE.md` is injected into context automatically at session start. Skip step 1 below.
To wire it: `bash scripts/setup.sh "/path/to/vault"` or run `/obsidian-setup`.

**Method A - Direct filesystem (default, always works):**
Use standard file tools (Read, Write, Edit, Glob) against the vault path. The vault is plain markdown, so every operation in this skill works this way with no setup. This is the normal path in Claude Code - the commands below use these tools directly.

**Method B - MCP server (optional, mainly for non-Claude-Code clients):**
This repo ships its own MCP server at `integrations/obsidian-mcp-server/` that exposes the vault as tools (`obsidian_search`, `obsidian_read_note`, `obsidian_save_note`, `obsidian_capture`, plus curator tools). It exists so other MCP clients - Hermes Agent, Claude Desktop, Cursor - can use the vault as a knowledge layer; in Claude Code itself, Method A is simpler and preferred. If those `obsidian_*` tools happen to be available in your client, you may use them instead of raw file tools. Setup lives in `integrations/obsidian-mcp-server/README.md` (it is `uv run --with 'mcp<2' python .../server.py` with `OBSIDIAN_VAULT_PATH` set, not an `npx` package).

### 1. First time in a vault → read `_CLAUDE.md`

Before doing anything in a vault, check if `_CLAUDE.md` exists at the vault root and read it:

```
Read <vault>/_CLAUDE.md
```

If it exists: follow its rules exactly - they override the defaults in this skill. Where `_CLAUDE.md` is silent, fall back to the defaults below.
If it doesn't exist: use the defaults in this skill, then offer to create one.

If the SessionStart hook is active, `_CLAUDE.md` is already in context - skip this step.

### 2. First time with a new user → run discovery

```
Glob <vault>/**/*.md
```

Scan the structure to understand: folder names, template locations, naming conventions, frontmatter patterns. Then read 2-3 existing notes to calibrate writing style before creating anything new.

### 3. Bootstrap a new vault

If the user has no vault yet, run:
```bash
# One-line install + bootstrap (asks 3 questions: vault path, your name, preset)
curl -sL https://raw.githubusercontent.com/eugeniughelbur/obsidian-second-brain/main/scripts/quick-install.sh | bash

# Or manual:
python scripts/bootstrap_vault.py --path ~/path/to/vault --name "Your Name"

# With a preset:
python scripts/bootstrap_vault.py --path ~/my-vault --name "Your Name" --preset executive
python scripts/bootstrap_vault.py --path ~/my-vault --name "Your Name" --preset builder
python scripts/bootstrap_vault.py --path ~/my-vault --name "Your Name" --preset creator
python scripts/bootstrap_vault.py --path ~/my-vault --name "Your Name" --preset researcher

# With assistant mode (maintaining vault for someone else):
python scripts/bootstrap_vault.py --path ~/my-vault --name "Your Name" --mode assistant --subject "Boss Name"
```

Then just point the skill at the new vault path (Method A above). If you use the optional bundled MCP server, set `OBSIDIAN_VAULT_PATH` to the new path and restart the client.

**Presets** customize the vault for different use cases:
- **`executive`** - Decisions, people, meetings, strategic planning. Kanban: OKRs, Quarterly, Weekly.
- **`builder`** - Projects, dev logs, architecture decisions, debugging. Kanban: Backlog, Sprint, Done.
- **`creator`** - Content calendar, ideas pipeline, audience notes, publishing. Kanban: Ideas, Drafts, Published.
- **`researcher`** - Sources, literature notes, hypotheses, methodology. Kanban: Reading, Processing, Synthesized.

Default (no preset) gives a general-purpose vault. All presets use wiki-style by default.

**Assistant mode** creates a `_CLAUDE.md` configured for operating a vault on behalf of someone else. See `references/claude-md-assistant-template.md`.

See `references/vault-schema.md` for full structural details.

---



## Kernprinzipien (Kompakt — Ausformulierung im Full-Manual)
- AI-first vault rule (applies to every note)
- Never create in isolation
- Bi-temporal facts - never overwrite, always append
- CRITICAL_FACTS.md - always loaded
- Raw is immutable
- Maintain `index.md` and `log.md`
- Per-day operation logs (modernized vaults)
- The vault is a living system
- Two-Output Rule
- Synthesis Hook
- Reconciliation
- Proactive save reminders
- Search before creating
- Never claim absence from memory, never fabricate
- Match the vault's voice
- Frontmatter is mandatory

- AI-first: jede Note für Agenten lesbar; Frontmatter Pflicht; nie isoliert anlegen (backlinks + index.md/log.md pflegen).
- Bi-temporal: Fakten nie überschreiben, immer anhangsweise datieren; Raw ist immutable.
- Zwei-Output-Regel, Synthesis-Hook, Reconciliation, proaktive Save-Reminder, "Search before creating", niemals Abwesenheit aus Memory behaupten (Halluzinationsschutz).

## Common Operations (Kurzform)
Save-from-conversation · Daily note · Dev-Session-Log · Kanban-Update · Vault-Health-Check — exakte Abläufe: references/full-manual.md → "Common Operations".

## Commands (46 — Doku im Full-Manual)
- `/obsidian-save`
- `/obsidian-daily`
- `/obsidian-recurring`
- `/obsidian-log`
- `/obsidian-review`
- `/obsidian-health`
- `/obsidian-reindex`
- `/obsidian-reconcile`
- `/obsidian-synthesize`
- `/obsidian-export`
- `/obsidian-init`
- `/obsidian-architect`
- `/obsidian-ingest`
- `/obsidian-brainstorm`
- `/obsidian-challenge`
- `/obsidian-emerge`
- `/obsidian-graduate`
- `/obsidian-panel`
- `/idea-discovery`
- `/obsidian-world`

> Bei Bedarf: `references/full-manual.md` laden (78 KB, nur on-demand).
