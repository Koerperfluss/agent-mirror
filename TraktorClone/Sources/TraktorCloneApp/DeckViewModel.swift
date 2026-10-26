import SwiftUI
import TraktorCloneCore
import AVFoundation
import UniformTypeIdentifiers

/// Ein Deck: Logik (DeckState) + Audio (AudioEngine) + Waveform + FX.
@MainActor
final class DeckViewModel: ObservableObject {
    let index: Int                                    // 0 = A, 1 = B
    @Published var state = DeckState()
    @Published var pitch: Double = 0
    @Published var fader: Double = 1
    @Published var title: String = "— kein Track —"
    @Published var playhead: TimeInterval = 0
    @Published var waveform: [Float] = []             // Slice 3: Peak-Buckets
    @Published var bpm: Double?                       // aus Library oder Setzung
    @Published var delayWet: Double = 0
    @Published var reverbWet: Double = 0
    @Published var filterOn = false
    @Published var filterHighPass = false
    private let engine: AudioEngine
    private var timer: Timer?
    private var loadedURL: URL?

    init(index: Int, engine: AudioEngine) {
        self.index = index
        self.engine = engine
        startPlayheadTimer()
    }

    var duration: TimeInterval { state.duration }

    func load() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.audio, UTType(filenameExtension: "mp4") ?? .audio]
        panel.canChooseDirectories = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        load(url: url)
    }

    func load(url: URL) {
        do {
            let dur = try engine.load(url: url, deck: index)
            state.load(title: url.deletingPathExtension().lastPathComponent, duration: dur)
            title = state.trackTitle
            loadedURL = url
            // Waveform im Hintergrund extrahieren (Slice 3)
            waveform = []
            let extractURL = url
            Task.detached(priority: .userInitiated) { [weak self] in
                let peaks = (try? WaveformExtractor.extract(url: extractURL, buckets: 400)) ?? []
                await MainActor.run { self?.waveform = peaks }
            }
        } catch {
            title = "⚠️ Laden fehlgeschlagen"
        }
    }

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

    /// Slice 3: Seek über Waveform-Klick (Fraction 0...1).
    func seekFraction(_ f: Double) {
        guard duration > 0 else { return }
        let t = min(max(f, 0), 1) * duration
        state.seek(to: t, now: clock)
        engine.seek(deck: index, to: t)
    }

    /// Slice 4: FX-Parameter an die Engine-Kette durchreichen.
    func applyDelay(_ wetPct: Double) {
        delayWet = wetPct
        engine.fx[index]?.setDelay(timeMs: 400, feedbackPct: 35, wetPct: wetPct)
    }

    func applyReverb(_ wetPct: Double) {
        reverbWet = wetPct
        engine.fx[index]?.setReverb(wetPct: wetPct, preset: true)
    }

    func applyFilter(on: Bool, highPass: Bool) {
        filterOn = on
        filterHighPass = highPass
        if on {
            engine.fx[index]?.setFilter(cutoffHz: highPass ? 120 : 8000,
                                        highPass: highPass, enabled: true)
        } else {
            engine.fx[index]?.setFilter(cutoffHz: highPass ? 20 : 20000,
                                        highPass: highPass, enabled: false)
        }
    }

    func applyMixerVolume(_ gain: Double) {
        engine.setVolume(deck: index, gain: gain)
    }

    var fileURL: URL? { loadedURL }

    private var clock: TimeInterval { ProcessInfo.processInfo.systemUptime }

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
