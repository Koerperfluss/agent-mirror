---
name: clt-swiftui-no-state
description: macOS hat NUR Command Line Tools (kein Xcode) — @State ist externes
  SwiftUIMacros-Makro und schlägt fehl; SwiftUI-UIs müssen
  @Published-ObservableObject + @StateObject nutzen (TraktorClone-Muster);
  weitere CLT-Fallen
metadata:
  node_type: memory
  type: reference
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Saschas Mac hat **kein Xcode.app, nur CommandLineTools** (xcode-select → /Library/Developer/CommandLineTools; kein Xcode*.app auf Platte, kein .xip in Downloads).

**Kern-Falle:** `@State` ist im aktuellen SDK ein externes Makro (Modul `SwiftUIMacros`), dessen Plugin **nur mit Xcode ausgeliefert wird** — Fehler: „external macro implementation type 'SwiftUIMacros.StateMacro' could not be found". Behebung ohne Xcode:
- **Nie `@State` schreiben.** Stattdessen je View eine kleine `@MainActor final class XUIState: ObservableObject { @Published var … }` + `@StateObject private var ui = XUIState()` — @StateObject/@EnvironmentObject/@Published sind KEINE Makros und laufen (genau so baut TraktorClone).
- Swift-Testing braucht Plugin-Pfad: `swift test -Xswiftc -plugin-path -Xswiftc /Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing` (steht in run_tests.sh von TraktorClone/LokiCanvas).

**Weitere CLT/macOS-Fallen (30.10. bewiesen):**
- `AVAudioSession` ist iOS-only → auf macOS die Session-Zeilen weglassen; AVAudioEngine läuft direkt.
- Swift 6 strict concurrency: unveränderliche Clients (nur `let`-Props) als `: Sendable` deklarieren, sonst „sending 'self.client' risks causing data races" in Tasks.
- Bundle per Hand: `swift build -c release` + Info.plist (CFBundleExecutable, NSMicrophoneUsageDescription) + `codesign --force --sign -`.
- Test-Runner kann mit Signal 6 crashen, wenn eine App mit SFSpeechRecognizer gleichzeitig läuft → App vorher schließen.

**Why:** Diese Blocker kosten jede Session sonst 30+ Min Fehlersuche. Verwandt: [[lokicanvas-native-app]].
