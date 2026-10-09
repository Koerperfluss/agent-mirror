---
name: tcc-fda-cleanup-2026-10-09
description: 09.10. TCC/FDA-Aufräum-Lauf — 2/12 tote Einträge gelöscht,
  11 offen (TCC-Zahl 88), GUI-Löschung braucht Saschas Touch ID + Settings-App
  instabil (startet laufend neu); Wartung fortsetzen bei „go"
metadata:
  node_type: memory
  type: project
  originSessionId: sess_380c5923-55eb-4ded-b208-0e0b05fa8d52
---

**Stand 09.10.2026 spät: 2/12 GELÖSCHT (AGSService + alter streamer 20260123 — Saschas Touch ID hielt für mehrere Löschungen!), TCC-Zählung 88 (vorher 90). 11 offen.**

- **Noch zu löschen (bewiesen tot):** `2.1.206/207/211/217/220/236`, `applet` ×3, `simplyprint-bambu-lab`, `streamer` (20260227). NICHT anfassen: `2.1.247/251`, alle AUS-Einträge, `claude`/`claude.app`-Zeilen (mehrdeutig). Backup: `~/sicherungen/tcc-backup-20261009/TCC.db`.
- **GUI-Instabilität:** Systemeinstellungen startete im Lauf 3× neu (PID wechselte 14919→26928→32648, Fenster leer) — deshalb brachen Loops ab. Workflow dwfrun-eec3e822-Löschloop: nach „Entfernen"-Klick hängt `getAXState` im Auth-Dialog (wartet auf Settle → Timeout) — daher pro Löschung: klicken, Sascha drückt Finger, dann weiter.
- **Entscheidung für Sascha angeboten:** (a) Agent klickt erste Zeile+Entfernen, er drückt Finger (Unlock hält mehrfach), Rest im Rutsch — wartet auf „go"; oder (b) er löscht die 11 selbst (Zeile → „−"). Danach TCC-DB-Gegenprüfung (`sqlite3 … count(*)`).
- „Dateien & Ordner"-Bereich (74 Apps): keine pfad-basierten Leichen, nur Spotlight-„?"-Treffer = kein Löschbeweis.
- Verwandt: [[plugin-skill-inventar-dwfrun-2026-10-09]], [[macos-27-beta-status]] (Beta-Instabilität)
