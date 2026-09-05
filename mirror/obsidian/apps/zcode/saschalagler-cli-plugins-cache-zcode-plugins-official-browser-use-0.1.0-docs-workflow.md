---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/browser-use/0.1.0/docs/workflow.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# Workflow

1. Start every logical tab operation batch with a dedicated JS call that returns all controlled tabs to the model:

```js
const browser = await agent.browsers.getDefault();
globalThis.controlledTabs = await browser.tabs.list();
return controlledTabs;
```

After inspecting that output, use the next JS call to match the intended page by stable id or verified URL/title facts,
then call `tabs.get(id)` to activate it. Never select `[0]` merely because the list is non-empty. If no controlled tab
matches, inspect user tabs and claim the matching page:

```js
const controlled = globalThis.controlledTabs;
const matching = controlled.filter((info) => info.url === "https://example.com/");
if (matching.length > 1) throw new Error("Multiple browser tabs match the target URL");
const controlledTab = matching[0] ? await browser.tabs.get(matching[0].id) : undefined;
const userTabs = await browser.user.openTabs();
const matchingUserTabs = userTabs.filter((info) => info.url === "https://example.com/");
if (matchingUserTabs.length > 1) throw new Error("Multiple user tabs match the target URL");
const tab = controlledTab ??
  (matchingUserTabs[0] ? await browser.user.claimTab(matchingUserTabs[0]) : undefined);
if (!tab) throw new Error("Target browser tab is not open");
await tab.playwright.domSnapshot();
```

2. If the task names a new URL, select with `getForUrl`, then open or navigate once:

```js
const browser = await agent.browsers.getForUrl("https://example.com");
const tab = await browser.tabs.new();
await tab.goto("https://example.com");
```

3. Read the page from `playwright.domSnapshot()`. It returns the Codex-compatible AI/ARIA tree with computed roles, accessible names, state and expanded iframe content when available. Construct Playwright locators only from facts present in the latest relevant snapshot. When the snapshot already contains the target, use it directly instead of writing `evaluate()` code to search related elements, enumerate inputs, dump HTML, or walk the DOM. Never guess a label, accessible name, placeholder, selector, or URL pattern, and never spend timeout budget using a guessed locator as an exploratory probe.

The snapshot call must be the final expression in the JS cell, or be passed to `nodeRepl.write(...)`. A local assignment alone does not return the DOM observation to the model.

4. Confirm locator uniqueness when it is not obvious, then act through real browser actions. If `count()` is zero, do not wait on or execute the locator: take a fresh snapshot and rebuild it. If it is greater than one, tighten the scope instead of using a positional shortcut:

```js
const input = tab.playwright.getByRole("textbox", { name: "Search" });
if ((await input.count()) !== 1) throw new Error("Search locator is not unique");
await input.fill("hello");
await input.press("Enter");
```

5. After an action, collect the cheapest observation that answers the next question. Prefer a targeted locator state check; take another `domSnapshot()` when you need new locator ground truth. Opening or navigating a normal page is not a reason to screenshot, and do not collect DOM snapshot plus screenshot together by default.

Only load `agent.documentation.get("screenshots")` when the user explicitly requests a screenshot, visual layout/rendering/image content must be judged, or the required target is missing from the DOM snapshot (for example canvas/custom-drawn UI). Once that branch is selected, every screenshot must be emitted in the same JS cell with `nodeRepl.emitImage(await tab.screenshot())`; never leave `tab.screenshot()` as the final expression or return its `Uint8Array` bytes directly.

After any Playwright timeout, strict-mode failure, or selector parse failure, do not retry the same locator. Take a fresh `domSnapshot()` and rebuild it from snapshot-proven facts. Routine locator and page-state waits fail within Codex's 3000ms budget; use a longer fixed sleep only when no concrete state can be observed.

Treat `playwright.evaluate(...)` and locator `evaluate(...)` as read-only last resorts. Do not mutate DOM, navigate, fetch, or trigger actions inside evaluate. Chromium can reject calls it cannot prove side-effect-free with `Possible side-effect in debug-evaluate`; do not retry an equivalent expression. Recover with `domSnapshot()`, targeted locator reads, or screenshot/CUA only when the missing fact is visual.

6. Tabs remain open across turns by default. Use `await browser.tabs.finalize({ keep })` only when you need to mark
   listed pages as `deliverable` or `handoff`; unlisted pages remain open. Close a tab only with an intentional
   `await tab.close()` call.

For direct lookup URLs, make at most one focused attempt derived from user input or verified page facts. Never iterate
guessed URL variants, paths, search parameters, or numeric IDs. If the focused attempt fails, use a fresh snapshot,
the site's own search/navigation, or an authoritative connector/API/CLI lookup before navigating again.
