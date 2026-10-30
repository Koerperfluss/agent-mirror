---
name: tauri-build-gotchas
description: Tauri-2-Fallen aus Product Canvas Local (30.10.) — capabilities
  statt fs-scope, withGlobalTauri, DMG-Bundling abschalten, SPA-Hard-Nav =
  weißer Screen, fehlende Named-Exports failen Rollup hart
metadata:
  node_type: memory
  type: reference
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Tauri-2-Erkenntnisse aus dem Bau von „Product Canvas Local" (30.10.2026, Web-React-App in native Hülle):

1. **Weißer Screen + Crash beim Start:** `plugins.fs` mit `scope` in tauri.conf.json ist Tauri-1-Syntax → Panic `unknown field 'scope'`. Tauri 2 will `src-tauri/capabilities/default.json` (permissions wie `fs:allow-appdata-read-recursive`, `http:default`, `core:default`) und plugins in der conf leer (`"plugins": {}`).
2. **`window.__TAURI__` nur mit `"withGlobalTauri": true`** (app-Sektion der conf). Ohne laufen `__TAURI__.path.appDataDir()`/`__TAURI__.fs` ins Leere. Achtung: Plugin-APIs (fs) erscheinen nur dort, wenn das Plugin Global-Scripts mitbringt — sonst npm-Paket `@tauri-apps/plugin-fs` im Frontend nutzen. conf-Änderungen sind in den Rust-Build eingebrannt (generate_context!) → nach conf-Edit neu bündeln.
3. **DMG-Bundling scheitert** an Finder-AppleScript-Timeout (`execution error -1712`) → **`npx tauri build --bundles app`** (nur .app, keine DMG) — .app liegt dann in `src-tauri/target/release/bundle/macos/`.
4. **SPA-Routing:** harte Navigation (`window.location.pathname = x`) = weißer Screen (Asset-Protocol ohne SPA-Fallback) bzw. 404 auf Static-Server → `history.replaceState({}, "", "/" + id)` + State setzen. Tauri-spezifisch weiß; im normalen Chromium-Build dasselbe Symptom über Static-Server-404 — gut zum Vortesten.
5. **Alias-Strategie für SDK-Ersatz:** `resolve.alias` auf Regex `^firebase/(app|auth|…)$` → Ersatzmodul ersetzt das ganze SDK auch in direkten Imports. Rollup bricht bei JEDEM fehlenden Named-Export hart ab („X is not exported by …") — die Ersatzdatei muss die komplette Import-Oberfläche abbilden; fehlende Exports per Schleife ergänzen bis grün.
6. **Release-DevTools:** `tauri = { version = "2", features = ["devtools"] }` in Cargo.toml → Inspector auch im Release-Build. Öffnen: App-Fenster fokussieren (System Events frontmost) + Cmd+Opt+I — globaler Keystroke geht sonst an falsche Apps (Multi-Monitor/Fokus-Krieg mit Parallel-Sessions beachten; Screenshots auf 3 Monitoren selten aussagekräftig — lieber Fenster-Liste via System Events verifizieren).
7. Build-Dauer: erster Cargo-Build ~2 Min (warm cache), Frontend ~8 s. cargo 1.98 war bereits installiert; @tauri-apps/cli via npm -D (v2.12.4).

**Why:** Jede dieser Fallen kostete eine Debug-Runde. **How to apply:** Vor Tauri-2-Bauten conf/capabilities gegen diese Liste prüfen; SPA-Apps nie mit location-Assignment routen. Siehe [[product-canvas-rebuild]], [[local-browser-testing-gotchas]].
