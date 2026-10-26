import Testing
import AVFoundation
@testable import TraktorCloneCore

@Suite struct FxTests {
    @Test func clampBoundaries() {
        #expect(FxChain.clamp(-1, 0, 10) == 0)
        #expect(FxChain.clamp(99, 0, 10) == 10)
        #expect(FxChain.clamp(5, 0, 10) == 5)
    }

    @Test func unitsAreAlive() {
        let fx = FxChain()
        #expect(fx.eq.bands.count == 2)
        #expect(fx.delay.wetDryMix == 0)
        #expect(fx.reverb.wetDryMix == 0)
    }

    @Test func filterCutoffClamps() {
        let fx = FxChain()
        fx.setFilter(cutoffHz: 5, highPass: true, enabled: true)
        #expect(fx.eq.bands[0].frequency == 20)
        #expect(!fx.eq.bands[0].bypass)
        fx.setFilter(cutoffHz: 99999, highPass: false, enabled: true)
        #expect(fx.eq.bands[1].frequency == 20000)
        fx.setFilter(cutoffHz: 500, highPass: true, enabled: false)
        #expect(fx.eq.bands[0].bypass)
    }

    @Test func delayClampsAndDefaults() {
        let fx = FxChain()
        fx.setDelay(timeMs: 5000, feedbackPct: -3, wetPct: 200)
        #expect(fx.delay.delayTime == 2.0)             // 2000 ms clamp
        #expect(fx.delay.feedback == 0)
        #expect(fx.delay.wetDryMix == 100)
        fx.setDelay(timeMs: 250, feedbackPct: 40, wetPct: 50)
        #expect(abs(fx.delay.delayTime - 0.25) < 1e-9)
        #expect(fx.delay.feedback == 40)
        #expect(fx.delay.wetDryMix == 50)
    }

    @Test func reverbClampsAndPreset() {
        let fx = FxChain()
        fx.setReverb(wetPct: 30, preset: true)         // smallRoom
        #expect(fx.reverb.wetDryMix == 30)
        fx.setReverb(wetPct: 150, preset: false)       // largeHall + clamp
        #expect(fx.reverb.wetDryMix == 100)
    }

    @Test func bypassAllResets() {
        let fx = FxChain()
        fx.setDelay(timeMs: 400, feedbackPct: 50, wetPct: 80)
        fx.bypassAll()
        #expect(fx.delay.wetDryMix == 0)
        #expect(fx.reverb.wetDryMix == 0)
        #expect(fx.eq.bands[0].bypass && fx.eq.bands[1].bypass)
    }
}

@Suite struct SyncTests {
    @Test func slavePitchIdenticalIsZero() {
        let g = BeatGrid(bpm: 128)
        let s = SyncEngine()
        #expect(abs(s.slavePitch(master: g, slave: g)) < 1e-9)
    }

    @Test func slavePitchSlowerIsPositive() {
        let master = BeatGrid(bpm: 128)
        let slave = BeatGrid(bpm: 120)
        let s = SyncEngine()
        #expect(abs(s.slavePitch(master: master, slave: slave) - (128.0/120.0 - 1)) < 1e-9)
    }

    @Test func slavePitchFasterIsNegative() {
        let master = BeatGrid(bpm: 120)
        let slave = BeatGrid(bpm: 128)
        let s = SyncEngine()
        #expect(s.slavePitch(master: master, slave: slave) < 0)
    }

    @Test func slavePitchClampsHalf() {
        let master = BeatGrid(bpm: 300)
        let slave = BeatGrid(bpm: 60)                  // Faktor 5 → clamp auf 0.5
        let s = SyncEngine()
        #expect(s.slavePitch(master: master, slave: slave) == 0.5)
    }

    @Test func beatPhaseAtExactBeatIsZero() {
        let g = BeatGrid(bpm: 120)                     // 0.5 s/Beat
        let s = SyncEngine()
        #expect(abs(s.beatPhase(time: 1.0, grid: g)) < 1e-9)
    }

    @Test func beatPhaseMidIsHalf() {
        let g = BeatGrid(bpm: 120)
        let s = SyncEngine()
        #expect(abs(s.beatPhase(time: 1.25, grid: g) - 0.5) < 1e-9)
    }

    @Test func beatsDiffSimple() {
        let g = BeatGrid(bpm: 60)                      // 1 s/Beat
        let s = SyncEngine()
        #expect(abs(s.beatsDiff(masterTime: 5, master: g, slaveTime: 3, slave: g) - 2) < 1e-9)
    }

    @Test func toggleMaster() {
        var s = SyncEngine()
        #expect(s.masterDeck == 0)
        s.toggleMaster(1)
        #expect(s.masterDeck == 1)
    }
}
