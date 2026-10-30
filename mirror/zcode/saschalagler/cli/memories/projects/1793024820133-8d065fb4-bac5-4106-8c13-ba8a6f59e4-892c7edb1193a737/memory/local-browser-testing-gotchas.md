---
name: local-browser-testing-gotchas
description: Browser-Testing lokal — file:// blockiert, http.server ohne
  SPA-Fallback, Cache-Buster, agent-browser-CLI als Playwright-Alternative
metadata:
  node_type: memory
  type: reference
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Beim Browser-Test lokaler Apps:

1. **Playwright-MCP blockiert `file://`** → `python3 -m http.server <Port> --bind 127.0.0.1` im Projektordner (run_in_background), dann `http://127.0.0.1:<Port>/…`; Server danach per TaskStop beenden.
2. **Browser-Cache-Falle:** Nach Edits liefert goto die ALTE Seite (26.10.: Drossel schien „kaputt") → Cache-Buster (`?v=neu1`) oder curl-Gegenprobe der Server-Auslieferung. Vite-Asset-Hashes im HTML gegen `ls dist/assets` prüfen, wenn Symptome „kleben" bleiben.
3. Konsolen-Zähler zwischen Tool-Calls können Minuten umfassen — Deltamessung erst nach Cache-Buster werten.
4. **Self-signed HTTPS hart blockiert** (`ERR_CERT_AUTHORITY_INVALID`, keine Durchklick-Seite) → zweite Vite-Instanz ohne ssl() auf Extra-Port für automatisierte Tests.
5. **python http.server hat KEINEN SPA-Fallback** (30.10., Product Canvas): Client-Routen wie `/<docId>` ergeben 404 „Error response" — im Browser sichtbar, in Tauri als weißer Screen getarnt. Für SPA-Tests: Route per History-API erreichen statt hart zu navigieren, oder Server mit Fallback.
6. **`agent-browser`-CLI** (`/opt/homebrew/bin/agent-browser`) = robuste Alternative, wenn Playwright-MCP spinnt: `open <url>`, `snapshot`, `eval "js"`, `console`, `errors`, `click @ref`, `wait` — Terminal-basiert (Chromium), inkl. echter Konsole/Errors; startet eigenen Browser (close + neu öffnen = frische Session, erst dann eval; ein „open" danach landet evtl. auf about:blank → nochmal open).

**Why:** Diese Fallen kosteten Fehldiagnosen an Saschas Live-Apps. **How to apply:** Server → Cache-Buster → Deltamessung; bei Playwright-MCP-Ausfällen direkt agent-browser. Siehe [[tauri-build-gotchas]], [[product-canvas-rebuild]].
