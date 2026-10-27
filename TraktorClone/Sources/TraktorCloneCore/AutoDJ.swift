import Foundation

/// Auto-DJ: rotierende Queue — spielt Tracks der Bibliothek nacheinander
/// und liefert beim Track-Ende den nächsten Eintrag.
public struct AutoDJ {
    public var enabled = false
    public private(set) var index = 0

    public init() {}

    /// Nächsten Track liefern (round-robin). nil, wenn aus oder Queue leer.
    public mutating func next(from queue: [NMLTrack]) -> NMLTrack? {
        guard enabled, !queue.isEmpty else { return nil }
        let t = queue[index % queue.count]
        index = (index + 1) % queue.count
        return t
    }

    public mutating func reset() { index = 0 }
}
