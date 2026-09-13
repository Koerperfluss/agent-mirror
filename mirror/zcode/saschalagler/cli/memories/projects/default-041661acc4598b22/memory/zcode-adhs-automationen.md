---
name: zcode-adhs-automationen
description: Saschas Tages-Routine 13.09. — Morgen-Brief-Automation LIVE (native
  ZCode-Automations), Abend-Logbuch wartet auf neuen Chat (1 Task/Chat-Limit), KEINE
  Web-UI, Logbuch im globalen Memory, verifizierter Architekten-Bauplan für Engine
metadata:
  node_type: memory
  type: project
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

**Stand 13.09.2026 spät (Morgen-Brief live, Engine geblockt durch Plan-Mode-Ablehnungen, Bauplan komplett verifiziert):**

**✅ ERLEDIGT 13.09.:**
1. **`~/.zcode/AGENTS.md` ANGELEGT** (Dauer-Prompt, wie GEMINI.md bei Antigravity): Entscheidungs-Hoheit (Produkt/UI entscheidet Sascha), nur Deutsch, ADHS-Format, Beweis-Pflicht. **19:45 ERWEITERT (diese Session):** + LOKI-Standard-Block (Caveman/ADHS/Sequential, Skill-Routing-Tabelle, Orchestrierungs-Gate Schnitt-0, 5 Stopp-Regeln, Session-Start-Pflicht LOKI_SESSION_CONTEXT+PROJECT_MAP, Verifikations-Pflicht, GLM-Betrieb) — 63 Zeilen, Quelle kanonisch ~/.agents/STANDARD-SKILLS.md.
1b. **ROOT CAUSE „jeder neue Chat dumm" GEFIXT:** `~/.zcode/cli/config.json` war seit 06.09. UNGÜLTIG (leerer `matcher: ""` im UserPromptSubmit-Gate-Hook → 127× `config_file_invalid` pro Tag → ZCode lud GESAMTE User-Config nicht: keine Hooks, kein SessionStart, keine MCPs). Fix: leerer matcher-Key entfernt, JSON valide, gate-enforcer live getestet (Trigger feuert, Fragen stumm). Wirkt nach ⌘Q-Neustart.
2. **Morgen-Brief-Automation LEBT** (native ZCode-Automations, ID `automation-d3f486f6-0509-4176-8459-be13ad3b4282`, cron `0 9 * * 1-5`, nächste Ausführung Mo 09:00): liest Logbuch + MASTER_TODO + SESSION_CONTEXT + daily_sweep → max. 5 Bullets → Logbuch-Datei + Kalender-Event „Tagesplan" via osascript.
3. asar nur nach /tmp/zcode_asar entpackt — **NICHTS gepatcht, App unangetastet** (Nutzer-STOPP; Deutsch-UI-Patch pausiert, siehe [[zcode-app-german-ui-patch]]).

**⚠️ OFFEN (Stand spät 13.09.):** Abend-Zusammenfassung scheiterte an **ZCode-Limit: 1 Scheduled Task pro Chat** → NEUER Chat nötig (cron `30 21 * * *`, Sicherheitsnetz: nur schreiben wenn Logbuch heute fehlt). **Engine noch NICHT gebaut** (daily_sweep.py, Logbuch-Ordner, assi brief/feierabend, Hook, /feierabend-Command). **Plan-Mode-Deadlock:** ExitPlanMode 4× „Permission denied", Nutzer-Verbal-GO im AskUserQuestion („Freigeben — bau fertig") hebt den Plan-Modus NICHT auf — nur der manuelle Modus-Umschalter am Eingabefeld (Plan → **Accept Edits/Execute**) + „go". Beim nächsten GO: direkt den Architekten-Bauplan unten exekutieren (daily_sweep.py-Code steht komplett im Session-Verlauf, fertig zum Schreiben). Nutzer verlangte außerdem: **ALLE installierten ZCode-Subagenten in die Pipeline einbeziehen** (code-architect/explore/implementer/reviewer, Agent Sdk Dev, Agentforce Adlc, Feature Dev, general-purpose, Max Explore; max 3 parallel). /standardskill wurde erneut gebootet und als Regel-Tabelle bestätigt.

**🛠️ VERIFIZIERTER BAUPLAN (Architekt-Subagent agent_887acee0, 13.09., vollständiger Code im Session-Verlauf):**
- **assi-Kollision:** `~/loki-assistent/assi` Zeile 17 mappt `"brief"` bereits auf `status` → Alias auf `("--brief",)` ändern + CMD-Dict um `"brief": "brief.py", "feierabend": "evening.py"` erweitern.
- **Hooks Merged (verifiziert):** config.json hat bereits `hooks.enabled: true` mit SessionStart-Array (2 Objekte OHNE matcher: obsidian load_vault_context.py + projects.py --hook) → neue Gruppe `{"matcher":"startup","hooks":[{"type":"command","command":"python3 ~/loki-assistent/assi brief --hook","enabled":true,"timeout":30}]}` ANHÄNGEN (idempotent per command-String-Check, Backup vorher, nie whole-file-Replace). Hook-Vertrag: `brief.py --hook` printet EINE Zeile `{"additionalContext": "<md>"}`, **immer Exit 0** (Start nie blockieren).
- **Sweep-Datenpfade (korrigeret/architekt-verifiziert):** Antigravity = `~/.gemini/antigravity/brain/<uuid>/.system_generated/logs/transcript.jsonl` (+ conversations/*.db) — `~/.gemini/tmp` nur litert-Logs! AutoClaw = `~/.openclaw-autoclaw/agents/*/sessions/*.jsonl` + `cron/jobs.json`. Cline = `~/.cline/data/sessions/*/*.messages.json` + `cache/user_input_history.jsonl` (JSON, kein DB-Zwang). ZCode-Rollout-Zeilen: `{"completedAt","request":{"body":{"messages":[...]}}}` — User-Prompts in `request.body.messages[]` role=user; Dateien bis 3 MB Token → mtime-Filter + Abbruch nach erstem Prompt. claude-mem: generisches Schema-Discovery (created_at+content-artige Spalte) via `file:...?mode=ro`.
- **Logbuch-Schreibregeln:** append-only, alles ab `## ✍️ Meine Notizen` = tabu (Parser stoppt an dieser Überschrift), Frontmatter handgeformt (kein PyYAML), status nur via feierabend auf „abgeschlossen".
- Risiken-Tabelle (8 Items) im Bauplan: mtime-Filter vor Parse (Timeout), WAL-Locks → try/except „(keine Daten)", git-subprocess mit timeout 10.

**Design-Entscheidungen (verbindlich):**
- **KEINE Web-UI** — Oberfläche = **Kalender am Mac + ZCode-Chat**. Siehe [[feedback-entscheidungshoheit]].
- Logbuch = **globales System-Memory `~/.agents/memory/logbuch/`** (1 Datei/Tag, Abschnitt pro Projekt, Tool-Tags [ZCode]/[Cline]/[Antigravity]/[AutoClaw], Status-Emoji ✅🔨⏳).
- **Nur 4 Tools als Quellen** (+ claude-mem, Git, LOKI-Dateien). Kalender via **AppleScript → Kalender.app** (Zielkalender zur Laufzeit ermitteln), NICHT AutoClaw-Connector.
- **Eigent = entschieden NICHT jetzt** (ZCode-Automations Primär; Eigent offiziell GLM-Plan-kompatibel, Gratis-BYOK-Tier, hat Automations/Memory/WhatsApp-Fernbedienung — Phase-3-Experiment falls gewünscht).

**Infrastruktur-Fakten 13.09.:**
- ZCode **Automations-Panel** (Sidebar → Automations) = natives UI (4 Templates, Idle-time-Tab) — genau daher sein ursprüngliches Template.
- ZCode-Subagenten-Status 13.09.: **code-architect LÄUFT** (lieferte 104k-Token-Bauplan), explore/reviewer = „Model request failed" (transient) bzw. „Model provider is not configured: builtin:zai-coding-plan" → bei Failure selbst ausführen (LOKI-Regel 9).
- `@agentforce-adlc:adlc-orchestrator` = installierter **Agentforce-Plugin-Subagent** in ZCode (adlc-author/engineer/orchestrator/qa) — nicht Teil der LOKI-Pipeline.
- `~/loki-assistent/assi` + LaunchAgent `com.sascha.assi.daily` (08:00, nur System-Health-Brief) existieren — Wiederverwendungs-Basis.
- Plan-Mode-Sandbox blockt teils unschuldige Befehle (sqlite3, python3 -c, npx, mcporter) — Read-only-Ausweichwege nutzen.

**Phase 2 (auf GO):** die 4 Template-Automations (Dev-Brief Mo–Fr 09:00, Risiko-Scan 10:00, Release-Brief Fr 16:00, Doku-Sync Mi 15:00) via CronCreate.
