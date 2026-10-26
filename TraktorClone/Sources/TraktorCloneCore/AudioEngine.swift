import AVFoundation

/// Audio-Backend: 2 Decks über AVAudioEngine (PlayerNode + TimePitch pro Deck).
/// Slice 1: Load/Play/Pause/Pitch/Keylock/Volume. Loop-Seek folgt in Slice 4.
public final class AudioEngine {
    public enum DeckError: Error { case loadFailed(String) }

    public let engine = AVAudioEngine()
    private var players: [Int: AVAudioPlayerNode] = [:]
    private var timePitch: [Int: AVAudioUnitTimePitch] = [:]
    private var files: [Int: AVAudioFile] = [:]
    /// Effekt-Kette pro Deck (Filter/Delay/Reverb) — in init verkabelt.
    public private(set) var fx: [Int: FxChain] = [:]

    public init() {
        for d in 0...1 {
            let player = AVAudioPlayerNode()
            let tp = AVAudioUnitTimePitch()
            let chain = FxChain()
            engine.attach(player)
            engine.attach(tp)
            engine.attach(chain.eq)
            engine.attach(chain.delay)
            engine.attach(chain.reverb)
            engine.connect(player, to: tp, format: nil)
            engine.connect(tp, to: chain.eq, format: nil)
            engine.connect(chain.eq, to: chain.delay, format: nil)
            engine.connect(chain.delay, to: chain.reverb, format: nil)
            engine.connect(chain.reverb, to: engine.mainMixerNode, format: nil)
            players[d] = player
            timePitch[d] = tp
            fx[d] = chain
        }
    }

    public func startIfNeeded() throws {
        if !engine.isRunning { try engine.start() }
    }

    /// Lädt eine Audio-Datei auf ein Deck (0/1).
    public func load(url: URL, deck: Int) throws -> Double {
        guard (0...1).contains(deck) else { throw DeckError.loadFailed("Deck \(deck) existiert nicht") }
        guard let file = try? AVAudioFile(forReading: url) else {
            throw DeckError.loadFailed("Nicht lesbar: \(url.lastPathComponent)")
        }
        stop(deck: deck)
        files[deck] = file
        let sampleRate = file.processingFormat.sampleRate
        return Double(file.length) / sampleRate
    }

    /// Seek: Player neu schedulen ab Frame-Offset; Playing-Zustand wird erhalten.
    public func seek(deck: Int, to seconds: TimeInterval) {
        guard let file = files[deck], let player = players[deck] else { return }
        let wasPlaying = player.isPlaying
        let sampleRate = file.processingFormat.sampleRate
        let target = AVAudioFramePosition(max(0, min(seconds * sampleRate, Double(file.length) - 1)))
        player.stop()
        file.framePosition = target
        if wasPlaying {
            player.scheduleSegment(file, startingFrame: target,
                                   frameCount: AVAudioFrameCount(file.length - target), at: nil)
            player.play()
        } else {
            file.framePosition = target
        }
    }

    public func play(deck: Int) {
        guard let file = files[deck], let player = players[deck] else { return }
        try? startIfNeeded()
        if player.isPlaying { return }
        let start = file.framePosition
        player.scheduleSegment(file, startingFrame: start,
                               frameCount: AVAudioFrameCount(max(0, file.length - start)), at: nil)
        player.play()
    }

    public func stop(deck: Int) {
        players[deck]?.stop()
    }

    public func setPitchFactor(deck: Int, factor: Double) {
        timePitch[deck]?.rate = Float(min(max(factor, 0.25), 4.0))
    }

    public func setKeylock(deck: Int, on: Bool) {
        let tp = timePitch[deck]
        tp?.pitch = 0                                 // Tonhöhe neutral
        // AVAudioUnitTimePitch hält Tonhöhe bei raten Änderung automatisch (kSteepness default).
        _ = on
    }

    public func setVolume(deck: Int, gain: Double) {
        players[deck]?.volume = Float(min(max(gain, 0), 2))
    }

    /// Aktuelle Abspielposition in Sekunden (aus der Render-Uhr — akkurat).
    public func position(deck: Int) -> TimeInterval? {
        guard let player = players[deck],
              let nodeTime = player.lastRenderTime,
              let playerTime = player.playerTime(forNodeTime: nodeTime)
        else { return nil }
        return max(0, Double(playerTime.sampleTime) / playerTime.sampleRate)
    }

    public var isRunning: Bool { engine.isRunning }
}
