import Testing
import AVFoundation
@testable import TraktorCloneCore

@Suite struct StemExporterTests {

    @Test func wavSettingsKeys() {
        let s = StemExporter.wavSettings()
        #expect(s[AVFormatIDKey] as? UInt32 == kAudioFormatLinearPCM)
        #expect(s[AVLinearPCMIsFloatKey] as? Bool == true)
        #expect(s[AVLinearPCMBitDepthKey] as? Int == 32)
        #expect(s[AVSampleRateKey] as? Double == 44_100.0)
        #expect(s[AVNumberOfChannelsKey] as? Int == 2)
    }

    @Test func exportAllMissingFileThrows() {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("dummy.mp4")
        #expect(throws: CocoaError.self) {
            try StemExporter.exportAll(from: tmp, toDirectory: tmp.deletingLastPathComponent())
        }
    }

    @Test func resultInitAndRoleLabelFallback() {
        let result = StemExportResult(urls: [], roles: [])
        #expect(result.urls.isEmpty)
        #expect(result.roles.isEmpty)

        #expect(StemFile.roleLabel(of: AVAssetTrack(), index: 0) == "Mix")
        #expect(StemFile.roleLabel(of: AVAssetTrack(), index: 4) == "Vocals")
        #expect(StemFile.roleLabel(of: AVAssetTrack(), index: 9) == "Track 9")
    }
}
