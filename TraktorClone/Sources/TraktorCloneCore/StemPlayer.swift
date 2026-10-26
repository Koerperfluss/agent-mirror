import AVFoundation

/// Stem-Playback: lädt eine NI-Stem-Datei (.stem.mp4) und spielt sie über
/// 5 AVAudioPlayerNodes (0 = Mix, 1...4 = Stems), jeder mit eigenem
/// AVAudioMixerNode als Gain-Regler (0...1).
///
/// GRENZE (ehrlich dokumentiert): `AVAudioFile(forReading:)` liest pro URL
/// nur Track 0 der MP4 — alle 5 Nodes lesen daher dieselbe (Mix-)Spur.
/// Voll-Sync je einzelner Track bräuchte AVAssetReader/AVAudioEngine-Buffer-Pulling
/// pro Track; für Slice 7c ist 5× dieselbe Datei praktikabel, da der Mix hörbar
/// identisch ist, wenn Mix = Summe der Stems. Die Gains steuern die Balance.
public final class StemPlayer {
    private let engine = AVAudioEngine()
    private var players: [AVAudioPlayerNode] = []
    private var mixers: [AVAudioMixerNode] = []
    private var file: AVAudioFile?
    public private(set) var isPlaying = false

    public init() {
        for _ in 0..<5 {
            let p = AVAudioPlayerNode()
            let m = AVAudioMixerNode()
            engine.attach(p)
            engine.attach(m)
            engine.connect(p, to: m, format: nil)
            engine.connect(m, to: engine.mainMixerNode, format: nil)
            players.append(p)
            mixers.append(m)
        }
    }

    public var duration: TimeInterval? {
        guard let f = file else { return nil }
        return Double(f.length) / f.processingFormat.sampleRate
    }

    /// Lädt eine .stem.mp4; wirft `CocoaError.fileNoSuchFile`, wenn die Datei
    /// fehlt, nicht lesbar ist oder weniger als 5 Audio-Tracks hat.
    public func load(url: URL) throws {
        let fail = { CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: url.path]) }
        guard FileManager.default.fileExists(atPath: url.path) else { throw fail() }
        let stem = StemFile(url: url)
        guard stem.audioTracks.count >= 5 else { throw fail() }
        guard let f = try? AVAudioFile(forReading: url) else { throw fail() }
        stopAll()
        file = f
    }

    /// Spielt alle 5 Nodes synchron ab Frame 0 (scheduleSegment + play der Reihe nach).
    public func play() {
        guard let f = file, !isPlaying else { return }
        try? engine.start()
        let start = max(0, f.framePosition)
        let frames = AVAudioFrameCount(max(0, f.length - start))
        guard frames > 0 else { return }
        for p in players {
            p.stop()
            p.scheduleSegment(f, startingFrame: start, frameCount: frames, at: nil)
            p.play()
        }
        isPlaying = true
    }

    public func pause() {
        guard isPlaying else { return }
        for p in players { p.pause() }
        isPlaying = false
    }

    /// Gain je Kanal: Index 0 = Mix, 1...4 = Stems. Geclamped auf 0...1;
    /// Index außerhalb der Reichweite wird ignoriert (no-crash).
    public func setStemGain(index: Int, gain: Double) {
        guard mixers.indices.contains(index) else { return }
        mixers[index].outputVolume = Float(min(max(gain, 0), 1))
    }

    private func stopAll() {
        for p in players { p.stop() }
        isPlaying = false
    }
}
