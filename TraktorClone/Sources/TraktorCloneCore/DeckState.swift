import Foundation

/// Zustandsmaschine eines Decks: Load → Ready → Playing/Paused, Hotcues, Loop, Pitch.
/// Reine Logik — kein Audio-I/O (testbar, ponytail). UI koppelt an AudioEngine.
public struct DeckState {
    public enum PlayState: Equatable { case idle, ready, playing, paused }

    public private(set) var playState: PlayState = .idle
    public private(set) var duration: TimeInterval = 0
    public private(set) var trackTitle: String = ""

    /// Pitch-Faktor als Halbtöne-Anteil: -1...1 → Rate 0.5...2.0 (±50 %).
    /// Traktor-Standardbereich ±8 % → UI clamp ±0.08 pro Einheit? Nein: pitchRange wählbar.
    public private(set) var pitch: Double = 0          // -pitchRange...pitchRange
    public var pitchRange: Double = 0.08               // ±8 %
    public private(set) var keylock: Bool = false

    public private(set) var position: TimeInterval = 0
    public private(set) var cuePoint: TimeInterval = 0
    public private(set) var hotcues: [Int: TimeInterval] = [:]
    public private(set) var loopStart: TimeInterval?
    public private(set) var loopEnd: TimeInterval?
    public private(set) var loopActive: Bool = false

    /// Monotone Zeitbasis für playhead (kein Audio-Callback nötig).
    private var playStartReference: TimeInterval = 0   // ProcessInfo uptime
    private var positionAtStart: TimeInterval = 0

    public init() {}

    public var rate: Double { 1.0 + pitch }             // Pitch 0.08 → 1.08×
    public var isPlaying: Bool { playState == .playing }
    public var loopContains: Bool {
        guard let s = loopStart, let e = loopEnd else { return false }
        return loopActive && position >= s && position < e
    }

    public mutating func load(title: String, duration: TimeInterval) {
        precondition(duration > 0, "Track-Dauer muss > 0 sein")
        self.trackTitle = title
        self.duration = duration
        position = 0; cuePoint = 0; hotcues = [:]
        loopStart = nil; loopEnd = nil; loopActive = false
        playState = .ready
    }

    public mutating func play(now: TimeInterval) {
        guard playState == .ready || playState == .paused else { return }
        playState = .playing
        positionAtStart = position
        playStartReference = now
    }

    public mutating func pause(now: TimeInterval) {
        guard playState == .playing else { return }
        position = currentPlayhead(now: now)
        playState = .paused
    }

    /// Playhead basierend auf externaler Uhr (App übergibt systemUptime).
    public func currentPlayhead(now: TimeInterval) -> TimeInterval {
        guard playState == .playing else { return position }
        var t = positionAtStart + (now - playStartReference) * rate
        if loopActive, let s = loopStart, let e = loopEnd, e > s {
            if t >= e { t = s + (t - s).truncatingRemainder(dividingBy: (e - s)) }
        }
        return min(max(t, 0), duration)
    }

    public mutating func seek(to t: TimeInterval, now: TimeInterval) {
        position = min(max(t, 0), duration)
        if playState == .playing { positionAtStart = position; playStartReference = now }
    }

    public mutating func cue(now: TimeInterval) {
        seek(to: cuePoint, now: now)
        if playState == .playing {
            pause(now: now)
        } else if playState == .ready {
            playState = .paused     // Cue pausiert immer (Traktor-Semantik)
        }
    }

    /// Traktor-Verhalten: Cue setzt Cue-Punkt auf aktuelle Position.
    public mutating func setCueHere() { cuePoint = position }

    public mutating func setHotcue(_ i: Int) { precondition((1...4).contains(i)); hotcues[i] = position }
    @discardableResult
    public mutating func jumpHotcue(_ i: Int, now: TimeInterval) -> Bool {
        guard let t = hotcues[i] else { return false }
        seek(to: t, now: now); return true
    }

    public mutating func loopIn()  { loopStart = position; loopEnd = nil; loopActive = false }
    public mutating func loopOut() {
        guard let s = loopStart, position > s else { return }
        loopEnd = position; loopActive = true
    }
    public mutating func loopExit() { loopActive = false }
    public mutating func loopToggle() { loopActive.toggle() }

    public mutating func setPitch(_ p: Double, now: TimeInterval) {
        if playState == .playing { position = currentPlayhead(now: now) }
        let clamped = min(max(p, -pitchRange), pitchRange)
        pitch = clamped
        if playState == .playing { positionAtStart = position; playStartReference = now }
    }
    public mutating func toggleKeylock() { keylock.toggle() }
}
