import Foundation
import Testing
@testable import TraktorCloneCore

@Suite("Flux Mode & Master Limiter")
struct FluxLimiterTests {

    // MARK: - Flux Mode (Zeitbasis = Deck-Position, Pause-sicher)

    @Test("Flux: Deck läuft 60 s → virtual 70, mit Scrub +5 → 75")
    func fluxVirtualPositionWithScrub() {
        var flux = FluxMode()
        flux.engage(position: 10, deckTime: 100)
        let v = flux.virtualPosition(deckTime: 160)
        #expect(abs(v - 70) < 1e-9)
        flux.scrub(delta: 5)
        let v2 = flux.virtualPosition(deckTime: 160)
        #expect(abs(v2 - 75) < 1e-9)
    }

    @Test("Flux: disengage nach 60 s → 70 ohne Scrub, aktiv=false")
    func fluxDisengageIgnoresScrub() {
        var flux = FluxMode()
        flux.engage(position: 10, deckTime: 100)
        flux.scrub(delta: 5)
        let target = flux.disengage(deckTime: 160)
        #expect(abs(target - 70) < 1e-9)
        #expect(!flux.active)
    }

    @Test("Flux: Pause friert Ziel ein — Deck-Zeit steht 40 s still → anchor")
    func fluxPauseFreezesTarget() {
        var flux = FluxMode()
        flux.engage(position: 20, deckTime: 0)
        // Deck pausiert: deckTime bleibt 0, obwohl 40 s Wandzeit vergehen
        let v = flux.virtualPosition(deckTime: 0)
        #expect(abs(v - 20) < 1e-9)
        let target = flux.disengage(deckTime: 0)
        #expect(abs(target - 20) < 1e-9)
    }

    @Test("Flux: Scrub negativ — virtual darf negativ sein, kein Clamping")
    func fluxNegativeScrubUnclamped() {
        var flux = FluxMode()
        flux.engage(position: 10, deckTime: 100)
        flux.scrub(delta: -20)
        let v = flux.virtualPosition(deckTime: 100)
        #expect(abs(v - (-10)) < 1e-9)
    }

    @Test("Flux: disengage ohne vergangene Zeit → anchor, Scrub verworfen")
    func fluxDisengageNoElapsedDropsScrub() {
        var flux = FluxMode()
        flux.engage(position: 5, deckTime: 100)
        flux.scrub(delta: -100)
        let target = flux.disengage(deckTime: 100)
        #expect(target == 5)
        #expect(!flux.active)
    }

    // MARK: - Master Limiter

    @Test("Limiter: Sinus 1.5 @ ceiling 0.9 → Peak ≤ 0.918, nicht stumm")
    func limiterLoudSinusCapped() {
        let sr = 48000.0
        let n = 4800
        var x = [Float](repeating: 0, count: n)
        for i in 0..<n {
            x[i] = Float(1.5 * sin(2.0 * Double.pi * 220.0 * Double(i) / sr))
        }
        let limiter = MasterLimiter(ceiling: 0.9, lookaheadMs: 5.0)
        let out = limiter.process(x, sampleRate: sr)

        #expect(out.count == n)
        let peak = out.map { abs($0) }.max() ?? 0
        #expect(peak <= 0.9 * 1.02)
        #expect(peak > 0.5)
    }

    @Test("Limiter: leises Signal (Peak 0.3) bleibt unverändert")
    func limiterQuietSignalUntouched() {
        let sr = 48000.0
        let n = 2400
        var x = [Float](repeating: 0, count: n)
        for i in 0..<n {
            x[i] = Float(0.3 * sin(2.0 * Double.pi * 100.0 * Double(i) / sr))
        }
        let limiter = MasterLimiter(ceiling: 0.98, lookaheadMs: 5.0)
        let out = limiter.process(x, sampleRate: sr)

        #expect(out.count == x.count)
        for i in 0..<n {
            #expect(abs(out[i] - x[i]) < 1e-6)
        }
    }

    @Test("Limiter: Stille → Stille, Länge erhalten")
    func limiterSilenceStaysSilent() {
        let x = [Float](repeating: 0, count: 1000)
        let limiter = MasterLimiter(ceiling: 0.98, lookaheadMs: 5.0)
        let out = limiter.process(x, sampleRate: 48000)
        #expect(out.count == x.count)
        for v in out {
            #expect(v == 0)
        }
    }
}
