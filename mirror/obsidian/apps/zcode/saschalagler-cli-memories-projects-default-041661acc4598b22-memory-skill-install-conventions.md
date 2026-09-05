---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/skill-install-conventions.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: skill-install-conventions
description: Canonical skill install layout — skills live in
  ~/.agents/skills/<name>/, exposed to ZCode via relative symlink
  ~/.zcode/skills/<name>, registered in ~/.agents/skill-routing.md
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a4fac12a-8aa1-4ca6-abd4-c5a2048eb9e7
---

Sascha's cross-agent skill ecosystem (ZCode, Claude Code, Cline, Antigravity, Hermes):

- Canonical location: `~/.agents/skills/<name>/SKILL.md`
- Expose to ZCode: relative symlink `~/.zcode/skills/<name>` → `../../.agents/skills/<name>` (verified convention, e.g. cognee-memory, agent-browser)
- After a skill proves itself, add a signal→skill row to `~/.agents/skill-routing.md` (the canonical routing memory; routing formula: `score = skill_match*0.4 + performance_history*0.3 + availability*0.2 + platform_fit*0.1`)
- Team-style skills follow the `lokiomnidevteam-plan` pattern: single SKILL.md with persona IDs, pipeline stages, output-artifact template, skill-pairing section
- For external GitHub skills: `npx skills add <repo> --skill <name> -g -y` already writes to `~/.agents/skills/<name>/` and auto-creates the `~/.zcode/skills/<name>` relative symlink plus 50+ other agent dirs — no manual layout work needed, only PATH/CLI setup steps the SKILL.md requires
- Security practice for `npx skills add`: the skills.sh scanner prints risk ratings (e.g. Med Risk / Socket alerts); before endorsing, inspect locally (wrapper script, listen address, source readability) — see [[cdp-skill-browser-harness]]
- Drift observed 26.08.2026: `~/.agents/skills` (112) vs `~/.zcode/skills` (110) — `lokiomnidevteam-plan`, `lokiomnidevteam-execute`, `_sources` only in `.agents`; `find-docs` only in `.zcode`. Re-run a sync check when skills are added — see [[zcode-setup-verified]]

**Why:** creating skills anywhere else breaks the multi-agent sharing. **How to apply:** when asked to create a skill, write to `~/.agents/skills/<name>/`, symlink into `~/.zcode/skills/`, and update the routing table. See [[web-research-team-skill]] for an example.
