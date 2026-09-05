---
app: zcode
quelle: "saschalagler/cli/plugins/cache/zcode-plugins-official/document-skills/0.1.2/skills/pdf/typesetting/typography.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---


---

## CJK Typography Supplement

> See `pagination.md` Section 3 for detailed rules.

```css
/* CJK punctuation placement rules (always include) */
body {
  line-break: strict;
  word-break: normal;
  overflow-wrap: break-word;
}

p, td, li {
  line-break: strict;
  text-align: justify;
}
```
