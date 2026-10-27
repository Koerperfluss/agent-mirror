import SwiftUI
import TraktorCloneCore
import CoreMIDI

/// Traktor-inspiriertes Dark-DJ-Theme (AA-Kontrast geprüft: muted 4.6:1 auf surface).
enum Theme {
    static let bg = Color(red: 0.063, green: 0.071, blue: 0.086)        // #101216
    static let surface = Color(red: 0.102, green: 0.118, blue: 0.141)   // #1A1E24
    static let waveBg = Color(red: 0.137, green: 0.153, blue: 0.180)    // #232E2E? nein: #232E38-Familie
    static let ink = Color(red: 0.910, green: 0.918, blue: 0.929)       // #E8EAED
    static let soft = Color(red: 0.718, green: 0.741, blue: 0.776)      // #B7BDC6
    static let muted = Color(red: 0.545, green: 0.573, blue: 0.612)     // #8B929C
    static let bd = Color(red: 0.180, green: 0.204, blue: 0.239)        // #2E343D
    static let acc = Color(red: 0.133, green: 0.827, blue: 0.910)       // #22D3EE Cyan
    static let gr = Color(red: 0.290, green: 0.871, blue: 0.502)        // #4ADE80
    static let yl = Color(red: 0.984, green: 0.749, blue: 0.141)        // #FBBF24
    static let rd = Color(red: 0.973, green: 0.443, blue: 0.443)        // #F87171
}

/// Root-UI: 2 Decks (Waveform+FX) + Mixer + Sync + Recording + Library.
struct ContentView: View {
    @EnvironmentObject var midi: MIDIController
    @StateObject private var engineHost = EngineHost()

    var body: some View {
        VStack(spacing: 12) {
            topBar
            learnBar
            HStack(alignment: .top, spacing: 16) {
                deckView(vm: engineHost.deckA, label: "A", keys: ("q", "w", "e"))
                mixerView
                deckView(vm: engineHost.deckB, label: "B", keys: ("u", "i", "o"))
            }
            libraryView
        }
        .padding(16)
        .foregroundStyle(Theme.ink)
        .tint(Theme.acc)
        .background(Theme.bg)
        .onAppear { engineHost.wire(midi: midi) }
    }

    /// Slice 8: MIDI-Learn — Funktion anklicken, nächste MIDI-Botschaft zuweist sie.
    @ViewBuilder
    private var learnBar: some View {
        HStack(spacing: 8) {
            Text("MIDI-Learn:").font(.caption)
            ForEach(LearnTarget.allCases) { t in
                Button(t.label) { engineHost.startLearn(t.action) }
                    .buttonStyle(.bordered)
                    .tint(engineHost.learnAction == t.action ? Theme.yl : Theme.acc)
            }
            if engineHost.learning {
                Text("→ MIDI-Botschaft senden …").font(.caption).foregroundStyle(Theme.yl)
                Button("Abbrechen") { engineHost.cancelLearn() }.buttonStyle(.bordered)
            }
            Spacer()
        }
    }

    // MARK: Top-Bar (MIDI-Status + Sync + Rec)
    private var topBar: some View {
        HStack {
            Image(systemName: "pianokeys")
            Text(midi.status).font(.caption).foregroundStyle(Theme.soft)
            Spacer()
            Button(engineHost.syncMaster == 1 ? "Master: B" : "Master: A") {
                engineHost.toggleSyncMaster()
            }
            .buttonStyle(.bordered)
            Button("Sync B→A") { engineHost.syncDeck(1) }.buttonStyle(.borderedProminent)
            Button(engineHost.isRecording ? "⏺ Stop" : "⏺ Rec") { toggleRecording() }
                .buttonStyle(.borderedProminent)
                .tint(engineHost.isRecording ? Theme.rd : Theme.acc)
        }
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

    // MARK: Deck (Waveform + Transport + FX)
    private func deckView(vm: DeckViewModel, label: String, keys: (load: String, play: String, cue: String)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Deck \(label)").font(.headline)
                Spacer()
                Text(vm.title).font(.caption).lineLimit(1).truncationMode(.middle)
            }
            waveformView(vm: vm)
            HStack {
                Text(timeString(vm.playhead)).font(.system(.caption, design: .monospaced))
                // Slice 8: Beat-Phase-LED — blitzt bei jedem Beat-Start auf
                Circle()
                    .fill(Theme.gr.opacity(vm.state.isPlaying ? Double(1 - vm.beatPhase) * 0.9 + 0.1 : 0.15))
                    .frame(width: 10, height: 10)
                    .help("Beat-Phase (blinkt auf dem Beat)")
                Spacer()
                Text(timeString(vm.state.duration)).font(.system(.caption, design: .monospaced))
            }
            HStack {
                Button("Load") { vm.load() }.keyboardShortcut(KeyEquivalent(Character(keys.load)), modifiers: [])
                Button(vm.state.isPlaying ? "Pause" : "Play") { vm.togglePlay() }
                    .keyboardShortcut(KeyEquivalent(Character(keys.play)), modifiers: [])
                Button("Cue") { vm.cue() }.keyboardShortcut(KeyEquivalent(Character(keys.cue)), modifiers: [])
            }
            HStack(spacing: 6) {
                ForEach(1...4, id: \.self) { i in
                    Button("\(i)") { vm.hotcue(i) }.frame(width: 34)
                }
                Spacer()
                Button(vm.state.keylock ? "Key ✓" : "Key") { vm.state.toggleKeylock() }
                    .buttonStyle(.bordered)
            }
            pitchRow(vm: vm)
            fxRow(vm: vm)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Theme.surface))
        // Slice 8: Datei direkt aufs Deck ziehen (Upload ohne Dialog)
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            guard let p = providers.first else { return false }
            _ = p.loadObject(ofClass: URL.self) { url, _ in
                guard let url else { return }
                Task { @MainActor in
                    vm.load(url: url.standardizedFileURL)
                }
            }
            return true
        }
    }

    /// Slice 3: Waveform-Canvas mit Playhead; Klick = Seek.
    private func waveformView(vm: DeckViewModel) -> some View {
        Canvas { ctx, size in
            let w = size.width, h = size.height
            let buckets = vm.waveform
            if buckets.isEmpty {
                ctx.fill(Path(CGRect(x: 0, y: h / 2 - 1, width: w, height: 2)),
                         with: .color(.secondary.opacity(0.25)))
            } else {
                let bw = w / CGFloat(buckets.count)
                for (i, peak) in buckets.enumerated() {
                    let barH = max(1, CGFloat(peak) * h)
                    ctx.fill(Path(CGRect(x: CGFloat(i) * bw, y: (h - barH) / 2,
                                         width: max(bw - 0.5, 0.5), height: barH)),
                             with: .color(Theme.acc.opacity(0.7)))
                }
            }
            if vm.state.duration > 0 {
                let x = w * CGFloat(vm.playhead / vm.state.duration)
                ctx.fill(Path(CGRect(x: x, y: 0, width: 2, height: h)),
                         with: .color(Theme.rd))
            }
        }
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 6).fill(Theme.waveBg))
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        vm.seekFraction(location.x / geo.size.width)
                    }
            }
        )
    }

    private func pitchRow(vm: DeckViewModel) -> some View {
        HStack {
            Text("Pitch").font(.caption)
            Slider(value: Binding(get: { vm.pitch }, set: { vm.setPitch($0) }),
                   in: -vm.state.pitchRange...vm.state.pitchRange)
            Text(String(format: "%+.1f%%", vm.pitch * 100))
                .font(.system(.caption, design: .monospaced)).frame(width: 56)
        }
    }

    /// Slice 4: Delay/Reverb-Wet + Filter-Toggle.
    private func fxRow(vm: DeckViewModel) -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("FX").font(.caption).frame(width: 30, alignment: .leading)
                Button(vm.filterOn ? (vm.filterHighPass ? "HP ✓" : "LP ✓") : "Filter") {
                    if vm.filterOn {
                        vm.applyFilter(on: false, highPass: vm.filterHighPass)
                    } else {
                        vm.applyFilter(on: true, highPass: !vm.filterHighPass)
                    }
                }
                .buttonStyle(.bordered).frame(width: 64)
                Spacer()
            }
            HStack {
                Text("Delay").font(.caption).frame(width: 40, alignment: .leading)
                Slider(value: Binding(get: { vm.delayWet }, set: { vm.applyDelay($0) }), in: 0...100)
                Text("\(Int(vm.delayWet))").font(.caption).frame(width: 26)
            }
            HStack {
                Text("Reverb").font(.caption).frame(width: 40, alignment: .leading)
                Slider(value: Binding(get: { vm.reverbWet }, set: { vm.applyReverb($0) }), in: 0...100)
                Text("\(Int(vm.reverbWet))").font(.caption).frame(width: 26)
            }
        }
    }

    // MARK: Mixer
    private var mixerView: some View {
        VStack(spacing: 14) {
            Text("Mixer").font(.headline)
            HStack(alignment: .bottom, spacing: 18) {
                VStack { fader(vm: engineHost.deckA); Text("A").font(.caption) }
                VStack {
                    Slider(value: Binding(
                        get: { engineHost.crossfader },
                        set: { engineHost.setCrossfader($0) }
                    ), in: 0...1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 120, height: 24)
                    Text("X-Fade").font(.caption)
                }
                VStack { fader(vm: engineHost.deckB); Text("B").font(.caption) }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 10).fill(Theme.surface))
    }

    private func fader(vm: DeckViewModel) -> some View {
        Slider(value: Binding(
            get: { vm.fader },
            set: { vm.fader = $0; vm.applyMixerVolume(vm.fader) }
        ), in: 0...1)
        .frame(width: 24, height: 120)
        .rotationEffect(.degrees(-90))
        .frame(width: 120, height: 40)
    }

    // MARK: Library (Slice 2)
    private var libraryView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Library").font(.headline)
                Text("(\(engineHost.library.count) Tracks aus collection.nml)")
                    .font(.caption).foregroundStyle(Theme.soft)
                Spacer()
                TextField("Suche Titel/Artist/Pfad…", text: Binding(
                    get: { engineHost.searchText },
                    set: { engineHost.searchText = $0 }
                ))
                .textFieldStyle(.roundedBorder).frame(maxWidth: 320)
            }
            let results = LibrarySearch.filter(engineHost.library, query: engineHost.searchText)
            List(results.prefix(100), id: \.path) { track in
                HStack {
                    VStack(alignment: .leading) {
                        Text(track.title.isEmpty ? track.path.components(separatedBy: "/").last ?? "?" : track.title)
                            .font(.callout).lineLimit(1)
                        Text(track.artist + (track.bpm.map { "  ·  \(Int($0)) BPM" } ?? ""))
                            .font(.caption).foregroundStyle(Theme.soft)
                    }
                    Spacer()
                    Button("→ A") { engineHost.load(track: track, deck: 0) }.buttonStyle(.bordered)
                    Button("→ B") { engineHost.load(track: track, deck: 1) }.buttonStyle(.bordered)
                }
            }
            .frame(minHeight: 140, maxHeight: 200)
            .listStyle(.inset)
            if engineHost.library.isEmpty {
                Text("Keine Tracks: In Traktor Tracks importieren, dann neu starten. (Deine collection.nml ist aktuell leer: COLLECTION ENTRIES=\"0\")")
                    .font(.caption).foregroundStyle(Theme.muted)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Theme.surface))
    }

    private func timeString(_ t: TimeInterval) -> String {
        guard t.isFinite, t >= 0 else { return "0:00.00" }
        let m = Int(t) / 60
        let s = t.truncatingRemainder(dividingBy: 60)
        return String(format: "%d:%05.2f", m, s)
    }
}

/// Slice 8: Lernbare Funktionen für MIDI-Learn (Label + DeckAction).
enum LearnTarget: String, CaseIterable, Identifiable {
    case play = "Play", cue = "Cue", hc1 = "Hotcue 1", hc2 = "Hotcue 2"
    case hc3 = "Hotcue 3", hc4 = "Hotcue 4", xf = "X-Fade"

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

/// Hält AudioEngine + Decks + Mixer + Sync + Recorder + Library.
@MainActor
final class EngineHost: ObservableObject {
    let audio = AudioEngine()
    let deckA: DeckViewModel
    let deckB: DeckViewModel
    private var mixer = Mixer()
    var sync = SyncEngine()
    let recorder = MasterRecorder()
    @Published var crossfader: Double = 0.5
    @Published var syncMaster = 0
    @Published var isRecording = false
    // Slice 8: MIDI-Learn-Zustand
    @Published var learning = false
    @Published var learnAction: DeckAction?

    /// Lern-Modus starten: nächste MIDI-Botschaft wird auf `action` gemappt.
    func startLearn(_ action: DeckAction) {
        learnAction = action
        learning = true
    }

    func cancelLearn() {
        learning = false
        learnAction = nil
    }
    @Published var library: [NMLTrack] = []
    @Published var searchText = ""

    init() {
        deckA = DeckViewModel(index: 0, engine: audio)
        deckB = DeckViewModel(index: 1, engine: audio)
        loadLibrary()
        loadLearnedMappings()
    }

    func setCrossfader(_ x: Double) {
        crossfader = x
        applyCrossfader(x)
    }

    func applyCrossfader(_ x: Double) {
        mixer.crossfader = x
        // ×2 gleicht die −3 dB in Mitte aus (equal-power: Mitte = 0.5 je Kanal).
        deckA.applyMixerVolume(deckA.fader * mixer.outputGain(channel: 0) * 2)
        deckB.applyMixerVolume(deckB.fader * mixer.outputGain(channel: 1) * 2)
    }

    /// Slice 6: Deck-Regler auf Master-BPM setzen.
    func toggleSyncMaster() { sync.toggleMaster(syncMaster == 0 ? 1 : 0) }

    func syncDeck(_ slave: Int) {
        let masterVM = sync.masterDeck == 0 ? deckA : deckB
        let slaveVM = slave == 0 ? deckA : deckB
        guard let mb = masterBPM(of: masterVM), let sb = slaveBPM(of: slaveVM) else { return }
        let pitch = sync.slavePitch(master: BeatGrid(bpm: mb), slave: BeatGrid(bpm: sb))
        slaveVM.setPitch(pitch)
    }

    private func masterBPM(of vm: DeckViewModel) -> Double? { vm.bpm }
    private func slaveBPM(of vm: DeckViewModel) -> Double? { vm.bpm }

    // MARK: Recording (Slice 5)
    func startRecording(to url: URL) throws {
        try recorder.start(engine: audio.engine, url: url)
        isRecording = true
    }

    func stopRecording() {
        recorder.stop(engine: audio.engine)
        isRecording = false
    }

    // MARK: Library (Slice 2)
    private func loadLibrary() {
        let url = URL(fileURLWithPath: NSString(string: "~/Documents/Native Instruments/Traktor 4.5.0/collection.nml").expandingTildeInPath)
        library = NMLParser.parse(url: url)
    }

    func load(track: NMLTrack, deck: Int) {
        guard !track.path.isEmpty else { return }
        var path = track.path
        if path.hasPrefix("/") == false && !path.contains(":") { path = "/" + path }
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let vm = deck == 0 ? deckA : deckB
        vm.load(url: url)
        vm.bpm = track.bpm
    }

    // MARK: MIDI-Learn-Persistenz
    private func loadLearnedMappings() {
        for l in MappingStore.loadOrDefault(from: MappingStore.defaultURL()) {
            if let a = l.assignment { midiRouter?.assign(a) }
        }
    }
    weak var midiRouter: MIDIActionRouter?
    func saveMappings(_ mappings: [LearnedMapping]) {
        try? MappingStore.save(mappings, to: MappingStore.defaultURL())
    }

    func wire(midi: MIDIController) {
        midiRouter = midi.router
        midi.router.onAction = { [weak self] action, value in
            Task { @MainActor in
                guard let self else { return }
                // MIDI-Learn: im Lern-Modus wird die erste Botschaft zugewiesen statt ausgeführt
                if self.learning, let target = self.learnAction,
                   let raw = midi.lastRaw {
                    midi.router.assign(MIDIAssignment(channel: raw.channel, isCC: raw.isCC,
                                                     control: raw.control, action: target))
                    self.saveMappings(midi.router.assignments.map(\.learned))
                    self.learning = false
                    self.learnAction = nil
                    return
                }
                switch action {
                case .playPause: self.deckA.togglePlay()
                case .cue: self.deckA.cue()
                case .hotcue1: self.deckA.hotcue(1)
                case .hotcue2: self.deckA.hotcue(2)
                case .hotcue3: self.deckA.hotcue(3)
                case .hotcue4: self.deckA.hotcue(4)
                case .crossfader: self.setCrossfader(Double(value) / 127)
                case .channelFaderA: self.deckA.fader = Double(value) / 127; self.deckA.applyMixerVolume(self.deckA.fader)
                case .channelFaderB: self.deckB.fader = Double(value) / 127; self.deckB.applyMixerVolume(self.deckB.fader)
                case .pitchA: self.deckA.setPitch(Double(value - 64) / 64 * self.deckA.state.pitchRange)
                case .pitchB: self.deckB.setPitch(Double(value - 64) / 64 * self.deckB.state.pitchRange)
                case .keylockA: self.deckA.state.toggleKeylock()
                case .keylockB: self.deckB.state.toggleKeylock()
                case .loopIn: self.deckA.state.loopIn()
                case .loopOut: self.deckA.state.loopOut()
                case .loopExit: self.deckA.state.loopExit()
                }
            }
        }
        // Demo-Mapping + gelernte Mappings (Persistenz)
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x24, action: .playPause))
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x25, action: .cue))
        midi.router.assign(.init(channel: 0, isCC: true, control: 7, action: .crossfader))
        for l in MappingStore.loadOrDefault(from: MappingStore.defaultURL()) {
            if let a = l.assignment { midi.router.assign(a) }
        }
    }
}

/// CoreMIDI-Input: listet Sources, verbindet alle, reicht Events an den Router.
@MainActor
final class MIDIController: ObservableObject {
    @Published var status = "MIDI: suche Geräte…"
    let router = MIDIActionRouter()
    /// Letzter eingegangener Event (Channel, isCC, Control) — für MIDI-Learn.
    @Published var lastRaw: (channel: UInt8, isCC: Bool, control: UInt8)?
    private var client: MIDIClientRef = 0
    private var port: MIDIPortRef = 0

    init() {
        let s = MIDIClientCreate("TraktorClone" as CFString, nil, nil, &client)
        guard s == noErr else { status = "MIDI: Client-Fehler \(s)"; return }
        status = "MIDI: \(numberOfSources) Quelle(n)"
        guard numberOfSources > 0 else { return }
        let result = MIDIInputPortCreate(client, "in" as CFString, MIDIController.readProc, Unmanaged.passUnretained(self).toOpaque(), &port)
        guard result == noErr else { status = "MIDI: Port-Fehler \(result)"; return }
        for i in 0..<numberOfSources {
            let src = MIDIGetSource(i)
            _ = MIDIPortConnectSource(port, src, nil)
        }
        status = "MIDI: \(numberOfSources) Quelle(n) verbunden"
    }

    private var numberOfSources: Int { MIDIGetNumberOfSources() }

    nonisolated fileprivate static let readProc: MIDIReadProc = { pktList, _, refCon in
        guard let refCon else { return }
        let controller = Unmanaged<MIDIController>.fromOpaque(refCon).takeUnretainedValue()
        var packet = pktList.pointee.packet
        for _ in 0..<pktList.pointee.numPackets {
            let n = Int(packet.length)
            let bytes: [UInt8] = withUnsafePointer(to: &packet.data) {
                $0.withMemoryRebound(to: UInt8.self, capacity: n) {
                    Array(UnsafeBufferPointer(start: $0, count: n))
                }
            }
            Task { @MainActor in
                // Slice 8: Rohevent für MIDI-Learn mitschreiben (Note-On/CC, 3 Bytes)
                if bytes.count >= 3 {
                    let type = bytes[0] & 0xF0
                    if type == 0x90 || type == 0xB0 {
                        controller.lastRaw = (bytes[0] & 0x0F, type == 0xB0, bytes[1])
                    }
                }
                controller.router.route(event: bytes)
            }
            packet = MIDIPacketNext(&packet).pointee
        }
    }
}
