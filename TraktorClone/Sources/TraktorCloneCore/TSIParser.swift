import Foundation

/// Liest Native-Instruments-XML: Traktor Settings (.tsi, verifiziert Plain-XML
/// `<NIXML><TraktorSettings><Entry Name Type Value>`) und generisch NIXML-Elemente
/// mit Attributen (z. B. <MAPPING ...> in Mapping-.tsi-Dateien).
public struct TSIEntry: Equatable {
    public let element: String            // z. B. "Entry", "MAPPING"
    public let attributes: [String: String]
}

public final class TSIParser: NSObject, XMLParserDelegate {
    public private(set) var entries: [TSIEntry] = []
    private var currentElement: String?
    private var currentAttributes: [String: String] = [:]

    public static func parse(data: Data) -> [TSIEntry] {
        let p = TSIParser()
        let parser = XMLParser(data: data)
        parser.delegate = p
        parser.parse()   // Fehler tolerant: bislang Geparstes zurückgeben
        return p.entries
    }

    public static func parse(url: URL) -> [TSIEntry] {
        (try? Data(contentsOf: url)).map { parse(data: $0) } ?? []
    }

    // MARK: XMLParserDelegate
    public func parser(_ parser: XMLParser,
                       didStartElement name: String,
                       namespaceURI: String?, qualifiedName: String?,
                       attributes: [String: String]) {
        currentElement = name
        currentAttributes = attributes
    }

    public func parser(_ parser: XMLParser, didEndElement name: String,
                       namespaceURI: String?, qualifiedName: String?) {
        if let el = currentElement, !currentAttributes.isEmpty {
            entries.append(TSIEntry(element: el, attributes: currentAttributes))
        }
        currentElement = nil
        currentAttributes = [:]
    }
}

/// MIDI-Zuordnung: Control (Note oder CC) → Deck-Aktion. Reine Logik.
public enum DeckAction: String, Codable, Equatable {
    case playPause, cue, hotcue1, hotcue2, hotcue3, hotcue4
    case loopIn, loopOut, loopExit
    case crossfader, channelFaderA, channelFaderB
    case pitchA, pitchB, keylockA, keylockB
}

public struct MIDIAssignment: Equatable {
    public let channel: UInt8          // 0-basiert
    public let isCC: Bool              // false = Note
    public let control: UInt8          // Note/CC-Nummer
    public let action: DeckAction
    public init(channel: UInt8, isCC: Bool, control: UInt8, action: DeckAction) {
        self.channel = channel; self.isCC = isCC; self.control = control; self.action = action
    }
}

/// Routet MIDI-Events auf Aktionen. UI/Engine registrieren Handler pro Aktion.
public final class MIDIActionRouter {
    public private(set) var assignments: [MIDIAssignment] = []
    public var onAction: ((DeckAction, UInt8) -> Void)?   // value 0...127

    public init() {}

    public func assign(_ a: MIDIAssignment) {
        assignments.removeAll { $0.channel == a.channel && $0.isCC == a.isCC && $0.control == a.control }
        assignments.append(a)
    }

    public func clear() { assignments.removeAll() }

    /// Normale MIDI-Events (anzahl Bytes 3: [status, d1, d2]).
    public func route(event bytes: [UInt8]) {
        guard bytes.count >= 3 else { return }
        let status = bytes[0]
        let type = status & 0xF0
        guard type == 0x90 || type == 0xB0 else { return }   // Note-On oder CC
        let channel = status & 0x0F
        let isCC = type == 0xB0
        let control = bytes[1]
        let value = bytes[2]
        // Note-On mit Velocity 0 = Note-Off → ignorieren
        if !isCC && value == 0 { return }
        guard let a = assignments.first(where: { $0.channel == channel && $0.isCC == isCC && $0.control == control }) else { return }
        onAction?(a.action, value)
    }
}
