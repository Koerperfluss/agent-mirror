import Foundation
import Testing
@testable import TraktorCloneCore

@Suite struct NMLParserTests {
    static let sampleXML = """
    <?xml version="1.0" encoding="utf-8" standalone="no"?>
    <NML VERSION="18"><HEAD COMPANY="www.native-instruments.com"/>
    <COLLECTION ENTRIES="2">
    <ENTRY TITLE="Nightdrive" ARTIST="Test Artist">
    <LOCATION VOLUME="Macintosh HD" DIR="/Music/:Sub" FILE="track1.mp3"/>
    <TEMPO BPM="128.00000000" QUALITY="1.000"/>
    <MUSICAL_KEY VALUE="8A"/>
    </ENTRY>
    <ENTRY TITLE="Second Song">
    <LOCATION VOLUME="Macintosh HD" DIR="/Music" FILE="s2.wav"/>
    <TEMPO BPM="174.00000000"/>
    </ENTRY>
    </COLLECTION></NML>
    """

    @Test func parsesEntriesWithAllFields() {
        let t = NMLParser.parse(data: Data(Self.sampleXML.utf8))
        #expect(t.count == 2)
        #expect(t[0].title == "Nightdrive")
        #expect(t[0].artist == "Test Artist")
        #expect(t[0].path == "Macintosh HD/Music/Subtrack1.mp3")
        #expect(t[0].bpm != nil && abs(t[0].bpm! - 128) < 1e-6)
        #expect(t[0].keyText == "8A")
    }

    @Test func optionalFieldsTolerated() {
        let t = NMLParser.parse(data: Data(Self.sampleXML.utf8))
        #expect(t[1].artist == "")
        #expect(t[1].keyText == "")
        #expect(t[1].bpm != nil)
    }

    @Test func searchFiltersCaseInsensitive() {
        let t = NMLParser.parse(data: Data(Self.sampleXML.utf8))
        #expect(LibrarySearch.filter(t, query: "night").count == 1)
        #expect(LibrarySearch.filter(t, query: "ARTIST").count == 1)
        #expect(LibrarySearch.filter(t, query: "s2.wav").count == 1)
        #expect(LibrarySearch.filter(t, query: "").count == 2)
        #expect(LibrarySearch.filter(t, query: "zzz").isEmpty)
    }

    @Test func parsesRealCollectionIfPresent() throws {
        let url = URL(fileURLWithPath: NSString(string: "~/Documents/Native Instruments/Traktor 4.5.0/collection.nml").expandingTildeInPath)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let t = NMLParser.parse(url: url)
        // Echte Datei kann leer sein (COLLECTION ENTRIES="0") — Parser muss das
        // ohne Crash spiegeln: Entries>0 → Tracks>0, Entries==0 → 0 Tracks.
        let raw = try String(contentsOf: url, encoding: .utf8)
        let declaredEntries = Int(raw.firstMatch(of: /ENTRIES="(\d+)"/)?.1 ?? "0") ?? 0
        if declaredEntries > 0 {
            #expect(t.count > 0)
            #expect(t.contains { !$0.title.isEmpty })
        } else {
            #expect(t.isEmpty)
        }
    }

    @Test func brokenXMLDoesNotCrash() {
        _ = NMLParser.parse(data: Data("<NML><COLLECTION><ENTRY TITLE=\"x".utf8))
    }
}
