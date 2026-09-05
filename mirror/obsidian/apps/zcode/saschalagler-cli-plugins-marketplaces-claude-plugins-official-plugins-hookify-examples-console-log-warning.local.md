---
app: zcode
quelle: "saschalagler/cli/plugins/marketplaces/claude-plugins-official/plugins/hookify/examples/console-log-warning.local.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: warn-console-log
enabled: true
event: file
pattern: console\.log\(
action: warn
---

🔍 **Console.log detected**

You're adding a console.log statement. Please consider:
- Is this for debugging or should it be proper logging?
- Will this ship to production?
- Should this use a logging library instead?
