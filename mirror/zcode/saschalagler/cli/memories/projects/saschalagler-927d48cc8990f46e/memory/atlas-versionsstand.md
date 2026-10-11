---
name: atlas-versionsstand
description: ATLAS-Versionen IST-Stand 21.09.2026 — beide lokalen Server (5173
  v8-Dev, 4173 Master-Preview) TOT; PROD atlas-v5.web.app lebt und wurde NEU
  deployed (Bundle index-DG7Gco4d.js statt Dn3jA4Wx.js vom 11.09.);
  ATLAS_MASTER/app bis 18.09. bearbeitet.
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2879174a-220a-46e8-be58-79d65929bc01
---

ATLAS (Cali Coach) — IST-Stand 21.09.2026 (live verifizert):

- **localhost:5173** (v8 „Barbulls Premium" Design-Sandbox, `~/ATLAS_DESIGN/atlas-v8`): Server tot (Ordner existiert, Stand 11.09.).
- **localhost:4173** (Master-Preview, `~/Desktop/Coworkspace_Ich/atlas + pliability /ATLAS_MASTER/app`): Server tot; Ordner bis 18.09. aktiv bearbeitet.
- **https://atlas-v5.web.app** (PROD): live, APK-Download 200 OK, **neues Bundle `index-DG7Gco4d.js`** — seit dem 11.09.-Bericht (da war es `index-Dn3jA4Wx.js` = identisch mit 4173) wurde neu gebaut+deployed. Der alte 11.09.-Bericht „4173 = PROD 1:1" ist damit veraltet.
- Offene Pfad-Entscheidung (aus Alt-Session): A = v5 stabil halten vs. B = v8-Fusion — von Sascha nie entschieden.

Verwandt: [[loki-os-ecosystem-stand]]

**11.10.2026 Pipeline-Test (erster appagentteam-Live-Flug):** flutter-skill explore auf PROD atlas-v5.web.app → 20 Steps geplant, 3 genutzt, 1 Seite/10 Elemente; Buttons COACH, LOGBUCH, DATENBANK, ÜBERBLICK getippt ✓; **0 Bugs, 0 Accessibility-Issues**; Playwright: 0 Console-Errors, Titel „ATLAS — Calisthenics Coach". Beweise: `~/Desktop/TEST_ATLAS_11-10.png` + explore-report.html (cwd ~/). Muster: flutter-skill `screenshot` via serve+FS_PORT HING → Playwright-Screenshot als Fallback (explore/snap = flutter-skill, visuelle Beweise = Playwright). Die 810k-Cline-Session „VERKAUFS HUB - 11 Agent monster" (sess 1789109742185_p3730, 8,3 MB messages, inputTokens 304 M) = FAILED ATLAS-Xcode/Web-Abgleich-Session — schadlos schließbar.

**11.10.2026 VOLL-TESTUNG gestartet (Sascha: „vollautonome Atlas testung ios app web app android app, optimierung, fokus: Funktion, intuitive Bedienung, File-Upload, Video-Upload, Userflow Trainingsplan/Logbuch"):** 4 Background-Läufe, Ergebnisse PENDING: (1) Subagent qa-tester = Web-Funktionstest via flutter-skill CLI (serve :3745, Uploads/Flows, max 25 Aktionen, Bug-Tabelle), (2) Subagent explore = Code-Analyse ATLAS_MASTER (existiert File-/Video-Upload/Trainingsplan/Logbuch überhaupt? Datei:Zeile), (3) iOS-Build: `xcodebuild -project "$A/app/ios/App/App.xcodeproj" -scheme App -sdk iphonesimulator -derivedDataPath /tmp/atlas_ios -quiet build CODE_SIGNING_ALLOWED=NO` (Capacitor 8.5.1 via CapApp-SPM, Xcode-27-Beta.6; A = Pfad mit trailing space quoten!), (4) Android: `cd "$A/app/android" && ./gradlew assembleDebug`. Projektstruktur: ATLAS_MASTER/app = Capacitor (dist + ios/App + android + firebase.json + index.html). Voll-Report folgt wenn Notifications da.
