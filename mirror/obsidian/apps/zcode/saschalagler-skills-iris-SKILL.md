---
app: zcode
quelle: "saschalagler/skills/iris/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: iris
description: Screenshot live websites and web UIs with Chrome-family browsers. Gives AI coding agents eyes via MCP camera or CLI.
---

# Iris — Website & UI Camera Plugin (brijr/iris)

Iris gives coding agents visual feedback by taking high-fidelity screenshots of web applications, local dev servers, and live URLs using an installed Chrome-family browser (Chrome, Chromium, Brave, Edge).

- **Binary:** `/Users/saschalagler/.local/bin/iris` (version 0.4.1)
- **MCP Server:** `/Users/saschalagler/.local/bin/iris mcp`
- **Repo:** https://github.com/brijr/iris

## Usage Modes

### 1. CLI Mode
```bash
# Capture desktop view (1440x900 @2x)
iris http://localhost:3000 -o /tmp/preview.png

# Capture full-page dark mode
iris --full --dark https://example.com -o /tmp/full.png

# Capture specific component by selector
iris --selector "#hero" --padding 20 http://localhost:5173 -o /tmp/hero.png

# Mobile viewport (iPhone 390x844 @3x)
iris --size iphone http://localhost:3000 -o /tmp/mobile.png
```

### 2. MCP Mode
Iris runs as an MCP server via `iris mcp` and is configured in `~/.mcp.json`.
Provides visual inspection tools for agents to capture and verify UI changes before declaring a task complete.
