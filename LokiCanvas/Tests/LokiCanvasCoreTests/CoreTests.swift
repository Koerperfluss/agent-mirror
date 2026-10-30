import Foundation
import Testing
@testable import LokiCanvasCore

@Suite struct OllamaClientTests {
    @Test func parseChatResponseValid() {
        let data = Data(#"{"model":"x","message":{"role":"assistant","content":"Hallo Canvas"}}"#.utf8)
        #expect(OllamaClient.parseChatResponse(data) == "Hallo Canvas")
    }

    @Test func parseChatResponseMissingMessage() {
        let data = Data(#"{"model":"x"}"#.utf8)
        #expect(OllamaClient.parseChatResponse(data) == "")
    }

    @Test func parseChatResponseGarbageIsNil() {
        #expect(OllamaClient.parseChatResponse(Data("nicht json".utf8)) == nil)
    }

    @Test func buildRequestBodyStreamFalseAndModel() throws {
        let body = try OllamaClient.buildRequestBody(model: "m1", messages: [
            OllamaMessage(role: "user", content: "hi")
        ])
        let obj = try #require(try JSONSerialization.jsonObject(with: body) as? [String: Any])
        #expect(obj["model"] as? String == "m1")
        #expect(obj["stream"] as? Bool == false)
        let msgs = try #require(obj["messages"] as? [[String: Any]])
        #expect(msgs.first?["content"] as? String == "hi")
    }

    @Test func visionMessageCarriesImages() throws {
        // Vision = letzte User-Nachricht enthält Base64-Bild (Ollama-API)
        let msg = OllamaMessage(role: "user", content: "was siehst du?", images: ["QUJD"])
        #expect(msg.images == ["QUJD"])
        let enc = try JSONEncoder().encode(msg)
        let obj = try #require(try JSONSerialization.jsonObject(with: enc) as? [String: Any])
        #expect((obj["images"] as? [String])?.count == 1)
    }

    @Test func parseTagsExtractsNames() {
        let data = Data(#"{"models":[{"name":"qwen3.5:9b"},{"name":"qwen2.5-coder:7b"}]}"#.utf8)
        #expect(OllamaClient.parseTags(data) == ["qwen3.5:9b", "qwen2.5-coder:7b"])
    }

    @Test func localModelsConstants() {
        #expect(LocalModels.chat.contains("qwen"))
        #expect(LocalModels.vision.contains("vl"))
        #expect(LocalModels.coder.contains("coder"))
    }
}

@Suite struct NodeModelTests {
    @Test func nodeCodableRoundtrip() throws {
        var n = CanvasNode(kind: .sketch, x: 10, y: 20, title: "Idee")
        n.strokes = [Stroke(color: "#22D3EE", width: 3, points: [[0, 0], [5, 5]])]
        // iso8601 speichert Sekunden-Genauigkeit → Fixture auf ganze Sekunde runden,
        // sonst scheitert der exakte Gleichheits-Vergleich an Bruchteilen.
        n.createdAt = Date(timeIntervalSinceReferenceDate: n.createdAt.timeIntervalSinceReferenceDate.rounded())
        let enc = JSONEncoder(); enc.dateEncodingStrategy = .iso8601
        let data = try enc.encode(n)
        let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
        let back = try dec.decode(CanvasNode.self, from: data)
        #expect(back == n)
    }

    @Test func kindRawValuesStable() {
        #expect(NodeKind.sketch.rawValue == "sketch")
        #expect(NodeKind.prototype.rawValue == "prototype")
    }
}

@Suite struct CanvasDocumentTests {
    @Test func roundtripViaTmpFile() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("lc-\(UUID().uuidString).json")
        var doc = CanvasDocument(name: "Test", nodes: [CanvasNode(kind: .text, text: "hello")])
        doc.zoom = 1.5; doc.panX = -30
        try doc.save(to: url)
        let back = try CanvasDocument.load(from: url)
        #expect(back.name == "Test")
        #expect(back.nodes.first?.text == "hello")
        #expect(back.zoom == 1.5 && back.panX == -30)
        try? FileManager.default.removeItem(at: url)
    }

    @Test func defaultDirectoryUnderDocuments() {
        #expect(CanvasDocument.defaultDirectory().path.contains("LokiCanvas"))
        #expect(CanvasDocument.autosaveURL().lastPathComponent == "autosave.json")
    }

    @Test func loadAutosaveNilWhenMissing() {
        #expect(CanvasDocument.loadAutosave() is CanvasDocument?)
    }
}

@Suite struct PrototypeGeneratorTests {
    @Test func sanitizeExtractsFirstFence() {
        let raw = "Erklärung\n```swift\nText(\"Hi\")\n```\nMehr Text"
        #expect(PrototypeGenerator.sanitize(raw) == "Text(\"Hi\")")
    }

    @Test func sanitizeStripsLanguageTag() {
        let raw = "```html\n<b>fett</b>\n```"
        #expect(PrototypeGenerator.sanitize(raw) == "<b>fett</b>")
    }

    @Test func sanitizeNoFenceTrims() {
        #expect(PrototypeGenerator.sanitize("  plain code\n") == "plain code")
    }

    @Test func buildPromptContainsParts() {
        let p = PrototypeGenerator.buildPrompt(sketchDescription: "3 Boxen", userPrompt: "Login")
        #expect(p.contains("3 Boxen"))
        #expect(p.contains("Login"))
        #expect(p.contains("SwiftUI"))
    }
}

@Suite struct VoiceParserTests {
    @Test func textNodeWithTitle() {
        let c = VoiceParser.parse("Neuer Text Knoten Einkaufsliste")
        #expect(c == .addTextNode("einkaufsliste"))
    }

    @Test func textNodeWithoutTitle() {
        #expect(VoiceParser.parse("neue notiz") == .addTextNode(nil))
    }

    @Test func sketchCommand() {
        #expect(VoiceParser.parse("neue Skizze bitte") == .addSketchNode)
    }

    @Test func deleteCommand() {
        #expect(VoiceParser.parse("lösche Auswahl") == .deleteSelected)
    }

    @Test func questionFallback() {
        #expect(VoiceParser.parse("Was ist SwiftUI?") == .ask("Was ist SwiftUI?"))
    }

    @Test func fragePrefixStripped() {
        #expect(VoiceParser.parse("Frage wie erstellt man einen Button") ==
                .ask("wie erstellt man einen button"))
    }
}
