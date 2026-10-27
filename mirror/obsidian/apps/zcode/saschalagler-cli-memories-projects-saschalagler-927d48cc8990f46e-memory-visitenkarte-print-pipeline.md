---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/visitenkarte-print-pipeline.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: visitenkarte-print-pipeline
description: Saschas Visitenkarten-Workflowsstand 27.10. — Design-Taste-Skills,
  Visual-Judge-Gate, bewährte Druck-PDF-Pipeline (PNG→bildbasiertes PDF)
metadata:
  node_type: memory
  type: project
  originSessionId: session_c6838a9a3dbab5ae2ed3f047aa155416
---

Visitenkarte KÖRPERFLUSS (27.10.2026): 4 freigegebene Designs A/F/H/I, 8/8 Seiten von pdf:visual-judge PASS.

**Warum:** Erste Versionen "hingen" (Sascha: "wie hingeschossen") — Emoji-Icons, kein Font-System. Fix per [[design-taste-frontend-v2-experimental]] (Anti-Slop: keine Emojis, kein Pure-Black, Em-Dash-Ban, Marcellus+Jost).

**How to apply (bewährte Pipeline):**
1. Design in `~/Desktop/VISITENKARTE_DESIGNS_2026-10-27/highend.html` (500×318px Canvas, Fonts lokal in `fonts/` via fontsource-CDN).
2. Seiten-HTMLs MÜSSEN den kompletten `<style>`-Block aus highend.html erben (sonst Serif-Fallback + schwarze Icons — teuer gelernt).
3. Pro Seite: `chrome --headless --force-device-scale-factor=2.008 --window-size=500,318 --screenshot` → 1004×639px = 300dpi.
4. PDF: 2 `<img>` mit `@page{size:85mm 55mm;margin:0}` + `page-break-after:always` → chrome `--print-to-pdf`. NIEMALS direkt HTML-Karten printen (Layer überlappen).
5. Abnahme: pdf:visual-judge-Agent auf die PNGs, Fixes, Re-Check — erst dann PDF.

Inhalt (final): Ganzheitlicher Therapeut · kein Diplom-Wording · kein Website-Link · nur +43 660 425 3366 + koerperfluss@gmail.com. Glas-Kopf: `LeePerrySmith.glb` aus `~/Desktop/Coworkspace_Ich/Körperfluss EDU/3d-UPGRADE-clone/public/`, gerendert via http-localhost + three.js (file://-CORS blockt GLB-Fetch).
