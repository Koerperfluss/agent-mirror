---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/product-canvas-rebuild.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: product-canvas-rebuild
description: Laufendes Projekt — Google Product Canvas (romannurik) wird als
  eigene Full-Stack-App nachgebaut; entpackt, npm install lief am 27.10.2026
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Seit 27.10.2026 baut Sascha Google „Product Canvas" (ProductCanvas-Experiment von romannurik, Apache-2.0 → Nachbau legal, LICENSE drin lassen) als eigene Full-Stack-App nach.

**Stand 27.10.2026:**
- Quelle: ZIP aus `~/Downloads/ProductCanvas-Experiment-main.zip` → entpackt nach `~/Desktop/Coworkspace_Ich/product-canvas-nachbau/ProductCanvas-Experiment-main`
- Umfang: 138 Quelldateien, 10.732 Zeilen TS/TSX, 34 Dependencies, 14 Module (ai, canvas, collab, live, meetings, miniapp-generator, notebook …); größte Datei `src/Editor.tsx` (728 Z.)
- Stack: Vite+React+TS · React Flow (Canvas) · Firebase RTDB+Auth (Multiplayer) · WebRTC (Video) · Gemini Live API (Voice) · Nano Banana (KI-Skizzen) · esbuild-wasm (In-Browser-Prototypen) · Tiptap (Wiki) · matter.js (Videoblasen)
- `npm install` lief im Hintergrund (Start 27.10.); danach geplant: `npm run dev` + Browser-Check
- **Braucht nur 1 Key:** `VITE_FIREBASE_CONFIG` (JSON-Blob) in `.env` — Sascha hat Firebase in ZCode verbunden; ob sein bestehendes Projekt genutzt werden darf, war noch offen
- Live-Referenz des Originals: https://threeplabs--canvas-evmrz4ny.web.app/
- Nächste Phase nach Laufen: Umbau zum eigenen Produkt (loki-dev MAP, Multi-Session)

**Why:** Das ist Saschas aktives Hauptprojekt ab 27.10.; Pfad, Key-Bedarf und Stand sind aus keinem Repo ableitbar. Verwandt: [[zcode-skills-landscape]] (video2code für andere Nachbau-Fälle).
