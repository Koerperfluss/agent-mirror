---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/loki-autostarts-orphaned.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: loki-autostarts-orphaned
description: LOKI-Autostart-Leichen (com.loki.master + com.loki.v15) — am 25.08.2026 ENTFERNT (bootout+disable, Backup ~/launchagents_backup/2026-08-25); omniroute/lokivoice/legalops bleiben
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a8584745-c71a-4be7-abfa-69705dde9546
---

**RESOLVED 2026-08-25:** `com.loki.master` (KeepAlive-Retry-Loop) und `com.loki.v15` wurden entfernt (`launchctl bootout` + `disable`, plists gesichert in `~/launchagents_backup/2026-08-25/`). Beide zeigten auf gelöschte Skripte in `~/loki-ki/` (Exit 127). Das ersetzt den Stand „EINE Boot-Kette com.loki.v15 → MASTER_BOOT v15.3.0" von 30.07.2026 — die kanonische Boot-Kette existiert so nicht mehr.

Bleiben absichtlich aktiv: `com.sascha.omniroute` (Gateway localhost:20128), `com.lokivoice.mcp-server`, `com.loki.legalops.mcp`, tägliche Kalender-Jobs `com.sascha.assi.daily` + `com.sascha.omni-check.daily`.

**How to apply:** Falls LOKI-Autostart gewünscht wird: aus dem Backup zurückschieben + `launchctl enable`. Nie omniroute/lokivoice/legalops anfassen. Details: [[mac-cleanup-2026-08-25]].
