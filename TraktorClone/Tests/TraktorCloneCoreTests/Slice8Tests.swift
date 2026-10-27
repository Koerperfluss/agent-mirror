import Foundation
import Testing
@testable import TraktorCloneCore

@Suite struct BeatLoopTests {
    @Test func setBeatLoopMath() {
        var d = DeckState()
        d.load(title: "T", duration: 100)
        d.seek(to: 10, now: 0)
        d.setBeatLoop(beats: 4, bpm: 120)             // 4 Beats @120 = 2 s
        let s = try! #require(d.loopStart)
        let e = try! #require(d.loopEnd)
        #expect(abs(s - 10) < 1e-9)
        #expect(abs((e - s) - 2.0) < 1e-9)
        #expect(d.loopActive)
    }

    @Test func setBeatLoopClampsToDuration() {
        var d = DeckState()
        d.load(title: "T", duration: 11)
        d.seek(to: 10, now: 0)
        d.setBeatLoop(beats: 8, bpm: 120)             // 4 s gewünscht, nur 1 s übrig
        let e = try! #require(d.loopEnd)
        #expect(abs(e - 11) < 1e-9)
    }
}

@Suite struct AutoDJTests {
    private func track(_ id: String) -> NMLTrack {
        var t = NMLTrack(); t.title = id; return t
    }

    @Test func disabledReturnsNil() {
        var a = AutoDJ()
        #expect(a.next(from: [track("A")]) == nil)
    }

    @Test func emptyQueueReturnsNil() {
        var a = AutoDJ(); a.enabled = true
        #expect(a.next(from: []) == nil)
    }

    @Test func roundRobinCycles() {
        var a = AutoDJ(); a.enabled = true
        let q = [track("A"), track("B")]
        #expect(a.next(from: q)?.title == "A")
        #expect(a.next(from: q)?.title == "B")
        #expect(a.next(from: q)?.title == "A")        // wrap
    }
}

@Suite struct StemPlayerStateTests {
    @Test func initIdle() {
        let p = StemPlayer()
        #expect(!p.isPlaying)
        #expect(p.duration == nil)
    }

    @Test func loadMissingFileThrows() {
        let p = StemPlayer()
        #expect(throws: (any Error).self) {
            try p.load(url: URL(fileURLWithPath: "/nonexistent/stems.mp4"))
        }
    }

    @Test func pauseAndSeekWithoutLoadNoCrash() {
        let p = StemPlayer()
        p.pause()
        p.seek(to: 5)
        #expect(!p.isPlaying)
    }
}
