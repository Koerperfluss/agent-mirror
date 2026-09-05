---
name: zai-coding-plan-limits
description: GLM Coding Plan has weekly + 5h credit caps even on paid tiers;
  parallel subagent fanout burns quota; [1310] = that cap. Z.AI MCP servers
  (web-search-prime, zread, vision) need explicit API key
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a4fac12a-8aa1-4ca6-abd4-c5a2048eb9e7
---

Sascha has a paid Z.AI AI Coding Plan (Pro) and believed it had no usage limits. Reality (confirmed via zcode.z.ai docs, 2026-08-30): new Coding Plans meter usage in **credits with weekly + 5-hour allowances** — the `[1310] Weekly/Monthly Limit Exhausted` errors from 2026-08-23/24 were exactly that cap (reset 2026-08-25 20:18). Dispatching 3 parallel research subagents (fanout) multiplies token burn and can exhaust a weekly quota fast — throttle fanout width near end of a quota window.

Related pitfalls seen in the same logs: (1) model name `glm‑coding‑5.3` written with Unicode non-breaking hyphens (U+2011) → provider 404; always ASCII hyphens. (2) `[402]` OpenRouter credit errors come from the OmniRoute fallback chain, not the Z.AI plan. (3) "ascii codec can't encode \xfc" = Clash/V2Ray SOCKS proxy + non-ASCII chars — use an HTTP proxy port for agent gateways.

Integration done 2026-08-30: added `web-search-prime`, `zread`, `zai-vision` MCP servers to `~/.mcp.json` (→ real target `~/.cline/data/settings/cline_mcp_settings.json`) with `YOUR_ZAI_API_KEY` placeholders — Sascha must replace the placeholder with his key from https://z.ai/manage-apikey/apikey-list (one find-replace, 3 occurrences). vision MCP fixes the "selected model does not support image input" screenshot-reading gap. Also: gstack + plan-tune were already installed at `~/.claude/skills/` (~/.gstack data dir); source clones go to `~/src/`. See [[web-research-team-skill]].
