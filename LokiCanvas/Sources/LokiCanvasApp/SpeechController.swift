import Foundation
import Speech
import AVFoundation

/// On-Device-Spracherkennung (de-DE, kein Cloud-Key) → Transcript an CanvasViewModel.
final class SpeechController: NSObject, ObservableObject, @unchecked Sendable {
    @Published var listening = false
    @Published var transcript = ""
    /// Wird nach `stop()` einmalig mit dem finalen Transcript gerufen (Main-Thread).
    var onFinal: ((String) -> Void)?

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "de-DE"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let engine = AVAudioEngine()

    /// Startet Aufnahme; bei fehlender Autorisierung → false.
    func start() -> Bool {
        guard !listening else { return true }
        transcript = ""
        let sem = DispatchSemaphore(value: 0)
        var speechOK = false
        SFSpeechRecognizer.requestAuthorization { state in
            speechOK = (state == .authorized)
            sem.signal()
        }
        sem.wait()
        guard speechOK else { return false }

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults = true
        if recognizer?.supportsOnDeviceRecognition == true {
            request?.requiresOnDeviceRecognition = true      // 100 % lokal
        }
        guard let request else { return false }

        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.request?.append(buffer)
        }
        do {
            engine.prepare()
            try engine.start()
        } catch { return false }

        task = recognizer?.recognitionTask(with: request) { [weak self] result, _ in
            guard let self, let result else { return }
            let text = result.bestTranscription.formattedString
            DispatchQueue.main.async { self.transcript = text }
        }
        listening = true
        return true
    }

    /// Stoppt und liefert das finale Transcript (Main-Thread).
    func stop() {
        guard listening else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        request?.endAudio()
        task?.cancel()
        listening = false
        let final = transcript
        DispatchQueue.main.async { self.onFinal?(final) }
    }
}
