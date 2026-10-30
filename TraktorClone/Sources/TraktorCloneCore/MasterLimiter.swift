import Foundation

/// Look-Ahead-Peak-Limiter für den Master (Ozone-Maximizer-Ersatz):
/// Gleitet Gain-Reduktion über ein Lookahead-Fenster, Ceiling hart.
/// Reiner Werttyp ohne Shared State — blockweise zustandslos, der Director
/// betreibt ihn pro Render-Block.
public struct MasterLimiter: Sendable {

    /// Maximale Ausgangsamplitude (z. B. 0.98).
    public var ceiling: Float

    /// Lookahead-Fenster in Millisekunden (z. B. 5.0).
    public var lookaheadMs: Double

    /// Maximaler Gain-Anstieg pro Sample (Release-Glättung).
    public var releasePerSample: Float

    public init(ceiling: Float = 0.98, lookaheadMs: Double = 5.0, releasePerSample: Float = 0.0005) {
        self.ceiling = ceiling
        self.lookaheadMs = lookaheadMs
        self.releasePerSample = releasePerSample
    }

    /// Verarbeitet einen Block (blockweise, zustandslos über Blöcke).
    public func process(_ input: [Float], sampleRate: Double) -> [Float] {
        let n = input.count
        guard n > 0, sampleRate > 0 else { return input }
        let la = max(1, Int(lookaheadMs / 1000 * sampleRate))

        // Ziel-Gain pro Sample: Peak über Fenster [i, i+la] (Lookahead = instant Attack).
        var gains = [Float](repeating: 1, count: n)
        for i in 0..<n {
            let end = min(i + la, n)
            var peak: Float = 0
            for j in i..<end {
                let a = abs(input[j])
                if a > peak { peak = a }
            }
            let target = min(1, ceiling / max(peak, 1e-6))
            // Gain-Glättung: nie schneller steigen als Release.
            let prev: Float = i > 0 ? gains[i - 1] : 1
            gains[i] = min(target, prev + releasePerSample)
        }

        var out = [Float](repeating: 0, count: n)
        for i in 0..<n {
            var v = input[i] * gains[i]
            if v > ceiling { v = ceiling }
            if v < -ceiling { v = -ceiling }
            out[i] = v
        }
        return out
    }
}
