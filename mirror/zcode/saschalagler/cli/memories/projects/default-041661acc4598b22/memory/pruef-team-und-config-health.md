---
name: pruef-team-und-config-health
description: 13.09. Prüf-/Test-Agent-Team (10 Agents + pruef-team-Dispatcher)
  gebaut, Cap „max 3 Agents" auf Saschas Befehl ENTFERNT, config-health.py
  Selbstcheck hängt jetzt als SessionStart-Hook in ZCode
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

**Stand 13.09.2026 abends:**

1. **Cap „max 3 Agents" = ENTFERNT** (Sascha: „weg damit"): loki-watcher.py aus PreToolUse in config.json raus + Backup `config.json.bak-cap-entfernt-20260913` + `/tmp/loki-agent-count.json` gelöscht. Parallelität = so viele wie der Task braucht.

2. **Prüf-Team (10 Agenten):** in `~/.zcode/agents/` — neu: `qa-tester` (Funktionstest mit Beweisen), `config-auditor` (Settings wirklich aktiv? Log-Beweis-Pflicht), `gate-auditor` (Disziplin-Audit mit VETO). Vorhanden: reviewer, code-architect, explore, implementer, 3× cavecrew. **Dispatcher-Skill:** `~/.agents/skills/pruef-team/SKILL.md` — klassifiziert, dispatcht 2–3 Prüfer parallel, aggregiert zu Urteil; VETO = Re-Prüfung Pflicht; „Wer gebaut hat, prüft nicht".

3. **Verankerung:** pruef-team steht in `~/.zcode/AGENTS.md` Routing-Tabelle + F-Kapitel (Verifikation = Prüf-Team-PASS, mind. 2 Prüfer, @gate-auditor immer dabei) → jeder neue Chat kennt es automatisch.

4. **Selbst-Check als Gedächtnis:** `~/.agents/tools/config-health.py` (SessionStart-Hook in config.json) prüft bei JEDEM neuen Chat die 6 Schaltstellen (config valide, AGENTS.md vollständig, gate-enforcer feuert wirklich, Agents/Commands da, Kontext-Dateien da) und INJIZIERT Warnung wenn kaputt — stille Config-Korruption (Fall 06.09.–13.09., 127 Warnungen) kann nie wieder unbemerkt bleiben.

**Lektion (Nie-wieder-Regeln):** (a) Settings niemals „aktiv" nennen ohne Funktionstest + Log-Beweis — Datei-Existenz ist kein Beweis (dafür: [[zcode-adhs-automationen]] Root-Cause). (b) Session lädt Config nur beim Prozessstart — Fix NACH Start wirkt erst im NEUEN Chat; SASCHAS Beschwerde „Settings funktionieren nichtmal hier mit dir" war exakt das: laufende Session (16:29) predates Fix (16:35), sie lädt nie neu. (c) Nach jedem Config-Edit: sofort `config-health.py` laufen lassen.

**Spät 13.09. Ergänzungen:** (d) „Wieso ist der Skill weg"-Panik (wayfinder/teach//standardskill/sequentialthinking) — FAKT: nichts weg, alle Dateien auf Disk ✓; Ursache = alte Session-Caches. Commands (z. B. /standardskill) sind ein ANDERER Namespace als Skills (Skill-Tool sagt „not found" für Commands — normal). (e) Als Antwort auf „zeig mir den gesamten Plan": Gesamt-Bau-Liste mit 11 Bausteinen geliefert (Config-Heilung, AGENTS.md 63 Z., Gate-Hook, Cap-Entfernung, 10 Prüf-Agents, pruef-team-Dispatcher, config-health, 612-Chat-Import + 11 Gruppen, Legal-Ops 6→1 App, FörderOps+LaunchAgent, 3 Memory-Einträge).

Verwandt: [[zcode-adhs-automationen]] · [[zcode-projektgruppen-mechanik]]

7. **BEWEIS-STAND ehrlich klassifiziert (Sascha: „wie kannst du sicher sein dass der drecks irgendwas bedient?"):** Alle ✅-Berichte waren Disk-Beweise (Datei da, Format stimmt, Skript manuell gelaufen), KEINE Live-Funktions-Beweise in einem echten Chat. Dafür gebaut: **Command `/systemproof`** (`~/.zcode/commands/systemproof.md`) — 6 Live-Checks (Regeln im Kontext? Gate-Injektion sichtbar? sequentialthinking antwortet? @cavecrew-investigator antwortet? Commands/Skills-Dateien da?) → URTEIL SYSTEM AKTIV / TEILWEISE / TOT. AGENTS-Format der neuen Agents (@qa-tester etc.) 1:1 vom bewiesen funktionierenden @cavecrew-reviewer kopiert. AUSSTEHEND: Sascha führt /systemproof in einem NEUEN Chat aus — erst dann ist „System aktiv" bewiesen, nicht davor behaupten.

6. **GLOBALE REGEL-VERKABELUNG 13.09. spät abgeschlossen (Sascha-Ziel: ALLE Mac-Apps konfiguriert):** `~/.agents/tools/sync-standard-skills.sh` TARGETS = jetzt ALLE 5 Harnesses (Cline, Gemini, Hermes + NEU: ZCode `~/.zcode/AGENTS.md`, Claude `~/.claude/CLAUDE.md`). 1 Quelle = `~/.agents/STANDARD-SKILLS.md` über Marker STANDARD-SKILLS:START/END; ZCode behält DAUER-PROMPT (Hoheit/Deutsch/ADHS/Beweis) + kanonischen Block darunter. Verifiziert: 5/5 Dateien mit Marker. Gate-Hooks bestätigt in Cline Code + Claude (06.09.) und ZCode (13.09. gefixt); AutoClaw hat loki-dev-Kopie; agent-os/orchestrator.py vorhanden. Künftig: 1 Sync-Lauf = alle 5 aktuell.
