---
name: cline-app-desktop-backend-fix
description: 18.09. Cline-Desktop-App (Tauri) „desktop backend exited before
  publishing its endpoint" gefixt — Ursache steckengebliebener
  code-sidecar-Prozess, Einzeiler-Fix
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_91589d59-5cf0-4fa5-a4f8-804e96d224d7
---

**18.09.2026 gefixt:** /Applications/Cline.app (Tauri-App, Binärdateien `cline-app` + `code-sidecar` in Contents/MacOS) zeigte `Tauri invoke get_desktop_backend_endpoint: desktop backend exited before publishing its endpoint`.

- **Root Cause:** steckengebliebener/alter `code-sidecar`-Prozess einer früheren Session war tot-fürs-Melden; App wartete ins Leere. Kein Gatekeeper/Codesign-Problem (Notarized Developer ID, spctl accepted), kein Crash-Report (nur alter vom 22.08).
- **Sidecar-Architektur:** `code-sidecar` spawnen 2 Prozesse, Hub-Daemon per Default auf Port **25463**, Pfad `/hub`; Health: `curl http://127.0.0.1:25463/health` → `{"ok":true, coreVersion 0.0.83, url ws://127.0.0.1:25463/hub}`. Laufen die Sidecars, respawnet die laufende cline-app sie automatisch.
- **Fix-Einzeiler:** `pkill -f code-sidecar; osascript -e 'quit app "Cline"'; sleep 2; open -a Cline`
- **Landkarten-Fallen:** `~/Library/Application Support/cline-app/` existiert nicht; echte App-Daten in `/var/folders/.../T/bot.cline.app` (+ WebKit-Sandboxes). `~/.cline/` im Home ist NICHT die App, sondern Saschas eigene LOKI-Config (CLAUDE.md, skills, cron …) — nicht anfassen.
- Verwandt: [[macos-27-beta-status]] (dort anderes Cline-Problem: AMFI-Signing nach npm-Updates).
