import AVFoundation

/// Audio-Backend: 2 Decks über AVAudioEngine (PlayerNode + TimePitch + FX-Kette
/// pro Deck), Stem-Player je Deck (echtes 4-Stem), VU-Pegel-Messung, Loops.
public final class AudioEngine {
    public enum DeckError: Error { case loadFailed(String) }

    public let engine = AVAudioEngine()
    private var players: [Int: AVAudioPlayerNode] = [:]
    private var timePitch: [Int: AVAudioUnitTimePitch] = [:]
    private var files: [Int: AVAudioFile] = [:]
    /// Effekt-Kette pro Deck (Filter/Delay/Reverb) — in init verkabelt.
    public private(set) var fx: [Int: FxChain] = [:]
    /// Slice 8: Stem-Player pro Deck (echtes 4-Stem-Playback über eigene Dateien).
    private var stemPlayers: [Int: StemPlayer] = [:]
    /// Slice 8: Pegel-Messung je Deck (Peak 0...1, per Tap).
    private var deckLevels: [Int: Double] = [0: 0, 1: 0]
    private var lastTapTime: [Int: TimeInterval] = [0: 0, 1: 0]

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
            installMeter(deck: d, node: chain.reverb)
        }
    }

    /// VU-Pegel (Peak 0...1) je Deck; verfällt, wenn keine Buffer mehr kommen.
    public func level(deck: Int) -> Double {
        let now = ProcessInfo.processInfo.systemUptime
        guard let last = lastTapTime[deck], now - last < 0.15 else { return 0 }
        return deckLevels[deck] ?? 0
    }

    private func installMeter(deck: Int, node: AVAudioNode) {
        let fmt = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buffer, _ in
            guard let self, let ch = buffer.floatChannelData?[0] else { return }
            var peak: Float = 0
            for i in 0..<Int(buffer.frameLength) {
                let v = abs(ch[i])
                if v > peak { peak = v }
            }
            self.deckLevels[deck] = Double(peak)
            self.lastTapTime[deck] = ProcessInfo.processInfo.systemUptime
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
        stemPlayers[deck] = nil                          // Stem-Modus verlassen
        files[deck] = file
        let sampleRate = file.processingFormat.sampleRate
        return Double(file.length) / sampleRate
    }

    /// Slice 8: Stem-Datei laden (echte 5-Track-Wiedergabe); wirft bei Fehlern durch.
    public func loadStem(url: URL, deck: Int) throws -> Double {
        guard (0...1).contains(deck) else { throw DeckError.loadFailed("Deck \(deck) existiert nicht") }
        let sp = stemPlayers[deck] ?? StemPlayer()
        try sp.load(url: url)
        players[deck]?.stop()
        files[deck] = nil
        stemPlayers[deck] = sp
        return sp.duration ?? 0
    }

    public func isStemDeck(_ deck: Int) -> Bool { stemPlayers[deck] != nil }

    public func stemGain(deck: Int, stem: Int, gain: Double) {
        stemPlayers[deck]?.setStemGain(index: stem, gain: gain)
    }

    /// Seek: Player neu schedulen ab Frame-Offset; Playing-Zustand wird erhalten.
    public func seek(deck: Int, to seconds: TimeInterval) {
        if let sp = stemPlayers[deck] { sp.seek(to: seconds); return }
        guard let file = files[deck], let player = players[deck] else { return }
        let sampleRate = file.processingFormat.sampleRate
        let target = AVAudioFramePosition(max(0, min(seconds * sampleRate, Double(file.length) - 1)))
        guard file.length - target > 0 else { return }      // kein 0-Frame-Schedule am Dateiende
        let wasPlaying = player.isPlaying
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
        try? startIfNeeded()
        if let sp = stemPlayers[deck] { sp.play(); return }
        guard let file = files[deck], let player = players[deck] else { return }
        if player.isPlaying { return }
        let start = file.framePosition
        player.scheduleSegment(file, startingFrame: start,
                               frameCount: AVAudioFrameCount(max(0, file.length - start)), at: nil)
        player.play()
    }

    public func stop(deck: Int) {
        if let sp = stemPlayers[deck] { sp.pause(); return }
        players[deck]?.stop()
    }

    /// Pause mit Präzision: aktuelle playerTime-Position wird in
    /// `file.framePosition` zurückgeschrieben, damit `play(deck:)` exakt dort
    /// weiterscheduled (Stem-Decks pausiert der StemPlayer selbst).
    public func pause(deck: Int) {
        if let sp = stemPlayers[deck] { sp.pause(); return }
        guard let file = files[deck], let player = players[deck] else { return }
        var pos = Double(file.framePosition)
        if let nodeTime = player.lastRenderTime,
           let playerTime = player.playerTime(forNodeTime: nodeTime) {
            pos += Double(playerTime.sampleTime)
        }
        player.pause()
        file.framePosition = AVAudioFramePosition(max(0, min(pos, Double(file.length))))
    }

    // MARK: - Loop

    /// Loop pro Deck. MECHANISMUS: repeating Timer alle (Loop-Dauer) macht
    /// `seek(deck:to:)` zurück zum Loop-Start — simplest, robust, `disableLoop` stoppt ihn.
    private struct LoopState {
        let startSec: Double
        let endSec: Double
        var timer: Timer?
    }
    private var loops: [Int: LoopState] = [:]

    public func enableLoop(deck: Int, startSec: Double, endSec: Double) {
        guard (0...1).contains(deck), endSec > startSec else { return }
        disableLoop(deck: deck)
        let duration = endSec - startSec
        // Swift-6-Concurrency: Timer-Closure ist @Sendable; Engine ist nicht
        // Sendable, deshalb bewusst unsafe entkoppelt (Nutzung nur im UI-Kontext).
        nonisolated(unsafe) let engine = self
        let timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            engine.seek(deck: deck, to: startSec)
        }
        loops[deck] = LoopState(startSec: startSec, endSec: endSec, timer: timer)
    }

    public func disableLoop(deck: Int) {
        loops[deck]?.timer?.invalidate()
        loops[deck] = nil
    }

    public func loopActive(deck: Int) -> Bool {
        loops[deck] != nil
    }

    public func setPitchFactor(deck: Int, factor: Double) {
        timePitch[deck]?.rate = Float(min(max(factor, 0.25), 4.0))
    }

    public func setKeylock(deck: Int, on: Bool) {
        timePitch[deck]?.pitch = 0                      // Tonhöhe neutral (Keylock)
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
