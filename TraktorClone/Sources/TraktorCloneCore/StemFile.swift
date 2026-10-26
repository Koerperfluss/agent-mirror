import AVFoundation

/// NI-Stem-Datei (.stem.mp4): MP4 mit 5 Audio-Tracks (1× Mix + 4× Stem).
/// Slice-7-Umfang: Struktur-Erkennung + Track-Titel; 4-Spur-Playback folgt
/// über 4 PlayerNodes (Ticket im STATE.md — AVAssetReader-Pump).
public final class StemFile {
    public let url: URL
    public private(set) var audioTracks: [AVAssetTrack] = []

    public init(url: URL) {
        self.url = url
        let asset = AVURLAsset(url: url)
        // Sync-API (deprecated-Warnung ok, mac13-kompatibel); Fehler → leere Liste
        audioTracks = asset.tracks(withMediaType: .audio)
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
