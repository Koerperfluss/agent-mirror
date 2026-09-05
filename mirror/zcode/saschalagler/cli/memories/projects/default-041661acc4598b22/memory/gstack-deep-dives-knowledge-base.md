---
name: gstack-deep-dives-knowledge-base
description: Knowledge base + graphify graph of gstack skill patterns at
  ~/.agents/knowledge/gstack-deep-dives — query before building new skills
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_a4fac12a-8aa1-4ca6-abd4-c5a2048eb9e7
---

`~/.agents/knowledge/gstack-deep-dives/` holds the archived "gstack Skill Deep Dives" doc (10.2k words, `raw/2026-08-23-gstack-skill-deep-dives.md`) plus `GSTACK-PATTERN-ANALYSE.md` mapping 14 transferable patterns → adopted in [[web-research-team-skill]] v1.1, 7 already covered by own skills (learn≈cognee-memory, health≈multi-agent-status-check, plan/ship≈lokiomnidevteam, context-save≈handoff, gbrain≈cross-platform-knowledge-sync), 3 consciously rejected (cookie import via Keychain, auto-upgrade loops, gstack browser sidebar), 3 open ideas (agent-retro, careful/freeze guardrails, skillify pattern).

`graphify-out/` contains a queryable knowledge graph (90 nodes, 93 edges, 21 labeled communities, HTML viz `graph.html`). Query with: `cd ~/.agents/knowledge/gstack-deep-dives && graphify query "<question>"`. God node: web-research-team v1.1 bridges 6 communities. Before building any new skill, check the analysis tables there first (already covered? established pattern? conscious gap?).
