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

Git (Stand 2026-10-26, spät): Head `a30349657` auf `cline/s4sx83cs` (github.com/Koerperfluss/agent-mirror, gh auth Koerperfluss). Kanonische Arbeitskopie: `~/agent-os/agent-mirror` (Klon; Projektinhalt am Repo-ROOT). **Slices 1–7 der Traktor-App FERTIG (54/54 Tests, 9 Suites) in `TraktorClone/` SwiftPM:** Slice 1 = Core (DeckState mit `now:`-Clock-Param überall, Mixer equal-power gesnappt, BeatGrid, TSIParser, MIDIActionRouter) + SwiftUI 2-Deck-App. **Slices 2–7 (Commit 42810482f) + Review-Fixes (a30349657):** NMLParser+LibrarySearch (echte collection.nml ist LEER, `ENTRIES="0"`), WaveformExtractor (400 Buckets, Peak, normalisiert) + AudioEngine.seek (`player.scheduleSegment(file, startingFrame:, frameCount:, at: nil)` — `at:` ist PFLICHT-Param, plus `file.length - target > 0`-Guard), FxChain (EQ/Delay/Reverb, Kette player→timePitch→EQ→Delay→Reverb→Mixer; Reverb-Preset nur bei Wechsel laden), SyncEngine (slavePitch clamp ±0.5, beatPhase), MasterRecorder (`isRecording = true` VOR installTap; Write-Fehler NSLog statt still), StemFile (lazy Tracks — kein Sync-I/O im init; Playback-Engine = Ticket 7b), MIDILearn/MappingStore (JSONEncoder MUSS `.sortedKeys+.prettyPrinted` für Stabilität), `make_app.sh` → **klickbares `build/TraktorClone.app`** (ad-hoc codesign, ohne Xcode). `.build/`+`build/` sind gegitignored (Artefakte waren committet). App-UI: Waveform-Canvas+Klick-Seek (via onTapGesture(CGPoint)+GeometryReader, kein @State — Ternary in .buttonStyle geht nicht), FX-Slider, Sync-Buttons, Rec, Library mit „→ A"/„→ B". **Reviewer-Veto durchlief das Team** (cavecrew-builder als Ersatz-Reviewer): REQUEST_CHANGES → 7 Findings alle gefixt. **Neue API-Fallen:** `AVLinearPCMIsSignedIntegerKey` existiert nicht im CLT-SDK; AVAudioUnitEQ hat kein `numberOfBands` (nur `bands.count`); `AVAudioFile` kein `duration` (length/sampleRate); `#expect(throws: ())` invalid → `(any Error).self`. **Known-Gaps:** Play-after-Pause startet an Schedule- statt Playhead-Position (playerTime-Sync fehlt), Stem-Playback offen, xcodebuild fehlt (nur CLT → kein Codesigning/Xcode-Projekt). 27/54 FEATURES implemented. `rebuild/STATE.md` führt weiter (nächste: Slice 7b oder Playhead-Präzision). Sascha pocht auf die fertige App mit ALLEN Funktionen — Prioritäts-/Team-Fragen stoßen ihn auf („wieso fragst du mich das ich will fertige app"); Spark-Aufgaben (README-Schritte A–D) sind für ihn irrelevant.

Saschas Custom-Skills (/roocode, /coderabbit, /gsd-core, /lokidev, /appagentteam): NICHT als ZCode-Skills registriert, aber als Dateien vorhanden — Manuell-Ausführung akzeptiert, siehe [[custom-skills-read-from-autoclaw]]. Hardware-Kette: Omnitronic BD-1380 USB (class-compliant → ALSA `snd-usb-audio` am Pi) + analoger A&H Xone:32 (keine Soundkarte); Traktor Pro selbst = macOS/Windows (CoreAudio/ASIO), kein ALSA. Siehe [[mimosa-hook-write-constraints]].

Methodik (2026-10-26, aus Saschas PDFs `~/Desktop/Reverse Engeniering /`): `docs/RE_METHODOLOGY.md` (12-Schritte-Funktionsgleichheit auf Traktor 4.5 gemappt) + `AGENTS.md` im Root = verbindlicher app-rebuild-Arbeitsvertrag für Agenten (FEATURES.json-Schema, rebuild/STATE.md-Checkpoints, Abschlussgate, keine Mocks als fertig). pi_re_client hat Task `rebuild` (Prüfblatt-Analyse, BEOBACHTUNG/HYPOTHESE/[VORSCHLAG]-Trennung); 13 Unit-Tests grün, letzter Commit `7b2c68e`. PDF-Dateiname-Falle: „reverse engineering .pdf" hat ein Leerzeichen vor der Endung. Wichtig: BD-1380 hat Riemenantrieb → kein echter DVS/Timecode-Turntable für Scratch.
