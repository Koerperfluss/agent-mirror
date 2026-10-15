# sdk (cline-code)

Zuletzt gespiegelt: 2026-10-15 18:44 UTC

## worktree_dependency_hygiene

### Worktree Dependency Hygiene
 
When working in a git worktree, verify dependency links before running CLI repros,
tests, hooks, or commits. `node_modules` symlinks can accidentally point at
another checkout, causing mixed-source type errors or runtime behavior.
 
Quick check:
 
```sh
realpath node_modules packages/core/node_modules packages/core/node_modules/@cline/llms
```
 
All paths should stay under the current worktree. If any path points to another
checkout, remove the bad `node_modules` symlinks and run `bun install` from the
worktree root before trusting test or hook results.

## plugin

---
name: cline-plugin
description: Self-contained guide to designing, building, packaging, and distributing a plugin for any Cline-based agent (CLI, VS Code, Kanban, JetBrains, custom SDK hosts). Covers both single-file plugins and full plugin packages.
---

# Authoring a Cline Agent Plugin

A **Cline plugin** is a TypeScript module that extends any agent built on the Cline Core SDK. The same plugin runs in the Cline CLI, the VS Code and JetBrains extensions, the Kanban host, and any custom app built on `@cline/core` — write it once, every host gets the new behavior.

A plugin can:

- **Register tools** the model can call (the most common use).
- **Hook into the agent loop** before/after runs, model calls, and tool calls.
- **Rewrite provider messages** before they hit the model (custom compaction, redaction, context shaping).
- **Register slash commands**, **prompt rules**, **providers**, and **automation event types**.

A plugin ships in one of two shapes:

1. **Single-file plugin** — one `.ts` file that exports a default plugin object. Drop it in a discovery folder and it's loaded.
2. **Plugin package** — a directory with `package.json`, npm dependencies, and (optionally) bundled assets like markdown templates. Installable via `cline plugin install`.

Both shapes use the same plugin API. The package form just adds dependency management and asset bundling.

This guide is self-contained. By the end of it, you'll be able to build either kind from scratch.

---

## 1. The mental model

When the host starts a session, it builds a registry of plugins and runs four phases:

1. **resolve** — collect the plugin objects.
2. **validate** — check each plugin's `manifest`. Capabilities must be non-empty; declared hook stages must have matching handlers; if `hooks` is present, `"hooks"` must be in `capabilities`.
3. **setup** — call each plugin's `setup(api, ctx)` once. This is where you `registerTool`, `registerCommand`, etc.
4. **activate** — registry is frozen, the agent loop starts, and your hooks/tools are live.

Two invariants the registry enforces:

- **Every contribution requires a matching capability.** Calling `api.registerRule(...)` without `"rules"` in `manifest.capabilities` throws.
- **Capabilities and handlers must agree.** Declaring `"hooks"` without a `hooks` object, or vice versa, fails validation.

After validation, registration is one-shot — there's no dynamic register/unregister during the session.

---

## 2. The smallest working plugin

```ts
import type { AgentPlugin } from "@cline/core";
import { createTool } from "@cline/core";

const plugin: AgentPlugin = {
  name: "hello-plugin",                     // required, unique within a session
  manifest: {
    capabilities: ["tools"],                // declares what setup() will register
  },
  setup(api, ctx) {
    api.registerTool(
      createTool({
        name: "say_hello",
        description: "Greet a person by name.",
        inputSchema: {
          type: "object",
          properties: { name: { type: "string" } },
          required: ["name"],
        },
        async execute({ name }: { name: string }) {
          return { greeting: `Hello, ${name}!` };
        },
      }),
    );
  },
};

export default plugin;
```

That's a complete plugin. The agent will see `say_hello` as a callable tool.

---

## 3. The manifest

```ts
manifest: {
  capabilities: ["tools", "hooks"],   // required — non-empty array
  paths?: string[],                   // optional — multi-entry packages
  providerIds?: string[],             // optional — provider plugins
  modelIds?: string[],                // optional — model plugins
}
```

| Field          | When to use                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------- |
| `capabilities` | Always. Lists what the plugin contributes; gates the corresponding `api.register*` methods.             |
| `paths`        | Only inside a `package.json` `cline.plugins` entry — when one package exposes multiple plugin entry points. |
| `providerIds`  | When `capabilities` includes `"providers"` — declares which provider IDs you register.                  |
| `modelIds`     | When you contribute models tied to specific IDs.                                                        |

### The complete capability list

| Capability         | What it unlocks in `api`                                              |
| ------------------ | --------------------------------------------------------------------- |
| `tools`            | `api.registerTool()`                                                  |
| `commands`         | `api.registerCommand()` (slash commands in chat surfaces)             |
| `rules`            | `api.registerRule()` (string injected into the system prompt)         |
| `messageBuilders`  | `api.registerMessageBuilder()` (rewrites provider-bound messages)     |
| `providers`        | `api.registerProvider()` (e.g. a custom model provider)               |
| `automationEvents` | `api.registerAutomationEventType()` and `ctx.automation?.ingestEvent()` |
| `hooks`            | The runtime `hooks` object on the plugin (lifecycle callbacks)        |

You declare any combination — most real plugins need 1–3 capabilities.

---

## 4. `setup(api, ctx)` — the registration phase

`setup()` runs **once per session** before the agent loop starts. Everything you register here is frozen for the lifetime of the session.

### 4.1 The `api` object

