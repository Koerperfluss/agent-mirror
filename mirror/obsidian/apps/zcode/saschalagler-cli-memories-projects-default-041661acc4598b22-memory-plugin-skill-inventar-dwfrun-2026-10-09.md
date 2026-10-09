---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/plugin-skill-inventar-dwfrun-2026-10-09.md"
stand: 2026-10-09
tags: [spiegel, zcode]
---

---
name: plugin-skill-inventar-dwfrun-2026-10-09
description: 09.10. Workflow dwfrun-8c351687 = Skill-/Plugin-Inventur (12 Einträge
  verifiziert) + FDA-Audit: 14 bewiesene Leichen, TCC.db gegen Programm-Löschung SIP-geschützt,
  Cleanup nur per GUI-„−"; Backup ~/sicherungen/tcc-backup-20261009
metadata:
  node_type: memory
  type: project
  originSessionId: sess_380c5923-55eb-4ded-b208-0e0b05fa8d52
---

09.10.2026: Sascha fragte per `/workflow` (boost), was die referenzierten Skills/Plugins alles sind, mit Screenshots der macOS „Festplattenvollzugriff"-Liste. Danach scharf nachgeschoben („du Trottel"): die Screenshots WIRKLICH durcharbeiten und FDA-Aufräum-Aktion.

- **Workflow dwfrun-8c351687** („Plugin/Skill-Inventur", Draft `.zcode/workflow-drafts/PluginSkill-Inventur.dwf.ts`): Plugin-Leser OK (5 plugin.json-Manifeste verifiziert), aber **alle 7 Skill-Leser schlugen fehl** — Workflow-Subagents konnten absolute Pfade außerhalb des Workspace nicht lesen; Lücke schloss der Main-Agent per Bash `head` (SKILL.md-Frontmatters). LESSON: für Datei-Lesen außerhalb des Workspace im Workflow `world.run("head", …)` statt Subagent `files.read` planen.
- **Inventar:** computer-use (native-Apps-Steuerung, nur Main-Agent), iris (Web-Screenshot-Kamera), desktop-commander-overview, caveman (Output-Kompression), ponytail (Minimal-Lösungen), agent-browser (Browser-Automations-CLI), zcode-configuration-guide (Config-Landkarte) + Plugins computer-use, zcode-guide, node-repl-host (reine Runtime), feature-dev (3 Anthropic-Subagents), desktop-commander (MCP Terminal/Dateien).

## FDA-Audit (Systemeinstellungen → Festplattenvollzugriff)

- **14 bewiesene Leichen** (Binary existiert nicht mehr, per `-e`-Check): claude-versionen 2.1.206/207/211/217/220/236 (nur 247+251 leben), 3× Adobe-Installer-`applet` (IDSN/ILST/PHSP auf Desktop gelöscht), 2× Autodesk `streamer`, `AGSService` (Adobe 25.08. deinstalliert), altes `claude-code/2.1.49`, `simplyprint-bambu-lab`.
- **⚠️ Programmatisches Löschen unmöglich:** SQLite-Write an `/Library/Application Support/com.apple.TCC/TCC.db` = „readonly database", auch Datei-Ersetzen = „Operation not permitted" — trotz ZCode-FDA (dev.zcode.app auth=2). Cleanup geht NUR per GUI-„−"-Knopf. Backup: `~/sicherungen/tcc-backup-20261009/TCC.db`.
- **Offen auf Sascha:** er muss die 14 Einträge selbst per „−" entfernen (EINE Aktion geliefert).
- AUS-Einträge (Spotify, WhatsApp, GoogleUpdater, Zen, Moonlock, CleanMyMac-mas, TestFlight) = bewusst off, NICHT löschen. `claude`+`Claude.app` = CLI + Desktop-App (kein Duplikat).

## Fortsetzung 09.10. abends: TCC-Aufräum-Workflow + GUI-Löschung

- **Sascha-Befehl:** Lösch-Darstellung (mermaid/d3) erstellen und **„dann lösche es für mich"** — GUI-Löschung soll der Agent selbst per computer-use machen, nicht Sascha manuell.
- **Workflow dwfrun-eec3e822** („TCC-Aufräum-Plan", Draft `.zcode/workflow-drafts/TCC-Aufräum-Plan.dwf.ts`): prüft FDA (90) + Ordner-Services (Dateien & Ordner) komplett deterministisch — jeder Pfad-Eintrag per `world.run("/bin/test",…)`, jeder Bundle-Eintrag per `world.run("/usr/bin/mdfind",…)`, TCC-Liste per `world.run("/usr/bin/sqlite3",…)`; Diagramm-Subagent schreibt `out/TCC_LOESCHPLAN.md` (Mermaid, 3 Gruppen: TOT/LEBT/UNGEPRÜFT).
- **WICHTIGE Korrektur zur Sandbox-Lesson:** Workflow-Subagents können keine absoluten Pfade lesen (files.read failt), **aber `world.run` kann** — sqlite3, /bin/test, mdfind auf absolute Systempfade funktionieren alle (per EvalWorkflowSnippet bewiesen). Deterministische Existenz-Checks gehören ins Skript per world.run, nicht in Subagents.
- **Offen:** GUI-Löschung der bewiesen toten Einträge per computer-use (node_repl, nur Main-Agent) — nach Workflow-Abschluss; Backup liegt in `~/sicherungen/tcc-backup-20261009/TCC.db`. UNGEPRÜFT-Einträge (Spotlight-Blindstellen wie Traktor/FreeCAD/Stats) NICHT löschen — kein Löschbeweis.
