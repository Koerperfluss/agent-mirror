# STATE — TraktorClone

**Stand:** 2026-10-26 · Slices 1–5 + 6 (Sync) + App-Bundle FERTIG · Stem-Playback offen
**Nächste Aktion:** Slice 7b — Stem-Playback-Engine (AVAssetReader-Pump → 4 PlayerNodes) ODER Play-after-Pause-Präzision (playerTime-Sync)
**Blockaden:** Subagent-Provider (GLM-5.3-Flash) down → Solo-Bau dokumentiert; hcom-Peers stale (16d)

## Bewiesener Stand
- **54/54 Tests in 9 Suites grün** (`TraktorClone/run_tests.sh`)
- **`build/TraktorClone.app` gebaut** (`make_app.sh`, ad-hoc signiert)
- Features live: 2 Decks + Waveform+Klick-Seek + FX (Filter/Delay/Reverb) + Sync (BPM-Pitch) + Master-Recording (AIFF) + Library (nml-Suche) + MIDI-Learn-Persistenz
- 4 neue Bugs durch TDD: scheduleSegments-API, AVLinearPCMIsSignedIntegerKey fehlt im SDK, @State-Macro-Race (Umgehung: keine @State), leere collection.nml-Semantik

## App nutzen (Lorenz)
```bash
cd agent-mirror/TraktorClone
./make_app.sh && open build/TraktorClone.app
./run_tests.sh
```

## Offene Tickets
- Slice 7b: Stem-Playback (StemFile-Struktur steht, Pump fehlt)
- Play-after-Pause: playerTime-basierter Resume
- Slice 9: Auto-DJ · Waveform-Zoom · MIDI-Learn-UI (Persistenz-Kern steht)
- README-Schritte A–D (Spark): irrelevant laut Nutzer, Tickets bleiben stehen

## Slice 7c (26.10., Team-Bau) — FERTIG
- StemPlayer (5 Nodes, Gain-Balance; Grenze: AVAudioFile liest nur Track 0 → Mix-Spur 5×, dokumentiert)
- AudioEngine: pause(deck:) mit playerTime-Rück sync, enableLoop/disableLoop (Timer-Retrigger, dokumentiert)
- DeckViewModel: Pause nutzt engine.pause → Play-after-Pause exakt am Playhead
- 62/62 Tests (11 Suiten), verified 26.10.
- Offen S8+: Auto-DJ, MIDI-Learn-UI, Waveform-Zoom

## Slice 8 (26.10.) — FERTIG
- Echter 4-Stem-Playback: StemPlayer.load konvertiert via StemExporter→Temp-WAVs, 5 eigene AVAudioFiles (Grenze behoben), Solo/Mute über Gains
- Beat-Phase-LED je Deck (beatPhase 0..1, blinkt auf dem Beat; Standard 120 BPM ohne BPM-Tag)
- MIDI-Learn-UI: Learn-Leiste (Play/Cue/HC1–4/X-Fade) → nächste MIDI-Botschaft zuweist, Persistenz mappings.json; Abbrechen-Button
- 62/62 Tests, App neu gebaut
- Offen S9: Auto-DJ, Waveform-Zoom

## Slice 9 (26.10.) — FERTIG (Kernfunktionen komplett)
- Auto-DJ: Toggle, 5s vor Ende wird nächster Library-Track ins andere Deck geladen+gestartet (AutoDJ round-robin, getestet)
- Beat-Loops: 1/2/4/8 Beats ab Position (setBeatLoop, Engine-Timer-Retrigger), Loop-Exit ✕
- Jog/Scrub: Waveform-Drag = kontinuierlicher Seek; Klick = Jump
- Waveform-Zoom 1x/2x/4x (Fenster um Playhead)
- Stem-Mixer: Mix+4 Stems Gain-Slider + Solo (bei .stem.mp4)
- VU-Meter je Deck (Peak-Tap an FX-Kette, 0,15s-Decay)
- 70/70 Tests (14 Suiten), Bundle neu, App läuft
- Offen: Waveform-Feinschliff (Beatgrid-Overlay), Cue-Persistenz
