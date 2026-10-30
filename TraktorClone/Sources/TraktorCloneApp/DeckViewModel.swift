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
    @Published var beatPhase: Double = 0              // Slice 8: 0...1 im Beat (LED)
    @Published var zoom = 1                           // Slice 8: Waveform-Zoom 1/2/4
    @Published var level: Double = 0                  // Slice 8: VU-Pegel 0...1
    @Published var isStem = false                     // Slice 8: Stem-Deck (.stem.mp4)?
    @Published var stemGains: [Double] = [1, 1, 1, 1, 1]  // Mix + 4 Stems
    @Published var loopBeats: Int? = nil              // aktiver Beat-Loop (1/2/4/8)
    var autoDjArmed = false                           // Slice 8: Auto-DJ-Marker je Deck
    private var syncEngine = SyncEngine()
    @Published var waveform: [Float] = []             // Slice 3: Peak-Buckets
    @Published var bpm: Double?                       // aus Library oder Setzung
    @Published var keyText: String = ""              // Slice 10: DSP-Key "Am"
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
            var dur: Double
            if url.pathExtension.lowercased() == "mp4" {
                dur = try engine.loadStem(url: url, deck: index)   // Slice 8: echter Stem-Pfad
                isStem = true
            } else {
                dur = try engine.load(url: url, deck: index)
                isStem = false
            }
            state.load(title: url.deletingPathExtension().lastPathComponent, duration: dur)
            title = state.trackTitle
            loadedURL = url
            loopBeats = nil
            restoreMemory(for: url)                    // Slice 10: Cue/Hotcues/BPM/Key
            analyzeInBackground(url: url)              // Slice 10: BPM+Key-DSP, falls unbekannt
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
            state.pause(now: clock); engine.pause(deck: index)
        } else {
            state.play(now: clock)
            engine.setPitchFactor(deck: index, factor: state.rate)
            engine.play(deck: index)
        }
    }

    func cue() { state.cue(now: clock); engine.stop(deck: index); persistMemory() }

    func hotcue(_ i: Int) {
        if state.hotcues[i] != nil { state.jumpHotcue(i, now: clock) } else { state.setHotcue(i) }
        persistMemory()                                // Slice 10: Hotcues dauerhaft
    }

    // MARK: - Slice 10: Track-Memory (Cue/Hotcues/BPM/Key pro Datei)

    private func restoreMemory(for url: URL) {
        guard let m = TrackMemoryStore.load(path: url.path) else { return }
        if let c = m.cue { state.seek(to: c, now: clock) }
        for (k, v) in m.hotcues {
            if let i = Int(k), (1...4).contains(i) { state.setHotcueRaw(i, at: v) }
        }
        bpm = m.bpm
        keyText = m.key ?? ""
    }

    private func analyzeInBackground(url: URL) {
        let path = url.path
        let alreadyKnown = TrackMemoryStore.load(path: path)
        if let b = alreadyKnown?.bpm, alreadyKnown?.key != nil { bpm = b; keyText = alreadyKnown?.key ?? ""; return }
        let analyzeURL = url
        Task.detached(priority: .utility) { [weak self] in
            let samples = PCMExtractor.loadMono(url: analyzeURL, maxSeconds: 90)
            let sr = 22050.0     // Detector-Fold läuft auf jeder Rate; env-Rate korrekt berechnet
            let win = 1024
            let env = BPMDetector.envelope(samples, win: win)
            let detectedBPM = BPMDetector.detectFromOnsets(BPMDetector.onsets(env),
                                                            framesPerSecond: sr / Double(win))
            let detectedKey = KeyDetector.detectKey(samples, sampleRate: sr)
            await MainActor.run {
                guard let self, self.loadedURL == analyzeURL else { return }
                if let b = detectedBPM, self.bpm == nil { self.bpm = b }
                if let k = detectedKey { self.keyText = k }
                self.persistMemory()
            }
        }
    }

    func persistMemory() {
        guard let url = loadedURL else { return }
        var hotcues: [String: Double] = [:]
        for (i, t) in state.hotcues { hotcues[String(i)] = t }
        let entry = TrackMemoryEntry(path: url.path,
                                     cue: state.cuePoint,
                                     hotcues: hotcues,
                                     bpm: bpm,
                                     key: keyText.isEmpty ? nil : keyText)
        TrackMemoryStore.save(entry)
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

    /// Slice 8: Beat-Loop 1/2/4/8 Beats ab aktueller Position (State + Engine-Retrigger).
    func setBeatLoop(_ beats: Int) {
        guard duration > 0 else { return }
        let bpmV = bpm ?? 120
        state.setBeatLoop(beats: beats, bpm: bpmV)
        if let s = state.loopStart, let e = state.loopEnd {
            engine.enableLoop(deck: index, startSec: s, endSec: e)
            loopBeats = beats
        }
    }

    func exitLoop() {
        state.loopExit()
        engine.disableLoop(deck: index)
        loopBeats = nil
    }

    func cycleZoom() {
        zoom = zoom == 1 ? 2 : (zoom == 2 ? 4 : 1)
    }

    /// Slice 8: Stem-Gain/Solo (Mix = 0, Stems 1...4).
    func setStemGain(_ i: Int, _ v: Double) {
        guard stemGains.indices.contains(i) else { return }
        stemGains[i] = min(max(v, 0), 1)
        engine.stemGain(deck: index, stem: i, gain: stemGains[i])
    }

    func stemSolo(_ i: Int) {
        for k in 0..<5 { setStemGain(k, k == i ? 1 : 0) }
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
                // Beat-Phase für LED (Standard 120 BPM, solange kein BPM bekannt)
                let grid = BeatGrid(bpm: self.bpm ?? 120)
                self.beatPhase = self.syncEngine.beatPhase(time: self.playhead, grid: grid)
                self.level = self.engine.level(deck: self.index)
            }
        }
    }
}
