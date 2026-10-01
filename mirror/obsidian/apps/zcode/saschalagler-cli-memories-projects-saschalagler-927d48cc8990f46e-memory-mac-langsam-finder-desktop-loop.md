---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/mac-langsam-finder-desktop-loop.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

---
name: mac-langsam-finder-desktop-loop
description: 01.10.2026 Diagnose Mac-Langsamkeit — Finder 100% CPU Endlos-Loop,
  Wurzel = 679k Desktop-Dateien + iCloud Desktop-Sync; deja hook-refresh Runaway
  gekillt; 6 GB Caches freigemacht; 2 GO-Punkte offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_31052e71-1af0-456d-92ea-d03c480959da
---

01.10.2026, ~11:40 Uhr: Saschas M4-Mac langsam. **Wurzel bewiesen: 679.326 Dateien auf `~/Desktop` (70 GB, „Dokumente"-Ordner allein 53 GB) + iCloud „Desktop & Dokumente"-Sync aktiv (`defaults read com.apple.finder FXICloudDriveDesktop` = 1) → Finder hängt in endloser `CA::Transaction`/`NSWindow`-Layout-Schleife (100 % CPU seit Boot, Neustarts inkl. geleertem Saved-State bringen nichts, AX-Abfrage bricht nach 8 s bei 22 Elementen ab).** WindowServer ~50 % = Folgeschaden. Ausgeschlossen: Finder-Fenster-State, Cloud-Extensions (Google Drive/Gemini/OneDrive FinderSync, 3× via `pluginkit -e ignore` deaktiviert — CPU blieb 96 %).

Erledigt mit Beweis:
- **`deja hook-refresh`-Prozess** (PPID 1, 2,5 min Laufzeit) frisst 3,5 GB RAM + 104 % CPU → gekillt, weg ([[deja-vu-install]]). 
- **~6 GB Caches gelöscht:** `~/.cache/uv` (4,9 GB, via `uv cache clean`), npm (586 MB), `~/.cache/huggingface/hub` (464 MB). APFS zeigt freed space verzögert (df 38 Gi frei, 92 % belegt).
- Swap (RAM-Überlauf auf SSD) 547 MB → 1,6 GB gestiegen; ~6 ZCode-Sessions/Prozesse gleichzeitig offen (je 100–450 MB).

**Why:** Nie wieder neu diagnostizieren — die Kette Desktop-Masse × iCloud-Sync × Liquid-Glass-Rendering ist die Erklärung; Extensions/Fenster waren Red Herrings.

**How to apply:** Offene GO-Punkte (nur mit Saschas GO ausführen): (1) **DER FIX:** `mv ~/Desktop/Dokumente ~/Dokumente/Desktop-Dokumente` (53 GB, gleiche Volume = Sekunden-Rename; Sascha soll Zielort bestätigen) — danach ~100 Desktop-Dateien, Finder normal. (2) Ollama-Modelle `qwen2.5-coder:7b` (4,7 GB) + `:1.5b` (986 MB) löschen (+5,7 GB; Sascha nutzt laut Memory nur glm-cloud). Extensions-Revert: `pluginkit -e use -i com.google.drivefs.finderhelper.findersync` (+ Gemini/OneDrive analog). Mac-Neustart löst NICHT — Loop kommt sofort zurück, solange der Desktop voll bleibt.
