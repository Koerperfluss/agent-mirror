---
name: koerperfluss-app
description: "Körperfluss React-App — kanonisches Verzeichnis, Repo, Firebase-Deploy (gen-lang, NICHT barbulls!)"
metadata: 
  node_type: memory
  type: project
  originSessionId: ee3ef77d-fc03-422b-8036-7b8a4fd37264
---

Körperfluss = KI-Lernplattform für medizinische Ausbildung (Physio/Gesundheit), Vite/React/TS/Tailwind, Backend Google Gemini.

**Kanonisches Verzeichnis (hier arbeiten & deployen):** `~/Desktop/Koerperfluss-3D-Upgrade`
- GitHub: `Koerperfluss/3d.-UPGRADE-`, branch `main`. Firebase-Projekt: `gen-lang-client-0285074833` (Default in `.firebaserc`), live: `gen-lang-client-0285074833.web.app`.
- Stammt aus AI-Studio-App `0ece798b-2b03-4091-96d2-2b53fac8a6c1`.

**Deploy IMMER mit explizitem Projekt:**
`npm run build && firebase deploy --only hosting --project gen-lang-client-0285074833`
Grund: `firebase use` steht global auf **`barbulls-app`** (= BAR-BULLS-Shop, NICHT Körperfluss). Ohne `--project` landet das Deploy auf dem falschen Projekt. Siehe [[bar-bulls-firebase]].

**Redundante Kopien (kein git — NICHT dort arbeiten):**
- `~/Desktop/aktuell-3d-upgrade-(vollfunktion)-körperfluss---...` (enthält auch antigravity-pwa Python + loki-ki im Unterordner/Worktree)
- `~/antigravity/aktuell-3d-upgrade-(VOLLFUNKTION)-Körperfluss-...` (hier liegt der Businessplan-PDF)
- `~/Desktop/Körperfluss Edu Local 3d MErch ` (kein App-Projekt, vermutlich Merch/Assets)

**DigiArk-Showcase:** Route `/showcase` (für Daniel @ DigiArk = Distributions-/Markteintrittspartner, KEIN Geldgeber). 5 echte Live-Module + 18-Tool-Matrix. Vision/Ganganalyse ist aktuell statisches Fake-Overlay (kein MediaPipe) → ehrlich als Prototyp gelabelt; echtes Client-Side-Video-Overlay ist offene Roadmap.

**Offene Sicherheit:** `VITE_GEMINI_API_KEY` liegt im Client-Bundle (öffentlich sichtbar) + in commit `ecfd2eb` des Public-Repos → Key in Google Cloud Console per HTTP-Referrer einschränken / rotieren.
