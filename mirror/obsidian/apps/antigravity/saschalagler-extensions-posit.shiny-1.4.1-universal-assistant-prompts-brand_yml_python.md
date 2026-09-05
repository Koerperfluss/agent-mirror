---
app: antigravity
quelle: "saschalagler/extensions/posit.shiny-1.4.1-universal/assistant-prompts/brand_yml_python.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

To use a _brand.yml file in Shiny for Python, this is how to do it with Shiny Express syntax:

```py
from shiny.express import input, render, ui

ui.page_opts(theme=ui.Theme.from_brand(__file__))
```

And this is how to do it with Shiny Core Syntax:

```py
from shiny import ui

app_ui = ui.page_fluid(
    # App UI code...
    theme=ui.Theme.from_brand(__file__)
)
```

It also requires installing the `brand_yml` package, and `shiny[theme]`, so those should be added to `requirements.txt`. If there is an existing `shiny` entry, replace it with `shiny[theme]`.

