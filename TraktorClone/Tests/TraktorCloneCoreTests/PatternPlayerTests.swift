// PatternPlayerTests.swift — Tests für DrumSynth + PatternSequencer (Swift Testing).

import Testing
@testable import TraktorCloneCore

@Suite("Pattern Player")
struct PatternPlayerTests {

    static let sampleRate = 44100.0

    // MARK: - Kick

    @Test("Kick: Länge ~0.35 s, Peak am Anfang ≥ 0.8, Ende klein")
    func kickShape() {
        let sr = Self.sampleRate
        let kick = DrumSynth.render(.kick, sampleRate: sr)
        let expected = Int(0.35 * sr)
        #expect(abs(kick.count - expected) <= Int(0.05 * Double(expected)))

        let headPeak = abs(kick.prefix(64).max { abs($0) < abs($1) } ?? 0)
        #expect(headPeak >= 0.8)

        let tail = kick.suffix(kick.count / 4).map { abs($0) }
        #expect((tail.max() ?? 0) < 0.1)
    }

    // MARK: - Snare

    @Test("Snare: Peak ≥ 0.4 und deterministisch")
    func snareDeterministic() {
        let sr = Self.sampleRate
        let a = DrumSynth.render(.snare, sampleRate: sr)
        let b = DrumSynth.render(.snare, sampleRate: sr)
        #expect(a == b)

        let peak = a.map { abs($0) }.max() ?? 0
        #expect(peak >= 0.4)
    }

    // MARK: - Hat

    @Test("Hat: Länge ~0.06 s, deterministisch")
    func hatShape() {
        let sr = Self.sampleRate
        let a = DrumSynth.render(.hat, sampleRate: sr)
        let b = DrumSynth.render(.hat, sampleRate: sr)
        #expect(a == b)

        let expected = Int(0.06 * sr)
        #expect(abs(a.count - expected) <= Int(0.05 * Double(expected)))
    }

    // MARK: - Clap

    @Test("Clap: ≥ 0.15 s lang, Peak ≥ 0.3")
    func clapShape() {
        let sr = Self.sampleRate
        let clap = DrumSynth.render(.clap, sampleRate: sr)
        #expect(Double(clap.count) / sr >= 0.15)

        let peak = clap.map { abs($0) }.max() ?? 0
        #expect(peak >= 0.3)
    }

    // MARK: - Sequencer-Init

    @Test("Sequencer-Init: Spuren auf 16 Steps aufgefüllt")
    func sequencerInitFillsSteps() {
        var seq = PatternSequencer(bpm: 120, steps: [
            .kick: [true, false, false, false],
            .snare: Array(repeating: true, count: 20),
        ])
        #expect(seq.steps[.kick]?.count == 16)
        #expect(seq.steps[.kick]?[0] == true)
        #expect(seq.steps[.snare]?.count == 16)
        // Nicht angegebene Spur ist aufgefüllt (nur false):
        let hat = seq.steps[.hat] ?? []
        // Hat wurde im Dict nicht explizit gesetzt, aber init füllt alle 4 Spuren.
        #expect(hat.count == 16)
        #expect(hat.allSatisfy { $0 == false })
    }

    // MARK: - Sequencer-Rendering

    @Test("Sequencer 120 BPM, Kick auf Step 0, 1 Bar: exakte Länge + früher Peak")
    func sequencerRenderLoop() {
        let sr = Self.sampleRate
        let seq = PatternSequencer(bpm: 120, steps: [.kick: [true] + Array(repeating: false, count: 15)])
        let out = seq.renderLoop(sampleRate: sr, bars: 1)
        let expected = Int(2.0 * sr) // 16 Steps * 0.125 s = 2.0 s
        #expect(abs(out.count - expected) <= 2)

        let firstQuarter = out.prefix(out.count / 4).map { abs($0) }
        #expect((firstQuarter.max() ?? 0) > 0.5)
    }

    @Test("Sequencer: 4 aufeinanderfolgende Steps bei 124 BPM → Trigger an Step-Positionen")
    func sequencerTriggers() {
        let sr = Self.sampleRate
        let seq = PatternSequencer(bpm: 124, steps: [.hat: [true, true, true, true]])
        let out = seq.renderLoop(sampleRate: sr, bars: 1)
        let stepSamples = Int(seq.stepDuration * sr)
        #expect(stepSamples > 0)
        #expect(abs(out[0]) > 0.4)
        #expect(abs(out[stepSamples]) > 0.4)
    }

    @Test("Clamping: volle Patterns überschreiten nie ±0.95")
    func clamping() {
        let sr = Self.sampleRate
        let full = Array(repeating: true, count: 16)
        let seq = PatternSequencer(bpm: 200, steps: [
            .kick: full, .snare: full, .hat: full, .clap: full,
        ])
        let out = seq.renderLoop(sampleRate: sr, bars: 2)
        #expect(out.allSatisfy { abs($0) <= 0.95 + 1e-6 })
    }
}
