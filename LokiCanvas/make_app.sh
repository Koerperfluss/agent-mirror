#!/bin/bash
# Baut LokiCanvas.app ohne Xcode (SwiftPM + handgebautes Bundle) — 24/7 nativ.
set -euo pipefail
cd "$(dirname "$0")"

echo "🔨 Release-Build…"
swift build -c release

APP="build/LokiCanvas.app"
BIN=".build/release/LokiCanvasApp"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>LokiCanvasApp</string>
  <key>CFBundleIdentifier</key><string>local.lokicanvas.app</string>
  <key>CFBundleName</key><string>LokiCanvas</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSMicrophoneUsageDescription</key><string>Sprach-Agent: Spracheingabe für lokale KI-Befehle</string>
</dict>
</plist>
PLIST

cp "$BIN" "$APP/Contents/MacOS/LokiCanvasApp"
codesign --force --sign - "$APP" 2>/dev/null || echo "⚠️ codesign übersprungen"

echo "✅ App gebaut: $APP"
echo "   Start: open $APP"
