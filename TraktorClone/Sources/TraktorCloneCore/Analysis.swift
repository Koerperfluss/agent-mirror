import Foundation

/// BPM-Erkennung: Energie-Hüllkurve → Onset-Kurve → Autokorrelation.
/// Reine Array-Mathematik — synthetisch testbar, kein Audio nötig.
public enum BPMDetector {

    /// RMS-Hüllkurve über Fenster `win` Samples.
    public static func envelope(_ x: [Float], win: Int = 1024) -> [Float] {
        guard win > 0, !x.isEmpty else { return [] }
        var out: [Float] = []
        out.reserveCapacity(x.count / win + 1)
        var i = 0
        while i < x.count {
            let end = min(i + win, x.count)
            var sum: Float = 0
            for j in i..<end { sum += x[j] * x[j] }
            out.append(sqrtf(sum / Float(end - i)))
            i = end
        }
        return out
    }

    /// Onset-Kurve: positive Differenzen der Hüllkurve.
    public static func onsets(_ env: [Float]) -> [Float] {
        guard env.count > 1 else { return [] }
        var out = [Float](repeating: 0, count: env.count)
        for i in 1..<env.count {
            let d = env[i] - env[i - 1]
            out[i] = d > 0 ? d : 0
        }
        return out
    }

    /// Autokorrelation der Onset-Kurve über BPM-Bereich; Rückgabe in Fold-Range 70...180.
    /// - Parameters:
    ///   - on: Onset-Kurve
    ///   - framesPerSecond: Hüllkurven-Rate (sampleRate / win)
    public static func detectFromOnsets(_ on: [Float], framesPerSecond fps: Double) -> Double? {
        guard on.count > Int(fps * 4) else { return nil }      // mind. 4 s Material
        let mean = on.reduce(0, +) / Float(on.count)
        let c = on.map { $0 - mean }
        var bestLag = 0
        var bestScore: Double = -1
        let minLag = Int(fps * 60.0 / 180.0)
        let maxLag = Int(fps * 60.0 / 70.0)
        guard minLag >= 1, maxLag < c.count / 2 else { return nil }
        for lag in minLag...maxLag {
            var acc: Double = 0
            var energy: Double = 0
            for i in 0..<(c.count - lag) {
                acc += Double(c[i]) * Double(c[i + lag])
                energy += Double(c[i + lag]) * Double(c[i + lag])
            }
            let norm = energy > 0 ? acc / sqrt(energy) : 0
            if norm > bestScore { bestScore = norm; bestLag = lag }
        }
        guard bestLag > 0 else { return nil }
        var bpm = 60.0 * fps / Double(bestLag)
        while bpm < 70 { bpm *= 2 }
        while bpm > 180 { bpm /= 2 }
        return (70.0...180.0).contains(bpm) ? bpm : nil
    }

    /// Komfort: Samples + Samplerate → BPM (Fold 70–180).
    public static func detectBPM(samples: [Float], sampleRate: Double, win: Int = 1024) -> Double? {
        let env = envelope(samples, win: win)
        return detectFromOnsets(onsets(env), framesPerSecond: sampleRate / Double(win))
    }
}

/// Key-Erkennung (vereinfacht): Goertzel-Filter über 12 Pitch-Klassen
/// (Oktaven 2–5); Dur/Moll-Heuristik über die große/kleine Terz.
public enum KeyDetector {

    static let pitchLetters = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

    /// Goertzel-Magnitude einer Frequenz über das gesamte Signal.
    public static func goertzel(_ x: [Float], sampleRate: Double, freq: Double) -> Double {
        guard x.count > 0, sampleRate > 0, freq > 0, freq < sampleRate / 2 else { return 0 }
        let k = 2.0 * cos(2.0 * Double.pi * freq / sampleRate)
        var s0: Float = 0, s1: Float = 0, s2: Float = 0
        for v in x { s0 = v + Float(k) * s1 - s2; s2 = s1; s1 = s0 }
        let power = s1 * s1 + s2 * s2 - Float(k) * s1 * s2
        return max(0, Double(power))
    }

    /// Summierte Energie je Pitch-Klasse (Oktaven 2–5, Kammerton A4=440).
    public static func pitchClassEnergy(_ x: [Float], sampleRate: Double) -> [Double] {
        var energy = [Double](repeating: 0, count: 12)
        for octave in 2...5 {
            for semitone in 0..<12 {
                // MIDI-Note: C2 = 36
                let midi = 36 + octave * 12 + semitone - 24   // octave 2 → C2=36
                let f = 440.0 * pow(2.0, (Double(midi) - 69.0) / 12.0)
                energy[semitone] += goertzel(x, sampleRate: sampleRate, freq: f)
            }
        }
        return energy
    }

    /// Tonart als "A" oder "Am" (Dur/Moll über Terzvergleich); nil bei Stille.
    public static func detectKey(_ x: [Float], sampleRate: Double) -> String? {
        guard x.count > Int(sampleRate) else { return nil }   // mind. 1 s
        let e = pitchClassEnergy(x, sampleRate: sampleRate)
        let total = e.reduce(0, +)
        guard total > 0 else { return nil }
        guard let root = e.indices.max(by: { e[$0] < e[$1] }) else { return nil }
        let majorThird = e[(root + 4) % 12]
        let minorThird = e[(root + 3) % 12]
        let minor = minorThird > majorThird * 0.9
        return pitchLetters[root] + (minor ? "m" : "")
    }
}
