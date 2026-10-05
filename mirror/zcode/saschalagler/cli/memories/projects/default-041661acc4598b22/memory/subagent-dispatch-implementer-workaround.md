---
name: subagent-dispatch-implementer-workaround
description: „No reasoning level selected" — 22.09. DRITTE Wurzel: eigene Agents
  (~/.zcode/agents/*.md) hatten model: ohne thoughtLevel: im Frontmatter → gefixt
  (thoughtLevel eingetragen, fix-subagents.sh erweitert); greift erst nach App-Neustart
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

**✅ 22.09. DRITTE WURZEL GEFUNDEN + GEFIXT (eigene Agents = Markdown-Dateien):** `cavecrew-*`, `implementer`, `qa-tester` etc. aus `~/.zcode/agents/*.md` lasen den Fehler neu, obwohl agents-state.json komplett war. Echte Ursache (im Bundle zcode.cjs rückverfolgt, Funktion `tee`/`parseSubagentMarkdownSelection`): **Frontmatter der Agent-Dateien hatte `model:` ohne `thoughtLevel:`** → effective selection ohne reasoningLevel → `reasoning-level-missing`. Fix: `thoughtLevel: low` (bzw. vorhandene Stufe) in alle 10 Dateien eingetragen (Backups `/tmp/agents-backup-*`); `fix-subagents.sh` erweitert (fügt fehlende thoughtLevel-Zeilen automatisch ein). **WICHTIG: laufende App cacht das Frontmatter → Fix greift erst nach ZCode-Neustart/neuer Session; general-purpose funktioniert derweil weiter.** general-purpose/Explore (built-ins) funktionierten parallel normal — Fehler betrifft NUR eigene Datei-Agents.

**🔁 22.09. Workflow dwfrun-efb4300b („Alle Agents prüfen und reparieren"):** Sascha rief /workflow „ALLE AGENTS SUCHEN PRÜFEN UND REPARIEREN". Topologie: python3-Inventur → 10 Prüfer-Subagents (1 pro Datei) → 1 Reparateur (Backups /tmp/agents-fix-2209/) → python3-Abschluss-Gate + Bericht-Artefakt. Snippet-Test vorab (EvalWorkflowSnippet) zeigte: alle 10 Dateien + 14 Plugin-Agents zu dem Zeitpunkt technisch grün. Schema-Gefunden aus dem Bundle (zcode.cjs): Overrides-Schlüssel `agentModelSelectionOverrides` = `source:scope:name` (createAgentStateId); **`builtInModelSelectionOverrides` mit Plain-Names eigener Agents funktioniert NICHT** (vergeblich getestet); Auswahl eigener Agents steckt IM Frontmatter (`model:` + `thoughtLevel:`, Funktion `tee`/`parseSubagentMarkdownSelection`).

**⚠️ 18.09. RÜCKFALL (Teilweise):** In der großen LokiVoice-Session warfen **`Explore` und `general-purpose` weiterhin „No reasoning level selected / selection=account:zai-start-plan/GLM-5.3-Flash"**, während **`implementer`-Dispatches parallel erfolgreich liefen** (3/3 implementer gestartet, 1 verifiziert geliefert). Der Hook-Fix deckt offenbar nicht alle Agent-Typen/Provider-Kombinationen (Plan-Account `zai-start-plan` statt `individual-coding-plan` im Fehlertext). **Workaround-Kette bewährt:** (1) Task als `implementer` umformulieren (auch für read-only Scans — „nur lesende Befehle"), (2) sonst Director-Direktausführung. Sascha-Seitiger Dauer-Fix: ZCode-Einstellungen → GLM-5.3-Flash → Denkstufe explizit setzen (App-Setting, nicht config.json).

**⚠️ 18.09. SPÄT (2. Beobachtung):** Implementer kann komplette Commits SELBST machen (62c3597 „Add STT and TTS pickers") und Dateien des Directors LÖSCHEN/ÜBERSCHREIBEN (mein LLMProviders.swift wurde durch seine AIProviders.swift ersetzt; seine Abschlus-Reports kamen teils gar nicht als Notification, Arbeit lag aber im Tree). Konsequenz: Nach implementer-Läufen IMMER `git log`/`git status` + Kollisions-Check (Dublett-Module, tote Referenzen) — siehe [[thomas-tasks-drei-recherchen]] Kollisions-Lektion.

**⚠️ 05.10. VIERTE WURZEL (bewiesen, 2× Dispatch-Test):** agents-state.json hatte 16 Overrides auf den toten Provider `omniroute/glm-first` (reasoningLevel max) → „Cannot start subagent: Reasoning level unsupported … selection=omniroute/glm-first". Fix: alle 4 Override-Sektionen geleert (Backup `~/sicherungen/agents-state-20261005/`). **ABER: Auch NACH korrekter Disk-Konfig (Sascha hat via UI auf GLM-5.3-Flash umgestellt, verifiziert per cat) schlägt Dispatch weiter mit omniroute/glm-first fehl — die LAUFENDE App hält die alte Selektion im Speicher.** Einziger Fix = ZCode ⌘Q-Neustart; kein In-Session-Workaround bekannt (implementer-Workaround half diesmal auch nicht, gleicher Fehler). Merksatz: Override-Quelle = agents-state.json + Agent-Frontmatter + App-Speichercache — erst Neustart, dann Dispatch-Test mit 1-Zeilen-Task.

**⚠️ 05.10. 14:05 — DISPATCH-TEST-KARTEN = UI-MÜLL (Sascha wütend):** JEDER fehlgeschlagene Dispatch-Test hinterlässt eine rote „SubAgent · … Failed"-Karte in Saschas ZCode-UI — 3 Tests hintereinander (13:10/13:39/13:50) = 3 rote Karten, er drehte durch („was ist damit du trottel"). **Regel: nie wieder wiederholte Dispatch-Tests — MAXIMAL 1 Test nach einem echten Fix, sonst gar keiner; Karten sind harmlos (nichts läuft/hängt), aber er sieht sie als Müll.** Antworten auf „was ist diese Karte": gescheiterter Startversuch, kein Prozess, keine Kosten.

**✅ 05.10. 14:09 — FALL KOMPLETT GELÖST (Endbeweis):** Sascha hat ZCode neu geöffnet (⌘Q + Neustart) → 1-Zeilen-Test-Dispatch: **„DISPATCH OK — Neustart wirksam"** (general-purpose, 17,5 s). Die Kette ist damit bewiesen: Konfig auf Disk korrigieren (Overrides leeren ODER Sascha stellt im UI um) → **App-Neustart ist der unverzichtbare letzte Schritt** → Dispatch läuft. Danach sofort 2 Hintergrund-Agents gestartet (Fundinventar + Marinus-Nachricht) — liefen sauber. Merksatz final: disk-fix → restart → EIN Test → direkt Teams starten, keine weiteren Einzel-Tests (Karten-Regel oben).

**⚠️ 18.09. (3. Beobachtung):** implementer kann auch silent FERTIG sein und danach weitere Edits machen — TaskOutput „No task found" heißt nicht verloren; Arbeit lag im Tree (git log bewies seinen Picker-Commit). Und: gelöschte Director-Dateien können im Projekt-`_ARCHIV/` liegen (Kollisions-Auflösung des Agenten) — vor Re-Implementierung IMMER erst Archiv/Tree prüfen, sonst baut man Duplikate.
