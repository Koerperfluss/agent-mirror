import Foundation

/// Reine Foundation-Helfer für Bild-/Base64-Handling (Core-seitig, testbar ohne AppKit).
public enum ImageUtil {

    /// true, wenn die Daten mit dem PNG-Magic-Header (\u{89}PNG) beginnen.
    public static func isPNG(_ data: Data) -> Bool {
        let magic: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        guard data.count >= magic.count else { return false }
        return Array(data.prefix(magic.count)) == magic
    }

    /// Entfernt ein optionales data:-Präfix ("data:image/png;base64,").
    public static func stripDataPrefix(_ s: String) -> String {
        guard s.hasPrefix("data:"), let comma = s.firstIndex(of: ",") else { return s }
        return String(s[s.index(after: comma)...])
    }

    /// Hex-Farbe ("#RRGGBB" oder "RRGGBB") → RGBA (0…1), nil bei Ungültigkeit.
    public static func rgbaFromHex(_ hex: String) -> (r: Double, g: Double, b: Double, a: Double)? {
        var h = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        if h.count == 3 { h = h.map { "\($0)\($0)" }.joined() }
        guard h.count == 6, let v = UInt32(h, radix: 16) else { return nil }
        return (Double((v >> 16) & 0xFF) / 255,
                Double((v >> 8) & 0xFF) / 255,
                Double(v & 0xFF) / 255, 1.0)
    }

    /// Standard-Prompt, wenn der Nutzer keinen angibt.
    public static let defaultVisionPrompt =
        "Beschreibe präzise, was auf diesem Bild/z dieser Skizze zu sehen ist. Deutsch."
}
