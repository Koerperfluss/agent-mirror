---
app: zcode
quelle: "saschalagler/cli/plugins/marketplaces/claude-plugins-official/plugins/hookify/examples/dangerous-rm.local.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: block-dangerous-rm
enabled: true
event: bash
pattern: rm\s+-rf
action: block
---

⚠️ **Dangerous rm command detected!**

This command could delete important files. Please:
- Verify the path is correct
- Consider using a safer approach
- Make sure you have backups
