import Testing
import Foundation
@testable import LokiCanvasCore

@MainActor
struct VoiceAgentTests {

    @Test func textNodeCommand() {
        let agent = VoiceAgent()
        let cmd = agent.process(finalTranscript: "neuer text knoten einkaufsliste")
        #expect(cmd == .addTextNode("einkaufsliste"))
    }

    @Test func textNodeWithoutTitle() {
        let agent = VoiceAgent()
        let cmd = agent.process(finalTranscript: "neuer text knoten")
        #expect(cmd == .addTextNode(nil))
    }

    @Test func askCommand() {
        let agent = VoiceAgent()
        let cmd = agent.process(finalTranscript: "frage wie ist das wetter")
        #expect(cmd == .ask("wie ist das wetter"))
    }

    @Test func unknownTranscriptReturnsNil() {
        let agent = VoiceAgent()
        // Parser-Fallback liefert .ask(raw) — process muss daraus nil machen.
        let cmd = agent.process(finalTranscript: "qq-müll-unbekannt")
        #expect(cmd == nil)
    }

    @Test func startStopWithoutPermissionsDoesNotCrash() {
        let agent = VoiceAgent()
        // Ohne Freigaben kehrt start() früh zurück: kein Crash, isListening false,
        // availabilityText erklärt den Zustand.
        agent.start()
        #expect(agent.isListening == false)
        #expect(!agent.availabilityText.isEmpty)
        agent.stop()
        #expect(agent.isListening == false)
    }
}
