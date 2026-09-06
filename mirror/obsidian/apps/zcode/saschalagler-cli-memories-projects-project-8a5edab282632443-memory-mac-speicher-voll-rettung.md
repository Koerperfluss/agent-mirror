---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/mac-speicher-voll-rettung.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: mac-speicher-voll-rettung
description: GELÖST 06.09. — Mac 22→74 GB frei per brctl evict (iCloud-Offline-Kopien
  freigegeben, nichts gelöscht); evict/download-Technik, .DS_Store-Falle, Logs in
  ~/Desktop/SPEICHER-RETTUNG; offen mit Sascha-OK: .lmstudio, Docker.raw, PRojekte
metadata:
  node_type: memory
  type: project
  originSessionId: sess_3ffe33ff-d0c0-4639-a973-ab1d721343be
---

**ERGEBNIS 06.09.2026 22:25: 22 GiB → 74 GiB frei (~52 GB gewonnen), NULL Dateien gelöscht.** Beweis-Logs: `~/Desktop/SPEICHER-RETTUNG/` (00-baseline.log, 01-evict.log, 02-ERGEBNIS.md).

**Kernbefund (korrigiert):** Storage-Dialog-Zahlen sind IRREFÜHREND („iCloud Drive verwendet 6,70 GB, Offline 100,86 GB") — Wahrheit steht in Systemeinstellungen→Apple Account→iCloud: **2-TB-Plan, 1,2 TB genutzt, Drive 373,5 GB in der Cloud**. Schreibtisch&Dokumente-Sync UND „Mac-Speicher optimieren" waren schon AN. Problem war nur: Mac hielt ~100 GB Offline-Doppel-Kopien fest. Er hat zusätzlich Google Drive (App installiert, DriveFS nur 7,7 GB lokal).

**Die Technik (wiederverwendbar):**
- `brctl evict <pfad>` = lokale Kopie einer BEREITS HOCHGELADENEN iCloud-Datei freigeben → Stub bleibt im Finder sichtbar, Klick lädt neu. `brctl download <pfad>` = zurückladen (Gegenprobe: PDF 0B→36K ✓)
- **.DS_Store-Falle:** .DS_Store verweigert evict (NSFileProviderError -2008) und blockiert Nachbar-Files im Bulk-Lauf → immer `! -name ".DS_Store"` ausnehmen und WIEDERHOLUNGSPASSES fahren bis „Rest datenvoll: 0" (`find … -size +20M | xargs du -k | awk '$1>2048' | wc -l`)
- Verifizierung: du = echte Blocks, ls -lh = Scheingröße; Erfolg an `df -k` Avail
- Einstellungs-Checks via computer-use: Systemeinstellungen → iCloud → Drive-Dialog (3 Toggles)

**Evicted:** Desktop/Dokumente/**Barbulls 34 GB** (= enthielt die Dialog-„videos/djo videos/BB-Videos" — ~/Documents selbst war klein, „Dokumente – MacBook Pro von Sascha" nur 52K!) · Musik aktuell 9,6 · 1) FOTOS 7,2 · FFG_ReSubmission_PAKET 9,9 · 0) Allgemeine Dokumente 1,2. **Nie anfassen:** PRojekte 13G (aktiv), Coworkspace_Ich 12G (ATLAS), .claude/.gemini/.zcode/.hermes, Library ~82G (App Support 48G: Claude-3p 12G, Claude 10G).

**Offen (brauchen Saschas OK, im Abschlussbericht offered als „mach Nr. X"):** 1. .lmstudio 19,6 GB (Modelle, neu ladbar) · 2. Docker.raw = Docker-VM (ls zeigt 72 GB SPARSE, du real nur 11 GB — immer du nehmen!), Reset via Docker Desktop→Problembehandlung · 3. PRojekte 13 GB ebenso evicten. „Mac-Speicher optimieren" ON → macOS evicted künftig selbst bei Druck. Siehe [[sascha-agenten-ordner-unantastbar]], [[anti-luegen-vertrag]].
