#!/bin/bash
# Baut TraktorClone.app ohne Xcode (SwiftPM + handgebautes Bundle).
set -euo pipefail
cd "$(dirname "$0")"

echo "🔨 Release-Build…"
swift build -c release

APP="build/TraktorClone.app"
BIN=".build/release/TraktorCloneApp"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>TraktorCloneApp</string>
  <key>CFBundleIdentifier</key><string>local.traktorclone.app</string>
  <key>CFBundleName</key><string>TraktorClone</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.2</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>NSMicrophoneUsageDescription</key><string>DJ-Audio-Aufnahme des Master-Ausgangs</string>
</dict>
</plist>
PLIST

cp "$BIN" "$APP/Contents/MacOS/TraktorCloneApp"
codesign --force --sign - "$APP" 2>/dev/null || echo "⚠️ codesign übersprungen"

echo "✅ App gebaut: $APP"
echo "   Start: open $APP"
