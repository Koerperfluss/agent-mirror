---
name: higgsfield-skills-installiert
description: higgsfield-ai/skills seit 07.09. installiert (8 Skills, ~/.agents/skills/higgsfield-*) — Design-Quelle für Apple-Liquid-Glass; Zoetrop existiert NICHT (GitHub 0 Treffer) — nie wieder suchen
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**`npx -y skills add higgsfield-ai/skills` = Exit 0 (07.09., in ATLAS-Glass-Agent angewendet).** 8 Skills unter `~/.agents/skills/higgsfield-*`: brandkit, generate, marketplace-cards, product-photoshoot, soul-id, video-explainer, **websites**, youtube-thumbnail.

**Design-Schlüsselquelle:** `higgsfield-websites/references/design-taste-frontend.md` — Appendix C „Apple Liquid Glass: Honest Web Approximation" (1px helle Oberkante, inset-Toplicht, Spektral-Highlights mit Alpha ≤ 0.08, Subtilität) + „1px inner border für physical edge refraction" + „motion must be motivated" (Spring statt linear).

**Angewendet in ATLAS `src/glass/` (07.09., tsc 0):** FluidScene = MeshPhysicalMaterial (transmission 0.75, ior 1.4, iridescence 0.45/1.3, clearcoat, attenuation Amber/Cyan) + RoomEnvironment/PMREMGenerator (prozedurale Env-Map — echte Glasreflexionen OHNE Netz, Teil von three 0.185) + orbitierende Amber/Cyan-PointLights + 3-Sinus-Vertex-Deformation mit 2. Oktave; Tilt/GlassPlate = EDGE_LIGHT (inset box-shadow oben weiß 0.30, Cyan unten) + 1px EDGE_RING via mask-composite (xor/exclude, Safari 16.4+) + tilt-abhängiger Specular-Sweep über CSS-Vars `--sx`/`--sr`; Static-Fall (Touch/reduced-motion) rendert passive Glaskante ohne JS.

**Zoetrop = NICHT existent (definitiv, 07.09. per GitHub-API geprüft: `search/repositories?q=zoetrop+skills` → total_count 0; `npx skills add zoetrop` bricht ab).** Sascha erwähnt es immer wieder („aktiviere zoetrope skill") — ehrlich melden, nicht nachbauen/täuschen ([[sascha-erfundene-konventionen]]). Verwandt: [[atlas-master-app-verhaeltnis]], [[skill-routing]].
