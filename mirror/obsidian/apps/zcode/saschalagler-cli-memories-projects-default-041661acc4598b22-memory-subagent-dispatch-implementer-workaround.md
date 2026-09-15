---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/subagent-dispatch-implementer-workaround.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

---
name: subagent-dispatch-implementer-workaround
description: GELÖST 15.09.2026 — Subagent-Fehler "No reasoning level selected" hatte
  seine Wurzel in ~/.zcode/v2/agents-state.json (Alter Fix-Override auf
  zai-start-plan OHNE Denkstufe); Overrides geleert, greift nach App-Neustart
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

**GELÖST am 15.09.2026 (Session sess_89889126):** Root Cause des Fehlers `Cannot start subagent: No reasoning level selected [reason=reasoning-level-missing; selection=account:zai-start-plan/GLM-5.3-Flash]` war NICHT der Plan-Account, sondern ein **alter Override in `~/.zcode/v2/agents-state.json`**:

```json
"builtInModelSelectionOverrides": {
  "Explore": {"providerId": "account:zai-start-plan", "modelId": "GLM-5.3-Flash"},   // ohne options.reasoningLevel!
  "general-purpose": {dito}
}
```

Den Built-in-Agents war früher (App-Settings „Subagents") ein fixes Modell OHNE Denkstufe zugewiesen worden. Der Code (Bundle `zcode.cjs`, Funktion `L8`/`resolveSubagentSelection`) verlangt zwingend `options.reasoningLevel` → Abbruch.

**Fix (15.09., FINALE Version nach Sascha-Korrektur „fixe GLEICH alle"):** Beide Built-ins EXPLIZIT gesetzt — `account:zai-individual-coding-plan/GLM-5.3-Flash` **mit `options.reasoningLevel:"low"`** (Provider+Modell bewiesen durch laufende Session; Backups `agents-state.json.bak2-20260915`). Reparatur-Skript falls App beim Beinen zurückschreibt: **`~/.zcode/fix-subagents.sh`**. Plugin-Agents brauchen nichts (Erbe funktioniert — implementer lief am 14.09.). **WICHTIG: Fix greift erst nach ZCode-Neustart (Bootstrap liest die Datei nur beim Start).**

**How to apply:** Nach App-Neustart Subagent-Test (trivialer general-purpose-Dispatch). Falls wieder FAIL → `implementer` als Workaround (lief am 14.09.). Verwandt: [[ios27-webapp-testing-recherche-2026-09-13]].
