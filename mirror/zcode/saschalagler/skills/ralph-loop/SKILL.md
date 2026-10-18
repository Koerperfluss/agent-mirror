---
name: ralph-loop
description: Autonomous iterative execution engine. Continuously runs, evaluates, self-heals, and re-tests code in fresh sub-cycles until all exit criteria and tests are 100% green.
---

# Ralph Loop Engine

Autonomous iteration protocol: Repeat test -> diagnose -> patch -> verify until success or hard cap.

## Loop Algorithm
1. **Execute Target:** Run build/test command (e.g. `npm test`, `pytest`, `cargo test`, or custom test script).
2. **Evaluate Exit Code:**
   - If Exit Code == 0: **HALT SUCCESS**. Report green status with proof.
   - If Exit Code != 0: Enter Self-Healing cycle.
3. **Self-Healing Cycle:**
   - Extract raw stderr/traceback (exact failure line).
   - Formulate single minimal root-cause hypothesis.
   - Apply surgical patch (max 1-2 files).
   - Re-run test.
4. **Circuit Breaker (Hard Cap):**
   - Maximum 5 iterations per sub-task.
   - If 5 iterations fail, stop, document blocker in `STATUS.md`, and notify operator.

## Docker & Sandbox Execution
- Run execution inside Docker container (`MCP_DOCKER` or isolated sandbox) when dependencies or side-effects are unsafe.
