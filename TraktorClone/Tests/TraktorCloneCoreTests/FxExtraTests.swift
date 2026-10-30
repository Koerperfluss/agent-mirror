// FxExtraTests.swift — Tests für Phaser, Bitcrusher und Gate.

import Testing
import Foundation
@testable import TraktorCloneCore

@Suite("FxExtra: Phaser, Bitcrusher, Gate")
struct FxExtraTests {

    private func sine(_ freq: Double, amplitude: Double, seconds: Double, sampleRate: Double = 44_100) -> [Float] {
        let count = Int(seconds * sampleRate)
        return (0..<count).map { Float(amplitude * sin(2.0 * .pi * freq * Double($0) / sampleRate)) }
    }

    // MARK: - Bitcrusher

    @Test("Bitcrusher 1 Bit: Ausgabewerte liegen nur bei 0 oder ±1")
    func bitcrusher1Bit() {
        let crusher = Bitcrusher(bits: 1)
        let input = sine(440, amplitude: 0.5, seconds: 0.1)
        let out = crusher.process(input)
        #expect(out.count == input.count)
        for v in out {
            #expect(abs(abs(v) - 0) < 1e-4 || abs(abs(v) - 1) < 1e-4)
        }
    }

    @Test("Bitcrusher 16 Bit: Sinus bleibt nahezu unverändert")
    func bitcrusher16Bit() {
        let crusher = Bitcrusher(bits: 16)
        let input = sine(440, amplitude: 0.5, seconds: 0.05)
        let out = crusher.process(input)
        for (o, i) in zip(out, input) {
            #expect(abs(o - i) < 1.0 / 1000.0)
        }
    }

    @Test("Bitcrusher Downsample 8: je 8 aufeinanderfolgende Samples identisch")
    func bitcrusherDownsample() {
        let crusher = Bitcrusher(bits: 16, downsample: 8)
        // Rauschen statt Sinus, damit Hold-Blöcke sichtbar werden.
        let input: [Float] = (0..<800).map {
            let t = Double($0) / 44_100.0
            return Float(0.5 * sin(2.0 * .pi * 1000.0 * t + sin(Double($0) * 0.7)))
        }
        let out = crusher.process(input)
        for block in stride(from: 0, to: out.count, by: 8) {
            let end = min(block + 8, out.count)
            let first = out[block]
            for i in block..<end {
                #expect(out[i] == first)
            }
        }
    }

    // MARK: - Gate

    @Test("Gate: leises Rauschen 0.01 fällt nach Release-Zeit vollständig auf 0")
    func gateClosesOnQuietSignal() {
        var gate = Gate(thresholdDb: -35, releaseMs: 120)
        // 0,5 s leises Rauschen bei 0,01 (ca. -40 dB) — Release 120 ms = 5292 Samples bei 44,1 kHz.
        let input = (0..<22_050).map { _ in Float(0.01 * (Double.random(in: -1...1))) }
        let out = gate.process(input, sampleRate: 44_100)
        let tailStart = 5_292
        for i in tailStart..<out.count {
            #expect(out[i] == 0)
        }
    }

    @Test("Gate: lauter Sinus 0.5 bleibt annähernd unverändert")
    func gatePassesLoudSignal() {
        var gate = Gate()
        let input = sine(440, amplitude: 0.5, seconds: 0.1)
        let out = gate.process(input, sampleRate: 44_100)
        let peak = out.map(\.magnitude).max() ?? 0
        #expect(peak >= 0.45)
    }

    @Test("Gate: leise→laut Übergang — erste Hälfte 0, zweite Hälfte ≥ 0.45")
    func gateQuietToLoud() {
        var gate = Gate()
        let quiet = [Float](repeating: 0.001, count: 1000)
        let loud = sine(440, amplitude: 0.5, seconds: 0.05).prefix(1000)
        let input = quiet + Array(loud)
        let out = gate.process(input, sampleRate: 44_100)
        for i in 0..<1000 {
            #expect(out[i] == 0)
        }
        let loudPeak = out[1000...].map(\.magnitude).max() ?? 0
        #expect(loudPeak >= 0.45)
    }

    // MARK: - Phaser

    @Test("Phaser: Länge erhalten, keine NaN/Inf, Peak ≤ 1.5")
    func phaserSignalIntegrity() {
        var phaser = Phaser()
        let input = sine(440, amplitude: 0.5, seconds: 0.5)
        let out = phaser.process(input, sampleRate: 44_100)
        #expect(out.count == input.count)
        var peak: Float = 0
        for v in out {
            #expect(v.isFinite)
            peak = max(peak, v.magnitude)
        }
        #expect(peak <= 1.5)
    }

    @Test("Phaser: Determinismus — zwei frische Instanzen liefern identische Ausgabe")
    func phaserDeterministic() {
        var a = Phaser()
        var b = Phaser()
        let input = sine(440, amplitude: 0.5, seconds: 0.3)
        let outA = a.process(input, sampleRate: 44_100)
        let outB = b.process(input, sampleRate: 44_100)
        #expect(outA.count == outB.count)
        for (x, y) in zip(outA, outB) {
            #expect(x == y)
        }
    }
}
