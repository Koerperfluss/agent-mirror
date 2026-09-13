---
name: loki-dev-gate-enforcement
description: loki-dev = EINE Fullstack-Pipeline (5 Modi) mit erzwungenem
  Orchestrierungs-Gate (Schnitt 0) — Skills konsolidiert 06.09., Gate per
  UserPromptSubmit-Hook in ZCode/Cline/Claude erzwungen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

**loki-dev-Pipeline (06.09.2026 konsolidiert):** Master `~/.agents/skills/loki-dev/SKILL.md`, 5 Modi — INIT (neues Projekt) · BUILD (Director, 8 Schritte) · TAKEOVER (SSD-Scan→Memory-Sweep→STATE.md) · FINISH (Audit→Tests→Review) · MAP (→wayfinder). Alte Skills sind 3-Zeilen-Wrapper darauf: glm-init, glm-build, deve, lokiomnidevteam-plan, lokiomnidevteam-execute (Backups `SKILL.md.bak-20260906` in AutoClaw). Routing in STANDARD-SKILLS.md zeigt auf loki-dev; verdrahtet in allen 5 Harnesses (Symlinks) + AutoClaw (Kopie).

**Schnitt-0-Orchestrierungs-Gate (Pflicht vor jedem Modus):** sequentialthinking-Zerlegung → TodoWrite SOFORT → PLAN-Tabelle im Chat (Stufe|Agent|Skill|Modell|~Tokens|~Zeit|Dep) → PLAN.md ins Projekt (persistent, Fortschritt live). Grund: Saschas berechtigter Vorwurf „Plan nie sichtbar, dutzendfach gefordert" — Skills sind passiver Text ohne Enforcement; TodoWrite stirbt mit der Session.

**Erzwingung:** `~/.agents/tools/gate-enforcer.py` als UserPromptSubmit-Hook registriert in ZCode (`config.json`→hooks.events), Cline (`~/.cline/hooks/settings.json`), Claude (`~/.claude/settings.json`). Trigger-Regex (baue/erstelle/mach mir/übernimm/onboard/fertig mach/projekt init) injiziert 🚦-Gate; ANTI-Regex hält Fragen („was ist…") stumm. Unit-getestet. Backups `*.bak-gate-20260906`. **Hooks greifen erst nach App-Neustart** (ZCode/Cline/Claude je 1× neu starten).

**Parallelität (Regel geändert auf Saschas Wunsch):** bedarfsberechnet aus Task-Graph (unabhängige Tasks = Parallelitätsgrad), Budget-Default 3 mit 1-Zeilen-Begründung bei mehr — „3" ist Quota-Schutz ([[zai-coding-plan-limits]], 16-GB-Mac), kein Dogma.

**Neustarts ausgeführt 06.09. spät:** Cline Code + Claude + ZCode (16:16, inkl. Restart-Kette) — Hooks damit geladen. Der ZCode-Restart-sqlite-Fix der Kette war gegen die FALSCHE Spalte (session-Tabelle hat keine `model`-Spalte; die zai-start-plan-Leiche steckt im App-Cache, nicht in db.sqlite) — fürs Wiki-Feature bleibt UI-Modellwahl der Fix, Details [[zcode-setup-verified]].

**13.09.2026 — KRITISCHE DIAGNOSE-LESSEN („Einstellungen nicht aktiv"):** Ein LEERER `matcher: ""` in `hooks.events.UserPromptSubmit` macht die gesamte `~/.zcode/cli/config.json` schema-invalid (Zod: matcher braucht ≥1 Zeichen) → ZCode verwirft beim Laden die **komplette** User-Config (alle Hooks + alle 16 MCP-Server!), im CLI-Log `~/.zcode/cli/log/zcode-YYYY-MM-DD.jsonl` steht `config_file_invalid`. Fix: matcher-Key einfach weglassen (fehlt er, matcht der Hook alles). Diagnose-Weg: Hook-Skript manuell pipen (`echo '{"prompt":"baue x"}' | python3 gate-enforcer.py`) → wenn Skript OK, Log nach config.file.invalid greppen. Nicht verwechseln: UI-Meldung „Partial assistant output was discarded before a streaming retry (hydrate-trace)" = transientes Provider-Streaming-Retry, kein Config-Problem.

**Full-Stack-Kette (Stand 08.09.2026, nach Skill-Konsolidierung 126→96, [[skills-architektur-2026-09-07]]):** Trigger „baue X" → gate-enforcer zwingt PLAN → skill-router wählt Teil-Skills → **Standard-Agents in `~/.zcode/agents/`: @code-architect (plant, kein Prod-Code) → @explore (read-only Scout) → @implementer (1 Stufe, Commit-Pflicht) → @reviewer (karpathy/ponytail-Review)** — @implementer-Spawns hart auf max 3 gekappt durch `~/.agents/tools/loki-watcher.py` (PreToolUse-Hook „Task|Agent", Exit-2-Block, Zähler /tmp/loki-agent-count.json). Vor-/Qualitäts-Skills: design-an-interface → prototype · tdd · code-review · qa · triage · to-spec/to-tickets (bleiben EINZELN — Prüfinstanz strich die Meta-Verschmelzung „work-flow": triage 28 KB State-Machine, Verlustrisiko > Nutzen) · ui-ux-tester. Deploy: deploy-to-vercel. Für „/implement"-Referenzen in ask-matt u. a. steht loki-dev Modus BUILD (ehem. implement-Skill archiviert).

Verwandt: [[autoclaw-full-stack-builder]] [[sequential-thinking-always]] [[skill-install-conventions]]
