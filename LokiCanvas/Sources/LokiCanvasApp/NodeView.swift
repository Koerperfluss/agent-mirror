import SwiftUI
import AppKit
import UniformTypeIdentifiers
import LokiCanvasCore

/// Ein Knoten auf der Canvas: Rahmen, Verschieben, Inhalt je NodeKind.
/// UI-Zustand makrofrei (CLT ohne SwiftUIMacros — @Published statt @State).
@MainActor
final class NodeUIState: ObservableObject {
    @Published var dragStart: CGPoint?
    @Published var strokeColor = "#22D3EE"
    @Published var eraser = false
    @Published var showImagePicker = false
    @Published var strokeFinished = true // true = nächster onChanged beginnt neuen Stroke
}

struct NodeView: View {
    @EnvironmentObject var model: CanvasModel
    let node: CanvasNode
    let selected: Bool

    @StateObject private var ui = NodeUIState()

    private var kindLabel: String {
        switch node.kind {
        case .text: "Text"; case .sketch: "Skizze"; case .image: "Bild"
        case .ai: "KI"; case .prototype: "Prototyp"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            header
            content
        }
        .padding(8)
        .frame(width: node.width, height: node.height, alignment: .topLeading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Theme.surface))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Theme.acc : Theme.bd, lineWidth: selected ? 2 : 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
        .gesture(moveGesture.simultaneously(with: TapGesture().onEnded {
            model.selection = node.id
        }))
        .fileImporter(isPresented: $ui.showImagePicker, allowedContentTypes: [.image]) { result in
            if case .success(let url) = result,
               let data = try? Data(contentsOf: url) {
                model.setImage(node.id, data: data)
            }
        }
        .dropDestination(for: Data.self) { items, _ in
            guard let data = items.first else { return false }
            model.setImage(node.id, data: data)
            return true
        } isTargeted: { _ in }
    }

    private var header: some View {
        HStack(spacing: 4) {
            Text(kindLabel).font(.caption2).foregroundStyle(Theme.acc)
            TextField("Titel", text: Binding(
                get: { node.title },
                set: { newValue in model.mutate(node.id) { $0.title = newValue } }))
                .textFieldStyle(.plain)
                .font(.caption)
                .foregroundStyle(Theme.soft)
        }
    }

    private var moveGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { g in
                // Node kann während des Drags gelöscht werden (z. B. Sprach-Befehl)
                // → gar nicht schreiben statt auf falschen Index zu schreiben.
                guard model.node(node.id) != nil else { return }
                if let start = ui.dragStart {
                    model.doc.nodes[nodeIndex].x = start.x + Double(g.translation.width) / model.zoom
                    model.doc.nodes[nodeIndex].y = start.y + Double(g.translation.height) / model.zoom
                } else {
                    ui.dragStart = CGPoint(x: node.x, y: node.y)
                }
            }
            .onEnded { _ in
                ui.dragStart = nil
                model.autosaveSoon()
            }
    }

    private var nodeIndex: Int {
        model.doc.nodes.firstIndex { $0.id == node.id } ?? 0
    }

    @ViewBuilder
    private var content: some View {
        switch node.kind {
        case .text: textBody
        case .sketch: sketchBody
        case .image: imageBody
        case .ai: aiBody
        case .prototype: prototypeBody
        }
    }

    // MARK: Text

    private var textBody: some View {
        TextEditor(text: Binding(
            get: { node.text },
            set: { newValue in model.mutate(node.id) { $0.text = newValue } }))
            .font(.callout)
            .scrollContentBackground(.hidden)
            .foregroundStyle(Theme.ink)
            .background(Theme.bg.opacity(0.4))
    }

    // MARK: Skizze (freies Zeichnen, 3 Farben + Radierer)

    private var sketchBody: some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                colorButton("#22D3EE")
                colorButton("#FBBF24")
                colorButton("#F87171")
                Button(ui.eraser ? "Stift" : "Radierer") { ui.eraser.toggle() }
                    .font(.caption2).buttonStyle(.bordered)
                Button("Leeren") {
                    model.mutate(node.id) { $0.strokes = [] }
                }
                .font(.caption2).buttonStyle(.bordered)
            }
            drawCanvas
        }
    }

    private func colorButton(_ hex: String) -> some View {
        Button {
            ui.strokeColor = hex
            ui.eraser = false
        } label: {
            Circle().fill(Color(hexString: hex) ?? Theme.acc).frame(width: 14, height: 14)
                .overlay(Circle().stroke(ui.strokeColor == hex && !ui.eraser ? Theme.ink : Theme.bd, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }

    private var drawCanvas: some View {
        Canvas { ctx, size in
            for stroke in node.strokes {
                guard stroke.points.count > 1 else { continue }
                var path = Path()
                let p0 = stroke.points[0]
                path.move(to: CGPoint(x: p0[0], y: p0[1]))
                for p in stroke.points.dropFirst() {
                    path.addLine(to: CGPoint(x: p[0], y: p[1]))
                }
                ctx.stroke(path, with: .color(Color(hexString: stroke.color) ?? Theme.acc),
                           lineWidth: stroke.width)
            }
            _ = size
        }
        .background(RoundedRectangle(cornerRadius: 6).fill(Theme.bg.opacity(0.6)))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { g in
                    let p = [Double(g.location.x), Double(g.location.y)]
                    if ui.eraser {
                        // Radierer: Punkt-Striche nahe der Position entfernen
                        model.mutate(node.id) { n in
                            n.strokes.removeAll { s in
                                s.points.contains { hypot($0[0] - p[0], $0[1] - p[1]) < 14 }
                            }
                        }
                    } else if ui.strokeFinished || node.strokes.isEmpty {
                        // Neuer Strich (nach Drag-Ende oder bei leerer Skizze)
                        ui.strokeFinished = false
                        model.mutate(node.id) { n in
                            n.strokes.append(Stroke(color: ui.strokeColor, points: [p]))
                        }
                    } else {
                        model.mutate(node.id) { n in
                            guard !n.strokes.isEmpty else { return }
                            n.strokes[n.strokes.count - 1].points.append(p)
                        }
                    }
                }
                .onEnded { _ in
                    ui.strokeFinished = true
                    model.autosaveSoon()
                }
        )
    }

    // MARK: Bild

    private var imageBody: some View {
        VStack(spacing: 4) {
            if let b64 = node.imageB64, let data = Data(base64Encoded: b64), let img = NSImage(data: data) {
                Image(nsImage: img).resizable().aspectRatio(contentMode: .fit)
            } else {
                Text("Bild hierher ziehen oder Button.")
                    .font(.caption).foregroundStyle(Theme.muted)
                Button("Bild wählen …") { ui.showImagePicker = true }
                    .font(.caption).buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: KI

    private var aiBody: some View {
        VStack(alignment: .leading, spacing: 4) {
            ScrollView {
                Text(node.text.isEmpty ? "Prompt eingeben (Inspector) und senden." : node.text)
                    .font(.callout).foregroundStyle(node.text.isEmpty ? Theme.muted : Theme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
            if model.loadingNode == node.id {
                ProgressView().controlSize(.small)
            }
        }
    }

    // MARK: Prototyp

    private var prototypeBody: some View {
        ScrollView {
            Text(node.code ?? "Prompt im Inspector → Code erscheint hier.")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(Theme.acc)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
        }
    }
}

// Hex-Farb-Helper (klein, lokal)
extension Color {
    init?(hexString: String) {
        var s = hexString.trimmingCharacters(in: .whitespaces)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6, let v = UInt64(s, radix: 16) else { return nil }
        self.init(red: Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >> 8) & 0xFF) / 255,
                  blue: Double(v & 0xFF) / 255)
    }
}
