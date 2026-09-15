---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/subagent-dispatch-implementer-workaround.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

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

**Fix (15.09., FINALE Version nach Sascha-Korrektur „fixe GLEICH alle"):** Beide Built-ins EXPLIZIT gesetzt — `account:zai-individual-coding-plan/GLM-5.3-Flash` **mit `options.reasoningLevel:"low"`** (Provider+Modell bewiesen durch laufende Session; Backups `agents-state.json.bak2-20260915`). Reparatur-Skript falls App beim Beinen zurückschreibt: **`~/.zcode/fix-subagents.sh`**. Plugin-Agents brauchen nichts (Erbe funktioniert — implementer lief am 14.09.). **WICHTIG: Fix greift erst nach ZCode-Neustart (Bootstrap liest die Datei nur beim Start).**

**How to apply:** Nach App-Neustart Subagent-Test (trivialer general-purpose-Dispatch). Falls wieder FAIL → `implementer` als Workaround (lief am 14.09.). Verwandt: [[ios27-webapp-testing-recherche-2026-09-13]].
