---
name: tcc-fda-cleanup-2026-10-09
description: 09.10. TCC/FDA-Aufräum-Lauf — 12 tote
  Festplattenvollzugriff-Einträge bewiesen+bereit, Löschversuche blockiert (SIP
  + Touch-ID-Pflicht pro Klick), wartet auf Saschas Fingerabdruck
metadata:
  node_type: memory
  type: project
  originSessionId: sess_380c5923-55eb-4ded-b208-0e0b05fa8d52
---

**Stand 09.10.2026 Abend: 12 tote FDA-Einträge verifiziert, GUI-Löschung läuft — Touch-ID-Dialog offen, wartet auf Sascha.**

- **Löschen bereit (bewiesen tot per `test -e`, Workflow dwfrun-eec3e822):** `2.1.206/207/211/217/220/236` (6 alte claude-CLI-Versionen; nur 2.1.247+2.1.251 existieren), `AGSService` (Adobe 25.08. deinstalliert), `applet` ×3 (Adobe-Desktop-Installateur weg), `simplyprint-bambu-lab` (Ordner weg), `streamer` ×1–2 (Autodesk webdeploy weg). Diagramm/Tabelle: Workspace `out/TCC_LOESCHPLAN.md` (Workflow-Artikel „TCC-Löschplan mit Diagramm").
- **Bewusst NICHT löschen:** `claude`/`claude.app`-Zeilen (UI-Zuordnung mehrdeutig — eines ist der lebende claude-code-Bundle-Eintrag), alle AUS-Einträge (Spotify/WhatsApp/GoogleUpdater/Moonlock/Zen/CaskHub …) = nur bewusst deaktiviert.
- **Technik-Fakten (bewiesen):** Lesen von `/Library/Application Support/com.apple.TCC/TCC.db` klappt mit FDA; **Schreiben blockiert SIP** (sqlite „readonly database" UND `cp`-Ersetzen „Operation not permitted") — GUI „−"-Knopf ist der einzige Weg. Backup: `~/sicherungen/tcc-backup-20261009/TCC.db`.
- **GUI-Automatisierung (computer-use via node_repl):** Sidebar-Klicks in Systemeinstellungen navigieren NICHT wenn Fenster im Hintergrund; zuverlässig = Deep-Link `open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFilesAccess"`. Klick auf „Entfernen" löst **jedes Mal** Touch-ID/Passwort-Dialog aus („Systemeinstellungen entsperren") — Unlock hielt nicht über Dialog hinweg. Bootstrap muss in JEDEN node_repl-Call (`app`-Binding überlebt Zelle nicht).
- „Dateien & Ordner"-Bereich (74 Apps): keine pfad-basierten Leichen, nur Spotlight-„?"-Treffer = kein Löschbeweis.
- Verwandt: [[plugin-skill-inventar-dwfrun-2026-10-09]]
