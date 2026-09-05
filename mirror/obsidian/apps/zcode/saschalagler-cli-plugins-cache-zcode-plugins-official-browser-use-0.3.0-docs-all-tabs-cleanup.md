---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/browser-use/0.3.0/docs/all-tabs-cleanup.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# All-Tabs Cleanup Guidance

If the user asks to close every visible in-app browser tab in the current conversation, close controlled tabs found through
`browser.tabs.list()` and then claim and close released or user-owned tabs from `browser.user.openTabs()`.
Neither list alone represents all tabs owned by the current conversation. Tabs from other conversations are isolated and
must not be enumerated or closed.
