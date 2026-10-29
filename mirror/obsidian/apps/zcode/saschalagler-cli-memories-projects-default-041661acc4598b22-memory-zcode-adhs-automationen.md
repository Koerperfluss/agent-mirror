---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/zcode-adhs-automationen.md"
stand: 2026-10-29
tags: [spiegel, zcode]
---

---
name: zcode-adhs-automationen
description: "13.09.–29.10. LIVE: EINE Automation mit ALLEN 6 Briefs (cron `0 9,10,15,16,21`; niemals 6 separate — Nutzer-Ziel!) · **61+ Läufe** · INFO-PUSH lebt (macOS-Benachrichtigung + 4-Zeilen-Format bei JEDEM Lauf inkl. No-ops, mehrfach Automatik-PASS) · GROSS-KONSOLIDIERUNG 26.10.: LOKI_TASKBOARD.md (~/.agents/memory/, 3,9 KB) + SYSTEMPROOF 6/6 AKTIV + Doku-Fix ERLEDIGT (README+Backup, grep-Beweis) · LokiVoice = `~/loki-ki/_ARCHIV/2026-10/loki-voice-alt/` (P1s obsolet) · Förder-Antrag: FÖDERUNG-Ordner aufgebaut (dwfrun) · Magicline-PDF bewiesen = `~/Desktop/MAGICLINE_GEORGE_ALLES_IN_EINEM_2026-10-19.pdf` (426 KB, déjà-Lektion: vor DATENLAGE UNKLAR deja+exaktes ls) · 28./29.10. = 2 Lücken-Tage in Folge (Mac aus) · OmniRoute :20128 LÄUFT WIEDER (Richtung offen) · Doku-Sync-DUPLIKAT automation-2df8eec5 Lösch-GO offen · offen auf GO: Wecker · Deutsch-Patch · Duplikat weg · OmniRoute-Richtung · 1 Task pro Chat-Limit"
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Stand 13.09.2026 abends — ZIEL ERREICHT: 1 Automation, alle 6 Funktionen, Engine komplett gebaut und live getestet.**

## Die EINE Automation (verifiziert via CronList, ID `automation-d3f486f6-0509-4176-8459-be13ad3b4282`)
- **Titel:** „LOKI Tages-Routine: alle 6 Briefs + Info-Push je Lauf" · cron **`0 9,10,15,16,21 * * *`** · active
- Zweig-Wahl zur Laufzeit per `date '+%H %u %A'`: 09:00 MORGEN-BRIEF (tgl.) + DEV-BRIEF (Mo–Fr, im selben Lauf) · 10:00 RISIKO-SCAN (tgl.) · 15:00 nur Mi DOKU-SYNC · 16:00 nur Fr RELEASE-BRIEF · 21:00 ABEND-ZUSAMMENFASSUNG.
- **Nutzer-Kernforderung:** „wieso formulierst du die automationen nicht als eine einzige statt 6 — DAS WAR DAS ZIEL" → niemals 6 separate Tasks anlegen; weitere Briefs = neue Zweige + neue Stunde in DENSELBEN cron. ZCode-Limit bestätigt: **1 Scheduled Task pro Chat**.
- **INFO-PUSH-Vertrag (26.10. per CronUpdate, Sascha: „die Läufe geben mir KEINE Info … 0 Info völlig wertlos"):** ① macOS-Benachrichtigung bei JEDEM Lauf (auch No-ops, `display notification` + title „LOKI <Zweig> <Uhrzeit>") ② Chat im 4-Zeilen-Format: WAS PASSIERT IST · WO ZU FINDEN (Kalender-Event + Logbuch-Pfad) · WANN nächster Lauf · WIE WEITER (GO-Wort) ③ No-op-1-Zeiler verboten (auch No-ops pushen mit Grund + nächstem vollen Lauf). Live bewiesen an vollen Läufen UND No-ops.

## Engine — GEBAUT 13.09. (Implementer-Subagent, 7/7 PASS, live getestet)
1. **`~/.agents/tools/daily_sweep.py`** — 7 Quellen read-only: ZCode-Rollouts, Cline `~/.cline/data/sessions/*/*.messages.json`, Antigravity `~/.gemini/antigravity/brain/*`, AutoClaw `~/.openclaw-autoclaw/agents/*/sessions/*.jsonl`+`cron/jobs.json`, claude-mem.db (Schema-Discovery `mode=ro`), Git heute, LOKI-Dateien.
2. **Logbuch** `~/.agents/memory/logbuch/` (23+ Dateien) — Frontmatter date/projects/status, H2 pro Projekt, `## ✍️ Meine Notizen` = tabu (Parser stoppt dort), append-only, Multi-Writer-sicher (vor jedem Schreiben NEU lesen — fremde Workflows schreiben mit!).
3. **`~/loki-assistent/assi`** erweitert: `brief` (Morgen-Brief, `--hook` = additionalContext-JSON, exit 0) + `feierabend` (Sweep anhängen + status abgeschlossen).
4. **SessionStart-Hook** in `~/.zcode/cli/config.json` (matcher „startup", assi brief --hook, timeout 30) — jetzt **5 Gruppen** (obsidian-vault, projects.py, assi-brief + 2).
5. **README-Fix 26.10.:** `~/loki-assistent/README.md` Befehls-Tabelle um brief/feierabend + push.sh-Abschnitt ergänzt (Backup `README.md.bak-20261026`, grep 0→4 Treffer) — Doku-Sync-Finding tot.

## Kalender-Fakten
- osascript → Calendar.app OHNE TCC-Prompt; **KEIN Gmail-/Google-Kalender** in Calendar.app → **Zielkalender = „Kalender"** (id 51D1AEBA-…). Calendar.app nicht laufend → `open -a Calendar; sleep 6` vor osascript (sonst Fehler -600).
- 30+ Events angelegt und jeweils zurückgelesen (UID-Beweise im Verlauf); FRIST-Event-Muster bewiesen (BH-Melk 09.10. als eigenes Ganztages-Event + Tagesplan-Warnung).

## Lauf-Verlauf (Kurzfassung, Details in den nummerierten Sektionen der Historie)
- **13.09.–21.09.:** alle 6 Zweige live bewiesen (Abend 13./16./20./21.09., RISIKO-SCAN mit echtem P1 21.09., Doku-Sync Finding 23.09., No-op-Guards mehrfach). LokiVoice-P1-Kette: Submodul dirty → Commit `7fdbf2d` (21 Dateien) → Parent-Pointer-P1 (01.10.) → **Lösung durch Archivierung**: loki-voice aus `loki-ki` entfernt → `~/loki-ki/_ARCHIV/2026-10/loki-voice-alt/` (18.10./26.10. bestätigt) — beide P1 obsolet.
- **Lücken-Tage = 100 % Schlaf-Fälle:** 15./17./19./23./25.–28.09., 30.09.–05.10., 07.–12.10., 19.–25.10. — Mac aus → ZCode-Cron feuert nicht. **Dauerhebel auf GO: LaunchAgent `com.sascha.assi.daily` (08:00) zum Routine-Wecker aufrüsten.** Catch-up-Muster bewährt: verpassten Morgen-Brief im 15/16/21-Lauf nachholen (Zweig-Abweichung dokumentieren).
- **UHR-ANOMALIE:** Zukunftdatierte Logbuch-Dateien (06.10/13.10) existierten, bevor das echte Datum sie einholte — Behandlung: `date`-Output = Wahrheit, Zukunftdateien beim echten Datum zu gültigen Logbüchern umbauen (Korrektur-Sektion anhängen, nichts löschen, Bi-Temporal).
- **26.10. GROSS-KONSOLIDIERUNG:** Taskboard `~/.agents/memory/LOKI_TASKBOARD.md` (3,9 KB; 16 Alt-Aufgaben, 6 erledigt/obsolet, Verteilung ZCode/Cline/AutoClaw/Sascha) + **SYSTEMPROOF 6/6 LIVE PASS** (Hook-JSON, 23 Logbücher, Sweep, Kalender-Rücklesen, Doku-Fix grep, 3/3 Engine-Dateien) + **Doku-Fix erledigt**.
- **27.10.–29.10.:** Info-Push an allen Läufen bewiesen (Morgen 09:05 pünktlich + 2 No-ops + Abend 21:04, jeweils Push + 4-Zeilen). **Förder-Antrag Körperfluss EDU:** dwfrun baute `FÖDERUNG/`-Ordner (FÖRDERANTRAGEN_2026-10, HARVESTS, FFG Kleinprojekt Anlauf 2) · Verkaufs-HUB-Handoff aktiv · Magicline-PDF bewiesen (426 KB) · 29.10. Donnerstags-No-op mit Push.
- **29.10. Abend:** 2. Lücken-Tag in Folge (28./29.10. ohne Morgen-Brief, Mac aus) — Logbuch 29.10. trotzdem geschlossen (ruhiger Donnerstag, 0 Commits, FIX-Lauf 3710694b erneut geöffnet). Event-UID `A706BAE0-917A-4436-A827-FC59BF181704`.
- Bilanz: **61+ Läufe**; Dauer-GOs unverändert: **GO Wecker · Deutsch-Patch („weiter übersetzen") · Duplikat weg (automation-2df8eec5) · OmniRoute-Richtung**.

## Offene Konflikte
- **OmniRoute :20128 LÄUFT WIEDER** (node PID 871, lsof 26.10.) — Widerspruch zum Abbau 20.09. ([[omniroute-rueckbau-system-fixes-2026-09-20]]); Richtung nur Sascha.
- **Doku-Sync-Duplikat:** `automation-2df8eec5` „Documentation sync check" (Mi 15:00, englisch) dupliziert den Mi-Zweig → Lösch-GO offen.
- Deutsch-Patch: `/tmp/zcode_i18n` verloren (flüchtig), aber app.asar vorhanden → Re-Extraktion jederzeit möglich; Details [[zcode-app-german-ui-patch]].
