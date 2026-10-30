# agent-os (zcode)

Zuletzt gespiegelt: 2026-10-30 02:08 UTC

## plan-session_58f3f4bfcb9a88671e0595593de28702

# Plan: LokiCanvas — native macOS-KI-Canvas-App (Google-Canvas-Klon, 100 % lokal)

**Ziel:** Eigenständige native macOS-App nach Google-Canvas-Vorbild: unendliche Canvas mit Nodes (Skizze, Text, Bild, KI), KI-Skizzen/Analyse, Sprach-Agent, Prototyp-Generator — **komplett lokal über Ollama** (qwen3.5:9b Chat, qwen3-vl:8b Vision, qwen2.5-coder:7b Code — alle heute live bewiesen). Kein Gemini-Key, kein Multiplayer, kein localhost-Browser: echte `.app` im Dock, 24/7.

**Beweiste Basis aus dieser Session:** Ollama :11434 🟢 mit allen 3 Modellen · SwiftPM+native-Bundle-Pattern bewiesen (TraktorClone: 70 Tests, laufende .app) · Dark-Theme-Tokens wiederverwendbar.

## Architektur (bewährtes TraktorClone-Muster)

```
agent-mirror/LokiCanvas/
├── Package.swift              # LokiCanvasCore (Lib) + LokiCanvasApp (executable) + Tests
├── Sources/LokiCanvasCore/
│   ├── OllamaClient.swift     # POST /api/chat (stream=false), Model-Whitelist, Timeout, Vision via base64-Bild
│   ├── NodeModel.swift        # Node-Typen: sketch/text/image/ai/prototype + Position/Size/Content
│   ├── CanvasDocument.swift   # JSON-Persistenz ~/Documents/LokiCanvas/*.json (Nodes, Verbindungen)
│   ├── PrototypeGenerator.swift # Sketch/Bild+Prompt → qwen2.5-coder → Code (SwiftUI/HTML), sanitisiert
│   ├── VoiceAgent.swift       # SFSpeechRecognizer on-device (de-DE) → Text → OllamaChat
│   └── Theme.swift            # Dark-Tokens (aus TraktorClone wiederverwendet)
├── Sources/LokiCanvasApp/
│   ├── LokiCanvasApp.swift    # @main, Fenster 1200×800
│   ├── ContentView.swift      # unendliche Canvas (MagnificationGesture+Drag), Node-Layer, Toolbar
│   ├── NodeView.swift         # je Typ: Skizze (NSBezierPath-Zeichnen), Text, Bild, AI-Output, Proto-Vorschau
│   └── InspectorView.swift    # Prompt-Eingabe, Modell-Wahl, Voice-Button (🔴 Aufnahme)
├── Tests/                     # Swift Testing: OllamaClient-Parsing (Mock), NodeModel, Document-Roundtrip, Generator-Sanitizer, Voice-Textverarbeitung
├── run_tests.sh               # CLT-Plugin-Fix (bewiesen)
└── make_app.sh                # → build/LokiCanvas.app, ad-hoc signiert, Info.plist mit Mic-Purpose
```

## Kernfunktionen (Canvas-Feature-Parität, Multiplayer ausgelassen)

1. **Unendliche Canvas**: Pan (Space+Drag/2-Finger), Zoom 25–400 %, Snap-Grid
2. **Node-Typen**: Skizze (frei zeichnen, Farben, Radierer), Text (Markdown), Bild (Drag&Drop/File), AI-Node (Prompt→Antwort), Prototyp-Node (Bild+Prompt→Code-Vorschau)
3. **KI-Skizzen**: qwen3-vl:8b analysiert Skizze/Bild („was siehst du?") → Ergebnis in AI-Node
4. **Prototyp-Generator**: qwen2.5-coder:7b generiert aus Skizze+Prompt lauffähigen Code, Code-Fence-Sanitizer, Vorschau im Node
5. **Sprach-Agent**: macOS-Speech on-device → Transcript → Ollama → Antwort-Node (Button in Toolbar)
6. **Dokumente**: Auto-Save JSON in ~/Documents/LokiCanvas, Öffnen-Dialog, mehrere Dokumente
7. **Modell-Statusleiste**: grün/rot je Ollama-Modell (Health-Check beim Start)
8. **24/7**: LokiCanvas.app nativ (kein Server, kein Port), optional LaunchAgent-Autostart-Hinweis in README

## Qualitäts-Gates
Swift-Testing-Suite grün (≥15 Tests) → Build complete → make_app.sh → App-Start mit PID-Beweis → README mit Bedienung → Commit+Push auf cline/s4sx83cs.

## Ehrliche Grenzen
- Sprache: SFSpeechRecognizer on-device braucht einmaligen Mic-Zugriff (macOS-Dialog, kein Key)
- Ollama muss laufen (läuft 24/7 bei dir, LaunchAgent vorhanden); App zeigt klaren Offline-Hinweis, startet aber trotzdem
- Keine Cloud, kein Multiplayer, keine Accounts — wie gefordert

**Aufwand:** ~2–3 h Director-Bau (Subagenten verfügbar, aber ein zusammenhängendes UI-Paket ist als Einzelbau schneller). Los nach GO.
