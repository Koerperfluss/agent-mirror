import Foundation

/// Track aus collection.nml (XML, verifiziert). Nur Metadaten — keine PII persistiert.
public struct NMLTrack: Equatable {
    public var title: String = ""
    public var artist: String = ""
    public var path: String = ""          // VOLUME + DIR + FILE zusammengesetzt
    public var bpm: Double?
    public var keyText: String = ""
    public init() {}
}

/// Liest <NML><COLLECTION><ENTRY>-Struktur: TITLE/ARTIST-Attribute, LOCATION
/// (VOLUME/DIR/FILE), TEMPO (BPM-Attribut), MUSICAL_KEY (VALUE). Tolerant gegen
/// fehlende Felder (Traktor schreibt optional).
public final class NMLParser: NSObject, XMLParserDelegate {
    public private(set) var tracks: [NMLTrack] = []

    private var inCollection = false
    private var current: NMLTrack?

    public static func parse(data: Data) -> [NMLTrack] {
        let p = NMLParser()
        let parser = XMLParser(data: data)
        parser.delegate = p
        parser.parse()
        return p.tracks
    }

    public static func parse(url: URL) -> [NMLTrack] {
        (try? Data(contentsOf: url)).map { parse(data: $0) } ?? []
    }

    // MARK: XMLParserDelegate
    public func parser(_ parser: XMLParser, didStartElement name: String,
                       namespaceURI: String?, qualifiedName: String?,
                       attributes: [String: String]) {
        switch name {
        case "COLLECTION":
            inCollection = true
        case "ENTRY" where inCollection:
            var t = NMLTrack()
            t.title = attributes["TITLE"] ?? ""
            t.artist = attributes["ARTIST"] ?? ""
            current = t
        case "LOCATION" where current != nil:
            let vol = attributes["VOLUME"] ?? ""
            let dir = attributes["DIR"] ?? ""
            let file = attributes["FILE"] ?? ""
            current?.path = vol + dir.replacingOccurrences(of: "/:", with: "/") + file
        case "TEMPO" where current != nil:
            if let bpm = attributes["BPM"], let v = Double(bpm) { current?.bpm = v }
        case "MUSICAL_KEY" where current != nil:
            current?.keyText = attributes["VALUE"] ?? ""
        default:
            break
        }
    }

    public func parser(_ parser: XMLParser, didEndElement name: String,
                       namespaceURI: String?, qualifiedName: String?) {
        if name == "ENTRY", let t = current {
            tracks.append(t)
            current = nil
        }
        if name == "COLLECTION" { inCollection = false }
    }
}

/// Suche im Library-Index (Fall insensitive, Titel/Artist/Pfad).
public enum LibrarySearch {
    public static func filter(_ tracks: [NMLTrack], query: String) -> [NMLTrack] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return tracks }
        return tracks.filter {
            $0.title.localizedCaseInsensitiveContains(q)
                || $0.artist.localizedCaseInsensitiveContains(q)
                || $0.path.localizedCaseInsensitiveContains(q)
        }
    }
}
