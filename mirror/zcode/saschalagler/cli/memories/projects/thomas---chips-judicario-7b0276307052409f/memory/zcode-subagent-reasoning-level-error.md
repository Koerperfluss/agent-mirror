---
name: zcode-subagent-reasoning-level-error
description: Agent-Tool startet Subagenten nicht — „No reasoning level selected"
  bei GLM-5.3-Flash; Lösung direkt selbst ausführen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5b46926c-ea38-4d93-833c-ef981b842fd5
---

Am 22.09.2026 schlug jeder Subagent-Start (z. B. `cavecrew-investigator`) fehl mit: „Cannot start subagent: No reasoning level selected / reasoning-level-missing [account:zai-individual-coding-plan/GLM-5.3-Flash]".

**Why:** Dem Modell fehlt in der Host-Konfiguration ein gewählter Reasoning-Level (Denkstufe) — kein Projektfehler, nichts lokal reparierbar.

**How to apply:** Nicht erneut versuchen, Subagenten über das **Agent-Tool** (subagent_type) zu dispatchen — Untersuchungsschritte direkt mit eigenen Tools ausführen (Bash/Read/Grep). WICHTIG (22.09. nachgetestet): **Subagenten in dynamischen Workflows** (`agent()`-Fassade in CreateWorkflow-Skripten, z. B. „Befund-Analyst", „Konfigurations-Analyst") laufen problemlos — nur der direkte Agent-Tool-Dispatch ist betroffen. Wenn Sascha in der Z.ai-/Host-Konfiguration eine Denkstufe wählt, sollten auch Agent-Tool-Dispatches wieder starten — vorher mit 1 Test-Dispatch prüfen.
