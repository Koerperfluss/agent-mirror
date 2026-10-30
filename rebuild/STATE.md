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

## Slice 10 (26.10.) — FERTIG (Analyse & Gedächtnis)
- BPM-Detektion: PCM→Mono→RMS-Hüllkurve→Onsets→Autokorrelation, Fold 70–180 (synthetisch: 120→120, 90→90)
- Key-Detektion: Goertzel über 12 Pitch-Klassen (Okt. 2–5), Dur/Moll-Terz-Heuristik (A4-Sinus→A)
- TrackMemoryStore: Cue/Hotcues/BPM/Key pro Datei-Pfad (SHA256-Key) in AppSupport — überlebt Neustarts
- Auto-Analyse im Hintergrund beim Laden (90 s Material); Header zeigt „128 BPM · Am"
- Beatgrid-Overlay in der Waveform (Beat-Striche bei bekanntem BPM, zoomtreu)
- 83/83 Tests (16 Suiten; 13 neue)

## Slice 11 (30.10.) — FERTIG (Restaufwand + Ausbau)
- Beatgrid-Offset: Phasen-Schätzung aus Onset-Kurve (estimateFirstBeatOffset), TrackMemory + Overlay nutzen Offset
- Sync-Nudge: Sync → A/B = BPM + Beat-Phase (nudgeTarget wählt nächsten Kandidaten MIT Ziel-Phase)
- Waveform: Cue/Hotcue-Marker (5 Farben + Flags), Zoom-Bug gefixt (Playhead Mitte, Klick → Fensterzeit via WaveWindow)
- Playlists: PlaylistStore (JSON), Quelle-Menü, Auto-DJ-Quelle umschaltbar, ＋ pro Library-Zeile
- Treiber-Panel: CoreAudio-Geräteliste + System-Ausgangswechsel, MIDI-Mapping-Tabelle (Löschen/Export/Import)
- Spotify-Import: Web-API-Metadaten (Env-Keys) → Match gegen Library → als Playlist (KEIN Audio-Streaming, Spotify-AGB)
- CLT-Falle bestätigt: @State = SwiftUIMacros-Makro, im CLT nicht vorhanden → UI-Flags in EngineHost (@Published)
- 102/102 Tests (22 Suiten; 19 neue), F-030..F-036 in FEATURES.json

## Slice 12 (30.10.) — DVS (Timecode-Vinyl) — FERTIG (Core bewiesen)
- Nutzer-Korrektur übernommen: DVS geht auch mit Riemenantrieb — Timecode wird aus dem Phono-Signal gelesen
- TimecodeVinyl.swift: LFSR (23-Bit Traktor Scratch A/B + 20-Bit Serato 2A Konstanten), Position-LUT, Zero-Crossing-Bitstream-Decoder, Tonearm-Tiefpass (2×Carrier), Speed-EMA, Richtungswechsel→Revalidierung
- DVSController: Phono-Input (AVAudioEngine input tap) → Decoder je Deck; EngineHost-Timer 10 Hz: Absolute-Mode-Seek (Lead-in 1000 Codes) + applyPlatterSpeed (Pitch=rückwärts/Stop)
- AudioDevices: Input-Geräte + Default-Input setzen (Phono-Interface-Wahl); UI DVS-Zeile im Treiber-Panel mit A/B-Speedanzeige
- Beweis synthetisch: Position@1.0x, 1.5×-Speed, 5 %-Rauschen, Extrapolation, LFSR fwd/rev invers, LUT-Zuordnung — 108/108 Tests (24 Suiten)
- Ehrlich offen: Live-Kalibrierung am echten Vinyl braucht Phono-Interface (Traktor Audio gebraucht oder Behringer UFO202) + Mikrofon-Freigabe-Dialog
- Lizenz-Route: eigene Implementierung des öffentlich dokumentierten Signalformats (§ 40e UrhG / Art. 6 RL 2009/24/EG), kein fremder Code übernommen (xwax ist GPL, Mixxx GPL)
- Xcode-27.2-Hinweis: installiert die fehlenden SwiftUIMacros-Plugins (CLT-@State-Falle stirbt)

## Slice 13 (30.10.) — NI-TSI-Reader + DVS-Pegel + B-Deck-MIDI — FERTIG
- Nutzer-Kontext geklärt: Mac = Audio-Interface; BD-1380-USB bringt Phono-Preamp+USB-Line-Out (kein Extra-Interface nötig); Mixer egal (Xone:32/DJM-750); Traktor-Scratch-Vinyl vorhanden
- TSIMappingImporter: S4/S2-User-Mappings sind NIXML+Base64-Blobs; DCDT-Region = Action-Registry (UTF-16LE-Namen), ABER ohne MIDI-Nummern (S4/S2=HID). Ehrliche Lösung: Action-Katalog-Bericht + Unterstützungs-Check statt Fake-Import; echte Bindings via MIDI-Learn. Scanner: robuster [u16 nlen][UTF16LE-ASCII]-String-Scan (Endian-Falle im Header-Feld umgangen)
- DeckAction erweitert: playPauseB/cueB/hotcue1-4B/loopInB/loopOutB (Router behandelt, alte JSONs laden weiter)
- DVS: Line/Phono-Toggle (Default Line für BD-1380-USB), Info.plist-Mic-Text aktualisiert
- 114/114 Tests (25 Suiten; 6 neue inkl. Integrationstest gegen die echte S4-Datei — grün)

## Slice 14–16 (30.10., loki-dev BUILD) — Funktionsabgleich Traktor Pro 4 — FERTIG
- Team: 3 cavecrew-Builder parallel (Flux+Limiter / PatternPlayer / FX-Extra) + Director (4 Decks, Integration) + cavecrew-Reviewer (REQUEST_CHANGES: 4×P2 — ALLE gefixt)
- FluxMode auf Deck-Zeitbasis umgebaut (Reviewer P2-1): Pause/Loop/pitch-sicher, Tests erweitert (Pause-Freeze-Test)
- 4 Decks: Engine 4 Ketten, UI-Reihe C/D, C/D fader-only (P2-4), AutoDJ lädt nur in freie Decks (P2-3), Pattern-Fallback ohne Überschreiben (P3-5)
- Pattern Player: Kick/Snare/Hat/Clap-Synthese (LCG deterministisch, Kick cos-Punch, Hat 2.5× skaliert), 16-Step, 3 Presets → WAV → freies Deck
- FX-Extra + MasterLimiter: Core + Tests bewiesen; Live-Verkabelung = Folge-Tickets (P3-6: Limiter gleitendes Max-Fenster + Block-Zustand; FX-Routing)
- 138/138 Tests (28 Suiten; +24: Flux 8→9, Pattern 8, FX 8 — nach Fixes), F-040..F-044
