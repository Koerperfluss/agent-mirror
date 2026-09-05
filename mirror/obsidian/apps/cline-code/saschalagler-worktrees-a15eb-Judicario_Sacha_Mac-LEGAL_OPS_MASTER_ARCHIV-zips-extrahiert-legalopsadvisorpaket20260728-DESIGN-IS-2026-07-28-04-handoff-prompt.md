---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legalopsadvisorpaket20260728/DESIGN-IS-2026-07-28/04-handoff-prompt.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

/make-plan Redesign the copy, honesty, and token-discipline layer of the Legal Ops Advisor UI (`/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/index.html`). Current design failed a Dieter Rams audit at 13/30 with critical gaps in principles #3 (aesthetic), #4 (understandable), #6 (honest), #8 (thorough), #9 (environmentally friendly), #10 (as little design as possible).

Verdict paragraph (quoted from 03-verdict.md):
> Total: 13/30. No principle scored 0, but the total falls far below the REFINE threshold (≥20) — verdict: REDESIGN. This is a REDESIGN of the copy, honesty, and token-discipline layer, not the structural bones. Today's earlier rework fixed the real structural gap (persona switcher was dead code, now wired end-to-end and keyboard-accessible throughout) and that work holds up under this audit. What fails this audit is a different layer: the interface tells the user things that aren't true (backend location, version number, internal engineering framing), and the visual/type system was never actually disciplined into a scale — it accreted values.

Why redesign and not refine: total score (13/30) is well under the 20-point REFINE threshold, and the #6 honesty failures (backend-location mislabel, version contradiction, verbatim internal engineering language shown to users) are load-bearing for a tool that handles private legal case data — not cosmetic issues a targeted patch can wave away.

Preserve from current design (do not touch):
- Color tokens: `--bg:#101114`, `--bg2:#1a1b1f`, `--bg3:#202126`, `--accent:#d9784f`, `--accent2:#e2916a`, `--text:#eae7e2` (index.html:11-27) — the terracotta-on-charcoal brand direction is a deliberate, user-approved choice this session, keep it.
- Typography pairing: EB Garamond for headings, Inter for body, JetBrains Mono for code (index.html:8,15-16) — keep the pairing, only the numeric scale built on top of it needs discipline.
- Persona-switcher structure and wiring: the `#persona-list` markup (index.html:600-635), the `selectPersona()` function, and the `PERSONA_NAMES` map (index.html:764-771) — functionally correct and keyboard-accessible end-to-end per this audit's Accessibility evidence. Only the taglines' wording needs to change (jargon → plain language), not the structure or the click-to-switch mechanism.
- All native `<button>`-based interactive elements and the resulting keyboard/focus-order foundation (index.html: every `.persona-btn`, `.pill-btn`, `.case-item`, `.action-btn`) — Accessibility scored this "excellent," zero `tabindex` hacks, fully logical tab order. Any new elements must follow this same native-element pattern.

Discard (structural patterns causing the audit failures):
- Hardcoded `[Cloud]` suffix on the status text, unconditional regardless of actual backend. Evidence: `index.html:779` (`` `${d.model || 'gemini-2.5-flash'} [Cloud]` ``) vs. `app.py`'s real `/health` response and `desktop_app.py`'s local-first `BACKEND_MODE='auto'` default. Caused failure on principle #6.
- Verbatim exposure of internal engineering prompt language ("SUPREME GOD MODE," "ADHD COGNITIVE SCAFFOLDING," v7.0 self-declaration) through the System-Prompt modal without any editorial pass for the end user. Evidence: `prompts/legal_ops_omni.txt:1,10,45` rendered unchanged into `index.html:815`. Caused failure on principles #6 and #4.
- Ad-hoc, ungoverned type scale (9 values, including fractional 12.5px/13.5px) and spacing scale (13 values) with no defined step system. Evidence: Visual subagent arrays in `01-evidence.md`. Caused failure on principle #3.
- 5 dead CSS selectors targeting elements that no longer exist, left over from prior iterations: `.composer`, `.input-bar`, `.msg`, `#chat-input`, bare `footer` (index.html:555-557). Caused failure on principle #10.
- Total absence of `disabled` and `success` states, and a raw unstyled `alert()` for upload errors inconsistent with the styled chat-error pattern. Evidence: `index.html:899` (alert), `922` (isLoading flag with no visual gate), `935` (styled error, for comparison). Caused failure on principle #8.
- Two infinite-loop pulse animations (`index.html:118-124`) with zero `prefers-reduced-motion` support anywhere in the document. Caused failure on principle #9.

Top 5 moves from the audit (verbatim):
1. #6 Honest: Make the status indicator read the real `d.backend` field instead of hardcoding "[Cloud]," and resolve the v6.0/v7.0 contradiction before the System-Prompt modal ships that text to a user. Evidence: `index.html:779`; `index.html:815` + `prompts/legal_ops_omni.txt:1`.
2. #4 Understandable: Replace jargon-heavy persona taglines and pill labels (GdB, VwGVG, MRG, MDR, BLUF, "AT/DACH/EU") with plain-language equivalents; delete the "M4-Native // Polymath-Core" vanity subtitle. Evidence: `index.html:607,616,625,634,679-691,580,992`.
3. #3 Aesthetic: Collapse the type scale and spacing scale onto a small deliberate set of steps; remove the `--accent3` duplicate variable. Evidence: Visual subagent's spacing/type arrays.
4. #10 As little design as possible: Delete the 5 confirmed-dead CSS selectors and the 2 orphaned IDs (`watchdog-path`, `send-btn`) that no code reads. Evidence: `index.html:555-557,654,707`.
5. #8/#9 Thorough / Environmentally friendly: Add a real `disabled` state during `isLoading`, replace the raw upload-error `alert()` with the existing styled error pattern, and wrap the pulsing status dots in a `prefers-reduced-motion` guard. Evidence: `index.html:899,922,118-124`.

Redesign principles in priority order:
1. #6 Honest — every visible claim (backend location, version number, prompt content shown to the user) must map 1:1 to actual behavior; a legal-privacy tool cannot afford a trust gap here.
2. #4 Understandable — a first-time user (e.g. Thomas, testing the web version, who did not build this) must be able to name every control and label without decoding legal/technical acronyms.
3. #10 As little design as possible — every token, selector, and label must earn its place; remove what doesn't serve the task.

Deliverables for the plan:
- New information architecture: NOT derived from scratch — this keeps the current persona-switcher/case-archive/chat structure (see Preserve list) and redesigns only the copy and token layer on top of it.
- Primary flow re-walk (low-fi labeled, compared to current): pick module → ask question → get grounded answer, with every label along that path in plain language and every status claim verified true.
- States checklist to close: empty (already present), loading (already present, keep), error (unify styled pattern, remove `alert()`), success (new — add), focus (already present, keep), disabled (new — add).
- A defined type scale (propose ~6 steps) and spacing scale (propose ~6-8 steps) that the CSS should be re-expressed against, replacing the current 9- and 13-value ad-hoc sets.
- Migration path: this is a single static file with no user-facing "old version" to sunset — changes ship in place, no flag/toggle needed.
- Cutover criteria: re-run this same 5-subagent evidence audit after the fix; ship when total ≥ 20 and #6/#4 individually score ≥ 2.

Anti-patterns to guard against (specific to REDESIGN):
- Do not re-touch the persona-switcher structure, color tokens, or font pairing — those are Preserve items, already correct.
- Do not silently keep the `[Cloud]`/`[lokal]` labeling logic "for now" — this is the single highest-leverage honesty fix in the whole audit and must ship in this pass, not be deferred.
- Do not swap jargon for different jargon — verify each replacement label against what a first-time user (no legal background) would actually understand.
- Do not add new dependencies, a build step, or a framework to fix any of the above — this remains one static HTML file with inline CSS/JS, per the existing project constraint.
