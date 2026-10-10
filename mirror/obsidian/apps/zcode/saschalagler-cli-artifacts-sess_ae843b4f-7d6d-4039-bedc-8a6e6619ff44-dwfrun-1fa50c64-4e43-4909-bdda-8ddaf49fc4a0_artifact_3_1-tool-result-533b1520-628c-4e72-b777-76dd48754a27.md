---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_ae843b4f-7d6d-4039-bedc-8a6e6619ff44/dwfrun-1fa50c64-4e43-4909-bdda-8ddaf49fc4a0_artifact_3_1-tool-result-533b1520-628c-4e72-b777-76dd48754a27.md"
stand: 2026-10-10
tags: [spiegel, zcode]
---

# HANDOFF VERKAUFS-HUB — 2026-10-10

**Quelle:** ausschließlich die gelieferten Ergebnis-Arrays vom 10.10.2026 (Datei-Befunde ai_studio_code · Real-Tool-Analyse · Kandidaten-Audit · Markt · Sammel-Funde). Nichts ergänzt; Uneindeutiges steht als „unklar".

---

## 1. BLUF

1. **Zwei Zahlen, klar getrennt:** Das Kandidaten-Audit stuft von 21 geprüften Kandidaten nur **4 als real** ein (OmniRoute, IRIS Neural OS, LOKI.OS App v18, Native Legal Ops); die Real-Tool-Analyse belegt separat **12 echte Tools** (Abschnitt 2) — davon **4 „läuft"** (paraletts-3d-shop, judicario-loki-voice, agent-mirror, native-legal-ops), 6 prototyp, 2 leergestellt. **Für die Verkaufsplanung gilt Abschnitt 2 mit den 4 „läuft"-Tools an der Spitze**; die „4 von 21"-Zahl ist nur das Audit-Urteil über die Kandidatenliste. **Alle 13 ai_studio_code-Fragmente sind Ghost** (4 byteidentische Dubletten) — hinter keinem steht ein Swift-/Python-Projekt (mdfind/find: kein *.xcodeproj/Package.swift außerhalb der Fragmente).
2. **Top-Empfehlung: Native Legal Ops als 999-EUR-Einmallizenz per b2b_direct an DACH-Kanzleien** — gestützt auf 101/110 E2E-Tests (Prüfbericht 02.10.2026) und das Privacy-Argument „100 % lokal"; CoCounsel (~100–150 USD/Nutzer/Monat) und Harvey (ab ~100k USD/Jahr) sind massiv teurer.
3. **Vor jedem Verkauf Blocker beseitigen:** fehlende LICENSE/README/Doku bei fast allen Tools, nur adhoc-Signierung (keine Notarization) bei den macOS-Apps, API-Keys-Logik in OmniRoute (Warnung INVENTAR-VOLL.md:31), IRIS-Copyright liegt bei Drittanbieter Harsh Pandey (Source-Available-Lizenz).

---

## 2. Die echten Tools (Real-Tool-Analyse — 12)

**Prüfbericht 02.10.2026** (in Abschnitt 2/5 zitiert) = `/Users/saschalagler/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/05_VOLLSTAENDIGER_PRUEF_UND_TESTBERICHT_2026-10-02.md` (Pfad am 10.10. per `find` verifiziert; enthält u. a. „54 von 54 Tests PASSED", „101 von 110 Tests PASSED (91.8%)").

| Tool | Pfad | Stand | Lücken bis verkaufbar | Wert | Kanal | Beweis |
|---|---|---|---|---|---|---|
| **paraletts-3d-shop** | `~/Desktop/Coworkspace_Ich/VEREIN ; BARBULLS ; PARALETTS` | läuft | kein Git-Repo/License, kein Checkout/Payment (nur statische Site), README/Tests fehlen, 3mf-Extractor nicht als Konfigurator verpackt, firebase.json nur .bak | 100–300 EUR einmalig (Kunden-Shop) · 15–40 EUR/Monat (betreuter Shop) | b2b_direct | `du -sh` → 297M; `deploy/index.html` Titel „BAR BULLS \| FEA-Optimierte Calisthenics Parallettes" |
| **judicario-loki-voice** | `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO` | läuft | adhoc-Signatur ohne Notarization (Gatekeeper-Warnung), keine LICENSE/README für Käufer, Thomas/Peter-Personalisierung entfernen, sauberes DMG + Install-Doku fehlen | 200–500 EUR Lizenz pro Nutzer (Legal-Nische) | b2b_direct | LokiVoice.app 1.0.0 (com.saschalagler.LokiVoiceApp); Prüfbericht 02.10.: **54/54 Tests PASSED**, Live-Gateway HTTP 200 |
| **koerperfluss-3d-v2-upgrade** | `github:Koerperfluss/3d.-UPGRADE-` (nicht lokal geklont) | prototyp | lokaler Clone fehlt, Vertriebs-README/Landing-Page, Backend-Kostenklärung (Firebase/Gemini), Demo-Daten/Tests; MIT-Lizenz macht Einzelverkauf schwer → als Dienst/Bundle | 500–2000 EUR Lizenz an Physio-Studios (Körperfluss-Bundle) | klinik_lizenz | `gh repo view` → PUBLIC, MIT, letzter Push 30.09.2026, 76 MB |
| **agent-mirror** | `~/Projects/agent-mirror` | läuft | README = Lovable-Boilerplate (keine Produktdoku), keine LICENSE, lokal kein .git, keine Tests, DSGVO-Frage (spiegelt Agenten-Umgebungen) ungeklärt | 50–150 EUR/Monat B2B-Dashboard oder 500–1500 EUR Lizenz | b2b_direct | Cloud-Run `agent-mirror-56283064730.europe-west1.run.app` → HTTP 200; Auto-Sync-Skripte (install.sh, archive-to-gcs.sh) vorhanden |
| **omniroute** | `~/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /OmniRoute` | leergestellt (Prüfzeitpunkt) | **API-Keys-Logik vor Verkauf säubern** (INVENTAR-VOLL.md:31), Start-/Daemon-Doku, Release-Verpackung (npm-Status unklar), Tests dünn (1 Datei) | 50–150 EUR/Monat White-Label (Multi-Abo-Sparer-Nische) | eigene_website | omniroute v3.8.50, LICENSE, aktives Git bis Commit #10826; Port 20128 beim Check tot (curl=000, kein Listener) trotz „täglich im Einsatz" |
| **iris-ai** | `~/Desktop/IRIS-AI-main` | prototyp | Copyright bei Drittanbieter Harsh Pandey (Custom Source-Available) → Weiterverkauf ohne Lizenzklärung blockiert, nur 2 Testdateien, eigene Vertriebsdoku/Branding fehlt | 20–60 EUR/Monat oder 200–500 EUR Lizenz — erst nach Lizenzklärung | gumroad | iris-ai v1.7.0, LICENSE „Copyright (c) 2026 Harsh Pandey"; Tests: isolate.test.ts + auth.spec.ts |
| **native-legal-ops** | App: `~/Desktop/Applications/Native Legal Ops.app` (Symlink → /Applications/…) · **Source-Repo (Kandidaten-Audit, heute per `ls` verifiziert):** `/Users/saschalagler/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/NativeLegalOps` | läuft | ~~„Source-Repo nicht auffindbar"~~ **nachkorrigiert:** Repo gefunden (2 .xcodeproj + Package.swift + Sources + Tests, 36 .swift-Dateien — Beweis in Abschnitt 4); der ältere Befund bezog sich nur auf den Desktop/Applications-Ordner. Verbleibende Lücken: keine Notarization (adhoc); Doku fehlt (INVENTAR-VOLL.md:34); keine LICENSE/Verkaufsvereinbarung | 500–2000 EUR Lizenz (Rechts-Nische) | b2b_direct | 10-MB-arm64-App (LegalOpsAdvisor 1.0.0, adhoc); Prüfbericht 02.10. (Pfad oben): **101/110 E2E-Tests** |
| **chipsi** | `~/Desktop/Applications/Chipsi.app` | leergestellt | Produktklärung (was verkaufen — Webapp? Wrapper?), Backend-Crash beheben (abhängig von Marinus/Reinhard), keine LICENSE/README, kein natives Produkt | 0 EUR einzeln — nur Teil des Judicario-Gesamtpakets | b2b_direct | Bundle = reiner Chrome-App-Mode-Wrapper (app_mode_loader, com.google.Chrome.app.…); Backend chipsi.openlaw.cc „100% Crash bei Synthese" (DEFECT) |
| **loki-os-app-v18** | `~/loki-ki/macos-app-v18` | prototyp | LICENSE fehlt, keine Tests, Notarization/DMG fehlen; Kopplung an LOKI-Interna (Brain-Pfade, OmniRoute, Kernel) für Fremdkunden entkoppeln | 50–200 EUR — nur als Teil der LOKI.OS-Suite | eigene_website | 16 Swift-Dateien, „LOKI OS v18.app" adhoc-signiert, deutsche README/PLAN.md |
| **auto-sync-save** | `~/Desktop/Auto Sync & Save` | prototyp | Sync-/Backup-Logik fertigstellen, eigenes Git-Repo, LICENSE, Produktdoku statt Lovable-Boilerplate, Tests/Build-Verifikation | 5–15 EUR/Monat wenn fertig | gumroad | package.json „tanstack_start_ts"; kein .git; README = Lovable-Boilerplate |
| **loki-dashboard-app** | `~/loki-ki/dashboard-app` | prototyp | alles: Features implementieren, Produktdoku, LICENSE, Git, Tests; Build unverifiziert (nur dist-Artefakt) | 0 EUR (Baublock) | eigene_website | React+Vite-Boilerplate-README, 0 Swift-Dateien (INVENTAR-VOLL.md:37 „Minimal-Template") |
| **koerperfluss-pilot-ai** | `~/Desktop/Coworkspace_Ich/Körperfluss EDU/Körperfluss-PILOT.AI` | prototyp | Scope-Klärung (Fördercockpit ≠ „AI-Studio-Prototyp" laut tools-v2.json), aktueller Build/Deploy, README/Lizenz, Tests/Demo | 0–100 EUR — Teil des Körperfluss-Bundles | b2b_direct | „Fördercockpit PILOT.AI" (foerder-cockpit-fuer-startups v5.0.0); dist/index.html nur 407 B (05.08.2026) |

**Zwischenzähler:** 4 läuft · 6 prototyp · 2 leergestellt.

---

## 3. ai_studio_code-Dateien (13)

Alle liegen in `/Users/saschalagler/Claude/Projects/TOOL SAMMLUNG VERKAUF/vibe-sales-suite/verkaufs hub/`. Audit-Urteil (Sektion 4): **13/13 = Ghost** — kein einziges Projekt dahinter.

| Datei | Was steckt drin | Tool-Name | Verkaufbar | Dublette? |
|---|---|---|---|---|
| ai_studio_code.py | Google-Beispielskript: Gemini-Deep-Research-Agent + Polling-Loop, kein eigenes Tool, kein UI (46 Zeilen/922 B) | keins | nein | nein |
| ai_studio_code (1).py | byteidentisch mit ai_studio_code.py | keins | nein | **ja** (MD5 43bd327b…) |
| ai_studio_code.txt | processAllAssets() mit TaskGroup — parallele Analyse von 42 Tool-Assets (Swift) | Workspace AI Pro (4-Stage Pipeline) | nein | **ja** (MD5 30dabe4f… = identisch mit (2).txt) |
| ai_studio_code (1).txt | systemPrompt für 4 Agent-Rollen (Evaluator, Web-Scraper, Marktanalyst, Sales-Strategist) inkl. Österreich-/Lemon-Squeezy-Verkaufslogik — der Kernwert des Snippets | Workspace AI Pro | teilweise | nein |
| ai_studio_code (2).txt | processAllAssets() (Original von .txt) | Workspace AI Pro | nein | nein |
| ai_studio_code (3).txt | SwiftUI-View „AI Agent Pipeline" mit Run-Button + Asset-Liste, ohne Rest nicht lauffähig | Workspace AI Pro | nein | nein |
| ai_studio_code (4).txt | Markdown-Dump „Portfolio-Inventar" (17 eigene Tools mit Typ/Pfad/Stack/Reifegrad), kein Code | keins (Inventardaten) | nein | nein |
| ai_studio_code (6).txt | runFullPipeline() mit 4 Stufen (Evaluierung→Competitor→Markt→Sales-Strategie Ö) + callAgent() mit echtem Gemini-API-Call und Mock-Fallback | Workspace AI Pro | teilweise | nein |
| ai_studio_code (7).txt | byteidentisch mit (6).txt | Workspace AI Pro | teilweise | **ja** (MD5 6b646d34…) |
| ai_studio_code (8).txt | Haupt-UI „Vibe Portfolio (N)" + Workspace-AI-Pro-Pipeline-Center + seedMockData (Atlas Cali V2, Andi Medical 2026, 20 AI-Studio-Apps) | Workspace AI Pro („Vibe Portfolio") | teilweise | nein |
| ai_studio_code (9).txt | processAllAssets() v2 mit completedCount/totalCount-Fortschrittszählung | Workspace AI Pro | nein | nein |
| ai_studio_code (10).txt | byteidentisch mit (8).txt | Workspace AI Pro | teilweise | **ja** (MD5 a7de4c69…) |
| ai_studio_code (11).txt | generisches SwiftUI-Card-Utility (Label+Text, isHighlight-Rahmen) ohne Anwendungslogik | Workspace AI Pro | nein | nein |

**Zwischenzähler:** 4 Dubletten · 5 „teilweise" (nur als Bausteine, alle ghost) · 8 „nein".

---

## 4. Kandidaten-Audit (21)

| Kandidat | Urteil | Beweis (kompakt) | Empfehlung |
|---|---|---|---|
| ai_studio_code.py | ghost | 46 Zeilen reines google-genai-Beispielskript; `ls` vibe-sales-suite/verkaufs hub → nur die 13 Fragmente, kein Projektordner | Streichen — Google-Beispielcode ohne Eigenleistung |
| ai_studio_code (1).py | ghost | MD5 43bd327b… byteidentisch mit ai_studio_code.py | Als Duplett streichen |
| ai_studio_code.txt | ghost | mdfind „WorkspaceAIOrchestrator" → nur die Fragmente; `find ~/Claude -name '*.xcodeproj' -o 'Package.swift'` → leer; zusätzlich Duplett von (2).txt | Als ghost markieren + als Duplett streichen |
| ai_studio_code (1).txt | ghost | mdfind Orchestrator/seedMockData/„4-Stage Pipeline" → nur Fragmente; kein Swift-Projekt unter ~/Claude | Als ghost markieren — Prompt-Text als Baustein haltbar |
| ai_studio_code (2).txt | ghost | mdfind → nur Fragment selbst; kein Projekt | Als ghost markieren |
| ai_studio_code (3).txt | ghost | mdfind „4-Stage Pipeline" → nur (3)/(8)/(10) + unbezogene gstack-Tests; VibePortfolio/„*Portfolio*.swift" → leer | Als ghost markieren |
| ai_studio_code (4).txt | ghost | Markdown-Dump, kein Code; ls bestätigt nur Fragmentdateien | Streichen — Inhalt steckt bereits in INVENTAR-VOLL.md |
| ai_studio_code (6).txt | ghost | mdfind Orchestrator/seedMockData → nur Fragmente; find *.xcodeproj/Package.swift → leer | Als ghost markieren — Kern-Snippet mit Gemini-Logik, kein lauffähiges Projekt |
| ai_studio_code (7).txt | ghost | MD5 6b646d34… byteidentisch mit (6).txt | Als Duplett streichen |
| ai_studio_code (8).txt | ghost | mdfind seedMockData → nur (8)/(10); mdfind „Workspace AI Pro" → leer; kein Xcode-Projekt | Als ghost markieren |
| ai_studio_code (9).txt | ghost | mdfind → nur Fragment im verkaufs-hub-Ordner; kein Projekt | Als ghost markieren |
| ai_studio_code (10).txt | ghost | MD5 a7de4c69… byteidentisch mit (8).txt | Als Duplett streichen |
| ai_studio_code (11).txt | ghost | Fragment nur im verkaufs-hub-Ordner; mdfind/find ohne Projekt-Fund | Streichen — generisches UI-Utility |
| **OmniRoute** | **real** | `ls` → v3.8.50 „Unified AI router with 342 providers…", .git, Makefile, docker-compose.yml, src, tests, bin/omniroute.mjs; mdfind → LaunchAgent com.omniroute.autostart.plist | Ins Inventar — produktionsreif, laut INVENTAR-VOLL.md täglich im Einsatz; **API-Keys-Logik vor Verkauf säubern** |
| IRIS Neural OS | real (Referenz) | `ls` → package.json, src, testing, electron-builder.yml, docs; README „IRIS Neural OS — Voice-First Desktop AI Assistant", Badges → github.com/IRISX-AI/IRIS-AI, Sponsor 201Harsh | Nur als Referenz — Lizenz/Eigentum klären, **nicht als eigenes Tool listen** (fremdes Open-Source-Repo) |
| **LOKI.OS App v18** | **real** | Package.swift + Sources/LOKIOSApp mit 16 .swift-Dateien + gebaute „LOKI OS v18.app" (_CodeSignature), PLAN.md, build.sh | Ins Inventar — gebaut und dokumentiert; Verkauf nur als LOKI.OS-Suite sinnvoll |
| **Native Legal Ops** | **real** | `ls` `/Users/saschalagler/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/NativeLegalOps` → NativeLegalOps.xcodeproj + „NativeLegalOps 2.xcodeproj", 2 .app-Bundles, Package.swift, Sources, Tests; `find -name '*.swift' \| wc -l` → 36; zusätzlich installiert unter /Applications (mdfind) | Ins Inventar — gebaut und installiert; Doku vor Verkauf nachliefern (OFFEN-Liste: Doku/LICENSE/Notarization, nicht mehr „Repo finden") |
| Chipsi | ghost | MacOS enthält nur „app_mode_loader"; CFBundleIdentifier = Chrome-App-Shortcut-Bundle (com.google.Chrome.app.…); mdfind → nur Audit-/Archivordner, kein Quellprojekt | Als ghost markieren — kein Projekt/Code dahinter, nicht verkaufen |
| Auto Sync & Save | prototyp | `ls` → src, package.json („tanstack_start_ts", Vite-Skripte), README, roadmap; `ls -d .git` → kein .git | Als Prototyp markieren — erst fertigstellen oder streichen |
| LOKI Dashboard-App | prototyp | React+Vite-Skelett (package.json „dashboard-app" v0.0.0, src, dist, node_modules), kein .git | Als Baublock markieren — Skelett ohne Eigenwert, nicht einzeln verkaufen |
| Körperfluss PILOT.AI | prototyp | `ls` → index.html, dist, DESIGN.md, firebase-blueprint.json, audit_report.md + lokale Dubletten (körperfluss-pilot.ai/, .zip); weitere Kopie im Koerperfluss-3D-Upgrade (INVENTAR-VOLL.md) | Als Prototyp ins Körperfluss-Bundle; Dubletten streichen |

**Zwischenzähler:** 4 real · 3 prototyp · 14 ghost.

---

## 5. Preis-/Markt-Empfehlungen Top-5

> ⚠️ **Caveat:** WebSearch war am 10.10.2026 durchgehend 429 rate-limited — Wettbewerbs-Anker stammen aus Vorwissen + bestehenden Listings (`listing/*.md:19`). Vor jeder Veröffentlichung live prüfen.

| # | Tool | Preis | Kanal | Begründung (kompakt) |
|---|---|---|---|---|
| 1 | **native-legal-ops** | **999 EUR Einmallizenz** (Upsell: 2.490 EUR/Jahr Team-Upgrade) | b2b_direct | DSGVO-Argument „100 % lokal" zieht nur im Vertrauenskanal (LinkedIn/Netzwerke); CoCounsel ~100–150 USD/Nutzer/Monat, Harvey ab ~100k USD/Jahr massiv teurer; 101/110 E2E-Tests (Prüfbericht 02.10.2026) belegen Reife |
| 2 | **judicario-loki-voice** | **299 EUR Einmallizenz** pro Nutzer | b2b_direct | günstiger Dragon-Legal-Ersatz (Anker 600–900 EUR Einmallizenz, Vorwissen); im unteren Mittelfeld der 200–500-EUR-Range, weil adhoc-Signierung ohne Notarization bei compliance-sensiblen Käufern noch Blocker; 54/54 Unit-Tests stützen den Preis |
| 3 | **agent-mirror** | **79 EUR/Monat** (Team-Abo, Einstieg) | b2b_direct | laufende Cloud-Run-Infrastrukturkosten; SaaS-Marktstandard Dev-Infra 49–199 EUR/Monat (Vorwissen); zwischen alten Tiers 49/199 (listing/agent-mirror.md:19), weil Boilerplate-README + fehlende LICENSE die Reife drücken; Live-Betrieb verifiziert (HTTP 200) |
| 4 | **koerperfluss-3d-v2-upgrade** | **1.290 EUR/Jahr** pro Standort (bis 30 Nutzer) | klinik_lizenz | Institutionslizenzen über Bildungsnetzwerke; 3D-Anatomie-Education-Markt (Complete Anatomy/Visible Body) bedient genau diesen Kanal; MDR-freier Education-Ansatz klappt Regulatorik aus; übernimmt Empfehlung listing/koerperfluss-3d-v2-upgrade.md:19 — vor Verkauf: lokaler Clone + MIT-Lizenz-Klärung nötig |
| 5 | **paraletts-3d-shop** | **249 EUR einmalig (Shop-Bau) + 29 EUR/Monat (Hosting/Betreuung)** | b2b_direct | Direktverkauf der fertigen Site an vorhandenen Kunden; alte SaaS-Empfehlung 149/449 EUR/Monat (listing/paraletts-3d-shop.md:19) laut Real-Tool-Analyse nicht haltbar (kein Checkout/Repo) |

---

## 6. Nächste Schritte (max. 5)

1. **Lizenz-/Hygiene-Sprint:** für die 4 realen Tools LICENSE + Vertriebs-README nachliefern; **OmniRoute-API-Keys-Logik säubern** (INVENTAR-VOLL.md:31) und **IRIS-Lizenz/Eigentum klären** (Copyright Harsh Pandey) — bis dahin nichts listen.
2. **Native Legal Ops: Doku + LICENSE nachliefern** — Source-Repo ist gefunden (`…/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/NativeLegalOps`, 2 .xcodeproj + 36 .swift-Dateien, heute per `ls` verifiziert; der ältere Befund „nicht auffindbar" bezog sich nur auf den Desktop/Applications-Ordner); danach Doku (INVENTAR-VOLL.md:34) und 999-EUR-Angebot an Kanzleien.
3. **Sammel-Funde abarbeiten:** 3 „ja"-Kandidaten ins Inventar aufnehmen (agent-os-stack, ATLAS-App-Export, ATLAS-Master-App); 8 „unklar" in nächster Session klären (Eigentum/Verhältnis).
4. **Gumroad-Listings nur nach Nutzer-Review:** alle Top-5-Preise beruhen auf Vorwissen (WebSearch 429) — Markt live prüfen, Listings dem Nutzer zur Freigabe vorlegen.
5. **Schnellster realer Umsatz:** Bar-Bulls-Shop-Deal an bestehenden Kunden abschließen (249 EUR + 29 EUR/Monat) — Site steht, nur Deal + minimale Betreuungs-Doku nötig.

**Stopp-Regeln (bindend):**
- ❌ **Kein Deploy** — keine Firebase-/Cloud-Run-/Hosting-Aktionen in dieser Handoff-Phase.
- ❌ **Kein git push** — lokale Commits nur auf Nutzer-Anweisung.
- ❌ **Gumroad nur nach Nutzer-Review** (Listings + Preise).
- ❌ Keine Dubletten/Dateien löschen ohne Nutzer-Freigabe (nur markieren).
- ⚠️ OmniRoute-Code nicht anfassen, solange API-Keys-Logik drin ist (Security-Risiko).

---

## 7. Neue Sammel-Funde (13)

> **Gilt-Regel (Widerspruch zu TODO-ZIELE §6 gelöst):** Diese Tabelle listet nur **Erstsignale** aus dem Roh-Scan. **Verbindlich für die Aufnahme-Entscheidung ist TODO-ZIELE-2026-10-10.md §6** (2× Ja zur Bewertung nach GO, 11× Nein; Maßstab: Tool = Eintrag in `tools-v2.json`, INVENTAR-VOLL.md:6). Abweichende Einzeleinstufungen hier (z. B. ATLAS-Apps „ja") sind Roh-Signale, keine Entscheidung. **Zahlenkollision entkräftet:** die 8 „unklar" hier ≠ die **8 INVENTAR-Kandidaten** (5-Zonen-Scan, INVENTAR-VOLL.md:13, Commit `c595bca`), auf die OFFEN #12 in TODO-ZIELE zielt — nicht dieselben Objekte.

| Name | Pfad | Signal | Aufnehmen? |
|---|---|---|---|
| loki-os-app-v17 | `/Users/saschalagler/loki-ki/macos-app-v17` | Vorversion der LOKI-OS-App: Swift-Package (Package.swift + Sources/) + Python-Daemon (LOKI_MASTER.py, loki_daemon.py, watcher.py) + RAG-Orchestrator (loki_unified_rag_orchestrator.ts) | **nein** — von v18 (im Inventar, real) abgelöst |
| loki-voice | `/Users/saschalagler/loki-ki/loki-voice` | Python-Voice-/Live-Übersetzung mit MCP-Server (loki_voice.py, start_mcp_server.sh, requirements.txt, Tests, WIKI.md); id-Match-Check: nur „judicario-loki-voice", anderer Pfad | **unklar** — Verhältnis zu judicario-loki-voice klären |
| loki-hud | `/Users/saschalagler/loki-ki/loki-hud` | Python-Terminal-HUD (hud.py) mit README + LOKI_DEV_PLAN.md (LOKI-Agenten-Status) | **unklar** — internes Utility, geringer Einzelverkaufswert |
| loki-mind-ios | `/Users/saschalagler/loki-ki/ios/loki-mind-ios` | SwiftUI-iOS-App (ContentView.swift, ShareViewController.swift, Info.plist) als Mobile-Anbindung für LOKI-Mind | **unklar** — nur 3 Dateien, Skelett |
| lokitrigger-ios | `/Users/saschalagler/loki-ki/ios/LokiTrigger` | Xcode-Projekt „CALO COACH ATLAS .xcodeproj" + LokiTrigger-App-Ordner (iOS-Trigger/Reminder für Cali-Coach) | **unklar** — ATLAS-Familie, Scope ungeklärt |
| agent-os-stack | `/Users/saschalagler/agent-os` | Python-Agent-OS-Framework agentos/ (orchestrator.py, router.py, discovery.py, slicer.py, engines.py, security/) + CLI + run_tests.py + Testinfra; Inventar kennt nur „loki :: loki-ki", nicht agent-os | **ja** |
| chitchat-macos | `/Users/saschalagler/Documents/GitHub/ChitChat` | fertiges macOS-Xcode-Projekt (ChitChat.xcodeproj, WhatsMac, Sparkle.framework, update_appcast.xml) — WebView-Chat-App mit Auto-Update | **unklar** — Eigentum/Lizenz ungeklärt (GitHub-Klon?) |
| mywhoop-go | `/Users/saschalagler/Documents/GitHub/mywhoop` | vollständiges Go-Projekt (go.mod, main.go, internal/, cmd/, export/, Dockerfile, main_test.go) — WHOOP-Datenexport-/Analyse-CLI | **unklar** — Eigentum/Lizenz ungeklärt |
| scite-zotero-plugin | `/Users/saschalagler/Documents/GitHub/scite-zotero-plugin` | TypeScript-Zotero-Plugin (package.json, bootstrap.ts, esbuild.js, client/, typings) | **unklar** — Eigentum/Lizenz ungeklärt |
| antigravity-rutherford | `/Users/saschalagler/Documents/antigravity/agitated-rutherford` | Python-Loki-Orchestrator-Workspace (loki_orchestrator.py, loki-run.sh, workspace/, multi_doc_reconciliation, TEST_INFRA.md) mit lauffähigem Code | **nein** — interner Agent-Arbeitsraum, kein Produkt |
| antigravity-einstein | `/Users/saschalagler/Documents/antigravity/quirky-einstein` | Python-Agent-Projekt (pyproject.toml, uv.lock, main.py, skills/-Ordner, README) — Skills-basiertes Agentenset (uv-Workflow) | **unklar** — README vorhanden, Scope ungeklärt |
| atlas-calisthenics-coach-app | `/Users/saschalagler/Desktop/Applications/ATLAS Calisthenics Coach.app` | signiertes macOS-App-Bundle (Contents/MacOS + Resources + Info.plist); Inventar hält nur die Quellordner (Atlas Cali Plan, ATLAS_MASTER), nicht den gebauten Export | **ja** — ins ATLAS/Körperfluss-Bundle |
| atlas-master-app | `/Users/saschalagler/Desktop/Coworkspace_Ich/atlas + pliability /ATLAS_MASTER/app` | Capacitor-Hybrid-App (package.json, src/, ios/, android/, dist/, firebase.json) — Master-Build des Cali-Coach, nicht im Inventar | **ja** — ins ATLAS/Körperfluss-Bundle |

**Zwischenzähler (Erstsignale):** 3 ja · 2 nein · 8 unklar — **verbindlich gilt TODO §6: 2× Ja · 11× Nein** (Gilt-Regel oben).

---

*Erstellt vom Handoff-Schreiber am 2026-10-10. Grundlage ausschließlich der gelieferten Ergebnis-Arrays; keine eigenen Nachforschungen, keine erfundenen Werte.*
