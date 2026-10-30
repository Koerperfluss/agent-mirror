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

**Auch CLT 27.2 (30.10. installiert) enthält SwiftUIMacros NICHT** — per `find` verifiziert. „Einfach CLT aktualisieren" löst das @State-Problem nicht; nur volles Xcode brächte das Plugin. Makrofreie SwiftUI-UIs bleiben der Standard-Weg auf diesem Mac.

**Kern-Falle:** `@State` ist im aktuellen SDK ein externes Makro (Modul `SwiftUIMacros`), dessen Plugin **nur mit Xcode ausgeliefert wird** — Fehler: „external macro implementation type 'SwiftUIMacros.StateMacro' could not be found". Behebung ohne Xcode:
- **Nie `@State` schreiben.** Stattdessen je View eine kleine `@MainActor final class XUIState: ObservableObject { @Published var … }` + `@StateObject private var ui = XUIState()` — @StateObject/@EnvironmentObject/@Published sind KEINE Makros und laufen (genau so baut TraktorClone).
- Swift-Testing braucht Plugin-Pfad: `swift test -Xswiftc -plugin-path -Xswiftc /Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing` (steht in run_tests.sh von TraktorClone/LokiCanvas).

**Weitere CLT/macOS-Fallen (30.10. bewiesen):**
- **XCTest existiert in CLT NICHT** („unable to resolve module dependency: 'XCTest'") — Test-Dateien müssen Swift-Testing sein (`import Testing`, `@Test`, `#expect`, `@Suite`).
- Mikro/Audio-Live-Calls (VoiceAgent.start()) in der Batch-Testsuite → Testing-Helper-Abort (Signal 6, auch ohne laufende App nicht immer reproduzierbar) → Suites mikrophonfrei halten (nur process()/Startzustand prüfen).
- `AVAudioSession` ist iOS-only → auf macOS die Session-Zeilen weglassen; AVAudioEngine läuft direkt.
- Swift 6 strict concurrency: unveränderliche Clients (nur `let`-Props) als `: Sendable` deklarieren, sonst „sending 'self.client' risks causing data races" in Tasks.
- Bundle per Hand: `swift build -c release` + Info.plist (CFBundleExecutable, NSMicrophoneUsageDescription) + `codesign --force --sign -`.
- Test-Runner kann mit Signal 6 crashen, wenn eine App mit SFSpeechRecognizer gleichzeitig läuft → App vorher schließen (LokiCanvas-Fall: App schließen reichte).

**Why:** Diese Blocker kosten jede Session sonst 30+ Min Fehlersuche. Verwandt: [[lokicanvas-native-app]].
