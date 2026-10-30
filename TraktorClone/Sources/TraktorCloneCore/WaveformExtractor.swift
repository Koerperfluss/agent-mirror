import AVFoundation

/// Extrahiert eine normierte Peak-Hüllkurve (Buckets) aus einer Audiodatei
/// für Waveform-Rendering. Sync-Aufruf — App ruft im Hintergrund-Task.
public enum WaveformExtractor {
    public static func extract(url: URL, buckets: Int = 512) throws -> [Float] {
        precondition(buckets > 0)
        let file = try AVAudioFile(forReading: url)
        let format = file.processingFormat
        let totalFrames = AVAudioFrameCount(file.length)
        guard totalFrames > 0 else { return Array(repeating: 0, count: buckets) }

        let framesPerBucket = max(1, Int(totalFrames) / buckets)
        var peaks = [Float](repeating: 0, count: buckets)
        let chunkCapacity = AVAudioFrameCount(16384)
        guard let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: chunkCapacity) else {
            return peaks
        }

        var bucket = 0
        var bucketPeak: Float = 0
        var consumed = 0

        while file.framePosition < totalFrames && bucket < buckets {
            try file.read(into: buf)
            let frames = Int(buf.frameLength)
            guard frames > 0, let channel = buf.floatChannelData?[0] else { break }
            for i in 0..<frames {
                let v = abs(channel[i])
                if v > bucketPeak { bucketPeak = v }
                consumed += 1
                if consumed >= framesPerBucket && bucket < buckets {
                    peaks[bucket] = bucketPeak
                    bucket += 1
                    bucketPeak = 0
                    consumed = 0
                }
            }
        }
        if bucket < buckets { peaks[bucket] = bucketPeak }   // Rest-Bucket

        // Normalisieren auf Maximum (View muss nicht skalieren)
        let maxP = peaks.max() ?? 1
        if maxP > 0 {
            for i in 0..<peaks.count { peaks[i] /= maxP }
        }
        return peaks
    }
}

/// Sichtbares Waveform-Fenster (Zoom): Playhead sitzt in der Fenstermitte,
/// Klick-/Drag-Positionen werden über offset+width zurück auf Track-Zeiten gemappt.
public enum WaveWindow {
    /// `offset` = Fensterstart als Anteil (0..<1), `width` = Fensterbreite als Anteil.
    public static func visible(playheadFraction: Double, zoom: Int,
                               buckets: Int) -> (offset: Double, width: Double) {
        guard buckets > 0, zoom > 1 else { return (0, 1) }
        let win = max(1, buckets / zoom)
        let frac = min(max(playheadFraction, 0), 1)
        var start = Int(frac * Double(buckets)) - win / 2
        start = max(0, min(start, buckets - win))
        return (Double(start) / Double(buckets), Double(win) / Double(buckets))
    }
}
