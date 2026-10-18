---
name: agent-defs-provider-fix
description: Subagent-Fix 18.10.2026 — alle 10 Agent-Defs in ~/.zcode/agents/
  standen auf totem Provider, laufen jetzt auf aktivem Plan
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d16e9574-8219-4c77-abee-ea5b9a120e96
---

18.10.2026: Subagent-Starts starben mit `provider-not-found: account:zai-start-plan/GLM-5.3-Flash` (alter Plan) bzw. `qwen/qwen3.8-max` (gelöschter Provider 3a11f548…). **GELÖST (gleicher Tag):** alle 10 Defs in `~/.zcode/agents/*.md` (cavecrew-*, code-architect, config-auditor, explore, gate-enforcer-test, implementer, qa-tester, reviewer) von `builtin:zai/GLM-5.3-Flash` auf **`account:zai-individual-coding-plan/GLM-5.3-Flash`** gestellt (= aktiver Plan, via ListModels verifiziert). **Beweis:** cavecrew-investigator Test-Start „AGENT GESTARTET OK" (22 s) — alle 10 Custom-Subagents seither voll nutzbar, kein Built-in-Workaround mehr nötig.

**Why:** Agent-Defs pinnen absolute Provider-IDs — bei Planwechsel/Aufräumen in provider_config.json brechen alle Subagents lautlos.
**How to apply:** Wenn Subagents `provider-not-found` werfen: zuerst `ListModels` (gültige IDs), dann `model:`-Feld in `~/.zcode/agents/*.md` auf aktuellen Plan setzen — NICHT `builtin:zai/…` (API-Key) pinnen, wenn Flatrate-Plan laufen soll. Verwandt: [[loki-os-audit-pipeline]]
