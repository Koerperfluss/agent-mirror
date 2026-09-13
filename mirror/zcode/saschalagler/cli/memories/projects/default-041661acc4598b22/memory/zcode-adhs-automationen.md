---
name: zcode-adhs-automationen
description: Saschas Wunsch-Automations (Abend-Logbuch + Morgen-Brief) — Design
  13.09. fertig, Plan-Approval offen (ExitPlanMode denied), nichts implementiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

13.09.2026: Sascha will ADHS-Struktur-Automations in ZCode. Plan ausgearbeitet, **ExitPlanMode wurde denied → nichts umgesetzt**, Plan wartet auf Approval im Original-Chat.

**Gewünscht (6 Automations erklärt):**
1. **Abend-Logbuch**: 3–5 ADHS-Bullets (was erledigt/woran gearbeitet/offen) → Kalender — Trigger: **wenn er „Feierabend" sagt**, NICHT fixe Uhrzeit → Lösung: `/feierabend` Command in `~/.zcode/commands/`
2. **Morgen-Brief**: Tagesplan max. 5 Bullets — Trigger: **beim ZCode-Start**, NICHT fixe Zeit → Lösung: **SessionStart-Hook** in `~/.zcode/cli/config.json` (`hooks.enabled: true`, existiert noch nicht)
3.–6. Template-Dev-Briefs (Dev-Brief Mo–Fr 09:00, Risiko-Scan täglich 10:00, Release-Brief Fr 16:00, Doku-Sync Mi 15:00) = **Phase 2**, erst nach stabilem Kern

**Kalender-Weg (sein „Wohin?" war offen):** Er nutzt Gmail → **direkter Google-Kalender via AutoClaw-Connector** (`mcporter call autoclaw-productivity.google_calendar_create_event`), NICHT über iCloud (sein eigener Vorschlag war der Umweg). Verbindung noch NICHT verifiziert (mcporter-Call in Plan-Mode geblockt) → Schritt 1 bei GO: `productivity_list_connections`. Fallback: AppleScript in Kalender.app.

**Verifizierte Fakten 13.09.:**
- ZCode-Cron-Automationssystem existiert, **0 Automations aktiv**
- `config.json`: KEIN language/locale-Setting (App-UI vermutlich nicht deutsch machbar); keine `hooks`-Sektion; `~/.zcode/AGENTS.md` existiert NICHT (Deutsch-Regel steht bisher nur im Home-Workspace-AGENTS.md)
- Commands vorhanden: init, kanban, projects, standardskill, todo (`~/.zcode/commands/`)
- Datenquellen für Tages-Zusammenfassung: `~/.zcode/cli/rollout/*.jsonl` (mtime-Filter) + `~/.zcode/cli/log/zcode-YYYY-MM-DD.jsonl` + Git-Commits + LOKI_SESSION_CONTEXT.md/MASTER_TODO.md

**Plan-Schritte bei Wiederaufnahme:** 1) `~/.zcode/AGENTS.md` mit Deutsch+ADHS-Regel 2) Google-Cal-Connector prüfen + Test-Event 3) `/feierabend.md` Command 4) SessionStart-Hook Morgen-Brief 5) optional Sicherheitsnetz-Cron 21:30 (nur falls kein Logbuch heute) 6) Live-Verifizierung mit Beweis. Siehe [[feedback-loesungen-statt-geht-nicht]].
