import Testing
import Foundation
import AppKit
@testable import LokiCanvasCore

/// Tests für die Core-seitigen Voraussetzungen der Bild-Analyse (Vision):
/// PNG-Erkennung, Base64-Roundtrip, Prompt-Fallback, Stroke-Struktur.
/// Das eigentliche Strokes-Rendering (VisionSupport) liegt im App-Target (AppKit).
@Suite struct VisionPrepTests {

    private func makeTinyPNG() -> Data {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 1, pixelsHigh: 1,
                                   bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
                                   isPlanar: false, colorSpaceName: .deviceRGB,
                                   bytesPerRow: 0, bitsPerPixel: 0)!
        rep.setColor(NSColor.red, atX: 0, y: 0)
        return rep.representation(using: .png, properties: [:])!
    }

    /// (a) PNG-Daten werden von isPNG erkannt (Magic-Bytes \u{89}PNG).
    @Test func isPNGDetectsMagicBytes() {
        let png = makeTinyPNG()
        #expect(ImageUtil.isPNG(png), "1×1-PNG muss PNG-Magic haben")
        #expect(!ImageUtil.isPNG(Data([0xFF, 0xD8, 0xFF])), "JPEG ist kein PNG")
        #expect(!ImageUtil.isPNG(Data()), "leere Daten sind kein PNG")
    }

    /// (b) Leere Strokes → Konzept: Hintergrund-Bild bleibt gültiges PNG.
    ///     Core-Seite: Stroke-Defaults sind valide; leerer Stroke-Array ist kodierbar.
    @Test func emptyStrokesAreValidAndEncodable() throws {
        let node = CanvasNode(kind: .sketch, strokes: [])
        #expect(node.strokes.isEmpty)
        let data = try JSONEncoder().encode(node)
        let back = try JSONDecoder().decode(CanvasNode.self, from: data)
        #expect(back == node)
        #expect(Stroke().color == "#22D3EE")
    }

    /// (c) imageB64-Roundtrip eines 1×1-PNG bleibt gleich (ohne data:-Präfix).
    @Test func base64RoundtripOfTinyPNG() {
        let png = makeTinyPNG()
        let b64 = png.base64EncodedString()
        #expect(b64 == png.base64EncodedString())
        #expect(Data(base64Encoded: b64) == png)
        #expect(ImageUtil.isPNG(Data(base64Encoded: b64)!))
    }

    /// (d) stripDataPrefix entfernt "data:image/png;base64," sauber.
    @Test func stripDataPrefixWorks() {
        let b64 = makeTinyPNG().base64EncodedString()
        #expect(ImageUtil.stripDataPrefix("data:image/png;base64,\(b64)") == b64)
        #expect(ImageUtil.stripDataPrefix(b64) == b64)
    }

    /// (e) Prompt-Fallback-Text nicht leer + Hex-Parsing der Stroke-Farbe.
    @Test func fallbackPromptAndHexParsing() {
        #expect(!ImageUtil.defaultVisionPrompt.isEmpty)
        let rgba = ImageUtil.rgbaFromHex("#22D3EE")
        #expect(rgba != nil)
        #expect(abs((rgba?.r ?? -1) - 0x22 / 255.0) < 0.0001)
        #expect(ImageUtil.rgbaFromHex("#XYZ") == nil)
    }
}
