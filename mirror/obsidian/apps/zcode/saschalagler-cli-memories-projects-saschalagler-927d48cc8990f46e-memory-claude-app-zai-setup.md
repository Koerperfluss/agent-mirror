---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/claude-app-zai-setup.md"
stand: 2026-10-29
tags: [spiegel, zcode]
---

---
name: claude-app-zai-setup
description: Claude.app = Claude Desktop (Chat, kein Umbau aufs ZCode-Abo
  möglich); Claude-Code-CLI-Config ~/.claude/settings.json ist BEREITS auf z.ai
  GLM umgestellt (Token = cline-pass-Key)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_3710694b-d1b2-4d51-bafa-02d30fb8bda5
---

Sascha will „Claude mit dem ZCode-Abo betreiben" (11.10.2026, Plan-Modus, Umsetzung wartet auf sein JA).

**Fakten (bewiesen):**
- `/Applications/Claude.app` = **Claude Desktop** (`com.anthropic.claudefordesktop`, v3.6556.2, Electron) — der CHAT-Client. Der braucht Anthropic-Login und lässt sich technisch NICHT auf das z.ai/GLM-Abo umbiegen. Das in 1 Satz sagen, nicht als Ampel-Liste.
- Claude **Code** (CLI) dagegen liest `~/.claude/settings.json` — und die ist **bereits fertig konfiguriert**: `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic`, `ANTHROPIC_AUTH_TOKEN=cb194f3f…UIwwAP` (**identisch mit dem cline-pass-Key** in `~/.cline/data/settings/providers.json`!), `ANTHROPIC_DEFAULT_HAIKU/OPUS/SONNET_MODEL=glm-5.3-flash[1m]`.
- **Stale-Eintrag:** `ANTHROPIC_MODEL` + `ANTHROPIC_DEFAULT_FABLE_MODEL` = `glm-first` — alter OmniRoute-Alias, auf dem direkten z.ai-Endpoint ungültig → Fix auf `glm-5.3-flash` (geplant, Backup `settings.json.bak-20261011` vorgesehen).

**Why:** Er fragte dreimal differently formuliert nach derselben Sache (AutoClaw, Cline, jetzt Claude) — immer dasselbe Muster: App soll sein GLM-Coding-Plan-Abo nutzen statt separatem Provider-Login.

**How to apply:** Bei „Claude geht nicht / 0 Credits" erst diese Datei lesen. Offener Umsetzungs-Rest: (1) z.ai-Anthropic-Endpoint curl-Test mit dem Key, (2) glm-first→glm-5.3-flash in settings.json (mit Backup), (3) Claude.app neustarten + Screenshot-Verifikation. Siehe [[cline-code-app-hub-1006-diagnosis]] + [[sascha-vollzug-keine-zwischenfragen]].
