import Foundation

/// Ein NI-Action-Eintrag aus einer Controller-TSI (aus DCDT-Records gelesen).
public struct TSIActionName: Equatable {
    public let name: String          // z. B. "Left.Cue.Play"
    public let supported: Bool       // wir haben eine passende DeckAction
    public init(name: String, supported: Bool) {
        self.name = name; self.supported = supported
    }
}

/// Reverse-Engineered Reader für NI-Controller-TSIs (Interop, § 40e UrhG).
///
/// Format (aus Bytecode-Analyse der S4/S2-User-Mappings): Die .tsi ist
/// NIXML-XML; die Controller-Definition steckt Base64-kodiert im Entry
/// `DeviceIO.Config.Controller`. Im Blob markiert `DCDT` einen Action-Record:
///
///     "DCDT" · u32 payloadLen · u16 skip · u16 nameLen(chars) · UTF-16LE-Name · …
///
/// Wichtig, ehrlich: Diese Templates (S4/S2 = HID-Hardware) speichern die
/// Action-Registry OHNE MIDI-Nummern (konstanter Platzhalter statt Note/CC).
/// Konkrete Controller-Bindings entstehen daher über unser MIDI-Learn;
/// dieser Reader liefert den Action-Katalog + Unterstützungs-Check.
public enum TSIMappingImporter {

    /// Liest alle Action-Namen aus einer NI-Controller-.tsi (Datei).
    public static func actions(url: URL) -> [TSIActionName] {
        guard let data = try? Data(contentsOf: url) else { return [] }
        return actions(data: data)
    }

    /// Liest alle Action-Namen aus NIXML-Rohdaten.
    public static func actions(data: Data) -> [TSIActionName] {
        var names = Set<String>()
        for entry in TSIParser.parse(data: data) where entry.element == "Entry" {
            guard let value = entry.attributes["Value"],
                  let blob = Data(base64Encoded: value) else { continue }
            for name in scanDCDT(blob: blob) {
                // NI-Actions tragen immer Punkt-Notation ("Left.Cue.Play");
                // das filtert Fragmente aus Header-Bytes und Metadaten.
                if name.contains(".") { names.insert(name) }
            }
        }
        return names.sorted().map { TSIActionName(name: $0, supported: deckAction(forNI: $0) != nil) }
    }

    /// Scannt den Blob nach [u16 nlen][UTF-16LE-ASCII-Name]-Mustern.
    /// Robust gegen Record-Header-Varianten (NI-Felder wechseln je Version);
    /// Nicht-ASCII-Müll filtert die Druckbarkeitsprüfung heraus.
    static func scanDCDT(blob: Data) -> [String] {
        let bytes = [UInt8](blob)
        var out: [String] = []
        var i = 0
        while i + 2 <= bytes.count - 2 {
            let nlen = Int(UInt16(bytes[i]) | UInt16(bytes[i + 1]) << 8)
            if nlen >= 2, nlen <= 64, i + 2 + nlen * 2 <= bytes.count {
                var chars: [UInt16] = []
                chars.reserveCapacity(nlen)
                var ok = true
                for c in 0..<nlen {
                    let lo = UInt16(bytes[i + 2 + c * 2])
                    let hi = UInt16(bytes[i + 2 + c * 2 + 1])
                    let ch = lo | hi << 8
                    // Nur druckbares ASCII in UTF-16LE (High-Byte 0, 0x20…0x7E)
                    if hi != 0 || lo < 0x20 || lo > 0x7E { ok = false; break }
                    chars.append(ch)
                }
                if ok {
                    out.append(String(decoding: chars, as: UTF16.self))
                    i += 2 + nlen * 2
                    continue
                }
            }
            i += 1
        }
        return out
    }

    // MARK: NI-Name → TraktorClone-DeckAction

    /// Übersetzt bekannte NI-Action-Namen auf unsere Aktionen.
    /// Left.* = Deck A, Right.* = Deck B. Rückgabe nil = nicht unterstützt.
    public static func deckAction(forNI name: String) -> DeckAction? {
        switch name {
        // Deck A
        case "Left.Cue.Play", "Left.Play": return .playPause
        case "Left.Cue": return .cue
        case "Left.Hotcue. 1 ": return .hotcue1
        case "Left.Hotcue. 2 ": return .hotcue2
        case "Left.Hotcue. 3 ": return .hotcue3
        case "Left.Hotcue. 4 ": return .hotcue4
        case "Left.Loop.In": return .loopIn
        case "Left.Loop.Out": return .loopOut
        case "Left.Loop.Move": return .loopExit
        // Deck B
        case "Right.Cue.Play", "Right.Play": return .playPauseB
        case "Right.Cue": return .cueB
        case "Right.Hotcue. 1 ": return .hotcue1B
        case "Right.Hotcue. 2 ": return .hotcue2B
        case "Right.Hotcue. 3 ": return .hotcue3B
        case "Right.Hotcue. 4 ": return .hotcue4B
        case "Right.Loop.In": return .loopInB
        case "Right.Loop.Out": return .loopOutB
        // Global
        case "Crossfader": return .crossfader
        default: return nil
        }
    }
}
