---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/omniroute-rueckbau-system-fixes-2026-09-20.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: omniroute-rueckbau-system-fixes-2026-09-20
description: OmniRoute abgebaut (Nutzer-Wunsch) + 7 Audit-Fixes: Atlas-Ingest 67 Module, Task-Bridge, loki-up.command, Mongo zu, tote Agents raus, Doku aktualisiert
metadata:
  type: project
---

Stand 20.09.2026 Abend — Fix-Lauf nach System-Selbstprüfung (Workflow „LOKI.OS Selbstprüfung", 39 Checks):

1. **OmniRoute ABGEBAUT auf Nutzer-Wunsch** („ich brauche kein OmniRoute mehr"): Plist `com.sascha.omniroute.plist` → `~/sicherungen/launchagents-disabled-20260920/` (reversibel). Laufender Prozess bleibt als Comet-Fallback bis zum Mac-Neustart; danach ist er WEG. Regeln in `~/.agents/STANDARD-SKILLS.md` D.1 umgestellt auf Direkt-Provider (ZCode/Claude=z.ai, Cline=OpenRouter, Gemini=Gemini-Key) + Sync auf alle 5 Harnesses (17:0x). WICHTIG: status_check.sh-Soll-Tabelle angepasst (OmniRoute-Zeile raus). Rest-Referenzen: openclaw.json-Provider, omni-* Skills (~6), `omni-check`-Terminal-Alias — bewusst NICHT gelöscht, nur Doku.
2. **OmniRoute-Bind bleibt `*:20128`**: Binary kodiert `*` hart, `HOST=127.0.0.1` in `~/.omniroute/.env` wirkte NICHT auf den Listen-Socket. Einziger Fix: macOS-Firewall (ist DISABLED) — sudo nötig → Paste-Block an Nutzer. `/health` ist KEIN OmniRoute-Endpunkt (TCP-Check nutzen).
3. **Atlas-Ingest gefixt** (2 Bugs): Quelle war toter Pfad `~/Desktop/lauri/ATLAS_KNOWLEDGE_BASE` → jetzt echter `ATLAS_MASTER`-Pfad (ist ein Symlink! find braucht -L) + os.walk-Pruning gegen node_modules (hing sonst Minuten) + GET-Pfad-Bug (`BASE_DIR` vs. `BASE_DIR.parent`) → **67 Wissensmodule live**.
4. **Task-Bridge**: Kernel `/tasks` liest `~/loki-ki/macos-app-v17/todo.txt` (NICHT `~/loki-ki/todo.txt` — das ist der Sprachnotizen-Speicher) → 5 echte Aufgaben statt Test-Dummies.
5. **`~/Desktop/loki-up.command`** (getestet): startet Kernel + LegalOps + Kanban idempotent — das erste Mittel nach jedem Reboot.
6. MongoDB gestoppt (`brew services stop mongodb-community`, niemand nutzte ihn), 2 tote LaunchAgents disabled (omni-check.daily Exit 2, toolhub-watchdog Exit 126), qwen2.5-coder:7b (4,7 GB) installiert.
7. Doku-Konsolidierung: `LOKI_MASTER_STATUS.md` (war 74 Tage alt) + `SYSTEM_HANDBUCH.md` neu geschrieben/gezielt gefixt; Backups in `~/sicherungen/doku-backup-20260920/`.

Verwandt: [[loki-kernel-v17-start-8010-fix]], [[zai-coding-plan-limits]]
