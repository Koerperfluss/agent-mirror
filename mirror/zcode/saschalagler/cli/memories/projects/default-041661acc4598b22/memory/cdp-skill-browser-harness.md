---
name: cdp-skill-browser-harness
description: cdp skill (browser-use/browser-harness-js) installed globally
  2026-08-23 — Chrome-via-CDP JS harness, CLI on /opt/homebrew/bin, REPL server
  on 127.0.0.1:9876, Sascha's Chrome CDP port is 9223
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a4fac12a-8aa1-4ca6-abd4-c5a2048eb9e7
---

Installed 2026-08-23 at Sascha's request via `npx skills add https://github.com/browser-use/browser-harness-js --skill cdp -g -y` → `~/.agents/skills/cdp/` (+ auto-symlink `~/.zcode/skills/cdp`).

- **What it does:** drives Chrome via DevTools Protocol from JS; `browser-harness-js '<JS>'` calls share one persistent Bun HTTP server holding a typed CDP `Session` (session, active target, globals survive across calls)
- **CLI:** symlinked to `/opt/homebrew/bin/browser-harness-js`; bun already present at `~/.bun/bin/bun`; server binds `127.0.0.1:9876` (localhost-only), spawns on first real call; control via `--status/--stop/--logs/--restart`
- **Sascha's Chrome CDP port is 9223** (agent-browser attaches there) — connect with `await session.connect({port:9223})`
- **Security:** skills.sh scanner rated Med Risk (1 Socket alert); locally verified clean (localhost-only bind, plain bash wrapper, readable TS source). Rated risky by nature (JS eval + browser control)
- Pairs with the browser layer of [[web-research-team-skill]] (ORCH-WEB) and `agent-browser`. Installed per [[skill-install-conventions]].
