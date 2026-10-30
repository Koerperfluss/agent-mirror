import SwiftUI
import TraktorCloneCore
import CoreMIDI
import UniformTypeIdentifiers

/// Traktor-inspiriertes Dark-DJ-Theme (AA-Kontrast geprüft).
/// Taste-Skill-Locks: EIN Akzent (Cyan), EIN Radius-System (12/8/6), EIN Spacing-Rhythmus (4er).
enum Theme {
    // Farben
    static let bg = Color(red: 0.055, green: 0.063, blue: 0.078)        // #0E1014 tiefer
    static let surface = Color(red: 0.086, green: 0.102, blue: 0.125)   // #161A20
    static let waveBg = Color(red: 0.118, green: 0.133, blue: 0.161)    // #1E2229
    static let ink = Color(red: 0.910, green: 0.918, blue: 0.929)       // #E8EAED
    static let soft = Color(red: 0.718, green: 0.741, blue: 0.776)      // #B7BDC6
    static let muted = Color(red: 0.545, green: 0.573, blue: 0.612)     // #8B929C
    static let bd = Color(red: 0.180, green: 0.204, blue: 0.239)        // #2E343D
    static let acc = Color(red: 0.133, green: 0.827, blue: 0.910)       // #22D3EE Cyan
    static let accDim = Color(red: 0.133, green: 0.827, blue: 0.910).opacity(0.15)
    static let gr = Color(red: 0.290, green: 0.871, blue: 0.502)        // #4ADE80
    static let yl = Color(red: 0.984, green: 0.749, blue: 0.141)        // #FBBF24
    static let rd = Color(red: 0.973, green: 0.443, blue: 0.443)        // #F87171

    // Radius-System (Lock: genau 3 Stufen)
    static let rCard: CGFloat = 12
    static let rControl: CGFloat = 8
    static let rWave: CGFloat = 6

    // Typo-Skala (5 Stufen)
    static let fDisplay = Font.system(size: 15, weight: .bold, design: .rounded)
    static let fHeadline = Font.system(size: 13, weight: .semibold, design: .rounded)
    static let fSub = Font.system(size: 11, weight: .medium, design: .monospaced)
    static let fBody = Font.system(size: 12, weight: .regular, design: .default)
    static let fCaption = Font.system(size: 10, weight: .regular, design: .default)
}

/// Root-UI: 2 Decks (Waveform+FX) + Mixer + Sync + Recording + Library.
struct ContentView: View {
    @EnvironmentObject var midi: MIDIController
    @StateObject private var engineHost = EngineHost()
    // CLT-Falle: @State ist im macOS-27-SDK ein Makro (SwiftUIMacros fehlt im CLT)
    // → UI-Schalter als @Published im EngineHost, nicht als @State.

    var body: some View {
        VStack(spacing: 0) {
            topBar
            learnBar
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
            HStack(alignment: .top, spacing: 12) {
                deckView(vm: engineHost.deckA, label: "A", keys: ("q", "w", "e"))
                mixerView
                deckView(vm: engineHost.deckB, label: "B", keys: ("u", "i", "o"))
            }
            .padding(.horizontal, 12)
            libraryView
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
        .padding(.top, 12)
        .foregroundStyle(Theme.ink)
        .tint(Theme.acc)
        .background(Theme.bg)
        .onAppear { engineHost.wire(midi: midi) }
        .sheet(isPresented: $engineHost.showSpotifyImport) {
            SpotifyImportSheet(host: engineHost)
        }
    }

    // MARK: Top-Bar
    private var topBar: some View {
        HStack(spacing: 8) {
            // Marke
            HStack(spacing: 4) {
                Image(systemName: "pianokeys")
                    .foregroundStyle(Theme.acc)
                Text(midi.status)
                    .font(Theme.fCaption)
                    .foregroundStyle(Theme.muted)
                    .lineLimit(1)
            }

            Spacer()

            // Sync-Sektion (BPM + Beat-Phase)
            HStack(spacing: 4) {
                Button(engineHost.syncMaster == 1 ? "Master: B" : "Master: A") {
                    engineHost.toggleSyncMaster()
                }
                .buttonStyle(.djControl)
                Button("Sync → A") { engineHost.syncDeck(0) }
                    .buttonStyle(.djProminent)
                Button("Sync → B") { engineHost.syncDeck(1) }
                    .buttonStyle(.djProminent)
                Button(engineHost.autoDjEnabled ? "🤖 Auto-DJ ✓" : "🤖 Auto-DJ") {
                    engineHost.toggleAutoDJ()
                }
                .buttonStyle(.djProminent(tint: engineHost.autoDjEnabled ? Theme.gr : Theme.acc))
            }

            Divider().frame(height: 16)

            // Rec
            Button {
                toggleRecording()
            } label: {
                HStack(spacing: 3) {
                    Circle()
                        .fill(engineHost.isRecording ? Theme.rd : Theme.muted)
                        .frame(width: 6, height: 6)
                    Text(engineHost.isRecording ? "Stop" : "Rec")
                        .font(Theme.fCaption)
                }
            }
            .buttonStyle(.djControl(tint: engineHost.isRecording ? Theme.rd : Theme.acc))
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
    }

    private func toggleRecording() {
        if engineHost.isRecording {
            engineHost.stopRecording()
        } else {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.aiff]
            panel.nameFieldStringValue = "TraktorMix.aiff"
            guard panel.runModal() == .OK, let url = panel.url else { return }
            try? engineHost.startRecording(to: url)
        }
    }

    // MARK: MIDI-Learn
    @ViewBuilder
    private var learnBar: some View {
        HStack(spacing: 6) {
            ForEach(LearnTarget.allCases) { t in
                Button(t.label) { engineHost.startLearn(t.action) }
                    .buttonStyle(.djControl(tint: engineHost.learnAction == t.action ? Theme.yl : Theme.acc))
            }
            if engineHost.learning {
                Text("→ MIDI-Botschaft senden …")
                    .font(Theme.fCaption)
                    .foregroundStyle(Theme.yl)
                Button("Abbrechen") { engineHost.cancelLearn() }
                    .buttonStyle(.djControl)
            }
            Spacer()
        }
    }

    // MARK: Deck
    private func deckView(vm: DeckViewModel, label: String, keys: (load: String, play: String, cue: String)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // ── Header: Deck-Name + Zoom + BPM/Key + Track ──
            HStack(spacing: 6) {
                Text(label)
                    .font(Theme.fDisplay)
                    .foregroundStyle(vm.state.isPlaying ? Theme.acc : Theme.muted)
                    .frame(width: 20)

                if vm.bpm != nil || !vm.keyText.isEmpty {
                    Text("\(vm.bpm.map { String(Int($0)) } ?? "?")\(vm.keyText.isEmpty ? "" : " · \(vm.keyText)")")
                        .font(Theme.fSub)
                        .foregroundStyle(Theme.yl)
                }

                Button("🔍\(vm.zoom)x") { vm.cycleZoom() }
                    .buttonStyle(.djControl)
                    .font(Theme.fCaption)

                Spacer()

                Text(vm.title)
                    .font(Theme.fCaption)
                    .foregroundStyle(Theme.soft)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            // ── Waveform ──
            waveformView(vm: vm)

            // ── Zeitleiste + LED + VU ──
            HStack(spacing: 8) {
                Text(timeString(vm.playhead))
                    .font(Theme.fSub)
                    .foregroundStyle(Theme.soft)

                beatLED(vm: vm)

                vuMeter(vm: vm)

                Spacer()

                Text(timeString(vm.state.duration))
                    .font(Theme.fSub)
                    .foregroundStyle(Theme.muted)
            }

            // ── Transport ──
            HStack(spacing: 6) {
                Button("Load") { vm.load() }
                    .keyboardShortcut(KeyEquivalent(Character(keys.load)), modifiers: [])
                    .buttonStyle(.djControl)

                playPauseButton(vm: vm, key: keys.play)

                Button("Cue") { vm.cue() }
                    .keyboardShortcut(KeyEquivalent(Character(keys.cue)), modifiers: [])
                    .buttonStyle(.djControl)
            }

            // ── Hotcues + Loops ──
            HStack(spacing: 4) {
                // Hotcues
                ForEach(1...4, id: \.self) { i in
                    Button("\(i)") { vm.hotcue(i) }
                        .buttonStyle(.djSquare(active: vm.state.hotcues[i] != nil))
                }

                Spacer()

                // Beat-Loops
                ForEach([1, 2, 4, 8], id: \.self) { b in
                    Button("\(b)") { vm.setBeatLoop(b) }
                        .buttonStyle(.djSquare(active: vm.loopBeats == b, activeColor: Theme.yl))
                }
                if vm.loopBeats != nil {
                    Button("✕") { vm.exitLoop() }
                        .buttonStyle(.djSquare(active: true, activeColor: Theme.rd))
                }

                Spacer()

                Button(vm.state.keylock ? "Key ✓" : "Key") { vm.state.toggleKeylock() }
                    .buttonStyle(.djControl(tint: vm.state.keylock ? Theme.gr : Theme.acc))
            }

            // ── Stem-Mixer ──
            if vm.isStem { stemMixerRow(vm: vm) }

            // ── Pitch ──
            pitchRow(vm: vm)

            // ── FX ──
            fxRow(vm: vm)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.rCard)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.rCard)
                        .strokeBorder(
                            vm.state.isPlaying
                                ? Theme.acc.opacity(0.25)
                                : Theme.bd,
                            lineWidth: 1
                        )
                )
        )
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            guard let p = providers.first else { return false }
            _ = p.loadObject(ofClass: URL.self) { url, _ in
                guard let url else { return }
                Task { @MainActor in vm.load(url: url.standardizedFileURL) }
            }
            return true
        }
    }

    // Play-Pause: prominent
    private func playPauseButton(vm: DeckViewModel, key: String) -> some View {
        Button {
            vm.togglePlay()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: vm.state.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 11, weight: .bold))
                Text(vm.state.isPlaying ? "Pause" : "Play")
                    .font(Theme.fHeadline)
            }
        }
        .keyboardShortcut(KeyEquivalent(Character(key)), modifiers: [])
        .buttonStyle(.borderedProminent)
        .tint(vm.state.isPlaying ? Theme.yl : Theme.acc)
        .controlSize(.large)
    }

    // Beat-LED mit Glow
    private func beatLED(vm: DeckViewModel) -> some View {
        Circle()
            .fill(Theme.gr.opacity(vm.state.isPlaying ? Double(1 - vm.beatPhase) * 0.9 + 0.1 : 0.15))
            .frame(width: 8, height: 8)
            .shadow(
                color: Theme.gr.opacity(vm.state.isPlaying && vm.beatPhase < 0.3 ? 0.8 : 0),
                radius: vm.state.isPlaying && vm.beatPhase < 0.3 ? 4 : 0
            )
            .help("Beat (blinkt auf jedem Beat)")
    }

    // VU-Meter mit Gradient
    private func vuMeter(vm: DeckViewModel) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.bd)
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Theme.gr, Theme.gr, Theme.yl, Theme.rd]),
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(width: max(2, geo.size.width * CGFloat(min(vm.level, 1))))
            }
        }
        .frame(width: 60, height: 5)
    }

    // MARK: Waveform (Zoom-Fenster + Cue/Hotcue-Marker)
    private func waveformView(vm: DeckViewModel) -> some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let all = vm.waveform
            if all.isEmpty {
                ctx.fill(Path(CGRect(x: 0, y: h / 2 - 1, width: w, height: 2)),
                         with: .color(Theme.muted.opacity(0.2)))
                return
            }
            let n = all.count
            let win = vm.window
            let total = vm.state.duration

            /// Track-Sekunde → x im sichtbaren Fenster.
            func xFor(_ time: TimeInterval) -> CGFloat {
                guard total > 0 else { return -1 }
                let f = time / total
                return w * CGFloat((f - win.offset) / max(win.width, 0.0001))
            }

            let bw = w / CGFloat(max(n * Int(win.width), 1))

            // Beatgrid (nutzt Offset aus der Track-Analyse, nicht nur BPM-Takt)
            if let bpmV = vm.bpm, bpmV > 0, total > 0 {
                let spb = 60.0 / bpmV
                let t0 = win.offset * total
                let t1 = (win.offset + win.width) * total
                let phase = vm.beatgridOffset ?? 0
                var t = max(((t0 - phase) / spb).rounded(.up) * spb + phase, 0)
                while t < t1 {
                    let x = xFor(t)
                    if x >= 0 && x <= w {
                        ctx.fill(Path(CGRect(x: x, y: h * 0.5 - 4, width: 1, height: 8)),
                                 with: .color(Theme.muted.opacity(0.4)))
                    }
                    t += spb
                }
            }

            // Waveform-Bars (nur das sichtbare Fenster), zweifarbig
            let firstBucket = Int(win.offset * Double(n))
            let visibleCount = max(1, Int(win.width * Double(n)))
            for i in 0..<visibleCount {
                let idx = min(firstBucket + i, n - 1)
                let peak = all[idx]
                let barH = max(1, CGFloat(peak) * h * 0.9)
                let x = CGFloat(i) * bw
                let barW = max(bw - 0.5, 0.5)
                ctx.fill(Path(CGRect(x: x, y: (h - barH) / 2, width: barW, height: barH / 2)),
                         with: .color(Theme.acc.opacity(0.85)))
                ctx.fill(Path(CGRect(x: x, y: h / 2, width: barW, height: barH / 2)),
                         with: .color(Theme.acc.opacity(0.45)))
            }

            // Rest-3: Cue-Marker (gelb) + Hotcues 1–4 (cyan/grün/gelb/rot) mit Flag oben
            let markerColors: [Color] = [Theme.acc, Theme.gr, Theme.yl, Theme.rd]
            func marker(_ time: TimeInterval, _ color: Color, flag: Bool) {
                let x = xFor(time)
                guard x >= 0 && x <= w else { return }
                ctx.fill(Path(CGRect(x: x - 1, y: flag ? 8 : 0, width: 2, height: flag ? h - 8 : h)),
                         with: .color(color.opacity(0.55)))
                if flag {
                    ctx.fill(Path(CGRect(x: x - 1, y: 0, width: 8, height: 8)),
                             with: .color(color))
                }
            }
            marker(vm.state.cuePoint, Theme.yl, flag: true)
            for i in 1...4 {
                if let t = vm.state.hotcues[i] { marker(t, markerColors[i - 1], flag: true) }
            }

            // Playhead mit Glow (Fenstermitte bei Zoom > 1)
            if total > 0 {
                let x = xFor(vm.playhead)
                if x >= 0 && x <= w {
                    ctx.fill(Path(CGRect(x: x - 1, y: 0, width: 4, height: h)),
                             with: .color(Theme.rd.opacity(0.3)))
                    ctx.fill(Path(CGRect(x: x, y: 0, width: 2, height: h)),
                             with: .color(Theme.rd))
                }
            }
        }
        .frame(height: 64)
        .background(
            RoundedRectangle(cornerRadius: Theme.rWave)
                .fill(Theme.waveBg)
        )
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in vm.seekFraction(location.x / geo.size.width) }
                    .gesture(DragGesture(minimumDistance: 1).onChanged { g in
                        vm.seekFraction(g.location.x / geo.size.width)
                    })
            }
        )
    }

    // MARK: Stem-Mixer
    private func stemMixerRow(vm: DeckViewModel) -> some View {
        let labels = ["Mix", "Drums", "Bass", "Other", "Voc"]
        return VStack(alignment: .leading, spacing: 4) {
            Text("Stems").font(Theme.fCaption).foregroundStyle(Theme.muted)
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { i in
                    VStack(spacing: 3) {
                        Slider(value: Binding(get: { vm.stemGains[i] },
                                              set: { vm.setStemGain(i, $0) }), in: 0...1)
                            .frame(width: 70)
                        HStack(spacing: 2) {
                            Text(labels[i]).font(Theme.fCaption).foregroundStyle(Theme.muted)
                            Button("S") { vm.stemSolo(i) }
                                .buttonStyle(.djControl)
                                .font(Theme.fCaption)
                        }
                    }
                }
            }
        }
    }

    // MARK: Pitch
    private func pitchRow(vm: DeckViewModel) -> some View {
        HStack(spacing: 8) {
            Text("Pitch").font(Theme.fCaption).foregroundStyle(Theme.muted)
            Slider(value: Binding(get: { vm.pitch }, set: { vm.setPitch($0) }),
                   in: -vm.state.pitchRange...vm.state.pitchRange)
            Text(String(format: "%+.1f%%", vm.pitch * 100))
                .font(Theme.fSub).foregroundStyle(Theme.acc)
                .frame(width: 52)
        }
    }

    // MARK: FX
    private func fxRow(vm: DeckViewModel) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Text("FX").font(Theme.fCaption).foregroundStyle(Theme.muted).frame(width: 24, alignment: .leading)
                Button(vm.filterOn ? (vm.filterHighPass ? "HP ✓" : "LP ✓") : "Filter") {
                    if vm.filterOn { vm.applyFilter(on: false, highPass: vm.filterHighPass) }
                    else { vm.applyFilter(on: true, highPass: !vm.filterHighPass) }
                }
                .buttonStyle(.djControl(tint: vm.filterOn ? Theme.gr : Theme.acc))
                .frame(width: 60)
                Spacer()
            }
            HStack(spacing: 6) {
                Text("Delay").font(Theme.fCaption).foregroundStyle(Theme.muted).frame(width: 36, alignment: .leading)
                Slider(value: Binding(get: { vm.delayWet }, set: { vm.applyDelay($0) }), in: 0...100)
                Text("\(Int(vm.delayWet))").font(Theme.fSub).foregroundStyle(Theme.muted).frame(width: 24)
            }
            HStack(spacing: 6) {
                Text("Reverb").font(Theme.fCaption).foregroundStyle(Theme.muted).frame(width: 36, alignment: .leading)
                Slider(value: Binding(get: { vm.reverbWet }, set: { vm.applyReverb($0) }), in: 0...100)
                Text("\(Int(vm.reverbWet))").font(Theme.fSub).foregroundStyle(Theme.muted).frame(width: 24)
            }
        }
    }

    // MARK: Mixer
    private var mixerView: some View {
        VStack(spacing: 12) {
            Text("Mixer").font(Theme.fHeadline).foregroundStyle(Theme.muted)

            HStack(alignment: .bottom, spacing: 16) {
                VStack(spacing: 4) {
                    fader(vm: engineHost.deckA)
                    Text("A").font(Theme.fSub).foregroundStyle(Theme.muted)
                }
                VStack(spacing: 4) {
                    Slider(value: Binding(
                        get: { engineHost.crossfader },
                        set: { engineHost.setCrossfader($0) }
                    ), in: 0...1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 20)
                    Text("X-Fade").font(Theme.fCaption).foregroundStyle(Theme.muted)
                }
                VStack(spacing: 4) {
                    fader(vm: engineHost.deckB)
                    Text("B").font(Theme.fSub).foregroundStyle(Theme.muted)
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.rCard).fill(Theme.surface))
    }

    private func fader(vm: DeckViewModel) -> some View {
        Slider(value: Binding(
            get: { vm.fader },
            set: { vm.fader = $0; vm.applyMixerVolume(vm.fader) }
        ), in: 0...1)
        .frame(width: 20, height: 100)
        .rotationEffect(.degrees(-90))
        .frame(width: 100, height: 36)
    }

    // MARK: Library + Playlists + Treiber
    private var libraryView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("Library").font(Theme.fHeadline).foregroundStyle(Theme.muted)
                Text("(\(engineHost.library.count))")
                    .font(Theme.fCaption).foregroundStyle(Theme.muted)
                Spacer()
                Button("🎧 Spotify-Playlist …") { engineHost.showSpotifyImport = true }
                    .buttonStyle(.djControl(tint: Theme.gr))
                TextField("Suche …", text: Binding(
                    get: { engineHost.searchText },
                    set: { engineHost.searchText = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 280)
            }

            // Rest-5: Playlists (Crate) — Quelle für Auto-DJ
            playlistRow

            let results = LibrarySearch.filter(engineHost.library, query: engineHost.searchText)
            List(results.prefix(60), id: \.path) { track in
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(track.title.isEmpty ? "—" : track.title)
                            .font(Theme.fBody).lineLimit(1)
                        HStack(spacing: 6) {
                            Text(track.artist).font(Theme.fCaption).foregroundStyle(Theme.muted)
                            if let b = track.bpm {
                                Text("\(Int(b)) BPM").font(Theme.fCaption).foregroundStyle(Theme.acc)
                            }
                        }
                    }
                    Spacer()
                    Button("＋") { engineHost.addToActivePlaylist(track) }
                        .buttonStyle(.djSquare)
                        .help("In aktive Playlist")
                    Button("→ A") { engineHost.load(track: track, deck: 0) }
                        .buttonStyle(.djControl)
                    Button("→ B") { engineHost.load(track: track, deck: 1) }
                        .buttonStyle(.djControl)
                }
                .listRowBackground(Theme.surface)
            }
            .listStyle(.inset)
            .frame(minHeight: 100, maxHeight: 140)
            .scrollContentBackground(.hidden)

            if engineHost.library.isEmpty {
                Text("collection.nml leer — in Traktor Tracks importieren, dann App neu starten.")
                    .font(Theme.fCaption).foregroundStyle(Theme.muted)
            }

            setupPanel
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.rCard).fill(Theme.surface))
    }

    private var playlistRow: some View {
        HStack(spacing: 6) {
            Text("Quelle:").font(Theme.fCaption).foregroundStyle(Theme.muted)
            Menu {
                Button("Library (alle)") { engineHost.activePlaylistID = nil }
                ForEach(engineHost.playlists) { p in
                    Button(p.name) { engineHost.activePlaylistID = p.id }
                }
            } label: {
                Text(engineHost.activePlaylistLabel)
                    .font(Theme.fCaption)
                    .foregroundStyle(engineHost.activePlaylistID != nil ? Theme.yl : Theme.acc)
            }
            .fixedSize()

            if engineHost.activePlaylistID != nil {
                Text("(\(engineHost.activePlaylist?.trackPaths.count ?? 0))")
                    .font(Theme.fCaption).foregroundStyle(Theme.muted)
                Button("🗑") {
                    if let id = engineHost.activePlaylistID { engineHost.deletePlaylist(id) }
                }
                .buttonStyle(.djSquare(active: true, activeColor: Theme.rd))
                .help("Playlist löschen")
            }
            Button("＋ Neu") { newPlaylistAlert() }
                .buttonStyle(.djControl)
            Spacer()
            Text("Auto-DJ zieht aus der gewählten Quelle.")
                .font(Theme.fCaption).foregroundStyle(Theme.muted)
        }
    }

    private func newPlaylistAlert() {
        let alert = NSAlert()
        alert.messageText = "Neue Playlist"
        alert.informativeText = "Name der Playlist:"
        alert.addButton(withTitle: "Anlegen")
        alert.addButton(withTitle: "Abbrechen")
        let field = NSTextField(frame: NSRect(x: 0, y: 0, width: 240, height: 24))
        field.placeholderString = "z. B. Warm-Up"
        alert.accessoryView = field
        if alert.runModal() == .alertFirstButtonReturn {
            engineHost.createPlaylist(name: field.stringValue)
        }
    }

    /// NI-Controller-TSI lesen → Action-Katalog (Zuordnung selbst per MIDI-Learn).
    private func importNativeTSI() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "tsi") ?? .xml]
        panel.canChooseDirectories = false
        panel.directoryURL = URL(fileURLWithPath: NSString(
            string: "~/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Controller"
        ).expandingTildeInPath)
        guard panel.runModal() == .OK, let url = panel.url else { return }
        let r = engineHost.importNativeMappings(from: url)
        let alert = NSAlert()
        alert.messageText = "NI-Controller-TSI gelesen"
        alert.informativeText = """
        \(r.total) NI-Actions erkannt, \(r.supported) davon unterstützt TraktorClone \
        (Play/Cue/Hotcues/Loops je Deck, Crossfader).

        Hinweis: S4/S2-Templates speichern keine MIDI-Nummern (HID-Geräte). \
        Weise deine Regler oben per MIDI-Learn zu (Klick auf die Aktion, dann Regler bewegen).
        """
        alert.runModal()
    }

    // MARK: Treiber & MIDI-Mappings (Rest-6)
    private var setupPanel: some View {
        DisclosureGroup(isExpanded: $engineHost.showSetup) {
            VStack(alignment: .leading, spacing: 6) {
                // Audio-Ausgang
                HStack(spacing: 6) {
                    Text("Audio").font(Theme.fCaption).foregroundStyle(Theme.muted)
                        .frame(width: 48, alignment: .leading)
                    Menu {
                        ForEach(engineHost.audioDevices, id: \.id) { dev in
                            Button(dev.name) { engineHost.setDefaultAudio(dev.id) }
                        }
                    } label: {
                        Text(engineHost.audioDevices.first { $0.id == engineHost.defaultAudioDeviceID }?.name
                             ?? "System-Ausgang")
                            .font(Theme.fCaption)
                    }
                    .fixedSize()
                    Button("↻") { engineHost.refreshAudioDevices() }
                        .buttonStyle(.djControl)
                    Text("(System-Ausgang, macOS-weit)")
                        .font(Theme.fCaption).foregroundStyle(Theme.muted)
                    Spacer()
                }

                // DVS (Timecode-Vinyl, Slice 12)
                HStack(spacing: 6) {
                    Text("DVS").font(Theme.fCaption).foregroundStyle(Theme.muted)
                        .frame(width: 48, alignment: .leading)
                    Button(engineHost.dvs.enabled ? "⏹ Stop" : "▶︎ Vinyl") { engineHost.dvs.toggle() }
                        .buttonStyle(.djProminent(tint: engineHost.dvs.enabled ? Theme.rd : Theme.gr))
                    Menu {
                        ForEach(engineHost.inputDevices, id: \.id) { dev in
                            Button(dev.name) { engineHost.setDefaultInputDevice(dev.id) }
                        }
                    } label: {
                        Text(engineHost.inputDevices.first { $0.id == engineHost.defaultInputDeviceID }?.name
                             ?? "Eingang")
                            .font(Theme.fCaption)
                    }
                    .fixedSize()
                    Text(engineHost.dvs.status)
                        .font(Theme.fCaption).foregroundStyle(Theme.soft).lineLimit(1)
                    Button(engineHost.dvs.lineLevel ? "Line ✓" : "Phono") {
                        engineHost.dvs.lineLevel.toggle()
                    }
                    .buttonStyle(.djControl(tint: engineHost.dvs.lineLevel ? Theme.gr : Theme.yl))
                    .help("BD-1380-USB = Line (Preamp eingebaut); klassische Phono-Verkabelung = Phono")
                    Spacer()
                    ForEach(0..<2, id: \.self) { i in
                        let active = engineHost.dvs.deckPosition[i] != nil
                        Text("\(i == 0 ? "A" : "B") \(engineHost.dvs.deckSpeed[i], specifier: "%.2f")×")
                            .font(Theme.fSub)
                            .foregroundStyle(active ? Theme.gr : Theme.muted)
                    }
                }

                // MIDI-Geräte + Mappings
                HStack(spacing: 6) {
                    Text("MIDI").font(Theme.fCaption).foregroundStyle(Theme.muted)
                        .frame(width: 48, alignment: .leading)
                    Text(midi.status).font(Theme.fCaption).foregroundStyle(Theme.soft)
                    Spacer()
                    Button("Export") { engineHost.exportMappings() }
                        .buttonStyle(.djControl)
                    Button("Import") { engineHost.importMappings() }
                        .buttonStyle(.djControl)
                    Button("NI .tsi") { importNativeTSI() }
                        .buttonStyle(.djControl(tint: Theme.gr))
                        .help("Native-Instruments-Controller-Mapping laden (S4/S2 & Co.)")
                }

                let mappings = engineHost.currentMappings
                if mappings.isEmpty {
                    Text("Keine Mappings — oben per MIDI-Learn anlernen.")
                        .font(Theme.fCaption).foregroundStyle(Theme.muted)
                } else {
                    ForEach(Array(mappings.enumerated()), id: \.offset) { _, m in
                        HStack(spacing: 6) {
                            Text("\(m.isCC ? "CC" : "Note") \(m.control) · Ch \(m.channel + 1)")
                                .font(Theme.fSub).foregroundStyle(Theme.acc)
                                .frame(width: 130, alignment: .leading)
                            Text("→ \(m.action)").font(Theme.fCaption).foregroundStyle(Theme.soft)
                            Spacer()
                            Button("✕") { engineHost.removeMapping(m) }
                                .buttonStyle(.djSquare(active: true, activeColor: Theme.rd))
                        }
                    }
                }
            }
            .padding(.top, 4)
        } label: {
            Text("Treiber & MIDI (\(engineHost.currentMappings.count))")
                .font(Theme.fCaption).foregroundStyle(Theme.muted)
        }
    }

    private func timeString(_ t: TimeInterval) -> String {
        guard t.isFinite, t >= 0 else { return "0:00.00" }
        let m = Int(t) / 60
        let s = t.truncatingRemainder(dividingBy: 60)
        return String(format: "%d:%05.2f", m, s)
    }
}

// MARK: - DJ Button Styles

/// Standard-Button: kompakt, klarer Border.
struct DJControlStyle: ButtonStyle {
    var tint: Color = Theme.acc

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.fCaption)
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: Theme.rControl)
                    .fill(tint.opacity(configuration.isPressed ? 0.2 : 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.rControl)
                    .strokeBorder(tint.opacity(0.3), lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == DJControlStyle {
    static var djControl: DJControlStyle { DJControlStyle() }
    static func djControl(tint: Color) -> DJControlStyle { DJControlStyle(tint: tint) }
}

/// Quadratischer Hotcue/Loop-Button.
struct DJSquareStyle: ButtonStyle {
    var active: Bool = false
    var activeColor: Color = Theme.acc

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.fSub)
            .foregroundStyle(active ? activeColor : Theme.muted)
            .frame(width: 28, height: 24)
            .background(
                RoundedRectangle(cornerRadius: Theme.rControl)
                    .fill(active ? activeColor.opacity(0.18) : Theme.bd.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.rControl)
                    .strokeBorder(active ? activeColor.opacity(0.5) : Theme.bd, lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == DJSquareStyle {
    static var djSquare: DJSquareStyle { DJSquareStyle() }
    static func djSquare(active: Bool, activeColor: Color = Theme.acc) -> DJSquareStyle {
        DJSquareStyle(active: active, activeColor: activeColor)
    }
}

/// Prominenter Button (Sync/Auto-DJ/Rec).
struct DJProminentStyle: ButtonStyle {
    var tint: Color = Theme.acc

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.fCaption)
            .foregroundStyle(Theme.bg)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(tint)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == DJProminentStyle {
    static var djProminent: DJProminentStyle { DJProminentStyle() }
    static func djProminent(tint: Color) -> DJProminentStyle { DJProminentStyle(tint: tint) }
}

// MARK: - Lernbare Funktionen (MIDI-Learn)

enum LearnTarget: String, CaseIterable, Identifiable {
    case play = "Play", cue = "Cue", hc1 = "HC1", hc2 = "HC2"
    case hc3 = "HC3", hc4 = "HC4", xf = "X-Fade"

    var id: String { rawValue }
    var label: String { rawValue }
    var action: DeckAction {
        switch self {
        case .play: return .playPause
        case .cue: return .cue
        case .hc1: return .hotcue1
        case .hc2: return .hotcue2
        case .hc3: return .hotcue3
        case .hc4: return .hotcue4
        case .xf: return .crossfader
        }
    }
}

// MARK: - Spotify-Playlist-Import (Rest-7: nur Metadaten, Match gegen lokale Library)

struct SpotifyImportSheet: View {
    @ObservedObject var host: EngineHost
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "music.note").foregroundStyle(Theme.gr)
                Text("Spotify-Playlist importieren").font(Theme.fDisplay)
                Spacer()
                Button("Schließen") { dismiss() }.buttonStyle(.djControl)
            }

            Text("Metadaten-Import: Spotify erlaubt DJ-Apps kein Audio-Streaming — die Tracks werden gegen deine lokale Library gematcht.")
                .font(Theme.fCaption).foregroundStyle(Theme.muted)

            HStack(spacing: 6) {
                TextField("https://open.spotify.com/playlist/…", text: $host.spotifyURLText)
                    .textFieldStyle(.roundedBorder)
                Button("Holen") {
                    Task { await host.importSpotifyPlaylist(host.spotifyURLText) }
                }
                .buttonStyle(.djProminent(tint: Theme.gr))
            }

            if !host.spotifyStatus.isEmpty {
                Text(host.spotifyStatus).font(Theme.fCaption).foregroundStyle(Theme.yl)
            }

            if !host.spotifyResults.isEmpty {
                List(host.spotifyResults, id: \.self) { st in
                    let local = PlaylistMatch.match(spotify: st, in: host.library)
                    HStack(spacing: 8) {
                        Circle()
                            .fill(local != nil ? Theme.gr : Theme.bd)
                            .frame(width: 7, height: 7)
                            .help(local != nil ? "In lokaler Library" : "Kein lokaler Treffer")
                        VStack(alignment: .leading, spacing: 1) {
                            Text(st.name).font(Theme.fBody).lineLimit(1)
                            Text(st.artist).font(Theme.fCaption).foregroundStyle(Theme.muted)
                        }
                        Spacer()
                        if let l = local {
                            Text(l.title).font(Theme.fCaption).foregroundStyle(Theme.soft).lineLimit(1)
                        } else {
                            Text("—").font(Theme.fCaption).foregroundStyle(Theme.muted)
                        }
                    }
                }
                .listStyle(.inset)
                .frame(minHeight: 180, maxHeight: 300)
                .scrollContentBackground(.hidden)

                Button("Gefundene als Playlist anlegen") {
                    host.saveSpotifyMatchesAsPlaylist(
                        name: host.spotifyStatus.split(separator: ":").first.map(String.init) ?? "Spotify-Import")
                }
                .buttonStyle(.djProminent)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(width: 560)
        .foregroundStyle(Theme.ink)
        .background(Theme.bg)
    }
}
