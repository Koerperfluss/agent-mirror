import Foundation
import CryptoKit

/// Dauerhaft gespeicherte Track-Daten (pro Datei-Pfad): Cue, Hotcues, BPM, Key.
public struct TrackMemoryEntry: Codable, Equatable {
    public var path: String
    public var cue: Double?
    public var hotcues: [String: Double]      // "1"..."4" → Sekunden
    public var bpm: Double?
    public var key: String?
    public var beatgridOffset: Double?      // Sekunden bis Beat 0 (Phase-Grid, optional → alte Dateien laden)

    public init(path: String, cue: Double? = nil, hotcues: [String: Double] = [:],
                bpm: Double? = nil, key: String? = nil, beatgridOffset: Double? = nil) {
        self.path = path; self.cue = cue; self.hotcues = hotcues
        self.bpm = bpm; self.key = key; self.beatgridOffset = beatgridOffset
    }
}

/// Speichert Track-Memory als JSON unter ~/Library/Application Support/TraktorClone/memory/.
public enum TrackMemoryStore {
    /// Dateiname = SHA256 des absoluten Pfads (stabil, ohne Sonderzeichen).
    public static func fileName(for path: String) -> String {
        let digest = SHA256.hash(data: Data(path.utf8))
        return digest.map { String(format: "%02x", $0) }.joined() + ".json"
    }

    public static func directory() -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("TraktorClone/memory", isDirectory: true)
    }

    public static func save(_ entry: TrackMemoryEntry) {
        let url = directory().appendingPathComponent(fileName(for: entry.path))
        try? FileManager.default.createDirectory(at: directory(), withIntermediateDirectories: true)
        let enc = JSONEncoder(); enc.outputFormatting = [.sortedKeys]
        if let data = try? enc.encode(entry) {
            try? data.write(to: url, options: [.atomic])
        }
    }

    public static func load(path: String) -> TrackMemoryEntry? {
        let url = directory().appendingPathComponent(fileName(for: path))
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(TrackMemoryEntry.self, from: data)
    }
}
