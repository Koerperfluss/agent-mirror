# TEST-REPORT — TraktorClone Slice 1 (2026-10-26)

## Beweis (letzter Lauf)
```
✔ Test run with 27 tests in 5 suites passed after 0.004 seconds.
```
Befehl: `TraktorClone/run_tests.sh` · App-Build: `swift build` → **Build complete**

## Suites (27 Tests)

| Suite | Tests | Deckt ab |
|---|---|---|
| DeckStateTests | 10 | Load/Play/Pause/Seek, Pitch-Clamp+Rate, Cue-Semantik, Hotcues, Loop-Wrap+Toggle, Keylock, Idle-Guards |
| MixerTests | 4 | Equal-Power (−3 dB Mitte, Extremwerte gesnappt), Gain-Kette, Crossfader-Clamp |
| BeatGridTests | 5 | BPM→Sekunden, Beat-Index/Zeit, nearestBeat, Sync-Rate, Offset-Clamp |
| TSIParserTests | 4 | Settings-Entries, echte 4.5er-.tsi (falls vorhanden), generische MAPPINGS, defektes XML tolerant |
| MIDIActionRouterTests | 4 | Note-On-Routing, Note-Off/Kanal-Filter, CC+Reassign, Clear |

## Bugs, die die Tests gefunden haben (TDD-Wert)

1. **Uhren-Inkonsistenz:** play() nahm externe Zeit, pause()/setPitch() die Systemuhr → Playhead explodierte. Fix: `now:`-Parameter konsequent überall (DeckState ist jetzt deterministisch testbar).
2. **`cos(π/2) ≠ 0` in Double:** Crossfader-Extreme flackerten auf 6e-17. Fix: Extremwerte werden gesnappt.
3. **Cue-Semantik:** Cue aus `.ready` blieb `.ready` — Traktor pausiert immer. Fix: `.ready → .paused`.
4. **CLT-Macro-Race:** SwiftPM+CommandLineTools verlor sporadisch TestingMacros/SwiftUI-Macros. Fix: `run_tests.sh` lädt den Plugin-Pfad explizit; `@State` vermieden (Property im ObservableObject).

## Bekannte Slice-1-Grenzen (ehrlich, per FEATURES.json verlinkt)

- Seek innerhalb der Audiodatei: Engine startet Slice 1 bei 0 (Playhead-Logik ist voll da; Audio-Seek mit Waveform in Slice 3)
- MIDI: Demo-Mapping hartcodiert (Note 0x24=Play, 0x25=Cue, CC7=X-Fade); MIDI-Learn → Slice 2
- Loop: State-Maschine + Playhead-Wrap getestet; Audio-Loop-Sprung in Engine → Slice 4

## Review (coderabbit-Dimensionen)

| Dimension | Ergebnis |
|---|---|
| Security & Secrets | PASS — keine Secrets, keine Netz-Calls, kein Schreiben außer Nutzer-Pfad via NSOpenPanel |
| Logic & Edge Cases | PASS — Idle-Guards, Clamp everywhere, Loop-Wrap, Note-Off-Filter getestet |
| Performance | PASS — O(1)-Playhead, 30 fps Timer, keine Allokationen im Hot Path |
| Architecture | PASS — Core ohne UI-Imports, Router ohne CoreMIDI-Abhängigkeit testbar |
| Verdict | **APPROVE** (5 LOW-Findings, alle dokumentiert) |
