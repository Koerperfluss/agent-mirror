---
name: zcode-adhs-automationen
description: Saschas Tages-Routine 13.09. — Morgen-Brief-Automation LIVE (native
  ZCode-Automations), Abend-Logbuch wartet auf neuen Chat (1 Task/Chat-Limit), KEINE
  Web-UI, Logbuch im globalen Memory
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Stand 13.09.2026 (Plan APPROVED, Umsetzung gestartet, dann Nutzer-STOPP der asar-Schiene):**

**✅ ERLEDIGT 13.09.:**
1. **`~/.zcode/AGENTS.md` ANGELEGT** (Dauer-Prompt, wie GEMINI.md bei Antigravity): Entscheidungs-Hoheit (Produkt/UI entscheidet Sascha), nur Deutsch, ADHS-Format, Beweis-Pflicht.
2. **Morgen-Brief-Automation LEBT** (native ZCode-Automations, ID `automation-d3f486f6-0509-4176-8459-be13ad3b4282`, cron `0 9 * * 1-5`, nächste Ausführung Mo 09:00): liest Logbuch + MASTER_TODO + SESSION_CONTEXT + daily_sweep → max. 5 Bullets → Logbuch-Datei + Kalender-Event „Tagesplan" via osascript.
3. asar nur nach /tmp/zcode_asar entpackt — **NICHTS gepatcht, App unangetastet** (Nutzer-STOPP).

**⚠️ OFFEN — Abend-Zusammenfassung:** Anlage scheiterte an **ZCode-Limit: 1 Scheduled Task pro Chat/Session** („Cannot create a scheduled task inside a session that already belongs to a scheduled task"). → Nächster Schritt: NEUER Chat, dort Abend-Automation anlegen (täglich 21:30 Sicherheitsnetz, cron `30 21 * * *`): prüft ob `~/.agents/memory/logbuch/<heute>.md` mit status: abgeschlossen existiert → wenn ja, sofort Ende; wenn nein: Sweep → 3–5 ADHS-Bullets **pro Projekt gruppiert, Tool-Tags [ZCode]/[Cline]/[Antigravity]/[AutoClaw]** → Logbuch-Datei + Ganztages-Event „Logbuch <Datum>" via osascript. Manueller Trigger: „Feierabend" sagen (Command noch nicht gebaut).

**Design-Entscheidungen (verbindlich):**
- **KEINE Web-UI** („ICH WILL KEINE SCHEISS WEB UI") — Oberfläche = **Kalender am Mac + ZCode-Chat**. Siehe [[feedback-entscheidungshoheit]].
- Logbuch-Speicher = **globales System-Memory `~/.agents/memory/logbuch/`** (1 Datei/Tag, Frontmatter date/projects/status, Abschnitt pro Projekt, Tool-Tags, geschützter „✍️ Meine Notizen"-Bereich — wird NIE überschrieben).
- **Nur 4 Tools als Quellen:** ZCode, AutoClaw, Antigravity, Cline (+ claude-mem, Git, LOKI-Dateien) — NICHT 6 Harnesses (Claude Code/Hermes gehören nicht dazu).
- Kalender-Weg: **AppleScript → Kalender.app** (Gmail-Kalender liegt da drin), NICHT AutoClaw-Connector.
- daily_sweep.py (`~/.agents/tools/`) noch NICHT geschrieben (Plan-Mode blockte Writes; Design komplett im Chat-Verlauf).

**Verifizierte Infrastruktur-Fakten 13.09.:**
- ZCode **Automations-Panel** (Sidebar → Automations) = natives UI für Scheduled Tasks mit 4 Templates (Morning dev brief/Risk scan/Release brief/Docs sync) — genau daher kam sein ursprüngliches Template. Idle-time task Tab existiert.
- `~/loki-assistent/assi` (Python-CLI, Workflows 00–05, remember/recall) + LaunchAgent `com.sascha.assi.daily` (08:00, schreibt brief_latest.txt = nur System-Health) existieren — Wiederverwendungs-Basis für assi brief/feierabend.
- `config.json` hat bereits `"hooks"`-Schlüssel; Hook-Schema: `hooks.enabled: true` Pflicht, SessionStart-Matcher `startup`, Output `{"additionalContext": ...}` (strikt), Timeout-Einheiten achten.
- ZCode-i18n: nur `langEN.js` + `langZH.js` in app.asar (siehe [[zcode-app-german-ui-patch]]).
- Explore-Subagenten brechen mit „Model provider is not configured: builtin:zai-coding-plan" → selbst ausführen (LOKI-Regel 9).
- Plan-Mode-Sandbox blockt teils unschuldige Befehle (sqlite3, python3 -c, npx, mcporter) — Read-only-Ausweichwege nutzen.

**Phase 2 (auf GO):** die 4 Template-Automations (Dev-Brief Mo–Fr 09:00, Risiko-Scan 10:00, Release-Brief Fr 16:00, Doku-Sync Mi 15:00) via CronCreate.
