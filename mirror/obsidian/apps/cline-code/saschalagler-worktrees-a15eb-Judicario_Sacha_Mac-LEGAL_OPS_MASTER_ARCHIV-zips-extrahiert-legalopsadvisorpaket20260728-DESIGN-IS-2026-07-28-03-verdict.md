---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legalopsadvisorpaket20260728/DESIGN-IS-2026-07-28/03-verdict.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Verdict — Legal Ops Advisor `index.html`

**Total: 13/30. No principle scored 0, but the total falls far below the REFINE threshold (≥20) — verdict: REDESIGN.**

Scope note: this is a REDESIGN of the **copy, honesty, and token-discipline layer**, not the structural bones. Today's earlier rework fixed the real structural gap (persona switcher was dead code, now wired end-to-end and keyboard-accessible throughout) and that work holds up under this audit — Accessibility scored the keyboard/focus foundation as "excellent," and the persona-switcher wiring itself introduced zero new dead code. What fails this audit is a different layer: the interface tells the user things that aren't true (backend location, version number, internal engineering framing), and the visual/type system was never actually disciplined into a scale — it accreted values.

## Why REDESIGN and not REFINE

The rule is mechanical once the scorecard is written: total < 20 triggers REDESIGN regardless of how the failures are distributed. Three of the ten scores (#3 aesthetic, #4 understandable, #6 honest, #8 thorough, #9 environmentally friendly, #10 as little as possible — six, not three) sit at 1/3, each independently evidenced. #6 (honest) is the most consequential: a legal tool that mislabels where a user's case data was processed is not a cosmetic defect, it's a trust failure on the load-bearing dimension the whole product depends on.

## Top 5 highest-leverage moves

1. **#6 Honest** — Make the status indicator read the real `d.backend` field instead of hardcoding "[Cloud]," and resolve the v6.0/v7.0 contradiction before the System-Prompt modal ships that text to a user. Evidence: `index.html:779`; `index.html:815` + `prompts/legal_ops_omni.txt:1`.
2. **#4 Understandable** — Replace jargon-heavy persona taglines and pill labels (GdB, VwGVG, MRG, MDR, BLUF, "AT/DACH/EU") with plain-language equivalents; delete the "M4-Native // Polymath-Core" vanity subtitle that serves no user task. Evidence: `index.html:607,616,625,634,679-691,580,992`.
3. **#3 Aesthetic** — Collapse the 9-value type scale and 13-value spacing scale onto a small deliberate set of steps; remove the `--accent3` duplicate variable. Evidence: Visual subagent's spacing/type arrays in `01-evidence.md`.
4. **#10 As little design as possible** — Delete the 5 confirmed-dead CSS selectors (`.composer`, `.input-bar`, `.msg`, `#chat-input`, bare `footer`) and the 2 orphaned IDs (`watchdog-path`, `send-btn`) that no code reads. Evidence: `index.html:555-557,654,707`.
5. **#8/#9 Thorough / Environmentally friendly** — Add a real `disabled` state on send/upload during `isLoading`, replace the raw `alert()` upload-error with the same styled error pattern already used for chat errors, and wrap the two infinite pulsing dots in a `prefers-reduced-motion` guard. Evidence: `index.html:899,922,118-124`.
