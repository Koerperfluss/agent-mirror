import Foundation

/// JSON-stabile Repräsentation eines gelernten Mappings.
public struct LearnedMapping: Codable, Equatable {
    public let channel: Int
    public let isCC: Bool
    public let control: Int
    public let action: String

    public init(channel: Int, isCC: Bool, control: Int, action: String) {
        self.channel = channel; self.isCC = isCC; self.control = control; self.action = action
    }
}

public extension MIDIAssignment {
    var learned: LearnedMapping {
        LearnedMapping(channel: Int(channel), isCC: isCC, control: Int(control), action: action.rawValue)
    }
}

public extension LearnedMapping {
    var assignment: MIDIAssignment? {
        guard let a = DeckAction(rawValue: action),
              (0...15).contains(channel), control >= 0, control <= 127
        else { return nil }
        return MIDIAssignment(channel: UInt8(channel), isCC: isCC, control: UInt8(control), action: a)
    }
}

/// Persistenz der gelernten Mappings als JSON.
public enum MappingStore {
    public static func save(_ mappings: [LearnedMapping], to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(mappings)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        try data.write(to: url, options: [.atomic])
    }

    public static func load(from url: URL) throws -> [LearnedMapping] {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([LearnedMapping].self, from: data)
    }

    public static func loadOrDefault(from url: URL) -> [LearnedMapping] {
        (try? load(from: url)) ?? []
    }

    public static func defaultURL() -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("TraktorClone/mappings.json")
    }
}
