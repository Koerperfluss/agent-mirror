import Foundation

/// User-Playlist ("Crate"): geordnete Liste lokaler Track-Pfade.
public struct Playlist: Codable, Equatable, Identifiable {
    public var id: UUID
    public var name: String
    public var trackPaths: [String]

    public init(id: UUID = UUID(), name: String, trackPaths: [String] = []) {
        self.id = id
        self.name = name
        self.trackPaths = trackPaths
    }
}

/// Persistiert alle Playlists als JSON. Tests nutzen `save(_:to:)` mit Temp-Verzeichnis —
/// die Default-URL gehört nur der laufenden App.
public enum PlaylistStore {
    public static func defaultURL() -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("TraktorClone/playlists.json")
    }

    public static func save(_ playlists: [Playlist]) throws {
        try save(playlists, to: defaultURL())
    }

    public static func save(_ playlists: [Playlist], to url: URL) throws {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try enc.encode(playlists)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        try data.write(to: url, options: [.atomic])
    }

    public static func load() -> [Playlist] {
        load(from: defaultURL())
    }

    public static func load(from url: URL) -> [Playlist] {
        guard let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([Playlist].self, from: data) else { return [] }
        return list
    }
}
