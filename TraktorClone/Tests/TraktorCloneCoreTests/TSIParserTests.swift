import Foundation
import Testing
@testable import TraktorCloneCore

@Suite struct TSIParserTests {
    @Test func parsesTraktorSettingsEntries() {
        let xml = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <NIXML><TraktorSettings>
        <Entry Name="Audio.ChannelFX.1.Type" Type="1" Value="0"/>
        <Entry Name="Master.Gain" Type="2" Value="-1.5"/>
        </TraktorSettings></NIXML>
        """
        let e = TSIParser.parse(data: Data(xml.utf8))
        #expect(e.count == 2)
        #expect(e[0].element == "Entry")
        #expect(e[0].attributes["Name"] == "Audio.ChannelFX.1.Type")
        #expect(e[0].attributes["Value"] == "0")
        #expect(e[1].attributes["Value"] == "-1.5")
    }

    @Test func parsesRealTraktorSettingsFileIfPresent() {
        // Echte Referenzdatei des Nutzers (nur lesen); ohne Datei: Test still bestehen lassen.
        let url = URL(fileURLWithPath: NSString(string: "~/Documents/Native Instruments/Traktor 4.5.0/Traktor Settings.tsi").expandingTildeInPath)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let e = TSIParser.parse(url: url)
        #expect(e.count > 100)
        #expect(e.contains { $0.attributes["Name"]?.hasPrefix("Audio.") == true })
    }

    @Test func parsesMappingAttributesGenerically() {
        let xml = """
        <NIXML><Controller id="1" DPVersion="4.5.0">
        <MAPPINGS><MAPPING Attr1="PLAY_DECK_A" Note="0x24" Channel="1"/></MAPPINGS>
        </Controller></NIXML>
        """
        let e = TSIParser.parse(data: Data(xml.utf8))
        let m = e.first { $0.element == "MAPPING" }
        #expect(m != nil)
        #expect(m?.attributes["Note"] == "0x24")
    }

    @Test func brokenXMLDoesNotCrash() {
        _ = TSIParser.parse(data: Data("<NIXML><Entry Name=\"A\" Value=\"1".utf8))
    }
}

@Suite struct MIDIActionRouterTests {
    @Test func routesNoteOnToAssignment() {
        let r = MIDIActionRouter()
        r.assign(MIDIAssignment(channel: 0, isCC: false, control: 0x24, action: .playPause))
        var got: (DeckAction, UInt8)?
        r.onAction = { got = ($0, $1) }
        r.route(event: [0x90, 0x24, 127])
        #expect(got?.0 == .playPause)
        #expect(got?.1 == 127)
    }

    @Test func ignoresNoteOffAndOtherChannels() {
        let r = MIDIActionRouter()
        r.assign(MIDIAssignment(channel: 0, isCC: false, control: 0x24, action: .playPause))
        var calls = 0
        r.onAction = { _, _ in calls += 1 }
        r.route(event: [0x90, 0x24, 0])
        r.route(event: [0x91, 0x24, 100])
        r.route(event: [0x80, 0x24, 100])
        r.route(event: [0x90])
        #expect(calls == 0)
    }

    @Test func routesCCAndReassignReplaces() {
        let r = MIDIActionRouter()
        r.assign(MIDIAssignment(channel: 1, isCC: true, control: 7, action: .crossfader))
        r.assign(MIDIAssignment(channel: 1, isCC: true, control: 7, action: .channelFaderA))
        var got: DeckAction?
        r.onAction = { action, _ in got = action }
        r.route(event: [0xB1, 7, 64])
        #expect(got == .channelFaderA)
        #expect(r.assignments.count == 1)
    }

    @Test func clearRemovesAll() {
        let r = MIDIActionRouter()
        r.assign(MIDIAssignment(channel: 0, isCC: false, control: 1, action: .cue))
        r.clear()
        #expect(r.assignments.isEmpty)
    }
}
