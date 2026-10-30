---
app: zcode
quelle: "saschalagler/workspace/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e46a/.zcode/plans/plan-session_3a1cc25ff2c2e82e01c329cebdb4fa22.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

# LokiCanvas zu Ende bauen — native SwiftUI-Mac-App, 100 % lokal (deine Ollama-Modelle)

## Verifizierte Basis (3 Erkundungs-Agenten, Pfad:Zeile-Beweise)
Core steht komplett (OllamaClient mit chat/vision/models · CanvasNode+Persistenz · PrototypeGenerator mit Sanitizer · Theme · VoiceParser) · **22 Tests grün-bereit** · TraktorClone-Bündel-Muster bewiesen (70 Tests + laufende .app auf genau diesem Mac, nur Command-Line-Tools nötig). **Es fehlt allein die App-Schicht + VoiceAgent.**

## Schritte

| # | Was | Beweis |
|---|---|---|
| 0 | **Ollama hochfahren** (LaunchAgent ist da, nur gestoppt) + Modelle verifizieren: qwen3.5:9b, qwen3.5-vl:8b, qwen2.5-coder:7b — Namen ggf. an Code-Whitelist angleichen | curl /api/tags + 1-Chat-Antwort |
| 1 | **2 Builder parallel** (ehrliche max. Parallelität — die 4 UI-Dateien sind ein Klettpaket, >2 Agenten würden sich nur ins Weg laufen): **B1 = App-Schicht** (LokiCanvasApp @main · ContentView mit unendlicher Canvas: Pan/Zoom 25–400 %/Node-Layer/Toolbar · NodeView für Skizze/Text/Bild/AI/Prototyp · InspectorView mit Prompt/Modell-Wahl/Voice-Button · nutzt Core-APIs unverändert) · **B2 = VoiceAgent.swift** (SFSpeechRecognizer on-device, deutsch → VoiceParser → Aktionen) + 4 neue Tests | Dateien + Test-Zähler ≥26 |
| 2 | **Integration + Gates**: Build-Fix (Target-Verzeichnis existiert dann), `swift test` komplett grün, `make_app.sh` → **LokiCanvas.app** (ad-hoc signiert, Info.plist mit Mikrofon-Freigabe-Text) | Exit-Codes + .app-Pfad |
| 3 | **Beweis-Batterie**: App per `open` starten (PID), Screenshot; Node anlegen + verschieben; **KI-Antwort von qwen3.5:9b landet im AI-Node**; App beenden+neu starten → **Daten bleiben** (autosave.json); Modell-Statusleiste grün | Screenshots + JSON-Datei |
| 4 | **Erste Versionierung**: LokiCanvas committen + pushen auf `cline/s4sx83cs` (bisher untracked) | Commit-Hash |

## Abnahme (beobachtbar)
Echte `.app` per Doppelklick · kein Browser/localhost/Firebase/Gemini · Daten überlebt Neustart · KI-Antworten aus deinen lokalen Modellen · 24/7 (App + optional Ollama-LaunchAgent läuft ohnehin dauerhaft).

## Ehrliche Grenzen (1 Zeile each)
- Mikrofon: 1× macOS-Dialog beim ersten Voice-Klick (kein Key, einmal bestätigen).
- Vision/Bild-Analyse braucht das exakte Modell in Ollama — Schritt 0 verifiziert, fehlt eines → klare Meldung statt Absturz (App läuft trotzdem).
- Nur CLT installiert — für diese native Mac-App bewiesen ausreichend (TraktorClone-Präzedenzfall).

## Zeit
**~60–120 Min.** (Core steht schon; Rest ist UI-Schicht + Bündel + Beweise). Backups: neue Dateien sind additive; bestehende Core-Dateien werden nicht angefasst außer VoiceAgent kommt NEU dazu.