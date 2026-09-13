---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/pruef-team-und-config-health.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

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

**Lektion (Nie-wieder-Regeln):** (a) Settings niemals „aktiv" nennen ohne Funktionstest + Log-Beweis — Datei-Existenz ist kein Beweis (dafür: [[zcode-adhs-automationen]] Root-Cause). (b) Session lädt Config nur beim Prozessstart — Fix NACH Start wirkt erst im NEUEN Chat. (c) Nach jedem Config-Edit: sofort `config-health.py` laufen lassen.

Verwandt: [[zcode-adhs-automationen]] · [[zcode-projektgruppen-mechanik]]
