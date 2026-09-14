---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/subagent-dispatch-implementer-workaround.md"
stand: 2026-09-14
tags: [spiegel, zcode]
---

---
name: subagent-dispatch-implementer-workaround
description: ZCode-Subagent-Fehler "No reasoning level selected" trifft NUR
  Explore/general-purpose (GLM-5.3-Flash ohne Denkstufe im
  zai-start-plan-Account) — der subagent_type "implementer" FUNKTIONIERT; alles
  über implementer routen
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Entdeckt 14.09.2026 (Session sess_0933a442): Der Agent-Dispatch-Fehler `Cannot start subagent: No reasoning level selected [reason=reasoning-level-missing; selection=account:zai-start-plan/GLM-5.3-Flash]` ist **subagent-typ-abhängig**:

| subagent_type | Status |
|---|---|
| `Explore`, `general-purpose` | ❌ FAIL (an GLM-5.3-Flash gebunden, dem im Plan-Account keine Denkstufe zugewiesen ist) |
| `implementer` | ✅ LÄUFT (auch für read-only Bash-Aufträge nutzbar — einfach "nur lesende Befehle" in den Prompt schreiben) |
| `reviewer` | lief am 11.09. noch (vor dem Bug-Auftreten); falls FAIL → gleichfalls implementer nehmen |

`~/.zcode/cli/config.json` enthält KEINE Reasoning-Level-Einstellung — der Fehler sitzt in der ZCode-App, nicht in der CLI-Config. **Dauer-Fix (nur Sascha kann klicken):** ZCode-Einstellungen → Modell GLM-5.3-Flash → Denk-/Reasoning-Stufe setzen. Bis dahin: alle Agenten-Aufträge als `implementer` starten.

**How to apply:** Bei „Cannot start subagent: No reasoning level selected": NICHT aufgeben, NICHT nur Main-Agent-Fallback — denselben Prompt an `subagent_type: implementer` erneut senden. Verwandt: [[ios27-webapp-testing-recherche-2026-09-13]] (Dort noch „Dispatch tot → Direktrecherche"; seit 14.09. der bessere Weg: implementer).
