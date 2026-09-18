---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/subagent-dispatch-implementer-workaround.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: subagent-dispatch-implementer-workaround
description: „No reasoning level selected" — Hook-Fix (~/.zcode/fix-subagents.sh)
  deckt implementer ab, aber 18.09. warfen Explore/general-purpose WEITERHIN den Fehler;
  Workaround: alles über implementer-Type routen oder Director-direct
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

**⚠️ 18.09. RÜCKFALL (Teilweise):** In der großen LokiVoice-Session warfen **`Explore` und `general-purpose` weiterhin „No reasoning level selected / selection=account:zai-start-plan/GLM-5.3-Flash"**, während **`implementer`-Dispatches parallel erfolgreich liefen** (3/3 implementer gestartet, 1 verifiziert geliefert). Der Hook-Fix deckt offenbar nicht alle Agent-Typen/Provider-Kombinationen (Plan-Account `zai-start-plan` statt `individual-coding-plan` im Fehlertext). **Workaround-Kette bewährt:** (1) Task als `implementer` umformulieren (auch für read-only Scans — „nur lesende Befehle"), (2) sonst Director-Direktausführung. Sascha-Seitiger Dauer-Fix: ZCode-Einstellungen → GLM-5.3-Flash → Denkstufe explizit setzen (App-Setting, nicht config.json).

**⚠️ 18.09. SPÄT (2. Beobachtung):** Implementer kann komplette Commits SELBST machen (62c3597 „Add STT and TTS pickers") und Dateien des Directors LÖSCHEN/ÜBERSCHREIBEN (mein LLMProviders.swift wurde durch seine AIProviders.swift ersetzt; seine Abschlus-Reports kamen teils gar nicht als Notification, Arbeit lag aber im Tree). Konsequenz: Nach implementer-Läufen IMMER `git log`/`git status` + Kollisions-Check (Dublett-Module, tote Referenzen) — siehe [[thomas-tasks-drei-recherchen]] Kollisions-Lektion.

**⚠️ 18.09. (3. Beobachtung):** implementer kann auch silent FERTIG sein und danach weitere Edits machen — TaskOutput „No task found" heißt nicht verloren; Arbeit lag im Tree (git log bewies seinen Picker-Commit). Und: gelöschte Director-Dateien können im Projekt-`_ARCHIV/` liegen (Kollisions-Auflösung des Agenten) — vor Re-Implementierung IMMER erst Archiv/Tree prüfen, sonst baut man Duplikate.
