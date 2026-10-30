import Foundation
import Testing
@testable import TraktorCloneCore

@Suite struct AnalysisTests {
    /// Synthetischer Click-Track: Spike alle 0,5 s @ 22050 Hz → 120 BPM.
    private func clickTrack(bpm: Double, seconds: Double, sr: Double = 22050) -> [Float] {
        let n = Int(sr * seconds)
        var x = [Float](repeating: 0, count: n)
        let period = Int(sr * 60.0 / bpm)
        var i = 0
        while i < n {
            for k in 0..<64 where i + k < n { x[i + k] = 1 - Float(k) / 64 } // kurzer Rampe
            i += period
        }
        return x
    }

    @Test func envelopeLength() {
        let env = BPMDetector.envelope([Float](repeating: 0.5, count: 5000), win: 1024)
        #expect(env.count == 5)
        #expect(abs(env[0] - 0.5) < 1e-6)
    }

    @Test func onsetsOnlyPositiveDiffs() {
        let on = BPMDetector.onsets([1, 3, 2, 5, 5])
        #expect(on == [0, 2, 0, 3, 0])
    }

    @Test func detect120FromSyntheticClicks() {
        let bpm = BPMDetector.detectBPM(samples: clickTrack(bpm: 120, seconds: 20), sampleRate: 22050)
        let v = try! #require(bpm)
        #expect(abs(v - 120) < 4, "erkannt: \(v ?? -1)")
    }

    @Test func detect90FoldsIntoRange() {
        let bpm = BPMDetector.detectBPM(samples: clickTrack(bpm: 90, seconds: 20), sampleRate: 22050)
        let v = try! #require(bpm)
        #expect(abs(v - 90) < 4, "erkannt: \(v ?? -1)")
    }

    @Test func detectNilOnShortInput() {
        #expect(BPMDetector.detectBPM(samples: [0.1, 0.2], sampleRate: 44100) == nil)
    }

    // MARK: Key

    @Test func goertzelFindsA4() {
        let sr = 22050.0
        var sine = [Float](repeating: 0, count: Int(sr))     // 1 s @ 440 Hz
        for i in 0..<sine.count {
            sine[i] = sinf(2 * Float.pi * 440 * Float(i) / Float(sr)) * 0.8
        }
        let g440 = KeyDetector.goertzel(sine, sampleRate: sr, freq: 440)
        let g466 = KeyDetector.goertzel(sine, sampleRate: sr, freq: 466.16)
        #expect(g440 > g466 * 10)
    }

    @Test func detectKeyAFromSine() {
        let sr = 22050.0
        var sine = [Float](repeating: 0, count: Int(sr * 2))
        for i in 0..<sine.count {
            sine[i] = sinf(2 * Float.pi * 440 * Float(i) / Float(sr)) * 0.8
        }
        let key = try! #require(KeyDetector.detectKey(sine, sampleRate: sr))
        #expect(key.hasPrefix("A"), "erkannt: \(key)")
    }

    @Test func detectKeyNilOnSilence() {
        #expect(KeyDetector.detectKey([Float](repeating: 0, count: 44100),
                                      sampleRate: 44100) == nil)
    }

    @Test func pitchLettersComplete() {
        #expect(KeyDetector.pitchLetters.count == 12)
        #expect(KeyDetector.pitchLetters.first == "C")
    }
}

@Suite struct TrackMemoryTests {
    private func tmpEntry() -> TrackMemoryEntry {
        TrackMemoryEntry(path: "/tmp/x-\(UUID().uuidString).mp3",
                         cue: 12.5, hotcues: ["1": 5, "2": 9],
                         bpm: 128, key: "Am")
    }

    @Test func fileNameIsShaHex() {
        let f = TrackMemoryStore.fileName(for: "/a/b.mp3")
        #expect(f.count == 69)                       // 64 Hex-Zeichen + ".json" (5)
        #expect(f.hasSuffix(".json"))
        #expect(f.dropLast(5).allSatisfy { $0.isHexDigit })
    }

    @Test func stableForSamePath() {
        #expect(TrackMemoryStore.fileName(for: "/same.mp3") ==
                TrackMemoryStore.fileName(for: "/same.mp3"))
    }

    @Test func saveLoadRoundtrip() {
        let e = tmpEntry()
        TrackMemoryStore.save(e)
        let back = TrackMemoryStore.load(path: e.path)
        #expect(back == e)
        // Aufräumen
        let url = TrackMemoryStore.directory()
            .appendingPathComponent(TrackMemoryStore.fileName(for: e.path))
        try? FileManager.default.removeItem(at: url)
    }

    @Test func loadMissingIsNil() {
        #expect(TrackMemoryStore.load(path: "/gibt-es-nicht-\(UUID()).mp3") == nil)
    }
}
