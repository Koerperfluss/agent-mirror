---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/product-canvas-rebuild.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: product-canvas-rebuild
description: Laufendes Projekt — Google Product Canvas (romannurik) als eigene
  Full-Stack-App; läuft lokal (HTTPS:5173), Firebase 90 % aufgesetzt, wartet
  auf Firebase-CLI-Login-Code von Sascha (Session A0670)
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Seit 27.10.2026 baut Sascha Google „Product Canvas" (ProductCanvas-Experiment von romannurik, Apache-2.0 → Nachbau legal, LICENSE drin lassen) als eigene Full-Stack-App nach.

**Stand 27.10.2026 (nachts, Stand nach Browser-Beweis):**
- Pfad: `~/Desktop/Coworkspace_Ich/product-canvas-nachbau/ProductCanvas-Experiment-main` (138 Dateien, 10.732 Zeilen, 14 Module; Stack: Vite+React+TS, React Flow, Firebase RTDB+Auth, WebRTC, Gemini Live, esbuild-wasm, Tiptap, matter.js)
- **App läuft**: 0 Konsolen-Fehler, Screenshot-Beweis (Login-Screen). Server: `vite.dev.config.ts` → HTTPS 5173 (self-signed, Mikrofon/WebRTC) + `vite.dev-http.config.ts` → HTTP 5188 (nur für Playwright). Server laufen als Background-Tasks in der ZCode-Session.
- `.env` enthält die ECHTE Firebase-Config (Projekt product-canvas-lab-6609), `databaseURL` verweist auf noch nicht existierende RTDB.

**Reparaturen beim Aufsetzen (wieder verwendbar):**
- `node-stdlib-browser` v1.2.1/1.3.1 fehlen mock/proxy-Dateien (packaging bug). Stubs angelegt: `mock/empty.js`, `proxy/querystring.js`, `proxy/url.js` **im Projekt-Root** (nicht node_modules!) — der Code löst `./mock/empty.js` relativ zum Start-Kontext auf (create-require → `[eval]`), deshalb halfen node_modules-Stubs nicht.
- `vite-tsconfig-paths` verursacht beim Start `ETIMEDOUT scandir` in Google-Drive-Shortcuts (`~/Library/CloudStorage/…/koerperfluss/…venv…`) — Ursache ungeklärt (tsconfigs harmlos). Fix: Plugin weggelassen, `@/*` direkt per `resolve.alias`. Test-Configs: `vite.iso.config.ts` (Isolation), `vite.minimal.config.ts`.
- Playwright-MCP blockt self-signed HTTPS (ERR_CERT_AUTHORITY_INVALID) → HTTP-Zweitinstanz für Browser-Tests.

**Firebase-Setup (Projekt `product-canvas-lab-6609`, neu angelegt, barbulls-app unberührt):**
- Weg: gcloud (koerperfluss@gmail.com) + REST mit Bearer-Token und **Pflicht-Header `x-goog-user-project`** (Quota-Project). `gcloud projects create --name=` (nicht --display-name), APIs: firebase, firebasedatabase, identitytoolkit. addFirebase ✅ (Poll der Operation bis done). Web-App registriert: appId `1:675368337217:web:076991cb00d8fe20efabc0`, Config via `GET …/webApps/{appId}/config`.
- **BLOCKER A:** RTDB-Create via REST → konstant 404-HTML (v1/v1beta1, us-central1/europe-west1, Projekt-ID und -Nummer durchprobiert). **BLOCKER B:** identitytoolkit → `CONFIGURATION_NOT_FOUND` (Auth-Config existiert nicht; wird nur durch das Console-/CLI-Initialisierungs-Ritual erzeugt; Ports in authorizedDomains werden vom Legacy-Validator abgelehnt — localhost gilt implizit mit jedem Port).
- Firebase-MCP: 401 (Token abgelaufen) · Firebase-CLI: war ausgeloggt · gcloud: eingeloggt.
- **OFFEN:** `firebase login --no-localhost` Session **A0670** läuft (Link an Sascha geschickt); sobald er den Autorisierungs-Code schickt: `firebase login <code>` → danach RTDB + Google-Auth über die CLI/REST mit Firebase-OAuth fertigstellen → Browser-Login-Test.
- Live-Referenz Original: https://threeplabs--canvas-evmrz4ny.web.app/

**Nächste Phase nach voller Funktion:** Umbau zum eigenen Produkt (loki-dev MAP, Multi-Session).

**Why:** Saschas aktives Hauptprojekt; Pfade, Workarounds und der offene Login-Code sind aus keinem Repo ableitbar. Verwandt: [[zcode-skills-landscape]], [[local-browser-testing-gotchas]].
