import Testing
import Foundation
@testable import TraktorCloneCore

// MARK: - DVS: Timecode-Synthese + Decoder (Slice 12, Kern)

/// Erzeugt Timecode-Signal (Grundformat nach mktimecode-Semantik):
/// Sinus/Quadratur, Bit 0 dämpft die untere Welle um 25 %.
func synthesizeTimecode(def: TimecodeDefinition, seconds: Double, sampleRate: Double,
                        speed: Double = 1.0, noise: Double = 0,
                        seed: (UInt32, inout UInt32) -> Void = { _, _ in }) -> ([Float], [Float]) {
    var code = def.seed
    var lastBitIndex = -1
    let n = Int(seconds * sampleRate)
    var l = [Float](repeating: 0, count: n)
    var r = [Float](repeating: 0, count: n)
    for s in 0..<n {
        let time = Double(s) / sampleRate * speed        // Platte schneller → Zeit skaliert
        let cycle = time * Double(def.resolution)
        let bitIndex = Int(cycle)
        if bitIndex > lastBitIndex {
            code = TimecodeLUT.fwd(code, def: def)
            lastBitIndex = bitIndex
        }
        let angle = cycle * Double.pi * 2
        let sinA = Foundation.sin(angle)
        let cosA = Foundation.cos(angle)
        let modulate = 1.0 - (-cosA + 1.0) * 0.25 * ((code & 1) == 0 ? 1.0 : 0.0)
        let x = sinA * modulate
        let y = cosA * modulate
        l[s] = Float(-y * 0.5 + (noise > 0 ? Double.random(in: -noise...noise) : 0))
        r[s] = Float(x * 0.5 + (noise > 0 ? Double.random(in: -noise...noise) : 0))
    }
    return (l, r)
}

@Suite("DVS-LFSR")
struct DvsLfsrTests {
    @Test func fwdUndRevSindInvers() {
        let def = TimecodeDefinition.traktorA
        var code = def.seed
        for _ in 0..<1000 {
            let next = TimecodeLUT.fwd(code, def: def)
            #expect(TimecodeLUT.rev(next, def: def) == code)
            code = next
        }
    }

    @Test func lutOrdnetPositionenZu() {
        let lut = TimecodeLUT(def: TimecodeDefinition.serato2A)
        #expect(lut.lookup(TimecodeDefinition.serato2A.seed) == 0)
        let next = TimecodeLUT.fwd(TimecodeDefinition.serato2A.seed, def: TimecodeDefinition.serato2A)
        #expect(lut.lookup(next) == 1)
        #expect(lut.lookup(0xDEADBEE) == -1)   // ungültiger Code
    }
}

@Suite("DVS-Decoder")
struct DvsDecoderTests {
    @Test func dekodiertPositionBeiReferenzgeschwindigkeit() {
        let def = TimecodeDefinition.serato2A
        let rate = 44100.0
        let decoder = TimecodeDecoder(def: def, sampleRate: rate)
        let (l, r) = synthesizeTimecode(def: def, seconds: 4, sampleRate: rate)
        decoder.submit(pcmL: l, pcmR: r)

        let expected = Int32(4.0 * Double(def.resolution))
        let pos = decoder.position
        #expect(pos != nil)
        if let p = pos {
            #expect(abs(p - expected) < 200)          // ±0.1 s Toleranz (Kalibrierungsphase)
        }
        #expect(abs(decoder.speed - 1.0) < 0.15)
    }

    @Test func dekodiertHöhereGeschwindigkeit() {
        let def = TimecodeDefinition.serato2A
        let rate = 44100.0
        let decoder = TimecodeDecoder(def: def, sampleRate: rate)
        let (l, r) = synthesizeTimecode(def: def, seconds: 4, sampleRate: rate, speed: 1.5)
        decoder.submit(pcmL: l, pcmR: r)

        #expect(decoder.position != nil)
        #expect(abs(decoder.speed - 1.5) < 0.25)
    }

    @Test func robustGegenRauschen() {
        let def = TimecodeDefinition.serato2A
        let rate = 44100.0
        let decoder = TimecodeDecoder(def: def, sampleRate: rate)
        let (l, r) = synthesizeTimecode(def: def, seconds: 5, sampleRate: rate, noise: 0.05)
        decoder.submit(pcmL: l, pcmR: r)

        let expected = Int32(5.0 * Double(def.resolution))
        if let p = decoder.position {
            #expect(abs(p - expected) < 500)
        } else {
            Issue.record("Position bei 5 % Rauschen nicht valide")
        }
    }

    @Test func extrapolatedPositionRechnetWeiter() {
        let def = TimecodeDefinition.serato2A
        let rate = 44100.0
        let decoder = TimecodeDecoder(def: def, sampleRate: rate)
        let (l, r) = synthesizeTimecode(def: def, seconds: 3, sampleRate: rate)
        decoder.submit(pcmL: l, pcmR: r)
        if let base = decoder.extrapolatedPosition {
            #expect(base > Double(3 * def.resolution) - 500)
        } else {
            Issue.record("keine extrapolierbare Position")
        }
    }
}
