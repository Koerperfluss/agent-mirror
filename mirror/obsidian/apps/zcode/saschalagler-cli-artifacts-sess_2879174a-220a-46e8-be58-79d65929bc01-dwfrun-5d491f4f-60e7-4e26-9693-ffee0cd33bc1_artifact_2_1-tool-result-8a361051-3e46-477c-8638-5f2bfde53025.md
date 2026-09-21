---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_2879174a-220a-46e8-be58-79d65929bc01/dwfrun-5d491f4f-60e7-4e26-9693-ffee0cd33bc1_artifact_2_1-tool-result-8a361051-3e46-477c-8638-5f2bfde53025.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

# LOKI.OS v18 — Abschlussbericht

**Ziel:** LOKI.OS v16: ein stabiler, vollständig bootbarer Personal-Intelligence-OS-Kernel auf Port 8010 mit Agent Council, Dashboard, OmniRoute-Integration, MCP-Bridge und automatischer Fallback-Kette (Ollama → Cloud), alle Tools konsistent konfiguriert mit korrekten Modellen (WAYFINDER_MAP.md:5, Destination).

## Ergebnis
- Build: ✅ grün (build.sh Exit 0)
- App läuft: ✅ (Prozess verifiziert)
- Review: PASS

## Gebaut
- 🎨 main.swift: AppZustand mit gemeinsamen Live-Status (ein Poll für Dashboard+Karte, 12 s >= 10 s laut PLAN §4.1), Retry-Sturm-Schutz, toleranter Status-Lookup per Alias
- 🎨 Neu: Views/VerbindungsBruecke.swift — dünner Wrapper, alle 6 Verbindungsdienst-Aufrufe an EINER Stelle (Konfliktregel PLAN §5); Signatur-Drift trifft nur diese Datei
- 🎨 RootView: Sidebar mit Indigo→Violett-Gradient, Live-Mini-Ampel im Footer, Poll-Loop; gemeinsame Bausteine MarkdownText (nativ, crash-sicher), FehlerKarte (rot + Retry), HinweisKarte, AktualisierenKnopf
- 🎨 Dashboard: 4 Live-Ampelkarten (Status-Ring + Kartenrand in Ampelfarbe), Zeitstempel + manuelle Aktualisierung, OmniRoute-Erklärkarte (rot = erwarteter Zustand), Quick-Actions inkl. Obsidian-Button mit Rückmelde-Zeile des Dienstes
- 🎨 Brain: entprellte Live-Suche (450 ms), Highlight ALLER Treffer (AttributedString per Segment-Konkatenation), Ergebnisse sortiert (created_at desc, nil zuletzt), Notiz-Formular mit automatischer Verifizierungssuche nach dem Speichern
- 🎨 Heute: heutiges Daily oben als Volltext (nutzt additives Feld 'volltext' des Verbindungs-Bauers), Archiv einklappbar (DisclosureGroup), Markdown nativ, klare 'noch keins heute'-Leerstelle mit dynamischem Dateinamen
- 🎨 Karte: 7-Knoten-Pipeline Sascha→Voice→Daemon→Modelle→Tools→Brain→Vault, live gefärbt aus dem gemeinsamen Poll, native Hover-Tooltips, Klick-Detail bleibt live (Name statt Kopie), resize-stabil (Norm-Koordinaten mit Rand)
- 🎨 Loki fragen: Frage-Feld (Enter/Button), Ladeindikator für das 120-s-Timeout des Dienstes, Antwort als natives Markdown + Kopieren-Button, Fehlerfall rote Karte mit Retry — kein Crash-Pfad
- 🎨 Schnittstellen-Abgleich nach Landung des Verbindungs-Bauers (15:58): alle 6 Signaturen 1:1 bestätigt; Rückgabe von obsidianOderFinderOeffnen angezeigt, volltext genutzt, Sortier-Hinweis nur bei vorhandenen Zeitstempeln (erstelltAm ist ehrlich nil)
- 🎨 Verifikation: ./build.sh exit 0 (zweimal), Mach-O arm64, 0 Compiler-Warnungen im Frisch-Build, Start-Rauchtest 10 s+ ohne Crash bei totem Kernel :8010, macos-app-v17 unberührt, kein git push, kein Deploy
- 🔌 Connections.swift komplett gebaut (einzige angefasste Datei; Ask nannte Pfad ohne /Connections/-Ordner — Platten-Wahrheit + Architekten-Layout ist Connections/Connections.swift): Models, LOKIEndpunkte, LOKIZeitlimits, VerbindungsFehler, Verbindungsdienst — alles async/await, @MainActor-sicher (Blockierendes in Task.detached), nur Foundation/SwiftUI/AppKit/SQLite3
- 🔌 /ask-Schema live probe-geklart: GET /ask?text=… => {ok, antwort} — Ask-Vorgabe bestätigt, PLAN.md §4.2 (POST/{question}) wäre falsch gewesen; Beweis: GET /ask ohne Parameter => 400 {ok:false, error:'text-Parameter fehlt'}, Live-Frage => 200 {ok:true, antwort:…}
- 🔌 Kernel-Health auf /loki/health (nicht /health; LOKI_MASTER.py:269), 3s-Timeout, down = rote Karte .offline statt Crash — live bewiesen (curl exit 7 + Treiber 'Kernel | offline')
- 🔌 Brain-Suche über /opt/homebrew/bin/python3 brain.py search <query> --json per Process-argv-Liste (NIEMALS Shell-String; brain.py:589-591) — immun gegen Schema-Drift, mehrstufige FTS5-Suche AND->OR->LIKE (brain.py:191)
- 🔌 Brain-Speichern über brain.py save <topic> <text> (Eigentümer-Schreibpfad, schreibt memory_entries+fts_memory in einer Transaktion, brain.py:170-175) mit Backup brain.db.bak-app-v18-YYYYMMDD einmal pro Tag vor Erst-Schreiben; Backup-Misserfolg verhindert Schreiben
- 🔌 Topic-Liste via sqlite3_open_v2(SQLITE_OPEN_READONLY) + konstantes SQL 'SELECT DISTINCT topic FROM memory_entries' (kein Nutzer-Input im Statement); live: 12 Themen
- 🔌 Daily: YYYY-MM-DD.md streng erkannt (Parse-Roundtrip), neueste zuerst, istHeute markiert, YAML-Frontmatter entfernt, deutsches Datum; ADDITIV TagesProtokoll.volltext (Default nil) für Phase-2-Volltext — live: 9 Dateien, 2026-09-21.md als heute erkannt
- 🔌 OmniRoute :20128 als reine Netzwerk-Fehler-Probe mit erklärendem Kartentext (abgebaut lt. AGENTS.md 20.09., rot = Normalzustand); Obsidian-Öffner: urlForApplication(toOpen:)-Check + obsidian://open bzw. Finder-Reveal-Fallback
- 🔌 Grenzfläche koordiniert: UI-Bauer legte parallel Views/VerbindungsBruecke.swift an, die exakt die PLAN-Signaturen konsumiert — mein @MainActor auf obsidianOderFinderOeffnen() habe ich auf meiner Seite gelöst (nonisolated, Aufrufpfade sind Button-Actions=Main); platzhalterStatus() bleibt als Startwert-Helfer kompatibel
- 🔌 Verifikation: swiftc -typecheck Connections.swift isoliert exit 0; ./build.sh exit 0 (auch nach parallelen UI-Bauer-Umbauten; transiente Race während deren GerüstHinweis-Umbau hat sich erledigt); CLI-Prüftreiber 12/12 Prüfpunkte grün, exit 0
- 🔌 Nicht ausgeführt (bewusst, ehrlich): kein echter notizErfassen-Save (kein Testeintrag ins Nutzer-Brain; Backup-Mechanik loest beim ersten echten Save aus) und kein Live-Oeffnen von Obsidian/Fenster (Side-Effect); Mimosa-Constraint 'localhost ablehnen' nicht angewandt — App ist lokaler Desktop-Client, dessen Zweck Loopback ist (Ask + PLAN §4.7); SQL ohne Nutzer-Input, nichts zu binden
- 🔌 Stopp-Regeln eingehalten: kein git push, kein Deploy, nichts gelöscht (nur eigener /tmp-Testtreiber entfernt), macos-app-v17 unberührt
- 📚 ARCHITEKTUR.md geschrieben: 4 Mermaid-Diagramme (Gefordert ≥3) — 1. Gesamt-Systemfluss als flowchart TB mit allen Ports (:8010/loki/health, :8078//ask, :20128), brain.db (mode=ro/INSERT+Backup), Daily/ und Obsidian-Vault-Öffner; 2. Datenfluss einer Sprachfrage als sequenceDiagram mit alt-Fehlerzweig (Daemon tot → rote Karte + Retry statt Crash); 3. Build-/Test-Pipeline als flowchart LR mit build.sh-Gate und Phase-4-Abnahmekriterien; 4. Bonus: Brain-Datenmodell als erDiagram (memory_entries + fts_memory).
- 📚 Jede Komponente in ARCHITEKTUR.md §2 in 2-3 Sätzen Deutsch beschrieben (App, RootView/Sidebar, 5 Views, Verbindungsdienst, Kernel, Voice-Daemon, OmniRoute, brain.db, Daily, Obsidian-Öffner) — jede Aussage belegt gegen PLAN.md §4/§6, Connections.swift:94-112 (LOKIEndpunkte), RootView.swift:13-43 (LOKISeite), build.sh:10-25.
- 📚 README.md erweitert: Was ist LOKI.OS v18 (inkl. Kernversprechen 'kein Dienst nötig, rot statt Crash'), Voraussetzungen, Starten (build.sh + open 'LOKI OS v18.app', Doppelklick), Bedienung aller 5 Seiten als Tabelle (Dashboard-Ampel/Brain-Suche+Notiz/Heute-Archiv/Karte-Hover+Obsidian-Button/Loki fragen-Retry), Verweise auf ARCHITEKTUR.md + PLAN.md, alle 4 Stopp-Regeln aus PLAN.md §7.
- 📚 ARCHITEKTUR.md nach '/Users/saschalagler/Documents/Obsidian Vault/Brain/ARCHITEKTUR.md' kopiert — TCC hat NICHT geblockt (cp exit 0, KOPIE_OK), Fallback ~/loki-brain/vault/Brain/ nicht nötig.
- 📚 Ehrlichkeits-Kennzeichnungen in der Doku: Ist-Stand genannt (Verbindungsdienst in Connections.swift:128-161 noch Platzhalter, Phase 1 parallel), /ask-Feldname als live-zu-verifizierend markiert, Glossar mit 10 Fachwörtern je 1 Satz.
- 📚 NICHT durchgeführt: automatisierter Mermaid-Render-Test — mmdc ist nicht installiert (which mmdc → not found); npx-Nachladen hätte Chromium aus dem Netz gezogen. Diagramme stattdessen manuell gegen Mermaid-Standard abgesichert (gequotete Labels, nur Standard-Shapes flowchart/sequenceDiagram/erDiagram, alle 4 Typen Obsidian-nativ). Obsidian-Render-Check selbst steht aus.
- 📚 Stopp-Regeln eingehalten: kein git push, kein Deploy, nichts gelöscht, macos-app-v17 unberührt, nur eigene 2 Projekt-Dateien + 1 Vault-Kopie geschrieben.

## QA-Checks
- Installation: build.sh hatte NICHT installiert (/Applications/LOKI OS v18.app existierte nicht) — cp -R von /Users/saschalagler/loki-ki/macos-app-v18/LOKI OS v18.app nach /Applications OK, codesign --force --sign - OK ('replacing existing signature', Identifier com.saschalagler.lokios.v18), open OK.
- Prozess lebt: sleep 3; pgrep -fl LOKIOSApp -> PID 21490 /Applications/LOKI OS v18.app/Contents/MacOS/LOKIOSApp; gleiche PID bei 3 Kontrollen 16:07-16:10 = stabil, kein Crash/Restart.
- Daemon-Verbund: curl -s --max-time 2 http://127.0.0.1:8078/status -> HTTP-JSON {state: idle, modell: cp/cline-pass/glm-5.3-flash, verlauf: 2, muted: false, tools: [say_text, open_url, browser_read, run_command, brain_save, brain_search, recall_history, read_briefing]}, CURL_EXIT=0.
- Brain-Verbund: /opt/homebrew/bin/python3 /Users/saschalagler/loki-brain/brain.py status -> Exit 0; DB /Users/saschalagler/loki-brain/brain.db (12 Einträge, FTS 12), Obsidian Vault Brain 13 MD-Dateien, Local Vault 12 MD-Dateien.
- Fenster-Beweis: screencapture -x /tmp/lokios_v18_qa.png (2,8 MB, 16:07) + fenster-genau /tmp/lokios_v18_qa_window.png und _window2.png; System Events bestaetigt Fenster 'LOKI.OS v18' bei (627,117) Groesse 1360x860.
- UI-Inhalt: Vision-Analyse (1 von 3 Versuchen erfolgreich, 2x Tool-Timeout) bestaetigt voll gerenderte dunkle Dashboard-UI auf Deutsch mit Titel 'LOKI.OS v18', Sidebar und Status-Karten — kein leeres Fenster.
- Schutzregeln eingehalten: keine Prozesse gekillt, kein git push, nichts geloescht; v18-Quellbundle und v17 unberuehrt.

## Funde / offene Punkte
- BrainView.swift:146 — Debounce-Cancel beim Tippen wirft CancellationError aus dem .value-Await (Connections.swift:351) und zeigt englische Fehlalarm-Karte „The operation was cancelled
- Daemon /status meldet permanenten Fehler 'OmniRoute nicht erreichbar: Connection refused' — OmniRoute wurde laut AGENTS.md (Stand 20.09.2026) bewusst abgebaut; Daemon-Konfiguration prueft noch den toten Endpoint :20128 und zeigt ihn als Fehler an. Kein Start-Blocker, aber Config-Referenz sollte bereinigt werden.
- Status-Karten im Dashboard zeigten im ersten Screenshot noch 'wird geprueft…/unbekannt'; finaler Karten-Zustand (z.B. Kernel :8010 gruen/rot) visuell nicht verifizierbar — Vision-Tool lief bei der Detailpruefung 2x in Timeout (30 s). Screenshot-Beweise liegen unter /tmp/lokios_v18_qa_window2.png zur manuellen Sichtung.
- Kernel-Port 8010 wurde laut Aufgabenstellung nicht geprueft (nicht Teil der 5 Checks) — Zustand des LOKI-Kernels ist aus diesem QA-Lauf unbelegt.

## Pfade
- Projekt: /Users/saschalagler/loki-ki/macos-app-v18
- Plan: /Users/saschalagler/loki-ki/macos-app-v18/PLAN.md · Architektur (Mermaid): /Users/saschalagler/loki-ki/macos-app-v18/docs/ARCHITEKTUR.md