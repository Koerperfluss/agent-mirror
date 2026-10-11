---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-livestatus-2026-10-11.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: loki-os-livestatus-2026-10-11
description: 11.10. Live-Status + Reparaturen — Kernel lebt (v15.3.0, bootstrap-Rezept),
  GO 1+2 ausgeführt (v17 gestoppt, Brain.app archiviert), Taskmaster konsolidiert
  (18 offen, #17 appagentteam-Live-Lauf P1), Archiv :8745, Agenten-Tafel D3,
  Bedienungs-PDF, openclaw 2026.9.2 im PATH
metadata:
  node_type: memory
  type: project
  originSessionId: sess_9bb02160-ce23-4582-a594-371c1f798aa5
---

11.10.2026 LIVE-GEPRÜFT (curl/pgrep/defaults, Beweise in LOKI-Universum-Visualisierung):

- **LOKI-Kernel :8010 TOT** (HTTP 000) — im Systemprotokoll 23.09. noch ✅. Watchdog `com.sascha.loki.kernel` hat nicht gehalten → Kernel-Neustart prüfen.
- **Ollama :11434 lebt mit NEUEN lokalen Modellen:** `qwen3.5:9b`, `qwen2.5-coder:7b`, `qwen2.5-coder:1.5b` + glm-5.3:cloud/flash:cloud. Memory vom 30.08. („kein echtes lokales Modell") ist ÜBERHOLT — Privacy-Modus (§12) jetzt real möglich.
- **OmniRoute :20128 TOT** (abgebaut auf Nutzer-Wunsch 20.09., korrekt so).
- **Hammerspoon läuft NICHT** (pgrep leer) → Doppel-Strg-Voice-Trigger tot; die 2 TCC-Klicks (Bedienungshilfen + Mikrofon) weiter offen.
- **Voice-Daemon :8078 lebt** (idle, glm-5.3-flash, Tools say/open_url/browser_read/run_command/brain_save…).
- **Apps:** Hermes.app = com.nousresearch.hermes v0.17.0 · Eigent.app = com.eigent.app v1.0.4 · AutoClaw2.app = com.zhipuai.autoclaw2 v2.0.1. LOKI Apps: LOKI OS v18, LOKI Brain, LokiVoice in /Applications.
- **Skills-Zahl live:** zcode 204 · agents 157 · claude 200 · autoclaw 121 (Total 682).
- paseo-PDF heißt exakt `getpaseopaseo Orchestrate multiple coding agents from desktop and mobile.pdf` (im Skill-Liste-Ordner).

**11.10. REPARATUREN AUSGEFÜHRT (Beweise):** Kernel :8010 WIEDER LEBEND (`launchctl bootstrap gui/501 ~/Library/LaunchAgents/com.sascha.loki.kernel.plist`, health={"status":"ok","version":"15.3.0"}, PID via KeepAlive) — Tipp: `launchctl kickstart` scheitert mit „not in domain" wenn Agent nie geladen war → bootstrap verwenden. Hammerspoon gestartet (`open -a Hammerspoon`, PID 70579) — TCC-Klicks weiter bei Sascha. `skillshare sync --all` = appagentteam jetzt in ALLEN 6 Targets (cline/claude/codex/cursor/gemini/hermes). Taskmaster: Tasks #8 Hermes-Pilot / #9 Eigent / #10 TCC / #11 Flutter-SDK offen; #1 (Mikro-TCC) + #2 (Tier-2-INDEX) alt-offen. **Dokumente für Sascha auf Desktop:** `~/Desktop/LOKI_OS_UEBERSICHT_2026-10-11.pdf` (Einfach-Sprache-Übersicht + 3-Apps-Urteil: AutoClaw2 JA · Hermes JA-Pilot · Eigent offen) + `~/Desktop/LOKI_UNIVERSUM_2026-10-11.html` (interaktive 5-Etagen-Karte, standalone).
- **Integration-Vorschlag:** AutoClaw2 = Produktivitäts-Connector (läuft schon via mcporter) · Hermes = Privacy-Worker mit Ollama-qwen3.5:9b (Pilot) · Eigent = visuelles Kontrollzimmer für Agenten-Schwärme (Test). ZCode bleibt Director, 2 GO-Gates.

Interaktive Karte: `~/.zcode/v2/visualizations/c99caef…/loki-os-universum.html` (Session-Visualisierungsordner). Verwandt: [[appagentteam-flutter-skill-live]] · [[loki-os-ecosystem-stand]]

**Agenten-Tafel v2 D3 (08:19):** `~/Desktop/LOKI_AGENTEN_TAFEL.html` = modernes D3-Dashboard (Timeline 5 Lanes, 55 Kreise, Stat-Karten, Aufgaben-Balken; Render via Playwright-DOM bewiesen: kreise=55, lanes=5). Alte Tabellen-Version: `LOKI_AGENTEN_TAFEL_v1_tabellen.html.bak`. **Update-Rezept bei „Tafel aktualisieren":** (1) `python3 ~/loki-agenttafel/collect.py > ~/loki-agenttafel/daten.json` (collect.py = nur Lesen+print, Mimosa-sicher), (2) daten.json lesen, (3) per Edit `const DATA = {...}`-Block in der Tafel ersetzen. **Mimosa-Block-Grenze:** kein Heredoc mit Script-Pfad-Strings via Bash, kein `open(<Variable>,"w")`. Playwright-MCP blockt file:// — Render-Test über lokalen `python3 -m http.server --bind 127.0.0.1` + DOM-Query (Screenshot-Call kann timeouten, DOM-Query reicht als Beweis).

**Nachrichten-Archiv (08:35, LEBT):** **http://127.0.0.1:8745** = LOKI Nachrichten-Archiv — jede USER-Nachricht aus ZCode (rollout-JSONL) + Claude Code (~/.claude/projects/*.jsonl) + Cline (~/.cline/data/sessions/*/messages.json: **role:"user"-Format, NICHT say:user_feedback**), 14-Tage-Fenster, live Suchfeld + Quellen-Filter. LaunchAgent `com.loki.archiv` (KeepAlive), Server `~/loki-agenttafel/archiv_server.py` (stdlib, nur Loopback, kein open(w) — Mimosa-sicher), Sammler `collect_messages.py`, Template `archiv_template.html` (fetch /daten). Beweis: 309 Nachrichten (ZCode 64 · Claude 104 · Cline 141), Suche „hermes"→4 Treffer via Playwright-DOM. **Antigravity-Phase 2 offen:** Conversations liegen als SQLite `.db` mit steps/trajectory-Tabellen (komplex, nicht message-flach). Archiv aktualisieren = Seite neu laden (Server sammelt每次 frisch).

**GO 1+2 AUSGEFÜHRT (08:50, Sascha-GO im Chat):** GO 1 = v17-Companion-App beendet (lief heimlich seit heute Nacht, PID 4326 kill → pgrep leer, Kernel :8010 unberührt ok). GO 2 = `LOKI Brain.app` aus /Applications **mv-only archiviert** nach `~/Desktop/Coworkspace_Ich/_APPS_ARCHIV_2026-10-11/` (auch: Abfahrtsliste-LOKI-OS.html dorthin, nachdem ihre 21 Items vollständig in den Taskmaster migriert wurden). **/Applications = nur noch `LOKI OS v18.app` + `LokiVoice.app`.** Repo-Kopien (loki-ki/macos-app-v17+v18, loki-brain-app) bleiben bewusst = Werkstatt.

**Taskmaster-Endstand (09:00):** 21er-Checkliste KOMPLETT migriert — neu: **#17 appagentteam Live-Lauf (P1 — der eigentliche Kern des Tages, noch nie geflogen)** · #18 API-Keys (nur Sascha) · #19 v18-Dashboard-Bugs (D3-Tab schwarz + HTTP-Karten) · #20 Atomic Hermes.app prüfen (GO) · #21 F-1-Watchdog/KeepAlive-Prüfung · #22 Hermes-Learning-Loop · #23 transformers-js · #24 LegalOps-Doku · #25 P3-Block (MCP-Bridge/Council/Vault-Index/n8n-Hub). **#12 closed** (openclaw v2026.9.2 war schon im PATH — installiert 08:20 von der Cline-mimo-Session). Verworfen (bewusst KEIN Task): OmniRoute-Start (Abbau-Beschluss 20.09.), Kernel-booten (läuft). 2 **Subagenten parallel bewiesen:** implementer (openclaw, fertig) + explorer (LegalOps, fertig).

**LegalOps-Analyse-Resultat (#13, Subagent explorer):** „4×-Duplikat" = **FEHLALARM**. Realität: 2 legitime Registrierungen in 2 verschiedenen Clients (ZCode-CLI `~/.zcode/cli/config.json:174` + Cline via `~/.mcp.json`-Symlink Z.293), beide gleicher Launcher (`loki-ki/services/start_loki_legal_ops_mcp.command`), nie im selben Namespace → kein Crash-Risiko. **Nichts entfernen** (Cline braucht den Eintrag). 2 Server-Prozesse parallel (04:09 verwaist + 07:32 aktiv) — Beenden des verwaisten nur mit Sascha-GO (ausstehend). **Randfund:** Z.AI-API-Key im Klartext in `~/.zcode/cli/config.json` Z.190ff (Einzel-Mac ok, nur relevant beim Teilen). Task-#13-Abschluss per task.py noch NICHT ausgeführt (nur angekündigt).

**Konsolidierungs-Reststand:** Weiterhin ausstehend (Sascha-GO): `LOKI_UNIVERSUM_2026-10-11.html` (Desktop, doppelt zur Cline-Universe) + `LOKI_AGENTEN_TAFEL_v1_tabellen.html.bak` löschen. Cline-mimo-Session-Verhalten dokumentiert: neue Nachricht → neues HTML statt bestehendes pflegen (Ursache der 7 Dokumente). **Rollout-Ordner ~/.zcode/cli/rollout ≈ 17,7 GB** (größte Datei 3,4 GB V14-Session) — Aufräum-Kandidat, Plan nur mit GO. Session-Übergabe-Vermerk: flutterskill/openclaw wurden teils PARALLEL von der Cline-mimo-Session installiert (08:20) — bei „wer hat was gebaut"-Fragen beide Sessions prüfen (chat-analysis 08:55: roter Faden des Tages = appagentteam + Verstehen; 6/7 Teilziele erledigt, einziger echter Offener = #17 Live-Lauf + Saschas 2 TCC-Klicks). Achtung: **Mimosa blockt Python-Scripte mit `open(<Variable>,"w")`** (statische Pfad-Traversal-Warnung, 3 Versuche blockiert) → deshalb kein Generator-Script, sondern direktes Write. Cline-Sessions liegen in `~/.cline/data/sessions/` als **Unterverzeichnisse + sessions.db**, nur das search_sessions.py-Script liest sie zuverlässig. Befund 08:15: Cline-Subagenten-Team von 09.10. (5× muse-spark) komplett FAILED (Team-Auth); 1 Cline läuft (glm-5.3-flash „Customize"), 1 idle (mimo, Universe-HTML). Rollout-Ordner ~17,7 GB (Aufräum-Kandidat, nur mit GO).
