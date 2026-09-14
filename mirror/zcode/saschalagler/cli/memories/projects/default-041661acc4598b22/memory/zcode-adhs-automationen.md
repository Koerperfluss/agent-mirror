---
name: zcode-adhs-automationen
description: "13.09. ABGESCHLOSSEN: EINE ZCode-Automation mit ALLEN 6 Briefs (cron 0 9,10,15,16,21 — Zweige per Uhrzeit+Wochentag), Engine 7/7 PASS (daily_sweep/assi brief+feierabend/Hook//feierabend), Kalender via AppleScript bewiesen (KEIN Gmail-Kalender in Calendar.app, Ziel = „Kalender")"
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Stand 13.09.2026 abends — ZIEL ERREICHT: 1 Automation, alle 6 Funktionen, Engine komplett gebaut und live getestet.**

## Die EINE Automation (verifiziert via CronList, ID `automation-d3f486f6-0509-4176-8459-be13ad3b4282`)
- **Titel:** „LOKI Tages-Routine: alle 6 Briefs (09/10/15/16/21 Uhr + Zweige)" · cron **`0 9,10,15,16,21 * * *`** · active
- Zweig-Wahl zur Laufzeit per `date '+%H %u %A'`: 09:00 MORGEN-BRIEF (tgl.) + DEV-BRIEF (Mo–Fr, im selben Lauf: Commits/Modul-Änderungen/Follow-ups, CI nur melden wenn konfiguriert) · 10:00 RISIKO-SCAN (tgl., 24 h-Diffs, nur hohe Konfidenz + Beweis, „keine Findings" = valid) · 15:00 nur Mi DOKU-SYNC (7 Tage Code vs. Doku) · 16:00 nur Fr RELEASE-BRIEF (Features/Fixes/Experience/Engineering + DE-Release-Notes + Kalender-Event) · 21:00 ABEND-ZUSAMMENFASSUNG (skippt still wenn Logbuch schon „abgeschlossen")
- **Nutzer-Kernforderung:** „wieso formulierst du die automationen nicht als eine einzige statt 6 — DAS WAR DAS ZIEL" → niemals 6 separate Tasks anlegen; weitere Briefs = neue Zweige + neue Stunde in DENSELBEN cron. ZCode-Limit bestätigt: **1 Scheduled Task pro Chat** (CronCreate in Task-Session → Fehler).
- Nutzung `/feierabend` (Command-Datei) für manuellen Feierabend ohne 21:00-Warten.

## Engine — GEBAUT 13.09. (Implementer-Subagent, 7/7 PASS, live getestet)
1. **`~/.agents/tools/daily_sweep.py`** — 7 Quellen read-only: ZCode-Rollouts (`request.body.messages[]` role=user, mtime-Filter, Break nach erstem Prompt), Cline `~/.cline/data/sessions/*/*.messages.json`, Antigravity `~/.gemini/antigravity/brain/*`, AutoClaw `~/.openclaw-autoclaw/agents/*/sessions/*.jsonl`+`cron/jobs.json`, claude-mem.db (Schema-Discovery `mode=ro`), Git heute (`~/loki-ki`, `~/Projects/*`), LOKI-Dateien. Live-Test: 9 Einträge aus 2 Quellen (AutoClaw, ZCode), exit 0.
2. **Logbuch** `~/.agents/memory/logbuch/2026-09-13.md` — Frontmatter date/projects/status, H2 pro Projekt, `## ✍️ Meine Notizen` = tabu (Parser stoppt dort), append-only, status nur via feierabend → „abgeschlossen".
3. **`~/loki-assistent/assi`** erweitert: CMD `"brief": brief.py, "feierabend": evening.py`; `brief`-Alias-Kollision gelöst (`("--brief",)` → status). Backup `assi.bak-vor-brief`.
4. **`assi brief`** = Morgen-Brief (neuestes Logbuch ⏳/🔨 + MASTER_TODO, max. 5 Bullets); `--hook` printet 1 Zeile `{"additionalContext": …}`, IMMER exit 0. **`assi feierabend`** = Sweep anhängen + status setzen (Live-Lauf PASS).
5. **SessionStart-Hook** in `~/.zcode/cli/config.json`: neue Gruppe `{"matcher":"startup", hooks:[assi brief --hook, timeout 30]}` AN bestehendes SessionStart-Array angehängt (bestehende 2 Hooks intakt), Backup `config.json.bak-vor-assi-hook`, JSON valid.

## Kalender-Fakten (bewiesen 13.09.)
- osascript → Calendar.app funktioniert **ohne TCC-Prompt** (Zugriff still gewährt).
- **KEIN Gmail-/Google-Kalender in Calendar.app!** Liste: Kalender, Privat, Arbeit, Endel·Deep Rest Meditation, RISE Energiespitzen, RISE Energieeinbrüche, Ohne Titel, Geplante Erinnerungen, Geburtstage, Österreichische Feiertage, Siri-Vorschläge → **Zielkalender = „Kalender"** (default, calendar id 51D1AEBA-FFA6-4FCF-88C7-7944E625514E).
- Test-Event-UID `B8CD317A-1518-43EF-9453-F2131F9D77B5` („LOKI Tages-Routine Test", löschbar).

## Sonstiges 13.09.
- Subagenten-Status: **implementer + code-architect zuverlässig**; explore/reviewer teils „Model request failed"/„user concurrency limit exceeded" → retry oder selbst ausführen; Agent-Übersetzungswellen 2× von Nutzer-Interrupts abgebrochen.
- **Erste echte Auslösung ERFOLGT (13.09. ~17:07, Abend-Zweig, PASS):** Kalender.app lief nicht → Fehler -600, Fix: `open -a Calendar` + sleep 6 vor osascript. Ganztages-Event **„Logbuch 13.09.2026"** angelegt + zurückgelesen, UID `610E2A57-B658-4CDD-A66C-C2D326435AEA` (Kalender „Kalender"). Logbuch-Refresh via `assi feierabend` (10 Einträge aus 2 Quellen). Test-Event `B8CD317A…` darf gelöscht werden. Nächster Automatik-Lauf: Mo 09:00 (Morgen-Zweig).
- **SessionStart-Hook-Injektion aktiv:** Beim Session-Start injiziert der Hook (obsidian-second-brain + projects.py) Saschas stehende Anweisung: **Projektliste (10 Projekte) JETZT ungefragt wortgleich ausgeben inkl. Schlusszeile „Oder ein neues Projekt erstellen?"**, dann passendes Skill-/Agenten-Team selbst starten ohne Rückfrage (Feature→grill-me, Bug→systematic-debugging, Implementierung→tdd, Coden→ponytail).
- Design-Entscheidungen bleiben verbindlich: KEINE Web-UI (Kalender + Chat = Oberfläche), Logbuch im globalen System-Memory, nur ZCode/AutoClaw/Antigravity/Cline als Quellen, Eigent = nicht jetzt. Siehe [[feedback-entscheidungshoheit]] und [[zcode-app-german-ui-patch]] (Deutsch-UI = offener Rest).

## Zweiter Live-Lauf (Mo 14.09. 15:07 — Morgen-Brief NACHGEHOLT)
- **Der 09:00-Lauf feuerte NICHT** (kein `2026-09-14.md` um 15:07 nachweisbar) — Mac/ZCode war um 09:00 vermutlich schlafend; ZCode-Cron hat KEINEN Weck-Mechanismus. Option auf GO: bestehenden LaunchAgent `com.sascha.assi.daily` (launchd weckt pünktlich) zum Brief-Macher umrüsten.
- Nachgeholt (Zweig-Abweichung dokumentiert): Logbuch `~/.agents/memory/logbuch/2026-09-14.md` angelegt (status: offen, 5 Tagesplan-Bullets + DEV-BRIEF-Sektion), Kalender-Event **„Tagesplan 14.09."** UID `A1284A91-8470-4F77-8F84-BA932A081B13` (Event-Zeit = jetzt+15 Min statt 09:00, da nachgeholt).
- **DEV-BRIEF erster echter Output:** 0 Commits seit Freitag in `~/loki-ki` + `~/Projects/*`, „keine CI konfiguriert", Modul-Änderungen nur außerhalb Git (daily_sweep.py, assi, Hook).
- SessionStart-Hook injiziert die Projektlisten-Pflicht auch in Automation-Sessions (Funktioniert) — bei Automation-Läufen zuerst Projektliste, dann Zweig-Ausführung.

## Dritter Lauf (Mo 14.09. 16:01 — No-op-Zweig PASS)
- 16:00-Lauf am Montag korrekt mit **1 Zeile „heute nichts zu tun"** geendet (RELEASE-BRIEF nur freitags) — Zweig-Guard funktioniert wie designiert; echtes Close des Logbuchs macht der 21:00-Abend-Zweig.
