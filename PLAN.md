# PLAN — TraktorClone (macOS DJ-App)

**Ziel:** Eigenständige, funktionsgleichwertige DJ-App (Traktor-Pro-4-Referenz) für macOS — Swift/CoreAudio/CoreMIDI.
**Methodik:** AGENTS.md-Vertrag + RE_METHODOLOGY.md · loki-dev BUILD · gsd-core Slices.
**DONE-WHEN gesamt:** FEATURES.json vollständig implemented+passed oder blocked mit Begründung.

## Slice 1 (diese Session) — 2-Deck-App-Fundament

| # | Task | Akzeptanzkriterium (DONE-WHEN) | Fortschritt |
|---|---|---|---|
| T1 | FEATURES-Inventar + PLAN + STATE | Dateien im Repo, Inventar ≥ 25 Funktionen | ✅ |
| T2 | Core-Package: DeckState, Mixer, BeatGrid, TSIParser, AudioEngine, MIDIActionRouter | `swift build` Exit 0 | ✅ |
| T3 | XCTest-Suite | `swift test` 0 fail (Ralph-Loop max 5 Iter.) | ✅ |
| T4 | SwiftUI-App: 2 Decks, Mixer, fileImporter, CoreMIDI-In, Tastatur | App-Target baut, startbar | ✅ |
| T5 | Review (Security/Logic/Perf/Arch) | Findings-Tabelle + Fixes committed | ✅ |
| T6 | TEST-REPORT + Push | Commit auf cline/s4sx83cs | ✅ |

## Architektur (Architect-Mode-Entscheidungen)

- **Ein SwiftPM-Package**: `TraktorCloneCore` (Library, testbar) + `TraktorCloneApp` (executable, SwiftUI) + Tests.
- **Audio:** AVFoundation — AVAudioEngine + AVAudioPlayerNode + AVAudioUnitTimePitch pro Deck (Pitch+Keylock nativ).
- **MIDI:** CoreMIDI-Input → `MIDIActionRouter` (reine Logik, testbar); UI koppelt Router an Decks.
- **Keine Dependencies** (ponytail): nur Foundation/AVFoundation/CoreMIDI/SwiftUI.
- **Ehrlichkeit:** „vollständig" = FEATURES.json-Umfang; nicht implementiertes steht mit `blocked`/`not_started` drin (Ehrlichkeitsregel aus RE_METHODOLOGY).

## Slices 2+ (offene Tickets, nach SIZE sortiert)

S2 Browser+Library (collection.nml lesen) · S3 Waveform-Rendering + Beatgrid-Overlay · S4 Effekte (Filter/Echo/Delay als AudioUnits) · S5 Recording + Mixdown · S6 Stems (Playback 4-Spur) · S7 DVS/Timecode (BD-1380 ist Riemenantrieb → Dokumentation: kein echtes DVS möglich) · S8 Sync-Engine (Beatmatching) · S9 Auto-DJ/Playlists
