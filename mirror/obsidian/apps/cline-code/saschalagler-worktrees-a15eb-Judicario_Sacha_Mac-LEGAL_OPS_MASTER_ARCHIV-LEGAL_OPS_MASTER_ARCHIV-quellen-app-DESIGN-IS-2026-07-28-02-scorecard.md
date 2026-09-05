---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/DESIGN-IS-2026-07-28/02-scorecard.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Scorecard — Legal Ops Advisor `index.html` (Dieter Rams, 10 Principles)

Scoring rule applied throughout: worst representative instance, not average; ties broken toward the lower score.

```
1. Good design is innovative — Score: 1/3
   Evidence: 00-scope.md — visual language explicitly modeled on Chipsi/Judicario (user's own direction); persona-chat-archive layout is a standard legal-AI pattern.
   Justification: Imitates competitors with the one distinct element (GdB-Analyst focus) as minor variation — not a wholesale flow copy, but no advancement of the form either.

2. Good design makes a product useful — Score: 2/3
   Evidence: 01-evidence.md Structural (primary task = pick persona → type → send, no forced detours, all fetches non-blocking) vs. Accessibility (worst-instance contrast fail, 3.11:1, sits on the send/action buttons — the single most-used control in the whole app).
   Justification: The task path itself is short and unobstructed, but the load-bearing control for that path has a WCAG-failing icon contrast, which is a genuine usability defect on the critical path — one clear defect keeps this off a clean 3.

3. Good design is aesthetic — Score: 1/3
   Evidence: 01-evidence.md Visual — 9-value type scale with fractional outliers (12.5px, 13.5px), 13-value spacing scale, and a literal duplicate token (`--accent3` = `--accent2` byte-for-byte).
   Justification: Three distinct, independently-verifiable system inconsistencies from Visual evidence alone — matches the "3-5 inconsistencies" tier, not "≤2 minor."

4. Good design makes a product understandable — Score: 1/3
   Evidence: 01-evidence.md Copy & Honesty — 7+ unexplained jargon terms across persona taglines, pill labels, and rendered answers (GdB, VwGVG, MRG, MDR, BLUF, "AT/DACH/EU", "M4-Native // Polymath-Core"), none decoded in-UI.
   Justification: Far beyond "1 control needs a tooltip" — jargon is systemic across most of the labeling surface a first-time user (e.g. Thomas) would encounter.

5. Good design is unobtrusive — Score: 2/3
   Evidence: 01-evidence.md Weight & Friction — 2 status dots pulse `infinite` on every screen, forever, with zero `prefers-reduced-motion` gate.
   Justification: Chrome is generally quiet and recedes (decluttered header, calm sidebar) but one element never stops moving and can't be turned off — visible but not loud, not fully receded either.

6. Good design is honest — Score: 1/3
   Evidence: 01-evidence.md Copy & Honesty — hardcoded "[Cloud]" status label regardless of actual backend (index.html:779 vs. app.py's real local-first default), plus "SUPREME GOD MODE" shown verbatim, plus a live v6.0-vs-v7.0 contradiction in the same modal.
   Justification: 3 independent, verified mismatches between claim and behavior — for a tool handling private legal case data, the backend-location mislabel is load-bearing, not cosmetic. This is the lowest-confidence-inspiring finding in the whole audit.

7. Good design is long-lasting — Score: 2/3
   Evidence: 01-evidence.md Copy & Honesty — version number ("v6.0") and a specific model name ("gemma4:12b-it-qat") are baked directly into UI copy in multiple places.
   Justification: The visual language itself (dark terracotta/charcoal, serif headings) is not fad-driven and should age well; but two concrete markers (version string, model name) will visibly date the interface the moment either changes, which is foreseeable within months.

8. Good design is thorough down to the last detail — Score: 1/3
   Evidence: 01-evidence.md Visual states checklist — `success` state entirely absent, `disabled` state entirely absent (0 occurrences), `error` state present but inconsistent (styled bubble vs. raw browser `alert()`).
   Justification: 2 states fully missing plus 1 present-but-inconsistent — matches "2-3 states missing," not "1 missing/rough."

9. Good design is environmentally friendly — Score: 1/3
   Evidence: 01-evidence.md Weight & Friction — JS payload is 11.9KB (excellent, would earn a 3 alone), but 2 infinite-loop animations run unconditionally with zero `prefers-reduced-motion` support anywhere in the document.
   Justification: The rubric's top two tiers both require motion to be gated/respectful of reduced-motion; that condition fails completely regardless of the otherwise-excellent payload size, so score follows the motion failure, not the weight success.

10. Good design is as little design as possible — Score: 1/3
    Evidence: 01-evidence.md Structural — 5 confirmed dead CSS selectors targeting elements that don't exist (`.composer`, `.input-bar`, `.msg`, `#chat-input`, bare `footer`) plus 2 orphaned IDs never read by any code (`watchdog-path`, `send-btn`).
    Justification: 7 independently-grep-confirmed removable artifacts — solidly past the "≤2 removable" tier, landing in "3-5 removable" (tie-break keeps it here rather than escalating to 0, since the page is not dominated by decoration).
```

**Total: 13/30**
