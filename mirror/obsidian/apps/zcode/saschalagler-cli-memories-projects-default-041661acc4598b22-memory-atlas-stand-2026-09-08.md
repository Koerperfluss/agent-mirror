---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/atlas-stand-2026-09-08.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: atlas-stand-2026-09-08
description: Atlas Cali Coach Stand 08.09. (sess_d4dc6589) — Web fix ✅, iOS-Dev-Setup
  komplett (Developer Mode enabled), v6-Build wartet auf Deploy, 5 uncommitted Files,
  Master-Prompt (P0–P4) übergeben
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

Atlas Cali Coach — Stand 08.09.2026 (Handoff aus ZCode-Session sess_d4dc6589):

- **Pfade:** Master `~/ATLAS_MASTER` und `~/Desktop/Coworkspace_Ich/atlas + pliability/ATLAS_MASTER`; Deploy-Repo `~/cali-coach-atlas-final` (GitHub Koerperfluss/atlas-cali-coach, Live https://barbulls-app.web.app bzw. atlas-v5.web.app).
- **Web ist fix:** firebase.json Cache-Fix (commit 12e3323, Browser zeigten alte Stände durch 1h-Cache), Coach-429-Fix via keyless Server-Proxy `/api/coach` (commit d46e364, Secret ATLAS_GEMINI_KEY), adaptives KI-Interview als Default-Onboarding live.
- **iOS-Dev-Setup KOMPLETT (08.09. verifiziert):** Xcode 27.0.0-Beta.6 unter `/Applications/Xcode-27.0.0-Beta.6.app` (xcode-select korrekt, Lizenz akzeptiert, kaputtes Xcode-26.6-Teilpaket gelöscht); iPhone 16 Pro Max iOS 27.0 gekoppelt; **Developer Mode ENABLED** (per devicectl verifiziert). iPhone-App neu übertragen = `npm run build` → `npx cap sync ios` → Build via Xcode 27 → Device-Install. Für TestFlight-Verteilung bleibt Apple-ID/2FA (bahldorfa@gmail.com) der Nutzer-Schritt.
- **Atlas v6 „Clean & Stable"** gebaut (Grafik-Extremismus aus src/index.css gestrippt, 137→75 Zeilen; Bundle index-BlhLFqDd.js) — **Deploy wartet auf GO**; Rollback: `git checkout 96fffe7 -- src/index.css`.
- **5 uncommitted Files in 3 Repos:** firebase.json ×3 (Cache-Header), ATLAS_MASTER/app/src/coach/CoachChat.tsx (+108), app/src/glass/FluidScene.tsx (±1) → erst prüfen/committen (P0), dann Deploy (P1).
- **Master-Prompt übergeben** („fordere gleich alles"): P0 uncommitted committen → P1 v6-Deploy → P2 iPhone+Android cap sync/Rebuild/Neuübertragung → P3 E2E-Beweis Live-Interview in isoliertem Profil → P4 Coach-Chat Tasks 20–22 + QA-Gate.
- **Eiserne Regeln:** Build immer mit `VITE_GEMINI_API_KEY=` (leer, sonst landet der Key im Bundle). Kein Deploy/git push ohne Sascha-GO. Browser-Automatisierung NIE im echten Chrome-Profil (ID-Austria-Login-Tab!) — isoliertes Profil. [[skills-architektur-2026-09-07]] [[macos-27-beta-status]]
