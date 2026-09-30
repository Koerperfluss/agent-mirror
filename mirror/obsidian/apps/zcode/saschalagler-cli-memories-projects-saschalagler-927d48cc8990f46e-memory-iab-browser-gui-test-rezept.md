---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/iab-browser-gui-test-rezept.md"
stand: 2026-09-30
tags: [spiegel, zcode]
---

---
name: iab-browser-gui-test-rezept
description: 30.09. bewiesen — echtes Live-GUI-Testen im ZCode-In-App-Browser
  via node_repl-Bootstrap (ZCODE_PLUGIN_ROOT/browser-client.mjs); D3-SVG-Knoten
  per read-only evaluate + CUA-Klick
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

Live-GUI-Blackbox-Test (web-gui-tester-Skill) im ZCode-In-App-Browser — Stand 30.09.2026, erfolgreich an beiden Körperfluss-Apps:

1. **Bootstrap JEDEM node_repl-Call voranstellen** (frischer Kernel!): `process.env.ZCODE_PLUGIN_ROOT` → `scripts/browser-client.mjs` → `setupBrowserRuntime({globals: globalThis})`, dann `agent.browsers.getForUrl(url)` → iab-Backend. Erster Call einmalig `browser.documentation()` ausgeben.
2. **Protokoll:** eigener Cell mit `browser.tabs.list()` → nächster Cell `tabs.get(id)` nach id/URL. Nach `goto` immer `waitForLoadState({state:"domcontentloaded"})`. Beobachtung primär per `domSnapshot()` (ARIA-Baum); Screenshots nur bei visuellen/SVG-Zielen und IMMER `nodeRepl.emitImage(...)` im selben Cell (read-Pflicht: Screenshot ohne Ansehen zählt nicht; Pfad steht in „Browser screenshot saved to: …").
3. **D3-/SVG-Knoten (nicht im ARIA-Baum):** Kreis-Positionen per read-only `playwright.evaluate` (getBoundingClientRect auf `svg circle`, nach fill filtern) holen und **im selben Kernel sofort** `tab.cua.click({x,y})` — bei laufender Force-Simulation werden Koordinaten sonst stale (Fehlschlag bei Pilot-Cloud).
4. **Live-Bundle deterministisch prüfen:** live index.html per curl holen → Asset-Name (Vite-Content-Hash) mit lokalem dist vergleichen; Bundle per curl laden + grep auf Fix-Marker/Passwort-Muster. Filename-Gleichheit = Inhalts-Gleichheit.
5. Tipp: kaputte Reste im evaluate-Ausdruck werfen ReferenceError und killen den ganzen Cell — sauber einen Ausdruck pro evaluate.

Verwandt: [[koerperfluss-edu-foerderpilot-fertig]], [[zoetrope-live-view]], [[session-quellen-wo-zu-finden]]
