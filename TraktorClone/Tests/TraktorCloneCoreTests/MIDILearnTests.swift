import Foundation
import Testing
@testable import TraktorCloneCore

@Suite struct MIDILearnTests {
    private func tmpJSON() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("tc-mappings-\(UUID().uuidString).json")
    }

    @Test func roundtripViaTmpFile() throws {
        let url = tmpJSON()
        let m = [LearnedMapping(channel: 0, isCC: false, control: 36, action: "playPause"),
                 LearnedMapping(channel: 1, isCC: true, control: 7, action: "crossfader")]
        try MappingStore.save(m, to: url)
        let loaded = try MappingStore.load(from: url)
        #expect(loaded == m)
        try? FileManager.default.removeItem(at: url)
    }

    @Test func loadThrowsWhenMissing() {
        #expect(throws: (any Error).self) { try MappingStore.load(from: tmpJSON()) }
    }

    @Test func loadOrDefaultFallsBackToEmpty() {
        #expect(MappingStore.loadOrDefault(from: tmpJSON()).isEmpty)
    }

    @Test func assignmentRoundtripBothWays() {
        let a = MIDIAssignment(channel: 3, isCC: true, control: 74, action: .pitchA)
        let l = a.learned
        let back = l.assignment
        #expect(back == a)
    }

    @Test func invalidActionStringYieldsNil() {
        let bad = LearnedMapping(channel: 0, isCC: false, control: 1, action: "explode")
        #expect(bad.assignment == nil)
    }

    @Test func outOfRangeControlYieldsNil() {
        let bad = LearnedMapping(channel: 0, isCC: true, control: 999, action: "cue")
        #expect(bad.assignment == nil)
    }

    @Test func sortedKeysAreStable() throws {
        let url = tmpJSON()
        let m = [LearnedMapping(channel: 2, isCC: true, control: 10, action: "cue")]
        try MappingStore.save(m, to: url)
        let d1 = try Data(contentsOf: url)
        try MappingStore.save(m, to: url)
        let d2 = try Data(contentsOf: url)
        #expect(d1 == d2)
        try? FileManager.default.removeItem(at: url)
    }

    @Test func defaultURLPointsToAppSupport() {
        #expect(MappingStore.defaultURL().lastPathComponent == "mappings.json")
        #expect(MappingStore.defaultURL().path.contains("TraktorClone"))
    }
}
