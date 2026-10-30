import SwiftUI
import LokiCanvasCore
import AppKit
import UniformTypeIdentifiers

/// Zentraler Zustand: Knoten, Kamera, Auswahl, KI-Aufrufe, Persistenz.
@MainActor
final class CanvasViewModel: ObservableObject {
    @Published var nodes: [CanvasNode] = []
    @Published var panX: Double = 0
    @Published var panY: Double = 0
    @Published var zoom: Double = 1
    @Published var selection: UUID?
    @Published var status = "bereit"
    @Published var busy = false
    @Published var chatOnline = false
    @Published var visionOnline = false
    @Published var coderOnline = false
    @Published var docName = "Unbenannt"

    let client = OllamaClient()

    // Pan-Hilfsspeicher (gestenbasiert)
    private var panBase: (Double, Double)?
    private var dragOrigin: (Double, Double)?

    init() {
        if let auto = CanvasDocument.loadAutosave() {
            nodes = auto.nodes
            panX = auto.panX; panY = auto.panY; zoom = auto.zoom
            docName = auto.name
            status = "Autosave geladen (\(auto.nodes.count) Knoten)"
        }
        Task { await checkModels() }
    }

    // MARK: Modell-Status

    func checkModels() async {
        let tags = await client.models()
        chatOnline = tags.contains { $0.contains("qwen3.5") }
        visionOnline = tags.contains { $0.contains("vl") }
        coderOnline = tags.contains { $0.contains("coder") }
        status = tags.isEmpty ? "⚠️ Ollama offline (App läuft trotzdem)" : "Ollama: \(tags.count) Modelle"
    }

    // MARK: Knoten-Verwaltung

    func addNode(_ kind: NodeKind) {
        let offset = Double(nodes.count % 6) * 40
        let n = CanvasNode(kind: kind, x: 120 + offset, y: 90 + offset,
                           title: kind == .ai ? "Frage …" : "")
        nodes.append(n)
        selection = n.id
        autosaveSoon()
    }

    func deleteSelected() {
        guard let id = selection else { return }
        nodes.removeAll { $0.id == id }
        selection = nil
        autosaveSoon()
    }

    func node(_ id: UUID) -> CanvasNode? { nodes.first { $0.id == id } }

    private func update(_ id: UUID, _ mutate: (inout CanvasNode) -> Void) {
        guard let i = nodes.firstIndex(where: { $0.id == id }) else { return }
        mutate(&nodes[i])
    }

    // MARK: Gesten (Pan / Node-Drag / Zoom)

    func beginPan() { panBase = (panX, panY) }
    func panChanged(_ w: CGFloat, _ h: CGFloat) {
        guard let base = panBase else { return }
        panX = base.0 + Double(w); panY = base.1 + Double(h)
    }
    func endPan() { panBase = nil; autosaveSoon() }

    func dragNode(_ id: UUID, translation: CGSize) {
        if dragOrigin == nil, let n = node(id) { dragOrigin = (n.x, n.y) }
        guard let o = dragOrigin else { return }
        update(id) { $0.x = o.0 + Double(translation.width); $0.y = o.1 + Double(translation.height) }
    }
    func endDragNode() { dragOrigin = nil; autosaveSoon() }

    func zoomBy(_ factor: CGFloat) {
        zoom = min(4, max(0.25, zoom * Double(factor)))
    }

    // MARK: Skizze

    private var strokeOpen: Set<UUID> = []

    func isStrokeEnded(_ id: UUID) -> Bool { !strokeOpen.contains(id) }
    func markStrokeEnded(_ id: UUID) { strokeOpen.remove(id) }

    func startStroke(_ id: UUID, color: String) {
        strokeOpen.insert(id)
        update(id) { $0.strokes.append(Stroke(color: color, width: 3, points: [])) }
    }

    func addPoint(_ id: UUID, x: CGFloat, y: CGFloat) {
        update(id) {
            guard !$0.strokes.isEmpty else { return }
            $0.strokes[$0.strokes.count - 1].points.append([Double(x), Double(y)])
        }
    }

    // MARK: Text-/Titel-Bindings

    func updateText(_ id: UUID, _ t: String) {
        update(id) { $0.text = t }
        autosaveSoon()
    }

    func updateTitle(_ id: UUID, _ t: String) {
        update(id) { $0.title = t }
        autosaveSoon()
    }

    // MARK: KI (lokal über Ollama)

    /// AI-Node: title = Frage → text = lokale Antwort (qwen3.5).
    func runAI(_ id: UUID) {
        guard let n = node(id), !n.title.isEmpty else { return }
        busy = true; status = "denke lokal (qwen3.5) …"
        let prompt = n.title
        Task { @MainActor in
            defer { busy = false }
            do {
                let answer = try await client.chat(model: LocalModels.chat, messages: [
                    OllamaMessage(role: "user", content: prompt)
                ])
                update(id) { $0.text = answer }
                status = "Antwort da (\(answer.count) Zeichen)"
            } catch {
                status = "⚠️ Ollama-Fehler: \(error.localizedDescription)"
            }
        }
    }

    /// Bild-Node analysieren → Antwort als neuer AI-Knoten daneben.
    func analyzeImage(_ id: UUID) {
        guard let n = node(id), let b64 = n.imageB64 else { return }
        busy = true; status = "Vision läuft (qwen-vl) …"
        Task { @MainActor in
            defer { busy = false }
            do {
                let answer = try await client.vision(
                    prompt: "Beschreibe kurz auf Deutsch, was auf dem Bild zu sehen ist.",
                    imageBase64: b64)
                let ai = CanvasNode(kind: .ai, x: n.x + n.width + 24, y: n.y,
                                    title: "Bildanalyse", text: answer)
                nodes.append(ai); selection = ai.id
                status = "Bild analysiert"
            } catch {
                status = "⚠️ Vision-Fehler: \(error.localizedDescription)"
            }
        }
    }

    /// Prototyp-Node: title = Anforderung (+ optional Bild) → code.
    func generatePrototype(_ id: UUID) {
        guard let n = node(id) else { return }
        busy = true; status = "Prototyp-Generator (qwen2.5-coder) …"
        let prompt = n.title
        let b64 = n.imageB64
        Task { @MainActor in
            defer { busy = false }
            do {
                var sketchDesc = "\(n.strokes.count) Skizzenstriche"
                if let b64 {
                    sketchDesc = try await client.vision(
                        prompt: "Beschreibe die UI-Skizze in 2 Sätzen (Elemente + Layout).",
                        imageBase64: b64)
                }
                let code = try await PrototypeGenerator.generate(
                    sketchDescription: sketchDesc, userPrompt: prompt, client: client)
                update(id) { $0.code = code; $0.text = sketchDesc }
                status = "Prototyp erzeugt (\(code.count) Zeichen Code)"
            } catch {
                status = "⚠️ Generator-Fehler: \(error.localizedDescription)"
            }
        }
    }

    // MARK: Voice

    func handleVoice(_ transcript: String) {
        guard !transcript.isEmpty else { return }
        switch VoiceParser.parse(transcript) {
        case .addTextNode(let title):
            let n = CanvasNode(kind: .text, title: title ?? "Notiz", text: "")
            nodes.append(n); selection = n.id
            status = "🎤 Text-Knoten erstellt"
        case .addSketchNode:
            let n = CanvasNode(kind: .sketch, title: "Sprach-Skizze")
            nodes.append(n); selection = n.id
            status = "🎤 Skizze erstellt"
        case .deleteSelected:
            deleteSelected(); status = "🎤 gelöscht"
        case .ask(let q):
            let n = CanvasNode(kind: .ai, title: q.isEmpty ? transcript : q)
            nodes.append(n); selection = n.id
            runAI(n.id)
        }
        autosaveSoon()
    }

    // MARK: Persistenz

    private var autosaveTimer: Timer?
    func autosaveSoon() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            Task { @MainActor in self?.saveNow() }
        }
    }

    func saveNow() {
        var doc = CanvasDocument(name: docName, nodes: nodes,
                                 panX: panX, panY: panY, zoom: zoom)
        doc.updatedAt = Date()
        try? doc.save(to: CanvasDocument.autosaveURL())
    }

    func saveAs() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.directoryURL = CanvasDocument.defaultDirectory()
        panel.nameFieldStringValue = (docName.isEmpty ? "canvas" : docName) + ".json"
        guard panel.runModal() == .OK, let url = panel.url else { return }
        docName = url.deletingPathExtension().lastPathComponent
        var doc = CanvasDocument(name: docName, nodes: nodes,
                                 panX: panX, panY: panY, zoom: zoom)
        try? doc.save(to: url)
        status = "gespeichert: \(url.lastPathComponent)"
    }

    func open() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.directoryURL = CanvasDocument.defaultDirectory()
        guard panel.runModal() == .OK, let url = panel.url,
              let doc = try? CanvasDocument.load(from: url) else { return }
        nodes = doc.nodes; panX = doc.panX; panY = doc.panY; zoom = doc.zoom
        docName = doc.name; selection = nil
        status = "geladen: \(url.lastPathComponent)"
    }

    /// Bild per Datei-Dialog in einen neuen Bild-Knoten laden.
    func addImageNode() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        guard panel.runModal() == .OK, let url = panel.url,
              let data = try? Data(contentsOf: url) else { return }
        let n = CanvasNode(kind: .image, title: url.lastPathComponent,
                           imageB64: data.base64EncodedString())
        nodes.append(n); selection = n.id
        autosaveSoon()
    }
}
