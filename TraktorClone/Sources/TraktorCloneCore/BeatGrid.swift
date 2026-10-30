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

    /// Schätzt den Offset des ersten Beats (Phase) aus einer Onset-Kurve:
    /// bewertet jede Kandidaten-Phase als Summe der Onset-Werte auf den Beat-Zeiten,
    /// die Phase mit dem höchsten Score gewinnt. Genauigkeit = Frame-Periode der Kurve.
    public static func estimateFirstBeatOffset(onsets: [Float], framesPerSecond fps: Double,
                                               bpm: Double) -> Double {
        let spbFrames = 60.0 / bpm * fps
        guard spbFrames >= 2, onsets.count > 4, fps > 0 else { return 0 }
        var bestPhase = 0.0
        var bestScore = -Double.infinity
        var phase = 0.0
        while phase < spbFrames {
            var score = 0.0
            var f = phase
            while f < Double(onsets.count) {
                score += Double(onsets[Int(f)])
                f += spbFrames
            }
            if score > bestScore { bestScore = score; bestPhase = phase }
            phase += 1
        }
        return bestPhase / fps
    }
}
