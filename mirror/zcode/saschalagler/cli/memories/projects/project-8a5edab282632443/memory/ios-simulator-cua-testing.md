---
name: ios-simulator-cua-testing
description: iOS-Simulator-App-Tests per computer-use (ZCode) — window-scoped
  Koordinaten Pflicht, Full-Display-Klicks werden abgelehnt, App-Inhalt nur via
  Screenshot+Vision lesbar; bewährte Kette für E2E-Tests nativer Capacitor-Apps
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

E2E-Tests einer iOS-Simulator-App (z.B. ATLAS Capacitor) mit dem computer-use-MCP (07.09. bewiesen: komplettes KI-Interview 0→11/13 + CTA-Klick im Simulator):

## Bewährte Kette
1. `open -a Simulator` (Fenster sichtbar; `xcrun simctl list devices booted` für UDID — Screenshots alternativ per `xcrun simctl io <UDID> screenshot <pfad>`)
2. `open_application {name:"Simulator"}` → pid holen
3. `list_windows {pid}` → window_id + bounds des iPhone-Fensters
4. `get_app_state {app_ref:{pid,window_id}, include_screenshot:true}` → window-scoped Raster (z.B. 456×972); Koordinaten via analyze_image auf die CDN-URL des Rasters bestimmen lassen
5. Klick/Typ mit diesen window-relativen Koordinaten: `left_click {target:{coordinate}}` (Frame-Bindung zum Fenster), `type {app_ref, text}`, `key {app_ref, text:"return"}`

## Fallgruben (alle selbst getroffen)
- **Full-Display-Screenshots:** Klicks darauf werden ABGELEHNT („no capture-time owner for the selected pixel") — Pixel-Owner nicht auflösbar. analyze_image-Koordinaten vom Full-Screen sind zudem oft falsch/halluziniert (behauptete zentriertes iPhone, Fenster lag woanders). IMMER window-scoped arbeiten.
- **zoom()-Frames:** neue Koordinaten sind RELATIV zum Crop (z.B. 400×210), nicht zum Fenster; Frames werden schnell stale („live pixel owner changed") — nach jedem Layout-Wechsel (Tastatur öffnet!) NEUen get_app_state-Screenshot holen und Koordinaten neu bestimmen.
- **get_app_state auf Simulator zeigt NICHT die App-Inhalte:** a11y-Tree liefert nur Simulator-Chrome (Menüs, Device-Buttons) — App-UI ist nicht accessibility-auflösbar. Text-Verifikation nur per Screenshot → Read (CDN-URL) → mcp__4_5v_mcp__analyze_image. Deren OCR kann Wörter verfälschen („lernen"→„lassen", „3x"→„25x") — kritische Aussagen 2× verifizieren.
- Lange Wartezeiten: KI-Antworten 20–60s (Self-Heal-Retries) — wait (max 30s) + sleep + simctl-Screenshot-Poll.
- **Simulator fährt zwischendurch herunter** (Hintergrund-Pausen genügen): install/launch schlägt fehl mit simctl error 405 „Unable to lookup in current state: Shutdown" (Background-Tasks dann exit 149, obwohl der xcodebuild selbst BUILD SUCCEEDED war) → erst `xcrun simctl boot <UDID>` + `open -a Simulator` (~12s warten), DANN install/launch/screenshot.
- **analyze_image kann PNGs gelegentlich ablehnen** („图片输入格式/解析错误" 400) — JPG-Raster von get_app_state funktionieren zuverlässiger als simctl-PNGs; notfalls erneut hochladen.

Verwandt: [[atlas-master-app-verhaeltnis]] · [[agent-browser-cli]] (Web-Pendant).
