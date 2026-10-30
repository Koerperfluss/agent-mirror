import Testing
import Foundation
@testable import TraktorCloneCore

// MARK: - Slice 13: NI-TSI-Action-Katalog (DCDT-Records)

/// Baut einen DCDT-Record nach dem reverse-engineineerten NI-Format:
/// "DCDT" · u32 payloadLen · u16 skip · u16 nameLen(chars) · UTF-16LE-Name · Restfelder
func dcdtRecord(action: String) -> Data {
    var d = Data([0x44, 0x43, 0x44, 0x54])               // "DCDT"
    let nameData = Array(action.utf16)
    let nameBytes = nameData.count * 2
    let payload = UInt32(2 + 2 + nameBytes + 14)
    d.append(contentsOf: withUnsafeBytes(of: payload.littleEndian) { Array($0) })
    d.append(contentsOf: [0x00, 0x00])                   // u16 skip
    d.append(contentsOf: withUnsafeBytes(of: UInt16(nameData.count).littleEndian) { Array($0) })
    for ch in nameData {
        d.append(contentsOf: withUnsafeBytes(of: ch.littleEndian) { Array($0) })
    }
    d.append(contentsOf: [0x00, 0x00, 0x01, 0x00, 0x00, 0x00,   // Felder nach Name
                          0x00, 0x3f, 0x80, 0x00,
                          0x00, 0x00, 0x00, 0x00])
    return d
}

@Suite("NI-TSI-Action-Katalog")
struct TSIMappingImportTests {
    @Test func dcdtScannerLiestNamen() {
        var blob = dcdtRecord(action: "Left.Cue")
        blob += dcdtRecord(action: "Right.Hotcue. 2 ")
        blob += dcdtRecord(action: "Left.Sample Play. 1 ")

        let names = TSIMappingImporter.scanDCDT(blob: blob)
        // Robuster Scanner: kann Header-Fragmente mitliefern — die vollen
        // Namen müssen enthalten sein.
        #expect(names.contains("Left.Cue"))
        #expect(names.contains("Right.Hotcue. 2 "))
        #expect(names.contains("Left.Sample Play. 1 "))
    }

    @Test func kaputteLängenWerdenÜbersprungen() {
        var blob = Data([0x44, 0x43, 0x44, 0x54])
        blob.append(contentsOf: [0xFF, 0xFF, 0xFF, 0xFF])  // absurde payloadLen
        blob += dcdtRecord(action: "Left.Sync")

        let names = TSIMappingImporter.scanDCDT(blob: blob)
        #expect(names.contains("Left.Sync"))
    }

    @Test func vollständigeTSIWirdGeparst() {
        let inner = dcdtRecord(action: "Left.Cue") + dcdtRecord(action: "Right.Play")
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
        <NIXML><TraktorSettings>
          <Entry Name="DeviceIO.Config.Controller" Type="3" Value="\(inner.base64EncodedString())"/>
        </TraktorSettings></NIXML>
        """
        let catalog = TSIMappingImporter.actions(data: Data(xml.utf8))
        #expect(catalog.count == 2)
        #expect(catalog[0].name == "Left.Cue")
        #expect(catalog[0].supported)                       // → .cue
        #expect(catalog[1].name == "Right.Play")
        #expect(catalog[1].supported)                       // → .playPauseB
    }

    @Test func niNamenÜbersetzenAufDeckActions() {
        #expect(TSIMappingImporter.deckAction(forNI: "Left.Cue.Play") == .playPause)
        #expect(TSIMappingImporter.deckAction(forNI: "Right.Cue.Play") == .playPauseB)
        #expect(TSIMappingImporter.deckAction(forNI: "Left.Hotcue. 3 ") == .hotcue3)
        #expect(TSIMappingImporter.deckAction(forNI: "Right.Loop.In") == .loopInB)
        #expect(TSIMappingImporter.deckAction(forNI: "Left.Sample Play. 1 ") == nil)
        #expect(TSIMappingImporter.deckAction(forNI: "Left.Shift") == nil)
    }

    @Test func neueDeckActionsSindCodableKompatibel() throws {
        // Alte Mapping-JSONs (ohne B-Actions) müssen weiter laden; neue runden.
        let m = LearnedMapping(channel: 0, isCC: false, control: 63, action: DeckAction.playPauseB.rawValue)
        let data = try JSONEncoder().encode([m])
        let back = try JSONDecoder().decode([LearnedMapping].self, from: data)
        #expect(back[0].assignment?.action == .playPauseB)
    }

    /// Integrationstest gegen die echte S4-Datei auf diesem Mac (überspringt still, falls fehlt).
    @Test func echteS4DateiLiefertActionKatalog() throws {
        let url = URL(fileURLWithPath: NSString(
            string: "~/Documents/Native Instruments/Traktor 4.5.0/Settings/Default Settings/Controller/Native Instruments/_01 - Controller - Native Instruments - S4 User Mapping.tsi"
        ).expandingTildeInPath)
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let data = try Data(contentsOf: url)
        let entries = TSIParser.parse(data: data)
        let deviceEntry = entries.first { $0.attributes["Name"] == "DeviceIO.Config.Controller" }
        let valueLen = deviceEntry?.attributes["Value"]?.count ?? -1
        let blob = deviceEntry.flatMap { $0.attributes["Value"] }.flatMap { Data(base64Encoded: $0) }
        let names = blob.map { TSIMappingImporter.scanDCDT(blob: $0) } ?? []
        #expect(entries.count >= 3, "Entries: \(entries.count)")
        #expect(valueLen > 100000, "Value-Länge: \(valueLen)")
        #expect((blob?.count ?? 0) > 100000, "Blob-Größe: \(blob?.count ?? 0)")
        #expect(names.count > 20, "DCDT-Namen: \(names.count) | erste: \(names.first ?? "—")")

        let catalog = TSIMappingImporter.actions(url: url)
        #expect(catalog.count > 20, "Katalog: \(catalog.count)")
        #expect(catalog.contains { $0.name == "Left.Cue" && $0.supported })
    }
}
