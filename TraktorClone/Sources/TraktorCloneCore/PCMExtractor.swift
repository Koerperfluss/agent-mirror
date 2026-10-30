import AVFoundation

/// Lädt Audiodateien als Mono-Float-Samples (alles Weitere läuft auf reinen Arrays — testbar).
public enum PCMExtractor {
    /// Mono-Mixdown, optional auf maxSeconds begrenzt. Fehler → leeres Array.
    public static func loadMono(url: URL, maxSeconds: Double = 120) -> [Float] {
        guard let file = try? AVAudioFile(forReading: url) else { return [] }
        return mono(from: file, maxSeconds: maxSeconds)
    }

    public static func mono(from file: AVAudioFile, maxSeconds: Double = 120) -> [Float] {
        let sr = file.processingFormat.sampleRate
        let cap = min(AVAudioFrameCount(file.length), AVAudioFrameCount(max(1, sr * maxSeconds)))
        guard let buf = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: cap)
        else { return [] }
        try? file.read(into: buf)
        let n = Int(buf.frameLength)
        guard n > 0, let ch = buf.floatChannelData else { return [] }
        let channels = max(1, Int(file.processingFormat.channelCount))
        var out = [Float](repeating: 0, count: n)
        for i in 0..<n {
            var s: Float = 0
            for c in 0..<channels { s += ch[c][i] }
            out[i] = s / Float(channels)
        }
        return out
    }
}
