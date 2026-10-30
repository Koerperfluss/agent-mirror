---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/lokicanvas-native-app.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: lokicanvas-native-app
description: Aktives Projekt (30.10.) — LokiCanvas native SwiftUI-Mac-App v1.1;
  Vision-Analyse eingebaut, 32/32 Tests, ALLE 3 Ollama-Modelle installiert und
  bewiesen; Commits 628ced708+26da6f987 lokal, Push von Guardrail blockiert
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Seit 30.10.2026: Sascha wollte den Product-Canvas-Nachbau NICHT als Web/localhost-App, sondern **eigenständige native macOS-App** mit seinen lokalen Ollama-Modellen („multiplayer völlig egal"). Ergebnis: **LokiCanvas** — echte SwiftUI-Mac-App, gebaut ohne Xcode.

**Stand 30.10.2026 (v1.1, alles bewiesen):**
- Pfad: `~/agent-os/agent-mirror/LokiCanvas/` (agent-mirror-Repo, Branch `cline/s4sx83cs`, Remote github.com/Koerperfluss/agent-mirror.git)
- `.app`: `build/LokiCanvas.app` (make_app.sh, ad-hoc signiert, Mic-Purpose) — läuft nativ
- **32/32 Tests in 7 Suiten** (Swift Testing; `bash run_tests.sh` mit CLT-testing-Plugin-Pfad)
- Features: unendliche Canvas (Pan/Zoom 25–400 % kumulativ), Nodes Text/Skizze/Bild/KI/Prototyp, **NEU v1.1: Vision-Analyse** (Bild-/Skizzen-Node im Inspector „Analysieren → KI-Node", qwen3-vl via OllamaClient.vision; Stroke-Render-Hilfe in VisionSupport.swift, ImageUtil.swift in Core), deutsche Voice-Befehle, Auto-Persistenz `~/Documents/LokiCanvas/autosave.json`, Modell-Statusleiste
- Commits `628ced708` + `26da6f987` liegen LOKAL; **git push vom Guardrail-Hook blockiert** (wiederholte Pushes nach Erst-Fehlschlag gesperrt) — Sascha/Cline manuell nachholen.

**QA-Team-Ergebnis (30.10., Reviewer-Agent, alle gefixt):** Stroke-Zeichnen hatte invertierte Bedingung (unsichtbare 1-Punkt-Strokes; Fix: ui.strokeFinished-Flag) · VoiceAgent crashte beim 2. start() (removeTap onBus:0 in stop()) · NSEvent-Scroll-Monitor frass alle Scroll-Events (Fix: nur CMD abfangen + removeMonitor in onDisappear) · Pinch-Zoom war multiplikativ-kompoundierend (Fix: pinchBase kumulativ + zoomTo) · Autosave-Deckung pan/zoomBy + willTerminate-Flush · Bild-Grenze 8 MB + NSImage-Check · Label „(Entf)" entfernt (kein Shortcut gebaut).

**Ollama (30.10. abends):** ALLE 3 Modelle installiert und bewiesen — `qwen3.5:9b` Chat-Antwort live („Von Nutzern erstellte interaktive App", 250 s Kaltladung), `qwen3-vl:8b` geladen (8,4 GB VRAM), `qwen2.5-coder:7b` schnell. Reparatur der früheren Blob-Lücken: `curl -X POST :11434/api/pull -d '{"name":"…"}'` (fehlte nur Manifest/Blob-Nachzug).
**RAM-Grenze:** Mac hat nur 17 GB RAM, Swap 10/10 GB voll (Fusion+Drucker+Agenten-Sessions) — **9b und vl NICHT gleichzeitig im RAM** (Vision-Inference im Swap-Sumpf >590 s ohne Antwort); Entladen via `/api/generate {"model":…,"keep_alive":0}`. glm-*-cloud = Abo-Limit.
**Ollama-Start-Falle:** `nohup ollama serve` kennt die Modelle NICHT — immer `open -a Ollama`.

**Kollisions-Fallen:** Tests crashen mit Signal 6, wenn die LokiCanvas-App gleichzeitig läuft → App schließen vor run_tests.sh. Mikro-Live-Calls (start()) in der Batch-Suite ebenda Abort → VoiceAgentTests sind mikrophonfrei (nur process()/Startzustand).

**Nebenbefund:** TraktorClone (`~/agent-os/agent-mirror/TraktorClone/`, 83/83 Tests) = Vorlagen-Muster; eine Parallel-Cline-Session arbeitet dort (UI-Modernisierung, CLT-27.2-Installer) — Bildschirm-Fokus-Kriege bei Screenshots möglich.

**Feature-Paritäts-Lücken vs. Google-Original (30.10. analysiert, offen):**
- **Flag-/Wiki-Knoten fehlen** (Original „+"-Menü: Personas · User Goals 🚩 · Tech stack · Design ideas · Prototype) — reine UI/Logik, lokal machbar; als nächster Feature-Slice vorgeschlagen (~20 Min), noch nicht gebaut.
- **Bild-ERZEUGUNG (Nano-Banana-Äquivalent) unmöglich mit Ollama** — Ollama kann nur Text/Vision, keine Diffusion. Bräuchte Zusatz-Tool (ComfyUI/Draw Things); Sascha noch nicht entschieden.
- Live-Sprach-Agent (Gemini Live, Cloud) = bewusst durch on-device Speech ersetzt.
- App läuft als PID bewiesen; Frage nach dauerhafter Kopie nach /Applications/Dock noch offen (nur auf GO).

**Why:** Hauptprojekt; QA-Fixliste, Ollama-RAM-Grenze und Guardrail-Verhalten sind aus keinem Repo ableitbar. Verwandt: [[product-canvas-rebuild]], [[clt-swiftui-no-state]], [[simple-language-responses]].
