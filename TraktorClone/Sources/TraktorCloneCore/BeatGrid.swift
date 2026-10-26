import Foundation

/// Beatgrid: BPM + Offset des ersten Beats. Basis für Sync/Loop-Quantisierung.
public struct BeatGrid: Equatable {
    public var bpm: Double
    public var firstBeatOffset: TimeInterval   // Sekunden bis Beat 0

    public init(bpm: Double, firstBeatOffset: TimeInterval = 0) {
        precondition(bpm > 0)
        self.bpm = bpm
        self.firstBeatOffset = max(0, firstBeatOffset)
    }

    public var secondsPerBeat: TimeInterval { 60.0 / bpm }

    /// Index des letzten Beats an oder vor `time` (Beat 0 = firstBeatOffset).
    public func beatIndex(at time: TimeInterval) -> Int {
        let t = max(time - firstBeatOffset, 0)
        return Int((t / secondsPerBeat).rounded(.down))
    }

    /// Zeitpunkt des n-ten Beats.
    public func beatTime(ofBeat index: Int) -> TimeInterval {
        firstBeatOffset + Double(max(index, 0)) * secondsPerBeat
    }

    /// Nächstliegender Beat zu `time`.
    public func nearestBeat(to t: TimeInterval) -> (index: Int, time: TimeInterval) {
        let raw = (t - firstBeatOffset) / secondsPerBeat
        let idx = Int(raw.rounded())
        return (idx, beatTime(ofBeat: idx))
    }

    /// Rate, um `self` auf `target` anzugleichen (Sync-Grundlage, Slice 8).
    public func rateToMatch(target: BeatGrid) -> Double {
        target.bpm / bpm
    }
}
