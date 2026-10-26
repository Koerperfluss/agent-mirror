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
