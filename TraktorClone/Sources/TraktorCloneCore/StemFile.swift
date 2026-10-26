import AVFoundation

/// NI-Stem-Datei (.stem.mp4): MP4 mit 5 Audio-Tracks (1× Mix + 4× Stem).
/// Tracks werden LAZY geladen (async-I/O blockiert nicht den Main-Thread).
public final class StemFile {
    public let url: URL
    private let asset: AVURLAsset
    private var cachedTracks: [AVAssetTrack]?

    public init(url: URL) {
        self.url = url
        self.asset = AVURLAsset(url: url)
    }

    /// Sync-Zugriff mit Cache; erster Aufruf kann I/O kosten (Call im Hintergrund halten).
    public var audioTracks: [AVAssetTrack] {
        if let cached = cachedTracks { return cached }
        // Sync-API (deprecated-Warnung ok, mac13-kompatibel); Fehler → leere Liste
        cachedTracks = asset.tracks(withMediaType: .audio)
        return cachedTracks ?? []
    }

    /// Track 0 = Mixdown, Tracks 1...4 = Drums/Bass/Other/Vocal (NI-Konvention).
    public var mixTrack: AVAssetTrack? { audioTracks.first }
    public var stemTracks: [AVAssetTrack] { Array(audioTracks.dropFirst().prefix(4)) }
    public var isStemFile: Bool { stemTracks.count == 4 }

    /// NI speichert Rollen im Track-Namen ("Drums", "Bass", "Other", "Vocals").
    public static func roleLabel(of track: AVAssetTrack, index: Int) -> String {
        let names = ["Mix", "Drums", "Bass", "Other", "Vocals"]
        return names.indices.contains(index) ? names[index] : "Track \(index)"
    }
}
