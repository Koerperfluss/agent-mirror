---
name: macos-27-beta-status
description: macOS 27 „Golden Gate" Developer Beta — AMFI killt ad-hoc-signierte
  Binaries (Cline-Fix ~/fix-cline-signing.sh nach jedem npm update!),
  WindowServer-Bug (40–60 % CPU, Geisterbilder), kein TM-Backup → bei Beta
  bleiben
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

macOS 27 „Golden Gate" Developer Beta — Stand 08.09.2026 (Sascha ist Entwickler, Entscheidung: bei Beta bleiben, Downgrade verworfen):

- **AMFI verschärft:** ad-hoc/linker-signierte Binaries ohne echten Apple-CMS-Blob werden beim Start gekillt (`Killed: 9`). Betroffen war die **Cline CLI** (Bun-Standalone; GitHub Issue cline/cline#12042 noch offen). Fix: Re-Signing mit der Apple-Development-Identity aus dem Keychain — Skript **`~/fix-cline-signing.sh`, NACH JEDEM `npm update -g cline` erneut ausführen** (Updates überschreiben die Signatur). Doku: `~/STATUS-cline-macos27-fix.md`. Cline muss einmal neu eingeloggt werden (Team-Backend „Unauthorized" → spawn_agent-Runs schlagen sonst fehl).
- **WindowServer-Bug:** 40–60 % CPU dauerhaft + Geisterbilder/Doppeltext (1537 Fehler/30 min). Gemessen: NICHT Refresh-Rate-abhängig (144/100/60 Hz alle ~48 %) = speicherleckend, nur Apple kann fixen. Symptomlinderung: Abmelden/Anmelden (startet WindowServer neu). Installiert: 100-Hz-LaunchAgent `dev.saschalagler.refresh100` (Rückweg auf 144 Hz via displayplacer dokumentiert); Terminal auf solides Profil (kein Blur); „Transparenz reduzieren" muss der Nutzer selbst klicken (TCC).
- **Time-Machine:** kein echtes Backup-Ziel (TM zeigt auf Macintosh HD selbst → Mount-Fehler). Ohne Backup ist Downgrade auf macOS 26 = Festplatten-Löschung → zu riskant; daher Beta-Verbleib. Externe Platte anbinden = offener Nutzer-Punkt.
- **Disk-Bereinigung 08.09.:** Claude-/Claude-3p-vm_bundles (20,4 GB), Google DriveFS (3 GB), Spotify-/Sigma-Caches gelöscht → ~103 GB frei. Offene OK-Fragen: iOS-26.5-Simulator-Runtime (17,6 GB).
- **Nicht Beta-Schuld:** Die echten Ausfälle (LOKI-Kernel 8010, LegalOps 7070, Kanban) waren laut Audit VOR der Beta da (F-1-Watchdog fehlte); F-1 (Kernel läuft) + F-2 (Home-Git-Repo → ~/.git.DISABLED-20260907) erledigt.
- **Cline-Sprache:** `~/.cline/rules/DE.md` angelegt (Antworten immer Deutsch, Code original).
- iPhone-Dev-Seite ist komplett: siehe [[atlas-stand-2026-09-08]]. [[mac-setup-16gb-m4]]
