import SwiftUI
import TraktorCloneCore
import AVFoundation
import UniformTypeIdentifiers

/// Ein Deck: Logik (DeckState) + Audio (AudioEngine) gekoppelt.
@MainActor
final class DeckViewModel: ObservableObject {
    let index: Int                                    // 0 = A, 1 = B
    @Published var state = DeckState()
    @Published var pitch: Double = 0
    @Published var fader: Double = 1
    @Published var title: String = "— kein Track —"
    @Published var playhead: TimeInterval = 0
    private let engine: AudioEngine
    private var timer: Timer?

    init(index: Int, engine: AudioEngine) {
        self.index = index
        self.engine = engine
        startPlayheadTimer()
    }

    func load() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.audio]
        panel.canChooseDirectories = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            let dur = try engine.load(url: url, deck: index)
            state.load(title: url.deletingPathExtension().lastPathComponent, duration: dur)
            title = state.trackTitle
        } catch {
            title = "⚠️ Laden fehlgeschlagen"
        }
    }

    private var clock: TimeInterval { ProcessInfo.processInfo.systemUptime }

    func togglePlay() {
        if state.isPlaying {
            state.pause(now: clock); engine.stop(deck: index)
        } else {
            state.play(now: clock)
            engine.setPitchFactor(deck: index, factor: state.rate)
            engine.play(deck: index)
        }
    }

    func cue() { state.cue(now: clock); engine.stop(deck: index) }

    func hotcue(_ i: Int) {
        if state.hotcues[i] != nil { state.jumpHotcue(i, now: clock) } else { state.setHotcue(i) }
    }

    func setPitch(_ p: Double) {
        state.setPitch(p, now: clock)
        pitch = state.pitch
        engine.setPitchFactor(deck: index, factor: state.rate)
    }

    func applyMixerVolume(_ gain: Double) {
        engine.setVolume(deck: index, gain: gain)
    }

    private func startPlayheadTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.state.isPlaying {
                    self.playhead = self.state.currentPlayhead(now: ProcessInfo.processInfo.systemUptime)
                } else {
                    self.playhead = self.state.position
                }
            }
        }
    }
}
