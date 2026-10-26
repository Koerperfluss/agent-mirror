import SwiftUI
import TraktorCloneCore
import CoreMIDI

/// Root-UI: 2 Decks + Mixer + MIDI-Status. Tastatur: A-Deck Q(load)/W(play)/E(cue)/1-4(hotcues),
/// B-Deck U/I/O + 7-0? — bewusst simpel (Slice 1): Space = Deck A Play.
struct ContentView: View {
    @EnvironmentObject var midi: MIDIController
    @StateObject private var engineHost = EngineHost()

    var body: some View {
        VStack(spacing: 12) {
            midiBar
            HStack(spacing: 16) {
                deckView(vm: engineHost.deckA, label: "A", keys: ("q", "w", "e"))
                mixerView
                deckView(vm: engineHost.deckB, label: "B", keys: ("u", "i", "o"))
            }
        }
        .padding(16)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear { engineHost.wire(midi: midi) }
    }

    private var midiBar: some View {
        HStack {
            Image(systemName: "pianokeys")
            Text(midi.status).font(.caption).foregroundStyle(.secondary)
            Spacer()
            Text("TraktorClone 0.1 · Slice 1").font(.caption2).foregroundStyle(.tertiary)
        }
    }

    private func deckView(vm: DeckViewModel, label: String, keys: (load: String, play: String, cue: String)) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Deck \(label)").font(.headline)
                Spacer()
                Text(vm.title).font(.caption).lineLimit(1).truncationMode(.middle)
            }
            Text(timeString(vm.playhead) + " / " + timeString(vm.state.duration))
                .font(.system(.body, design: .monospaced))
            HStack {
                Button("Load") { vm.load() }.keyboardShortcut(KeyEquivalent(Character(keys.load)), modifiers: [])
                Button(vm.state.isPlaying ? "Pause" : "Play") { vm.togglePlay() }
                    .keyboardShortcut(KeyEquivalent(Character(keys.play)), modifiers: [])
                Button("Cue") { vm.cue() }.keyboardShortcut(KeyEquivalent(Character(keys.cue)), modifiers: [])
            }
            HStack(spacing: 6) {
                ForEach(1...4, id: \.self) { i in
                    Button("\(i)") { vm.hotcue(i) }
                        .frame(width: 34)
                }
            }
            HStack {
                Text("Pitch").font(.caption)
                Slider(value: Binding(
                    get: { vm.pitch },
                    set: { vm.setPitch($0) }
                ), in: -vm.state.pitchRange...vm.state.pitchRange)
                Text(String(format: "%+.1f%%", vm.pitch * 100))
                    .font(.system(.caption, design: .monospaced)).frame(width: 56)
            }
            Button(vm.state.keylock ? "Keylock ✓" : "Keylock") { vm.state.toggleKeylock() }
                .buttonStyle(.bordered)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .controlBackgroundColor)))
    }

    private var mixerView: some View {
        VStack(spacing: 14) {
            Text("Mixer").font(.headline)
            HStack(alignment: .bottom, spacing: 18) {
                VStack { fader(vm: engineHost.deckA) ; Text("A").font(.caption) }
                VStack {
                    Slider(value: Binding(
                        get: { engineHost.crossfader },
                        set: { engineHost.setCrossfader($0) }
                    ), in: 0...1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 120, height: 24)
                    Text("X-Fade").font(.caption)
                }
                VStack { fader(vm: engineHost.deckB) ; Text("B").font(.caption) }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(nsColor: .controlBackgroundColor)))
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

    private func timeString(_ t: TimeInterval) -> String {
        guard t.isFinite, t >= 0 else { return "0:00" }
        return String(format: "%d:%05.2f", Int(t) / 60, t.truncatingRemainder(dividingBy: 60))
    }
}

/// Hält AudioEngine + Decks + Mixer-Verkabelung.
@MainActor
final class EngineHost: ObservableObject {
    let audio = AudioEngine()
    let deckA: DeckViewModel
    let deckB: DeckViewModel
    private var mixer = Mixer()
    @Published var crossfader: Double = 0.5

    init() {
        deckA = DeckViewModel(index: 0, engine: audio)
        deckB = DeckViewModel(index: 1, engine: audio)
        _ = mixer
    }

    func setCrossfader(_ x: Double) {
        crossfader = x
        applyCrossfader(x)
    }

    func applyCrossfader(_ x: Double) {
        mixer.crossfader = x
        // ×2 gleicht die −3 dB in Crossfader-Mitte aus (equal-power: Mitte = 0.5 je Kanal),
        // damit volle Fader-Stellung bei Mittelstellung noch Full Scale liefert.
        deckA.applyMixerVolume(deckA.fader * mixer.outputGain(channel: 0) * 2)
        deckB.applyMixerVolume(deckB.fader * mixer.outputGain(channel: 1) * 2)
    }

    /// MIDI-Aktionen auf Decks mappen (Router aus MIDIController).
    func wire(midi: MIDIController) {
        midi.router.onAction = { [weak self] action, value in
            Task { @MainActor in
                guard let self else { return }
                switch action {
                case .playPause: self.deckA.togglePlay()
                case .cue: self.deckA.cue()
                case .hotcue1: self.deckA.hotcue(1)
                case .hotcue2: self.deckA.hotcue(2)
                case .hotcue3: self.deckA.hotcue(3)
                case .hotcue4: self.deckA.hotcue(4)
                case .crossfader: self.applyCrossfader(Double(value) / 127)
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
        // Demo-Mapping: generische Standardzuweisung (MIDI-Learn folgt Slice 2)
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x24, action: .playPause))
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x25, action: .cue))
        midi.router.assign(.init(channel: 0, isCC: true, control: 7, action: .crossfader))
    }
}

/// CoreMIDI-Input: listet Sources, verbindet die erste gefundene, reicht Events an den Router.
@MainActor
final class MIDIController: ObservableObject {
    @Published var status = "MIDI: suche Geräte…"
    let router = MIDIActionRouter()
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

    /// C-Callback → Router (thread-safe über MainActor-Hop).
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
            Task { @MainActor in controller.router.route(event: bytes) }
            packet = MIDIPacketNext(&packet).pointee
        }
    }
}
