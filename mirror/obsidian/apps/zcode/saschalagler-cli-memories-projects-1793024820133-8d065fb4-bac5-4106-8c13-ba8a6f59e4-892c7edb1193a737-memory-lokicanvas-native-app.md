---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/lokicanvas-native-app.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: lokicanvas-native-app
description: Aktives Projekt (30.10.) — LokiCanvas native SwiftUI-Mac-App in
  ~/agent-os/agent-mirror/LokiCanvas; .app läuft, 27/27 Tests, KI über lokales
  Ollama (nur qwen2.5-coder:7b真的 installiert); Commit 628ced708 lokal, Push von
  Guardrail blockiert
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Seit 30.10.2026: Sascha wollte den Product-Canvas-Nachbau NICHT als Web/localhost-App, sondern **eigenständige native macOS-App** mit seinen lokalen Ollama-Modellen („multiplayer völlig egal"). Ergebnis: **LokiCanvas** — echte SwiftUI-Mac-App, gebaut ohne Xcode.

**Stand 30.10.2026 (alles bewiesen):**
- Pfad: `~/agent-os/agent-mirror/LokiCanvas/` (Teil des agent-mirror-Repos, Branch `cline/s4sx83cs`, Remote github.com/Koerperfluss/agent-mirror.git)
- `.app`: `build/LokiCanvas.app` (make_app.sh, ad-hoc signiert, Mic-Purpose in Info.plist) — Doppelklick/Dock, kein Browser/localhost/Firebase/Gemini
- 27/27 Tests in 6 Suiten (Swift Testing; `bash run_tests.sh` mit CLT-testing-Plugin-Pfad)
- Features: unendliche Canvas (Pan/Zoom 25–400 %), Node-Typen Text/Skizze/Bild/KI/Prototyp, deutsche Voice-Befehle (VoiceParser+VoiceAgent on-device), Auto-Persistenz `~/Documents/LokiCanvas/autosave.json`, Modell-Statusleiste
- Commit `628ced708` liegt LOKAL; **git push wurde vom Guardrail-Hook blockiert** (nach 1 fehlgeschlagenem Erst-Push werden wiederholte Pushes gesperrt) — Push von Sascha/Cline manuell nachholen.

**Ollama-Lage (30.10.):** Nur `qwen2.5-coder:7b` (+1.5b) wirklich installiert und antwortet (= LocalModels.chat UND .coder). `qwen3.5:9b` und `qwen3-vl:8b` haben nur Manifeste — **Blobs fehlen** (7,2 GB gesamt; 9b/vl je ~5 GB weg) → Statusleiste rot; Fix: `ollama pull qwen3.5:9b`. glm-*-cloud = Abo-Limit. Mac hat 11,8 GiB VRAM.
**Ollama-Start-Falle:** `nohup ollama serve` kennt die Modelle NICHT (anderer Kontext) — immer via `open -a Ollama` starten (LaunchAgent com.ollama.ollama registriert).

**Kollisions-Falle:** Tests crashen mit Signal 6, wenn die LokiCanvas-App gleichzeitig läuft (Speech-Freigabe-Kollision) → vor `run_tests.sh` App schließen.

**Nebenbeweis:** TraktorClone (`~/agent-os/agent-mirror/TraktorClone/`) = bewährtes SwiftPM+handgebaut-Bundle-Muster (83/83 Tests) — Vorlage für weitere native Apps ohne Xcode.

**Why:** Hauptprojekt; Build-Tricks, Ollama-Modell-Lücke und Guardrail-Verhalten sind aus keinem Repo ableitbar. Verwandt: [[product-canvas-rebuild]], [[clt-swiftui-no-state]], [[simple-language-responses]].
