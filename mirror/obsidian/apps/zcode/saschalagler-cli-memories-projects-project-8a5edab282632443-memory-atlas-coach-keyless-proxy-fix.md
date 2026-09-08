---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/atlas-coach-keyless-proxy-fix.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: atlas-coach-keyless-proxy-fix
description: Root Cause der 10-h-App-Blockade gefixt: Client-Keyless→Proxy; Plan-E2E live bewiesen; Deploy-Build immer mit leerem VITE_GEMINI_API_KEY
metadata:
  type: project
---

08.09.2026: Die 10-h-Blockade („app live bekommen geht nicht") war ein Free-Tier-Key im Build: `.env.local` (VITE_GEMINI_API_KEY, Limit 20/Tag) wurde beim Clean-Deploy eingebakt → Client rief Gemini direkt → 429. Fix (Desktop-Repo, Commit d46e364): `geminiClient.ts` ruft ohne Key `/api/coach` (Server-Kette, Abo-Secret ATLAS_GEMINI_KEY), Key-Gate in CoachChat.tsx deaktiviert, BYO-Key bleibt.

**How to apply:** Deploy-Build IMMER mit `VITE_GEMINI_API_KEY= npm run build` (leer), nie .env.local einbacken. Plan-Karten-Trigger-Regex im Coach: „Erstelle mir einen individuellen Trainingsplan" — Nachrichten brauchen diesen Prefix. E2E-Beweis: Plan-Karte → „In Logbuch übernehmen" → Logbuch-Eintrag (Di. 08. Sept., 3 Blöcke/6 Übungen/18 Sätze). **Finale Live-Version 08.09.: `index-K9pgQrSf.js` (Fix des „Kein API-Key"-Throws), live == lokal dist (Parität per curl bewiesen); die alte „Altlast"-App ist vollständig überschrieben — atlas-v5 = Clean-Build, keine zweite Version mehr.** PWA-Manifest `/manifest.webmanifest` live (HTTP 200) → iPhone-Install = Safari → Teilen → „Zum Home-Bildschirm", full-screen ohne Xcode; echter TestFlight-Weg bleibt Saschas Apple-ID-Schritt. Dokumente: ~/ATLAS_MASTER/{ATLAS-REGELN,INIT-KONFIGURATION,PROJEKT-STATUS-PLAN}.md. Verwandt: [[atlas-master-app-verhältnis]], [[atlas-firestore-telemetry-setup]]
