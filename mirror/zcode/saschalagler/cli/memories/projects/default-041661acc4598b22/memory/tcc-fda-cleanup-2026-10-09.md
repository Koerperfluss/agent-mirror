---
name: tcc-fda-cleanup-2026-10-09
description: 09.10. TCC/FDA-Aufräum-Lauf ABGESCHLOSSEN — alle 14 toten Einträge weg
  (TCC 90→72), lebende Tools verifiziert unversehrt; gelernt macOS 27 verlangt Touch
  ID pro „Entfernen“-Klick (Unlock hält NICHT über mehrere Löschungen); Settings-Deep-Link
  als zuverlässiger Navigationsweg
metadata:
  node_type: memory
  type: project
  originSessionId: sess_380c5923-55eb-4ded-b208-0e0b05fa8d52
---

**09.10. Abend FERTIG: Sascha hat die letzten 11 toten Einträge selbst per GUI gelöscht (Zeile klicken → „−“ → Touch ID pro Löschung). Beweis: TCC-Datenbank 88→72 Einträge, Suchliste aller 11 Toten liefert LEERES Ergebnis.**

- **Endstand:** 14 tote Einträge identifiziert (Workflow dwfrun-eec3e822, jeder Pfad per `test -e` bewiesen) → alle 14 weg (2 über meine GUI-Klicks + Saschas Finger: AGSService, alter streamer 20260123; 11 durch Sascha selbst: 2.1.206/207/211/217/220/236, applet ×3, simplyprint-bambu-lab, streamer 20260227). Er löschte auch claude.app/2.1.251 — harmlos, CLI fragt FDA einfach neu an.
- **Verifiziert unversehrt (auth=2):** dev.zcode.app, Terminal, Konsole, Antigravity (beide), AutoClaw, Cline, Comet, node. Backup: `~/sicherungen/tcc-backup-20261009/TCC.db`.
- **Regel fürs nächste Mal:** macOS 27 verlangt Touch ID für JEDE einzelne FDA-Löschung — Unlock hält NICHT über mehrere Löschungen (Agent kann klicken, ohne Finger pro Dialog passiert nichts). Bei Batch: nach „Entfernen“-Klick NICHT beobachten (getAXState hängt am Auth-Dialog → 8-s-Deadline-Timeout), sofort nächste Zeile klicken.
- **GUI-Fallstricke:** Settings-App restartete 3× (PID-Wechsel 14919→26928→32648); Sidebar-Klicks geben Stale-Element-Fehler → zuverlässigster Weg: Deep-Link `/usr/bin/open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFilesAccess"`. Finder findet TCC-Leichen nicht (Dateien existieren nicht mehr = der Beweis) — Sascha musste das erklärt bekommen.
- „Dateien & Ordner“ (74 Apps): keine pfad-basierten Leichen, nur Spotlight-„?“ = kein Löschbeweis → unangetastet.
- Verwandt: [[plugin-skill-inventar-dwfrun-2026-10-09]], [[macos-27-beta-status]] (Beta-Instabilität)
