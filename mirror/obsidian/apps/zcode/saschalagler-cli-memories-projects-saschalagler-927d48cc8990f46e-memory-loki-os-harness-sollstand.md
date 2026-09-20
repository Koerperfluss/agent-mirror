---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-harness-sollstand.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: loki-os-harness-sollstand
description: LOKI-OS-Harness Soll-Stand — 6 Schaltstellen in ~/.zcode
  (config/hooks, 17 MCP, 10 Agenten, 7 Commands, Sync-Quelle, 2 Wayfinder-Maps)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_e8798d40-41ac-4fb4-8725-69b28c7e7475
---

LOKI-OS-Harness Soll-Stand (gebaut 13.09.2026 in sess_6ec2db7a/sess_ecb2e5e0/sess_055615ab; verifiziert 20.09.2026):

1. **Config** `~/.zcode/cli/config.json`: valide (Crash-Ursache 06.09.–13.09. war leerer `matcher: ""`), Hooks SessionStart/PreToolUse/UserPromptSubmit — gate-enforcer, block-dangerous-git, config-health.py (Selbstcheck bei Start), fix-subagents.sh, projects.py + deja-Hooks (20.09. additiv).
2. **MCP:** 17 Server (16 original + deja seit 20.09.).
3. **Agenten** `~/.zcode/agents/` (10): cavecrew ×3, code-architect, explore (GLM-5.3), implementer, reviewer (qwen3.8-max via ClinePass), qa-tester, config-auditor, gate-enforcer-test (llama-70b via ClinePass). Bekannte Lücke: cavecrew ×3 ohne `model:`-Frontmatter → erscheinen evtl. nicht im Panel.
4. **Commands** `~/.zcode/commands/` (7): init, kanban, projects, standardskill, todo, feierabend, systemproof.
5. **Eine Quelle:** `~/.agents/STANDARD-SKILLS.md` → `~/.agents/tools/sync-standard-skills.sh` verteilt an 5 Harnesses (ZCode AGENTS.md, Claude CLAUDE.md, Cline, Gemini, Hermes).
6. **Orchestrierung:** loki-dev = 1 Pipeline, 5 Modi (INIT/BUILD/TAKEOVER/FINISH/MAP); 2 Wayfinder-Maps: `~/.agents/.wayfinder/map.md` (Skill-Konsolidierung, Tickets 10+11 offen) und `~/loki-ki/.wayfinder/map.md` (LOKI.OS Körperfluss-Automation, T-01…T-04).

Regel-Änderungen immer: 1× in STANDARD-SKILLS.md editieren + `bash ~/.agents/tools/sync-standard-skills.sh` — nie in die Kopien. Verwandt: [[deja-vu-install]].
