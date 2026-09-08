---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/atlas-v8-premium-neubau.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: atlas-v8-premium-neubau
description: ATLAS v8 PREMIUM Komplett-Neubau in Sandbox ~/ATLAS_DESIGN/atlas-v8
  (eigenes Git) — kanonisches Redesign von Sascha verworfen, Live-Build
  unantastbar, 4 Parallel-Agenten, DESIGN-BIBEL „Flüssiges Gold auf Schwarz"
  F1–F8
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

08.09.2026: Nach 2 Plan-Ablehnungen genehmigt (Details [[sascha-plan-vollstaendigkeit]]). **Die 4 harten Vorgaben:** (1) Kanonisches FUI-Redesign (FluidScene/Tilt/Medaillon) = „völlig unbrauchbar" → **Komplettneubau**, nicht portieren. (2) „**Du greifst den laufenden app build nicht an sonst bist du tot**" — Live-Repo src/ + atlas-v5 tabu, kein Deploy/cap sync; alles in Sandbox. (3) ALLE Design-Skills nutzen (apple-design, ui-ux-pro-max, frontend-design, web-design-guidelines, vercel-react-best-practices, minimalist-ui, shadcn-ui, design-an-interface, prototype, d3-visualization, higgsfield) — „visuell die premium app nr 1, tob dich aus", 3D-Logo-Medaillon wie Körperfluss-App (NEU aus offizieller SVG bauen). (4) „starte so viel agent wie nötig vollautonom" → max-3-Regel von IHN aufgehoben, Wave 2 = 4 Agents parallel.

**Sandbox:** `~/ATLAS_DESIGN/atlas-v8` (eigener Git, Wave-1-Commit `c91b7d2`): Vite+React+TS+Tailwind3+three/@react-three/fiber+drei+d3+framer-motion+lucide. Engine portiert (getestet, tsc grün): coach/{agent,geminiClient,persona,tiers,types}, data/{exerciseDb,seed,knowledge.json,learned-kb.json 76K}, onboarding/{plan,profileDb,kb,coachText}, logbook/logbookDb, types — gleiche relative Struktur wie Live-Repo. public/: brand/barbulls-kreis-official.svg + graph.json (800 Knoten). `npm install` braucht **--legacy-peer-deps** (r3f peerOptional-Konflikt). vite.config proxyt /api/coach + /api/track auf die CloudFunctions (keyless funktioniert im dev lokal).

**DESIGN-BIBEL.md v1.0** = Gesetz: „Flüssiges Gold auf Schwarz", Tokens aus Logo (bg #050505, ink #ECE7DF, amber #f59e0b), 3 Materialschichten (L1 Bühne flüssig langsam / L2 Glas-Rezept bg-white/5+blur18+inset-Toplicht+Spektral-Kante / L3 Tinte z-10), F1–F8 (F8: Blur ≤6/Screen, transform/opacity only, Auto-Degradation <45 fps). `src/components/index.tsx` = FROZEN-API (GlassCard/GlassButton/Chip/Sheet/TabBar/SideNav/Slider/TimerRing/TextField/StatTile/Medallion/FluidBackdrop) — Agent A veredelt innen, Screens bauen dagegen.

**Agenten-Scopes (disjunkt!):** A = src/glass/Medallion+FluidBackdrop+Komponenten-Veredelung · B = Screens Interview/Logbuch/Übersicht/Wissen/Settings (+Upsell/Pro) · C = Übungs-DB (scripts/ingest-graph.mjs → graphExercises.seed.json ≥60 Übungen aus Graph; Media-Feld YouTube-Embed/Insta-Link/Bild; Archiv-Flag; Voll-Edit) · D = Marketing-Agent → `~/ATLAS_DESIGN/marketing-agent/` (MARKET-INTEL wo/was/wann Palantir-Stil, TARGETING 4 Personas, CAMPAIGN-ASSETS DE/EN, MESSEPLAN 12 Wo). DB-Kern der Idee von ihm: „alle meine Übungen die im Graphen sind + Einbindung durch Personen mittels Video-Link Insta YouTube oder Bilder".

**Gates:** T5 QA isoliert + Judge → **Abnahme** · F1 EIN Deploy nur nach **Deploy-GO** (alter v5-Bundle = Rollback) · F2 cap sync/APK · F3 Doku. Beweis-Pflicht: Live-Bundle-Hash von atlas-v5 vor/nach identisch. Verwandt: [[atlas-master-app-verhaeltnis]], [[atlas-lernender-agent-paradigma]], [[atlas-design-system]], [[anti-luegen-vertrag]]
