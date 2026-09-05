---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/gemini-api-stack.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: gemini-api-stack
description: "Gemini API Skills + Docs-MCP global auf dem Mac — wo sie liegen, warum der MCP 429 liefert, wie man nachzieht"
metadata: 
  node_type: memory
  type: project
  originSessionId: 839fd700-ffa8-46b6-ab4e-3751b025c453
  modified: 2026-08-05T11:19:54.320Z
---

Stand 2026-08-05. Vier Skills aus `github.com/google-gemini/gemini-skills` @47d75ca liegen kanonisch in `~/.agents/skills/` und sind von dort nach `~/.claude/skills/`, `~/.cline/skills/`, `~/.gemini/skills/` **symlinked**: `gemini-api-dev`, `gemini-live-api-dev`, `gemini-interactions-api`, `gemini-omni-flash-api`. Der vierte steht in Googles Doku-Seite nicht drin — nur im Repo.

**Der MCP-Server ist konfiguriert, aber tot.** `https://gemini-api-docs-mcp.dev` antwortet auf jedem Pfad (`/`, `/mcp`, `/sse`) mit **HTTP 429**, verifiziert per curl *und* per `gemini mcp list` (Status `Disconnected`, Discovery-Fehler HTTP 429). Das ist Googles Seite, nicht die Konfiguration. Eingetragen ist er in 8 Configs — `~/.mcp.json`, `~/.claude.json`, `~/.gemini/settings.json`, `~/.cursor/mcp.json`, `~/.cline/data/settings/cline_mcp_settings.json`, `~/Library/Application Support/Claude/claude_desktop_config.json`, `~/.config/antigravity/mcp_config.json`, `~/.gemini/config/mcp_config.json`. **Fallstrick:** die letzten beiden (Antigravity) nutzen `{"serverUrl": ...}`, alle anderen `{"type":"http","url":...}`. Solange der Server 429 liefert, greifen die Skills auf `https://ai.google.dev/gemini-api/docs/llms.txt` zurück (HTTP 200, geprüft).

**LOKI OS braucht keinen Extra-Eintrag** — `~/agent-os/agentos/discovery.py` scannt `~/.agents/skills`, `~/.claude/skills`, `~/.gemini/skills` und die drei MCP-Configs bereits selbst; `capabilities_map.json` baut sich neu, sobald sie älter als 24 h ist. Siehe [[agent-os]].

**Erwartetes Rauschen, kein Fehler:** Die Gemini CLI meldet beim Start `Skill conflict detected: "gemini-*" ... is overriding ...`, weil sie `~/.agents/skills` und `~/.gemini/skills` beide scannt und der Symlink dieselbe Datei zweimal zeigt.

Nachziehen mit `bash ~/agent-os/gemini-stack-sync.sh` (`--check` = Trockenlauf) — idempotent, holt Upstream, setzt Symlinks + alle 8 MCP-Einträge, baut die capabilities_map neu. Siehe [[loki-os]].

Nebenbefund beim Aufräumen: In `~/.gemini/config/mcp_config.json` steht ein **GitHub Personal Access Token im Klartext** (Eintrag `github-mcp-server`, `env.GITHUB_PERSONAL_ACCESS_TOKEN`) — rotieren und über eine Env-Variable statt der Config führen.
