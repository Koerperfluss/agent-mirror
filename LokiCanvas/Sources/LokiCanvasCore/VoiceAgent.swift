import Foundation
import Speech
import AVFoundation

/// Sprachgesteuerter Agent: SFSpeechRecognizer + AVAudioEngine,
/// Transcript live in `transcript`, Endergebnis → `VoiceParser` → `onCommand`.
@MainActor
public final class VoiceAgent: ObservableObject {
    @Published public private(set) var isListening: Bool = false
    @Published public private(set) var transcript: String = ""
    @Published public private(set) var availabilityText: String = "Sprache bereit"

    /// Wird bei erkanntem Befehl gefeuert (immer auf dem MainActor).
    public var onCommand: ((VoiceCommand) -> Void)?

    private let locale: Locale
    private let engine = AVAudioEngine()
    private var recognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    public init(locale: Locale = Locale(identifier: "de-DE")) {
        self.locale = locale
        self.recognizer = SFSpeechRecognizer(locale: locale)
        refreshAvailability()
    }

    // MARK: - Öffentliche Steuerung

    public func start() {
        guard !isListening else { return }

        // Früh aussteigen, wenn Freigaben fehlen — kein Crash, Hinweis genügt.
        let speechStatus = SFSpeechRecognizer.authorizationStatus()
        guard speechStatus == .authorized else {
            availabilityText = (speechStatus == .denied || speechStatus == .restricted)
                ? "Spracherkennung nicht freigegeben — Systemeinstellungen > Datenschutz > Spracherkennung beachten"
                : "Spracherkennung noch nicht freigegeben — App-Dialog beachten"
            requestPermissionsIfNeeded()
            return
        }
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        guard micStatus == .authorized else {
            availabilityText = "Mikrofon nicht freigegeben — App-Dialog beachten"
            if micStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .audio) { [weak self] _ in
                    Task { @MainActor in self?.refreshAvailability() }
                }
            }
            return
        }
        guard let recognizer, recognizer.isAvailable else {
            availabilityText = "Spracherkennung auf diesem Mac nicht verfügbar"
            return
        }

        do {
            try beginSession(recognizer: recognizer)
            isListening = true
            transcript = ""
            availabilityText = recognizer.supportsOnDeviceRecognition
                ? "Sprache bereit (on-device)"
                : "Sprache bereit (Server-Fallback)"
        } catch {
            availabilityText = "Audio-Start fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    public func stop() {
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
        // Tap entfernen, sonst crasht der ZWEITE start() mit doppeltem Bus-0-Tap.
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isListening = false
    }

    // MARK: - Testbare Verarbeitung (ohne Mikrofon)

    /// Parst ein finales Transcript; `nil` bei unbekanntem Befehl
    /// (Parser-Fallback `.ask` zählt nur als bekannt, wenn "frage" gesagt wurde).
    internal func process(finalTranscript: String) -> VoiceCommand? {
        let command = VoiceParser.parse(finalTranscript)
        switch command {
        case .ask(let q):
            // Unbekanntes → Parser liefert Fallback `.ask(raw)`; echter ask-Befehl enthält "frage".
            guard finalTranscript.lowercased().contains("frage") else { return nil }
            return .ask(q)
        default:
            return command
        }
    }

    // MARK: - Intern

    private func beginSession(recognizer: SFSpeechRecognizer) throws {
        // macOS: keine AVAudioSession nötig (iOS-only API) — AVAudioEngine läuft direkt.
        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        // On-device versuchen, sonst Fallback (Hinweis steht in availabilityText).
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }

        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.request?.append(buffer)
        }
        engine.prepare()
        try engine.start()

        self.request = request
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }
                if let result {
                    self.transcript = result.bestTranscription.formattedString
                    if result.isFinal {
                        self.stop()
                        if let command = self.process(finalTranscript: self.transcript) {
                            self.onCommand?(command)
                        }
                        self.transcript = ""
                    }
                }
                if error != nil {
                    self.stop()
                }
            }
        }
    }

    private func requestPermissionsIfNeeded() {
        if SFSpeechRecognizer.authorizationStatus() == .notDetermined {
            SFSpeechRecognizer.requestAuthorization { [weak self] _ in
                Task { @MainActor in self?.refreshAvailability() }
            }
        }
    }

    private func refreshAvailability() {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .denied, .restricted:
            availabilityText = "Spracherkennung nicht freigegeben — Systemeinstellungen > Datenschutz > Spracherkennung beachten"
        case .notDetermined:
            availabilityText = "Spracherkennung noch nicht freigegeben — App-Dialog beachten"
        default:
            if let recognizer, !recognizer.isAvailable {
                availabilityText = "Spracherkennung auf diesem Mac nicht verfügbar"
            } else {
                availabilityText = "Sprache bereit"
            }
        }
    }
}
