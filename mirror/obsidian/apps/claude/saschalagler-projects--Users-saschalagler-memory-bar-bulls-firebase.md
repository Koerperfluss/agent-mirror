---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/bar-bulls-firebase.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: bar-bulls-firebase
description: BAR BULLS Shop Firebase-Hosting Setup + welcher Host welches Projekt ist (Unfall-Schutz)
metadata: 
  node_type: memory
  type: project
  originSessionId: 6dfa2c6d-b72f-4761-8448-e5792cf9cc43
---

BAR BULLS = Calisthenics-Parallettes-Shop von Sascha (Verein Barbulls Wachau, Melk).
Projektordner: `/Users/saschalagler/Desktop/3d hub paraletts verkau/` (git-Repo, branch main, KEIN Remote — nicht auf GitHub gesichert; BAR-BULLS-HTML sind untracked).

**Firebase-Hosting — Zuordnung unbedingt einhalten:**
- `barbulls-app.web.app` (Projekt `barbulls-app`) = DER eine Haupt-Host für BAR BULLS. Hierhin gehört alles BAR BULLS.
- `gen-lang-client-0285074833.web.app` (displayName KoerperflussWebfrontendkooper) = NICHT BAR BULLS. Das ist Saschas **„Antigravity Hub 3.0"** / Calisthenics-Hub (Routen `/app/`, `/logbook.html`, `/rehab.html`, `/cali-logbook_files/`, Pläne unter `/api/v1/plans/`). NIEMALS BAR BULLS hierhin deployen.

**Vergangener Unfall (2026-06-15):** Gemini-CLI hatte `deploy/.firebaserc` auf gen-lang gesetzt und BAR BULLS über den Hub deployt. Behoben per Rollback (REST API, Version `9354f6a2dfb23731`) und `deploy/.firebaserc` default auf `barbulls-app` umgestellt.

**Rollback-Technik (falls nochmal nötig):** `gcloud auth print-access-token` funktioniert; Firebase-Hosting-REST mit Header `X-Goog-User-Project: <projektid>`; `POST .../sites/<site>/releases?versionName=sites/<site>/versions/<versionId>` stellt eine alte Version wieder her.

**KANONISCHER ORDNER (Stand 2026-06-24):** `/Users/saschalagler/Desktop/3d hub paraletts verkau/BARBULLS-FINAL/` — eigener git-Repo, DIE eine Quelle der Wahrheit (von Antigravity dorthin verschoben; ggf. via git wiederherstellen). Aktuelle Basis = `index.html` (43 KB, clean Single-Page Shop = Saschas Lieblings-UI: Hero+Equipment-Varianten V1 89€/V2 119€/Combo 189€+Apparel+Community+Warenkorb+WhatsApp-Checkout +436601490090+Lightbox+Instagram @bar.bulls+Logo `media/bar_bulls_logo.svg`) + `media/` + firebase.json/.firebaserc auf `barbulls-app`. git-Historie: commit 33d74b5 = clean Shop (aktuell), a2fa1d6 = volle Feature-Version (113 KB, Tabs+3D+Margen-Rechner) als Backup. Deploy: `cd BARBULLS-FINAL && npx firebase-tools@latest deploy --only hosting --project barbulls-app`. Entwicklung läuft ab jetzt in Claude Code (nicht Antigravity) — keine parallelen Agenten.

Frühere verstreute Dateien (veraltet): `bar_bulls_official_website.html` (~22 KB, clean Shop-UI die Sascha mag), `deploy/index.html` (~38 KB dunkel), `bar_bulls_hub.html` (Tech-Hub). Liegen im Projektordner `3d hub paraletts verkau`, werden von parallelen Antigravity-Sessions ständig verschoben.

**Wichtig:** Sascha arbeitet teils mit parallelen Gemini-CLI-Sessions, die Dateien live verschieben/löschen → Quelle des "mehrere Versionen verteilt"-Chaos. Vor Aufräumarbeiten andere Sessions schließen lassen. Siehe [[loki-ki-projekt]] für andere lokale Projekte.
