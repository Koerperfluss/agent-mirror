---
app: zcode
quelle: "saschalagler/skills/roo-code/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: roo-code
description: Agent-based coding workflow with specialized execution modes (Code, Architect, Ask, Debug). Connects Antigravity with Cline SDK, ZCode, AutoClaw, and custom tool policies.
---

# Roo Code Workflow

Multi-mode autonomous coding system modeled after Roo Code / Roo Cline for high-speed IDE paired programming.

## Modes & Responsibilities
- **Architect Mode:** High-level system design, schema design, technology selection, and task decomposition. Read-only codebase inspection.
- **Code Mode:** Direct implementation specialist. Surgical edits (<=2 files), strict adherence to established architecture, instant syntax/lint check.
- **Ask Mode:** Explains architectures, traces dependencies, and clarifies requirements without mutating code.
- **Debug Mode:** Root-cause analysis, stack trace inspection, reproduction loops, and minimal verified patches.

## Mode Switching Rules
- Switch to **Architect** when the task alters system boundaries or interfaces.
- Switch to **Code** when executing concrete tickets from an existing plan.
- Switch to **Debug** when a test fails or an unexpected exception is thrown.
- Switch to **Ask** when clarifying ambiguity with the user.

## Tool & Policy Controls
- Always check `.clinerules` and local workspace policies before invoking shell commands or editing sensitive files.
- Integrate with local ZCode / AutoClaw runners via `@cline/sdk`.
