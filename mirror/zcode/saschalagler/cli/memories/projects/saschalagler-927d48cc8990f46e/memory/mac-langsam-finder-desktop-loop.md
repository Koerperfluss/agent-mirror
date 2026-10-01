---
name: mac-langsam-finder-desktop-loop
description: 01.10.2026 Diagnose Mac-Langsamkeit — Finder 100% CPU Endlos-Loop;
  deja-Runaway gekillt, 6 GB Caches frei, 53-GB-Dokumente-Ordner vom Desktop
  verschoben; Loop bleibt, Entscheidung iCloud-Sync-aus vs. node_modules offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_31052e71-1af0-456d-92ea-d03c480959da
---

01.10.2026, ~11:40–12:00 Uhr: Saschas M4-Mac langsam. **Diagnose bewiesen:** 679.326 Dateien auf `~/Desktop` + iCloud „Desktop & Dokumente"-Sync (`FXICloudDriveDesktop = 1`) → Finder-Endlos-Loop `CA::Transaction`/`NSWindow`-Layout, ~96–100 % CPU über alle Neustarts, AX-Abfrage bricht nach 8 s bei 22 Elementen ab. Load bis 17, Swap 1,6 GB (~6 ZCode-Sessions je 100–450 MB offen).

Erledigt mit Beweis:
- **`deja hook-refresh`-Runaway** (3,5 GB RAM + 104 % CPU) gekillt → 0 Prozesse; Saschas eigener Aktivitätsmonitor-Screenshot bestätigt „deja (Beendet)".
- **~6 GB Caches gelöscht:** `uv cache clean` (4,9 GB), npm (586 MB), `~/.cache/huggingface/hub` (464 MB). APFS bucht verzögert → df 38 Gi, aber Speicher-Settings zeigen 102 GB verfügbar + „61 GB löschbar" (purgeable) — kein Widerspruch.
- **53-GB-Dokumente-Ordner vom Desktop weg:** `mv ~/Desktop/Dokumente ~/Documents/Desktop-Dokumente` (0,006 s, Volume-Rename; nur ~3.077 Dateien drin). Desktop: 70 GB → **17 GB**, aber Loop blieb (96 %).
- Isolationstests alle NEGATIV (Setup jeweils restauriert): Fenster-Saved-State geleert, 3 FinderSync-Extensions via `pluginkit -e ignore` (→ `use` zurück), `CreateDesktop false` (→ true zurück).

**Wahre Rest-Ursache:** **628.820 der 676k Dateien stecken in `~/Desktop/Coworkspace_Ich` (9,7 GB, 24 `node_modules`-Ordner)** + 42.672 in „PRojekte ". Extensions/Icons/Fenster waren Red Herrings.

**Diagnose-Fallen (nie wieder):** (1) `ps aux | grep 'MacOS/Finder'` matcht auch Gemini/OneDrive/Google-FinderSyncExtension-Helper — echten Finder per höchster PID NACH `sleep`-Abstand zum killall identifizieren (ohne sleep sampelt man die Extension, CPU 0). (2) Ordner physisch `~/Documents`, nicht `~/Dokumente` (deutsche Namen sind nur Finder-Anzeige). (3) `mv` auf gleichem Volume = O(1)-Rename, trotz 53 GB.

**Nachtrag 01.10. ~12:00 („seit gestern"-Wurzel + Disk-Entlastung bewiesen):** Auslöser = Saschas Nachtsession bis 02:57 (antigravity-Zeitstempel) → Schreibflut (WhatsApp-iCloud-Backups Media/Document/Video.tar, CloudDocs client.db, deja-Index-Wachstum) drückte Disk auf 92 %. **`tmutil thinlocalsnapshots / 999999999999 4` → Disk 39 → 82 GB frei (92 % → 82 %)** — größter Sofort-Hebel, safe. **Docker.raw = 72 GB** (`~/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw`), Docker läuft NICHT aktiv (nur vmnetd-Helper) — größter einzelner Disk-Fresser. **macOS-BETA im Einsatz: 27.2 Build 26B5091g (g = Seed)** — Liquid-Glass-Finder-Loop ist plausibel ein Beta-Bug; Softwareupdate prüfen ist Ultimativ-Lösung. deja hook-refresh sprang 3× wieder an (88–104 % CPU, 2–3,5 GB, bei JEDEM Session-Start) = reproduzierbarer Bug.

**How to apply — offene Entscheidung an Sascha (Stand 01.10.):** (1) **Empfehlung: iCloud „Desktop & Dokumente"-Sync AUS** (Systemeinstellungen → Apple-ID → iCloud → Drive) — Dateien bleiben lokal, wahrscheinlichstes Loop-Ende, umkehrbar. (2) Optional: 24 `node_modules` löschen (regenerierbar via `npm install`, ~600k Dateien weg; bricht Dev-Server bis reinstall). (3) Ollama-Modelle `qwen2.5-coder:7b` (4,7 GB) + `:1.5b` (986 MB) löschen = +5,7 GB (nur glm-cloud in Nutzung). Mac-Neustart löst NICHT — Loop kommt zurück, solange 628k Dateien + Sync aktiv. ⚠️ Sascha ist frustriert von Jargon — Berichte in einfachen Sätzen + Tabellen, keine Fachwort-Wände ([[sascha-arbeitsregeln-hart]]).
