---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/ssd-cache-automation.md"
stand: 2026-10-30
tags: [spiegel, zcode]
---

---
name: ssd-cache-automation
description: 18.09. SSD-voll-Diagnose + tägliche Cache-Bereinigung-Automation
  (automation-03ce4628)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_66536c69-6d4a-4f36-a9c7-b1c72c2a20b1
---

18.09.2026: Data-Volume 371/460 GB belegt (nur 29 GB frei). Größte Brocken: **~/Desktop 79 GB** (Saschas Dateien, nie löschen), `/private/var/folders/…/X` **25 GB** Temp-Cache, ~/Library 56 GB (App Support 17 GB, iCloud 16 GB), CoreSimulator 1,5 GB.

**Automation erstellt:** `automation-03ce4628-a0a0-4e42-b807-8650402c7471` „Tägliche SSD-Cache-Bereinigung (12 Uhr)", cron `0 12 * * *`, löscht nur Caches mit Altersfilter (mtime +2/+3 Tage): var/folders X+T, ~/Library/Caches, ~/.cache, npm-cache, `simctl delete unavailable`, Trash. Schutzliste: Desktop/Documents/Pictures/Music/Downloads/Mobile Documents/Application Support/Repos.

**18.09. Erweiterung:** Automation nutzt jetzt **Mole-CLI** (`mole clean`, Homebrew `/opt/homebrew/bin/mole`) als Schritt 1. Tool-Inventar: CleanMyMac NICHT installiert; Vorssaint = GUI-only (Fenster/Clipboard, kein Cleaning-CLI). Erster Live-Lauf 18.09.: Mole +1,54 GB, var/folders 26→4,3 GB. Mole "Large files"-Vorschläge (LM-Studio 14 GB, Docker 5,8 GB) IMMER überspringen — Schutzliste im Automation-Prompt.

**18.09. Runde 2 (nach Saschas Wut — rechtlich: er hatte recht, 163 Brew-Pakete):** Volle Inventur: 47 Apps in /Applications, 156 Brew-Formeln + 8 Casks. **CleanMyMac = Setapp-Version, DEINSTALLIERT** — nur Leichen; LaunchDaemons/PrivilegedHelper gelöscht (sudo frei), 9 Application-Scripts-Reste in ~/Library (mas/setapp-Varianten). **Vorssaint 3.3.5 = GUI-only UND fernsteuerungs-resistent**: Fenster (Display 2, 1467×953) lehnt synthetische Mausklicks ab („declined left mouse down", Overlay-Layer) → NIE wieder GUI-Automatisierung versuchen, nur Sascha von Hand. Brew cleanup brachte nur 175 KB (war sauber). Endstand 18.09.: **42 GB frei** (Start 29 GB), var/folders stabil 4,3 GB.

**18.09. Runde 3 (Agenten-Recherche, Sascha-Instanz „es verwaltet nichts"):** Vorssaint-Agent bewies aus CHANGELOG.md/Info.plist: Homebrew-Modul = nur GUI für install/uninstall/update, KEIN brew cleanup; Cleaner-Modul räumt App-Reste/Caches/Logs/iOS-Backups in den PAPIERKORB, läuft bei Sascha schon täglich automatisch (cleanerScheduleFrequency=daily, nur ~40 MB/Tag — manueller Vollscan ist die echte Wirkung); KEINE Automatisierung (kein CLI/URL-Scheme/Shortcuts). **Top-20-Disk-Analyse (361 GB):** 1. Desktop/Dokumente/Barbulls 34 GB (davon „MEDIE: PLÄNE" 24 GB!) · 2. ~/.lmstudio 16 GB · 3. Musik aktuell 9,6 GB · 4. ~/.gemini/antigravity 9,2 GB · 5. Fotos 7,2 GB · 6. **~/.zcode/cli/rollout 7,8 GB — ALLE Dateien jünger als 30 Tage = aktiv, NICHT löschbar** · 7. Docker 5,8 GB. Endstand 18.09.: 42 GB frei (Start 29 GB). 3 GO-Hebel angeboten: Barbulls-Medien weg (24 GB), ungenutzte LM-Studio-Modelle, Antigravity-Cache-Prüfung — wartet auf Saschas Nummer.

Echte Entlastung braucht zusätzlich manuell: Desktop ausmisten (79 GB) — Sascha-Entscheidung.

**13.10.2026 Stand:** `df` = **73 GiB frei** (05.10.: 42 GiB → **+31 GiB** in ~1 Woche). Ursache unbestätigt (Attribution): Kandidat ist diese Automation (12-Uhr-Läufe beim gelegentlichen Mac-Aufwachen in der Funkstille-Woche) — Nachweis über ihr Automation-Log möglich, nicht geprüft. Meldung im Abend-Brief der Tages-Routine ([[zcode-adhs-automationen]]).

**30.10. Ordner-Klärung nach Saschas Wut („für was reinigst du… was ist das… 40 GB Application Support?"):** Er fürchtete, die Automation lösche seine Sachen — widerlegt: Automation fasst NUR var/folders X+T, ~/Library/Caches, ~/.cache, Trash an. Klare Zuordnung (gemessen): `~/.ollama/models/blobs` **15 GB = Ollama-Modell-Gewichtsdateien** (qwen2.5-coder:7b u. a., BrowserOS-Hauptmodell) → BEHALTEN; `~/Claude/Projects/TOOL SAMMLUNG VERKAUF/AI_STUDIO_EXPORTS` **3,3 GB, 807 Objekte (erstellt 30.08.) = seine exportierten AI-Studio-Tools, Verkaufs-Warenlager** → BEHALTEN; App Support ~37 GB Top: **Autodesk 12 GB — aber Autodesk NICHT als App installiert = Restdaten → EINZIGER Lösch-Kandidat, wartet auf GO** (Backup zuerst), autoclaw 3,9 GB, FileProvider/CloudDocs je 2,4 GB, Google 2,1 GB, BrowserOS 1,5 GB. SSD-Stand 30.10.: 36–39 GB frei, purgeable-Specher füllt Platte über Nacht scheinbar (~40 GB Schwankung normal, kein echtes Wachstum); Gesamtbelegung wächst langsam real (361→383 GB in 6 Wochen) — Treiber: Desktop ~70 GB, CoreDevice 19 GB, LM-Studio 14 GB, Autodesk-Rest 12 GB.

**30.10. Runde 2 („rede ich undeutlich?"): Kern-Klärung geliefert — die Platte bleibt voll, weil sie NICHT von Müll voll wird, sondern von FESTEN Brocken, die kein Cleaner anfassen darf. Neu gemessen:** **`~/.zcode/cli/rollout` (ZCode-Chat-Verläufe) 7,8→25 GB in 6 Wochen = größter Wachstums-Treiber!** · Autodesk-Reste 12 GB · .ollama 16 GB (806 Blob-Dateien intakt, behalten) · .gemini 11 GB · .lmstudio 8 GB. **2 GO-Angebote mit Kurzbefehl gestellt, wartet auf Saschas Antwort:** **„ja zcode"** = löscht 25 GB alte Chat-Logs (verliert alte ZCode-Chat-Historie!) · **„ja autodesk"** = sichert + löscht 12 GB Reste. Sascha wiederholte dieselbe Frage nach der Klärung → nächstes Mal noch kürzere, tabellenlose Antwort mit Löschen JA/NEIN pro Punkt.
