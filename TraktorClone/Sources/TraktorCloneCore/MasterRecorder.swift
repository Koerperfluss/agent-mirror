import AVFoundation

/// Nimmt den Master-Ausgang (mainMixer-Tap) in eine PCM-Datei auf.
public final class MasterRecorder {
    private var file: AVAudioFile?
    public private(set) var isRecording = false
    public private(set) var startedAt: Date?

    public init() {}

    /// PCM-16-bit/44.1k/stereo — Standard für DJ-Exporte.
    public static func pcmSettings() -> [String: Any] {
        [AVFormatIDKey: kAudioFormatLinearPCM,
         AVLinearPCMBitDepthKey: 16,
         AVLinearPCMIsFloatKey: false,
         AVLinearPCMIsBigEndianKey: false,
         AVSampleRateKey: 44100.0,
         AVNumberOfChannelsKey: 2]
    }

    public func start(engine: AVAudioEngine, url: URL) throws {
        guard !isRecording else { return }
        let f = try AVAudioFile(forWriting: url, settings: MasterRecorder.pcmSettings())
        file = f
        isRecording = true                                  // VOR installTap: Tap darf nichts droppen
        startedAt = Date()
        let format = engine.mainMixerNode.outputFormat(forBus: 0)
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            guard let self, self.isRecording, let f = self.file else { return }
            do { try f.write(from: buffer) }
            catch { NSLog("TraktorClone Recorder: Schreibfehler \(error)") }   // nicht still schlucken
        }
    }

    public func stop(engine: AVAudioEngine) {
        guard isRecording else { return }
        engine.mainMixerNode.removeTap(onBus: 0)
        file = nil
        isRecording = false
        startedAt = nil
    }
}
