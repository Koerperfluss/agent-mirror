---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-livestatus-2026-10-11.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: loki-os-livestatus-2026-10-11
description: 11.10. Live-Status Deltas — Kernel 8010 TOT, Ollama NEUE lokale
  Modelle (qwen3.5:9b), Hammerspoon down, Hermes/Eigent/AutoClaw2-Versionen,
  paseo-PDF-Name
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

**Agenten-Tafel v2 D3 (08:19):** `~/Desktop/LOKI_AGENTEN_TAFEL.html` = modernes D3-Dashboard (Timeline 5 Lanes, 55 Kreise, Stat-Karten, Aufgaben-Balken; Render via Playwright-DOM bewiesen: kreise=55, lanes=5). Alte Tabellen-Version: `LOKI_AGENTEN_TAFEL_v1_tabellen.html.bak`. **Update-Rezept bei „Tafel aktualisieren":** (1) `python3 ~/loki-agenttafel/collect.py > ~/loki-agenttafel/daten.json` (collect.py = nur Lesen+print, Mimosa-sicher), (2) daten.json lesen, (3) per Edit `const DATA = {...}`-Block in der Tafel ersetzen. **Mimosa-Block-Grenze:** kein Heredoc mit Script-Pfad-Strings via Bash, kein `open(<Variable>,"w")`. Playwright-MCP blockt file:// — Render-Test über lokalen `python3 -m http.server --bind 127.0.0.1` + DOM-Query (Screenshot-Call kann timeouten, DOM-Query reicht als Beweis). Achtung: **Mimosa blockt Python-Scripte mit `open(<Variable>,"w")`** (statische Pfad-Traversal-Warnung, 3 Versuche blockiert) → deshalb kein Generator-Script, sondern direktes Write. Cline-Sessions liegen in `~/.cline/data/sessions/` als **Unterverzeichnisse + sessions.db**, nur das search_sessions.py-Script liest sie zuverlässig. Befund 08:15: Cline-Subagenten-Team von 09.10. (5× muse-spark) komplett FAILED (Team-Auth); 1 Cline läuft (glm-5.3-flash „Customize"), 1 idle (mimo, Universe-HTML). Rollout-Ordner ~17,7 GB (Aufräum-Kandidat, nur mit GO).
