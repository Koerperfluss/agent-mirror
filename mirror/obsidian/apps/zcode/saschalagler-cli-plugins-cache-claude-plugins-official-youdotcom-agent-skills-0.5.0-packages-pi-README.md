---
app: zcode
quelle: "saschalagler/cli/plugins/cache/claude-plugins-official/youdotcom-agent-skills/0.5.0/packages/pi/README.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# @youdotcom-oss/pi

You.com skills and MCP tools for Pi.

This package registers bundled You.com skills and bridges You.com remote MCP
tools into Pi for web search, content extraction, research, finance, docs
lookup, and guidance on adding You.com APIs, MCP, and SDKs to agentic projects.

## Install

```sh
pi install npm:@youdotcom-oss/pi
```

## What it includes

- Skills from `./skills`: `you-web`, `you-research`, `you-finance`,
  `you-discover`, and `you-free`
- Keyless `you-search` from the You.com free MCP profile
- Authenticated You.com MCP tools for content, research, and finance
- You.com Docs MCP tools for platform and API documentation

## Auth

- `you-free` and You.com Docs MCP do not require auth.
- Authenticated You.com MCP tools require `YDC_API_KEY`.

## Test

```sh
bun test
```
