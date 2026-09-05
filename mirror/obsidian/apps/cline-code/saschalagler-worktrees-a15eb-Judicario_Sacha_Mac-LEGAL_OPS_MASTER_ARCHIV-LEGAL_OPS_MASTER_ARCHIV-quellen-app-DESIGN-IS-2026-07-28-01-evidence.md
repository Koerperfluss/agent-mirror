---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/DESIGN-IS-2026-07-28/01-evidence.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Evidence — Legal Ops Advisor `index.html`

Consolidated from 5 parallel evidence subagents. Every fact below is a subagent finding, not orchestrator opinion. All line numbers refer to the audited state of `index.html` at time of audit (post persona-switcher rework).

## Structural

- 16 static interactive elements (buttons/inputs/textarea) + 1 runtime-multiplied `.case-item` button template (`renderCases()`, ~line 850-868).
- Max nesting depth: 8 levels static (body→main→chat-window→welcome→welcome-card→prompt-pills→pill-btn→svg); 10 levels at runtime when an AI answer renders a markdown table (body→main→chat-window→message→persona-label→bubble→table→tbody→tr→td).
- Repeated patterns: `.persona-btn`×4 (601,610,619,628), `.pill-btn`×4 (677,681,685,689), `.persona-icon`×4, `.action-btn`×2 (703,707), `.prompt-btn`×2 (585,722), `.status-dot`×2 (592,652).
- **Dead CSS (confirmed via grep, targets elements that don't exist):** `.composer`, `.input-bar` (line 557), `.msg` (line 555, real class is `.message`), `#chat-input` (line 556, real id is `user-input`), `footer` tag selector (line 557, no `<footer>` exists, only `.sidebar-footer` div).
- Orphaned IDs (defined, never read by JS): `watchdog-path` (line 654), `send-btn` (line 707 — only used via inline `onclick`, never `getElementById`'d).
- No dead JS functions, no broken `getElementById` targets. `.persona-badge` cleanly fully removed (0 remnants) — the prior review's cleanup held.

## Visual (all INFERRED from source, no live render)

- Spacing scale: 13 distinct px values `[2,4,6,8,10,12,14,16,18,20,24,32,40]`.
- Type scale: 9 distinct px values `[10,11,12,12.5,13,13.5,14,16,24]` — includes fractional ad-hoc values (12.5, 13.5).
- Color count: 18 distinct values total — 10 unique in `:root` (`--accent3` is a byte-for-byte duplicate of `--accent2`, `#e2916a`) + 8 hardcoded outside `:root` not routed through a variable (`#8a3f22`, `#fff`, `#2a2b30`, `#3a3b42`, plus 3 inline `rgba(...)`).
- **Contrast — worst pair: white `#fff` text/icon on `--accent` `#d9784f` background = 3.11:1** — fails WCAG AA for normal text (4.5:1 required), passes only the large-text threshold (3:1). Used on `.send-btn` (line 497-501) and `.action-btn:hover` (line 494) — the primary "send message" control.
- States: empty ✓ (line 854, real message), loading ✓ (text-only, no spinner primitive), error ✓ but inconsistent (styled bubble error at line 935 vs. raw unstyled browser `alert()` for upload failures at line 899), success ✗ (no post-action confirmation anywhere in the file), focus ✓ but partial (3 selectors + search-box + textarea; not every interactive class covered), disabled ✗ (zero `:disabled`/`disabled` occurrences anywhere — send/upload stay visually active during `isLoading`).

## Copy & Honesty

- **"SUPREME GOD MODE"** (`prompts/legal_ops_omni.txt:1`) is shown verbatim to end users: it's the first line of the text rendered into `#modal-prompt-content` (index.html:815) when the user clicks the header's "System Prompt v6.0" button (line 585).
- **Version contradiction visible in one screen:** UI labels everywhere read "v6.0" (lines 6, 579, 587, 673, 720, 764) — the prompt text shown in that exact modal declares itself **v7.0** (`legal_ops_omni.txt:1`, and again at its closing line: "LEGAL-OPS-OMNI-ARCHITECT v7.0 betriebsbereit").
- **Backend location mislabeled:** `index.html:779` hardcodes `` `${d.model || 'gemini-2.5-flash'} [Cloud]` `` — the `[Cloud]` suffix is unconditional, never checks `d.backend`. Per `app.py`'s `/health` endpoint and `desktop_app.py`'s `BACKEND_MODE='auto'` default (local-first Ollama, Gemini fallback), the normal/default operating mode returns `backend: "ollama"` — meaning the UI tells the user their query went to "Cloud" even when it was answered 100% locally. For a tool whose own project docs state "OFFLINE = privat, nur Mac" as a core privacy promise, this is a direct, evidenced contradiction between claimed and actual data handling.
- No dark patterns found (no forced continuity, hidden cost, fake scarcity, confirmshaming) — actively checked, none present.
- Unexplained jargon in 7+ user-facing labels: "AT/DACH/EU" (607), "GdB … EStG §35, BBG, SGB IX" (616), "VwGH, VfGH, OGH, EuGH" (625), "MDR" (634), gesetzeskürzel in all 4 pill buttons (679-691), "BLUF" in rendered AI answers (992), "M4-Native // Polymath-Core" (580) — none decoded in-UI.
- Race condition: System-Prompt modal can show "Keine Prompt-Details gefunden" (817) if clicked before the async `/personas/detail` fetch resolves, despite the button unconditionally promising prompt transparency.

## Weight & Friction

- Inline JS: 11,929 bytes, one `<script>` block, zero external JS files — far under any reasonable budget.
- Initial requests: 1 Google Fonts stylesheet (10 font-weight variants referenced) + 4 `fetch()` calls on `DOMContentLoaded` (`/health`, `/db_stats`, `/cases`, `/personas/detail`) = 5 requests.
- None of the 4 fetches block interactivity — textarea has no `disabled` attribute, user can type/send before any fetch resolves.
- 2 active idle-screen animations: `.status-dot { animation: pulse 2s infinite }` applied to 2 elements present at first paint (header + sidebar footer) — both loop forever. `fadeUp` only fires on new chat messages, not present on idle screen.
- **`prefers-reduced-motion`: zero matches anywhere in the file.**
- 0 modals/badges/popups visible at initial load (`.modal-overlay` correctly defaults to `display:none`).

## Accessibility

- Contrast audit (29 pairs checked): only 1 clear failure — white on `--accent` (3.11:1, on the primary send/action buttons). Everything else passes AA; several pairs sit in a "PASS but tight" 4.69–5.04:1 band (`--muted` on `--bg3`, active-persona-button start-gradient text).
- Focus order: fully logical DOM/tab order, zero `tabindex` hacks needed or present.
- Keyboard reachability: **excellent** — every primary action (persona switch, case select, prompt pill, file attach, send, modal open/close-via-button) is a real `<button>`, natively focusable and Enter/Space-activatable. Enter-to-send also works.
- **One gap:** the modal's overlay-click-to-close (line 715) is a `<div onclick>` with no `tabindex`/`role`/keydown handler — mouse-only. No `Escape` handler exists anywhere in the document. The dedicated "Schließen" button remains keyboard-reachable, so this is a redundant-path gap, not a full lockout.
- ARIA: 3 implicit landmarks (`<header>`=banner, `<aside>`=complementary, `<main>`=main), **zero** explicit `role`/`aria-label` attributes anywhere in the document (icon-only buttons like upload/send rely on a `title` attribute at best, which has inconsistent screen-reader support).
- No skip-link present (confirmed via grep, 0 matches for "Skip to"/"Zum Inhalt").
