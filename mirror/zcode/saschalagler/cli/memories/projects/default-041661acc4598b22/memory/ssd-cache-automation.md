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

Echte Entlastung braucht zusätzlich manuell: Desktop ausmisten (79 GB) — Sascha-Entscheidung.
