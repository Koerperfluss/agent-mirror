---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/loki-workflow-harness.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

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
