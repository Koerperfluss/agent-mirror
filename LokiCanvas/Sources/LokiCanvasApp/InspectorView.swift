import SwiftUI
import LokiCanvasCore

// MARK: - VoiceAgent (Platzhalter mit GENAU dem B2-Interface)
//
// B2 liefert die echte Implementierung (Spracherkennung, de-DE). Bis dahin
// läuft diese lokale Variante: start()/stop() toggeln nur den Zustand,
// es wird nichts erkannt — die UI bleibt bedienbar, kein Crash.
// Beim Eintreffen der Core-Implementierung diesen Block entfernen.

final class VoiceAgent: ObservableObject {
    @Published var isListening: Bool = false
    @Published var transcript: String = ""
    var onCommand: ((VoiceCommand) -> Void)?
    var availabilityText: String

    init(locale: Locale = Locale(identifier: "de-DE")) {
        availabilityText = "Spracherkennung: Warten auf B2-Modul (\(locale.identifier))."
    }

    func start() {
        isListening = true
        transcript = ""
    }

    func stop() {
        isListening = false
    }
}

// MARK: - Inspector (rechte Seitenleiste)

struct InspectorView: View {
    @EnvironmentObject var model: CanvasModel
    @EnvironmentObject var voice: VoiceAgent
    @State private var prompt = ""
    @State private var selectedModel = LocalModels.chat

    var body: some View {
        Group {
            if let id = model.selection, let node = model.node(id) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Inspector · \(node.kind.rawValue)").font(.headline).foregroundStyle(Theme.acc)

                    if node.kind == .ai || node.kind == .prototype {
                        nodeActions(node)
                    } else {
                        Text("Keine Aktionen für diesen Typ — direkt im Knoten bearbeiten.")
                            .font(.caption).foregroundStyle(Theme.muted)
                    }

                    voiceSection

                    Spacer()

                    Button("Knoten löschen (Entf)") {
                        model.deleteSelected()
                    }
                    .tint(Theme.rd)
                }
                .padding(12)
                .background(Theme.surface)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inspector").font(.headline).foregroundStyle(Theme.acc)
                    Text("Kein Knoten ausgewählt.").font(.caption).foregroundStyle(Theme.muted)
                    voiceSection
                    Spacer()
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Theme.surface)
            }
        }
    }

    // MARK: KI/Prototyp-Aktionen

    @ViewBuilder
    private func nodeActions(_ node: CanvasNode) -> some View {
        Text("Prompt").font(.caption).foregroundStyle(Theme.muted)
        TextEditor(text: $prompt)
            .font(.callout)
            .scrollContentBackground(.hidden)
            .frame(height: 90)
            .background(Theme.bg.opacity(0.5))

        if node.kind == .ai {
            Picker("Modell", selection: $selectedModel) {
                ForEach(availableModels, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .font(.caption)

            Button("Senden") {
                model.runAI(node.id, prompt: prompt.isEmpty ? node.text : prompt,
                            model: selectedModel)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.acc)
            .disabled(model.loadingNode != nil)

            ScrollView {
                Text(node.text.isEmpty ? "Antwort erscheint hier." : node.text)
                    .font(.callout)
                    .foregroundStyle(node.text.isEmpty ? Theme.muted : Theme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        } else {
            Button("Prototyp generieren") {
                model.generatePrototype(node.id, prompt: prompt.isEmpty ? node.title : prompt)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.acc)
            .disabled(model.loadingNode != nil)

            ScrollView {
                Text(node.code ?? "Code erscheint hier.")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(Theme.acc)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        }

        if model.loadingNode == node.id {
            HStack(spacing: 6) {
                ProgressView().controlSize(.small)
                Text("Lokales Modell arbeitet …").font(.caption).foregroundStyle(Theme.muted)
            }
        }
    }

    private var availableModels: [String] {
        var m = [LocalModels.chat, LocalModels.vision, LocalModels.coder]
        m.removeDuplicates()
        return m
    }

    // MARK: Sprache

    private var voiceSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sprache").font(.caption).foregroundStyle(Theme.muted)
            Button {
                if voice.isListening { voice.stop() } else { voice.start() }
            } label: {
                Label(voice.isListening ? "Aufnahme stoppen" : "Aufnahme starten",
                      systemImage: voice.isListening ? "stop.circle.fill" : "mic.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(voice.isListening ? Theme.rd : Theme.rd.opacity(0.8))

            Text(voice.isListening ? "Hört zu …" : voice.availabilityText)
                .font(.caption2).foregroundStyle(Theme.muted)

            if !voice.transcript.isEmpty {
                Text("Transcript: „\(voice.transcript)“")
                    .font(.caption).foregroundStyle(Theme.soft)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.bg.opacity(0.4)))
    }
}

private extension Array where Element == String {
    mutating func removeDuplicates() {
        var seen: Set<String> = []
        self = filter { seen.insert($0).inserted }
    }
}
