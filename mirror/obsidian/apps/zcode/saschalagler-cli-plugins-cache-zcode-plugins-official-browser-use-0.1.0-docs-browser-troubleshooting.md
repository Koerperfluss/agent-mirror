---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/browser-use/0.1.0/docs/browser-troubleshooting.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# Browser Interaction Troubleshooting

- First use the selected browser's documented API. Do not inspect implementation source or switch control
  mechanisms merely because a page interaction failed.
- A stale/missing/closed tab, an empty controlled/user tab list, or an unavailable injected Playwright helper does
  not prove the browser disconnected. Keep the existing `browser` binding. For controlled tabs, return the complete
  `browser.tabs.list()` result in a dedicated JS call, inspect it, then call `browser.tabs.get(info.id)` in the next
  call; if none exist, inspect `browser.user.openTabs()` and claim the matching visible page. Create a new tab only
  when neither list contains the page.
- After locator timeout, strict-mode failure, or selector parse failure, take a fresh `domSnapshot()`. Rebuild a
  unique locator from facts in that snapshot and check `count()`/`isVisible()` before acting. Do not retry the same
  locator, guess an absent role/name/placeholder, or use `first()`/`last()`/`nth()` to hide ambiguity.
- Only an explicit browser-disconnected error requires selecting a fresh browser and reading its effective docs
  again. If a documented member is unavailable, use alternatives exposed by the current capability manifest.
