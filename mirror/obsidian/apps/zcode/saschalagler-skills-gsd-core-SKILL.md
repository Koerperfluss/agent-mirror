---
app: zcode
quelle: "saschalagler/skills/gsd-core/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: gsd-core
description: Spec-driven development framework (Git. Ship. Done.). Enforces multi-phase workflows (Research -> Spec -> Plan -> Vertical Slice Execution), prevents context rot via isolated subtasks, and maintains continuous project rhythm.
---

# GSD Core (Git. Ship. Done.)

Framework for disciplined, spec-driven AI development. Prevents context degradation across complex tasks.

## Core Principles
1. **Zero Context Rot:** Split large tasks into fresh-context phases. Do not accumulate large, stale conversation buffers.
2. **Spec Before Code:** No code without a defined specification and clear acceptance criteria (DONE-WHEN).
3. **Vertical Slices:** Implement end-to-end vertical slices rather than horizontal layers.
4. **Ruthless Pruning (YAGNI):** Omit speculative architecture; build the exact minimal solution that passes validation.

## 4-Phase Pipeline
1. **Phase 1: Research (Explore & Map):**
   - Read relevant codebase paths, identify seams, verify APIs.
   - Document findings in `RESEARCH.md` or session scratchpad.
2. **Phase 2: Specification (RFC & Boundaries):**
   - Define inputs, outputs, data models, and edge cases.
   - Establish explicit validation criteria.
3. **Phase 3: Execution Plan (Task-Graph):**
   - Decompose into atomic sub-tasks (max 1-2 files per task).
   - Order by strict dependency order.
4. **Phase 4: Ship (Vertical Slice & Verify):**
   - Implement, run unit/integration tests, verify output, commit.
