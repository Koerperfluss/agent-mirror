---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/browser-use/0.1.0/docs/overview.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# Built-in Browser Automation API

The browser registry understands backend types `iab`, `extension`, and `cdp`. Playwright is a `Tab` API surface, not a backend. The desktop host normally advertises `iab`, while ZCode CLI can explicitly advertise a managed headless Chromium as `cdp`. Never treat an unadvertised backend as available.

Start from the Codex object model and read the selected browser's complete effective documentation once:

```js
const browser = await agent.browsers.get("iab");
nodeRepl.write(await browser.documentation());
const tab = (await browser.tabs.selected()) ?? (await browser.tabs.new());
await tab.goto("https://example.com");
await tab.playwright.domSnapshot();
```

For a CLI started with `--browser-use=headless`, select the advertised `cdp` backend (or use
`getForUrl(url)`). Headless is its launch/display mode, not a fourth backend type.

Keep the DOM observation as the final expression so the model receives it. Assigning it to a variable without returning or writing it does not surface the page state.

High-level methods return their payload directly. Actions return `undefined` on success. If a command fails, the method throws `BrowserCommandError`.

`playwright.domSnapshot()` is the default observation and locator ground truth. It returns the Codex-compatible compact AI/ARIA tree rather than page `outerHTML`.

## API use behavior

- Reuse the selected browser binding across REPL calls. Before each new logical tab operation batch, call
  `tabs.list()` in a dedicated JS cell and return the complete result to the model. After inspecting it, use the next JS
  call to match the intended id/url/title and call `tabs.get(id)`; do not trust an old Tab binding when several tabs may
  exist. Continuous actions in the same JS cell may reuse the just-validated Tab.
- App-provided in-app-browser context is ambient UI state, not a browser-selection instruction. When it identifies a
  visible page, recover it from controlled tabs first, then user tabs; do not create a duplicate page before checking both.
- Base every interaction on visible page state, not DOM source order. After an action, collect the cheapest observation
  that answers the next question; do not take a snapshot and screenshot together by default.
- If the tab is already at the intended URL, do not call `goto()` again. Use `reload()` only when a refresh is required.
- For a read-only lookup, one focused direct URL derived from verified facts is acceptable. If that attempt fails or
  cannot be verified, do not loop over guessed URL variants, query grids, path names, or numeric resource IDs. Switch to
  the site's visible search/navigation or a purpose-built connector/API/CLI. Once one authoritative candidate exists,
  verify it directly instead of collecting more candidates.
- Minimize interruptions. For an underspecified but safe request, try the best evidence-backed path before asking a
  clarifying question.

Available entry points:

- `await agent.browsers.list()` returns runtime descriptors (`id`, `type`, capabilities, metadata) from the host registry. Connection generation remains an internal stale-routing guard.
- `await agent.browsers.get(idOrType)`, `getDefault()`, and `getForUrl(url)` return a `Browser`; an explicit unavailable selection fails instead of silently switching backend.
- `browser.tabs.list()` returns `TabInfo[]` for all controlled tabs, including the current `active` marker and actual
  CSS `viewport: { width, height }`. Inspect the whole list and match by stable id or verified URL/title; never select a
  multi-tab target by array position.
- `browser.tabs.selected()` returns the active tab when known.
- `browser.tabs.get(tabId)` validates, binds, and activates a tab in its owning window/workspace/session scope. The
  renderer shows it only if that scope is currently foreground; background sessions never steal the user's current UI.
- `browser.tabs.new()` creates a real IAB tab and returns only after its guest ready acknowledgement.
- `browser.user.openTabs()` lists user tabs without granting control; call `browser.user.claimTab(tab)` explicitly before using one.
- Browser tabs persist across turns for the lifetime of the current ZCode process. `tabs.finalize({ keep })` marks
  only listed tabs as `handoff` or `deliverable`; unlisted tabs remain open. Only `tab.close()`, a user close, window
  close, or process exit removes a tab.
- Creating an IAB tab automatically opens the right pane and activates that tab so the user can see browser use in progress.
- Use `await (await browser.capabilities.get("visibility")).set(false | true)` only when the task explicitly needs to hide or show the pane again.
- `agent.documentation.get("screenshots")` loads screenshot guidance only when visual evidence is actually required.

Core `Tab` methods:

- `id`, `url()`, `title()`
- `goto(url)`
- `back()`, `forward()`, `reload()`, `close()`
- `screenshot(opts?)`
- `setViewportSize({ width, height })`, `viewportSize()` — Playwright-compatible responsive viewport control. IAB
  automatically opens the target tab in free-size mode. Width must be 320–3840 and height 320–2160; invalid input
  fails instead of being clamped.
- `getJsDialog()`
- `markDeliverable()`, `markHandoff()`
- `capabilities`, `cua`, `dom_cua`, `playwright`

Escape hatches:

- `tab.cua` is the coordinate path for canvas and custom-drawn controls.
- `tab.dom_cua` is the node path where `node_id` equals the snapshot `ref`.
- `cua.drag({ path, keys? })` preserves every supplied point. `cua.scroll({ x, y, scrollX, scrollY,
keypress? })` scrolls from the supplied viewport anchor. `dom_cua.scroll({ node_id?, x, y })` uses `x/y`
  as deltas and scrolls from the node center or, without a node, the viewport center.
- CUA and DOM CUA `keypress({ keys })` treat keys as one combination, not a sequence of independent presses.
  IAB does not expose CUA/DOM CUA `downloadMedia`; use a snapshot-proven Playwright locator's
  `downloadMedia()` when the selected element exposes a downloadable media/link URL.
- `tab.playwright` exposes the Codex common surface: `locator/getBy*/frameLocator`, locator actions and
  queries, `evaluate`, `domSnapshot`, `waitForURL`, `waitForLoadState`,
  `waitForTimeout`, `expectNavigation`, and download events.
- Fixed waiting is `tab.playwright.waitForTimeout(timeoutMs)`, never `tab.waitForTimeout`. Prefer
  `locator.waitFor(...)`, `waitForURL(...)`, `waitForLoadState(...)`, or a fresh semantic observation.
- Routine locator, URL/load-state wait, and read-only evaluate operations default to and are capped at 3000ms,
  matching Codex. A timeout is a signal to refresh the snapshot and rebuild the locator, not to retry it unchanged.
- IAB matches Codex's upload boundary: `waitForEvent("filechooser")` / `fileChooser.setFiles(...)` fail with
  `capability_unsupported`; no fake upload success is exposed.
