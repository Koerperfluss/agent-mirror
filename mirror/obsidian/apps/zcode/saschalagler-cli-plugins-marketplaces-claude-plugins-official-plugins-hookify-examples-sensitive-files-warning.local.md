---
app: zcode
quelle: "saschalagler/cli/plugins/marketplaces/claude-plugins-official/plugins/hookify/examples/sensitive-files-warning.local.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: warn-sensitive-files
enabled: true
event: file
action: warn
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env$|\.env\.|credentials|secrets
---

🔐 **Sensitive file detected**

You're editing a file that may contain sensitive data:
- Ensure credentials are not hardcoded
- Use environment variables for secrets
- Verify this file is in .gitignore
- Consider using a secrets manager
