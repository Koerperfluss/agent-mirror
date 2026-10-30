---
name: product-canvas-rebuild
description: Aktives Projekt — Google Product Canvas (romannurik) als eigene Full-Stack-App; seit 27.10. VOLL LAUFFÄHIG lokal via Firebase-Emulatoren (Login/Mock/Canvas bewiesen); KI wartet nur auf echten Gemini-Key; echtes Firebase optional
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Seit 27.10.2026 baut Sascha Google „Product Canvas" (ProductCanvas-Experiment von romannurik, Apache-2.0 → Nachbau legal) als eigene Full-Stack-App.

**Stand 27.10.2026 (nachts): VOLL LAUFFÄHIG END-TO-END BEWIESEN.**
- Pfad: `~/Desktop/Coworkspace_Ich/product-canvas-nachbau/ProductCanvas-Experiment-main` (138 Dateien, 10.732 Zeilen; Stack: Vite+React+TS, React Flow, Firebase RTDB+Auth, WebRTC, Gemini Live, esbuild-wasm, Tiptap, matter.js)
- **Klickpfad komplett bestanden** (Playwright): ?mock=1 → „Sign in with Google" → anonym (Emulator) → Privacy „Got it" → Setup (Gemini-Key-Feld) → **Canvas-Session `/vcqM8oQytB`** → Leinwand rendert (React Flow, Toolbar, „What do you want to build?"), 0 echte Fehler.
- Server: `vite.dev.config.ts` → HTTPS 5173 (self-signed) + `vite.dev-http.config.ts` → HTTP 5188 (für Playwright). Nutzung: `https://localhost:5173/?mock=1` (Zertifikatswarnung durchklicken).
- `.env` = echte Config von Projekt `product-canvas-lab-6609` (barbulls-app unberührt).

**Chirurgische Patches (je Backup `*.bak-2026-10-27` daneben):**
1. `src/firebase.ts`: in DEV `connectAuthEmulator(9099)` + `connectDatabaseEmulator(9100)`.
2. `src/onboarding/Onboarding.tsx`: DEV + `?mock` überspringt den Invite-Claim (`hasAccess`-Gate).
3. `src/auth/AuthProvider.tsx`: signIn → wenn DEV+`?mock` → `signInAnonymously` statt Google-Popup.
- Erkenntnis: Der eingebaute `?mock=N`-Modus ersetzt nur einen BEREITS eingeloggten User (Anzeige-Trick) — kein Gate-Bypass; deshalb Patch 3.

**Emulator-Setup (umgeht beide Google-Sperren komplett):**
- `firebase.emulator.json` (auth :9099, database :9100, ui :4000) + `database.rules.json` (offen). Start: `JAVA_HOME=/opt/homebrew/opt/openjdk@21 firebase emulators:start -c firebase.emulator.json --project demo-canvas` (demo-Präfix = kein Login nötig). Java 21 war schon via brew da (Java 8 zu alt für Emulator).
- **Port 9000 ist von BrowserOS belegt** → Datenbank-Emulator auf 9100.

**Reparaturen beim Aufsetzen (wieder verwendbar):**
- `node-stdlib-browser` v1.2.1/1.3.1 packaging bug: Stubs `mock/empty.js`, `proxy/querystring.js`, `proxy/url.js` **im Projekt-Root** (nicht node_modules — create-require löst relativ zum Start-Kontext auf).
- `vite-tsconfig-paths` → ETIMEDOUT-scandir in Google-Drive-Shortcuts (Ursache offen) → Plugin weggelassen, `@/*` per resolve.alias.
- Playwright-MCP blockt self-signed HTTPS → HTTP-Zweitinstanz. `firebase login` (alle Varianten) endet sofort by design; Links im ZCode-In-App-Browser scheitern mit „Unable to verify client" (Cookies/Flow).

**Die 4 restlichen Konsolen-Fehler (erklärt):** 2× html-to-image Google-Fonts-CORS (harmlos, auch im Original) + 2× Gemini 400 API_KEY_INVALID = **KI-Kette lebt, wartet nur auf echten Gemini-Key** (aistudio.google.com/api-keys → in App-Settings eintragen).

**Echtes Firebase (optional, Projektparts fertig):** Projekt `product-canvas-lab-6609` per gcloud+REST angelegt (Pflicht-Header `x-goog-user-project`; `gcloud projects create --name=`), Web-App appId `1:675368337217:web:076991cb00d8fe20efabc0`. **Blocker bleiben:** RTDB-Create REST→404-HTML, identitytoolkit→CONFIGURATION_NOT_FOUND (nur Console-/CLI-Ritual). firebase login via Saschas Code wäre der Hebel — Sessions verfallen aber sofort und der Link-Chaos frustrierte ihn; nur noch anbieten wenn er fragt.

**Nächste Phase:** ~~Umbau zum eigenen Produkt~~ → **ABGELÖST 30.10.:** Sascha lehnte Web/localhost-Träger ab („0 Sinn") und wollte native App + lokale Ollama-Modelle statt Gemini-Key → Nachfolger ist **LokiCanvas** (SwiftUI, siehe [[lokicanvas-native-app]]). Web-Nachbau ruht als Referenz; Quellordner offenbar nach `~/Desktop/Reverse Engeniering /product-canvas-nachbau/` verschoben.

**Why:** Nachfolge-Projekt von [[lokicanvas-native-app]]; Pfade, Patches, Emulator-Ports hier, Restarbeiten aus keinem Repo ableitbar. Verwandt: [[zcode-skills-landscape]], [[local-browser-testing-gotchas]], [[simple-language-responses]].
