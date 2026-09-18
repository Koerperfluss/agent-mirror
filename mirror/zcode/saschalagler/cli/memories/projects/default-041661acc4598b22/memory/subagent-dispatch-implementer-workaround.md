---
name: subagent-dispatch-implementer-workaround
description: GELÖST + LIVE BEWIESEN 16.09. — „No reasoning level selected" saß in
  ~/.zcode/v2/agents-state.json; Fix = Explore/general-purpose explizit auf
  GLM-5.3-Flash + reasoningLevel "low" + Reparatur-Skript
  ~/.zcode/fix-subagents.sh; Test-Dispatch lief durch
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

**✅ GELÖST + LIVE BEWIESEN 16.09.:** Test-Dispatch `general-purpose` lief durch („SUBAGENT OK", agent_0ab62252). Fix = in `~/.zcode/v2/agents-state.json` beide Built-ins EXPLIZIT gesetzt: `account:zai-individual-coding-plan/GLM-5.3-Flash` **mit `options.reasoningLevel:"low"`** (Backups `.bak-fix-20260915`/`.bak2-20260915`; Reparatur-Skript `~/.zcode/fix-subagents.sh`). Plugin-Agents erben (implementer lief immer). Historische Ursache: alter App-Override ohne Denkstufe → `L8()`-Pflichtprüfung schlug fehl.

```json
"builtInModelSelectionOverrides": {
  "Explore": {"providerId": "account:zai-start-plan", "modelId": "GLM-5.3-Flash"},   // ohne options.reasoningLevel!
  "general-purpose": {dito}
}
```

Den Built-in-Agents war früher (App-Settings „Subagents") ein fixes Modell OHNE Denkstufe zugewiesen worden. Der Code (Bundle `zcode.cjs`, Funktion `L8`/`resolveSubagentSelection`) verlangt zwingend `options.reasoningLevel` → Abbruch.

**✅ GELÖST + AUTOMATISIERT 16.09.:** Fix sitzt UND heilt sich selbst — **SessionStart-Hook** in `~/.zcode/cli/config.json` (`bash ~/.zcode/fix-subagents.sh --silent`) prüft bei JEDEM Chat-Start die Overrides und repariert still (idempotent, Backup-Rotation max. 5). Live bewiesen: Kaputt-Simulation → Hook → „FIXED" → geheilt; Zweitlauf = „intakt — nichts zu tun". Dispatch-Tests bestanden: „SUBAGENT OK" (general-purpose), „EXPLORE OK" (Explore m. Bash), reviewer 51 s. Kein manueller Notfall-Knopf mehr nötig.

**How to apply:** Nach App-Neustart Subagent-Test (trivialer general-purpose-Dispatch). Falls wieder FAIL → `implementer` als Workaround (lief am 14.09.). Verwandt: [[ios27-webapp-testing-recherche-2026-09-13]].
