import Foundation

/// Sprach-Befehle (deutsch), die der Voice-Agent aus dem Transcript zieht.
/// Reine Logik — testbar; die Erkennung (SFSpeechRecognizer) sitzt in der App.
public enum VoiceCommand: Equatable {
    case addTextNode(String?)        // "neuer text knoten …"
    case addSketchNode               // "neue skizze"
    case deleteSelected              // "lösche (auswahl)"
    case ask(String)                 // "frage …" / alles andere → KI-Frage
}

public enum VoiceParser {
    /// Interpretiert ein deutsches Transcript in einen Befehl.
    public static func parse(_ raw: String) -> VoiceCommand {
        let t = raw.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return .ask("") }

        // Text-Knoten: "neuer text knoten …" ODER schlicht "neue notiz …"
        // ("notiz" allein genügt als Stichwort — natürliche Sprache).
        let isTextNode =
            (t.contains("text") && (t.contains("knoten") || t.contains("notiz")))
            || t.contains("notiz")
        if isTextNode {
            // Titel nach dem letzten Stichwort
            if let range = t.range(of: "knoten") ?? t.range(of: "notiz") {
                let rest = String(t[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                    .trimmingCharacters(in: CharacterSet(charactersIn: ".,"))
                return .addTextNode(rest.isEmpty ? nil : rest)
            }
            return .addTextNode(nil)
        }
        if t.contains("skizze") || t.contains("zeichnen") { return .addSketchNode }
        if t.hasPrefix("lösche") || t.hasPrefix("loesche") || t.contains("löschen") {
            return .deleteSelected
        }
        if let range = t.range(of: "frage") {
            return .ask(String(t[range.upperBound...]).trimmingCharacters(in: .whitespaces))
        }
        return .ask(raw)   // Fallback: alles als KI-Frage
    }
}
