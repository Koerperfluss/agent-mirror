import Testing
@testable import TraktorCloneCore

@Suite struct MixerTests {
    @Test func equalPowerCenterIsMinus3dB() {
        let g = Mixer.equalPowerGains(x: 0.5)
        #expect(abs(g.a - 0.5) < 1e-9)
        #expect(abs(g.b - 0.5) < 1e-9)
        #expect(abs(g.a + g.b - 1.0) < 1e-9)
    }

    @Test func equalPowerExtremes() {
        let l = Mixer.equalPowerGains(x: 0)
        #expect(l.a == 1 && l.b == 0)
        let r = Mixer.equalPowerGains(x: 1)
        #expect(r.a == 0 && r.b == 1)
    }

    @Test func outputGainChain() {
        var m = Mixer()
        m.channelA.gain = 2.0
        m.channelA.fader = 0.5
        m.crossfader = 0
        #expect(abs(m.outputGain(channel: 0) - 1.0) < 1e-9)
        #expect(m.outputGain(channel: 1) == 0)
        m.crossfader = 0.5
        #expect(abs(m.outputGain(channel: 0) - 0.5) < 1e-9)
    }

    @Test func crossfaderClampsOutOfRange() {
        let g1 = Mixer.equalPowerGains(x: -3)
        #expect(g1.a == 1 && g1.b == 0)
        let g2 = Mixer.equalPowerGains(x: 42)
        #expect(g2.a == 0 && g2.b == 1)
    }
}

@Suite struct BeatGridTests {
    @Test func secondsPerBeat() {
        #expect(abs(BeatGrid(bpm: 120).secondsPerBeat - 0.5) < 1e-9)
    }

    @Test func beatIndexAndTime() {
        let g = BeatGrid(bpm: 120, firstBeatOffset: 0.25)
        #expect(g.beatIndex(at: 0.25) == 0)
        #expect(g.beatIndex(at: 0.74) == 0)
        #expect(g.beatIndex(at: 0.76) == 1)
        #expect(abs(g.beatTime(ofBeat: 2) - 1.25) < 1e-9)
    }

    @Test func nearestBeat() {
        let g = BeatGrid(bpm: 60)
        let n = g.nearestBeat(to: 2.4)
        #expect(n.index == 2)
        #expect(abs(n.time - 2.0) < 1e-9)
    }

    @Test func syncRate() {
        let a = BeatGrid(bpm: 120)
        let b = BeatGrid(bpm: 128)
        #expect(abs(a.rateToMatch(target: b) - 128.0/120.0) < 1e-9)
    }

    @Test func negativeTimeClampsToBeatZero() {
        let g = BeatGrid(bpm: 120, firstBeatOffset: 1.0)
        #expect(g.beatIndex(at: 0.5) == 0)
        #expect(abs(g.beatTime(ofBeat: -5) - 1.0) < 1e-9)
    }
}
