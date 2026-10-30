import SwiftUI
import LokiCanvasCore

// MARK: - Inspector (rechte Seitenleiste)

/// UI-Zustand makrofrei (CLT ohne SwiftUIMacros-Plugin — @Published statt @State).
@MainActor
final class InspectorUIState: ObservableObject {
    @Published var prompt = ""
    @Published var visionPrompt = ""
    @Published var selectedModel = LocalModels.chat
}

struct InspectorView: View {
    @EnvironmentObject var model: CanvasModel
    @EnvironmentObject var voice: VoiceAgent
    @StateObject private var ui = InspectorUIState()

    var body: some View {
        Group {
            if let id = model.selection, let node = model.node(id) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Inspector · \(node.kind.rawValue)").font(.headline).foregroundStyle(Theme.acc)

                    if node.kind == .ai || node.kind == .prototype {
                        nodeActions(node)
                    } else if node.kind == .image || node.kind == .sketch {
                        visionSection(node)
                    } else {
                        Text("Keine Aktionen für diesen Typ — direkt im Knoten bearbeiten.")
                            .font(.caption).foregroundStyle(Theme.muted)
                    }

                    voiceSection

                    Spacer()

                    Button("Auswahl löschen") {
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
        TextEditor(text: $ui.prompt)
            .font(.callout)
            .scrollContentBackground(.hidden)
            .frame(height: 90)
            .background(Theme.bg.opacity(0.5))

        if node.kind == .ai {
            Picker("Modell", selection: $ui.selectedModel) {
                ForEach(availableModels, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .font(.caption)

            Button("Senden") {
                model.runAI(node.id, prompt: ui.prompt.isEmpty ? node.text : ui.prompt,
                            model: ui.selectedModel)
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
                model.generatePrototype(node.id, prompt: ui.prompt.isEmpty ? node.title : ui.prompt)
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

    // MARK: Bild-Analyse (Vision) für Bild-/Skizzen-Nodes

    @ViewBuilder
    private func visionSection(_ node: CanvasNode) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Bild-Analyse (Vision)").font(.caption).foregroundStyle(Theme.muted)
            TextEditor(text: $ui.visionPrompt)
                .font(.callout)
                .scrollContentBackground(.hidden)
                .frame(height: 60)
                .background(Theme.bg.opacity(0.5))
            Button("Analysieren → KI-Node") {
                model.runVision(fromImageNodeId: node.id, prompt: ui.visionPrompt)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.acc)
            .disabled(model.loadingNode != nil || model.busy)
            if model.loadingNode != nil {
                HStack(spacing: 6) {
                    ProgressView().controlSize(.small)
                    Text("Lokales Modell arbeitet …").font(.caption).foregroundStyle(Theme.muted)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.bg.opacity(0.4)))
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
