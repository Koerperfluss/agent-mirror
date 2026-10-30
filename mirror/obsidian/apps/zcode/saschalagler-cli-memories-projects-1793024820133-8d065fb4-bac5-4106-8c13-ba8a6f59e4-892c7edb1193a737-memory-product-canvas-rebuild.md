---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/product-canvas-rebuild.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: product-canvas-rebuild
description: Aktives Projekt — Google Product Canvas (romannurik) lokal; 30.10. neu
  als native Tauri-App „Product Canvas Local.app" gebaut (Vite-Alias-Shim statt 12
  Umbauten); Editor im Browser-Build voll bewiesen, Tauri-Webview hängt noch im Loading
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Sascha baut Google „Product Canvas" (ProductCanvas-Experiment von romannurik, Apache-2.0) nach. **Zielstand 30.10.: native Tauri-Mac-App „Product Canvas Local.app" — kein Browser/localhost, keine Firebase/Gemini, KI über lokale Ollama/LM-Studio-Modelle, kein Multiplayer.** Geschwistert-Projekt: [[lokicanvas-native-app]] (SwiftUI-Variante, fertig).

**Pfad (gezogen):** `~/Desktop/Reverse Engeniering /product-canvas-nachbau/ProductCanvas-Experiment-main` (Leerzeichen + trailing space!). 138 Dateien, 10.732 Zeilen; Vite+React+TS, React Flow, Firebase RTDB+Auth, WebRTC, Gemini Live, esbuild-wasm, Tiptap, matter.js. Kein Git-Repo im Ordner.

**Architektur-Trick (statt 12 Umbauten): 1 Nahtstelle + Vite-Aliase.**
- `src/local/rtdb-local.ts` (~340 Z.): Mini-RTDB (ref/set/update/push/onValue/get/child/query/onDisconnect…), Baum debounced (500 ms) als `canvas-db.json`; Tauri: `window.__TAURI__.path.appDataDir()` + `__TAURI__.fs`, Browser-Fallback: localStorage (Key `rtdb-local:/tmp/...`).
- `src/local/firebase-local.ts`: Total-Ersatz für firebase/app|auth|database|functions|storage — `vite.config.ts` aliasiert bei `VITE_LOCAL_APP=1` ALLE `firebase/*`-Imports darauf (23 direkte Imports in 12 Verbrauchern! — DocumentProvider, PresenceProvider, rtcfire, MiniAppHost importieren direkt). **Rollup failt hart bei fehlenden Named-Exports** → Vertragsliste: connectAuthEmulator/connectDatabaseEmulator (no-op), serverTimestamp, onChildAdded/Changed, getDatabase, signInAnonymously/WithPopup/WithRedirect, GoogleAuthProvider, getIdTokenResult, uploadBytes/getDownloadURL, httpsCallable …
- `src/local/ai-local.ts` + `ai/index.ts` LOCAL-Zweig: OpenAI-Format (chat/completions) gegen `prefs.localAIBaseUrl` (Default `http://127.0.0.1:11434/v1` Ollama) + `prefs.localAIModel` (Default `qwen2.5-coder:7b`); cURL-Beweis geliefert. Bild/Voice werfen bewusst „Lokal nicht verfügbar".
- Auth: Auto-Login `uid:'local-user'`, `getIdTokenResult()` → `{claims:{hasAccess:'local'}}` (Invite-Gate), Onboarding überspringt Login/Invite/Gemini-Key, LoginScreen-Text „Lokal starten".
- `src-tauri/` (Tauri 2): Fenster 1440×900, fs+http-Plugins, Command `fetch_local_ai` (Host 127.0.0.1, Port nur 11434/1234).

**Fixes beim Bau (alle .bak-2026-10-30):** `vite-tsconfig-paths` war DER ETIMEDOUT-Übeltäter (scandiert Google-Drive-Shortcuts; Bisect bewiesen) → entfernt, `@`-Alias reicht. App.tsx: harte Navigation (`window.location.pathname = generateId()`) → `history.replaceState` + docId-State (harte Nav = weißer Screen/404 in Tauri/Static-Server); DocumentProvider braucht docId-Prop. Shim-User MUSS `getIdTokenResult()` als Methode haben (AuthProvider ruft direkt auf — sonst stiller Loading-Hänger ohne Konsolenfehler!). Devtools-Feature in Cargo.toml (`tauri = {version:"2", features:["devtools"]}`) für Release-Inspektion.

**Stand (bewiesen):**
- Frontend `VITE_LOCAL_APP=1 vite build` grün; Tauri-App gebaut: `src-tauri/target/release/bundle/macos/Product Canvas Local.app` (13,7 MiB; DMG-Bundling scheitert am Finder-AppleScript-Timeout → immer `tauri build --bundles app`).
- **Browser-Gegenbeweis komplett** (`python3 -m http.server 4188` im dist, agent-browser): Auto-Login → Privacy → SPA-Route `/b6LEv9YBzo` → Editor (Toolbar, „Lokal"-Button) → Shim-Persistenz in localStorage, 0 Konsolenfehler, 0 Google-Calls.
- **OFFEN:** Tauri-Webview bleibt im Loading-Spinner hängen (dunkles Fenster + Theme + Menü ok, kein JS-Fehler sichtbar), obwohl identisches dist im Browser läuft. DevTools (Cargo-devtools, Cmd+Opt+I im App-Fokus) noch nicht ausgelesen — Fokus-Krieg mit Parallel-Session, die gerade CLT 27.2 installiert.
- Ollama real: nur `qwen2.5-coder:7b` (+1.5b) antwortet; `qwen3.5:9b`/`qwen3-vl:8b` Manifeste ohne Blobs (→ `ollama pull`); LM Studio aus.

**Ältere Artefakte (27.10., ruhen):** Web-Version via Firebase-Emulatoren voll lauffähig (Patches + Ports siehe Git-Historie dieser Datei); echtes Firebase-Projekt `product-canvas-lab-6609` teils eingerichtet (RTDB-Create + identitykit nur per Console-Ritual, Blocker unverändert).

**Why:** Multi-Session-Projekt; Alias-Architektur, Vertragsliste und Tauri-Fallen sind aus dem Repo nicht ableitbar. Verwandt: [[lokicanvas-native-app]], [[tauri-build-gotchas]], [[local-browser-testing-gotchas]], [[simple-language-responses]].
