import AVFoundation
import TraktorCloneCore

/// DVS-Steuerung: Phono-Eingang → Timecode-Decoder je Deck → Platte steuert
/// den Playhead (Absolute-Mode: Lead-in übersprungen) + Pitch folgt der
/// Plattengeschwindigkeit (inkl. Rückwärts/Stop).
///
/// Braucht einmalig Mikrofon-Freigabe (macOS-Dialog) und ein Audio-Interface
/// mit Phono-Preamplifier am System-Eingang.
@MainActor
final class DVSController: ObservableObject {
    @Published var enabled = false
    @Published var status = "DVS: aus"
    @Published var deckPosition: [Int32?] = [nil, nil]
    @Published var deckSpeed: [Double] = [0, 0]
    /// Stille Zone am Plattenanfang (Codes), bevor der Track startet.
    @Published var leadInCodes: Double = 1000

    private let engine = AVAudioEngine()
    private var decoders: [TimecodeDecoder?] = [nil, nil]
    private let defA = TimecodeDefinition.traktorA
    private let defB = TimecodeDefinition.traktorB

    func toggle() {
        enabled ? stop() : start()
    }

    func start() {
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount >= 2 else {
            status = "DVS: kein Stereo-Eingang verfügbar"
            return
        }
        decoders = [TimecodeDecoder(def: defA, sampleRate: format.sampleRate),
                    TimecodeDecoder(def: defB, sampleRate: format.sampleRate)]
        input.installTap(onBus: 0, bufferSize: 512, format: format) { [weak self] buffer, _ in
            guard let self else { return }
            self.feed(buffer: buffer, channels: Int(format.channelCount))
        }
        do {
            engine.prepare()
            try engine.start()
            enabled = true
            status = "DVS: läuft (\(Int(format.sampleRate)) Hz) — Platte auflegen"
        } catch {
            status = "DVS: Eingang fehlgeschlagen — \(error.localizedDescription)"
        }
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        enabled = false
        status = "DVS: aus"
        deckPosition = [nil, nil]
        deckSpeed = [0, 0]
    }

    private func feed(buffer: AVAudioPCMBuffer, channels: Int) {
        guard let data = buffer.floatChannelData, buffer.frameLength > 0 else { return }
        let n = Int(buffer.frameLength)
        let left = Array(UnsafeBufferPointer(start: data[0], count: n))
        let right = channels > 1 ? Array(UnsafeBufferPointer(start: data[1], count: n)) : left
        for (i, decoder) in decoders.enumerated() {
            guard let decoder else { continue }
            decoder.submit(pcmL: left, pcmR: right)
            let pos = decoder.currentPosition()
            Task { @MainActor in
                self.deckPosition[i] = pos?.position
                self.deckSpeed[i] = decoder.speed
            }
        }
    }

    /// Platten-Codes → Track-Sekunden (Absolute-Mode, Lead-in übersprungen).
    func trackTime(deck: Int) -> Double? {
        guard let code = deckPosition[deck] else { return nil }
        let t = (Double(code) - leadInCodes) / Double(deck == 0 ? defA.resolution : defB.resolution)
        return max(0, t)
    }
}
