import Foundation

/// Ein Track aus einer Spotify-Playlist (nur Metadaten).
public struct SpotifyTrack: Equatable, Hashable {
    public let name: String
    public let artist: String
    public init(name: String, artist: String) {
        self.name = name
        self.artist = artist
    }
}

/// Importierte Playlist: Name + Track-Metadaten.
public struct SpotifyPlaylist: Equatable {
    public let name: String
    public let tracks: [SpotifyTrack]
    public init(name: String, tracks: [SpotifyTrack]) {
        self.name = name
        self.tracks = tracks
    }
}

public enum SpotifyClientError: Error, LocalizedError, Equatable {
    case badURL
    case http(Int)

    public var errorDescription: String? {
        switch self {
        case .badURL: return "Playlist-URL nicht erkennbar"
        case .http(let code): return "Spotify-Server: HTTP \(code)"
        }
    }
}

/// Spotify Web API: öffentliche Playlists als Metadaten importieren.
/// Absichtlich KEIN Audio-Streaming — Spotify untersagt DJ-Audio-Streaming
/// (Richtlinie für derivative Apps); wir matchen gegen die lokale Library.
/// Credentials ausschließlich via Environment: SPOTIFY_CLIENT_ID / SPOTIFY_CLIENT_SECRET.
public enum SpotifyClient {
    // MARK: URL/URI-Parsing

    /// Playlist-URL, -URI oder 22-Zeichen-ID → ID. Nur [A-Za-z0-9] wird durchgelassen
    /// (kein URL-Injection-Fenster im nachfolgenden Request-Pfad).
    public static func playlistID(from input: String) -> String? {
        let patterns = ["spotify:playlist:([A-Za-z0-9]+)", "playlist/([A-Za-z0-9]+)"]
        for p in patterns {
            if let range = input.range(of: p, options: .regularExpression) {
                let matched = String(input[range])
                let id = matched.split(whereSeparator: { ":/".contains($0) }).last.map(String.init)
                if let id, !id.isEmpty { return id }
            }
        }
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count == 22, trimmed.allSatisfy({ $0.isLetter || $0.isNumber }) { return trimmed }
        return nil
    }

    // MARK: API (async)

    /// Client-Credentials-Token. Secrets nur aus Environment-Argumenten (nicht im Code).
    public static func token(clientID: String, clientSecret: String) async throws -> String {
        let basic = Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()
        var req = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        req.httpMethod = "POST"
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.setValue("Basic \(basic)", forHTTPHeaderField: "Authorization")
        req.httpBody = "grant_type=client_credentials".data(using: .utf8)
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw SpotifyClientError.http((resp as? HTTPURLResponse)?.statusCode ?? -1) }
        struct T: Decodable { let access_token: String }
        return try JSONDecoder().decode(T.self, from: data).access_token
    }

    /// Holt Name + Tracks (bis 500) einer öffentlichen Playlist. `id` kommt aus
    /// `playlistID(from:)` und ist damit auf [A-Za-z0-9] beschränkt.
    public static func fetchPlaylist(id: String, token: String) async throws -> SpotifyPlaylist {
        var name = "Playlist"
        var tracks: [SpotifyTrack] = []
        var next: URL? = URL(string: "https://api.spotify.com/v1/playlists/\(id)")
        let decoder = JSONDecoder()
        struct Page: Decodable {
            struct Root: Decodable { let name: String? }
            struct Items: Decodable {
                struct Item: Decodable {
                    struct Track: Decodable {
                        struct Artist: Decodable { let name: String }
                        let name: String
                        let artists: [Artist]?
                    }
                    let track: Track?
                }
                let items: [Item]
                let next: URL?
            }
            let name: String?
            let tracks: Items?
        }
        var first = true
        while let url = next {
            var req = URLRequest(url: url)
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
                throw SpotifyClientError.http((resp as? HTTPURLResponse)?.statusCode ?? -1)
            }
            let page = try decoder.decode(Page.self, from: data)
            if first {
                name = page.name ?? name
                first = false
            }
            for item in page.tracks?.items ?? [] {
                if let t = item.track {
                    tracks.append(SpotifyTrack(name: t.name, artist: t.artists?.first?.name ?? ""))
                }
            }
            next = page.tracks?.next
            if tracks.count >= 500 { break }
        }
        return SpotifyPlaylist(name: name, tracks: tracks)
    }
}

/// Spotify-Track gegen lokale Library matchen (Titel/Artist, case-insensitiv).
public enum PlaylistMatch {
    public static func match(spotify: SpotifyTrack, in library: [NMLTrack]) -> NMLTrack? {
        let t = spotify.name.lowercased()
        let a = spotify.artist.lowercased()
        guard !t.isEmpty else { return nil }
        if let exact = library.first(where: { $0.title.lowercased() == t }) { return exact }
        if let contains = library.first(where: { $0.title.lowercased().contains(t) }) { return contains }
        if !a.isEmpty, let byArtist = library.first(where: {
            $0.artist.lowercased().contains(a) && !$0.title.isEmpty
        }) { return byArtist }
        return nil
    }
}
