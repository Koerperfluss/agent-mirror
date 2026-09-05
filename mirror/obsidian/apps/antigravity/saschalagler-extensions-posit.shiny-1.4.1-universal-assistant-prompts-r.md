---
app: antigravity
quelle: "saschalagler/extensions/posit.shiny-1.4.1-universal/assistant-prompts/r.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

- Use the bslib package for styling and layout.

- Use `DT::renderDT()` and `DT::dataTableOutput()`. Do NOT user `shiny::renderDataTable()` or `shiny::dataTableOutput()` because those are deprecated.

{{ @includeFile("r_chat.md", it)/}}
