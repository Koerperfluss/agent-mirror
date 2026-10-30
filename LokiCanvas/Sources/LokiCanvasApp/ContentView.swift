import SwiftUI
import AppKit
import LokiCanvasCore

// MARK: - Zentrales Modell (Zustand, Persistenz, KI)

@MainActor
final class CanvasModel: ObservableObject {
    @Published var doc: CanvasDocument
    @Published var selection: UUID?
    @Published var status = "bereit"
    @Published var chatOnline = false
    @Published var visionOnline = false
    @Published var coderOnline = false
    @Published var ollamaOffline = false
    @Published var loadingNode: UUID?

    let client = OllamaClient()

    private var autosaveTimer: Timer?

    init() {
        if let auto = CanvasDocument.loadAutosave() {
            doc = auto
            status = "Autosave geladen (\(auto.nodes.count) Knoten)"
        } else {
            doc = CanvasDocument()
        }
    }

    var nodes: [CanvasNode] { doc.nodes }
    var zoom: Double { doc.zoom }

    func node(_ id: UUID) -> CanvasNode? { doc.nodes.first { $0.id == id } }

    func mutate(_ id: UUID, _ change: (inout CanvasNode) -> Void) {
        guard let i = doc.nodes.firstIndex(where: { $0.id == id }) else { return }
        change(&doc.nodes[i])
        autosaveSoon()
    }

    // MARK: Knoten

    func addNode(_ kind: NodeKind, title: String = "", text: String = "") {
        let offset = Double(doc.nodes.count % 6) * 40
        let n = CanvasNode(kind: kind, x: 120 + offset, y: 90 + offset, title: title, text: text)
        doc.nodes.append(n)
        selection = n.id
        autosaveSoon()
    }

    func deleteSelected() {
        guard let id = selection else { return }
        doc.nodes.removeAll { $0.id == id }
        selection = nil
        autosaveSoon()
    }

    // MARK: Kamera

    func pan(byX dx: Double, dy: Double) {
        doc.panX += dx; doc.panY += dy
    }

    func setPan(x: Double, y: Double) {
        doc.panX = x; doc.panY = y
    }

    func zoomBy(_ factor: Double) {
        doc.zoom = min(4.0, max(0.25, doc.zoom * factor))
    }

    func dragNode(_ id: UUID, translation: CGSize, zoom: Double) {
        mutate(id) {
            $0.x += translation.width / zoom
            $0.y += translation.height / zoom
        }
    }

    // MARK: Persistenz

    func autosaveSoon() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            Task { @MainActor in self?.doc.autosave() }
        }
    }

    // MARK: Modell-Status (beim Start; kein Crash wenn Ollama aus)

    func checkModels() async {
        let tags = await client.models()
        ollamaOffline = tags.isEmpty
        chatOnline = tags.contains { $0.contains("qwen3.5") && !$0.contains("vl") }
        visionOnline = tags.contains { $0.contains("vl") }
        coderOnline = tags.contains { $0.contains("coder") }
        status = tags.isEmpty
            ? "Ollama offline — Knoten/Text/Skizze funktionieren trotzdem, KI nicht."
            : "Ollama: \(tags.count) Modelle gefunden."
    }

    // MARK: KI-Aufrufe (Antwort in den Node, Fehler als Text statt Crash)

    func runAI(_ id: UUID, prompt: String? = nil, model: String = LocalModels.chat) {
        guard let n = node(id) else { return }
        let p = prompt ?? n.text
        guard !p.isEmpty else {
            status = "Kein Prompt angegeben."
            return
        }
        loadingNode = id
        status = "Denke lokal (\(model)) …"
        mutate(id) { $0.text = "" }
        Task { @MainActor in
            defer { loadingNode = nil }
            do {
                let answer = try await client.chat(model: model, messages: [
                    OllamaMessage(role: "user", content: p)
                ])
                mutate(id) { $0.text = answer }
                status = "Antwort da (\(answer.count) Zeichen)."
            } catch {
                mutate(id) { $0.text = "KI-Fehler: \(error.localizedDescription)" }
                status = "KI-Fehler: \(error.localizedDescription)"
            }
        }
    }

    func generatePrototype(_ id: UUID, prompt: String) {
        guard node(id) != nil else { return }
        loadingNode = id
        status = "Prototyp-Generator (\(LocalModels.coder)) …"
        Task { @MainActor in
            defer { loadingNode = nil }
            do {
                let code = try await PrototypeGenerator.generate(
                    sketchDescription: "", userPrompt: prompt, client: client)
                mutate(id) { $0.code = code }
                status = "Prototyp erzeugt (\(code.count) Zeichen Code)."
            } catch {
                mutate(id) { $0.code = "Generator-Fehler: \(error.localizedDescription)" }
                status = "Generator-Fehler: \(error.localizedDescription)"
            }
        }
    }

    // MARK: Bild in Node laden (FileImporter/Drop)

    func setImage(_ id: UUID, data: Data) {
        mutate(id) { $0.imageB64 = data.base64EncodedString() }
    }

    func addImageNode(data: Data, title: String) {
        addNode(.image, title: title)
        if let id = selection { setImage(id, data: data) }
    }
}

// MARK: - Haupt-View

struct ContentView: View {
    @EnvironmentObject var model: CanvasModel
    @StateObject private var voice = VoiceAgent(locale: Locale(identifier: "de-DE"))
    @State private var panOrigin: CGPoint?
    @State private var showImporter = false

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            HStack(spacing: 0) {
                canvasArea
                InspectorView()
                    .environmentObject(voice)
                    .frame(width: 280)
            }
            statusBar
        }
        .background(Theme.bg)
        .onAppear {
            voice.onCommand = { handleVoice($0) }
            Task { await model.checkModels() }
        }
        .onDisappear { voice.stop() }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.image]) { result in
            if case .success(let url) = result,
               let data = try? Data(contentsOf: url) {
                model.addImageNode(data: data, title: url.lastPathComponent)
            } else if case .failure(let err) = result {
                model.status = "Bild-Fehler: \(err.localizedDescription)"
            }
        }
    }

    // MARK: Toolbar

    private var toolbar: some View {
        HStack(spacing: 8) {
            Text("LokiCanvas").font(.headline).foregroundStyle(Theme.acc)
            Button("+ Text") { model.addNode(.text) }
            Button("+ Skizze") { model.addNode(.sketch) }
            Button("+ Bild") { showImporter = true }
            Button("+ KI") { model.addNode(.ai) }
            Button("+ Prototyp") { model.addNode(.prototype) }
            Divider().frame(height: 18)
            Button {
                if voice.isListening { voice.stop() } else { voice.start() }
            } label: {
                Label(voice.isListening ? "Stop" : "Sprache",
                      systemImage: voice.isListening ? "stop.circle.fill" : "mic.fill")
            }
            .foregroundStyle(voice.isListening ? Theme.rd : Theme.gr)
            if voice.isListening && !voice.transcript.isEmpty {
                Text("„\(voice.transcript.prefix(40))“")
                    .font(.caption).foregroundStyle(Theme.muted).lineLimit(1)
            }
            Spacer()
            Text("Zoom \(Int(model.zoom * 100)) %")
                .font(.caption).foregroundStyle(Theme.muted)
        }
        .buttonStyle(.bordered)
        .padding(10)
        .background(Theme.surface)
    }

    // MARK: Canvas

    private var canvasArea: some View {
        ZStack(alignment: .topLeading) {
            Theme.bg
                .contentShape(Rectangle())
                .gesture(panGesture)
            ForEach(model.nodes) { node in
                NodeView(node: node, selected: model.selection == node.id)
                    .offset(x: node.x, y: node.y)
                    .onTapGesture { model.selection = node.id }
            }
        }
        .clipped()
        .scaleEffect(model.zoom, anchor: .topLeading)
        .offset(x: model.doc.panX, y: model.doc.panY)
        .gesture(MagnificationGesture().onChanged { model.zoomBy($0) })
        .onAppear { installScrollMonitor() }
    }

    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { g in
                if let o = panOrigin {
                    model.setPan(x: o.x + g.translation.width, y: o.y + g.translation.height)
                } else {
                    panOrigin = CGPoint(x: model.doc.panX, y: model.doc.panY)
                }
            }
            .onEnded { _ in
                panOrigin = nil
                model.autosaveSoon()
            }
    }

    /// Trackpad-Scroll = Pan, Cmd+Scroll = Zoom (NSEvent-Monitor, beim Verlassen entfernt).
    @State private var scrollMonitor: Any?
    private func installScrollMonitor() {
        guard scrollMonitor == nil else { return }
        scrollMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { ev in
            if ev.modifierFlags.contains(.command) {
                model.zoomBy(1.0 - ev.scrollingDeltaY * 0.01)
            } else {
                model.pan(byX: ev.scrollingDeltaX, dy: ev.scrollingDeltaY)
            }
            return nil
        }
    }

    // MARK: Statusleiste (Modell-Check)

    private var statusBar: some View {
        HStack(spacing: 10) {
            dot(model.chatOnline, "Chat (\(LocalModels.chat))")
            dot(model.visionOnline, "Vision (\(LocalModels.vision))")
            dot(model.coderOnline, "Coder (\(LocalModels.coder))")
            if model.ollamaOffline {
                Text("Ollama ist nicht erreichbar (localhost:11434) — App läuft ohne KI weiter.")
                    .font(.caption).foregroundStyle(Theme.rd)
            }
            if model.loadingNode != nil {
                ProgressView().controlSize(.small)
            }
            Text(model.status).font(.caption).foregroundStyle(Theme.muted).lineLimit(1)
            Spacer()
            Text("\(model.nodes.count) Knoten").font(.caption).foregroundStyle(Theme.muted)
        }
        .padding(8)
        .background(Theme.surface)
    }

    private func dot(_ ok: Bool, _ label: String) -> some View {
        HStack(spacing: 3) {
            Circle().fill(ok ? Theme.gr : Theme.rd).frame(width: 7, height: 7)
            Text(label).font(.caption2).foregroundStyle(Theme.muted)
        }
    }

    // MARK: Sprach-Befehle (VoiceParser)

    private func handleVoice(_ command: VoiceCommand) {
        switch command {
        case .addTextNode(let title):
            model.addNode(.text, title: title ?? "Notiz")
            model.status = "Sprache: Text-Knoten erstellt."
        case .addSketchNode:
            model.addNode(.sketch, title: "Sprach-Skizze")
            model.status = "Sprache: Skizze erstellt."
        case .deleteSelected:
            model.deleteSelected()
            model.status = "Sprache: Auswahl gelöscht."
        case .ask(let question):
            model.addNode(.ai, title: question.isEmpty ? "KI-Frage" : question)
            if let id = model.selection {
                model.runAI(id, prompt: question.isEmpty ? "Antworte kurz auf Deutsch." : question)
            }
        }
    }
}
