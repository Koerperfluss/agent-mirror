import AVFoundation
import CoreMedia

/// Ergebnis eines Stem-Exports: geschriebene WAV-Dateien + zugehörige Rollen-Namen.
public struct StemExportResult {
    public let urls: [URL]
    public let roles: [String]

    public init(urls: [URL], roles: [String]) {
        self.urls = urls
        self.roles = roles
    }
}

/// Exportiert die Audio-Tracks einer NI-Stem-Datei (.stem.mp4) als einzelne WAV-Dateien.
/// Track 0 = Mixdown, Tracks 1...4 = Stems (NI-Konvention, siehe `StemFile.roleLabel`).
public enum StemExporter {

    /// Ziel-Format: Linear PCM, Float-32, 44.1 kHz, stereo.
    public static func wavSettings() -> [String: Any] {
        [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsFloatKey: true,
            AVLinearPCMBitDepthKey: 32,
            AVSampleRateKey: 44_100.0,
            AVNumberOfChannelsKey: 2,
        ]
    }

    /// Liest einen AVAssetTrack komplett via AVAssetReader und schreibt die
    /// PCM-Buffers in eine WAV (`stem_<index>.wav`). Gibt die Datei-URL zurück.
    @discardableResult
    public static func exportStems(assetTrack: AVAssetTrack, toDirectory: URL, index: Int) throws -> URL {
        let reader: AVAssetReader
        do {
            reader = try AVAssetReader(asset: assetTrack.asset!)
        } catch {
            throw error
        }

        let output = AVAssetReaderTrackOutput(track: assetTrack, outputSettings: wavSettings())
        reader.add(output)
        reader.startReading()

        let wavURL = toDirectory.appendingPathComponent("stem_\(index).wav")
        let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 44_100.0,
            channels: 2,
            interleaved: true
        )!
        let wavFile = try AVAudioFile(forWriting: wavURL, settings: format.settings)

        while let sampleBuffer = output.copyNextSampleBuffer() {
            if let pcmBuffer = audioPCMBuffer(from: sampleBuffer, format: format) {
                try wavFile.write(from: pcmBuffer)
            }
        }
        if reader.status == .failed, let readError = reader.error {
            throw readError
        }
        return wavURL
    }

    /// Exportiert Mixdown + alle Stems einer Stem-Datei. Rollen via `StemFile.roleLabel`.
    public static func exportAll(from url: URL, toDirectory: URL) throws -> StemExportResult {
        let stemFile = StemFile(url: url)
        guard !stemFile.audioTracks.isEmpty else {
            throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: url.path])
        }

        var urls: [URL] = []
        var roles: [String] = []
        for (i, track) in stemFile.audioTracks.enumerated() {
            urls.append(try exportStems(assetTrack: track, toDirectory: toDirectory, index: i))
            roles.append(StemFile.roleLabel(of: track, index: i))
        }
        return StemExportResult(urls: urls, roles: roles)
    }

    /// CMSampleBuffer → AVAudioPCMBuffer (no-copy; Block-Buffer wird mit freigegeben).
    private static func audioPCMBuffer(from sampleBuffer: CMSampleBuffer, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        var audioBufferList = AudioBufferList()
        var blockBuffer: CMBlockBuffer?

        let status = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: nil,
            bufferListOut: &audioBufferList,
            bufferListSize: MemoryLayout<AudioBufferList>.size,
            blockBufferAllocator: kCFAllocatorDefault,
            blockBufferMemoryAllocator: kCFAllocatorDefault,
            flags: 0,
            blockBufferOut: &blockBuffer
        )
        guard status == noErr, blockBuffer != nil else { return nil }
        let bufferSize = Int(audioBufferList.mBuffers.mDataByteSize)
        guard bufferSize > 0, let srcData = audioBufferList.mBuffers.mData else { return nil }

        let bytesPerFrame = Int(format.streamDescription.pointee.mBytesPerFrame)
        guard let pcmBuffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: AVAudioFrameCount(bufferSize / bytesPerFrame)
        ), let dstData = pcmBuffer.audioBufferList.pointee.mBuffers.mData else { return nil }

        // PCM-Daten in den AVAudioPCMBuffer kopieren (Block-Buffer wird automatisch freigegeben).
        memcpy(dstData, srcData, bufferSize)
        pcmBuffer.frameLength = AVAudioFrameCount(bufferSize / bytesPerFrame)
        return pcmBuffer
    }
}
