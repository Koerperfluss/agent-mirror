import SwiftUI
import TraktorCloneCore
import CoreMIDI
import AppKit

/// Hält AudioEngine + Decks + Mixer + Sync + Recorder + Library + MIDI-Learn + Auto-DJ.
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
    @Published var learning = false
    @Published var learnAction: DeckAction?
    @Published var autoDjEnabled = false
    private var autoDj = AutoDJ()
    private var finishTimer: Timer?
    @Published var library: [NMLTrack] = []
    @Published var searchText = ""

    init() {
        deckA = DeckViewModel(index: 0, engine: audio)
        deckB = DeckViewModel(index: 1, engine: audio)
        loadLibrary()
    }

    func setCrossfader(_ x: Double) {
        crossfader = x
        applyCrossfader(x)
    }

    func applyCrossfader(_ x: Double) {
        mixer.crossfader = x
        deckA.applyMixerVolume(deckA.fader * mixer.outputGain(channel: 0) * 2)
        deckB.applyMixerVolume(deckB.fader * mixer.outputGain(channel: 1) * 2)
    }

    func toggleSyncMaster() { sync.toggleMaster(syncMaster == 0 ? 1 : 0) }

    func syncDeck(_ slave: Int) {
        let masterVM = sync.masterDeck == 0 ? deckA : deckB
        let slaveVM = slave == 0 ? deckA : deckB
        guard let mb = masterVM.bpm, let sb = slaveVM.bpm else { return }
        let pitch = sync.slavePitch(master: BeatGrid(bpm: mb), slave: BeatGrid(bpm: sb))
        slaveVM.setPitch(pitch)
    }

    // MARK: Recording
    func startRecording(to url: URL) throws {
        try recorder.start(engine: audio.engine, url: url)
        isRecording = true
    }

    func stopRecording() {
        recorder.stop(engine: audio.engine)
        isRecording = false
    }

    // MARK: Auto-DJ
    func toggleAutoDJ() {
        autoDjEnabled.toggle()
        autoDj.enabled = autoDjEnabled
        if autoDjEnabled { startFinishWatcher() } else { finishTimer?.invalidate() }
    }

    private func startFinishWatcher() {
        finishTimer?.invalidate()
        finishTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.autoDjEnabled, self.library.isEmpty == false else { return }
                for vm in [self.deckA, self.deckB] {
                    let remaining = vm.state.duration - vm.playhead
                    if vm.state.isPlaying, vm.state.duration > 0,
                       remaining < 5, remaining > 0, !vm.autoDjArmed {
                        vm.autoDjArmed = true
                        if let next = self.autoDj.next(from: self.library) {
                            let other = vm === self.deckA ? self.deckB : self.deckA
                            self.load(track: next, deck: other.index)
                            if !other.state.isPlaying { other.togglePlay() }
                        }
                    } else if !vm.state.isPlaying || remaining > 10 {
                        vm.autoDjArmed = false
                    }
                }
            }
        }
    }

    // MARK: MIDI-Learn
    func startLearn(_ action: DeckAction) {
        learnAction = action
        learning = true
    }

    func cancelLearn() {
        learning = false
        learnAction = nil
    }

    // MARK: Library
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
    func saveMappings(_ mappings: [LearnedMapping]) {
        try? MappingStore.save(mappings, to: MappingStore.defaultURL())
    }

    func wire(midi: MIDIController) {
        midi.router.onAction = { [weak self] action, value in
            Task { @MainActor in
                guard let self else { return }
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
                case .channelFaderA:
                    self.deckA.fader = Double(value) / 127
                    self.deckA.applyMixerVolume(self.deckA.fader)
                case .channelFaderB:
                    self.deckB.fader = Double(value) / 127
                    self.deckB.applyMixerVolume(self.deckB.fader)
                case .pitchA:
                    self.deckA.setPitch(Double(value - 64) / 64 * self.deckA.state.pitchRange)
                case .pitchB:
                    self.deckB.setPitch(Double(value - 64) / 64 * self.deckB.state.pitchRange)
                case .keylockA: self.deckA.state.toggleKeylock()
                case .keylockB: self.deckB.state.toggleKeylock()
                case .loopIn: self.deckA.state.loopIn()
                case .loopOut: self.deckA.state.loopOut()
                case .loopExit: self.deckA.state.loopExit()
                }
            }
        }
        // Demo-Mapping + gelernte Mappings
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x24, action: .playPause))
        midi.router.assign(.init(channel: 0, isCC: false, control: 0x25, action: .cue))
        midi.router.assign(.init(channel: 0, isCC: true, control: 7, action: .crossfader))
        for l in MappingStore.loadOrDefault(from: MappingStore.defaultURL()) {
            if let a = l.assignment { midi.router.assign(a) }
        }
    }
}

/// CoreMIDI-Input: verbindet alle Sources, reicht Events an Router.
@MainActor
final class MIDIController: ObservableObject {
    @Published var status = "MIDI: suche …"
    let router = MIDIActionRouter()
    @Published var lastRaw: (channel: UInt8, isCC: Bool, control: UInt8)?
    private var client: MIDIClientRef = 0
    private var port: MIDIPortRef = 0

    init() {
        let s = MIDIClientCreate("TraktorClone" as CFString, nil, nil, &client)
        guard s == noErr else { status = "MIDI: Fehler \(s)"; return }
        let n = MIDIGetNumberOfSources()
        guard n > 0 else { status = "MIDI: keine Geräte"; return }
        let r = MIDIInputPortCreate(client, "in" as CFString, MIDIController.readProc,
                                    Unmanaged.passUnretained(self).toOpaque(), &port)
        guard r == noErr else { status = "MIDI: Port-Fehler \(r)"; return }
        for i in 0..<n { _ = MIDIPortConnectSource(port, MIDIGetSource(i), nil) }
        status = "MIDI: \(n) verbunden"
    }

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
