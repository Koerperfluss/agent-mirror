# Memory Index

- [Mimosa-Hook: Code-Dateien nur via Write-Tool](mimosa-hook-skills-write-tool.md) — Bash-Kopie von .py/.yaml nach ~/.claude/skills wird blockiert
- [UI/UX-Skills Reparatur 26.10.2026](uiux-skills-repair-2026-10-26.md) — Skills komplettiert + verdrahtet; HUB-Fixes erledigt (Backup da); offen: Backup-Watcher, Manifest, Stufe C
- [Einfache Sprache](simple-language-responses.md) — Sascha versteht fachliche Antworten oft nicht: radikal vereinfachen, max 3 Punkte, 1 Entscheidung pro Antwort
- [Lokale Browser-Tests](local-browser-testing-gotchas.md) — file:// blockiert → http.server; Cache-Buster; kein SPA-Fallback; agent-browser-CLI als Alternative
- [ZCode-Skills-Landschaft](zcode-skills-landscape.md) — 251 Slash-Befehle in ~/.zcode/commands/ (27.10. generiert), sichtbar erst nach App-Neustart; /workflow fest eingebaut; 11 Skill-Ordner kaputt
- [Product-Canvas-Nachbau](product-canvas-rebuild.md) — AKTIV: native Tauri-App „Product Canvas Local" gebaut (Firebase-Aliase → lokaler Shim); Browser-Beweis komplett, Tauri-Webview hängt noch im Loading
- [Tauri-2-Fallen](tauri-build-gotchas.md) — capabilities statt fs-scope, withGlobalTauri, --bundles app (DMG crasht), SPA-Hard-Nav = weiß, fehlende Named-Exports failen Rollup
- [gstack-Werkzeugkasten](gstack-toolkit.md) — ~/gstack = Garry Tans KI-Toolkit; bin/-Befehle laufen automatisch, nicht von Hand anfassen
- [LokiCanvas Native-App](lokicanvas-native-app.md) — FERTIG: SwiftUI-Mac-App läuft, 27/27 Tests, Ollama lokal (nur coder:7b echt, 9b/vl-Blobs fehlen), Push von Guardrail blockiert
- [CLT ohne Xcode: kein @State](clt-swiftui-no-state.md) — @State-Makro schlägt fehl → @Published+@StateObject-Muster; Testing-Plugin-Pfad; AVAudioSession iOS-only
