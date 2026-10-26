---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/qwen-flash-spark-project.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: qwen-flash-spark-project
description: qwen-flash-spark — Qwen3.8-Flash-Next auf DGX Spark für
  Traktor-Clone; Pfade, Git, verifizierte Fakten
metadata:
  node_type: memory
  type: project
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

Projekt `~/qwen-flash-spark` (Stand 2026-10-26): Qwen3.8-Flash-Next (125B MoE, 6B aktiv, Gated-DeltaNet/QSA-Hybrid) läuft als llama-server auf Saschas DGX Spark (GB10, 128 GB, :8080); Mac/Pi = Client (pi_benchmark.py, pi_re_client.py mit Tasks hid/mapping/capture/format/codegen). **Endziel: eigener Traktor-Pro-4-Clone auf macOS (Swift/CoreAudio/CoreMIDI)** — Repo ist zugleich Anleitung für Lorenz (docs/LORENZ_GUIDE.md).

Verifizierte Fakten (nicht raten): Traktor `Traktor Settings.tsi` = **Plain-XML** (`<NIXML><Entry …/>`), kein Binär-RE nötig; GGUF `unsloth/Qwen3.8-Flash-Next-GGUF`, **UD-Q4_K_XL = 111 GB** (alte ~78-GB-Schätzung war falsch; Q5 passt nicht in 128 GB); MTP-Flag `--spec-type draft-mtp`; GB10-Runtime-Pflichtflags `-ub 2048 -b 2048 --no-mmap`; llama.cpp-Support seit PR #16095/#17584. Clients blocken private IPs (SSRF-Guard) → LAN-Nutzung braucht `QFS_ALLOW_LAN=1` oder `--allow-lan`.

Git (Stand 2026-10-26, spät): Head `2a68dcbdb` auf `cline/s4sx83cs` (github.com/Koerperfluss/agent-mirror, gh auth Koerperfluss). Kanonische Arbeitskopie: `~/agent-os/agent-mirror` (Klon; Projektinhalt am Repo-ROOT). **Slice 1 der Traktor-App FERTIG:** `TraktorClone/` SwiftPM-Package — Core (DeckState-Zustandsmaschine mit `now:`-Clock-Param überall, Mixer equal-power mit gesnappten Extremen, BeatGrid, TSIParser, AudioEngine AVAudioEngine+TimePitch, MIDIActionRouter) + SwiftUI-App `swift run TraktorCloneApp` (2 Decks, Mixer, CoreMIDI-Live-In, Demo-Mapping Note 0x24=Play/0x25=Cue/CC7=X-Fade, Tastatur Q/W/E + U/I/O). **27/27 Tests grün** via `TraktorClone/run_tests.sh`; 4 TDD-Bugs gefixt (Uhren-Inkonsistenz, cos(π/2)≠0, Cue aus .ready→.paused, CLT-Macro-Race). Swift/CLT-Fakten: reine CommandLineTools haben kein XCTest → **Swift Testing** (`import Testing`, `#expect`, tools-version 6.0); Macro-Plugin-Race („TestingMacros not found") → fix via `-Xswiftc -plugin-path -Xswiftc /Library/Developer/CommandLineTools/usr/lib/swift/host/plugins/testing` (in run_tests.sh); `@State` ist im neuen SDK ein Makro → Property ins ObservableObject statt `@State` (SwiftUIMacros-Race); `AVAudioFile` hat kein `duration` (length/sampleRate). 14/29 FEATURES.json implemented, DVS blocked (BD-1380 Riemenantrieb), nächster: Slice 2 (Library/collection.nml-Reader) oder Slice 3 (Waveform+Seek) — `rebuild/STATE.md` führt weiter. Sascha pocht darauf, die App wirklich zu bauen (nicht nur Doku/Skripte).

Saschas Custom-Skills (/roocode, /coderabbit, /gsd-core, /lokidev, /appagentteam): NICHT als ZCode-Skills registriert, aber als Dateien vorhanden — Manuell-Ausführung akzeptiert, siehe [[custom-skills-read-from-autoclaw]]. Hardware-Kette: Omnitronic BD-1380 USB (class-compliant → ALSA `snd-usb-audio` am Pi) + analoger A&H Xone:32 (keine Soundkarte); Traktor Pro selbst = macOS/Windows (CoreAudio/ASIO), kein ALSA. Siehe [[mimosa-hook-write-constraints]].

Methodik (2026-10-26, aus Saschas PDFs `~/Desktop/Reverse Engeniering /`): `docs/RE_METHODOLOGY.md` (12-Schritte-Funktionsgleichheit auf Traktor 4.5 gemappt) + `AGENTS.md` im Root = verbindlicher app-rebuild-Arbeitsvertrag für Agenten (FEATURES.json-Schema, rebuild/STATE.md-Checkpoints, Abschlussgate, keine Mocks als fertig). pi_re_client hat Task `rebuild` (Prüfblatt-Analyse, BEOBACHTUNG/HYPOTHESE/[VORSCHLAG]-Trennung); 13 Unit-Tests grün, letzter Commit `7b2c68e`. PDF-Dateiname-Falle: „reverse engineering .pdf" hat ein Leerzeichen vor der Endung. Wichtig: BD-1380 hat Riemenantrieb → kein echter DVS/Timecode-Turntable für Scratch.
