import Foundation

/// Erzeugt aus Skizzen-Beschreibung/Bild + Prompt lauffähigen Prototyp-Code
/// via lokalem Coder-Modell (qwen2.5-coder) — kein Cloud-Key.
public enum PrototypeGenerator {

    /// Extrahiert den Code aus einer LLM-Antwort:
    /// nimmt den ersten ```-Codeblock; ohne Fence die getrimmte Gesamtantwort.
    public static func sanitize(_ raw: String) -> String {
        let fences = raw.components(separatedBy: "```")
        guard fences.count >= 3 else { return raw.trimmingCharacters(in: .whitespacesAndNewlines) }
        var code = fences[1]
        // Sprach-Tag der ersten Zeile entfernen (swift/html/…)
        if let nl = code.firstIndex(of: "\n") {
            let first = String(code[code.startIndex..<nl]).trimmingCharacters(in: .whitespaces)
            if !first.isEmpty && !first.contains(" ") && first.allSatisfy({ $0.isLetter }) {
                code = String(code[code.index(nl, offsetBy: 1)...])
            }
        }
        return code.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Baut den Aufgaben-Prompt fürs Coder-Modell (SwiftUI, ein Codeblock).
    public static func buildPrompt(sketchDescription: String, userPrompt: String) -> String {
        """
        Du bist ein UI-Prototyp-Generator. Aus der Skizzen-Beschreibung und der
        Nutzeranforderung erzeugst Du EINEN vollständigen, kompilierbaren
        SwiftUI-View-Code (macOS). Antworte NUR mit einem einzigen ```swift-Codeblock,
        keine Erklärungen.

        Skizze: \(sketchDescription.isEmpty ? "(leer)" : sketchDescription)
        Anforderung: \(userPrompt.isEmpty ? "sinnvolle Standard-UI" : userPrompt)
        """
    }

    /// End-to-End (async): Prompt an lokales Coder-Modell → sanitierter Code.
    public static func generate(sketchDescription: String, userPrompt: String,
                                client: OllamaClient = OllamaClient()) async throws -> String {
        let prompt = buildPrompt(sketchDescription: sketchDescription, userPrompt: userPrompt)
        let raw = try await client.chat(model: LocalModels.coder, messages: [
            OllamaMessage(role: "user", content: prompt)
        ])
        return sanitize(raw)
    }
}
