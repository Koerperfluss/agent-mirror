import Foundation

/// Flux Mode: Deck merkt sich beim Aktivieren die Track-Position (Anchor).
/// Scrub-Bewegungen verändern nur eine virtuelle Position; der Track läuft
/// unberührt weiter. Beim Deaktivieren springt das Deck dorthin zurück, wo es
/// ohnehin wäre (Traktor-Verhalten).
///
/// Zeitbasis ist die DECK-Position (`currentPlayhead`), nicht die Wanduhr —
/// damit sind Pause, Loop-Wrap und Pitch automatisch korrekt (Reviewer-Fix P2-1).
public struct FluxMode: Equatable, Sendable {

    /// Flux aktiv?
    public private(set) var active = false

    /// Track-Position (Sekunden) beim Aktivieren.
    public private(set) var anchorPosition: TimeInterval = 0

    /// Deck-Position beim Aktivieren (Anchor-Uhr läuft auf der Track-Zeitachse).
    private var anchorDeckTime: TimeInterval = 0

    /// Summe der Scrub-Bewegungen (Sekunden).
    private var scrubDelta: TimeInterval = 0

    public init() {}

    /// Flux aktivieren: Anchor-Position und aktuellen Deck-Stand merken.
    public mutating func engage(position: TimeInterval, deckTime: TimeInterval) {
        anchorPosition = position
        anchorDeckTime = deckTime
        scrubDelta = 0
        active = true
    }

    /// Scrub-Bewegung anwenden (Sekunden, positiv/vorwärts).
    public mutating func scrub(delta: TimeInterval) {
        guard active else { return }
        scrubDelta += delta
    }

    /// Virtuelle Position (was man sieht/hört): Anchor + Fortschritt des Decks + Scrub.
    public func virtualPosition(deckTime: TimeInterval) -> TimeInterval {
        guard active else { return anchorPosition }
        return anchorPosition + (deckTime - anchorDeckTime) + scrubDelta
    }

    /// Flux beenden: Rückkehr-Ziel = wo der Track wäre, wenn nie unterbrochen
    /// (max(0, …)), scrubDelta wird verworfen. Setzt `active = false`.
    @discardableResult
    public mutating func disengage(deckTime: TimeInterval) -> TimeInterval {
        let target = max(0, anchorPosition + (deckTime - anchorDeckTime))
        active = false
        scrubDelta = 0
        anchorPosition = target
        return target
    }
}
