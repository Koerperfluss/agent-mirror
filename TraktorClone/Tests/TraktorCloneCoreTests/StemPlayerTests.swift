import Testing
import Foundation
@testable import TraktorCloneCore

@Suite struct StemPlayerTests {

    @Test func loadMissingFileThrows() {
        let missing = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".stem.mp4")
        #expect(throws: CocoaError.self) {
            try StemPlayer().load(url: missing)
        }
    }

    @Test func setStemGainClampsAndNeverCrashes() {
        let p = StemPlayer()
        p.setStemGain(index: 0, gain: 2.5)    // clamp auf 1
        p.setStemGain(index: 4, gain: -1.0)   // clamp auf 0
        p.setStemGain(index: 99, gain: 0.5)   // out of range → guard, no-crash
        p.setStemGain(index: -1, gain: 0.5)
    }

    @Test func initBeforeLoad() {
        let p = StemPlayer()
        #expect(!p.isPlaying)
        #expect(p.duration == nil)
    }

    @Test func loopEnableDisableTogglesState() {
        let engine = AudioEngine()
        #expect(!engine.loopActive(deck: 0))
        engine.enableLoop(deck: 0, startSec: 1.0, endSec: 2.0)
        #expect(engine.loopActive(deck: 0))
        engine.disableLoop(deck: 0)
        #expect(!engine.loopActive(deck: 0))
    }

    @Test func pauseWithoutLoadedDeckIsNoCrash() {
        let engine = AudioEngine()
        engine.pause(deck: 0)
        engine.pause(deck: 42)   // guard → no-crash
    }
}
