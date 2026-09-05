---
app: antigravity
quelle: "saschalagler/extensions/posit.shiny-1.4.1-universal/assistant-prompts/brand_yml_r.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

To use a _brand.yml file in Shiny for R, pass it as the `theme` argument to a `page_*` function.

```R
ui <- page_sidebar(
  title = "Acme Sales Dashboard",
  theme = bs_theme(brand = "acme-brand.yml"),
  # ... the rest of your app ...
)
```
