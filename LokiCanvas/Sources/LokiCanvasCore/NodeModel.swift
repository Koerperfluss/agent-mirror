import Foundation

/// Knoten-Typ auf der Canvas.
public enum NodeKind: String, Codable {
    case sketch, text, image, ai, prototype
}

/// Ein Zeichenstrich (Punkte als [x,y]-Paare, node-lokal).
public struct Stroke: Codable, Equatable {
    public var color: String
    public var width: Double
    public var points: [[Double]]

    public init(color: String = "#22D3EE", width: Double = 3, points: [[Double]] = []) {
        self.color = color; self.width = width; self.points = points
    }
}

/// Ein Canvas-Knoten: Position/Größe + typspezifischer Inhalt.
public struct CanvasNode: Codable, Identifiable, Equatable {
    public var id: UUID
    public var kind: NodeKind
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double
    public var title: String
    public var text: String          // Text / Prompt / AI-Antwort
    public var imageB64: String?     // Bild (Base64) für image/prototype
    public var strokes: [Stroke]     // Skizze
    public var code: String?         // generierter Prototyp-Code
    public var createdAt: Date

    public init(id: UUID = UUID(), kind: NodeKind,
                x: Double = 80, y: Double = 80, width: Double = 260, height: Double = 200,
                title: String = "", text: String = "", imageB64: String? = nil,
                strokes: [Stroke] = [], code: String? = nil, createdAt: Date = Date()) {
        self.id = id; self.kind = kind; self.x = x; self.y = y
        self.width = width; self.height = height
        self.title = title; self.text = text; self.imageB64 = imageB64
        self.strokes = strokes; self.code = code; self.createdAt = createdAt
    }
}

/// Gesamtdokument: Knoten + Kamera (Pan/Zoom), JSON-persistiert.
public struct CanvasDocument: Codable, Equatable {
    public var name: String
    public var nodes: [CanvasNode]
    public var panX: Double
    public var panY: Double
    public var zoom: Double
    public var updatedAt: Date

    public init(name: String = "Unbenannt", nodes: [CanvasNode] = [],
                panX: Double = 0, panY: Double = 0, zoom: Double = 1, updatedAt: Date = Date()) {
        self.name = name; self.nodes = nodes
        self.panX = panX; self.panY = panY; self.zoom = zoom; self.updatedAt = updatedAt
    }

    /// Standardordner: ~/Documents/LokiCanvas
    public static func defaultDirectory() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("LokiCanvas", isDirectory: true)
    }

    public static func autosaveURL() -> URL {
        defaultDirectory().appendingPathComponent("autosave.json")
    }

    /// Speichert JSON (atomic); legt den Ordner bei Bedarf an.
    public func save(to url: URL) throws {
        let dir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let enc = JSONEncoder(); enc.outputFormatting = [.prettyPrinted, .sortedKeys]; enc.dateEncodingStrategy = .iso8601
        try enc.encode(self).write(to: url, options: [.atomic])
    }

    public func autosave() { try? save(to: Self.autosaveURL()) }

    public static func load(from url: URL) throws -> CanvasDocument {
        let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601
        return try dec.decode(CanvasDocument.self, from: Data(contentsOf: url))
    }

    public static func loadAutosave() -> CanvasDocument? {
        (try? load(from: autosaveURL())) ?? nil
    }

    /// Listet gespeicherte Dokumente (json) im Standardordner.
    public static func listDocuments() -> [URL] {
        let dir = defaultDirectory()
        let files = (try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)) ?? []
        return files.filter { $0.pathExtension == "json" }.sorted { $0.lastPathComponent < $1.lastPathComponent }
    }
}
