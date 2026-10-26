---
name: loki-workflow-harness
description: Wo die LOKI-Workflows
  (roo-code/gsd-core/coderabbit/loki-dev/ponytail/appagentteam) leben und wie
  sie in ZCode genutzt werden
metadata:
  node_type: memory
  type: project
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

LOKI-Workflows sind in **zwei Orten** identisch vorhanden (Stand 26.10.2026): `~/.openclaw-autoclaw/skills/` (AutoClaw-Original) und `~/.claude/skills/` (zentraler Spiegel, von Claude-Code automatisch geladen). ZCode lädt sie NICHT als Slash-Commands — Nutzung in ZCode: SKILL.md lesen + Methodik manuell anwenden (bewiesen: TraktorClone-Bau lief komplett nach loki-dev/gsd-core/coderabbit).

**Warum:** ZCode lädt Skills nur aus `~/.zcode/cli/plugins/cache/`; die LOKI-Ordner sind fremde Harness-Verzeichnisse.
**How to apply:** Bei Bau-Aufträgen: loki-dev BUILD-Gate (SequentialThinking→TodoWrite→PLAN-Tabelle→PLAN.md), Slices à max 2 Dateien (gsd-core), ralph-loop bis grün (max 5 Iter.), coderabbit-4D-Review mit Veto. Subagenten: cavecrew-builder/implementer-Defs laufen auf `account:zai-individual-coding-plan/GLM-5.3-Flash` (Fix 26.10., Backups `.bak-20261026`). Routing-Tabelle: `~/.agents/skill-routing.md`. Siehe [[subagent-provider-fix-zai-api]].

**agent-os (LOKI-OS) Stand 26.10. spät: ALLE Milestones M1–M5 DONE, 210/210 Tests OK** (Beweis: `agent-os/VICTORY_AUDIT.md`; `./bin/agentos status` live: OmniRoute 🟢 23ms, Ollama 🟢, Gemini/Claude 🟢). M2 = `agentos/orchestrator.py` (plan→code→test→done, protokolliert NUR, schreibt bewusst keine Dateien) + `maker.py` (compile()-Validierung, 3× Selbstheilung, audit_code-Gate; Sofort-„done" ohne Sequenz = korrekt fail) + CLI `build --json`. M3 = `commander.py` (ProcessManager PID-Registry, PortMonitor.probe_tcp) + `shell.py` (PersistentShell: echtes PTY pty.openpty, send mit select-Loop, SIGTERM→wait→SIGKILL+Reaping; CLI `process --shell-open/send/close`). M4 = security/ 9 Module + Pre-Commit-Gate im Maker + Post-Build-Strix-Scan in cli.py (außer `--no-security-scan`). M5 = Victory Audit. cavecrew-builder als Team-Builder 3× bewiesen (M2, TraktorClone 7c, PTY-Shell). agent-os weiterhin OHNE Git (kein GO für git init). Nächste agentos-Stufe: Maker-Artefakte in die Pipeline integrieren (echte Datei-Erzeugung).
