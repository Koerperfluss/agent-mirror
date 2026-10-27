import AVFoundation

/// Stem-Playback: lädt eine NI-Stem-Datei (.stem.mp4) und spielt alle 5 Tracks
/// (0 = Mix, 1...4 = Stems) über je einen AVAudioPlayerNode mit eigenem
/// AVAudioMixerNode als Gain-Regler (0...1).
///
/// Echter Mehrtrack-Weg (Slice 8): `AVAudioFile` liest pro URL nur Track 0 —
/// deshalb konvertiert `load` zunächst ALLE Tracks einmalig offline in
/// Temp-WAVs (via `StemExporter`, AVAssetReader-Pump) und öffnet dann je Track
/// eine eigene Datei. Kosten: einmalige Konvertierung beim Laden (Sekunden);
/// danach echtes 4-Stem-Mischen mit Solo/Mute über die Gains.
public final class StemPlayer {
    private let engine = AVAudioEngine()
    private var players: [AVAudioPlayerNode] = []
    private var mixers: [AVAudioMixerNode] = []
    private var files: [AVAudioFile] = []          // 0 = Mix, 1...4 = Stems
    private var tempDir: URL?                       // zum Aufräumen beim nächsten load
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

    /// Längste gemeinsame Abspiel-Dauer (kürzester Track bestimmt das Ende).
    public var duration: TimeInterval? {
        guard !files.isEmpty else { return nil }
        let durs = files.map { Double($0.length) / $0.processingFormat.sampleRate }
        return durs.min()
    }

    /// Lädt eine .stem.mp4; wirft `CocoaError.fileNoSuchFile`, wenn die Datei
    /// fehlt, nicht lesbar ist, weniger als 5 Audio-Tracks hat oder die
    /// Konvertierung fehlschlägt.
    public func load(url: URL) throws {
        let fail = { CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: url.path]) }
        guard FileManager.default.fileExists(atPath: url.path) else { throw fail() }
        let stem = StemFile(url: url)
        guard stem.audioTracks.count >= 5 else { throw fail() }

        stopAll()
        cleanupTemp()

        // Offline-Konvertierung: alle 5 Tracks → einzelne WAVs (AVAssetReader-Pump)
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("stems-\(UUID().uuidString)", isDirectory: true)
        let result = try StemExporter.exportAll(from: url, toDirectory: dir)
        guard result.urls.count >= 5 else { throw fail() }

        let opened = try result.urls.prefix(5).map { try AVAudioFile(forReading: $0) }
        files = Array(opened)
        tempDir = dir
    }

    /// Spielt alle 5 Tracks synchron ab Frame 0.
    public func play() {
        guard !files.isEmpty, !isPlaying else { return }
        try? engine.start()
        // Sync-Start: kürzester Track begrenzt (bei NI-Stems identische Länge)
        guard let minFrames = files.map({ $0.length }).min(), minFrames > 0 else { return }
        for (i, p) in players.enumerated() {
            let f = files[i]
            let start = max(0, f.framePosition)
            let frames = AVAudioFrameCount(max(0, min(f.length, minFrames) - start))
            guard frames > 0 else { continue }
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

    /// Gain je Kanal: Index 0 = Mix, 1...4 = Stems (Solo/Mute über 0/1).
    /// Index außerhalb der Reichweite wird ignoriert (no-crash).
    public func setStemGain(index: Int, gain: Double) {
        guard mixers.indices.contains(index) else { return }
        mixers[index].outputVolume = Float(min(max(gain, 0), 1))
    }

    private func stopAll() {
        for p in players { p.stop() }
        isPlaying = false
    }

    private func cleanupTemp() {
        guard let dir = tempDir else { return }
        try? FileManager.default.removeItem(at: dir)
        tempDir = nil
        files = []
    }

    deinit { cleanupTemp() }
}
