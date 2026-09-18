---
name: agent-wochenreports-automation
description: Freitags-Wochenreport-Automation über alle Agent-Apps eingerichtet;
  täglicher 20-Uhr-Report noch offen (1-Automation-pro-Session-Limit)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a55787e4-5bb6-4dc7-98c2-1ccd6ca69015
---

18.09.2026: Sascha will wöchentlich (freitags) + täglich Zusammenfassungen der Ereignisse aus allen Agent-Apps (ZCode, Cline, Antigravity, AutoClaw/OpenClaw) über seine Projekte.

- ✅ **Wochenreport LIVE**: Automation `automation-5ff3acbc-6637-4f95-a6ef-8a844ef0878e`, cron `0 17 * * 5` (freitags 17:00). Sammelt aus ZCode (tasks-index.sqlite/db.sqlite), Cline-Importen, Antigravity (state.vscdb), OpenClaw-Logs, Wayfinder + Memory; pro Projekt Tabelle (App|Was|Beweis), speichert nach `~/Desktop/Agent-Wochenreports/WOCHE_YYYY-MM-DD.md`. Erster Lauf: Fr 25.09.2026.
- ❌ **Tagesreport (täglich 20:00) NOCH OFFEN**: Erstellen schlug fehl — „Cannot create a scheduled task inside a session that already belongs to a scheduled task" ( diese Session gehörte selbst zu einer Automation). **Pro Session geht nur 1 neue Automation.** Fix: in einem NEUEN normalen Chat die Automation „Täglicher Agent-Kurzreport (20:00)" anlegen (Prompt-Vorlage steht im Chat vom 18.09.).

Verwandt: [[zcode-adhs-automationen]], [[projectlisten-hook-projects-py]] (Chat-Store-Quellen).
