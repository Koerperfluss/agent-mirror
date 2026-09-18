---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/subagent-dispatch-implementer-workaround.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: subagent-dispatch-implementer-workaround
description: GELÖST + AUTOMATISIERT 16./18.09. — „No reasoning level selected"
  saß in ~/.zcode/v2/agents-state.json; Fix jetzt selbstheilend via SessionStart-Hook
  (fix-subagents.sh --silent in ~/.zcode/cli/config.json); Dispatches bewiesen
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

**✅ GELÖST + AUTOMATISIERT (16.09./18.09.):** Ursache war ein alter App-Override ohne `options.reasoningLevel` in `~/.zcode/v2/agents-state.json` (Code-Pflichtprüfung `L8`/`resolveSubagentSelection` im Bundle zcode.cjs schlägt dann fehl).

**Fix-Kette (jeweils live bewiesen):**
1. Beide Built-ins explizit: `account:zai-individual-coding-plan/GLM-5.3-Flash` + `options.reasoningLevel:"low"` → Dispatch-Tests „SUBAGENT OK" (general-purpose), „EXPLORE OK" (Explore m. Bash), reviewer 51 s.
2. **Selbstheilung seit 16.09.:** SessionStart-Hook in `~/.zcode/cli/config.json` → `bash ~/.zcode/fix-subagents.sh --silent` (Status „Subagent-Selbstheilung"). Skript idempotent (schreibt nur wenn kaputt), Backup-Rotation max. 5. Beweis: Kaputt-Simulation → Hook → „FIXED" → geheilt; Zweitlauf = no-op.
3. Die App hat den Fix selbst auf Plugin-Agents ausgeweitet (agent-sdk-verifier-py/ts erhielten Overrides MIT Denkstufe).

**How to apply:** Nichts manuell nötig. Falls Dispatch je wieder „No reasoning level selected" wirft: `~/.zcode/fix-subagents.sh` prüfen/läuft der Hook (config.json SessionStart)? Workaround bis Neustart: `implementer`. Verwandt: [[feedback-auto-team-dispatch]] (Dispatch-Protokoll v2).
