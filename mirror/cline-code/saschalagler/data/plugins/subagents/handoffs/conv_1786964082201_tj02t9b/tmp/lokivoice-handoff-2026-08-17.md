# LokiVoice Handoff — Fix für permanente Selbst-Unterbrechung
Date: 2026-08-17 | Project: /Users/saschalagler/Desktop/LokiVoiceApp

## Ziel
LokiVoice (SwiftUI Menu-Bar-App, Gemini Live API via WebSocket, Stimme "Charon") unterbrach sich in jedem Satz. Ursache gefunden und behoben.

## Root Cause (analysiert & behoben)
NICHT das Token-Limit: Das Mikrofon streamte während der Audio-Ausgabe weiter an Gemini. Die VAD des Live-API hörte Lokis eigene Stimme (Lautsprecher-Echo), hielt sie für Nutzereingabe und brach den Turn ab ("interrupted"). Zusätzlich: System-Prompt sagte wörtlich "Rede so kurz und prägnant wie möglich", und `isSpeaking` wurde nie zurückgesetzt.

## Geändert in Sources/VoiceService.swift (Details → git diff / Datei)
- Halb-Duplex-Echo-Schutz: Mic-Frames werden verworfen, solange Audio-Buffer pending + 0,5s Nachlauf (`stateLock`, `pendingAudioBuffers`, `micMutedUntil`, `micUnmuteGrace`).
- `resetPlaybackState(clearQueue:)`: bei Server-`interrupted` wird `playerNode.stop()` aufgerufen und Audio-Queue geleert; bei `turnComplete` wird `isSpeaking=false` gesetzt (vorher nie passiert).
- `playAudioChunk`: Buffer-Completion-Handler dekrementiert Counter; auch bei `stopSession()` Cleanup.
- `maxOutputTokens`: 65536 (Live-API-Maximum).
- System-Prompt: "Vollständigkeit geht vor Kürze, brich niemals mitten im Satz ab".

## Build-Status
- Debug- und Release-Build OK (`swift build` / `-c release`).
- `build_app.sh` lief erfolgreich; App liegt unter `/Users/saschalagler/Desktop/LokiVoiceApp/LokiVoice.app` (ad-hoc signiert).
- Vorheriges Bundle-Problem (kLSNoExecutableErr) war stale Bundle — gelöst via rm -rf + rebuild.
- WARNUNG: `swift build -c release` in run_commands kann in 30s-Timeout laufen → immer via start_background_command ausführen.

## Offen / Next
1. **Verifikation durch User noch ausstehend**: App starten (`open LokiVoice.app`), testen ob Unterbrechungen weg sind. Falls persistierend: Kopfhörer? → VAD-Konfiguration prüfen (`realtimeInputConfig`, evtl. `automaticActivityDetection` deaktivieren).
2. Falls weiterhin kurz: Setup-Config / System-Instruction iterieren.
3. Side Quest (abgebrochen, low priority): Skills-Setup (Issue-Tracker/Triage/Domain-Docs) für BEIDE Projekte Judicario_Sacha_Mac + LokiVoiceApp — User hatte "beide" bestätigt, lokaler Markdown-Tracker empfohlen (kein GitHub-Repo, gh-Token invalid).

## Kontext-Notizen
- LokiVoice gehört zur Legal-Ops/Thomas/Judicario/Chipsi-Voice-Stack (Layer 1 STT = faster-whisper; LokiVoice = Gemini-Live-Pfad). User verwechselt Session-Drift zwischen Projekten — Projekt-Kontext bestätigen vor Tangenten.
- `scheduleApplicationNotification`-Log ist benigne LaunchServices-Warnung, kein Crash.
- macOS-Bug im Code dokumentiert: Tap muss VOR `audioEngine.start()` installiert werden.

## Suggested Skills
- `diagnosing-bugs` — falls die Unterbrechungen nach Echo-Gating persistieren (VAD-Tuning als nächster Verdächtiger).
- `grill-me` / `to-tickets` — falls Side-Quest Skills-Setup für beide Projekte fortgesetzt wird.
- `projects` — Projekt-Kontext-Verwechslungen zwischen LokiVoice und Judicario vermeiden.

## Sensitives
API-Key liegt in der App/Umgebung — nicht in Logs/Dokumenten kopieren. Keine Keys in diesem Doc.
