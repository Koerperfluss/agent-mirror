import SwiftUI
import TraktorCloneCore
import CoreMIDI

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

            // Sync-Sektion
            HStack(spacing: 4) {
                Button(engineHost.syncMaster == 1 ? "Master: B" : "Master: A") {
                    engineHost.toggleSyncMaster()
                }
                .buttonStyle(.djControl)
                Button("Sync B→A") { engineHost.syncDeck(1) }
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

    // MARK: Waveform
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
            let frac = vm.state.duration > 0 ? vm.playhead / vm.state.duration : 0
            let vis: ArraySlice<Float>
            let offsetF: CGFloat
            if vm.zoom == 1 { vis = all[...]; offsetF = 0 }
            else {
                let win = max(1, n / vm.zoom)
                var start = Int(frac * CGFloat(n)) - win / 2
                start = max(0, min(start, n - win))
                vis = all[start..<(start + win)]
                offsetF = CGFloat(start) / CGFloat(n)
            }
            let bw = w / CGFloat(max(vis.count, 1))

            // Beatgrid
            if let bpmV = vm.bpm, bpmV > 0 {
                let spb = 60.0 / bpmV
                let total = vm.state.duration
                let win = vm.zoom == 1 ? n : max(1, n / vm.zoom)
                let start = vm.zoom == 1 ? 0 : max(0, min(Int(frac * Double(n)) - win / 2, n - win))
                let t0 = Double(start) / Double(n) * total
                let t1 = Double(start + win) / Double(n) * total
                var t = (t0 / spb).rounded(.up) * spb
                while t < t1 {
                    let idx = Int(t / total * Double(n)) - start
                    if idx >= 0 && idx < win {
                        let x = CGFloat(idx) * bw
                        ctx.fill(Path(CGRect(x: x, y: h * 0.5 - 4, width: 1, height: 8)),
                                 with: .color(Theme.muted.opacity(0.4)))
                    }
                    t += spb
                }
            }

            // Waveform-Bars mit vertikalem Gradient
            for (i, peak) in vis.enumerated() {
                let barH = max(1, CGFloat(peak) * h * 0.9)
                let x = CGFloat(i) * bw
                let barW = max(bw - 0.5, 0.5)
                // Obere Hälfte heller, untere dunkler
                ctx.fill(Path(CGRect(x: x, y: (h - barH) / 2, width: barW, height: barH / 2)),
                         with: .color(Theme.acc.opacity(0.85)))
                ctx.fill(Path(CGRect(x: x, y: h / 2, width: barW, height: barH / 2)),
                         with: .color(Theme.acc.opacity(0.45)))
            }

            // Playhead mit Glow
            if vm.state.duration > 0 {
                let x = w * CGFloat(max(0, min(frac - offsetF, 1)))
                ctx.fill(Path(CGRect(x: x - 1, y: 0, width: 4, height: h)),
                         with: .color(Theme.rd.opacity(0.3)))
                ctx.fill(Path(CGRect(x: x, y: 0, width: 2, height: h)),
                         with: .color(Theme.rd))
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

    // MARK: Library
    private var libraryView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("Library").font(Theme.fHeadline).foregroundStyle(Theme.muted)
                Text("(\(engineHost.library.count))")
                    .font(Theme.fCaption).foregroundStyle(Theme.muted)
                Spacer()
                TextField("Suche …", text: Binding(
                    get: { engineHost.searchText },
                    set: { engineHost.searchText = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 280)
            }

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
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: Theme.rCard).fill(Theme.surface))
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
