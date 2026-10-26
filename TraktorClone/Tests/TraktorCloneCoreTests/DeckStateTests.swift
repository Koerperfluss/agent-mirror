import Testing
@testable import TraktorCloneCore

@Suite struct DeckStateTests {
    @Test func idleGuards() {
        var d = DeckState()
        d.play(now: 0); d.pause(now: 1); d.cue(now: 2); _ = d.jumpHotcue(1, now: 2)
        #expect(d.playState == .idle)
        d.load(title: "T", duration: 100)
        #expect(d.playState == .ready)
    }

    @Test func loadResetsEverything() {
        var d = DeckState()
        d.load(title: "A", duration: 50)
        d.load(title: "B", duration: 80)
        #expect(d.trackTitle == "B")
        #expect(d.duration == 80)
        #expect(d.position == 0)
        #expect(d.playState == .ready)
    }

    @Test func playPauseSeek() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.play(now: 10)
        #expect(d.playState == .playing)
        #expect(abs(d.currentPlayhead(now: 12) - 2) < 1e-9)
        d.pause(now: 12)
        #expect(d.playState == .paused)
        #expect(abs(d.position - 2) < 1e-9)
    }

    @Test func pitchChangesRateAndClamps() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.play(now: 0)
        d.setPitch(0.08, now: 0)
        #expect(abs(d.rate - 1.08) < 1e-9)
        #expect(abs(d.currentPlayhead(now: 1) - 1.08) < 1e-6)
        d.setPitch(0.5, now: 1)                      // außerhalb ±0.08 → clamp
        #expect(d.pitch == 0.08)
        d.pitchRange = 0.16
        d.setPitch(-0.16, now: 1)
        #expect(abs(d.pitch + 0.16) < 1e-9)
    }

    @Test func cueStopsAtCuePoint() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.seek(to: 30, now: 0); d.setCueHere()
        d.seek(to: 60, now: 0)
        d.cue(now: 5)
        #expect(abs(d.position - 30) < 1e-9)
        #expect(d.playState == .paused)
    }

    @Test func hotcuesSetAndJump() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.seek(to: 10, now: 0); d.setHotcue(1)
        d.seek(to: 20, now: 0); d.setHotcue(2)
        #expect(d.jumpHotcue(3, now: 0) == false)
        #expect(d.jumpHotcue(2, now: 0) == true)
        #expect(abs(d.position - 20) < 1e-9)
    }

    @Test func loopWrapsPlayhead() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.seek(to: 10, now: 0); d.loopIn()
        d.seek(to: 14, now: 0); d.loopOut()
        #expect(d.loopActive)
        d.pause(now: 0)
        d.seek(to: 13.5, now: 0)
        d.play(now: 100)
        let ph = d.currentPlayhead(now: 100.5)       // 0.5 s → 14.0 → wrap auf 10
        #expect(abs(ph - 10) < 1e-6)
    }

    @Test func loopToggleExitAndGuards() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.loopOut()
        #expect(d.loopEnd == nil)
        d.seek(to: 5, now: 0); d.loopIn()
        d.seek(to: 2, now: 0); d.loopOut()
        #expect(d.loopEnd == nil)
        d.seek(to: 9, now: 0); d.loopOut()
        d.loopExit()
        #expect(!d.loopActive)
        d.loopToggle()
        #expect(d.loopActive)
    }

    @Test func seekClamps() {
        var d = DeckState()
        d.load(title: "T", duration: 10)
        d.seek(to: -5, now: 0)
        #expect(d.position == 0)
        d.seek(to: 99, now: 0)
        #expect(abs(d.position - 10) < 1e-9)
    }

    @Test func keylockToggle() {
        var d = DeckState()
        #expect(!d.keylock)
        d.toggleKeylock()
        #expect(d.keylock)
    }
}
