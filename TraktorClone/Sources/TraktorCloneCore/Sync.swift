import Foundation

/// Sync-Logik: Slave-Deck auf Master-BPM bringen + Beat-Phase für LED.
public struct SyncEngine {
    public var masterDeck: Int = 0

    public init() {}

    /// Pitch-Wert (rate − 1), damit der Slave auf Master-BPM kommt. Clamp ±0.5.
    public func slavePitch(master: BeatGrid, slave: BeatGrid) -> Double {
        let rate = slave.rateToMatch(target: master)   // target.bpm / slave.bpm
        return Self.clamp(rate - 1.0, -0.5, 0.5)
    }

    /// Position im Beat als 0.0...1.0 (Beat-LED).
    public func beatPhase(time: TimeInterval, grid: BeatGrid) -> Double {
        guard grid.secondsPerBeat > 0 else { return 0 }
        let t = max(time - grid.firstBeatOffset, 0)
        let frac = (t / grid.secondsPerBeat).truncatingRemainder(dividingBy: 1)
        return frac < 0 ? frac + 1 : frac
    }

    /// Zeit, auf die der Slave springen soll, damit seine Beat-Phase der Master-Phase
    /// entspricht. Kandidaten sind die nächstliegenden Beat-Grenzen MIT Ziel-Phase
    /// (±1 Beat); Kandidaten vor dem ersten Beat werden verworfen.
    public func nudgeTarget(masterTime: TimeInterval, master: BeatGrid,
                            slaveTime: TimeInterval, slave: BeatGrid) -> TimeInterval {
        guard master.secondsPerBeat > 0, slave.secondsPerBeat > 0 else { return slaveTime }
        let masterBeats = (masterTime - master.firstBeatOffset) / master.secondsPerBeat
        let phase = masterBeats - masterBeats.rounded(.down)              // 0..<1
        let slaveBeats = (slaveTime - slave.firstBeatOffset) / slave.secondsPerBeat
        let base = slave.firstBeatOffset + (slaveBeats.rounded(.down) + phase) * slave.secondsPerBeat
        var best = base
        var bestDist = abs(base - slaveTime)
        for delta in [-1.0, 1.0] {
            let candidate = base + delta * slave.secondsPerBeat
            if candidate < slave.firstBeatOffset { continue }
            let d = abs(candidate - slaveTime)
            if d < bestDist { bestDist = d; best = candidate }
        }
        return max(0, best)
    }

    /// Wie viele Slave-Beats der Slave gegenüber dem Master versetzt ist
    /// (positiv = Slave hinkt hinterher in Beats gemessen bei slave-BPM).
    public func beatsDiff(masterTime: TimeInterval, master: BeatGrid,
                          slaveTime: TimeInterval, slave: BeatGrid) -> Double {
        guard slave.secondsPerBeat > 0 else { return 0 }
        let masterBeats = (masterTime - master.firstBeatOffset) / master.secondsPerBeat
        let slaveBeats = (slaveTime - slave.firstBeatOffset) / slave.secondsPerBeat
        return masterBeats - slaveBeats
    }

    public mutating func toggleMaster(_ deck: Int) {
        masterDeck = deck
    }

    public static func clamp(_ v: Double, _ lo: Double, _ hi: Double) -> Double {
        min(max(v, lo), hi)
    }
}
