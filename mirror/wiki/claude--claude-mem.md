# claude-mem (claude)

Zuletzt gespiegelt: 2026-09-24 23:50 UTC

## anti-pattern-czar

# Anti-Pattern Czar

You are the **Anti-Pattern Czar**, an expert at identifying and fixing error handling anti-patterns.

## Your Mission

Help the user systematically fix error handling anti-patterns detected by the automated scanner.

## Process

1. **Run the detector:**
   ```bash
   bun run scripts/anti-pattern-test/detect-error-handling-antipatterns.ts
   ```

2. **Analyze the results:**
   - Count CRITICAL, HIGH, MEDIUM, and APPROVED_OVERRIDE issues
   - Prioritize CRITICAL issues on critical paths first
   - Group similar patterns together

3. **For each CRITICAL issue:**

   a. **Read the problematic code** using the Read tool

   b. **Explain the problem:**
      - Why is this dangerous?
      - What debugging nightmare could this cause?
      - What specific error is being swallowed?

   c. **Determine the right fix:**
      - **Option 1: Add proper logging** - If this is a real error that should be visible
      - **Option 2: Add [APPROVED OVERRIDE]** - If this is expected/documented behavior
      - **Option 3: Remove the try-catch entirely** - If the error should propagate
      - **Option 4: Add specific error type checking** - If only certain errors should be caught

   d. **Propose the fix** and ask for approval

   e. **Apply the fix** after approval

4. **Work through issues methodically:**
   - Fix one at a time
   - Re-run the detector after each batch of fixes
   - Track progress: "Fixed 3/28 critical issues"

## Guidelines for Approved Overrides

Only approve overrides when ALL of these are true:
- The error is **expected and frequent** (e.g., JSON parse on optional fields)
- Logging would create **too much noise** (high-frequency operations)
- There's **explicit recovery logic** (fallback value, retry, graceful degradation)
- The reason is **specific and technical** (not vague like "seems fine")

## Valid Override Examples:

✅ **GOOD:**
- "Expected JSON parse failures for optional data fields, too frequent to log"
- "Logger can't log its own failures, using stderr as last resort"
- "Health check port scan, expected connection failures on free port detection"
- "Git repo detection, expected failures when not in a git directory"

❌ **BAD:**
- "Error is not important" (why catch it then?)
- "Happens sometimes" (when? why?)
- "Works fine without logging" (works until it doesn't)
- "Optional" (optional errors still need visibility)

## Critical Path Rules

For files in the CRITICAL_PATHS list (SDKAgent.ts, GeminiAgent.ts, OpenRouterAgent.ts, SessionStore.ts, worker-service.ts):

- **NEVER** approve overrides on critical paths without exceptional justification
- Errors on critical paths MUST be visible (logged) or fatal (thrown)
- Catch-and-continue on critical paths is BANNED unless explicitly approved
- If in doubt, make it throw - fail loud, not silent

## Output Format

After each fix:
```
✅ Fixed: src/utils/example.ts:42
   Pattern: NO_LOGGING_IN_CATCH
   Solution: Added logger.error() with context

Progress: 3/28 critical issues remaining
```

After completing a batch:
```
🎯 Batch complete! Re-running detector...
[shows new results]
```

## Important

- **Read the code** before proposing fixes - understand what it's doing
- **Ask the user** if you're uncertain about the right approach
- **Don't blindly add overrides** - challenge each one
- **Prefer logging** over overrides when in doubt
- **Work incrementally** - small batches, frequent validation

## When Complete

Report final statistics:
```
🎉 Anti-pattern cleanup complete!

Before:
  🔴 CRITICAL: 28
  🟠 HIGH: 47
  🟡 MEDIUM: 76

After:
  🔴 CRITICAL: 0
  🟠 HIGH: 47
  🟡 MEDIUM: 76
  ⚪ APPROVED OVERRIDES: 15

All critical anti-patterns resolved!
```


## animated-installer

# Comprehensive Claude-Mem Installer with @clack/prompts

## Overview

Build a beautiful, animated CLI installer for claude-mem using `@clack/prompts` (v1.0.1). Distributable via `npx claude-mem-installer` and `curl -fsSL https://install.cmem.ai | bash`. Replaces the need for users to manually clone, build, configure settings, and start the worker.

**Worktree**: `feat/animated-installer` at `.claude/worktrees/animated-installer`

---

## Phase 0: Documentation & API Reference

### Allowed APIs (@clack/prompts v1.0.1, ESM-only)

| API | Signature | Use Case |
|-----|-----------|----------|
| `intro(title?)` | `void` | Opening banner |
| `outro(message?)` | `void` | Completion message |
| `cancel(message?)` | `void` | User cancelled |
| `isCancel(value)` | `boolean` | Check if user pressed Ctrl+C |
| `text(opts)` | `Promise<string \| symbol>` | API key input, port, data dir |
| `password(opts)` | `Promise<string \| symbol>` | API key input (masked) |
| `select(opts)` | `Promise<Value \| symbol>` | Provider, model, auth method |
| `multiselect(opts)` | `Promise<Value[] \| symbol>` | IDE selection, observation types |
| `confirm(opts)` | `Promise<boolean \| symbol>` | Enable Chroma, start worker |
| `spinner()` | `SpinnerResult` | Installing deps, building, starting worker |
| `progress(opts)` | `ProgressResult` | Multi-step installation progress |
| `tasks(tasks[])` | `Promise<void>` | Sequential install steps |
| `group(prompts, opts)` | `Promise<Results>` | Chain prompts with shared results |
| `note(message, title)` | `void` | Display settings summary, next steps |
| `log.info/success/warn/error(msg)` | `void` | Status messages |
| `box(message, title, opts)` | `void` | Welcome box, completion summary |

### Anti-Patterns
- Do NOT use `require()` — package is ESM-only
- Do NOT call prompts without TTY check first — hangs indefinitely in non-TTY
- Do NOT forget `isCancel()` check after every prompt (or use `group()` with `onCancel`)
- Do NOT use `chalk` — use `picocolors` (clack's dep) for consistency
- `text()` has no numeric mode — validate manually for port numbers
- `spinner.stop()` does not accept status codes — use `spinner.error()` for failures

### Distribution Patterns
- **npx**: `package.json` `bin` field → `"./dist/index.js"`, file needs `#!/usr/bin/env node`
- **curl|bash**: Shell bootstrap downloads JS, runs `node script.js` directly (preserves TTY)
- **esbuild**: Bundle to single ESM file, `platform: 'node'`, `banner` for shebang

### Key Source Files to Reference
- Settings defaults: `src/shared/SettingsDefaultsManager.ts` (lines 73-125)
- Settings validation: `src/services/server/SettingsRoutes.ts`
- Worker startup: `src/services/worker-service.ts` (lines 337-359)
- Health check: `src/services/infrastructure/HealthMonitor.ts`
- Plugin registration: `plugin/.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`
- Marketplace sync: `scripts/sync-marketplace.cjs`
- Cursor integration: `src/services/integrations/CursorHooksInstaller.ts`
- Existing OpenClaw installer: `install/public/openclaw.sh` (reference for logic, not code to copy)

---

## Phase 1: Project Scaffolding

**Goal**: Set up the installer package structure with build tooling.

### Tasks

1. **Create directory structure** in the worktree:
   ```
   installer/
   ├── src/
   │   ├── index.ts              # Entry point with TTY guard
   │   ├── steps/
   │   │   ├── welcome.ts        # intro + version check
   │   │   ├── dependencies.ts   # bun, uv, git checks
   │   │   ├── ide-selection.ts  # IDE picker + registration
   │   │   ├── provider.ts       # AI provider + API key
   │   │   ├── settings.ts       # Additional settings config
   │   │   ├── install.ts        # Clone, build, register plugin
   │   │   ├── worker.ts         # Start worker + health check
   │   │   └── complete.ts       # Summary + next steps
   │   └── utils/
   │       ├── system.ts         # OS detection, command runner
   │       ├── dependencies.ts   # bun/uv/git install helpers
   │       └── settings-writer.ts # Write ~/.claude-mem/settings.json
   ├── build.mjs                 # esbuild config
   ├── package.json              # bin, type: module, deps
   └── tsconfig.json
   ```

2. **Create `package.json`**:
   ```json
   {
     "name": "claude-mem-installer",
     "version": "1.0.0",
     "type": "module",
     "bin": { "claude-mem-installer": "./dist/index.js" },
     "files": ["dist"],
     "scripts": {
       "build": "node build.mjs",
       "dev": "node build.mjs && node dist/index.js"
     },
     "dependencies": {
       "@clack/prompts": "^1.0.1",
       "picocolors": "^1.1.1"
     },
     "devDependencies": {
       "esbuild": "^0.24.0",
       "typescript": "^5.7.0",
       "@types/node": "^22.0.0"
     },
     "engines": { "node": ">=18.0.0" }
   }
   ```

3. **Create `build.mjs`**:
   - esbuild bundle: `entryPoints: ['src/index.ts']`, `format: 'esm'`, `platform: 'node'`, `target: 'node18'`
   - Banner: `#!/usr/bin/env node`
   - Output: `dist/index.js`

4. **Create `tsconfig.json`**:
   - `module: "ESNext"`, `target: "ES2022"`, `moduleResolution: "bundler"`


## test-audit-2026-01-05

# Test Quality Audit Report

**Date**: 2026-01-05
**Auditor**: Claude Code (Opus 4.5)
**Methodology**: Deep analysis with focus on anti-pattern prevention, actual functionality testing, and regression prevention

---

## Executive Summary

**Total Test Files Audited**: 41
**Total Test Cases**: ~450+

### Score Distribution

| Score | Category | Count | Percentage |
|-------|----------|-------|------------|
| 5 | Essential | 8 | 19.5% |
| 4 | Valuable | 15 | 36.6% |
| 3 | Marginal | 11 | 26.8% |
| 2 | Weak | 5 | 12.2% |
| 1 | Delete | 2 | 4.9% |

### Key Findings

**Strengths**:
- SQLite database tests are exemplary - real database operations with proper setup/teardown
- Infrastructure tests (WMIC parsing, token calculator) use pure unit testing with no mocks
- Search strategy tests have comprehensive coverage of edge cases
- Logger formatTool tests are thorough and test actual transformation logic

**Critical Issues**:
- **context-builder.test.ts** has incomplete mocks that pollute the module cache, causing 81 test failures when run with the full suite
- Several tests verify mock behavior rather than actual functionality
- Type validation tests (export-types.test.ts) provide minimal value - TypeScript already validates types at compile time
- Some "validation" tests only verify code patterns exist, not that they work

**Recommendations**:
1. Fix or delete context-builder.test.ts - it actively harms the test suite
2. Delete trivial type validation tests that duplicate TypeScript compiler checks
3. Convert heavy-mock tests to integration tests where feasible
4. Add integration tests for critical paths (hook execution, worker API endpoints)

---

## Detailed Scores

### Score 5 - Essential (8 tests)

These tests catch real bugs, use minimal mocking, and test actual behavior.

| File | Test Count | Notes |
|------|------------|-------|
| `tests/sqlite/observations.test.ts` | 25+ | Real SQLite operations, in-memory DB, tests actual data persistence and retrieval |
| `tests/sqlite/sessions.test.ts` | 20+ | Real database CRUD operations, status transitions, relationship integrity |
| `tests/sqlite/transactions.test.ts` | 15+ | Critical transaction isolation tests, rollback behavior, error handling |
| `tests/context/token-calculator.test.ts` | 35+ | Pure unit tests, no mocks, tests actual token estimation algorithms |
| `tests/infrastructure/wmic-parsing.test.ts` | 20+ | Pure parsing logic tests, validates Windows process enumeration edge cases |
| `tests/utils/logger-format-tool.test.ts` | 56 | Comprehensive formatTool tests, validates JSON parsing, tool output formatting |
| `tests/server/server.test.ts` | 15+ | Real HTTP server integration tests, actual endpoint validation |
| `tests/cursor-hook-outputs.test.ts` | 12+ | Integration tests running actual hook scripts, validates real output |

**Why Essential**: These tests catch actual bugs before production. They test real behavior with minimal abstraction. The SQLite tests in particular are exemplary - they use an in-memory database but perform real SQL operations.

---

### Score 4 - Valuable (15 tests)

Good tests with acceptable mocking that still verify meaningful behavior.

| File | Test Count | Notes |
|------|------------|-------|
| `tests/sqlite/prompts.test.ts` | 15+ | Real DB operations for user prompts, timestamp handling |
| `tests/sqlite/summaries.test.ts` | 15+ | Real DB operations for session summaries |
| `tests/worker/search/search-orchestrator.test.ts` | 30+ | Comprehensive strategy selection logic, good edge case coverage |
| `tests/worker/search/strategies/sqlite-search-strategy.test.ts` | 25+ | Filter logic tests, date range handling |
| `tests/worker/search/strategies/hybrid-search-strategy.test.ts` | 20+ | Ranking preservation, merge logic |
| `tests/worker/search/strategies/chroma-search-strategy.test.ts` | 20+ | Vector search behavior, doc_type filtering |
| `tests/worker/search/result-formatter.test.ts` | 15+ | Output formatting validation |
| `tests/gemini_agent.test.ts` | 20+ | Multi-turn conversation flow, rate limiting fallback |
| `tests/infrastructure/health-monitor.test.ts` | 15+ | Health check logic, threshold validation |
| `tests/infrastructure/graceful-shutdown.test.ts` | 15+ | Shutdown sequence, timeout handling |
| `tests/infrastructure/process-manager.test.ts` | 12+ | Process lifecycle management |
| `tests/cursor-mcp-config.test.ts` | 10+ | MCP configuration generation validation |
| `tests/cursor-hooks-json-utils.test.ts` | 8+ | JSON parsing utilities |
| `tests/shared/settings-defaults-manager.test.ts` | 27 | Settings validation, migration logic |
| `tests/context/formatters/markdown-formatter.test.ts` | 15+ | Markdown generation, terminology consistency |

**Why Valuable**: These tests have some mocking but still verify important business logic. The search strategy tests are particularly good at testing the decision-making logic for query routing.

---

### Score 3 - Marginal (11 tests)

Tests with moderate value, often too much mocking or testing obvious behavior.

| File | Test Count | Issues |
|------|------------|--------|
| `tests/worker/agents/observation-broadcaster.test.ts` | 15+ | Heavy mocking of SSE workers, tests mock behavior more than actual broadcasting |
| `tests/worker/agents/fallback-error-handler.test.ts` | 10+ | Error message formatting tests, low complexity |
| `tests/worker/agents/session-cleanup-helper.test.ts` | 10+ | Cleanup logic with mocked dependencies |
| `tests/context/observation-compiler.test.ts` | 20+ | Mock database, tests query building not actual compilation |
| `tests/server/error-handler.test.ts` | 8+ | Mock Express response, tests formatting only |
| `tests/cursor-registry.test.ts` | 8+ | Registry pattern tests, low risk area |
| `tests/cursor-context-update.test.ts` | 5+ | File format validation, could be stricter |
| `tests/hook-constants.test.ts` | 5+ | Constant validation, low value |
| `tests/session_store.test.ts` | 10+ | In-memory store tests, straightforward logic |
| `tests/logger-coverage.test.ts` | 8+ | Coverage verification, not functionality |
| `tests/scripts/smart-install.test.ts` | 25+ | Path array tests, replicates rather than imports logic |

**Why Marginal**: These tests provide some regression protection but either mock too heavily or test low-risk areas. The smart-install tests notably replicate the path arrays from the source file rather than testing the actual module.

---

### Score 2 - Weak (5 tests)

Tests that mostly verify mocks work or provide little value.

| File | Test Count | Issues |
|------|------------|--------|

