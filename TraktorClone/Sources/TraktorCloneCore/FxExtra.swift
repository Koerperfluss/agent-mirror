// FxExtra.swift — Zusätzliche DJ-Effekte (Phaser, Bitcrusher, Gate)
// Reine Sample-Prozessoren, nur Foundation, Swift 6 / macOS 13+.

import Foundation

/// Phaser-Effekt: 4-Stufen-Allpass-Kaskade mit LFO-moduliertem Koeffizienten,
/// Feedback (0.5) und 50 % Dry/Wet-Mix.
///
/// Der LFO läuft mit 0,5 Hz sinusförmig zwischen 0,2 und 0,8 (Allpass-Koeffizient `a`).
/// Die LFO-Phase bleibt über Blöcke hinweg erhalten — Instanz pro Deck behalten.
public struct Phaser: Sendable {

    /// LFO-Geschwindigkeit in Hz (Standard 0,5).
    public var rate: Double

    /// Effekttiefe 0…1 (skaliert den Allpass-Bereich um die Mitte 0,5).
    public var depth: Double

    /// Aktuelle LFO-Phase in Radiant (Zustand über Blöcke).
    private var lfoPhase: Double = 0

    /// Allpass-Delay-Zustand je Stufe (y[n-1]).
    private var stageState: [Double] = [0, 0, 0, 0]

    /// Letzter Ausgangswert für das Feedback.
    private var lastOut: Double = 0

    /// Vorheriger Eingangswert je Stufe (x[n-1]).
    private var prevIn: [Double] = [0, 0, 0, 0]

    /// - Parameters:
    ///   - rate: LFO-Geschwindigkeit in Hz.
    ///   - depth: Tiefe 0…1.
    public init(rate: Double = 0.5, depth: Double = 1.0) {
        self.rate = rate
        self.depth = depth
    }

    /// Verarbeitet einen Sample-Block und liefert den phaserten Block zurück.
    public mutating func process(_ x: [Float], sampleRate: Double) -> [Float] {
        var out = [Float](repeating: 0, count: x.count)
        let phaseInc = 2.0 * Double.pi * rate / sampleRate
        for n in 0..<x.count {
            // LFO: Sinus zwischen 0,2 und 0,8, Tiefe skaliert die Abweichung von 0,5.
            let lfo = sin(lfoPhase)
            let a = 0.5 + 0.3 * lfo * depth
            lfoPhase += phaseInc
            if lfoPhase >= 2.0 * Double.pi { lfoPhase -= 2.0 * Double.pi }

            // Eingang inkl. Feedback des Gesamtausgangs.
            var signal = Double(x[n]) + 0.5 * lastOut

            // 4 Allpass-Stufen: y[n] = a*(x[n]-y[n-1]) + x[n-1]
            for s in 0..<4 {
                let xn = signal
                let yn = a * (xn - stageState[s]) + prevIn[s]
                stageState[s] = yn
                prevIn[s] = xn
                signal = yn
            }

            // 50 % Dry/Wet-Mix.
            let mixed = 0.5 * Double(x[n]) + 0.5 * signal
            lastOut = mixed
            out[n] = Float(mixed)
        }
        return out
    }
}

/// Bitcrusher: Bit-Tiefen-Reduktion plus Sample-and-Hold-Downsampling.
/// Zustandslos bezüglich Bits; der Hold-Zustand gilt nur innerhalb eines Blocks.
public struct Bitcrusher: Sendable {

    /// Quantisierungstiefe in Bit (1…16).
    public var bits: Int

    /// Sample-Hold: nur jedes N-te Sample wird neu berechnet (1…32).
    public var downsample: Int

    /// - Parameters:
    ///   - bits: Bit-Tiefe 1…16.
    ///   - downsample: Hold-Faktor 1…32.
    public init(bits: Int = 8, downsample: Int = 1) {
        self.bits = max(1, min(16, bits))
        self.downsample = max(1, min(32, downsample))
    }

    /// Verarbeitet einen Block: Quantisierung auf `bits` und Hold alle `downsample` Samples.
    public func process(_ x: [Float]) -> [Float] {
        let levels = Double(1 << bits)
        let half = levels / 2
        var out = [Float](repeating: 0, count: x.count)
        var held: Double = 0
        for n in 0..<x.count {
            if n % downsample == 0 {
                held = (Double(x[n]) * half).rounded() / half
            }
            out[n] = Float(held)
        }
        return out
    }
}

/// Noise-Gate mit Instant-Attack und linearem Release.
/// Öffnet sofort, wenn |x| den Schwellwert überschreitet; fällt danach
/// linear auf 0 über `releaseMs` ab. Unter Schwellwert + abgelaufenem Release → 0.
public struct Gate: Sendable {

    /// Schwellwert in dB (-60…0, Standard -35).
    public var thresholdDb: Double

    /// Release-Zeit in Millisekunden (Standard 120).
    public var releaseMs: Double

    /// Aktueller Hüllkurven-Gain 0…1.
    private var env: Double = 0

    /// - Parameters:
    ///   - thresholdDb: Schwellwert in dB.
    ///   - releaseMs: Release-Zeit in ms.
    public init(thresholdDb: Double = -35, releaseMs: Double = 120) {
        self.thresholdDb = max(-60, min(0, thresholdDb))
        self.releaseMs = max(0, releaseMs)
    }

    /// Verarbeitet einen Block: Instant-Attack, linearer Release-Rampenabfall.
    public mutating func process(_ x: [Float], sampleRate: Double) -> [Float] {
        var out = [Float](repeating: 0, count: x.count)
        let threshold = pow(10.0, thresholdDb / 20.0)
        let releaseSamples = max(1.0, releaseMs * sampleRate / 1000.0)
        let step = 1.0 / releaseSamples
        for n in 0..<x.count {
            let absX = abs(Double(x[n]))
            if absX >= threshold {
                env = 1.0
            } else {
                env = max(0, env - step)
            }
            out[n] = Float(Double(x[n]) * env)
        }
        return out
    }
}
