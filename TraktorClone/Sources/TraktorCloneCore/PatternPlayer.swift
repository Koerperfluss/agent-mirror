// PatternPlayer.swift — Pattern Player: synthetische Drum-Sounds + 16-Step-Sequencer.
// Reine DSP-Synthese (nur Foundation, kein AVFoundation). Alle Funktionen sind rein
// und deterministisch (Rauschen via LCG), damit Tests reproduzierbar sind.

import Foundation

/// Drum-Sound-Typen des Pattern Players (synthetisiert, keine Samples).
public enum DrumSound: String, CaseIterable, Sendable {
    case kick
    case snare
    case hat
    case clap
}

/// Deterministische Rauschquelle: Linearer Kongruenzgenerator (LCG).
/// state = state &* 6364136223846793005 &+ 1442695040888963407
/// Ausgabe: Float in -1…1 aus den oberen Bits (state >> 33 & 0xFFFF).
struct LCGNoise: Sendable {
    var state: UInt64

    init(seed: UInt64 = 0x9E3779B97F4A7C15) {
        self.state = seed
    }

    /// Liefert den nächsten Rauschwert in -1…1.
    mutating func next() -> Float {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        let bits = (state >> 33) & 0xFFFF
        return Float(bits) / 32768 * 2 - 1
    }
}

/// DSP-Synthese der Drum-Sounds (mono, Werte in -1…1, vor Clamping im Sequencer).
public enum DrumSynth {

    /// Rendert einen Drum-Sound (mono, 0…±1).
    /// - kick: Sinus-Sweep 150→45 Hz, exponentielles Decay über ~0.35 s
    /// - snare: deterministisches Rauschen (LCG) + 180-Hz-Ton, ~0.2 s
    /// - hat: hochpass-artiges kurzes Rauschen (Differenz aufeinanderfolgender Rauschwerte), ~0.06 s
    /// - clap: 3 Rausch-Bursts à 10 ms versetzt + Decay
    /// - Parameter sampleRate: Abtastrate in Hz (z. B. 44100), muss > 0 sein.
    public static func render(_ sound: DrumSound, sampleRate: Double) -> [Float] {
        precondition(sampleRate > 0, "sampleRate muss > 0 sein")
        switch sound {
        case .kick: return renderKick(sampleRate: sampleRate)
        case .snare: return renderSnare(sampleRate: sampleRate)
        case .hat: return renderHat(sampleRate: sampleRate)
        case .clap: return renderClap(sampleRate: sampleRate)
        }
    }

    /// Kick: Frequenz-Sweep 150→45 Hz über die Gesamtdauer, exp-Decay tau ≈ 0.1 s.
    private static func renderKick(sampleRate: Double) -> [Float] {
        let duration = 0.35
        let count = Int(duration * sampleRate)
        var out = [Float](repeating: 0, count: count)
        // Frequenz verläuft linear (in der Phase integriert) von 150 Hz auf 45 Hz.
        let fStart = 150.0, fEnd = 45.0
        var phase = 0.0
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let progress = Double(i) / Double(count)
            let freq = fStart + (fEnd - fStart) * progress
            phase += 2.0 * Double.pi * freq / sampleRate
            let env = exp(-t / 0.1)
            // cos-Start: voller Punch ab Sample 0 (sin(0)=0 würde den Impact verschlucken)
            out[i] = Float(cos(phase) * env)
        }
        return out
    }

    /// Snare: Rauschen (LCG, deterministisch) + 180-Hz-Ton, exp-Decay über ~0.2 s.
    private static func renderSnare(sampleRate: Double) -> [Float] {
        let duration = 0.2
        let count = Int(duration * sampleRate)
        var out = [Float](repeating: 0, count: count)
        var noise = LCGNoise()
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let env = exp(-t / 0.06)
            let n = noise.next()
            let tone = sin(2.0 * Double.pi * 180.0 * t)
            let mix: Double = 0.7 * Double(n) + 0.3 * tone
            out[i] = Float(mix * env)
        }
        return out
    }

    /// Hat: Differenz aufeinanderfolgender LCG-Rauschwerte wirkt wie Hochpass, sehr kurzes Decay.
    private static func renderHat(sampleRate: Double) -> [Float] {
        let duration = 0.06
        let count = Int(duration * sampleRate)
        var out = [Float](repeating: 0, count: count)
        var noise = LCGNoise(seed: 0xDEADBEEF)
        var previous = noise.next()
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let current = noise.next()
            let env = exp(-t / 0.015)
            // 2.5× auf Schlag-Pegel (Diff-Rauschen ist von Natur aus leise), ±0.95
            var v = Double(current - previous) * env * 2.5
            v = max(-0.95, min(0.95, v))
            out[i] = Float(v)
            previous = current
        }
        return out
    }

    /// Clap: 3 Rausch-Bursts à 10 ms, versetzt um je 12 ms, mit exp-Decay; Gesamtdauer 0.2 s.
    private static func renderClap(sampleRate: Double) -> [Float] {
        let duration = 0.2
        let count = Int(duration * sampleRate)
        var out = [Float](repeating: 0, count: count)
        let burst = Int(0.01 * sampleRate)        // 10 ms Burst-Länge
        let offset = Int(0.012 * sampleRate)      // 12 ms Versatz zwischen Bursts
        for b in 0..<3 {
            var noise = LCGNoise(seed: UInt64(0xC1A0 + b))
            let start = b * offset
            let end = min(start + burst, count)
            for i in start..<end where i >= 0 {
                let t = Double(i - start) / sampleRate
                let env = exp(-t / 0.008)
                out[i] += noise.next() * Float(env)
            }
        }
        // Globales Ausklingen am Ende.
        for i in 0..<count {
            let t = Double(i) / sampleRate
            out[i] *= Float(exp(-t / 0.15))
        }
        return out
    }
}

/// 16-Step-Sequencer mit bis zu 4 Spuren (eine je DrumSound), BPM-getaktet.
/// Ein Takt = 4 Beats, 4 Steps pro Beat → Step-Dauer = 60 / bpm / 4 Sekunden.
public struct PatternSequencer: Sendable {

    /// Tempo in BPM (gültig: 60…200, wird per clamp begrenzt).
    public var bpm: Double

    /// Steps je Spur: genau 16 Einträge pro DrumSound (true = Trigger am Step-Anfang).
    public var steps: [DrumSound: [Bool]]

    /// Erstellt einen Sequencer. Fehlende oder kürzere Spuren werden auf 16×false aufgefüllt,
    /// längere Spuren auf 16 Einträge abgeschnitten.
    /// - Parameters:
    ///   - bpm: Tempo in BPM (60…200, außerhalb wird geklemmt).
    ///   - steps: Steps-Mapping je DrumSound.
    public init(bpm: Double = 124, steps: [DrumSound: [Bool]] = [:]) {
        self.bpm = min(max(bpm, 60), 200)
        var filled: [DrumSound: [Bool]] = [:]
        for sound in DrumSound.allCases {
            var track = Array(repeating: false, count: 16)
            if let provided = steps[sound] {
                for (index, value) in provided.enumerated() where index < 16 {
                    track[index] = value
                }
            }
            filled[sound] = track
        }
        self.steps = filled
    }

    /// Step-Dauer in Sekunden (60 / bpm / 4).
    public var stepDuration: Double {
        60.0 / bpm / 4.0
    }

    /// Rendert `bars` Takte gemischt. Jedes aktive Step triggert den Sound am Step-Anfang;
    /// Overlappende Sounds werden einfach addiert und das Ergebnis auf ±0.95 geklemmt.
    /// Das Array endet exakt bei bars*16*stepDuration Samples; darüber hinaus ragende
    /// Sounds werden abgeschnitten.
    public func renderLoop(sampleRate: Double, bars: Int) -> [Float] {
        precondition(sampleRate > 0, "sampleRate muss > 0 sein")
        precondition(bars > 0, "bars muss > 0 sein")
        let stepDur = stepDuration
        let totalSteps = bars * 16
        let totalSamples = Int(Double(totalSteps) * stepDur * sampleRate)
        var out = [Float](repeating: 0, count: totalSamples)

        for (sound, track) in steps {
            guard let buffer = cachedBuffer(for: sound, sampleRate: sampleRate) else { continue }
            for step in 0..<totalSteps {
                guard track[step % 16] else { continue }
                let start = Int(Double(step) * stepDur * sampleRate)
                let end = min(start + buffer.count, totalSamples)
                guard start < totalSamples else { continue }
                for i in start..<end {
                    out[i] += buffer[i - start]
                }
            }
        }

        // Auf ±0.95 clampen (Overload-Schutz).
        for i in 0..<out.count {
            let v = out[i]
            out[i] = v > 0.95 ? 0.95 : (v < -0.95 ? -0.95 : v)
        }
        return out
    }

    /// Frischer Sound-Buffer pro Aufruf (Werttypen, rein — kein Cache nötig).
    private func cachedBuffer(for sound: DrumSound, sampleRate: Double) -> [Float]? {
        DrumSynth.render(sound, sampleRate: sampleRate)
    }
}
