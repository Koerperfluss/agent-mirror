---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legalopsadvisorpaket20260728/DESIGN-IS-2026-07-28/00-scope.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Scope — Legal Ops Advisor UI Audit (Dieter Rams)

**Audited surface:** `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/index.html` — the single static HTML/CSS/JS file that IS the entire UI, served identically by two surfaces:
- Desktop app (FastAPI `app.py`, `FileResponse` on `/`)
- Web version for Thomas (Firebase Hosting, `public: "."`)

Inferred as audit target from session context: this file was just reworked twice today (palette pass, then structural pass adding a persona-module switcher, header decluttering, chat persona-labels, empty states, focus rings) — the user did not name a different target when invoking `/claude-mem:design-is`.

**Primary user:** Sascha (solo operator) and case collaborators, using the app to ask Austrian/DACH/EU legal questions grounded in RIS case law, optionally against a specific case file, choosing one of 4 specialist personas (Legal-Ops-Omni, GdB-Analyst, VwGH-Researcher, Compliance-Architect).

**Primary task:** pick the right specialist module → ask a legal question (optionally attach a case document or reference an indexed case folder) → get a grounded, citation-backed answer.

**Constraints:**
- Single static HTML file, zero build step, zero framework, zero bundler — any recommendation must respect this.
- Must render identically as a PyWebView desktop window and as a plain browser tab.
- Dark-mode only (no light theme exists).
- Explicit brand direction from the user this session: visual language modeled on "Chipsi" and "Judicario" (competitor legal-tech tools) — terracotta accent (`--accent:#d9784f`) on warm charcoal (`--bg:#101114`), EB Garamond serif headings.

**Reference/competitor designs:** Chipsi (chipsi.openlaw.cc), Judicario — both referenced by the user as the aesthetic/functional bar this app is being compared against in an existing 3-way comparison dossier (published artifact, not part of this audit's surface).

**Input materials for this audit:** static source only (`index.html`, `app.py` for backend-contract facts referenced by the UI, `prompts/*.txt` for the persona copy already surfaced in-UI). No live browser session used — this is a single static file, so CSS-declared facts (spacing, type scale, color tokens, contrast pairs) are read directly from source rather than measured via a rendered DOM; marked INFERRED where relevant per the skill's static-repo fallback rule.

Design already exists and has had two real iteration passes today → **not** a NEW-design case. Proceeding to Phase 1.
