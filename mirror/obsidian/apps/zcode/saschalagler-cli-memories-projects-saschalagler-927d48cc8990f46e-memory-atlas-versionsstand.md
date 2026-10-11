---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/atlas-versionsstand.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

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

**11.10.2026 VOLL-TESTUNG ERGEBNIS (alles zurückgemeldet):**

- **Web (qa-tester-Subagent):** URTEIL PASS — 5✅ 6⚠️ 1❌. Kern-Flows ✓ (Tab-Navigation, Trainingsplan-KI-Flow „Plan erstellen"→KI-Fragen, Logbuch-Übernahme, Datenbank-CRUD-Buttons vorhanden). ❌ Screenshot-Endpoint (CDP captureScreenshot Timeout, HTTP 500, Infra). ⚠️ **visibility:hidden-Falle:** versteckter Chrome-Tab = Renderer pausiert, erste 3 Taps wirkungslos → erst Tab-Fokus (bringToFront). File-/Video-Upload-Durchläufe OFFEN (Aktionslimit 25 erreicht) — Repro: serve → Tab fokussieren → Coach → Vision → upload_file mit Testvideo.
- **iOS: BUILD SUCCEEDED** — aber NUR mit explizitem `-destination 'platform=iOS Simulator,name=iPhone 17e'`; ohne -destination druckte xcodebuild nur die Geräteliste = **SCHEINSUCCESS**. Zweite Falle: `EXIT=$?` nach pipe (`| tail`) liefert pipe-Exit, nicht build-Exit — Logs müssen greped werden. App.app: `/tmp/atlas_ios/Build/Products/Debug-iphonesimulator/App.app`, Bundle-ID **app.barbulls.atlas** (steht in project.pbxproj, Info.plist hat nur $(PRODUCT_BUNDLE_IDENTIFIER)). simctl boot/install/launch-Kette gestartet (launch booted app.barbulls.atlas + Screenshot TEST_ATLAS_IOS_11-10.png) — Abschluss-Bestätigung ausstehend.
- **Android: BUILD FAILED (18s)** — „Could not resolve all artifacts for configuration 'classpath'" (Gradle-Config-Auflösung, kein Code-Fehler). → Task #28. Alte funktionierende APKs existieren weiter: `app/build/outputs/apk/release/app-release.apk` + `app/src/main/assets/public/download/ATLAS-v5.apk`.
- **Code-Analyse (explore-Subagent, Belege app/src/):** ALLE 4 Features existieren — File-Upload = JSON-Import/Export Übungs-DB (DatabaseTab.tsx:103/66-73), Video-Upload + Kamera LOKAL via MediaPipe (VisionPanel.tsx:618/710, pose.ts:411 „Frames verlassen das Gerät nie"), Trainingsplan (data/plans.ts + TrainingsplaeneTab + GTG gtgDb.ts), Logbuch (logbookDb.ts IndexedDB + SessionRunner.tsx painScore). **Kein Firebase Storage (0 Grep-Treffer) = Privacy-Design, kein Bug.** YouTube-Links statt Video-Storage (exercise.ts:14).
- **ATLAS-Auftrags-Lücken gegenüber Saschas Wortlaut** (seine Rechnung „DAS WAREN AUCH NICHT DIE AUFGABEN" bezog sich u. a. darauf, dass ich seinen Auftrag nie als komplette Checkliste zeigte): ❌ Android-Fix · ⚠️ File-/Video-Upload-Echtdurchlauf · ⚠️ Nutzbarkeits-/Verständnis-Bewertung · ❌ „Optimierung der ganzen App" nicht begonnen. Test-Beweise: Desktop/TEST_ATLAS_11-10.png, TEST_ATLAS_IOS_11-10.png (pendiert), TEST_HUB_11-10.png.

**11.10. NACHMITTAG — Android GELÖST + Video-Upload getestet (echter Bug gefunden):**

- **Android ✅ GELÖST (Subagent, BUILD SUCCESSFUL 1m8s, APK `app/build/outputs/apk/debug/app-debug.apk` 28 MB frisch):** Ursachen-Kette: System-JDK = **Java 8**, AGP 8.13 braucht ≥17, Capacitor kompiliert source 21 → Fix rein Umgebungs-seitig: `export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"` + `./gradlew assembleDebug --offline` (alle Artifacts im Cache). Zero-Code-Diff. Dauerhaft-Option (bewusst NICHT gesetzt): `~/.gradle/gradle.properties` → `org.gradle.java.home=…openjdk@21…`. Copy-Vorlage steht im File.
- **Video-Upload-Nachtest (Subagent, URTEIL FAIL 4✅ 3❌ 1⚠️):** File-Upload App-seitig ✅ (Video landet sauber im `<video>`, Name angezeigt) — **echter Bug: „Analyse starten" startet die Verarbeitung NICHT** (video friert bei currentTime 0.02, 14 Gelenkwinkel bleiben „–", play() resolvet aber sofort wieder paused; keine Fehlermeldung) → **Task #28 (P2, Projekt ATLAS): „Analyse-Button startet Video-Pose-Analyse nicht — vermutlich requestVideoFrameCallback/Playback-Loop"**. flutter-skill `upload` ist für diese App unbrauchbar (Chrome-154-Quirk: file chooser „files.length is 0") — funktionierender Workaround = DataTransfer-Injection + change-Event. Kleinstrepro: PROD → Form-Check → Vision → „Video wählen" → MP4 → „Analyse starten".
- Privacy-Pilot Ollama (qwen3.5:9b, FFG-Frage): erster Aufruf = 2-Min-Timeout (Modell-Ladezeit beim Kaltstart), Retry offen — gehört zu Task #8 Hermes-Pilot.
