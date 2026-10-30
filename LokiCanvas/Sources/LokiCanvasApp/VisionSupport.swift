import AppKit
import LokiCanvasCore

/// AppKit-seitige Vorbereitung für Vision-Requests: Skizzen-Strokes → PNG → Base64.
/// (App-Target, weil NSImage/NSBezierPath AppKit sind; Core bleibt Foundation-only.)
enum VisionSupport {

    static let renderWidth: CGFloat = 512
    static let renderHeight: CGFloat = 360

    /// Hintergrundfarbe = Theme.bg als NSColor (#101216).
    static let backgroundColor = NSColor(calibratedRed: 0.063, green: 0.071, blue: 0.086, alpha: 1)

    /// Rendert Strokes in ein 512×360-Bild (Theme.bg-Hintergrund) → PNG-Data.
    /// Leere Strokes liefern trotzdem ein gültiges Hintergrund-Bild.
    static func renderStrokesPNG(_ strokes: [Stroke],
                                 width: CGFloat = renderWidth,
                                 height: CGFloat = renderHeight) -> Data? {
        let image = NSImage(size: NSSize(width: width, height: height))
        image.lockFocusFlipped(true)
        defer { image.unlockFocus() }

        backgroundColor.setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 0, width: width, height: height)).fill()

        for stroke in strokes {
            let pts = stroke.points.compactMap { p -> NSPoint? in
                guard p.count >= 2 else { return nil }
                return NSPoint(x: p[0], y: p[1])
            }
            guard pts.count >= 2 else { continue }
            let path = NSBezierPath()
            path.move(to: pts[0])
            for p in pts.dropFirst() { path.line(to: p) }
            path.lineWidth = max(1, CGFloat(stroke.width))
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            (ImageUtil.rgbaFromHex(stroke.color).map {
                NSColor(calibratedRed: $0.r, green: $0.g, blue: $0.b, alpha: $0.a)
            } ?? .cyan).setStroke()
            path.stroke()
        }

        guard let tiff = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff),
              let png = rep.representation(using: .png, properties: [:]) else { return nil }
        return png
    }

    /// Base64 für den Vision-Call: Skizze rendern oder vorhandenes imageB64 nehmen
    /// (data:-Präfix wird entfernt). nil, wenn nichts Brauchbares da ist.
    static func base64ForNode(_ node: CanvasNode) -> String? {
        if let b64 = node.imageB64, !b64.isEmpty {
            return ImageUtil.stripDataPrefix(b64)
        }
        guard !node.strokes.isEmpty,
              let png = renderStrokesPNG(node.strokes) else { return nil }
        return png.base64EncodedString()
    }
}
