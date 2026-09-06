---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/zcode-setup-verified.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: zcode-setup-verified
description: ZCode/Cline-Setup 26.08.2026 live verifiziert — 14 MCP-Server, 16
  Plugins, Skill-Drift 112/110; Obsidian↔Cline Memory-Sync offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

Verifiziert 26.08.2026. Clines Audit-Bericht war mostly richtig, hatte aber 2 Fehler ("9 Plugins" → wirklich 16; "Skills identisch" → wirklich Drift):

- **MCP**: 14 Server in `~/.zcode/cli/config.json` → MCP_DOCKER (docker mcp gateway, profile ai_coding), context7, filesystem, desktop-commander, chrome-devtools, sequential-thinking, firebase, firestore, google-cloud-storage, google-workspace, graphos-tools, claude-mem, loki-voice, loki-legal-ops-mcp. Backup: `config.json.bak-mcp-20260822`.
- **Plugins**: 16 aktiv — context7, code-review, feature-dev, superpowers, commit-commands, playwright, github, ios-simulator, cloudbase-skills, agent-sdk-dev, agentforce-adlc, youdotcom-agent-skills, mimosa, zcode-cua, restore-legacy-sessions, example-plugin.
- **Skills**: 110 in `~/.zcode/skills/` vs 112 in `~/.agents/skills/` (Master). Drift: `lokiomnidevteam-plan`, `lokiomnidevteam-execute`, `_sources` nur in `.agents`; `find-docs` nur in `.zcode`. Fix wartet auf Saschas Go ("fix sync").
- **Cline-Workflow**: `~/.cline/workflows/04-skill-aware-task-distribution.md` (v1.0) integriert, alle 5 Pflicht-Skills vorhanden. Trigger `/skill-aware-task-distribution`; Score-Formel siehe [[skill-install-conventions]].
- **Wiki-Generator-Fehler (06.09.):** „当前选择的模型供应商不存在: builtin:zai-start-plan" = toter Provider-Name — Z.AI-Provider wurde in `builtin:zai-coding-plan` umbenannt (Log-Beweis 05.09.: session.model.updated start-plan→coding-plan), der Wiki-Dialog hält die Leiche gespeichert. Fix: im Wiki-Dialog Modell neu wählen → Generate. `~/.zcode/cli/db/db.sqlite` gehört der LAUFENDEN App — nie live reinschreiben.
- **Gate-Hooks (06.09.):** UserPromptSubmit-Hook `gate-enforcer.py` registriert (ZCode config.json, Cline hooks/settings.json, Claude settings.json) — Details [[loki-dev-gate-enforcement]]. Wirken erst nach App-Neustart.
- **Offen**: Obsidian↔Cline Memory-Sync — ZCode-Workspace-Memory überträgt NICHT automatisch zu Cline. Empfohlener Weg: Memory-Export als Markdown in `~/.agents/skills/_sources/` als ein Source of Truth (Alternative: obsidian-vault Skill).

- **sequential-thinking** (30.08. verifiziert): registriert in `~/.zcode/cli/config.json` (~Zeile 94, `/opt/homebrew/bin/npx @modelcontextprotocol/server-sequential-thinking`) und in `~/.mcp.json` — ein Symlink auf `~/.cline/data/settings/cline_mcp_settings.json`. Sascha hielt es irrtümlich für einen Skill und „sah nichts": kein UI, kein Skill-File — wirkt nur unsichtbar in Antworten (nummerierte Denkschritte).

**Why:** Zustand des Agent-Ökosystems; Cline-Zahlen nicht blind vertrauen — Config selbst zählen. **How to apply:** Bei Setup-/Status-Fragen zu ZCode/Cline diese Fakten als Ist-Stand nehmen und Drift-/Sync-Punkte als offene Todo anbieten.
